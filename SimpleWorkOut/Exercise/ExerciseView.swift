//
//  ExerciseView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import SwiftUI

struct ExerciseView: View {
    @ObservedObject private var viewModel = ExerciseViewModel()
    
    @State private var exerciseNameInput: String = ""
    @State private var exerciseTypeInput: String = ""
    @State private var setInput: String = ""
    @State private var restInput: String = ""
    @State private var isAlertEnable: Bool = false {
        didSet {
            exerciseNameInput = ""
            exerciseTypeInput = ""
        }
    }
    @State private var isWorkOut: Bool = false {
        didSet {
            setInput = ""
            restInput = ""
        }
    }
    @State private var isShowWorkOutView: Bool = false
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.exercises, id: \.name) { exercise in
                    HStack {
                        Text(exercise.name)
                        Text(exercise.type)
                        Button("") {
                            viewModel.setSelectExerciseSetAndRest(name: exercise.name, type: exercise.type)
                            isWorkOut = true
                        }
                    }
                    .swipeActions {
                        Button {
                            viewModel.delectExercise(name: exercise.name)
                        }label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .onAppear() {
            viewModel.fetchExercises()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAlertEnable.toggle()
                }label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Create Exercise", isPresented: $isAlertEnable) {
            TextField("Please input exercise name.", text: $exerciseNameInput)
            TextField("Please input exercise type.", text: $exerciseTypeInput)
            Button("Cancle", role: .cancel) {}
            Button("OK") {
                viewModel.createExercise(name: exerciseNameInput, type: exerciseTypeInput)
            }
        }
        .alert("Setup Set and Rest", isPresented: $isWorkOut) {
            TextField("Please input exercise set", text: $setInput)
            TextField("Please input exercise rest time.", text: $restInput)
            Button("Cancle", role: .cancel) {}
            Button("OK") {
                viewModel.setSelectExerciseSetAndRest(set: setInput, rest: restInput)
                isShowWorkOutView = true
            }
        }
        .alert(isPresented: $viewModel.isError, error: viewModel.error) {}
        .navigationDestination(isPresented: $viewModel.canWorkOut) {
            if isShowWorkOutView {
                WorkOutExerciseView(viewModel: WorkOutExerciseViewModel(selectWorkOutExercise: viewModel.selectExercise))
                    .onDisappear(){isShowWorkOutView = false}
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseView()
                .environment(\.managedObjectContext, Persistent.preview.container.viewContext)
        }
    }
}
