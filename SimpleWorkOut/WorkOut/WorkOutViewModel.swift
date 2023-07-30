//
//  WorkOutViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/28.
//

import Foundation
import Combine

struct UserWorkOut {
    let workOutExercise: WorkOutByExercise
    var set: [Set]
    struct Set {
        var weight: Double
        var reps: Int
        var restDuration: Int
        var exerciseDuration: Int
    }
}
class WorkOutViewModel: ObservableObject {
    enum WorkOutStatus: String {
        case beforeWorkOut = "BeforeWorkOut"
        case workOut = "WorkOut"
        case afterWorkOut = "AfterWorkOut"
        case finish = "Finish"
    }
    private let model = WorkOutSaveModel()
    
    var cancellable: AnyCancellable?
    
    @Published public var error: WorkOutError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    @Published var totalWorkOutTimer: CustomTimer = .init()
    @Published var singleWorkOutTimer: CustomTimer = .init()
    @Published var restWorkOutTimer: CustomMinusTimer
    @Published var selectWorkOutExercise: WorkOutByExercise
    @Published var currentSet: Int = 1
    @Published var workOutButtonText: String = ""
    @Published var isFinishWorkOut = false
    @Published var currentWorkOutStatus: WorkOutStatus = .beforeWorkOut
    
    var workOutData: UserWorkOut
    
    init(selectWorkOutExercise: WorkOutByExercise?) {
        var _selectWorkOutExercise: WorkOutByExercise = .init(name: "error", type: "error", set: 0, rest: 0)
        if let selectWorkOutExercise {
           _selectWorkOutExercise = selectWorkOutExercise
        }
        self.selectWorkOutExercise = _selectWorkOutExercise
        self.workOutData = .init(workOutExercise:_selectWorkOutExercise, set: [])
        self.restWorkOutTimer = .init(setTime: _selectWorkOutExercise.rest)
        
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
    
    public func recordWorkOut() {
        do {
            try model.recordWorkOut(workOutData: self.workOutData)
        }
        catch {
            self.error = WorkOutError.RecordError
        }
    }
    
    public func recordWeigthAndReps(weight: Double?, reps: Int?) {
        guard let weight, let reps else { error = .RecordError; return }
        let restDuration = restWorkOutTimer.getTime()
        let exerciseDuration = singleWorkOutTimer.getTime()
        self.workOutData.set.append(.init(weight: weight, reps: reps, restDuration: restDuration, exerciseDuration: exerciseDuration))
        singleWorkOutTimer.reset()
        restWorkOutTimer.reset()
    }
    
    public func workOutButtonClickAction() {
        switch currentWorkOutStatus {
        case .beforeWorkOut:
            totalWorkOutTimer.start()
            singleWorkOutTimer.start()
            currentWorkOutStatus = .workOut
        case .workOut:
            currentWorkOutStatus = .afterWorkOut
            singleWorkOutTimer.stop()
        case .afterWorkOut:
            if currentSet <= selectWorkOutExercise.set {
                currentWorkOutStatus = .beforeWorkOut
                
            }
            else {
                currentWorkOutStatus = .finish
                isFinishWorkOut = true
            }
        case .finish:
            break
        }
    }
    
    private func sceneActiveMethod() {
        
    }
    
    private func sceneInactiveMethod() {
        
    }
    
    private func sceneBackgroundMethod() {
        
    }
}
