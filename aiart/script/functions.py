import emoji
from functools import reduce
import re
from abcli import file
from abcli.plugins.metadata import post as post_metadata, MetadataSourceType
from . import NAME
from abcli import logging
import logging

logger = logging.getLogger(__name__)


def flatten(
    filename,
    frame_count=-1,
    marker="",
    slice_by="sentences",
):
    success, script = file.load_text(filename)
    if not success:
        return success

    script = [line for line in script if "![image]" not in line and "<img" not in line]
    script = [re.sub(r"https?://\S+", "", line) for line in script]
    script = [re.sub(r"http?://\S+", "", line) for line in script]

    if marker:
        script_ = []
        prev_line = ""
        for line in script:
            if marker:
                if marker in line:
                    marker = ""
                continue

            if not prev_line and not line:
                continue

            script_ += [line]
            prev_line = line

        script = script_

    script = reduce(
        lambda x, y: x + y,
        [line.split(".") for line in script],
        [],
    )

    is_script = False
    script_ = []
    for line in script:
        if "```" in line:
            is_script = not is_script
            continue
        if not is_script:
            script_ += [line]
    script = script_

    for substr in "[x]".split(","):
        script = [line.replace(substr, "") for line in script]

    script = [emoji.demojize(line) for line in script]

    for ch in "[]()`*#\"\\'<>:!?/":
        script = [line.replace(ch, "") for line in script]

    for ch in "_-":
        script = [line.replace(ch, " ") for line in script]

    script = [line.strip() for line in script]

    script = [line for line in script if not line.startswith("linkbacks")]

    # no single-word lines.
    script = [
        line
        for line in script
        if len(line.split(" ")) > 1 or len(line.replace(" ", "")) == 0
    ]

    # no numbers and spaces.
    script = [line for line in script if not re.match(r"^[\d\s]+$", line)]

    script = [line[:120] for line in script]

    if slice_by == "words":
        script_ = []
        prev_line = ""
        for line in script:
            if prev_line:
                script_ += line.split(" ")
            else:
                script_ += [line]
            prev_line = line
        script = script_

    if frame_count != -1:
        script_ = []
        for line in script:
            if not frame_count:
                break
            if line:
                frame_count -= 1
            script_ += [line]
        script = script_

    if not file.save_text(
        filename,
        script,
    ):
        return False

    if not post_metadata(
        "script",
        {
            "frame_count": frame_count,
            "marker": marker,
            "script": script,
        },
        source=file.path(filename),
        source_type=MetadataSourceType.PATH,
    ):
        return False

    logger.info(
        f"{NAME}.flatten: {filename} - {len(script)} lines(s), started at {marker} - sliced by {slice_by}"
    )
    return True
