//
//  TicTacMatchesApp.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

@main
struct TicTacMatchesApp: App {
    @State private var matches = Match.mockMatches
    var body: some Scene {
        WindowGroup {
//            ContentView()
            MatchesView(matches: $matches)
        }
    }
}
