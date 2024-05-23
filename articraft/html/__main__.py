import argparse
from articraft import VERSION
from articraft.html import NAME
from articraft.html.functions import ingest_url
from articraft.logger import logger


parser = argparse.ArgumentParser(NAME, description=f"{NAME}-{VERSION}")
parser.add_argument(
    "task",
    type=str,
    help="ingest_url",
)
parser.add_argument(
    "--url",
    type=str,
)
parser.add_argument(
    "--verbose",
    type=int,
    default=0,
    help="0|1",
)
parser.add_argument(
    "--fake_agent",
    type=int,
    default=0,
    help="0|1",
)
args = parser.parse_args()

success = False
if args.task == "ingest_url":
    success, description = ingest_url(
        url=args.url,
        fake_agent=bool(args.fake_agent),
        verbose=bool(args.verbose),
    )
    print(description)
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
