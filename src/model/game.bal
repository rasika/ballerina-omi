import ballerina/math;
import ballerina/io;

public type Game object {
    Player[] players = [];
    Card[] cards = [];
    Trick gameTrick = new(4, startPosition  = 3);
    boolean isLastMatchDraw = false;
    Console console = new;

    public new() {
        string[!...] types = ["Spades", "Hearts", "Clubs", "Diamonds"];
        string[!...] nums = ["7", "8", "9", "10", "J", "Q", "K", "A"];
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
            players[gameTrick.next()].addCard(c);
        }
    }

    public function addPlayer(Player player) {
        players[lengthof players] = player;
    }

    function notifyTrumps(string trumps) {
        Card card = new("A", trumps);
        io:println(trumps + " " + card.getCardTypeSymbol() + " are the Trumps!");
        foreach player in players {
            player.trumps = trumps;
        }
    }

    public function startGame() {
        if (lengthof players != 4){
            error err = { message: "{\"Player count should be 4!\"}" };
            throw err;
        }

        //Distribute first half of cards
        distributeCards(createRandomNumbers(0, 16));

        // Player always gets chance to declare thurumpu
        Player firstPlayer = players[gameTrick.get()];
        string trumps = firstPlayer.declareTrumps();
        notifyTrumps(trumps);

        //Distribute second half of cards
        distributeCards(createRandomNumbers(16, 32));

        //Reset turn into current user
        _ = gameTrick.back();

        log:printDebug(players[3].getPlayerName() + "[" + players[3].getPlayerTeam() + "]: ");
        //players[3].printAllCards(textOnly = true);
        log:printDebug(players[0].getPlayerName()+ "[" + players[0].getPlayerTeam() + "]: ");
        //players[0].printAllCards(textOnly = true);
        log:printDebug(players[1].getPlayerName()+  "[" + players[1].getPlayerTeam() + "]: ");
        //players[1].printAllCards(textOnly = true);
        log:printDebug(players[2].getPlayerName() + "[" + players[2].getPlayerTeam() + "]: ");
        //players[2].printAllCards(textOnly = true);

        console.clearScreen();

        boolean stop = false;
        string? cardType = ();
        map<int> score;
        while (!stop) {
            Player currentPlayer = players[gameTrick.next()];
            currentPlayer.setCurrentCardType(cardType);

            //io:println();
            //io:print(currentPlayer.getPlayerName() + "[" + currentPlayer.getPlayerTeam() + "]: ");
            //currentPlayer.printAllCards(textOnly = true);

            Card? playerCard = currentPlayer.playCard(gameTrick);
            match playerCard {
                Card c => {
                    if(gameTrick.isFirstTurn()){
                        cardType = c.getCardType();
                    }
                    gameTrick.addCard(c, trumps, currentPlayer);
                    io:print(currentPlayer.getPlayerName() + "[" + currentPlayer.getPlayerTeam() + "]: ");
                    io:println(c.getCardNumber() + c.getCardTypeSymbol());
                    //c.print();
                    //io:println();

                    console.clearScreen();
                    Card[] trickCards = [];
                    (Player, Card)[] tmpTrickCards = gameTrick.getCardsOftheTrick();
                    foreach i, trickCard in tmpTrickCards {
                        trickCards[i] = trickCard[1];
                    }
                    printCards(trickCards, false);

                    if(gameTrick.isLastTurn()){
                        (Player, Card)? winner = gameTrick.winnerOftheTrick();
                        match winner {
                            (Player, Card) pair => {
                                var (p, _) = pair;
                                int oldScore = score[p.getPlayerTeam()] ?: 0;
                                oldScore++;
                                score[p.getPlayerTeam()] = oldScore;
                                io:println("Winner of the trick: " + p.getPlayerName() + "[" + p.getPlayerTeam() + "]");
                            }
                            () => {}
                        }
                    }
                }
                () =>  {
                    if(gameTrick.isFirstTurn()){
                        stop = true;
                        int tokens;
                        string winningPlayers;
                        (tokens, winningPlayers) = anounceWinners(score, firstPlayer.getPlayerTeam());
                        io:println("Winner of the Game: " + winningPlayers + " and won " + tokens + " tokens");
                    }
                }
            }
        }
    }

    function anounceWinners(map<int> score, string trumpAnouncedTeam) returns (int, string){
        int tokens;
        string winningTeam = "";
        string winningPlayers = "";
        int maxScore = 0;
        foreach k,v in score {
            if(v > maxScore){
                winningTeam = k;
                maxScore = v;
            }
        }

        string prefix = "";
        foreach player in players {
            if (player.getPlayerTeam() == winningTeam){
                winningPlayers += prefix + player.getPlayerName();
                prefix = ",";
            }
        }

        if(maxScore == 8){
            tokens = 3; //Kapothi
            isLastMatchDraw = false;
        } else if (maxScore == 4){
            tokens = 0; //Seporu
            isLastMatchDraw = true;
        } else {
            if(trumpAnouncedTeam != winningTeam || isLastMatchDraw){
                tokens = 2;
            } else {
                tokens = 1;
            }
            isLastMatchDraw = false;
        }
        return (tokens, winningPlayers);
    }
};