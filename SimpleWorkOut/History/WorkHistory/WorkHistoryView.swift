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
            .navigationTitle("운동 기록")
        }
        .onAppear() {
            viewModel.fetchExerciseHistorys()
        }
        .navigationDestination(isPresented: $isPushView) {
            Text("Hello, World")
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
    @State var viewModel: WorkHistoryViewModel
    var body: some View {
        VStack {
            
        }
    }
}
