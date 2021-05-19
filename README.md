# TransformersWars

## App building

To install dependencies, run:

pod install

Then open TransformersWars.xcworkspace file.

## Assumptions

- If a transformer wins a battle is considered as a survivor.
- In the case of a tie both transformers are destroyed.
- In a case of a skip the transformer is considered as a survivor.
- If two transformers with the same name fight, a massive destruction is triggered.
- The fight button is enabled when at least one transformer is created
- If there is only one transformer in a fight the result will be a tie
- If there are only transformers of one team the result will be a tie

## Understanding the battle result
- When an autobot wins a battle, the result message at the bottom of the cell is painted red.
- When a decepticon wins a battle, the result message at the bottom of the cell is painted purple.
- When a tie happens, the result message at the bottom of the cell is painted yellow.
- When a massive destruction happens, the result message at the bottom of the cell is painted blue.
