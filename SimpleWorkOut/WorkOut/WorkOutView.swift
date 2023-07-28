//
//  WorkOutView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import SwiftUI

struct WorkOutView: View {
    @ObservedObject var viewModel: WorkOutViewModel
    @State private var weightInput: String = ""
    @State private var repsInput: String = ""
    var body: some View {
        VStack {
            Text(viewModel.totalWorkOutTimer.milliSecondTime)
            Text("\(viewModel.currentSet)/\(viewModel.selectWorkOutExercise.set)")
            TextField("Weigth", text: $weightInput)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
            TextField("Count", text: $repsInput)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
            Spacer()
            Button{
                viewModel.workOutButtonClickAction()
            }label: {
                RoundedRectangle(cornerRadius: 13)
                Text("")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .bold))
            }
        }
        .navigationTitle(Text(viewModel.selectWorkOutExercise.name))
        .onChange(of: viewModel.currentWorkOutStatus) { _ in
            weightInput = ""
            repsInput = ""
        }
    }
}

struct WorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkOutView(viewModel: .init(selectWorkOutExercise: .init(name: "ExampleExercise", type: "ExampleType", set: 5, rest: 90)))
        }
    }
}
