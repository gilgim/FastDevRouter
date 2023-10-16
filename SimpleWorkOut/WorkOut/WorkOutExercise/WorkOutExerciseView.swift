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
    @State var isDismissAlert: Bool = false
    @State var playAnimation: Bool = false
    let themeColor = Color.cyan
    var body: some View {
        VStack {
            
            Group {
                Text("\(viewModel.currentSet) / \(viewModel.selectWorkOutExercise.set)")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                HStack {
                    LottieView(name: "runningAnimation", size: .init(width: 60, height: 60), isPlaying: $playAnimation)
                        .frame(width: 60, height: 60)
                        .offset(.init(width: 5, height: 0))
                    Text(viewModel.totalWorkOutTimer.secondTime)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                }
                .offset(x: -25, y: 0)
                Text("You are currently on set \(viewModel.currentSet)")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
            }
            
            
            ScrollView(showsIndicators: false) {
                Group {
                    HStack {
                        Text("Auto Start Next Set")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        Spacer()
                        Button(action: {
                            viewModel.isAutoStart.toggle()
                        }) {
                            HStack {
                                Image(systemName: viewModel.isAutoStart ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(height: 20)
                        }
                        .tint(themeColor)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
                
                Group {
                    HStack {
                        Text("Over Training")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        Spacer()
                        Button(action: {
                            viewModel.isOverTraining.toggle()
                        }) {
                            HStack {
                                Image(systemName: viewModel.isOverTraining ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(height: 20)
                        }
                        .tint(themeColor)
                    }
                    .padding(.all)
                }
                
                Group {
                    HStack {
                        Text("Weight")
                        Divider()
                        TextField(viewModel.getPreviousWeight(), text: $viewModel.weightInput)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                        Spacer()
                        Button(action: {
                            viewModel.weightUnit = .kilogram
                        }) {
                            Text("kg")
                                .padding(10)
                                .background(viewModel.weightUnit == .kilogram ? themeColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        
                        Button(action: {
                            viewModel.weightUnit = .pound
                        }) {
                            Text("lb")
                                .padding(10)
                                .background(viewModel.weightUnit == .pound ? themeColor : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    }
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .frame(height:30)
                    .padding(.horizontal)
                }
                
                
                Group {
                    HStack {
                        Text(" Reps ")
                        Divider()
                        TextField("12", text: $viewModel.repsInput)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                        Text("Reps")
                            .padding(10)
                            .background(themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                        Spacer()
                    }
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .frame(height:30)
                    .padding(.all)
                }
                
                Group {
                    HStack {
                        Divider()
                        Text("set")
                            .frame(maxWidth: .infinity)
                        Divider()
                        Text("duration")
                            .frame(maxWidth: .infinity)
                        Divider()
                        Text("weight")
                            .frame(maxWidth: .infinity)
                        Divider()
                        Text("reps")
                            .frame(maxWidth: .infinity)
                        Divider()
                    }
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(content: {
                        Rectangle()
                            .fill(themeColor.opacity(0.8))
                    })
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    
                    ForEach(viewModel.workOutData.set, id: \.self) { recordSet in
                        HStack {
                            Divider()
                            Text("\(recordSet.setNumber)")
                                .frame(maxWidth: .infinity)
                            Divider()
                            Text("\(recordSet.exerciseDuration)")
                                .frame(maxWidth: .infinity)
                            Divider()
                            Text("\(Util.formatNumberForDivisibility(double: recordSet.weight))\(recordSet.unit)")
                                .frame(maxWidth: .infinity)
                            Divider()
                            Text("\(recordSet.reps)")
                                .frame(maxWidth: .infinity)
                            Divider()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        Divider()
                    }
                }
            }
            
            Spacer()
            
            Button{
                viewModel.workOutButtonClickAction()
            }label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(themeColor)
                    VStack {
                        if let workOutStatus = self.buttonStatuseText() {
                            Text(workOutStatus)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        }
                        Text(self.buttonText())
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .onAppear() {
            if !viewModel.isExerciseStart {
                viewModel.workOutStart()
            }
        }
        .onReceive(viewModel.totalWorkOutTimer.$intTime) { _ in
            self.viewModel.objectWillChange.send()
        }
        .onChange(of: viewModel.currentWorkOutStatus, perform: { newValue in
            self.playAnimation = false
            if newValue == .workOut {
                self.playAnimation = true
            }
        })
        .onChange(of: viewModel.isFinishWorkOut, perform: { isFinish in
            if isFinish {
                viewModel.timerStop()
                viewModel.recordWorkOut()
            }
        })
        .navigationTitle(Text(viewModel.selectWorkOutExercise.name))
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isDismissAlert.toggle()
                } label: {
                    Text("Cancel")
                }
                .tint(Color(uiColor: .systemRed))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Text("Finish")
                        .fontWeight(.bold)
                }
            }
        })
        .alert("Exercise Cancel", isPresented: $isDismissAlert, actions: {
            Button("Ok", role: .destructive) {
                dismiss()
            }
            Button("Cancel",role: .cancel) {}
        }, message: {
            Text("Would you like to cancel the workout?")
        })
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
    func buttonStatuseText() -> String? {
        switch viewModel.currentWorkOutStatus {
        case.beforeWorkOut:
            return nil
        case.workOut:
            return "Work Out"
        case.afterWorkOut:
            return "Rest"
        case.finish:
            return nil
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
