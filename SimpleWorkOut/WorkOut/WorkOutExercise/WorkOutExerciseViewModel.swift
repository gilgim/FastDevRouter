//
//  WorkOutViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/28.
//

import Foundation
import Combine
import SwiftUI

struct UserWorkOutExercise {
    let id: UUID
    let workOutExercise: WorkOutByExercise
    var totalDuration: Int
    var set: [Set]
    struct Set: Hashable {
        var id = UUID()
        var setNumber: Int
        var weight: Double
        var reps: Int
        var restDuration: Int
        var exerciseDuration: Int
        var unit: String
    }
}

class WorkOutExerciseViewModel: ObservableObject {
    enum WorkOutStatus: String {
        case beforeWorkOut = "BeforeWorkOut"
        case workOut = "WorkOut"
        case afterWorkOut = "AfterWorkOut"
        case finish = "Finish"
    }
    enum WeightUnit: String {
        case kilogram = "kg"
        case pound = "lb"
    }
    
    private let model = WorkOutExerciseModel()
    let restNotification = CustomNotification(id: "rest", title: "Rest Finish", message: "Rest finish. Please complete with your workout.")
    
    var cancellable: AnyCancellable?
    @Published public var isAutoStart: Bool = false
    @Published public var isOverTraining: Bool = false
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
    @Published var isExerciseStart = false
    @Published var isFinishWorkOut = false
    
    @Published var totalWorkOutTimer: CustomTimer
    @Published var singleWorkOutTimer: CustomTimer
    @Published var restWorkOutTimer: CustomMinusTimer
    
    @Published var selectWorkOutExercise: WorkOutByExercise
    @Published var currentSet: Int = 1
    @Published var currentWorkOutStatus: WorkOutStatus = .beforeWorkOut
    @Published var weightInput: String = ""
    @Published var weightUnit: WeightUnit = .kilogram
    @Published var repsInput: String = ""
    
    var lastWeight: Double = 10
    var lastReps: Int = 12
    var disappearTime: Int = 0
    
    private var weightStorage: Double {
        get {
            return Double(weightInput) ?? lastWeight
        }
    }
    private var repsStorage: Int {
        get {
            return Int(repsInput) ?? lastReps
        }
    }
    
    var workOutData: UserWorkOutExercise
    
