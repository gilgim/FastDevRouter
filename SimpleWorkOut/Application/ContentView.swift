//
//  ContentView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ExerciseView()
            }
            .tabItem {
                Image(systemName: "figure.run")
                Text("Exercise")
            }
            NavigationStack {
                RoutineView()
            }
            .tabItem {
                Image(systemName: "list.clipboard")
                Text("Routine")
            }
            NavigationStack {
                WorkHistoryView()
            }
            .tabItem {
                Image(systemName: "chart.bar.doc.horizontal")
                Text("Record")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
