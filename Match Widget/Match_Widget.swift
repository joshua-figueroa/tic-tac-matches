//
//  Match_Widget.swift
//  Match Widget
//
//  Created by Joshua Figueroa on 8/26/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Match_Widget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CurrentMatchAttributes.self) { context in
            VStack {
                Text("Resume \(context.state.title) Match")
                    .padding(.bottom, 3)
                HStack {
                    Text("Turn: Player")
                    Image(systemName: context.state.icon)
                        .foregroundColor(Color(context.state.theme))
                    Text("(\(context.state.name))")
                }
            }
            .padding()
            .activityBackgroundTint(Color.clear)
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "checkerboard.rectangle")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                        .padding(.leading, 6)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: context.state.icon)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.trailing, 6)
                        .foregroundColor(Color(context.state.theme))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text("\(context.state.title) Match")
                            .padding(.bottom, 3)
                            .font(.title3)
                        HStack {
                            Text("Turn: \(context.state.name)")
                                .font(.headline)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "checkerboard.rectangle")
            } compactTrailing: {
                Image(systemName: context.state.icon)
                    .foregroundColor(Color(context.state.theme))
            } minimal: {
                Image(systemName: "checkerboard.rectangle")
                    .foregroundColor(Color(context.state.theme))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color(context.state.theme))
        }
    }
}

struct Match_Widget_Previews: PreviewProvider {
    static let attributes = CurrentMatchAttributes()
    static let contentState = CurrentMatchAttributes.ContentState(index: 1, name: "Joshua", icon: "xmark", theme: "teal", title: "Capy Wrestle")

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
