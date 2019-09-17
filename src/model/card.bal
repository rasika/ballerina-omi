import ballerina/io;
import shan1024/chalk;

# Represents a card of the card deck.
public type Card object {
    @final
    string[!...] types = ["Spades", "Hearts", "Clubs", "Diamonds"];

    @final
    string[!...] nums = ["7", "8", "9", "10", "J", "Q", "K", "A"];

    string cardNumber;
    string cardType;
    chalk:Chalk c = new(chalk:DEFAULT, chalk:DEFAULT);

    public new(cardNumber, cardType) {
        c = c.light();
        if (cardType == "Hearts" || cardType == "Diamonds"){
            c = c.foreground(chalk:RED);
            c = c.background(chalk:WHITE);
        } else if (cardType == "Spades" || cardType == "Clubs"){
            c = c.foreground(chalk:BLACK);
            c = c.background(chalk:WHITE);
        } else {
            c = c.foreground(chalk:GREEN);
            c = c.background(chalk:WHITE);
        }
    }

    # Returns card number
    # + return - `string` card number
    public function getCardNumber() returns string {
        return cardNumber;
    }

    # Returns card type
    # + return - `string` card number
    public function getCardType() returns string {
        return cardType;
    }

    # Prints card in terminal
    public function print() {
        string t = getCardTypeSymbol();
        string n = cardNumber;
        string[] lines = self.getPrintText();
        foreach line in lines {
            io:println(line);
        }
    }

    # Returns a list of lines
    # + return - a list of `string` lines
    public function getPrintText() returns string[] {
        string t = getCardTypeSymbol();
        string n = cardNumber;
        string s = (cardNumber == "10") ? "" :  " ";
        string[] lines = [];
        //lines[0] = c.write(",--------,");
        //lines[1] = c.write(string `|{{n}}{{s}}      |`);
        //lines[2] = c.write(string `|{{t}}       |`);
        //lines[3] = c.write("|        |");
        //lines[4] = c.write(string `|       {{t}}|`);
        //lines[5] = c.write(string `|      {{s}}{{n}}|`);
        //lines[6] = c.write("`--------'");
        lines[0] = c.write(string ` {{n}}{{s}}       `);
        lines[1] = c.write(string ` {{t}}        `);
        lines[2] = c.write("          ");
        lines[3] = c.write("          ");
        lines[4] = c.write("          ");
        lines[5] = c.write(string `        {{t}} `);
        lines[6] = c.write(string `       {{s}}{{n}} `);
        return lines;
    }

    function getCardTypeSymbol() returns string {
        string out;
        if (cardType == "Hearts"){
            out = "♥";
        } else if (cardType == "Spades"){
            out = "♠";
        } else if (cardType == "Clubs"){
            out = "♣";
        } else if (cardType == "Diamonds"){
            out = "♦";
        } else {
            out = " ";
        }
        return out;
    }

    # Compare this card with other card.
    # + otherCard - other `Card` to be compared
    # + trumps - trumps `string`
    # + return - `int` deviation
    public function compare(Card otherCard, string trumps = "") returns int {
        return otherCard.getWeight(trumps) - getWeight(trumps);
    }

    # Calculate and returns the weight of the card.
    # + return - `int` weight value
    public function getWeight(string trumps) returns int {
        //Calculate card number precedence
        int cardIndex = -1;
        foreach i, num in nums {
            if (cardNumber == num){
                cardIndex = i;
                break;
            }
        }
        cardIndex++; //avoid zero index
        if(trumps == "") {
            return cardIndex;
        } else {
            // Compare trumps or not
            int cardMultiplier = 1;
            if(cardType == trumps){
                cardMultiplier = 2;
            }
            return (cardIndex * cardMultiplier);
        }
    }
};

# Prints a list of cards
# + cards - list of `Card` to be printed
# + printOptions - if `true` prints options line, do nothing otherwise
public function printCards(Card[] cards, boolean printOptions) {
    int length = 0;
    string[] lines = [];
    string optionsLine = "";
    int numLines = lengthof cards[0].getPrintText();

    int i = 0;
    while (i < numLines) {
        string line = "";
        int j = 0;
        foreach index, card in cards {
            string cardLine = card.getPrintText()[i];
            line += " " + cardLine;
        }
        lines[i] = line;
        i++;
    }

    if (printOptions){
        foreach index, card in cards {
            optionsLine += "    [" + (index + 1) + "]    ";
        }
        lines[i] = optionsLine;
    }
    foreach line in lines {
        io:println(line);
    }
}