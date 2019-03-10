# KingOrQueen

Simple `King or Queen` game that can be played over the network

## Project Structure

- `king_or_queen` - the library that implements the game
- `king_or_queen_cli` - cli to the library

## Idea

- Bob sends to Alice request to choose King or Queen
- Alice chooses King or Queen
  - she generates private and public RSA keys
  - she signs choosed card name
  - she sends only signature to Bob
- Bob guesses card and sends his guess to Alice
- Alice returns public key
- Bob now can check his guess using signature and public key

## How to use

- Usage is described in `king_or_queen_cli` project
