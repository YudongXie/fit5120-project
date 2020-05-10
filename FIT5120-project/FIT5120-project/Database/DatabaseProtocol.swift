//
//  DatabaseProtocol.swift
//  FIT5120-project
//
//  Created by Simon Xie on 4/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case update
}


enum ListenerType {
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onCheckListChange(change: DatabaseChange, checkList: [CheckList])
}
protocol DatabaseProtocol: AnyObject {
    func addCheckList(questionOne: Bool, questionTwo: Bool, questionThree: Bool, questionFour: Bool, questionFive: Bool, time: String, fatigueLevel: String, rating: Int, weatherTemp: String) -> CheckList
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func update(checkList: CheckList, questionOne: Bool, questionTwo: Bool, questionThree: Bool, questionFour: Bool, questionFive: Bool, fatigueLevel: String, rating: Int, weatherTemp: String)
    func updatePvtResultToCoredata(checkList: CheckList, fatigueLevel: String, rating: Int)
//    func updateQuestionOnly(checkList:CheckList, questionOne: Bool, questionTwo: Bool, questionThree: Bool, questionFour: Bool, questionFive: Bool)
    func updateQuestion(checkList:CheckList, questionChanged: Bool, order: Int)
    func fetchAllCheckList() -> [CheckList]
}


