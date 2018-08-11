import ballerina/io;

public type Player object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string currentCardType;

    public new(playerName) {

    }

    public function addCard(Card c);
    public function playCard() returns Card | ();
    public function printAllCards(boolean textOnly = false);
    public function declareTrumps() returns string;
    public function setCurrentCardType(string? cardType);
};

public type ComputerPlayer object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string currentCardType;

    public new(playerName) {

    }

    documentation {
        Adds a card to player's deck.

        P{{card}} new card
    }
    public function addCard(Card card) {
        cards[<string>counter] = card;
        counter++;
    }

    documentation {
        Play the card.

        R{{}} Card
    }
    public function playCard() returns Card | (){
        if(lengthof cards == 0){
            return ();
        }
        string cardKey = cards.keys()[0];
        Card chosedCard = check <Card>cards[cardKey];
        _ = cards.remove(cardKey);
        return chosedCard;
    }

    documentation {
        Print all cards in hand.

        P{{textOnly}} if True prints only textual output
    }
    public function printAllCards(boolean textOnly = false) {
        if (textOnly) {
            any[] vals = cards.values();
            foreach item in vals {
                Card card = check <Card>item;
                io:print(card.printNumber() + card.printType() + ", ");
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

    public function setCurrentCardType(string? cardType){

    }
};

public type TerminalPlayer object {
    public string playerName;
    public map cards;
    public int counter = 0;
    public string currentCardType;

    public new(playerName) {

    }

    documentation {
        Adds a card to player's deck.

        P{{card}} new card
    }
    public function addCard(Card card) {
        cards[<string>counter] = card;
        counter++;
    }

    documentation {
        Play the card.

        R{{}} Card
    }
    public function playCard() returns Card | (){
        if(lengthof cards == 0){
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

    documentation {
        Print all cards in hand.

        P{{textOnly}} if True prints only textual output
    }
    public function printAllCards(boolean textOnly = false) {
        if (textOnly) {
            any[] vals = cards.values();
            foreach item in vals {
                Card card = check <Card>item;
                io:print(card.printNumber() + card.printType() + ", ");
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

    documentation {
        Declare Trumps.

        R{{}} Trumps
    }
    public function declareTrumps() returns string {
        printAllCards();
        (string, string)[] types = [("Hearts","♥"), ("Diamonds","♦"), ("Spades","♠"), ("Clubs","♣")];
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

    public function setCurrentCardType(string? cardType){

    }
};