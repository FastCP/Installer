#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
File name: fastcp-updater.py
Author: Rehmat Alam (contact@rehmat.works)
Date created: 8/22/2021
Date last modified: 8/22/2021
Python Version: 3.9
"""

import os
import shutil
from subprocess import (
    STDOUT, Popen, DEVNULL, PIPE, check_call, CalledProcessError
)
import zipfile
import requests

# Define some needed global vars
FASTCP_ROOT = '/etc/fastcp'
FASTCP_APP_ROOT = os.path.join(FASTCP_ROOT, 'fastcp')
FASTCP_VENV_ROOT = os.path.join(FASTCP_ROOT, 'venv')
FASTCP_EXTRACTED_PATH = os.path.join(FASTCP_ROOT, 'fastcp-master')
FASTCP_SERVICE_PATH = '/etc/systemd/system/fastcp.service'
FASTCP_PACKAGE_URL = 'https://cdn.fastcp.org/file/fastcp/latest.zip'
FASTCP_ZIP_ROOT = os.path.join(FASTCP_ROOT, 'fastcp.zip')
FASTCP_CRUCIAL_FILES = ['db.sqlite3', 'run-crons.sh', 'vars.ini', 'vars.sh']
FASTCP_UPGRADER_LOG_FILE = os.path.join(os.getcwd(), 'fcp-upgrader-error-log.txt')


class FastcpUpdater(object):
    """FastCP Updater.

    This is the updater class for FastCP control panel (https://fastcp.org). This class attempts to update
    an installation of FastCP to the latest available version.
    """

    def print_text(self, text: str, color: str = '', bold: bool = False) -> None:
        """Print text.

        Prints a colorful text. The color codes used below are obtained from the StackOverflow answer https://stackoverflow.com/questions/287871/how-to-print-colored-text-to-the-terminal.

        Args:
            text (str): The text to print to the terminal using print() function
            color (str): The color to use for the text. based on message type. It can be success, warning, or error.
        """
        OKGREEN = '\033[92m'
        WARNING = '\033[93m'
        FAIL = '\033[91m'
        OKBLUE = '\033[94m'
        BOLD = '\033[1m'
        ENDC = '\033[0m'

        text = f'==> {text}'
        if bold:
            text = f'{BOLD}{text}{ENDC}'

        if color and color in ['success', 'warning', 'info', 'error']:
            if color == 'success':
                text = f'{OKGREEN}{text}{ENDC}'
            elif color == 'warning':
                text = f'{WARNING}{text}{ENDC}'
            elif color == 'error':
                text = f'{FAIL}{text}{ENDC}'
            elif color == 'info':
                text = f'{OKBLUE}{text}{ENDC}'
        print(text)

    def is_installed(self) -> bool:
        """FastCP is installed.

        Ensure that FastCP is installed. This method checks for the presence of several paths before
        making the decition.

        Returns:
            bool: True if FastCP is installed, False otherwise.
        """
        return all([os.path.exists(path) for path in [FASTCP_APP_ROOT, FASTCP_VENV_ROOT, FASTCP_SERVICE_PATH]])


    def run_cmd(self, cmd: str, shell=False) -> bool:
        """Runs a shell command.
        Runs a shell command using subprocess.

        Args:
            cmd (str): The shell command to run.
            shell (bool): Defines either shell should be set to True or False.

        Returns:
            bool: Returns True on success and False otherwise
        """
        try:
            if not shell:
                check_call(cmd.split(' '),
                        stdout=DEVNULL, stderr=STDOUT, timeout=300)
            else:
                Popen(cmd, stdin=PIPE, stdout=DEVNULL,
                    stderr=STDOUT, shell=True).wait()
            return True
        except CalledProcessError:
            return False

    def do_upgrade(self) -> bool:
        """Upgrade FastCP.

        This method upgrades FastCP by downloading the latest ZIP package, extracting it, by backing up the database, upgrading the code,
        by restoring the database and by running any migrations if added. It also installs new dependencies too.

        Returns:
            bool: True on success False otherwise.
        """

        try:
            self.print_text('Creating backup of FastCP data.')
            # Copy the database & env vars
            for f in FASTCP_CRUCIAL_FILES:
                shutil.copy(os.path.join(FASTCP_APP_ROOT, f), FASTCP_ROOT)

            # Delete existing installations
            shutil.rmtree(FASTCP_APP_ROOT)

            self.print_text('Downloading FastCP latest source code.')

            # Download latest code
            with requests.get(FASTCP_PACKAGE_URL, stream=True) as r:
                with open(FASTCP_ZIP_ROOT, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=1024*1024):
                        f.write(chunk)

            # Unzip the package
            self.print_text(f'Extracting FastCP source code zip package.')
            with zipfile.ZipFile(FASTCP_ZIP_ROOT, 'r') as zip_ref:
                zip_ref.extractall(FASTCP_ROOT)

            # Rename FastCP extracted directory
            self.print_text('Completing FasatCP upgrade.')
            if os.path.exists(FASTCP_EXTRACTED_PATH):
                os.rename(FASTCP_EXTRACTED_PATH, FASTCP_APP_ROOT)


            # Install requirements
            self.print_text('Installing FastCP dependencies.')
            self.run_cmd(f'{FASTCP_VENV_ROOT}/bin/python -m pip install -r {FASTCP_APP_ROOT}/requirements.txt')

            # Delete archive
            if os.path.exists(FASTCP_ZIP_ROOT):
                os.remove(FASTCP_ZIP_ROOT)

            self.print_text('Restoring FastCP data.')
            for f in FASTCP_CRUCIAL_FILES:
                # Delete if files exist in app root
                full_path = os.path.join(FASTCP_APP_ROOT, f)
                if os.path.exists(full_path):
                    os.remove(full_path)

                # Restore backup
                backup_path = os.path.join(FASTCP_ROOT, f)
                shutil.move(backup_path, FASTCP_APP_ROOT)

            # Run migrations if any
            self.run_cmd(f'{FASTCP_VENV_ROOT}/bin/python {FASTCP_APP_ROOT}/manage.py migrate')

            # Restart service
            self.print_text('Restarting FastCP service.')
            self.run_cmd('/usr/sbin/service fastcp restart', shell=True)

            return True
        except Exception as e:
            with open(FASTCP_UPGRADER_LOG_FILE, 'w') as f:
                f.write(str(e))
            return False


# Run upgrader
if __name__ == '__main__':

    # Create FastCP updater instance
    fcp = FastcpUpdater()

    fcp.print_text('Starting FastCP upgrade.', color='info')

    # Ensure FastCP is installed
    if fcp.is_installed():
        update = fcp.do_upgrade()
        if update:
            fcp.print_text('Congratulations! FastCP has been upgraded to latest version.', color='success')
        else:
            # Check fcp-upgrader-error-log.txt in the current directory.
            fcp.print_text('Something went wrong and FastCP upgrade was not successful.', color='error')
    else:
        fcp.print_text('We cannot locate a valid FastCP installation on this system.', color='warning')