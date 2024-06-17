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
    var winner: Match.Player?
    var winnerIndex: Int
    var boardSize: Int
    var board: Board
    var isTied: Bool
    
    init(id: UUID = UUID(), date: Date = Date(), players: [Match.Player], winner: Match.Player, index: Int, size: Int, board: Board) {
        self.id = id
        self.date = date
        self.players = players
        self.winner = winner
        self.winnerIndex = index
        self.boardSize = size
        self.board = board
        self.isTied = false
    }
    
    init(id: UUID = UUID(), date: Date = Date(), players: [Match.Player], size: Int, board: Board) {
        self.id = id
        self.date = date
        self.players = players
        self.boardSize = size
        self.board = board
        self.isTied = true
        self.winnerIndex = 0
    }
}

extension History {
    static var mockHistory = History(players: Match.mockMatches[0].players, winner: Match.mockMatches[0].players[0], index: 1, size: 3, board: Board.mockBoard)
    static var mockHistoryTied = History(players: Match.mockMatches[0].players, size: 3, board: Board.mockBoardTied)
}
