//
//  BoardView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI
import ActivityKit

struct BoardView: View {
    @Binding var match: Match
    @State private var board: [[Int]]
    @State private var currentPlayer = 1
    @State private var showAlert = false
    @State private var winningCombo: [[Int]]?
    @State private var isTied = false
    @State private var activity: Activity<CurrentMatchAttributes>? = nil
    @State private var activityId: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    var boardCap: CGFloat
    var cellSpacing: CGFloat
    let newMatch: Bool
    
    init(match: Binding<Match>, newMatch: Bool) {
        self._match = match
        self.newMatch = newMatch
        if newMatch {
            self._board = State(initialValue: Array(repeating: Array(repeating: 0, count: match.wrappedValue.boardSize), count: match.wrappedValue.boardSize))
        } else {
            self._board = State(initialValue: match.wrappedValue.pausedBoard)
        }
        
        if match.wrappedValue.boardSize == 3 {
            self.boardCap = 20
            self.cellSpacing = 20
        } else {
            self.boardCap = 12
            self.cellSpacing = 10
        }
        
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: cellSpacing), count: match.boardSize)
    }
    
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
                GeometryReader { geometry in
                    let buttonSizeFull = geometry.size.width / CGFloat(match.boardSize)
                    let buttonSize = buttonSizeFull - boardCap
                    
                    LazyVGrid(columns: columns, spacing: cellSpacing) {
                        ForEach(Array(board.enumerated()), id: \.offset) { row, cols in
                            ForEach(Array(cols.enumerated()), id: \.offset) { col, cell in
                                Button(action: {
                                    printCell(row: row, col: col)
                                }) {
                                    if cell > 0 {
                                        Image(systemName: getSystemImage(cellCount: cell))
                                            .foregroundColor(getColor(player: cell))
                                            .font(match.boardSize == 3 ? .largeTitle : .title2)
                                    } else {
                                        Text("")
                                            .padding()
                                    }
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(getStrokeColor(cell: cell, row: row, col: col), lineWidth: 2))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Tic Tac Toe")
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Tic Tac Ding!"),
                message: Text(getAlertMsg()),
                primaryButton: .destructive(Text("Reset")) {
                    resetActivity()
                    resetBoard()
                },
                secondaryButton: .default((Text("Save"))) {
                    resetActivity()
                    saveBoard()
                }
            )
        }
        .onAppear() {
            if newMatch {
                match.deletePausedBoard()
                match.paused = false
            }
            
            do {
                activityId = try LiveActivityManager.startActivity(currentPlayer, match.players[currentPlayer - 1].name, getSystemImage(cellCount: currentPlayer),
                match.title)
            } catch {
                print(error.localizedDescription)
            }
        }
        .onDisappear() {
            if showAlert {
                match.deletePausedBoard()
            } else {
                match.pausedBoard = board
            }
            resetActivity()
        }
        .onChange(of: board) { newBoard in
            match.updateBoardStatus(board: newBoard)
        }
        .onChange(of: showAlert) { newShowAlert in
            if newShowAlert {
                match.paused = false
            }
        }
    }
    
    private func printCell(row: Int, col: Int) {
        board[row][col] = currentPlayer
        checkWinner()
        if !showAlert {
            currentPlayer = currentPlayer == 1 ? 2 : 1
            Task {
                await LiveActivityManager.updateActivity(id:activityId, currentPlayer ,match.players[currentPlayer - 1].name, getSystemImage(cellCount: currentPlayer), match.title)
            }
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
        let boardSize = match.boardSize
        
        // Check diagonals
        if (0..<boardSize).allSatisfy({ board[$0][$0] == board[0][0] && board[0][0] != 0 }) {
            showAlert = true
            winningCombo = (0..<boardSize).map { [$0, $0] }
        } else if (0..<boardSize).allSatisfy({ board[$0][boardSize - 1 - $0] == board[0][boardSize - 1] && board[0][boardSize - 1] != 0 }) {
            showAlert = true
            winningCombo = (0..<boardSize).map { [$0, boardSize - 1 - $0] }
        }
        
        // Check rows and columns
        for i in 0..<boardSize {
            // Check row
            if (0..<boardSize).allSatisfy({ board[i][$0] == board[i][0] && board[i][0] != 0 }) {
                showAlert = true
                winningCombo = (0..<boardSize).map { [i, $0] }
            }
            // Check column
            else if (0..<boardSize).allSatisfy({ board[$0][i] == board[0][i] && board[0][i] != 0 }) {
                showAlert = true
                winningCombo = (0..<boardSize).map { [$0, i] }
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
        board = Array(repeating: Array(repeating: 0, count: match.boardSize), count: match.boardSize)
        currentPlayer = 1
        showAlert = false
    }
    
    private func saveBoard() {
        var history: History
        
        if isTied {
            history = History(players: match.players, size: match.boardSize, board: Board(config: board))
        } else {
            history = History(players: match.players, winner: match.players[currentPlayer - 1], index: currentPlayer, size: match.boardSize, board: Board(config: board, winningCombo: winningCombo!))
        }
        
        match.history.insert(history, at: 0)
        dismiss()
    }
    
    private func checkForTie() -> Bool {
        if board.flatMap({ $0 }).contains(0) {
            return false
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
    
    private func resetActivity() {
        Task {
            await LiveActivityManager.endActivity()
        }
    }
}

#Preview("Board: 3x3") {
    BoardView(match: .constant(Match.mockMatches[0]), newMatch: true)
}

#Preview("Board: 5x5") {
    BoardView(match: .constant(Match.mockMatches[1]), newMatch: true)
}
