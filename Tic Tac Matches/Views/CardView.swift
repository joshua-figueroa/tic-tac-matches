//
//  CardView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct CardView: View {
    let match: Match
    var body: some View {
        VStack(alignment: .leading) {
            Text(match.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(match.players.map { $0.name }.joined(separator: ", "))", systemImage: "person.2")
                    .labelStyle(.leadingIcon)
                Spacer()
                Label("\(match.boardSize)", systemImage: "checkerboard.rectangle")
                    .labelStyle(.trailingIcon)
            }
            .padding(.trailing, 10)
            .font(.caption)
        }
        .padding(.vertical)
        .foregroundColor(match.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var match = Match.mockMatches[0]
    static var previews: some View {
        CardView(match: match)
            .background(match.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
