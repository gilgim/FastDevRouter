//
//  TempExerciseView.swift
//  SimpleWorkOut
//
//  Created by Gilgim on 2023/08/14.
//

import SwiftUI

struct TempExerciseView: View {
    @State var types = ["Chest", "back", "Shourder", "etc"]
    @State var selectType: String = ""
    @State var isAlertEnable: Bool = false
    @State var tempText: String = ""
    var showSearchView: Bool {
        get {
            return selectType == "magnifyingglass"
        }
    }
    
    @State var searchText: String = ""
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Spacer(minLength: 10)
                    Button {
                        withAnimation {
                            if selectType == "magnifyingglass" {
                                selectType = ""
                            }
                            else {
                                selectType = "magnifyingglass"
                            }
                        }
                    }label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(CustomButtonStyle(isPressed: selectType == "magnifyingglass"))
                    ForEach(types, id:\.self) { type in
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                if selectType == type {
                                    selectType = ""
                                }
                                else {
                                    selectType = type
                                }
                            }
                        }label: {
                            Text(type)
                        }
                        .buttonStyle(CustomButtonStyle(isPressed: selectType == type))
                    }
                    Spacer(minLength: 10)
                }
                .padding(.bottom, 5)
            }
            
            if showSearchView {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 10)
            }
            
            List {
                ForEach(0..<2, id: \.self) { _ in
                    ExerciseContentView(exerciseButtonClickHandler:  {
                        print("HelloWorld")
                    })
                    .listRowInsets(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
                    .background(Color.clear)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(Color(uiColor: .systemBlue))
                        Button {
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(Color(uiColor: .systemRed))
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Exercise")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAlertEnable.toggle()
                }label: {
                    Image(systemName: "plus")
                        .bold()
                }
            }
        }
        .alert("Create Exercise", isPresented: $isAlertEnable) {
            TextField("Exercise Name", text: $tempText)
            TextField("Body Type", text: $tempText)
            Button("Cancle", role: .cancel) {}
            Button("OK") {
                
            }
        }
    }
}

struct TempExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TempExerciseView()
        }
    }
}
