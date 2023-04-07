from functools import reduce
import os
import os.path
import requests
from bs4 import BeautifulSoup
from . import NAME
from abcli import file
from abcli import path
from abcli.modules import objects
from urllib.parse import urlparse
from abcli import logging
from abcli.logging import crash_report
import logging

logger = logging.getLogger(__name__)


def create_html(
    working_folder,
    generator,
    template="double",
):
    logger.info(
        "aiart.create_html({}:{}): {}".format(
            template,
            generator,
            working_folder,
        )
    )

    success, html_content = file.load_text(
        os.path.join(
            os.getenv("abcli_path_git", ""),
            f"aiart/templates/{template}.html",
        ),
    )
    if not success:
        return success

    object_name = path.name(working_folder)

    success, metadata = file.load_json(
        os.path.join(
            working_folder,
            f"{generator}.json",
        )
    )
    if not success:
        return False

    html_content = [
        "\n".join([f"        <p>{line_}</p>" for line_ in metadata["content"][1:]])
        if "--text--" in line
        else (
            line.replace("--generator--", metadata["generator"])
            .replace("--image--", f"./{object_name}-{generator}.png")
            .replace("--source--", metadata["source"])
            .replace("--title--", metadata["content"][0])
            .replace("--url--", f"http://kamangir.net/private/?object={object_name}")
        )
        for line in html_content
    ]

    return file.save_text(
        os.path.join(working_folder, "report.html"),
        html_content,
    )


def ingest_url(
    url,
    header=0,
    footer=0,
):
    """ingest poetry from url.

    Args:
        url (str): -> README.md for list of supported sources.
        header (int): number of lines to skip at the start.
        footer (int): number of lines to skip at the end.

    Returns:
        bool: success
        List[str]: content
    """
    domain = urlparse(url).netloc

    try:
        response = requests.get(url)

        soup = BeautifulSoup(response.content, "html.parser")

        if domain == "allpoetry.com":
            title, poem_body = ingest_url_allpoetry(soup)
        elif domain == "medium.com":
            title, poem_body = ingest_url_medium_com(soup)
        elif domain == "www.poetryfoundation.org":
            title, poem_body = ingest_url_poetryfoundation(soup)
        else:
            logger.error(f"-{NAME}.ingest_url({url}): {domain}: domain not found.")
            return False, []

        poem_body = [line for line in [line.strip() for line in poem_body] if line]

        if header:
            poem_body = poem_body[header:]
        if footer:
            poem_body = poem_body[:-footer]

        logger.info(
            "{}:{}-{}\n{} @ {}: {} line(s):\n{}".format(
                url,
                header,
                footer,
                title,
                domain,
                len(poem_body),
                "\n".join(poem_body),
            )
        )

        return True, [title] + poem_body
    except:
        crash_report(f"aiart.html: ingest_url({url})")
        return False, []


def ingest_url_allpoetry(soup):
    for br in soup.find_all("br"):
        br.replace_with("\n")

    title = soup.find("h1", {"class": "title"}).text.strip()

    poem_body = (
        soup.find("div", {"class": "poem_body"})
        .find_all("div")[1]
        .text.strip()
        .split("\n")
    )

    return title, poem_body


def ingest_url_medium_com(soup):
    title = soup.find("h1", {"class": "pw-post-title"}).text.strip()

    for br in soup.find_all("br"):
        br.replace_with("\n")

    poem_body = reduce(
        lambda x, y: x + y,
        [
            [line.strip() for line in item.text.split("\n")]
            for item in soup.find_all("p", {"class": "pw-post-body-paragraph"})
        ],
        [],
    )

    return title, poem_body


def ingest_url_poetryfoundation(soup):
    title = soup.find("div", {"class": "c-feature-hd"}).find("h1").text.strip()

    poem_body = soup.find("div", {"class": "c-feature-bd"}).text.strip().split("\r")

    return title, poem_body
