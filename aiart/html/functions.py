from functools import reduce
import os
import os.path
import requests
from bs4 import BeautifulSoup
from abcli import file
from abcli import path
from abcli.modules import objects
from abcli import logging
from abcli.logging import crash_report
import logging

logger = logging.getLogger(__name__)


def create_html(
    working_folder,
    generator,
):
    table_mode = generator != "DALL-E"

    logger.info(
        "aiart.create_html({}): {}{}".format(
            generator,
            working_folder,
            " - [table]" if table_mode else "",
        )
    )

    object_name = path.name(working_folder)

    if table_mode:
        content = [
            f'            <a href="./{object_name}-video.gif"><img src="./{object_name}-{file.name_and_extension(filename)}" width="16%"></a>'
            for filename in sorted(objects.list_of_files(object_name))
            if file.extension(filename) in "jpg,png,jpeg".split(",")
        ]
    else:
        content = [f'<img src="./{object_name}-DALL-E.png">']

    success, html_content = file.load_text(
        os.path.join(
            os.getenv("abcli_path_git", ""),
            "aiart/templates/DALL-E.html",
        ),
    )
    if not success:
        return success

    html_content = [line.replace("--title--", object_name) for line in html_content]

    html_content = [
        line if "--content--" not in line else "\n".join(content)
        for line in html_content
    ]

    return file.save_text(
        os.path.join(working_folder, "report.html"),
        html_content,
    )


def ingest_url(url):
    """ingest poetry from url.

    Args:
        url (str): example: https://allpoetry.com/16-bit-Intel-8088-chip

    Returns:
        bool: success
        List[str]: content
    """
    try:
        response = requests.get(url)

        soup = BeautifulSoup(response.content, "html.parser")

        for br in soup.find_all("br"):
            br.replace_with("\n")

        title = soup.find("h1", {"class": "title"}).text.strip()

        poem_body = (
            soup.find("div", {"class": "poem_body"})
            .find_all("div")[1]
            .text.strip()
            .split("\n")
        )

        logger.info(
            "{}: {} line(s):\n{}".format(
                title,
                len(poem_body),
                "\n".join([line for line in poem_body if line]),
            )
        )

        return True, [title] + poem_body
    except:
        crash_report(f"aiart.html: ingest_url({url})")
        return False, []
