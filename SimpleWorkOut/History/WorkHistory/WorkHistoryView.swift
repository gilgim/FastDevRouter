//
//  WorkHistoryView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct WorkHistoryView: View {
    @ObservedObject var viewModel = WorkHistoryViewModel()
    @State var isPushView: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer().frame(height: 30)
                LazyVGrid(columns: .init(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity)), count: 3), spacing: 12, pinnedViews: [], content: {
                    ForEach(viewModel.workOutExercises, id: \.self) { exerciseName in
                        Button {
                            isPushView.toggle()
                            viewModel.selectExerciseName = exerciseName
                            viewModel.fetchExeciseHistorysDetail()
                        }label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .overlay {
//                                        RoundedRectangle(cornerRadius: 13)
//                                            .stroke(lineWidth: 2)
//                                            .foregroundColor(.black)
                                        Text(exerciseName)
                                            .foregroundColor(.black.opacity(0.87))
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                
                            }
                        }
                    }
                })
                .padding(.horizontal, 24)
                Spacer().frame(height: 60)
            }
            .navigationTitle("History")
        }
        .onAppear() {
            viewModel.fetchExerciseHistorys()
        }
        .navigationDestination(isPresented: $isPushView) {
            WorkHistoryComponentView(viewModel: .constant(viewModel))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.selectExerciseName)
        }
    }
}

struct WorkHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkHistoryView()
    }
}

struct WorkHistoryComponentView: View {
    @Binding var viewModel: WorkHistoryViewModel

    var body: some View {
        List {
            ForEach(viewModel.workOutDetailList, id: \.id) { history in
                DetailView(workOutExercise: .constant(history))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    struct DetailView: View {
        @Binding var workOutExercise: WorkOutExercise
        @State var isOpen: Bool = false
        var body: some View {
            Section(header: header) {
                if isOpen {
                    ForEach(sets, id: \.id) { set in
                        Text("Set \(set.setNumber): \(Util.formatNumberForDivisibility(double: set.weight))\(set.unit ?? "kg") x \(set.reps) reps, Rest: \(Util.intToSecond(intTime: Int(set.restDuration))) seconds")

                    }
                }
            }
        }
        var sets: [ExerciseSet] {
            return (workOutExercise.sets?.allObjects as? [ExerciseSet] ?? []).sorted(by: {$0.setNumber < $1.setNumber})
        }
        var header: some View {
            Button(action: {
                withAnimation {
                    isOpen.toggle()
                }
            }) {
                HStack {
                    Text("\(workOutExercise.date?.localizedString() ?? "")")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                }
            }
        }
    }
}
