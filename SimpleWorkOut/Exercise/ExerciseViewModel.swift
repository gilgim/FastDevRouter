//
//  ExerciseViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/26.
//

import Foundation

struct WorkOutByExercise {
    let name: String
    let type: String
    var set: Int
    var rest: Int
}

class ExerciseViewModel: ObservableObject {
    let model = ExerciseModel()
    @Published public var error: ExerciseError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    @Published public var exercises: [(name: String, type: String)] = []
    @Published public var selectExercise: WorkOutByExercise? = nil
    @Published public var canWorkOut: Bool = false
    public func setSelectExerciseSetAndRest(name: String, type: String) {
        self.selectExercise = .init(name: name, type: type, set: 0, rest: 0)
    }
    
    public func setSelectExerciseSetAndRest(set: Int?, rest: Int?) {
        guard let set, let rest else {error = .NotWorkOutError; return}
        self.selectExercise?.set = set
        self.selectExercise?.rest = rest
        self.canWorkOut = true
    }
    
    public func createExercise(name: String, type: String? = nil) {
        do {
            try model.create(name: name, type: type)
            self.fetchExercises()
        }
        catch {
            self.error = error as? ExerciseError
        }
    }
    
    public func delectExercise(name: String) {
        model.delete(name: name)
        fetchExercises()
    }
    
    public func fetchExercises() {
        guard let list = model.read() else {return}
        exercises = list.map({
            if let exercise = $0 as? Exercise {
                 return (exercise.name ?? "", exercise.type ?? "")
            }
            else {
                return ("","")
            }
        })
    }
}
