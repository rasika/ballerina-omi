import ballerina/io;
import shan1024/chalk;

public function printCard(Card card) {
    io:println(card.print());
}