public type Trick object {
    int maxLimit;
    int playerPosition;
    int counter = 0;
    int startPos;
    (Player, Card)[] cardsOftheTrick = [];
    (Player, Card)? winnerOfTheTrick = ();

    public new(maxLimit, int startPosition = 0) {
        maxLimit--;//since counter starts with zero
        if (startPosition <= maxLimit && startPosition >= 0){
            playerPosition = startPosition;
        } else {
            playerPosition = 0;
        }
        startPos = startPosition;
    }

    public function isFirstTurn() returns boolean {
        return playerPosition == startPos;
    }

    public function isLastTurn() returns boolean {
        return playerPosition == maxLimit -1;
    }

    public function get() returns int {
        return playerPosition;
    }

    public function next() returns int {
        if(playerPosition == maxLimit){
            playerPosition = 0;
        } else {
            playerPosition++;
        }
        return playerPosition;
    }

    public function back() returns int {
        if(playerPosition == 0){
            playerPosition = maxLimit;
        } else {
            playerPosition--;
        }
        return playerPosition;
    }

    public function addCard(Card card, string trumps, Player player){
        cardsOftheTrick[counter] = (player, card);
        match winnerOfTheTrick {
            (Player , Card) c => {
                var (_, cc) = c;
                if(cc.compare(card, trumps = trumps) > 0){
                    winnerOfTheTrick = (player, card);
                }
            }
            () => {
                winnerOfTheTrick = (player, card);
            }
        }
        counter++;
        //Check and reset counter
        if(counter == maxLimit){
            counter = 0;
        }
    }

    public function getCardsOftheTrick() returns (Player, Card)[]{
        return cardsOftheTrick;
    }

    public function winnerOftheTrick() returns (Player, Card)? {
        return winnerOfTheTrick;
    }
};