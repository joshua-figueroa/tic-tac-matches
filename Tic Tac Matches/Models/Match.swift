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
    var paused: Bool
    var pausedBoard: [[Int]]

    
    init(id: UUID = UUID(), title: String, size: Int, theme: Theme, players: [String], paused: Bool = false) {
        self.id = id
        self.title = title
        self.boardSize = size
        self.theme = theme
        self.players = players.map { Player(name: $0) }
        self.paused = paused
        self.pausedBoard = Array(repeating: Array(repeating: 0, count: size), count: size)
    }
    
    mutating func deletePausedBoard() {
        self.pausedBoard = Array(repeating: Array(repeating: 0, count: self.boardSize), count: self.boardSize)
    }
    
    mutating func updateBoardStatus(board: [[Int]]) {
        self.paused = board != Array(repeating: Array(repeating: 0, count: self.boardSize), count: self.boardSize)
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
        Match(title: "", size: 3, theme: .navy, players: [])
    }
}

extension Match {
    static let mockMatches: [Match] = [
        Match(title: "Love Match", size: 3, theme: .tan, players: ["Joshua", "Fiona"]),
        Match(title: "Dog Fight", size: 5, theme: .lavender, players: ["Dream", "Woody"], paused: true),
        Match(title: "Piggy Wrestle", size: 3, theme: .oxblood, players: ["Tootsie", "Olaf"])
    ]
}
