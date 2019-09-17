import ballerina/io;
import ballerina/log;

public type Player abstract object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string? currentCardType;
    public string trumps;
    public string team;

    public function getPlayerName() returns string;
    public function getPlayerTeam() returns string;
    public function addCard(Card c);
    public function playCard(Trick gameTurn) returns Card|();
    public function printAllCards(boolean textOnly = false);
    public function declareTrumps() returns string;
    public function setCurrentCardType(string? cardType);
};

public type ComputerPlayer object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string? currentCardType;
    public string trumps;
    public string team;

    public new(playerName, team) {}

    public function getPlayerName() returns string {
        return playerName;
    }

    public function getPlayerTeam() returns string {
        return team;
    }

    public function addCard(Card card) {
        cards[<string>counter] = card;
        counter++;
    }

    public function playCard(Trick gameTurn) returns Card|() {
        if (lengthof cards == 0){
            return ();
        }

        string cardKey = cards.keys()[0];
        Card chosedCard = check <Card>cards[cardKey];

        (string, Card)? highestSameTypeCard = ();
        (string, Card)? lowestSameTypeCard = ();
        (string, Card)? lowestNonTrumpCard = ();
        (string, Card)? higherTrump = ();
        Card? otherTeamCard = ();

        Player? winner = gameTurn.winnerOftheTrick()[0];
        string winnerTeam = "";
        match winner {
            Player p => {
                log:printDebug("Winner: " + p.getPlayerName() + "[" + p.getPlayerTeam() + "]");
                winnerTeam = p.getPlayerTeam();
                if (winnerTeam != getPlayerTeam()) {
                    otherTeamCard = gameTurn.winnerOftheTrick()[1];
                }
            }
            () => {
                winnerTeam = "";
                otherTeamCard = ();
            }
        }

        foreach i, item in cards.values() {
            Card newCard = check <Card>item;
            boolean isSameType = newCard.getCardType() == currentCardType;

            match highestSameTypeCard {
                (string, Card) pair => {
                    var (_, hsmCard) = pair;
                    if (isSameType && (hsmCard.compare(newCard) > 0)){
                        highestSameTypeCard = (cards.keys()[i], newCard);
                    }
                }
                () => {
                    if (isSameType) {
                        highestSameTypeCard = (cards.keys()[i], newCard);
                    }
                }
            }

            match lowestSameTypeCard {
                (string, Card) pair => {
                    var (_, lsmCard) = pair;
                    if (isSameType && (lsmCard.compare(newCard) < 0)){
                        lowestSameTypeCard = (cards.keys()[i], newCard);
                    }
                }
                () => {
                    if (isSameType) {
                        lowestSameTypeCard = (cards.keys()[i], newCard);
                    }
                }
            }

            match lowestNonTrumpCard {
                (string, Card) pair => {
                    var (_, lCard) = pair;
                    if (lCard.compare(newCard) < 0 && newCard.getCardType() != trumps){
                        lowestNonTrumpCard = (cards.keys()[i], newCard);
                    }
                }
                () => {
                    if (newCard.getCardType() != trumps) {
                        lowestNonTrumpCard = (cards.keys()[i], newCard);
                    }
                }
            }


            match higherTrump {
                (string, Card) pair => {
                    var (_, tCard) = pair;
                    if (tCard.compare(newCard) < 0 && newCard.getCardType() == trumps){
                        higherTrump = (cards.keys()[i], newCard);
                    }
                }
                () => {
                    if (newCard.getCardType() == trumps){
                        higherTrump = (cards.keys()[i], newCard);
                    }
                }
            }
        }

        Card ignore = new("A", "Hearts");
        if (highestSameTypeCard != ()){
            Card c = highestSameTypeCard[1] ?: ignore;
            log:printDebug("highestSameTypeCard: " + c.getCardNumber() + c.getCardTypeSymbol());
        }

        if (lowestSameTypeCard != ()){
            Card c = lowestSameTypeCard[1] ?: ignore;
            log:printDebug("lowestSameTypeCard: " + c.getCardNumber() + c.getCardTypeSymbol());
        }

        if (lowestNonTrumpCard != ()){
            Card c = lowestNonTrumpCard[1] ?: ignore;
            log:printDebug("lowestCard: " + c.getCardNumber() + c.getCardTypeSymbol());
        }

        if (higherTrump != ()){
            Card c = higherTrump[1] ?: ignore;
            log:printDebug("higherTrump: " + c.getCardNumber() + c.getCardTypeSymbol());
        }

        boolean cardSelected = false;
        if (winnerTeam != getPlayerTeam()){
            // If other team is going to win...
            match highestSameTypeCard {
                // If there's a higher card in same type
                (string, Card) hsCardPair => {
                    // Check and put the same type highest card
                    var (hKey, hCard) = hsCardPair;

                    match otherTeamCard {
                        Card c => {
                            if (c.compare(hCard) > 0){
                                // If highest card is exceeding current highest card
                                (cardKey, chosedCard) = hsCardPair;
                                log:printDebug("Playing highestSameTypeCard");
                                cardSelected = true;
                            }
                        }
                        () => {
                            // There's no other team card, just put highest
                            (cardKey, chosedCard) = hsCardPair;
                            log:printDebug("No otherTeamCard, Playing highestSameTypeCard");
                            cardSelected = true;
                        }
                    }
                }
                () => {
                    // Or else, check for trumps
                    match higherTrump {
                        // If exists, put a higher trump card
                        (string, Card) pair => {
                            (cardKey, chosedCard) = pair;
                            log:printDebug("Playing higher trump card");
                            cardSelected = true;
                        }
                        () => {
                            log:printDebug("No sameTypeCard, No Trumps");
                        }
                    }
                }
            }
        }

        if (!cardSelected){
            match lowestSameTypeCard {
                (string, Card) lcPair => {
                    log:printDebug("Playing lowestSameTypeCard");
                    (cardKey, chosedCard) = lcPair;
                }
                () => {
                    match lowestNonTrumpCard {
                        // Or else, put lowest card
                        (string, Card) lcPair => {
                            log:printDebug("Playing lowestNonTrumpCard");
                            (cardKey, chosedCard) = lcPair;
                        }
                        () => {
                            log:printDebug("Playing default card");
                        }
                    }
                }
            }
        }

        _ = cards.remove(cardKey);
        return chosedCard;
    }

    public function printAllCards(boolean textOnly = false) {
        if (textOnly) {
            any[] vals = cards.values();
            foreach item in vals {
                Card card = check <Card>item;
                io:print(card.getCardNumber() + card.getCardTypeSymbol() + ", ");
            }
            io:print("\n");
        } else {
            // Get available cards
            any[] anyList = cards.values();
            Card[] cardList = [];
            int count = 0;
            foreach item in anyList {
                cardList[count] = check <Card>item;
                count++;
            }

            // Print all avaialble cards
            printCards(cardList, true);
            io:println("");
        }
    }

    public function declareTrumps() returns string {
        return "Spades";
    }

    public function setCurrentCardType(string? cardType) {
        currentCardType = cardType;
    }
};

