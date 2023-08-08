//
//  RoutineViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation
struct WorkOutByRoutine {
    //  [Routine]
    //  여러개의 공통 운동을 쓰기위해서 추가된 id
    var id = UUID()
    let name: String
    let type: String?
    let exercises: [WorkOutByExercise]
}
class RoutineViewModel: ObservableObject {
    @Published var routines: [(id: UUID, name: String, type: String?, exercises: [WorkOutByExercise])] = []
    @Published var isWorkOut: Bool = false
    
    var selectRoutine: WorkOutByRoutine? = nil
    let model = RoutineModel()
    
    public func setSelectRoutine(selectRoutine: (id: UUID ,name: String, type: String?, exercises: [WorkOutByExercise])) {
        let routine: WorkOutByRoutine = .init(id: selectRoutine.id , name: selectRoutine.name, type: selectRoutine.type, exercises: selectRoutine.exercises)
        self.selectRoutine = routine
        self.isWorkOut.toggle()
    }
    public func delectRoutine(name: String) {
        model.delete(name: name)
        fetchRoutines()
    }
    public func fetchRoutines() {
        guard let list = model.read() as? [Routine] else {return}
        routines = list.map({
            guard let exercises = $0.routineExercise?.allObjects as? [RoutineExercise] else {return (UUID(),"",nil,[])}
            
            var exerciseStorage: [WorkOutByExercise] = []
            for exercise in exercises {
                let workOutByExercise = WorkOutByExercise(id: exercise.id ?? UUID(), name: exercise.exercise?.name ?? "", type: exercise.exercise?.type ?? "", set: Int(exercise.setReps), rest: Int(exercise.restDuration))
                exerciseStorage.append(workOutByExercise)
            }
            
            return ($0.id ?? UUID(), $0.name ?? "", $0.type, exerciseStorage)
        })
    }
}
