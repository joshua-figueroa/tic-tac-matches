//
//  DetailView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var match: Match
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd h:mm a"
        return formatter
    }()
    
    var body: some View {
        List {
            Section(header: Text("Match Info")) {
                NavigationLink(destination: BoardView(match: $match)) {
                    Label("Start Match", systemImage: "play")
                        .font(.headline)
                }
                HStack {
                    Label("Board Size", systemImage: "checkerboard.rectangle")
                    Spacer()
                    Text("\(match.boardSize) x \(match.boardSize)")
                }
            }
            
            Section(header: Text("Players")) {
                ForEach(match.players) { player in
                    Label(player.name, systemImage: "person")
                }
            }
            
            Section(header: Text("Match History")) {
                if match.history.isEmpty {
                    Label("No matches yet", systemImage: "checkerboard.rectangle")
                }
                
                ForEach(match.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(dateFormatter.string(from: history.date))
                        }
                    }
                }
            }
        }
        .navigationTitle(match.title)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(match: .constant(Match.mockMatches[0]))
    }
}
