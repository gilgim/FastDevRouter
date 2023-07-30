//
//  SimpleWorkOutApp.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/24.
//

import SwiftUI

@main
struct SimpleWorkOutApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Persistent.shared.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                AppLifecycleManager.shared.appState.send(.active)
            case .inactive:
                AppLifecycleManager.shared.appState.send(.inactive)
            case .background:
                AppLifecycleManager.shared.appState.send(.background)
            @unknown default:
                break
            }
        }
    }
}
