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
import AVFoundation

//  MARK: Environment
class SoundManager {
    static func DefaultSound() { AudioServicesPlaySystemSound(1007) }
    static func VibrateSound() { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) }
}

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
        if _backgroundElapesdTime == 0 {
            _backgroundElapesdTime = (Util.currentDateToInt() - foregroundTimeStorage) * 100
            foregroundTimeStorage = 0
        }
    }
    private func inactiveMethod() {
        if _backgroundElapesdTime == 0 {
            _backgroundElapesdTime = (Util.currentDateToInt() - foregroundTimeStorage) * 100
            foregroundTimeStorage = 0
        }
        else if foregroundTimeStorage == 0 {
            foregroundTimeStorage = Util.currentDateToInt()
            _backgroundElapesdTime = 0
        }
    }
    private func backgroundMethod() {
        if foregroundTimeStorage == 0 {
            foregroundTimeStorage = Util.currentDateToInt()
            _backgroundElapesdTime = 0
        }
    }
    
}

//  MARK: Timer
class WorkOutTimer: ObservableObject {
    enum WorkOutState {
        case notStart, workingOut, resting, finish
    }
    static let shared = WorkOutTimer()
    
    var totalWorkOutTimer: CustomTimer? = nil
    var singleWorkOutTimer: CustomTimer? = nil
    var restTimer: CustomMinusTimer? = nil
}

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
    public var isExistTimer: Bool {
        get {return self.timer != nil ? false : true}
    }
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.intTime += 1
        })
        if let timer {
            RunLoop.current.add(timer, forMode: .common)
        }
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
    @Published private var intTime: Int
    private var defaultTime: Int
    init(setTime: Int) {
        self.intTime = setTime
        self.defaultTime = setTime
    }
    private var timer: Timer?
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.intTime -= 1
            if self.intTime <= 0 {
//                SoundManager.DefaultSound()
                SoundManager.VibrateSound()
                
                self.stop()
                self.timerStopClosure?(self.intTime)
            }
        })
        if let timer {
            RunLoop.current.add(timer, forMode: .common)
        }
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
            self.stop()
            self.timerStopClosure?(self.intTime)
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
    
    static func formatNumberForDivisibility(double: Double) -> String {
        if double.truncatingRemainder(dividingBy: 1) != 0 {
            return String(format: "%.1f", double)
        }
        else {
            return String(Int(double))
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
//  MARK: UserNotificationCenter
struct CustomNotification {
    private var id: String
    private var title: String
    private var message: String
    init(id: String, title: String = "", message: String = "") {
        self.id = id
        self.title = title
        self.message = message
    }
    mutating func changeIdentifer(id: String) {
        self.id = id
    }
    func addNotification(trigerTime: TimeInterval) {
        let trigerTimeStorage = trigerTime/Double(100)
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.body = message
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: trigerTimeStorage, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}


