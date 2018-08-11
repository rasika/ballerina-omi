public type Turn object {
    int maxLimit;
    int counter;
    int startPos;

    public new(maxLimit, int startPosition = 0) {
        maxLimit--;//since counter starts with zero
        if (startPosition <= maxLimit && startPosition >= 0){
            counter = startPosition;
        } else {
            counter = 0;
        }
        startPos = counter;
    }

    public function isFirstTurn() returns boolean {
        return counter == startPos;
    }

    public function get() returns int {
        return counter;
    }

    public function next() returns int {
        if(counter == maxLimit){
            counter = 0;
        } else {
            counter++;
        }
        return counter;
    }

    public function back() returns int {
        if(counter == 0){
            counter = maxLimit;
        } else {
            counter--;
        }
        return counter;
    }
};