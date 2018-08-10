import ballerina/math;

public type Game object {
    string trumps;
    Player[] players = [];
    Card[] cards = [];

    public new() {
        string[] types = ["Spades", "Hearts", "Clubs", "Diamonds"];
        string[] nums = ["7", "8", "9", "10", "J", "Q", "K", "A"];
        int count = 0;
        foreach t in types {
            foreach n in nums {
                cards[count] = new(n, t);
                count++;
            }
        }
    }

    function createRandomNumbers(int startPos, int endPos) returns int[] {
        // Create a random array
        int count = 0;
        int[] rands = [];
        int gap = endPos - startPos;
        while (count < gap) {
            int rand = math:randomInRange(startPos, endPos);
            boolean found = false;
            // Look for existing values
            foreach r in rands {
                if (r == rand) {
                    found = true;
                    break;
                }
            }
            // Add if not exists
            if (!found){
                rands[count] = rand;
                count++;
            }
        }
        return rands;
    }

    function distributeCards(int[] randsOrder) {
        int playerIndex = 0;
        foreach randVal in randsOrder {
            Card c = cards[randVal];
            players[playerIndex].addCard(c);
            if (playerIndex == 3) {
                playerIndex = 0;
            } else {
                playerIndex++;
            }
        }
        io:println();
    }

    documentation {
        Adds a new player.

        P{{player}} player
    }
    public function addPlayer(Player player) {
        players[lengthof players] = player;
    }

    documentation {
        Start the game.
    }
    public function startGame() {
        if (lengthof players != 4){
            error err = { message: "{Player count should be 4!}" };
            throw err;
        }

        distributeCards(createRandomNumbers(0, 16));

        // Player always gets chance to declare thurumpu
        trumps = players[3].declareTrumps();

        io:println("\033[H\033[2J");
        distributeCards(createRandomNumbers(16, 32));

        _ = players[3].playCard();
    }
};