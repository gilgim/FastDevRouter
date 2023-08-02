//
//  RoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct RoutineView: View {
    @ObservedObject private var viewModel = RoutineViewModel()
    @State private var isShowAddRoutineView: Bool = false
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.routines, id: \.name) { routine in
                    HStack {
                        Text(routine.name)
                        if let type = routine.type {
                            Text(type)
                        }
                        Text("exercise : \(routine.exercises.count)")
                    }
                    .swipeActions {
                        Button {
                            viewModel.delectRoutine(name: routine.name)
                        }label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .onAppear() {
            viewModel.fetchRoutines()
        }
        .navigationDestination(isPresented: $isShowAddRoutineView, destination: {
            
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddRoutineView()
                }label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RoutineView()
        }
    }
}
