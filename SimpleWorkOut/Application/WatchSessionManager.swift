//
//  WatchSessionManager.swift
//  SimpleWorkOut
//
//  Created by Gilgim on 11/13/23.
//

import Foundation
import WatchConnectivity
import CoreData

final class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    var messageSendAction: (String)->() = {_ in}
    var exerciseSendAction: (Data)->() = {_ in}
    var waitingActions: [()->()] = []
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func sendMessage(_ message: String) {
        guard WCSession.default.activationState == .activated else {
            return
        }
#if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#else
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#endif
        
        WCSession.default.sendMessage(["message" : message], replyHandler: nil) { error in
            print("Cannot send message: \(String(describing: error))")
        }
    }
    
    func sendExercise(_ exercise: Data) {
        guard WCSession.default.activationState == .activated else {
            return
        }
#if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#else
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#endif
        
        WCSession.default.sendMessage(["exercise" : exercise], replyHandler: nil) { error in
            print("Cannot send object: \(String(describing: error))")
            self.waitingActions.append {
                guard WCSession.default.activationState == .activated else {
                    return
                }
#if os(iOS)
                guard WCSession.default.isWatchAppInstalled else {
                    return
                }
#else
                guard WCSession.default.isCompanionAppInstalled else {
                    return
                }
#endif
                WCSession.default.sendMessage(["exercise" : exercise], replyHandler: nil) { error in
                    print("Cannot send object: \(String(describing: error))")
                    
                }
            }
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let message = message["message"] as? String {
            DispatchQueue.main.async { [weak self] in
                self?.messageSendAction(message)
            }
        }
        else if let exercise = message["exercise"] as? Data {
            DispatchQueue.main.async { [weak self] in
                self?.exerciseSendAction(exercise)
            }
        }
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            while !waitingActions.isEmpty {
                if let action = waitingActions.first {
                    DispatchQueue.main.async {
                        action()
                    }
                    waitingActions.remove(at: 0)
                }
            }
        }
    }
}
