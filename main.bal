import ballerina/io;
import model;

function main(string... args) {
    io:println("-==Welcome to Omi==-");

    model:Game game = new();

    model:Player p1 = new model:ComputerPlayer("p1");
    model:Player p2 = new model:ComputerPlayer("p2");
    model:Player p3 = new model:ComputerPlayer("p3");
    model:Player p4 = new model:TerminalPlayer("p4");

    game.addPlayer(p1);
    game.addPlayer(p2);
    game.addPlayer(p3);
    game.addPlayer(p4);

    game.startGame();
}