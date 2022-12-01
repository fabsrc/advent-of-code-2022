# :christmas_tree::calendar: Advent of Code 2022

## Run solutions

```sh
# $1: Day of the calendar
export AOC_COOKIE="session=<session cookie here>"
function aoc {
  curl "https://adventofcode.com/2022/day/$1/input" -s --cookie $AOC_COOKIE
}

# Example
crystal 01.cr "$(aoc 1)"
```
