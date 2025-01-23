//
//  GithubActionsPlaygroundApp.swift
//  GithubActionsPlayground
//
//  Created by Cookie-san on 2025/01/23.
//

import SwiftUI

@main
struct GithubActionsPlaygroundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
