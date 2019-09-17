public type Console object {
    public function clearScreen(){
        io:println("\u001B[H\u001B[2J");
    }
};