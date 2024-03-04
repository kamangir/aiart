import argparse
from aiart import NAME, VERSION
from aiart.logger import logger


parser = argparse.ArgumentParser(NAME, description=f"{NAME}-{VERSION}")
parser.add_argument(
    "task",
    type=str,
    help="version",
)
args = parser.parse_args()

success = False
if args.task == "version":
    print(f"{NAME}-{VERSION}")
    success = True
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
