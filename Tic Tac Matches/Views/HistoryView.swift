//
//  HistoryView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/22/23.
//

import SwiftUI

struct HistoryView: View {
    var history: History
    var winnerIndex: Int
    var boardCap: CGFloat
    var cellSpacing: CGFloat
    
    init(history: History) {
        self.history = history
        if history.isTied {
            self.winnerIndex = -1
        } else {
            self.winnerIndex = history.players.firstIndex(of: history.winner!)! + 1
        }
        
        if history.boardSize == 3 {
            self.boardCap = 20
            self.cellSpacing = 20
        } else {
            self.boardCap = 12
            self.cellSpacing = 10
        }
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: cellSpacing), count: history.boardSize)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(spacing: 8) {
                    Label("Player", systemImage: "xmark")
                        .labelStyle(TrailingIconLabelStyle())
                        .font(.title2)
                        .foregroundColor(Theme.poppy.mainColor)
                    
                    Text(history.players[0].name)
                        .font(.title3)
                }
                Spacer()
                VStack(spacing: 8) {
                    Label("Player", systemImage: "circle")
                        .labelStyle(TrailingIconLabelStyle())
                        .font(.title2)
                        .foregroundColor(Theme.teal.mainColor)
                    
                    Text(history.players[1].name)
                        .font(.title3)
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 60)
            
            HStack(alignment: .center) {
                if history.isTied {
                    Text("Tied!")
                        .font(.title)
                } else {
                    Text("Winner:")
                        .font(.title)
                    Label("(\(history.winner!.name))", systemImage: getSystemImage(index: winnerIndex))
                        .labelStyle(.trailingIcon)
                        .foregroundColor(getColor(player: winnerIndex))
                        .font(.title)
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            
            VStack {
                GeometryReader { geometry in
                    let buttonSizeFull = geometry.size.width / CGFloat(history.boardSize)
                    let buttonSize = buttonSizeFull - boardCap
                    
                    LazyVGrid(columns: columns, spacing: cellSpacing) {
                        ForEach(Array(history.board.config.enumerated()), id: \.offset) { row, cols in
                            ForEach(Array(cols.enumerated()), id: \.offset) { col, cell in
                                Button(action: {}) {
                                    if cell > 0 {
                                        Image(systemName: getSystemImage(index: cell))
                                            .foregroundColor(getColor(player: cell))
                                            .font(history.boardSize == 3 ? .largeTitle : .title2)
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
            .padding()
            
            Spacer()
            .navigationTitle("Tic Tac Toe")
        }
    }
    
    private func getSystemImage(index: Int) -> String {
        if index == 1 {
            return "xmark"
        } else if index == 2 {
            return "circle"
        }

        return ""
    }
    
    private func getColor(player: Int) -> Color {
        return player == 1 ? Theme.poppy.mainColor : Theme.teal.mainColor
    }
    
    private func getStrokeColor(cell: Int, row: Int, col: Int) -> Color {
        if !history.isTied && history.board.winningCombo!.contains([row, col]) {
            return getColor(player: winnerIndex)
        }
        
        return .blue
    }
}

#Preview("History: 3x3") {
    HistoryView(history: History.mockHistory)
}

#Preview("History: 5x5") {
    HistoryView(history: History.mockHistoryTied)
}
