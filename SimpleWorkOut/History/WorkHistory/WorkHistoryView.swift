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
    struct DetailView: View {
        @State var isOpen: Bool = false
        @Binding var workOutHistory: WorkOutExercise
        
        var body: some View {
            VStack {
                Button {
                    withAnimation {
                        isOpen.toggle()
                    }
                } label: {
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 80, alignment: .center)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.horizontal, 24)
                            .overlay {
                                Text(workOutHistory.date?.localizedString() ?? Date().localizedString())
                            }
                        Spacer()
                        Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                            .foregroundColor(.black.opacity(0.87))
                    }
                }
                .fixedSize(horizontal: false, vertical: true) // 버튼의 세로 크기를 고정합니다.

                if isOpen {
                    VStack {
                        ForEach(sets, id: \.self) { set in
                            Text("\(set.setNumber)")
                        }
                    }
                    .transition(.slide) // 펼쳐지고 접힐 때 슬라이드 효과를 추가합니다.
                }
            }
        }
        
        var sets: [ExerciseSet] {
            return workOutHistory.sets?.allObjects as? [ExerciseSet] ?? []
        }
        
        func detailHeight() -> CGFloat {
            return isOpen ? CGFloat(sets.count) * 20 : 0
        }
    }
    var body: some View {
        List {
            ForEach(viewModel.workOutDetailList, id: \.id) { history in
                DetailView(workOutHistory: .constant(history))
            }
        }
        .listStyle(PlainListStyle())
    }
}
