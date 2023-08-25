//
//  CurrentMatchAttributes.swift
//  Tic Tac Matches
//
//  Created by Joshua Figueroa on 8/26/23.
//

import ActivityKit

struct CurrentMatchAttributes: ActivityAttributes {
    public typealias CurrentMatchStatus = ContentState
    public struct ContentState: Codable, Hashable {
        var index: Int
        var name: String
        var icon: String
        var theme: String
        var title: String
    }
}
