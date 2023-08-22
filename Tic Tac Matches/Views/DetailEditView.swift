//
//  DetailEditView.swift
//  tic-tac-toe
//
//  Created by Joshua Figueroa on 8/21/23.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var match: Match
    @State private var newPlayerName = ""
    let isEdit: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Match Info")) {
                TextField("Title", text: $match.title)
                if !isEdit {
                    HStack {
                        // Todo: Different board sizes
                        Slider(value: $match.boardSizeInDouble, in: 3...5, step: 1) {
                            Text("Board Size")
                        }
                        .disabled(true)
                        Spacer()
                        Text("\(match.boardSize) x \(match.boardSize) board size")
                            .accessibilityHidden(true)
                    }
                }
                ThemePicker(selection: $match.theme)
            }
            
            Section(header: Text("Players")) {
                ForEach(match.players) { player in
                    Text(player.name)
                        .disabled(isEdit)
                        .foregroundColor(isEdit ? .gray : .primary)
                }
                
                if match.players.count < 2 && !isEdit {
                    HStack {
                        TextField("New Player", text: $newPlayerName)
                        Button(action: {
                            withAnimation {
                                let player = Match.Player(name: newPlayerName)
                                match.players.append(player)
                                newPlayerName = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .accessibilityLabel("Add player")
                        }
                        .disabled(newPlayerName.isEmpty)
                    }
                }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(match: .constant(Match.mockMatches[0]), isEdit: false)
    }
}
