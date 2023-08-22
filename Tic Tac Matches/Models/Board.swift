//
//  Board.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import Foundation

struct Board: Identifiable, Codable {
    let id: UUID
    var config: [[Int]]
    var winningCombo: [[Int]]?
    
    init(id: UUID = UUID(), config: [[Int]], winningCombo: [[Int]]) {
        self.id = id
        self.config = config
        self.winningCombo = winningCombo
    }
    
    init(id: UUID = UUID(), config: [[Int]]) {
        self.id = id
        self.config = config
    }
}

extension Board {
    static var mockBoard = Board(config: [[1, 1, 2], [0, 1, 2], [0, 0, 2]], winningCombo: [[0, 0], [1, 0], [2, 0]])
}
