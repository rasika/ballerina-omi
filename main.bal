import ballerina/io;
import model;

function main(string... args) {
    io:println("-==Welcome to Omi==-");

    model:Game game = new();

    //var playerName = io:readln("Player Name:");
    //model:Card c1 = new("K", "Spades");
    //model:Card c2 = new("9", "Hearts");
    //model:Card c3 = new("7", "Clubs");
    //model:Card c4 = new("A", "Diamonds");
    //model:Card empty = new(" ", " ");
    //c2.print();
    //model:printCards([c1, c2, c3, c4, empty]);

    model:Player p1 = new model:ComputerPlayer("p1");
    model:Player p2 = new model:ComputerPlayer("p2");
    model:Player p3 = new model:ComputerPlayer("p3");
    model:Player p4 = new model:TerminalPlayer("p4");

    game.addPlayer(p1);
    game.addPlayer(p2);
    game.addPlayer(p3);
    game.addPlayer(p4);

    game.startGame();

    //io:print("p1: ");
    //p1.printAllCards(textOnly = true);
    //io:print("p2: ");
    //p2.printAllCards(textOnly = true);
    //io:print("p3: ");
    //p3.printAllCards(textOnly = true);
    //io:print("p4: ");
    //p4.printAllCards(textOnly = true);

    // p4.playCard().print();
}