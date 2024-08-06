#include "numbergame.h"
#include "player.h"
#include "protocol.h"

NumberGame::NumberGame() : numberToGuess(0), entranceFee(500), prizePool(0)
{
}

void NumberGame::start()
{
    // Verificar jogadores online e dividir pela metade
    players = Game::getInstance().getPlayers();
    if (players.size() < 2) {
        // Não há jogadores suficientes para iniciar o evento
        return;
    }

    // Escolher um número aleatório
    pickNumber();
    announce();
}

void NumberGame::end()
{
    // Determinar o vencedor e pagar o prêmio
    for (Player* player : players) {
        if (player->getNumber() == numberToGuess) {
            player->addMoney(prizePool);
            break;
        }
    }
    
    // Limpar o evento
    players.clear();
    numberToGuess = 0;
    prizePool = 0;
}

void NumberGame::onPlayerCommand(Player* player, const std::string& command)
{
    if (command == "join")
    {
        if (player->getMoney() < entranceFee) {
            player->sendTextMessage("Você não tem dinheiro suficiente para participar.");
            return;
        }
        
        player->removeMoney(entranceFee);
        prizePool += entranceFee;
        players.push_back(player);
    }
    else if (command.find("guess") == 0)
    {
        int guessedNumber = std::stoi(command.substr(6)); // Assumindo o comando no formato "guess <numero>"
        
        if (guessedNumber == numberToGuess) {
            // O jogador adivinhou corretamente
            player->addMoney(prizePool);
            end();
        } else {
            player->sendTextMessage("Você adivinhou o número errado.");
        }
    }
}

void NumberGame::pickNumber()
{
    numberToGuess = rand() % 100 + 1; // Escolhe um número entre 1 e 100
}

void NumberGame::announce()
{
    std::string message = "Um novo evento começou! Adivinhe o número entre 1 e 100 para ganhar o prêmio!";
    for (Player* player : players) {
        player->sendTextMessage(message);
    }
}
