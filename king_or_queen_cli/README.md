# KingOrQueenCli

CLI to `king_or_queen` library

## Requirements

Elixir should be installed

## Usage

- start alice

```
PORT=8090 ./king_or_queen_cli
```

- start bob providing alice's address

```
./king_or_queen_cli --alice http://localhost:8090

```

## Example

Alice

```
➜  king_or_queen_cli git:(master) ✗ PORT=8090 ./king_or_queen_cli

11:09:16.024 [info]  Starting `King or Queen` application...
Choose card (King or Queen):
King
You lost

Choose card (King or Queen):
Queen
You won

```

Bob

```
➜  king_or_queen_cli git:(master) ./king_or_queen_cli --alice http://localhost:8090

11:09:51.604 [info]  Starting `King or Queen` application...
Guess card (King or Queen):
King
You won
Play again? (y or n)
y
Guess card (King or Queen):
King
You lost
Play again? (y or n)
n
```
