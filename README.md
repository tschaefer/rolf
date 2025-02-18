# rolf

Ask Rolf for postcode.

![rolf](https://github.com/user-attachments/assets/db44016f-468e-4466-b7bf-4d4bb7f51d3d)


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