    init(selectWorkOutExercise: WorkOutByExercise?) {
        var _selectWorkOutExercise: WorkOutByExercise = .init(name: "error", type: "error", set: 0, rest: 0)
        if let selectWorkOutExercise {
           _selectWorkOutExercise = selectWorkOutExercise
        }
        self.selectWorkOutExercise = _selectWorkOutExercise
        self.workOutData = .init(id: .init(), workOutExercise:_selectWorkOutExercise, totalDuration: 0, set: [])
        
        WorkOutTimer.shared.totalWorkOutTimer = .init()
        totalWorkOutTimer = WorkOutTimer.shared.totalWorkOutTimer ?? .init()
        
        WorkOutTimer.shared.singleWorkOutTimer = .init()
        singleWorkOutTimer = WorkOutTimer.shared.singleWorkOutTimer ?? .init()
        
        WorkOutTimer.shared.restTimer = .init(setTime: _selectWorkOutExercise.rest)
        restWorkOutTimer = WorkOutTimer.shared.restTimer ?? .init(setTime: _selectWorkOutExercise.rest)
        
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
    
    deinit {
        WorkOutTimer.shared.totalWorkOutTimer = nil
        WorkOutTimer.shared.singleWorkOutTimer = nil
        WorkOutTimer.shared.restTimer = nil
    }
    
    public func recordWorkOut() {
        do {
            try model.recordWorkOut(workOutData: self.workOutData)
        }
        catch {
            self.error = WorkOutExerciseError.RecordError
        }
    }
    
    private func recordWeigthAndReps(weight: Double?, reps: Int?, exerciseDuration: Int? = nil) {
        guard let weight, let reps else { error = .RecordError; return }
        let restDuration = restWorkOutTimer.getDefaultTime() - restWorkOutTimer.getTime()
        var tempExerciseDuration = 0
        if let exerciseDuration = exerciseDuration {
            tempExerciseDuration = exerciseDuration
        }
        else {
            tempExerciseDuration = singleWorkOutTimer.getTime()
        }
         
        self.workOutData.set.append(.init(setNumber: currentSet, weight: weight, reps: reps, restDuration: restDuration, exerciseDuration: tempExerciseDuration, unit: self.weightUnit.rawValue))
        self.weightInput = ""
        self.repsInput = ""
    }
    
    public func workOutStart() {
        totalWorkOutTimer.start()
        isExerciseStart = true
    }
    
    public func workOutRestart() {
        totalWorkOutTimer.start()
        totalWorkOutTimer.addTime(time: (Util.currentDateToInt() - disappearTime) * 100)
        switch currentWorkOutStatus {
        case .beforeWorkOut:
            break
        case .workOut:
            singleWorkOutTimer.start()
            singleWorkOutTimer.addTime(time: (Util.currentDateToInt() - disappearTime) * 100)
        case .afterWorkOut:
            restWorkOutTimer.start()
            restWorkOutTimer.minusTime(time: (Util.currentDateToInt() - disappearTime) * 100)
        case .finish:
            break
        }
    }
    public func disappearWorkOut() {
        disappearTime = Util.currentDateToInt()
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
        var tempExerciseDuration: Int? = nil
        if currentSet < selectWorkOutExercise.set {
            if restTime > 0 {
                let title = "Rest End"
                let massege = "Are you ending your rest period"
                customAlert = .init(title: title, message: massege, okButtonAction: {
                    if self.isAutoStart {
                        self.restWorkOutTimer.stop()
                        self.restWorkOutTimer.reset()
                        tempExerciseDuration = self.singleWorkOutTimer.getTime()
                        self.singleWorkOutTimer.reset()
                        self.singleWorkOutTimer.start()
                        self.currentWorkOutStatus = .workOut
                    }
                    else {
                        self.currentWorkOutStatus = .beforeWorkOut
                    }
                    self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage, exerciseDuration: tempExerciseDuration)
                    self.currentSet += 1
                }, cancelButtonAction: {})
            }
            else {
                self.isAlert = false
                if self.isAutoStart {
                    self.restWorkOutTimer.stop()
                    self.restWorkOutTimer.reset()
                    tempExerciseDuration = self.singleWorkOutTimer.getTime()
                    self.singleWorkOutTimer.reset()
                    self.singleWorkOutTimer.start()
                    self.currentWorkOutStatus = .workOut
                }
                else {
                    self.currentWorkOutStatus = .beforeWorkOut
                }
                self.recordWeigthAndReps(weight: self.weightStorage, reps: self.repsStorage, exerciseDuration: tempExerciseDuration)
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
    
    //  MARK: Input Methods
    public func getPreviousWeight() -> String {
        if self.workOutData.set.count > 0 {
            let weight = self.workOutData.set.last!.weight
            return String(Util.formatNumberForDivisibility(double: weight)) + self.workOutData.set.last!.unit
        }
        else if let workoutExercise = model.read()?.filter({$0.exercise?.name == self.selectWorkOutExercise.name}), workoutExercise.count > 0 {
            let sortedExercises = workoutExercise.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            let exercise = sortedExercises.first
            
            if let sets = exercise?.sets?.allObjects as? [ExerciseSet],
               let set = sets.sorted(by: { $0.setNumber > $1.setNumber}).first {
                let weight = set.weight
                let unit = set.unit ?? "unfind unit"
                self.lastWeight = weight
                
                return Util.formatNumberForDivisibility(double: weight) + unit
            }
        }
        return Util.formatNumberForDivisibility(double: lastWeight) + "kg"
    }
    public func getPreviousReps() -> String {
        if self.workOutData.set.count > 0 {
            return String(self.workOutData.set.last!.reps)
        }
        else if let workoutExercise = model.read()?.filter({$0.exercise?.name == self.selectWorkOutExercise.name}), workoutExercise.count > 0 {
            let sortedExercises = workoutExercise.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            let exercise = sortedExercises.first
            
            if let sets = exercise?.sets?.allObjects as? [ExerciseSet],
               let set = sets.sorted(by: { $0.setNumber > $1.setNumber}).first {
                let reps = set.reps
                self.lastReps = Int(reps)
                return "\(reps)"
            }
        }
        return "\(self.lastReps)"
    }
}
