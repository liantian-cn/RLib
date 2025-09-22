import os
from datetime import datetime

x = int((datetime.now() - datetime(2023, 7, 1)).days)
now = datetime.now()

args = [
    'nuitka',
    '--standalone',
    # '--show-memory',
    # '--show-progress',
    '--assume-yes-for-downloads',
    '--windows-uac-admin',
    '--mingw64',
    '--windows-icon-from-ico=./python.ico',
    '--windows-console-mode=force',
    # '--show-progress',
    '--output-dir=build',
    'main.py'
]

os.system(' '.join(args))


