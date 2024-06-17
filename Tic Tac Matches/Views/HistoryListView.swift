//
//  HistoryListView.swift
//  Tic Tac Matches
//
//  Created by Joshua Figueroa on 6/14/24.
//

import SwiftUI

struct HistoryListView: View {
    var history: History
    var theme: Theme
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd h:mm a"
        return formatter
    }()
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text(dateFormatter.string(from: history.date))
            Spacer()
            Image(systemName: history.isTied ? "equal.circle.fill" : getPlayerIcon(index: history.winnerIndex))
                .foregroundColor(history.isTied ? theme.mainColor : getPlayerColor(index: history.winnerIndex))
        }
    }
    
    private func getPlayerIcon(index: Int) -> String {
        return index == 1 ? "xmark" : "circle"
    }
    
    private func getPlayerColor(index: Int) -> Color {
        return index == 1 ? Theme.poppy.mainColor : Theme.teal.mainColor
    }
}

#Preview("Winner") {
    HistoryListView(history: History.mockHistory, theme: Theme.navy)
        .previewLayout(.fixed(width: 400, height: 60))
}

#Preview("Tied") {
    HistoryListView(history: History.mockHistoryTied, theme: Theme.indigo)
        .previewLayout(.fixed(width: 400, height: 60))
}
