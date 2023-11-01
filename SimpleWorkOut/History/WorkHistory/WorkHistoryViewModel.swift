//
//  WorkHistoryViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/11/01.
//

import Foundation

class WorkHistoryViewModel: ObservableObject {
    let model = WorkHistoryModel()
    @Published public var error: ExerciseError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    @Published public var workOutExercises: [String] = []
    @Published public var selectExerciseName: String = ""
    
    public func delectExercise(id: String) {
        model.delete(id: id)
        fetchExerciseHistorys()
    }
    
    public func fetchExerciseHistorys() {
        guard let list = model.read() else {return}
        workOutExercises = list.map({
            if let workOutExericse = $0 as? WorkOutExercise {
                return (workOutExericse.exercise?.name ?? "")
            }
            else {
                return ""
            }
        })
        workOutExercises = Array(Set(workOutExercises)).sorted(by: {$0 < $1})
    }
    
    public func fetchExeciseHistorysDetail() {
        guard let list = model.read() else {return}
        var detailHistory = list.map({
            if let workOutExericse = $0 as? WorkOutExercise {
                return workOutExericse.exercise
            }
            return nil
        })
        detailHistory = detailHistory.filter { exercise in
            guard let exercise else {return false}
            if exercise.name == self.selectExerciseName {
                return true
            }
            else {
                return false
            }
        }
        
    }
}
