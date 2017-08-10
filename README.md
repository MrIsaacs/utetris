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


[stack]
[newline]



#Panel

## States

STATIC
SWAP
HANG -> FALL
CLEAR
POPPNG -> POPPED

## Popping

When a match occurs, the panels pop off the screen in order.
This order appears to always be left to right top to bottom.

Lets say you cleared

```
[X,O]
[X,O]
[X,O]
```

They would pop in this order

```
[1,2]
[3,4]
[5,6]
```



#Todo

* Need to add POPPING, POPPED panel states (ref to https://github.com/omenking/panel-attack) `function Panel.clear(self)` engine 705 FC_POP
