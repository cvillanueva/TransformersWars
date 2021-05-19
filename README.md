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

## Understanding the battle result
- When an autobot wins a battle, the result message at the bottom of the cell is painted red.
- When a decepticon wins a battle, the result message at the bottom of the cell is painted purple.
- When a tie happens, the result message at the bottom of the cell is painted yellow.
- When a massive destruction happes, the result message at the bottom of the cell is painted blue.
