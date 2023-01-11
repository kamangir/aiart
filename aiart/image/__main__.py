import argparse
import cv2
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
    help="convert",
)
parser.add_argument(
    "--destination",
    type=str,
)
parser.add_argument(
    "--height",
    type=int,
    default=512,
)
parser.add_argument(
    "--source",
    type=str,
)
parser.add_argument(
    "--width",
    type=int,
    default=512,
)
# important that unknown args are ignored.
args, _ = parser.parse_known_args()

success = False
if args.task == "convert":
    success, image = file.load_image(args.source)
    if success:
        success = file.save_image(
            args.destination,
            cv2.resize(
                image,
                (args.width, args.height),
            ),
        )

    if success:
        logger.info(f"{args.source} -{args.height}x{args.width}> {args.destination}")
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
