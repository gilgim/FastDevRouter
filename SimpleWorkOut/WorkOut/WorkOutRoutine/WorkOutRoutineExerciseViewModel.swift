//
//  WorkOutRoutineExerciseViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/03.
//

import Foundation
import Combine
import SwiftUI

class WorkOutRoutineExerciseViewModel: ObservableObject {
    enum WorkOutStatus: String {
        case beforeWorkOut = "BeforeWorkOut"
        case workOut = "WorkOut"
        case afterWorkOut = "AfterWorkOut"
        case finish = "Finish"
    }
    let model: WorkOutRoutineModel
    let restNotification = CustomNotification(id: "rest", title: "Rest Finish", message: "Rest finish. Please complete with your workout.")
    
    var cancellable: AnyCancellable?
    @Published public var isAutoStart: Bool = false
    @Published public var isAlert: Bool = false
    @Published public var customAlert: CustomAlert? = nil {
        didSet {
            if customAlert != nil {
                isAlert = true
            }
        }
    }
    
    @Published public var error: WorkOutExerciseError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    
    @Published var isFinishWorkOut = false
    
    @Published var totalWorkOutTimer: CustomTimer = .init()
    @Published var singleWorkOutTimer: CustomTimer = .init()
    @Published var restWorkOutTimer: CustomMinusTimer
    
    @Published var selectWorkOutExercise: WorkOutByExercise
    @Published var currentSet: Int = 1
    @Published var currentWorkOutStatus: WorkOutStatus = .beforeWorkOut
    @Published var weightInput: String = ""
    @Published var repsInput: String = ""
    private var weightStorage: Double {
        get {
            return Double(weightInput) ?? 10
        }
    }
    private var repsStorage: Int {
        get {
            return Int(repsInput) ?? 12
        }
    }
    
    var workOutData: UserWorkOutExercise
    
    init(model: WorkOutRoutineModel, selectWorkOutExercise: WorkOutByExercise?) {
        self.model = model
        var _selectWorkOutExercise: WorkOutByExercise = .init(name: "error", type: "error", set: 0, rest: 0)
        if let selectWorkOutExercise {
           _selectWorkOutExercise = selectWorkOutExercise
        }
        self.selectWorkOutExercise = _selectWorkOutExercise
        self.workOutData = .init(id: _selectWorkOutExercise.id, workOutExercise:_selectWorkOutExercise, totalDuration: 0, set: [])
        self.restWorkOutTimer = .init(setTime: _selectWorkOutExercise.rest)
        self.restWorkOutTimer.timerStopClosure = { restTime in
            self.restFinish(restTime: restTime)
        }
        cancellable = AppLifecycleManager.shared.appState.sink(receiveValue: { [weak self] state in
            guard let self else {return}
            switch state {
            case .active:
                self.sceneActiveMethod()
            case .inactive:
                self.sceneInactiveMethod()
            case .background:
                self.sceneBackgroundMethod()
            @unknown default:
                break
            }
        })
    }
    
    public func recordRoutineExerciseWorkOut() {
        model.addCompleteExercise(completeExercise: self.workOutData)
    }
    
    public func recordWeigthAndReps(weight: Double?, reps: Int?) {
        guard let weight, let reps else { error = .RecordError; return }
        let restDuration = restWorkOutTimer.getDefaultTime() - restWorkOutTimer.getTime()
        let exerciseDuration = singleWorkOutTimer.getTime()
        self.workOutData.set.append(.init(setNumber: currentSet, weight: weight, reps: reps, restDuration: restDuration, exerciseDuration: exerciseDuration, unit: "FIXME"))
        self.weightInput = ""
        self.repsInput = ""
    }
    
    public func workOutStart() {
        totalWorkOutTimer.start()
    }
    
    public func workOutButtonClickAction() {
        
        switch currentWorkOutStatus {
        case .beforeWorkOut:
            restWorkOutTimer.stop()
            restWorkOutTimer.reset()
            singleWorkOutTimer.reset()
            singleWorkOutTimer.start()
            currentWorkOutStatus = .workOut
            
        case .workOut:
            singleWorkOutTimer.stop()
            restWorkOutTimer.start()
            currentWorkOutStatus = .afterWorkOut
            
        case .afterWorkOut:
            restFinish(restTime: restWorkOutTimer.getTime())
        case .finish:
            break
        }
    }
    
    public func restFinish(restTime: Int) {
        if currentSet < selectWorkOutExercise.set {
            if restTime > 0 {
                let title = "Rest End"
                let massege = "Are you ending your rest period"
                customAlert = .init(title: title, message: massege, okButtonAction: {
                    self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage)
                    if self.isAutoStart {
                        self.restWorkOutTimer.stop()
                        self.restWorkOutTimer.reset()
                        self.singleWorkOutTimer.reset()
                        self.singleWorkOutTimer.start()
                        self.currentWorkOutStatus = .workOut
                    }
                    else {
                        self.currentWorkOutStatus = .beforeWorkOut
                    }
                    self.currentSet += 1
                }, cancelButtonAction: {})
            }
            else {
                self.isAlert = false
                self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage)
                if self.isAutoStart {
                    self.restWorkOutTimer.stop()
                    self.restWorkOutTimer.reset()
                    self.singleWorkOutTimer.reset()
                    self.singleWorkOutTimer.start()
                    self.currentWorkOutStatus = .workOut
                }
                else {
                    self.currentWorkOutStatus = .beforeWorkOut
                }
                self.currentSet += 1
            }
        }
        else {
            if restTime > 0 {
                let title = "Rest End"
                let massege = "Are you ending your rest period"
                customAlert = .init(title: title, message: massege, okButtonAction: {
                    self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage)
                    self.workOutData.totalDuration = self.totalWorkOutTimer.getTime()
                    self.isFinishWorkOut = true
                    self.cancellable?.cancel()
                }, cancelButtonAction: {})
            }
            else {
                self.isAlert = false
                self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage)
                self.workOutData.totalDuration = self.totalWorkOutTimer.getTime()
                self.isFinishWorkOut = true
                self.cancellable?.cancel()
            }
        }
    }
    public func timerStop() {
        totalWorkOutTimer.stop()
        singleWorkOutTimer.stop()
        restWorkOutTimer.stop()
    }
    private func sceneActiveMethod() {
        if currentWorkOutStatus == .workOut {
            singleWorkOutTimer.addTime(time: AppLifecycleManager.shared.backgroundElapesdTime)
        }
        else  if currentWorkOutStatus == .afterWorkOut {
            restWorkOutTimer.minusTime(time: AppLifecycleManager.shared.backgroundElapesdTime)
        }
        totalWorkOutTimer.addTime(time: AppLifecycleManager.shared.backgroundElapesdTime)
        restNotification.removeNotification()
    }
    private func sceneInactiveMethod() {}
    
    private func sceneBackgroundMethod() {
        if currentWorkOutStatus == .afterWorkOut {
            print("test\(restWorkOutTimer.getTime())")
            restNotification.addNotification(trigerTime: Double(restWorkOutTimer.getTime()))
        }
    }
}
