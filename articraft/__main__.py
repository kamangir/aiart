import argparse
from articraft import NAME, VERSION, DESCRIPTION, ICON
from articraft.logger import logger
from blueness.argparse.version import main


success, message = main(NAME, VERSION, DESCRIPTION, ICON)
if not success:
    logger.error(message)
