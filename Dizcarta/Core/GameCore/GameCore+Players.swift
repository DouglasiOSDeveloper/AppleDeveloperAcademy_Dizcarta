//
//  GameCore+players.swift
//  Dizcarta
//
//  Created by Igor Samoel da Silva on 10/10/22.
//

import Foundation

extension GameCore {
    
    internal func getPlayers(match: MatchInProgress) -> [Player] {
        repository.getPlayers(match: match)
    }
    
    func fetchPlayers() {
        self.players = getPlayers(match: matchInProgress)
        self.objectWillChange.send()
    }
    
    func createPlayer(name: String, avatar: String) {
        if !players.contains(where: { $0.avatar == avatar }) {
            repository.createPlayer(name: name, avatar: avatar, match: matchInProgress)
        }
        self.players = repository.getPlayers(match: matchInProgress)
        self.objectWillChange.send()
    }
    
    func removePlayer(avatarName: String) {
        if let player = players.first(where: { $0.wrappedAvatar == avatarName }) {
            players.removeAll(where: { player.wrappedAvatar == $0.wrappedAvatar })
            repository.delete(object: player)
            players = repository.getPlayers(match: matchInProgress)
            self.objectWillChange.send()
        }
    }
     
    func resetMatch() {
        let players = getPlayers(match: matchInProgress)
        players.forEach { player in
            repository.delete(object: player)
        }
        self.players = []
        repository.delete(object: matchInProgress)
        repository.removeAllMatchesInProgress()
    }
    
    func getRandomCard() {
        guard var list = self.cardList?.cards, !list.isEmpty else { return}
        let card = list.remove(at: Int.random(in: 0...(list.count - 1)))
        self.cardList?.cards = list
        self.selectedCard = card
    }
    
    func removePlayerPoints(player: Player, points: Int) {
        repository.removePlayerPoints(player: player, points: points)
        if player.points == 0 {
            playerLost = PlayerLost(player: player, isLost: true)
        }
    }
    
    func addPlayerPoints(player: Player, points: Int) {
        repository.addPlayerPoints(player: player, points: points)
    }
    
    func transferPlayerPoints(from: Player, toPlayer: Player, points: Int) {
        removePlayerPoints(player: from, points: points)
        addPlayerPoints(player: toPlayer, points: points)
    }
    
    func getRanking() -> [Player] {
        repository.getRanking(match: matchInProgress)
    }
    
    func nextPlayer() {
        if playersTurn.isEmpty {
            playersTurn = getPlayers(match: matchInProgress).map({ Int64($0.turn) })
            playersTurn = playersTurn.sorted(by: { $0 < $1 })
            players = getPlayers(match: matchInProgress)
        }
        let turn = playersTurn.removeFirst()
        guard let player = players.first(where: { $0.turn == turn && $0.points > 0 })
        else {
            return nextPlayer()
        }
        playerPlaying = player
    }
    
    func verifyMatchIsEnded() {
        guard let cardList else { return }
        if cardList.cards.isEmpty {
            self.isGameFinished = true
            return
        }
        
        if players.filter({ $0.points > 0 }).count == 1 {
            self.isGameFinished = true
            return
        }
    }
}
