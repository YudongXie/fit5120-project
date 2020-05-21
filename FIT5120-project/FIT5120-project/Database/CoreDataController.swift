//
//  CoreDataController.swift
//  FIT5120-project
//
//  Created by Simon Xie on 4/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate{

    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    // Results
    var allCheckListFetchedResultsController: NSFetchedResultsController<CheckList>?
    override init() {
        persistantContainer = NSPersistentContainer(name: "dataModel")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        // If there are no locations in the database assume that the app is running
        // for the first time. Create the default locations.
        if fetchAllCheckList().count == 0 {
            createDefaultEntries()
        }
    }
    
    
    func createDefaultEntries(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        let _ = addCheckList(questionOne: false, questionTwo: false, questionThree: false, questionFour: false, questionFive: false, time: currentDate, fatigueLevel: "Reaction Test Not Done", rating: 0, weatherTemp: "no record")
    }
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
                print("saved correctly")
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addCheckList(questionOne: Bool, questionTwo: Bool, questionThree: Bool, questionFour: Bool, questionFive: Bool, time: String, fatigueLevel: String, rating: Int, weatherTemp: String) -> CheckList {
        let checkList = NSEntityDescription.insertNewObject(forEntityName: "CheckList", into:
            persistantContainer.viewContext) as! CheckList
        checkList.questionOne = questionOne
        checkList.questionTwo = questionTwo
        checkList.questionThree = questionThree
        checkList.questionFour = questionFour
        checkList.questionFive = questionFive
        
        checkList.time = time
        checkList.fatigueLevel = fatigueLevel
        checkList.rating = Int32(rating)
        checkList.weatherTemp = weatherTemp
        // This less efficient than batching changes and saving once at end.
        saveContext()
        return checkList
    }
      
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.all {
            listener.onCheckListChange(change: .add, checkList:fetchAllCheckList())
        }
        
//        if listener.listenerType == ListenerType.all {
//            listener.onCheckListChange(change: .update, checkList:fetchAllCheckList())
//        }
    }
    
    func update(checkList: CheckList, questionOne: Bool, questionTwo: Bool, questionThree: Bool, questionFour: Bool, questionFive: Bool, fatigueLevel: String, rating: Int, weatherTemp: String){
        checkList.questionOne = questionOne
        checkList.questionTwo = questionTwo
        checkList.questionThree = questionThree
        checkList.questionFour = questionFour
        checkList.questionFive = questionFive
        checkList.fatigueLevel = fatigueLevel
        checkList.rating = Int32(rating)
        checkList.weatherTemp = weatherTemp
        saveContext()
    }
    
    func updatePvtResultToCoredata(checkList: CheckList, fatigueLevel: String, rating: Int){
        checkList.fatigueLevel = fatigueLevel
        checkList.rating = Int32(rating)
        saveContext()
    }
    
    
    func updateQuestion(checkList:CheckList, questionChanged: Bool, order: Int){
        print(questionChanged)
        switch order {
        case 0:
            checkList.questionOne = questionChanged
            break
        case 1:
            checkList.questionTwo = questionChanged
            break
        case 2:
            checkList.questionThree = questionChanged
            break
        case 3:
            checkList.questionFour = questionChanged
            break
        case 4:
            checkList.questionFive = questionChanged
            break
        default:
            break
        }
        saveContext()
    }
    
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func fetchAllCheckList() -> [CheckList] {
        if allCheckListFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<CheckList> = CheckList.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allCheckListFetchedResultsController = NSFetchedResultsController<CheckList>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            allCheckListFetchedResultsController?.delegate = self
            do {
                try allCheckListFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var checkList = [CheckList]()
        if allCheckListFetchedResultsController?.fetchedObjects != nil {
            checkList = (allCheckListFetchedResultsController?.fetchedObjects)!
        }
        return checkList
    }
    
    // MARK: - Fetched Results Conttroller Delegate
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allCheckListFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.all {
                    listener.onCheckListChange(change: .add, checkList: fetchAllCheckList())
                }
            }
        }else if controller == allCheckListFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.all {
                    listener.onCheckListChange(change: .update, checkList: fetchAllCheckList())
                }
            }
        }
    }
    // MARK: - Default entries
  
}

