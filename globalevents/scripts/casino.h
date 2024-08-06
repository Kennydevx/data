#ifndef CASINO_H
#define CASINO_H

#include "player.h"
#include <vector>
#include <unordered_map>

class Casino {
public:
    Casino();
    void startRound();
    void placeBet(Player* player, int number);
    void endRound();
    void distributeWinnings();

private:
    int generatedNumber;
    int totalPot;
    int betAmount;
    std::unordered_map<Player*, int> bets; // Player and their guessed number
    std::vector<Player*> winners;
};

#endif // CASINO_H
