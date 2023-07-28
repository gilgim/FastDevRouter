//
//  WorkOutViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/28.
//

import Foundation
struct UserWorkOut {
    let workOutExercise: WorkOutByExercise
    var set: [Set]
    struct Set {
        var weight: Double
        var reps: Int
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
    @Published var restWorkOutTimer: CustomTimer = .init()
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
    }
    
    public func recordWorkOut() {
        model.recordWorkOut(workOutData: self.workOutData)
    }
    
    public func recordWeigthAndReps(weight: Double?, reps: Int?) {
        guard let weight, let reps else { error = .RecordError; return }
        self.workOutData.set.append(.init(weight: weight, reps: reps))
    }
    
    public func workOutButtonClickAction() {
        switch currentWorkOutStatus {
        case .beforeWorkOut:
            currentWorkOutStatus = .workOut
        case .workOut:
            currentWorkOutStatus = .afterWorkOut
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
}
