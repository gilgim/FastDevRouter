//
//  ContentView.swift
//  UITestApp Watch App
//
//  Created by Gaea on 2023/11/15.
//

import SwiftUI

struct ContentView: View {
    @State var number = 1
    var body: some View {
        VStack {
            HStack {
                Button {
                    if number > 1 {
                        number -= 1
                    }
                }label: {
                    Circle()
                        .foregroundStyle(.green)
                        .overlay {
                            Image(systemName: "minus")
                                .fontWeight(.bold)
                        }
                }
                .disabled(number == 1)
                .buttonStyle(.plain)
                .frame(width: 30)
                Spacer()
                Text("\(number) Rep")
                    .font(.system(size: 32))
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    
                Spacer()
                Button {
                    number += 1
                }label: {
                    Circle()
                        .foregroundStyle(.green)
                        .overlay {
                            Image(systemName: "plus")
                                .fontWeight(.bold)
                        }
                }
                
                .buttonStyle(.plain)
                .frame(width: 30)
            }
            HStack {
                Picker(selection: .constant(1)) {
                    Text("1")
                    Text("1")
                } label: {
                    Text("분")
                }
                Picker(selection: .constant(1)) {
                    Text("1")
                    Text("1")
                } label: {
                    Text("초")
                }
            }
            Spacer()
            Button {
                
            }label: {
                Text("시작")
                    .foregroundStyle(.white)
                    .frame(height: 50)
            }
            
            .tint(.green)
        }
    }
}

#Preview {
    ContentView()
}
