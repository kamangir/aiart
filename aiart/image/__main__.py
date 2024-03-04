import argparse
import cv2
from abcli import file
from aiart.image import NAME
from aiart.logger import logger


parser = argparse.ArgumentParser(NAME)
parser.add_argument(
    "task",
    type=str,
    default="",
    help="convert|convert_to_RGBA",
)
parser.add_argument(
    "--destination",
    type=str,
)
parser.add_argument(
    "--height",
    type=int,
    default=-1,
)
parser.add_argument(
    "--source",
    type=str,
)
parser.add_argument(
    "--width",
    type=int,
    default=-1,
)
# important that unknown args are ignored.
args, _ = parser.parse_known_args()

success = False
if args.task == "convert":
    success, image = file.load_image(args.source)

    if success:
        if args.width != -1 and args.height != -1:
            image = cv2.resize(
                image,
                (args.width, args.height),
            )

        success = file.save_image(args.destination, image)

    if success:
        logger.info(f"{args.source} -{args.height}x{args.width}> {args.destination}")
elif args.task == "convert_to_RGBA":
    # https://chat.openai.com/chat/c15fe2ad-cd5b-4218-8f05-21e5443775b8
    from PIL import Image

    image = Image.open(args.source)

    image = image.convert("RGBA")

    data = image.getdata()

    new_data = [(r, g, b, 0) for r, g, b, a in data]

    image.putdata(new_data)

    image.save(args.destination)

    logger.info(f"{args.source} -RGBA-> {args.destination}")

    success = True
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
