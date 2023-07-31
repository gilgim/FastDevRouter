//
//  Util.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import Foundation
import SwiftUI
import CoreData
import Combine

//  MARK: Environment
class AppLifecycleManager: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    static let shared = AppLifecycleManager()
    @Published var appState: PassthroughSubject<ScenePhase, Never> = .init()
    init() {
        appState.sink { [weak self] state in
            guard let self else {return}
            switch state {
            case.active:
                self.activeMethod()
            case.background:
                self.backgroundMethod()
            case.inactive:
                self.inactiveMethod()
            @unknown default:
                break
            }
        }
        .store(in: &cancellables)
    }
    private var foregroundTimeStorage: Int = Int(Date().timeIntervalSince1970)
    private var _backgroundElapesdTime: Int = 0
    var backgroundElapesdTime: Int {
        get {return _backgroundElapesdTime}
    }
    
    private func activeMethod() {
        _backgroundElapesdTime = Util.currentDateToInt() - foregroundTimeStorage
        foregroundTimeStorage = 0
    }
    private func inactiveMethod() {
        
    }
    private func backgroundMethod() {
        foregroundTimeStorage = Util.currentDateToInt()
        _backgroundElapesdTime = 0
    }
    
}

//  MARK: Timer
class CustomTimer: ObservableObject {
    public var secondTime: String {
        get {
            let totalSeconds = Double(intTime) / 100.0
            let minutes = Int(totalSeconds) / 60
            let seconds = Int(totalSeconds) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    public var milliSecondTime: String {
        get {
            return String(format: "%02d.%02d.%02d", intTime / 6000, (intTime / 100) % 60, intTime % 100)
        }
    }
    @Published public var intTime: Int = 0
    private var timer: Timer?
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.intTime += 1
        })
    }
    public func reset() {
        self.intTime = 0
    }
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    public func getTime() -> Int {
        return intTime
    }
    public func addTime(time: Int) {
        intTime += time
    }
}

class CustomMinusTimer: ObservableObject {
    public var timerStopClosure: ((Int) -> ())?
    public var secondTime: String {
        get {
            let minutes = Int(intTime) / 60
            let seconds = Int(intTime) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    public var milliSecondTime: String {
        get {
            return String(format: "%02d.%02d.%02d", intTime / 6000, (intTime / 100) % 60, intTime % 100)
        }
    }
    @Published private var intTime: Int
    private var defaultTime: Int
    init(setTime: Int) {
        self.intTime = setTime
        self.defaultTime = setTime
    }
    private var timer: Timer?
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.intTime -= 1
            if self.intTime == 0 {
                self.timerStopClosure?(self.intTime)
                self.stop()
            }
        })
    }
    public func reset() {
        intTime = defaultTime
    }
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    public func getTime() -> Int {
        return intTime
    }
    public func getDefaultTime() -> Int {
        return defaultTime
    }
    public func minusTime(time: Int) {
        intTime -= time
        if intTime < 0 {
            intTime = 0
        }
    }
}
//  MARK: Util
struct Util {
    static func currentDateToInt() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        return components.hour! * 3600 + components.minute! * 60 + components.second!
    }
    static func intToSecond(intTime: Int) -> String {
        let totalSeconds = Double(intTime) / 100.0
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    static func intToMilliSecond(intTime: Int) -> String {
        return String(format: "%02d.%02d.%02d", intTime / 6000, (intTime / 100) % 60, intTime % 100)
    }
    static func intToInt16(int: Int) -> Int16 {
        if int <= Int(Int16.max) && int >= Int(Int16.min) {
            return Int16(int)
        } else {
            print("Cannot convert, value is out of range for Int16")
            return Int16.max
        }
    }
    
    static func intToInt32(int: Int) -> Int32 {
        if int <= Int(Int32.max) && int >= Int(Int32.min) {
            return Int32(int)
        } else {
            print("Cannot convert, value is out of range for Int16")
            return Int32.max
        }
    }
}

//  MARK: Alert
struct CustomAlert {
    var title: String
    var message: String
    var okButtonAction: (() -> ())?
    var cancelButtonAction: (() -> ())?
}
