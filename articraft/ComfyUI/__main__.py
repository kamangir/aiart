import argparse
from articraft import VERSION
from articraft.ComfyUI import NAME
from articraft.ComfyUI.functions import func
from articraft.logger import logger
from blueness.argparse.generic import ending

parser = argparse.ArgumentParser(NAME, description=f"{NAME}-{VERSION}")
parser.add_argument(
    "task",
    type=str,
    help="task",
)
parser.add_argument(
    "--arg",
    type=bool,
    default=0,
    help="0|1",
)
args = parser.parse_args()

success = False
if args.task == "task":
    success = func(args.arg)
else:
    success = None

ending(logger, NAME, args.task, success)
