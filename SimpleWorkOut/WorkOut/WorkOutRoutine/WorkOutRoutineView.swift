//
//  WorkOutRoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/03.
//

import SwiftUI

struct WorkOutRoutineView: View {
    @StateObject var viewModel: WorkOutRoutineViewModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.exerciseList, id: \.id) { exercise in
                    NavigationLink {
                        WorkOutRoutineExerciseView(viewModel: .init(model: viewModel.model, selectWorkOutExercise: exercise))
                    }label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 100, height: 100)
                            VStack {
                                Text(exercise.name)
                                Text("\(exercise.set)")
                                Text("\(exercise.rest)")
                            }
                            .foregroundColor(.white)
                        }
                    }
                }
                ForEach(viewModel.exerciseCompleteList, id: \.id) { exercise in
                    ZStack {
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        VStack {
                            Text(exercise.name)
                            Text("\(exercise.setReps)")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear() {
            viewModel.startRoutine()
            viewModel.fetchExercises()
        }
    }
}

struct WorkOutRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutRoutineView(viewModel: .init(selectRoutine: .init(name: "new", type: "newType", exercises: [])))
    }
}
