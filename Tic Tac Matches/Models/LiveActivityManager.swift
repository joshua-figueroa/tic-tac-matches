//
//  LiveActivityManager.swift
//  Tic Tac Matches
//
//  Created by Joshua Figueroa on 8/26/23.
//

import Foundation
import ActivityKit

enum LiveActivityManagerError: Error {
    case failedToGetId
}

@available(iOS 16.1, *)
class LiveActivityManager {
    @discardableResult
    static func startActivity(_ index: Int, _ name: String, _ icon: String, _ title: String) throws -> String {
        var activity: Activity<CurrentMatchAttributes>?
        let initialState = CurrentMatchAttributes.ContentState(index: index, name: name, icon: icon, theme: "poppy", title: title)
        let content = ActivityContent(state: initialState, staleDate: .now.addingTimeInterval(5 * 60))
        do {
            activity = try Activity.request(attributes: CurrentMatchAttributes(), content: content, pushType: nil)
            guard let id = activity?.id else { throw LiveActivityManagerError.failedToGetId }
            return id
        } catch {
            throw error
        }
    }
    
    static func updateActivity(id: String, _ index: Int, _ name: String, _ icon: String, _ title: String) async {
        let theme = index == 1 ? "poppy" : "teal"
        let updatedContentState = CurrentMatchAttributes.ContentState(index: index, name: name, icon: icon, theme: theme, title: title)
        let activity = Activity<CurrentMatchAttributes>.activities.first(where: { $0.id == id })
        let content = ActivityContent(state: updatedContentState, staleDate: .now.addingTimeInterval(5 * 60))
        await activity?.update(content)
    }
    
    static func endActivity() async {
        let state = CurrentMatchAttributes.ContentState(index: 0, name: "", icon: "", theme: "", title: "")
        let content = ActivityContent(state: state, staleDate: .now)
        for activity in Activity<CurrentMatchAttributes>.activities {
            await activity.end(content, dismissalPolicy: .immediate)
        }
    }
}
