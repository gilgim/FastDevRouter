//
//  RoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct RoutineView: View {
    @ObservedObject private var viewModel = RoutineViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.routines, id: \.id) { routine in
                    HStack {
                        RoutineContentView(routine: .constant(routine))
                        Spacer()
                        Button{
                            viewModel.setSelectRoutine(selectRoutine: routine)
                        }label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
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
        .navigationDestination(isPresented: $viewModel.isWorkOut, destination: {
            if let selectRoutine = viewModel.selectRoutine {
                WorkOutRoutineView(viewModel: .init(selectRoutine: selectRoutine))
            }
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

struct RoutineContentView: View {
    @State var isShowExercises: Bool = false
    @Binding var routine: (id: UUID, name: String, type: String?, exercises: [WorkOutByExercise])
    var body: some View {
        VStack {
            HStack {
                Text(routine.name)
                if let type = routine.type {
                    Text(type)
                }
                Text("exercise : \(routine.exercises.count)")
                Button {
                    withAnimation {
                        isShowExercises.toggle()
                    }
                }label: {
                    Image(systemName: isShowExercises ? "chevron.up" : "chevron.down")
                }
            }
            if isShowExercises {
                ForEach(routine.exercises, id: \.id) { exercise in
                    HStack {
                        Text(exercise.name)
                        Text(exercise.type)
                        Text("\(exercise.set)")
                        Text("\(Util.intToSecond(intTime: exercise.rest))")
                    }
                }
            }
        }
    }
}
