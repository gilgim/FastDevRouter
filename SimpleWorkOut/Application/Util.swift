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
    static let shared = AppLifecycleManager()
    @Published var appState: PassthroughSubject<ScenePhase, Never> = .init()
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
    @Published private var intTime: Int = 0
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
}

class CustomMinusTimer: ObservableObject {
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
    init(setTime: Int) {
        self.intTime = setTime
    }
    private var timer: Timer?
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.intTime -= 1
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
}
