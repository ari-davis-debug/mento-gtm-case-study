# board-decks/

> Where Mento's quarterly board decks live, parsed into markdown so Claude can read across them.

## What goes here

- One file per board meeting: `YYYY-MM-DD-board-deck.md`
- A `_synthesis.md` rolling doc summarizing the through-lines across decks (the things that come up every quarter)

## How it's used

When Claude is asked *"what did Alex tell the board about GTM last quarter?"*, it reads the latest deck here, plus the synthesis. Never reproduces full deck text — extracts the GTM-relevant section as a short summary with citations.

## What does *not* go here

- Slide decks for prospects (those live in `services/<workflow>/assets/` if they're part of a workflow)
- Financial models — separate concern, not Claude's job
- Anything board-confidential that hasn't been redacted
