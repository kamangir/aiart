from articraft.logger import logger


def func(arg: str) -> bool:
    logger.info(f"arg:{arg}")
    return True
