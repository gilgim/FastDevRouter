//
//  WorkOutView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import SwiftUI

struct WorkOutView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkOutViewModel
    @State private var weightInput: String = ""
    @State private var repsInput: String = ""
    var body: some View {
        VStack {
            Text(viewModel.totalWorkOutTimer.secondTime)
            Text("\(viewModel.currentSet)/\(viewModel.selectWorkOutExercise.set)")
            TextField("Weigth: Default 10kg", text: $weightInput)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
            TextField("Reps: Default 12reps", text: $repsInput)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
            Spacer()
            Button{
                viewModel.workOutButtonClickAction()
                if viewModel.currentWorkOutStatus == .workOut {
                    viewModel.setWeightAndReps(weight: weightInput, reps: repsInput)
                }
            }label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                    Text(self.buttonText())
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .bold))
                }
            }
        }
        .onAppear() {
            viewModel.workOutStart()
        }
        .onReceive(viewModel.totalWorkOutTimer.$intTime) { _ in
            self.viewModel.objectWillChange.send()
        }
        .onChange(of: viewModel.currentWorkOutStatus) { _ in
            weightInput = ""
            repsInput = ""
        }
        .onChange(of: viewModel.isFinishWorkOut, perform: { isFinish in
            if isFinish {
//                viewModel.recordWorkOut()
            }
        })
        .navigationTitle(Text(viewModel.selectWorkOutExercise.name))
        .alert(isPresented: $viewModel.isAlert) {
            Alert(
                title: Text(viewModel.customAlert?.title ?? "error"),
                message: Text(viewModel.customAlert?.message ?? ""),
                primaryButton: .default(Text("OK"), action: {
                    viewModel.customAlert?.okButtonAction?()
                }),
                secondaryButton: .cancel(Text("Cancel"), action: {
                    viewModel.customAlert?.cancelButtonAction?()
                })
            )
        }
        .sheet(isPresented: $viewModel.isFinishWorkOut) {
            dismiss()
        } content: {
            Text("Record")
        }

    }
    func buttonText() -> String {
        switch viewModel.currentWorkOutStatus {
        case.beforeWorkOut:
            return "Start"
        case.workOut:
            return viewModel.singleWorkOutTimer.milliSecondTime
        case.afterWorkOut:
            return viewModel.restWorkOutTimer.secondTime
        case.finish:
            return "Finish"
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
