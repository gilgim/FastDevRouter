//
//  WorkOutView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import SwiftUI

struct WorkOutExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: WorkOutExerciseViewModel
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.totalWorkOutTimer.secondTime)
                Button(action: {
                    viewModel.isAutoStart.toggle()
                }) {
                    HStack {
                        Image(systemName: viewModel.isAutoStart ? "checkmark.square" : "square")
                    }
                }
            }
            Text("\(viewModel.currentSet)/\(viewModel.selectWorkOutExercise.set)")
            TextField("Weigth: Default 10kg", text: $viewModel.weightInput)
            .multilineTextAlignment(.center)
            .font(.system(size: 18))
            .keyboardType(.decimalPad)
            
            TextField("Reps: Default 12reps", text: $viewModel.repsInput)
            .multilineTextAlignment(.center)
            .font(.system(size: 18))
            .keyboardType(.decimalPad)
            
            Spacer()
            Button{
                viewModel.workOutButtonClickAction()
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
        .onDisappear(){
            viewModel.timerStop()
        }
        .onReceive(viewModel.totalWorkOutTimer.$intTime) { _ in
            self.viewModel.objectWillChange.send()
        }
        .onChange(of: viewModel.isFinishWorkOut, perform: { isFinish in
            if isFinish {
                viewModel.timerStop()
                viewModel.recordWorkOut()
            }
        })
        .navigationTitle(Text(viewModel.selectWorkOutExercise.name))
        .alert(viewModel.customAlert?.title ?? "Title", isPresented: $viewModel.isAlert, actions: {
            Button("Ok") {
                if let okAction = viewModel.customAlert?.okButtonAction {
                    okAction()
                }
            }
            Button("Cancel",role: .cancel) {
                if let cancelAction = viewModel.customAlert?.cancelButtonAction {
                    cancelAction()
                }
            }
        }, message: {
            Text(viewModel.customAlert?.message ?? "Message")
        })
        .sheet(isPresented: $viewModel.isFinishWorkOut) {
            dismiss()
        } content: {
            WorkOutRecordingView(workoutID: viewModel.workOutData.id)
        }

    }
    func buttonText() -> String {
        switch viewModel.currentWorkOutStatus {
        case.beforeWorkOut:
            return "Start"
        case.workOut:
            return viewModel.singleWorkOutTimer.milliSecondTime
        case.afterWorkOut:
            return viewModel.restWorkOutTimer.milliSecondTime
        case.finish:
            return "Finish"
        }
    }
}

struct WorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkOutExerciseView(viewModel: .init(selectWorkOutExercise: .init(name: "ExampleExercise", type: "ExampleType", set: 5, rest: 90)))
        }
    }
}
