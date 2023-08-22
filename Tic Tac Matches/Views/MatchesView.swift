//
//  MatchesView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct MatchesView: View {
    @Binding var matches: [Match]
    @State private var newMatch = false
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                if matches.isEmpty {
                    ScrollView {
                        Text("\(isFirstLaunch ? "Welcome to Tic Tac Matches – the ultimate destination for timeless gaming excitement! It revamps the timeless Tic Tac Toe game with a fresh and modern approach." : "Hmmm... seems that you don't have an active match yet.") Click the + button to add a match and start playing!")
                            .padding()
                            .font(isFirstLaunch ? .headline : .callout)
                            .foregroundColor(.gray)
                    }
                }
                List($matches, editActions: .delete) { $match in
                    NavigationLink(destination: DetailView(match: $match)) {
                        CardView(match: match)
                    }
                    .listRowBackground(match.theme.mainColor)
                }
            }
            .navigationTitle("Tic Tac Matches")
            .toolbar {
                Button(action: {
                    newMatch = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Match")
            }
        }
        .sheet(isPresented: $newMatch) {
            NewMatchSheet(matches: $matches, isPresent: $newMatch)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveAction()
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView(matches: .constant([]), saveAction: {})
    }
}
