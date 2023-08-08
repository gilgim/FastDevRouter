//
//  WorkHistoryView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct WorkHistoryView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkOutExercise.date, ascending: true)],animation: .default)
    private var workOutHistory: FetchedResults<WorkOutExercise>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkOutRoutine.date, ascending: true)],animation: .default)
    private var workOutRoutineHistory: FetchedResults<WorkOutRoutine>
    var body: some View {
        List {
            ForEach(workOutRoutineHistory) { routine in
                RoutineHistoryContentView(routine: routine)
                .swipeActions {
                    Button{
                        context.delete(routine)
                    }label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            ForEach(workOutHistory) { workOut in
                HStack {
                    Text(workOut.exercise?.name ?? "Not Found")
                    Text(workOut.date?.description ?? "Not Found")
                    NavigationLink("") {
                        WorkOutRecordingView(workoutID: workOut.id ?? UUID())
                    }
                }
                .swipeActions {
                    Button{
                        context.delete(workOut)
                    }label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .listStyle(InsetListStyle())
    }
}

struct WorkHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkHistoryView()
    }
}

struct RoutineHistoryContentView: View {
    @State var routine: WorkOutRoutine
    @State var isOpen: Bool = false
    var body: some View {
        VStack {
            Button {
                isOpen.toggle()
            }label: {
                HStack {
                    Text(routine.routine?.name ?? "Not Found")
                    Text(routine.date?.description ?? "Not Found")
                }
            }
            if isOpen {
                Text("count \((routine.workOutExercise?.allObjects as? [WorkOutExercise])?.count ?? 0)")
                ForEach(routine.workOutExercise?.allObjects as? [WorkOutExercise] ?? []) { workOut in
                    HStack {
                        Text(workOut.exercise?.name ?? "Not Found")
                        Text(workOut.date?.description ?? "Not Found") 
                    }
                }
            }
        }
    }
}
