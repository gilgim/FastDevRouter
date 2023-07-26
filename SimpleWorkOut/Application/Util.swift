//
//  Util.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import Foundation
import CoreData

//  MARK: Model
protocol Model {
    func create(object: NSManagedObject)
    func read(key: String) -> [NSManagedObject]?
    func update(object: NSManagedObject)
    func delect(object: NSManagedObject)
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
}
