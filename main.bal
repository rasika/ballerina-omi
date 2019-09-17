import ballerina/io;
import model;

public function main(string... args) {
    io:println("-==Welcome to Omi==-");

    model:Game game = new();

    model:Player p1 = new model:ComputerPlayer("Player1", "B");
    model:Player p2 = new model:ComputerPlayer("Player2", "A");
    model:Player p3 = new model:ComputerPlayer("Player3", "B");
    model:Player p4 = new model:TerminalPlayer("Rasika ", "A");

    game.addPlayer(p1);
    game.addPlayer(p2);
    game.addPlayer(p3);
    game.addPlayer(p4);

    game.startGame();
}