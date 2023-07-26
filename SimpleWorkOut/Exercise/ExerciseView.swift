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
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.exercises, id: \.name) { exercise in
                    HStack {
                        Text(exercise.name)
                        Text(exercise.type)
                        Button("") {
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
            Button("OK") {
                viewModel.createExercise(name: exerciseNameInput, type: exerciseTypeInput)
            }
        }
        .alert("Setup Set and Rest", isPresented: $isWorkOut) {
            TextField("Please input exercise set", text: $setInput)
            TextField("Please input exercise rest time.", text: $restInput)
            NavigationLink("OK") {
                //  FIXME: 키보드 숫자 제안 및 숫자 범위 설정
                WorkOutView(setCount: setInput, setRestTime: restInput)
            }
        }
        .alert(isPresented: $viewModel.isError, error: viewModel.error) {}
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
