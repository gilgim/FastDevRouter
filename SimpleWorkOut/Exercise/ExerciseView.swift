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
    
    @State var selectType: String = ""
    @State var searchText: String = ""
    var showSearchView: Bool {
        get {
            return selectType == "magnifyingglass"
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Spacer(minLength: 10)
                    Button {
                        withAnimation {
                            if selectType == "magnifyingglass" {
                                selectType = ""
                            }
                            else {
                                selectType = "magnifyingglass"
                            }
                        }
                    }label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(CustomButtonStyle(isPressed: selectType == "magnifyingglass"))
                    ForEach(viewModel.typeList, id:\.self) { type in
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                if selectType == type {
                                    selectType = ""
                                }
                                else {
                                    selectType = type
                                }
                            }
                        }label: {
                            Text(type)
                        }
                        .buttonStyle(CustomButtonStyle(isPressed: selectType == type))
                    }
                    Spacer(minLength: 10)
                }
                .padding(.bottom, 5)
            }
            
            if showSearchView {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 10)
            }
            
            List {
                ForEach(viewModel.exercises.filter { exercise in
                    if selectType == "magnifyingglass" {
                        return searchText.isEmpty || exercise.name.lowercased().contains(searchText.lowercased())
                    }
                    else if selectType != "" {
                        return exercise.type.lowercased().contains(selectType.lowercased())
                    }
                    else {
                        return true
                    }
                }, id: \.name) { exercise in
                    ExerciseContentView(
                        exerciseName: exercise.name,
                        bodyPart: exercise.type,
                        exercisePlayButtonClickHandler: {
                            viewModel.setSelectExerciseSetAndRest(name: exercise.name, type: exercise.type)
                            isWorkOut = true
                        },
                        exerciseButtonClickHandler: {
                            print("HelloWorld")
                        }
                    )
                    .listRowInsets(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        Button {
                            withAnimation {
                                viewModel.delectExercise(name: exercise.name)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(Color(uiColor: .systemRed))
                    }
                }
            }
            .listStyle(PlainListStyle())
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
                        .bold()
                }
            }
        }
        .alert("Create Exercise", isPresented: $isAlertEnable) {
            TextField("Exercise Name", text: $exerciseNameInput)
            TextField("Body Type", text: $exerciseTypeInput)
            Button("Cancle", role: .cancel) {}
            Button("OK") {
                viewModel.createExercise(name: exerciseNameInput, type: exerciseTypeInput)
            }
        }
        .alert("Setup Set and Rest", isPresented: $isWorkOut) {
            HStack {
                Image(systemName: "sportscourt.fill")
                TextField("Number of Sets", text: $setInput)
                    .keyboardType(.numberPad)
            }
            HStack {
                Image(systemName: "timer")
                TextField("Rest Time", text: $restInput)
                    .keyboardType(.numberPad)
            }
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                viewModel.setSelectExerciseSetAndRest(set: setInput, rest: restInput)
                isShowWorkOutView = true
            }
        }
        .alert(isPresented: $viewModel.isError, error: viewModel.error) {}
        .navigationDestination(isPresented: $viewModel.canWorkOut) {
            if isShowWorkOutView {
                WorkOutExerciseView(viewModel: WorkOutExerciseViewModel(selectWorkOutExercise: viewModel.selectExercise))
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
