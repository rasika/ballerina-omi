import ballerina/math;

public type Game object {
    string trumps;
    Player[] players = [];
    Card[] cards = [];
    Turn gameTurn = new(4, startPosition  = 2);

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
        foreach randVal in randsOrder {
            Card c = cards[randVal];
            players[gameTurn.next()].addCard(c);
        }
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

        //Distribute first half of cards
        distributeCards(createRandomNumbers(0, 16));

        // Player always gets chance to declare thurumpu
        Player firstPlayer = players[gameTurn.next()];
        trumps = firstPlayer.declareTrumps();
        Card card = new("A", trumps);
        io:println(trumps + " " + card.getCardTypeSymbol() + " are the Trumps!");

        //Distribute second half of cards
        distributeCards(createRandomNumbers(16, 32));

        //Reset turn into current user
        _ = gameTurn.back();

        boolean stop = false;
        string? cardType = ();
        while (!stop) {
            Player currentPlayer = players[gameTurn.next()];
            currentPlayer.setCurrentCardType(cardType);
            Card? playerCard = currentPlayer.playCard();
            match playerCard {
                Card c => {
                    c.print();
                }
                () =>  {
                    if(gameTurn.isFirstTurn()){
                        stop = true;
                    }
                }
            }
        }
    }
};