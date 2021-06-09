//
//  itemModel.swift
//  ToDoListApp
//
//  Created by admin on 5/6/21.
//

import Foundation



struct ItemModel: Identifiable, Codable {
    let id : String
    let title: String
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, isCompleted: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> ItemModel{
        return ItemModel(id: id, title: title, isCompleted: !isCompleted)
    }
}


import SwiftUI

class StopWatchManager: ObservableObject {
    
    enum stopWatchMode {
        case running
        case stopped
        case paused
    }
    
    @Published var mode: stopWatchMode = .stopped
    
    @Published var secondsElapsed = 0.0
    @Published var minutesElapsed = 0.0
    @Published var hoursElapsed = 0.0
    
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){timer in
            if self.secondsElapsed > 59.9{
                self.secondsElapsed = 0
                self.minutesElapsed += 1.0
            }else{
                self.secondsElapsed += 0.1
            }
            if self.minutesElapsed > 59.0{
                self.minutesElapsed = 0
                self.hoursElapsed += 1.0
            }
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    func stop() {
        timer.invalidate()
        secondsElapsed = 0.0
        mode = .stopped
    }
}
