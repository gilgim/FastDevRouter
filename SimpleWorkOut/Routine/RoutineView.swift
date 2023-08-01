//
//  RoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct RoutineView: View {
    @State private var isShowAddRoutineView: Bool = false
    var body: some View {
        VStack {
            List {
               
            }
        }
        .navigationDestination(isPresented: $isShowAddRoutineView, destination: {
            
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddRoutineView()
                }label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RoutineView()
        }
    }
}
