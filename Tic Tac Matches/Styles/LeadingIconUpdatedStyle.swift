//
//  LeadingIconUpdatedStyle.swift
//  Tic Tac Matches
//
//  Created by Joshua Figueroa on 8/22/23.
//

import SwiftUI

struct LeadingIconUpdatedStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == LeadingIconUpdatedStyle {
    static var leadingIcon: Self { Self() }
}
