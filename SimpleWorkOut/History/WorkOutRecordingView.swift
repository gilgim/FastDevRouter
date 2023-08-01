//
//  WorkOutRecordingView.swift
//  SimpleWorkOut
//
//  Created by Gilgim on 2023/07/31.
//

import SwiftUI

struct WorkOutRecordingView: View {
    @Environment(\.managedObjectContext) var context
    
    var workoutID: UUID // ID를 통해 원하는 운동 데이터를 찾습니다.
    @FetchRequest var workout: FetchedResults<WorkOutExercise>
    @State var istest = false
    init(workoutID: UUID) {
        self.workoutID = workoutID
        self._workout = FetchRequest(
            entity: WorkOutExercise.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", workoutID as CVarArg)
        )
    }

    var body: some View {
        if let workoutExercise = workout.first,
           let exercise = workoutExercise.exercise,
           let sets = workoutExercise.sets?.allObjects as? [ExerciseSet] {
            NavigationStack {
                VStack(alignment: .leading) {
                    Text("Total WorkOut Time : \(Util.intToSecond(intTime: Int(workoutExercise.totalDuration)))")
                    Text("Total Exercise Time : \(Util.intToMilliSecond(intTime: sets.map({Int($0.exerciseDuration)}).reduce(0, {$0+$1})))")
                    Text("Rest Time : \(Util.intToMilliSecond(intTime: sets.map({Int($0.restDuration)}).reduce(0, {$0+$1})))")
                    Text("Total Volum : \(sets.map({($0.weight*Double($0.reps))}).reduce(0, {$0+$1}))")
                    Text("Doing Set : \(sets.count)")
                    Text("Weight Average : \(sets.map({$0.weight}).reduce(0, {$0+$1}) / Double(sets.count))")
                    Text("Reps Average : \(sets.map({$0.reps}).reduce(0, {$0+Int($1)}) / sets.count)")
                }
                .navigationTitle((exercise.name ?? "Not Found") + " Record")
            }
        } else {
            Text("No Workout Data")
        }
    }
}

struct WorkOutRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        // 테스트 용 UUID를 입력하거나 실제 데이터의 UUID를 입력합니다.
        WorkOutRecordingView(workoutID: UUID())
    }
}
