#include "casino.h"
#include "game.h"
#include <cstdlib>
#include <ctime>

Casino::Casino() : generatedNumber(0), totalPot(0), betAmount(1000) {
    srand(time(NULL));
}

void Casino::startRound() {
    generatedNumber = rand() % 500 + 1;
    totalPot = 0;
    bets.clear();
    winners.clear();
}

void Casino::placeBet(Player* player, int number) {
    if (player->getGold() < betAmount) {
        player->sendTextMessage(MSG_INFO, "You do not have enough gold to place a bet.");
        return;
    }
    
    player->removeGold(betAmount);
    totalPot += betAmount;
    bets[player] = number;
}

void Casino::endRound() {
    for (auto& bet : bets) {
        Player* player = bet.first;
        int guessedNumber = bet.second;
        if (guessedNumber == generatedNumber) {
            winners.push_back(player);
        }
    }
    
    distributeWinnings();
}

void Casino::distributeWinnings() {
    if (winners.empty()) {
        // No winners, carry the pot to the next round
        return;
    }
    
    int share = totalPot / winners.size();
    for (Player* winner : winners) {
        winner->addGold(share);
        winner->sendTextMessage(MSG_INFO, "Congratulations! You won the casino round.");
    }
}
