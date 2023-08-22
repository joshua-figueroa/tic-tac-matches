//
//  TicTacMatchesApp.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

@main
struct TicTacMatchesApp: App {
    @StateObject private var store = MatchStore()
    @State private var matches = Match.mockMatches
    
    var body: some Scene {
        WindowGroup {
            MatchesView(matches: $store.matches) {
                Task {
                    do {
                        try await store.save(matches: store.matches)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .task {
                do {
                    try await store.load()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
