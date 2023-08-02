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
    var body: some View {
        List {
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
    }
}

struct WorkHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkHistoryView()
    }
}
