#ifndef __NUMBERGAME_H__
#define __NUMBERGAME_H__

#include "game.h"

class NumberGame
{
public:
    NumberGame();
    void start();
    void end();
    void onPlayerCommand(Player* player, const std::string& command);
    
private:
    void pickNumber();
    void announce();
    
    std::vector<Player*> players;
    int numberToGuess;
    int entranceFee;
    int prizePool;
};

#endif // __NUMBERGAME_H__
