import pytest
from aiart.html.functions import ingest_poetry_from_url, ingest_url


@pytest.mark.parametrize(
    "url, expected_title, expected_content_length",
    [
        (
            "https://allpoetry.com/Hemingway-Never-Did-This",
            "Hemingway Never Did This",
            32,
        ),
        (
            "https://allpoetry.com/16-bit-Intel-8088-chip",
            "16-bit Intel 8088 chip",
            27,
        ),
        (
            "https://www.poetryfoundation.org/poems/45502/the-red-wheelbarrow",
            "The Red Wheelbarrow",
            9,
        ),
    ],
)
def test_ingest_poetry_from_url(url, expected_title, expected_content_length):
    success, content = ingest_poetry_from_url(url)
    assert success
    assert len(content) >= 1
    assert content[0] == expected_title
    assert len(content) == expected_content_length


@pytest.mark.parametrize(
    "url, fake_agent, expected_success",
    [
        (
            "https://earthdaily.com/constellation/",
            False,
            False,
        ),
        (
            "https://earthdaily.com/constellation/",
            True,
            True,
        ),
    ],
)
def test_url(url, fake_agent, expected_success):
    success, _ = ingest_url(url, fake_agent=fake_agent)
    assert success == expected_success
