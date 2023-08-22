//
//  Match.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import Foundation

struct Match: Identifiable, Codable {
    let id: UUID
    var title: String
    var theme: Theme
    var boardSize: Int
    var boardSizeInDouble: Double {
        get {
           Double(boardSize)
       }
        set {
            boardSize = Int(newValue)
        }
    }
    var players: [Player]
    var history: [History] = []
    
    init(id: UUID = UUID(), title: String, size: Int, theme: Theme, players: [String]) {
        self.id = id
        self.title = title
        self.boardSize = size
        self.theme = theme
        self.players = players.map { Player(name: $0) }
    }
}

extension Match {
    struct Player: Identifiable, Codable, Equatable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
    
    static var emptyMatch: Match {
        Match(title: "", size: 3, theme: .sky, players: [])
    }
}

extension Match {
    static let mockMatches: [Match] = [
        Match(title: "Love Match", size: 3, theme: .tan, players: ["Joshua", "Fiona"]),
        Match(title: "Dog Fight", size: 3, theme: .lavender, players: ["Dream", "Woody"]),
        Match(title: "Piggy Wrestle", size: 3, theme: .oxblood, players: ["Tootsie", "Olaf"])
    ]
}
