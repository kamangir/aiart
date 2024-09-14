import argparse

from blueness import module
from blueness.argparse.generic import sys_exit

from articraft import NAME, VERSION
from articraft.script.functions import flatten
from articraft.logger import logger

NAME = module.name(__file__, NAME)

parser = argparse.ArgumentParser(NAME, description=f"{NAME}-{VERSION}")
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
    success = None

sys_exit(logger, NAME, args.task, success)
