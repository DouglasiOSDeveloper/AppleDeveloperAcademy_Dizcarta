//
//  PlayerRepository.swift
//  Dizcarta
//
//  Created by Igor Samoel da Silva on 23/09/22.
//

import Foundation
import CoreData

protocol GameRepositoryProtocol: Repository {
    var context: NSManagedObjectContext { get set }
    var turnCount: Int { get set }
    
    func getPlayers(match: MatchInProgress) -> [Player]
    func createPlayer(name: String, avatar: String, match: MatchInProgress)
    func createMatch() -> MatchInProgress
    
    func removePlayerPoints(player: Player, points: Int)
    func addPlayerPoints(player: Player, points: Int)
    
    func getRanking(match: MatchInProgress) -> [Player]
    
}

extension GameRepositoryProtocol {
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("[SAVE CORE DATA]: ERROR TO SAVE CONTEXT")
            }
        }
    }
    func delete(object: NSManagedObject) {
        context.delete(object)
        save()
    }
}

final class PlayerRepositoryCoreData: GameRepositoryProtocol {
    
    var turnCount: Int = 0
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getPlayers(match: MatchInProgress) -> [Player] {
        do {
            let matches = try context.fetch(MatchInProgress.fetchRequest())
            print("matches \(matches)")
            guard let players = matches.first?.players?.allObjects as? [Player] else { return []}
            print("[CORE DATA]: GET PLAYERS \(players)")
            return players
        } catch {
            print("[CORE DATA]: ERRO TO GET PLAYERS")
        }
        return []
    }
    
    func createPlayer(name: String, avatar: String, match: MatchInProgress) {
        let player = Player(context: context)
        player.name = name
        player.avatar = avatar
        player.points = 0
        turnCount += 1
        player.turn = Int16(turnCount)
        save()
        print("[CORE DATA]: PLAYER CREATED \(player)")
    }
    
    func createMatch() -> MatchInProgress {
        let matchInProgress = MatchInProgress(context: context)
        matchInProgress.dizDate = Date()
        save()
        return matchInProgress
    }
    
    func removePlayerPoints(player: Player, points: Int) {
        player.points -= Int16(points)
        save()
    }
    
    func addPlayerPoints(player: Player, points: Int) {
        player.points += Int16(points)
        save()
    }
    
    func getRanking(match: MatchInProgress) -> [Player] {
        getPlayers(match: match).sorted(by: { $0.points > $1.points })
    }
    
    
}

final class PlayerRepositoryMock: GameRepositoryProtocol {
    
    var turnCount: Int = 0
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = PersistenceController.inMemoryContext
    }
    
    func getPlayers(match: MatchInProgress) -> [Player] {
        do {
            let matches = try context.fetch(MatchInProgress.fetchRequest())
            print("matches \(matches)")
            guard let players = matches.first?.players?.allObjects as? [Player] else { return []}
            print("[CORE DATA]: GET PLAYERS \(players)")
            return players.sorted(by: { $0.points > $1.points })
        } catch {
            print("[CORE DATA]: ERRO TO GET PLAYERS")
        }
        return []
    }
    
    func createPlayer(name: String, avatar: String, match: MatchInProgress) {
        let player = Player(context: context)
        player.name = name
        player.avatar = avatar
        player.points = 0
        turnCount += 1
        player.turn = Int16(turnCount)
        player.matchInProgress = match
        print("[CORE DATA]: PLAYER CREATED \(player)")
        save()
    }
    
    func createMatch() -> MatchInProgress {
        let matchInProgress = MatchInProgress(context: context)
        matchInProgress.dizDate = Date()
        save()
        return matchInProgress
    }
    
    func removePlayerPoints(player: Player, points: Int) {
        player.points -= Int16(points)
        save()
    }
    
    func addPlayerPoints(player: Player, points: Int) {
        player.points += Int16(points)
        save()
    }
    
    func getRanking(match: MatchInProgress) -> [Player] {
        getPlayers(match: match).sorted(by: { $0.points > $1.points })
    }
    
}

final class PlayerRepository {
    static func get(context: NSManagedObjectContext) -> GameRepositoryProtocol {
        AppConfig.isMocked ? PlayerRepositoryMock(context: context) : PlayerRepositoryCoreData(context: context)
    }
}