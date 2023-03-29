import pytest
from aiart.html import ingest_url


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
def test_ingest_url(url, expected_title, expected_content_length):
    success, content = ingest_url(url)
    assert success
    assert len(content) >= 1
    assert content[0] == expected_title
    assert len(content) == expected_content_length
