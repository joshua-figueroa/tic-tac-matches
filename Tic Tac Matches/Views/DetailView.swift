//
//  DetailView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var match: Match
    @State private var editingMatch = Match.emptyMatch
    @State private var isPresentingEditView = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd h:mm a"
        return formatter
    }()
    
    var body: some View {
        List {
            Section(header: Text("Match Info")) {
                if match.paused {
                    NavigationLink(destination: BoardView(match: $match, newMatch: false)) {
                        Label("Resume Match", systemImage: "playpause")
                            .font(.headline)
                    }
                }
                NavigationLink(destination: BoardView(match: $match, newMatch: true)) {
                    Label(match.paused ? "Start New Match" : "Start Match", systemImage: "play")
                        .font(match.paused ? .body : .headline)
                }
                HStack {
                    Label("Board Size", systemImage: "checkerboard.rectangle")
                    Spacer()
                    Text("\(match.boardSize) x \(match.boardSize)")
                }
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(match.theme.name)
                        .padding(4)
                        .foregroundColor(match.theme.accentColor)
                        .background(match.theme.mainColor)
                        .cornerRadius(4)
                }
            }
            
            Section(header: Text("Players")) {
                ForEach(Array(match.players.enumerated()), id: \.offset) { index, player in
                    HStack {
                        Label(player.name, systemImage: "person")
                        Spacer()
                        Image(systemName: index == 0 ? "xmark" : "circle")
                            .foregroundColor(index == 0 ? Theme.poppy.mainColor : Theme.teal.mainColor)
                    }
                }
            }
            
            Section(header: Text("Match History")) {
                if match.history.isEmpty {
                    Label("No matches yet", systemImage: "checkerboard.rectangle")
                }
                
                ForEach(match.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HistoryListView(history: history, theme: match.theme)
                    }
                }
            }
        }
        .navigationTitle(match.title)
        .toolbar() {
            Button("Edit") {
                isPresentingEditView = true
                editingMatch = match
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationStack {
                DetailEditView(match: $editingMatch, isEdit: true)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                match = editingMatch
                            }
                        }
                    }
                    .navigationTitle(match.title)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(match: .constant(Match.mockMatches[1]))
    }
}
