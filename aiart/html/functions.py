from functools import reduce
from typing import List, Tuple
import requests
from bs4 import BeautifulSoup
from . import NAME
from urllib.parse import urlparse
from abcli import logging
from abcli.logging import crash_report
import logging

logger = logging.getLogger(__name__)


def ingest_poetry_from_url(
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
        elif domain == "medium.com" or domain.endswith(".medium.com"):
            title, poem_body = ingest_url_medium_com(soup)
        elif domain == "www.poetryfoundation.org":
            title, poem_body = ingest_url_poetryfoundation(soup)
        else:
            logger.error(
                f"-{NAME}.ingest_poetry_from_url({url}): {domain}: domain not found."
            )
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
        crash_report(f"aiart.html: ingest_poetry_from_url({url})")
        return False, []


def ingest_url(
    url: str,
    fake_agent: bool = False,
    verbose: bool = False,
) -> Tuple[bool, str]:
    # https://www.zenrows.com/blog/403-web-scraping#set-fake-user-agent
    headers = (
        {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
        }
        if fake_agent
        else {}
    )

    response = requests.get(url, headers=headers)
    if verbose:
        logger.info(f"response: {response}")

    # https://chat.openai.com/c/6deb94d0-826a-48de-b5ef-f7d8da416c82
    # response.raise_for_status()
    if response.status_code // 100 != 2:  # Check if status code is not in the 2xx range
        logger.info(
            "ingest_url({}) failed, status_code: {}, reason: {}.".format(
                url,
                response.status_code,
                response.reason,
            )
        )
        return False, ""

    # Check if the content type is text-based (e.g., HTML, plain text)
    if "text" not in response.headers.get("content-type", "").lower():
        logger.error(f"ingest_url({url}): url does not contain text-based content.")
        return False, ""

    soup = BeautifulSoup(response.text, "html.parser")
    description = " ".join([p.get_text() for p in soup.find_all("p")])

    if verbose:
        logger.info("ingest_url({}): {}".format(url, description))
    return True, description


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
