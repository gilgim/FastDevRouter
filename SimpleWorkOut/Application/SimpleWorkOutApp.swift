//
//  SimpleWorkOutApp.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/24.
//

import SwiftUI

@main
struct SimpleWorkOutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, Persistent.shared.container.viewContext)
        }
    }
}
