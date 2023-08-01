//
//  AddRoutineView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import SwiftUI

struct AddRoutineView: View {
    @ObservedObject private var viewModel = AddRoutineViewModel()
    @State var arr: [Int] = [1,2,3]
    @State var isSelectBar = false
    @State var text: String = ""
    @FocusState var isfocus
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach (arr, id: \.self) { i in
                        Text("\(i)")
                    }
                }
                List {
                    ForEach(viewModel.allExercises, id: \.name) { exercise in
                        HStack {
                            Text(exercise.name)
                            Text(exercise.type)
                        }
                    }
                }
            }
            if isSelectBar {
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                            Button("ok") {
                                withAnimation {
                                    self.isSelectBar = false
                                }
                            }
                            TextField("set", text: $text)
                                .focused($isfocus)
                        }
                        .frame(height: 120)
                        .padding(.bottom, 12)
                    }
                }
            }
        }
    }
}

struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutineView()
    }
}
