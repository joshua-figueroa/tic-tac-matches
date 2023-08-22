//
//  History.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var players: [Match.Player]
    var winner: Match.Player
    var boardSize: Int
    var board: Board
    
    init(id: UUID = UUID(), date: Date = Date(), players: [Match.Player], winner: Match.Player, size: Int, board: Board) {
        self.id = id
        self.date = date
        self.players = players
        self.winner = winner
        self.boardSize = size
        self.board = board
    }
}

extension History {
    static var mockHistory = History(players: Match.mockMatches[0].players, winner: Match.mockMatches[0].players[0], size: 3, board: Board.mockBoard)
}
