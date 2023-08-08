//
//  WorkOutRoutineViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/03.
//

import Foundation

struct UserWorkOutRoutine {
    let id: UUID
    let workOutRoutine: WorkOutByRoutine
    var totalDuration: Int
}
class WorkOutRoutineViewModel: ObservableObject {
    let model = WorkOutRoutineModel()
    @Published var selectRoutine: WorkOutByRoutine
    @Published var exerciseList: [WorkOutByExercise]
    @Published var exerciseCompleteList: [(id: UUID, name: String, type: String?, setReps: Int)] = []
    @Published public var error: WorkOutRoutineError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    var workOutData: UserWorkOutRoutine
    init(selectRoutine: WorkOutByRoutine) {
        self.selectRoutine = selectRoutine
        self.exerciseList = selectRoutine.exercises
        self.workOutData = .init(id: selectRoutine.id, workOutRoutine: selectRoutine, totalDuration: 0)
    }
    public func startRoutine() {
        do {
            try self.model.createWorkOutRoutine(selectRoutine: workOutData)
        }
        catch {
            self.error = error as? WorkOutRoutineError
        }
    }
    public func fetchExercises() {
        do {
            exerciseList = try self.model.getNotCompleteExercises().map({
                return WorkOutByExercise(id: $0.id ?? UUID(),name: $0.exercise?.name ?? "", type: $0.exercise?.type ?? "", set: Int($0.setReps), rest: Int($0.restDuration))
            })
            exerciseCompleteList = self.model.getCompleteExercise().map({
                return (id: UUID(), name: $0.workOutExercise.name, type: $0.workOutExercise.type, setReps: $0.set.count)
            })
        }
        catch {
            self.error = error as? WorkOutRoutineError
        }
    }
    public func finishRoutine() {
        do {
            try model.recordRoutine()
        }
        catch {
            self.error = error as? WorkOutRoutineError
        }
    }
}
