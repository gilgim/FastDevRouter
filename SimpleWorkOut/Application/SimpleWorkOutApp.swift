//
//  SimpleWorkOutApp.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/24.
//

import SwiftUI
import AVFoundation

@main
struct SimpleWorkOutApp: App {
    @Environment(\.scenePhase) private var scenePhase
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted!")
            } else {
                print("Notification authorization denied because: \(String(describing: error))")
            }
        }
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        Log.logLocale.printProperty
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Persistent.shared.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App Active")
                AppLifecycleManager.shared.appState.send(.active)
            case .inactive:
                print("App Inactive")
                AppLifecycleManager.shared.appState.send(.inactive)
            case .background:
                print("App Background")
                AppLifecycleManager.shared.appState.send(.background)
            @unknown default:
                break
            }
        }
    }
}
