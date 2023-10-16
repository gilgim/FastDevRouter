//
//  ContentView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var selection = 0
    var body: some View {
        VStack {
            TabView(selection: $selection) {
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
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
