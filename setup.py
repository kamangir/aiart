from aiart import NAME, VERSION, DESCRIPTION
from blueness.pypi import setup

setup(
    filename=__file__,
    repo_name="aiart",
    name=NAME,
    version=VERSION,
    description=DESCRIPTION,
    packages=[NAME],
)
