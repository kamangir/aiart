import argparse
from . import *
from abcli import file
from abcli import logging
import logging

logger = logging.getLogger(__name__)


parser = argparse.ArgumentParser(NAME)
parser.add_argument(
    "task",
    type=str,
    default="",
    help="flatten",
)
parser.add_argument(
    "--filename",
    type=str,
)
parser.add_argument(
    "--frame_count",
    type=int,
    default=-1,
)
parser.add_argument(
    "--marker",
    type=str,
)
parser.add_argument(
    "--slice_by",
    type=str,
    default="sentences",
)
args = parser.parse_args()

success = False
if args.task == "flatten":
    success = flatten(
        args.filename,
        args.frame_count,
        args.marker,
        args.slice_by,
    )
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
