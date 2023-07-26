//
//  WorkOutView.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import SwiftUI

struct WorkOutView: View {
    enum WorkOutState: String {
        case start = "Start"
        case stop = "Stop"
        case finish = "Finish"
    }
    @ObservedObject private var timer: CustomTimer = .init()
    @State private var workOutState: WorkOutState = .start
    @State var setCount: String
    @State var setRestTime: String
    @State var currentSet: String = "1"
    init(setCount: String, setRestTime: String) {
        self.setCount = setCount
        self.setRestTime = setRestTime
    }
    
    var body: some View {
        VStack {
            Text(timer.secondTime)
            Text("\(currentSet)/\(setCount)")
            Spacer()
            Button {
                switch workOutState {
                case.start:
                    timer.start()
                case.stop:
                    timer.stop()
                case.finish:
                    timer.reset()
                }
                if workOutState == .start {
                    workOutState = .stop
                }
                else if workOutState == .stop {
                    workOutState = .start
                }
            }label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .frame(height: 120)
                    Text(workOutState.rawValue)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct WorkOutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkOutView(setCount: "0", setRestTime: "0")
        }
    }
}