public type TerminalPlayer object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string? currentCardType;
    public string trumps;
    public string team;

    public new(playerName, team) {

    }

    public function getPlayerName() returns string {
        return playerName;
    }

    public function getPlayerTeam() returns string {
        return team;
    }

    public function addCard(Card card) {
        cards[<string>counter] = card;
        counter++;
    }

    public function playCard(Trick gameTurn) returns Card|() {
        if (lengthof cards == 0){
            return ();
        }
        printAllCards();
        // Ask for choice
        boolean chosed = false;
        int choice;
        while (!chosed) {
            choice = check <int>io:readln("Enter Card Choice:");
            if (choice <= lengthof cards){
                chosed = true;
            } else {
                io:println("Invalid Choice!");
            }
        }

        // Return chosed card
        string cardKey = cards.keys()[(choice - 1)];
        Card chosedCard = check <Card>cards[cardKey];
        _ = cards.remove(cardKey);
        return chosedCard;
    }

    public function printAllCards(boolean textOnly = false) {
        if (textOnly) {
            any[] vals = cards.values();
            foreach item in vals {
                Card card = check <Card>item;
                io:print(card.getCardNumber() + card.getCardTypeSymbol() + ", ");
            }
            io:print("\n");
        } else {
            // Get available cards
            any[] anyList = cards.values();
            Card[] cardList = [];
            int count = 0;
            foreach item in anyList {
                cardList[count] = check <Card>item;
                count++;
            }

            // Print all avaialble cards
            printCards(cardList, true);
            io:println("");
        }
    }

    public function declareTrumps() returns string {
        printAllCards();
        (string, string)[] types = [("Hearts", "♥"), ("Diamonds", "♦"), ("Spades", "♠"), ("Clubs", "♣")];
        foreach i, t in types {
            io:println((i + 1) + ". " + t[0] + " (" + t[1] + ")");
        }
        boolean chosed = false;
        int choice;
        while (!chosed) {
            choice = check <int>io:readln("Enter Trump Choice:");
            if (choice > 0 && choice <= 4){
                chosed = true;
            } else {
                io:println("Invalid Choice!");
            }
        }
        return types[choice - 1][0];
    }

    public function setCurrentCardType(string? cardType) {
        currentCardType = cardType;
    }
};