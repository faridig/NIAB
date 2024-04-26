from typing import Optional


def convert_dates(date: str) -> str:
    """Convert Allocine's dates to 'YYYY-MM-DD' format"""
    date = date.split()
    MONTH_MAPPING = {
        "janvier": "01",
        "février": "02",
        "mars": "03",
        "avril": "04",
        "mai": "05",
        "juin": "06",
        "juillet": "07",
        "août": "08",
        "septembre": "09",
        "octobre": "10",
        "novembre": "11",
        "décembre": "12"
    }
    date[1] = MONTH_MAPPING[date[1]]
    # Pad with 0 the 1-number days' strings
    date[0] = "0" + date[0] if len(date[0]) == 1 else date[0]
    return "-".join(reversed(date))


def convert_duration(duration: str) -> Optional[int]:
    """Convert a duration string to its minutes counterpart"""
    if duration is None or not duration.endswith("min"):
        return None
    duration = duration.split()
    hours = int(duration[0].replace("h", ""))
    minutes = int(duration[1].replace("min", ""))
    return (60 * hours + minutes)
