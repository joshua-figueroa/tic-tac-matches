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
    
    init(history: History) {
        self.history = history
        self.winnerIndex = history.players.firstIndex(of: history.winner)! + 1
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
                Text("Winner:")
                    .font(.title)
                Label("(\(history.winner.name))", systemImage: getSystemImage(index: winnerIndex))
                    .labelStyle(.trailingIcon)
                    .foregroundColor(getColor(player: winnerIndex))
                    .font(.title)
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            
            VStack {
                ForEach(Array(history.board.config.enumerated()), id: \.offset) { row, cols in
                    HStack {
                        ForEach(Array(cols.enumerated()), id: \.offset) { col, cell in
                            Button(action: {}) {
                                if cell > 0 {
                                    Image(systemName: getSystemImage(index: cell))
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
                            .disabled(true)
                        }
                    }
                }
            }
            
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
        if history.board.winningCombo.contains([row, col]) {
            return getColor(player: winnerIndex)
        }
        
        return .blue
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History.mockHistory)
    }
}
