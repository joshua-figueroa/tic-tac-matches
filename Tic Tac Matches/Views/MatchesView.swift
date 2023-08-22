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
    var body: some View {
        NavigationStack {
            VStack {
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
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView(matches: .constant(Match.mockMatches))
    }
}
