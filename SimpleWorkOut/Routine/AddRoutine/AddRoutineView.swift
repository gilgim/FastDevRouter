//
//  AddRoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = AddRoutineViewModel()
    @State var selectExerciseStorage: WorkOutByExercise? = nil
    @State var nameInput: String = ""
    @State var typeInput: String = ""
    @State var setInputText: String = ""
    @State var restInputText: String = ""
    @State var isShowSetAndRest = false {
        didSet {
            setInputText = ""
            restInputText = ""
        }
    }
    @State var isShowCreateAlert = false {
        didSet {
            nameInput = ""
            typeInput = ""
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.selectExercises, id: \.id) { exercise in
                    HStack {
                        Text(exercise.name)
                        Text(exercise.type)
                        Text("\(exercise.set)")
                        Text("\(Util.intToSecond(intTime: exercise.rest))")
                    }
                }
            }
            List {
                ForEach(viewModel.allExercises, id: \.name) { exercise in
                    Button {
                        selectExerciseStorage = exercise
                        isShowSetAndRest = true
                    }label: {
                        HStack {
                            Text(exercise.name)
                            Text(exercise.type)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    self.isShowCreateAlert = true
                }
            }
        }
        .alert("Create Exercise", isPresented: $isShowCreateAlert) {
            TextField("Please input routine name.", text: $nameInput)
            TextField("Please input routine type.", text: $typeInput)
            Button("Cancle", role: .cancel) {}
            Button("OK") {
                viewModel.createRoutine(name: nameInput, type: typeInput) {
                    self.dismiss()
                }
            }
        }
        .alert("Add Exercise", isPresented: $isShowSetAndRest) {
            TextField("Please input set", text: $setInputText)
            TextField("Please input rest", text: $restInputText)
            Button("OK") {
                if let selectExerciseStorage {
                    viewModel.addExercise(exercise: selectExerciseStorage, setReps: setInputText, restDuration: restInputText)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert(isPresented: $viewModel.isError, error: viewModel.error) {}
    }
}

struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutineView()
    }
}
