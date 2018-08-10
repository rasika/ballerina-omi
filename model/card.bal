import ballerina/io;
import shan1024/chalk;

public type Card object {
    string cardNumber,
    string cardType,
    chalk:Chalk c = new(chalk:DEFAULT, chalk:DEFAULT),

    public new(cardNumber, cardType) {
        c = c.light();
        if (cardType == "Hearts" || cardType == "Diamonds"){
            c = c.foreground(chalk:RED);
        } else if (cardType == "Spades" || cardType == "Clubs"){
            c = c.foreground(chalk:BLACK);
        } else {
            c = c.foreground(chalk:GREEN);
        }
    }

    public function printNumber() returns string {
        return cardNumber;
    }

    public function printType() returns string {
        return getCardTypeSymbol();
    }

    public function print() {
        string t = getCardTypeSymbol();
        string n = cardNumber;
        string[] lines = self.getPrintText();
        foreach line in lines {
            io:println(line);
        }
    }

    public function getPrintText() returns string[] {
        string t = getCardTypeSymbol();
        string n = cardNumber;
        string s = (cardNumber == "10") ? "" :  " ";
        string[] lines = [];
        lines[0] = c.write(",--------,");
        lines[1] = c.write(string `|{{n}}{{s}}      |`);
        lines[2] = c.write(string `|{{t}}       |`);
        lines[3] = c.write("|        |");
        lines[4] = c.write(string `|       {{t}}|`);
        lines[5] = c.write(string `|      {{s}}{{n}}|`);
        lines[6] = c.write("`--------'");
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
};

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