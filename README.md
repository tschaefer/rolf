# rolf

Ask Rolf for postcode.

![Rofl - Deutsche Bundespost (Public Domain) ](https://www.stupidedia.org/images/9/93/ROLF_-_DEUTSCHE_POST_-_DEUTSCHE_BUNDESPOST_I.jpg "Rolf - Deutsche Bundespost (Public Domain)")

## Introduction

Ask **Rolf** with german city, street and optional federal state name and he will
answer you with all matching postcodes or full addresses.

## Installation

    $ gem build
    $ gem install rolf-$(ruby -Ilib -e 'require "rolf/version"; puts Rolf::VERSION').gem

## Usage

    $ rolf query Garmisch-Partenkirchen Zugspitzstrasse
    82467

    $ rolf query --full Garmisch-Partenkirchen Zugspitzstrasse
    Zugspitzstraße, Garmisch-Partenkirchen, Landkreis Garmisch-Partenkirchen, Obb, Bayern, 82467

    $ rolf query --json Garmisch-Partenkirchen Zugspitzstrasse
    [
      {
        "road": "Zugspitzstraße",
        "town": "Garmisch-Partenkirchen",
        "county": "Landkreis Garmisch-Partenkirchen",
        "state_district": "Obb",
        "state": "Bayern",
        "postcode": "82467"
      }
    ]

For further information about the command line tool `rolf` use the switches
`--help` / `--man`.

## License

[MIT License](https://spdx.org/licenses/MIT.html)

## Is it any good?

[Yes.](https://news.ycombinator.com/item?id=3067434)
