import argparse
import os
from . import *
from abcli import logging
import logging

logger = logging.getLogger(__name__)


parser = argparse.ArgumentParser(NAME)
parser.add_argument(
    "task",
    type=str,
    default="",
    help="create_html",
)
args = parser.parse_args()


success = False
parser.add_argument(
    "--generator",
    type=str,
    help=os.getenv("AIART_GENERATOR_LIST", ""),
    default=os.getenv("AIART_DEFAULT_GENERATOR", ""),
)
parser.add_argument(
    "--working_folder",
    type=str,
    default="",
)
if args.task == "create":
    success = create_html(
        args.working_folder,
        args.generator,
    )
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
