//
//  NewMatchSheet.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct NewMatchSheet: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var newMatch = Match.emptyMatch
    @Binding var matches: [Match]
    @Binding var isPresent: Bool
    
    var body: some View {
        NavigationStack {
            DetailEditView(match: $newMatch, isEdit: false)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresent = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            if !newMatch.title.isEmpty && newMatch.players.count == 2 {
                                matches.append(newMatch)
                            }
                            isPresent = false
                            isFirstLaunch = false
                        }
                    }
                }
        }
    }
}

struct NewMatchSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchSheet(matches: .constant(Match.mockMatches), isPresent: .constant(true))
    }
}
