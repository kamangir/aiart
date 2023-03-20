import requests
from bs4 import BeautifulSoup
from abcli import logging
from abcli.logging import crash_report
import logging

logger = logging.getLogger(__name__)


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

        title = soup.find("h1", {"class": "title"}).text.strip()

        poem_body = (
            soup.find("div", {"class": "poem_body"})
            .find_all("div")[1]
            .text.strip()
            .split("\n")
        )

        logger.info(
            "{}: {} line(s): {}".format(title, len(poem_body), ", ".join(poem_body))
        )

        return True, [title] + poem_body
    except:
        crash_report(f"aiart.html: ingest_url({url})")
        return False, []
