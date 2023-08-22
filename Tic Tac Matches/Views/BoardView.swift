//
//  BoardView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct BoardView: View {
    @Binding var match: Match
    @State private var board: [[Int]] = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    @State private var currentPlayer = 1
    @State private var showAlert = false
    @State private var winningCombo: [[Int]]?
    @State private var isTied = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            
            HStack {
                VStack(spacing: 8) {
                    Label("Player", systemImage: "xmark")
                        .labelStyle(TrailingIconLabelStyle())
                        .font(.title2)
                        .foregroundColor(Theme.poppy.mainColor)
                    
                    Text(match.players[0].name)
                        .font(.title3)
                }
                Spacer()
                VStack(spacing: 8) {
                    Label("Player", systemImage: "circle")
                        .labelStyle(TrailingIconLabelStyle())
                        .font(.title2)
                        .foregroundColor(Theme.teal.mainColor)
                    
                    Text(match.players[1].name)
                        .font(.title3)
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 60)
            
            Label("Turn", systemImage: getSystemImage(cellCount: currentPlayer))
                .foregroundColor(getColor(player: currentPlayer))
                .font(.title)
                .padding(.top, 30)
                .padding(.bottom, 20)
            
            VStack {
                ForEach(Array(board.enumerated()), id: \.offset) { row, cols in
                    HStack {
                        ForEach(Array(cols.enumerated()), id: \.offset) { col, cell in
                            Button(action: {printCell(row: row, col: col)}) {
                                if cell > 0 {
                                    Image(systemName: getSystemImage(cellCount: cell))
                                        .foregroundColor(getColor(player: cell))
                                        .font(.largeTitle)
                                } else {
                                    Text("")
                                        .padding()
                                }
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(getStrokeColor(cell: cell, row: row, col: col), lineWidth: 2))
                            .padding(5)
                        }
                    }
                }
            }
            
            Spacer()
            .navigationTitle("Tic Tac Toe")
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Tic Tac Ding!"),
                message: Text(getAlertMsg()),
                primaryButton: .destructive(Text("Reset")) {
                    resetBoard()
                },
                secondaryButton: .default((Text("Save"))) {
                    saveBoard()
                }
            )
        }
    }
    
    private func printCell(row: Int, col: Int) {
        board[row][col] = currentPlayer
        checkWinner()
        if !showAlert {
            currentPlayer = currentPlayer == 1 ? 2 : 1
        }
    }
    
    private func getColor(player: Int) -> Color {
        return player == 1 ? Theme.poppy.mainColor : Theme.teal.mainColor
    }
    
    private func getSystemImage(cellCount: Int) -> String {
        if cellCount == 1 {
            return "xmark"
        } else if cellCount == 2 {
            return "circle"
        }

        return ""
    }
    
    private func checkWinner() {
        // Check diagonal
        if board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[2][2] != 0 {
            showAlert = true
            winningCombo = [[0, 0], [1, 1], [2, 2]]
        } else if board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[2][0] != 0 {
            showAlert = true
            winningCombo = [[0, 2], [1, 1], [2, 0]]
        }
        
        for i in 0..<3 {
            // Check horizontal
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][2] != 0 {
                showAlert = true
                winningCombo = [[i, 0], [i, 1], [i, 2]]
            }
            // Check vertical
            else if board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[2][i] != 0 {
                showAlert = true
                winningCombo = [[0, i], [1, i], [2, i]]
            }
        }
        
        if !showAlert {
            isTied = checkForTie()
        }
    }
    
    private func getStrokeColor(cell: Int, row: Int, col: Int) -> Color {
        guard let combo = winningCombo else {return .blue}
        
        if showAlert && combo.contains([row, col]) {
            return getColor(player: currentPlayer)
        }
        
        return .blue
    }
    
    private func resetBoard() {
        board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        currentPlayer = 1
        showAlert = false
    }
    
    private func saveBoard() {
        var history: History
        
        if isTied {
            history = History(players: match.players, size: match.boardSize, board: Board(config: board))
        } else {
            history = History(players: match.players, winner: match.players[currentPlayer - 1], size: match.boardSize, board: Board(config: board, winningCombo: winningCombo!))
        }
        
        match.history.insert(history, at: 0)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func checkForTie() -> Bool {
        for row in board {
            for col in row {
                if col == 0 {
                    return false
                }
            }
        }
        showAlert = true
        return true
    }
    
    private func getAlertMsg() -> String {
        if isTied {
            return "You are tied!"
        }
        return "\(match.players[currentPlayer - 1].name) (Player \(currentPlayer == 1 ? "X" : "O")) Won!"
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(match: .constant(Match.mockMatches[0]))
    }
}
