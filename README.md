# Description

A open-source clone of Panel de Pon / Tetris Attack

# Dependencies

* Coffescript
* Gulp


# How to get started

You'll need to run these two tasks

`npm run serve` - serves static files via `http-server`
`npm run watch` - watches gulp for recompliation

Then visit

`http://localhost:8080`


# References

## Examples of panel chaining

https://www.dropbox.com/sh/w8cg4qbrnkltk1v/AAAmAsDKbqzd2h8X-KBqpOLQa?dl=0

# Credits
This source code is a heavily modifed version of `tzwaan`
which is based on a go varaion by `jessethegame`
[tetris-attack-js](https://github.com/tzwaan/tetris-attack-js)
[go-attack](https://github.com/jessethegame/go-attack)
[jessethegame](https://github.com/jessethegame/), called

# Goal

To build a multiplayer version of tetris attack for competitve play.

Its likely once I've learned how to implement everything in Coffeescript
I will begin to port the game into something standalone such as Unity or
Java or C++


# Playfield

The panels on the playfield are stored in a single dimenional array.
The panels start from the top-left corner.
