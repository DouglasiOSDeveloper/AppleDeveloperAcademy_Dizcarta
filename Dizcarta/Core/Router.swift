//
//  Router.swift
//  Dizcarta
//
//  Created by Igor Samoel da Silva on 17/11/22.
//

import Foundation

enum Screen: Hashable {
    case home
    case setupMatch
    case shiftPlayer
    case acceptRefuse
    case gameOver
    case ranking
    case gamePaused
    case configuration
    case inGame
    case shuffleAnimation
    case rules
}

final class Router: ObservableObject {
    @Published var path: [Screen] = []
    @Published var gameCore: GameCore!
    func goToRoot() {
        path = .init()
    }
    
    func pushView(screen: Screen) {
        path.append(screen)
    }
    
    func newGame() {
        path.removeAll()
        path.append(.setupMatch)
    }
    
    func popView(screen: Screen? = nil) {
        if let screen {
            path.removeAll(where: {$0 == screen})
        } else {
            path.removeLast()
        }
    }
}