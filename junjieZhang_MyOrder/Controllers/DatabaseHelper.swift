//
//  DatabaseHelper.swift
//  junjieZhang_MyOrder
//
//  Created by Junjie Zhang on 2021-03-23.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    private static var shared : DatabaseHelper?
    
    static func getInstance() -> DatabaseHelper{
        if shared != nil{
            return shared!
        }else{
            return DatabaseHelper(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "ToDo"
    
    private init (context : NSManagedObjectContext){
        self.moc = context
    }
    
    func insertTask(newToDo: Task){
        do{
            let taskTobeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! ToDo
                
            taskTobeAdded.coffeeQuantity = newToDo.coffeeQTY
            taskTobeAdded.coffeeSize = newToDo.coffeeSize
            taskTobeAdded.coffeeType = newToDo.coffeeType
            taskTobeAdded.orderID = UUID()
            taskTobeAdded.orderDateCreated = Date()
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data inserted successfully")
            }
            
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    
    func searchTask(taskID: UUID) -> ToDo?{
        print(taskID)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "orderID == %@", taskID as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first as? ToDo
            }
        }catch let error as NSError{
            print("Unable to search task \(error)")
        }
        
        return nil
    }
    
    func updateTask(updatedTask: ToDo){
        print(updatedTask.orderID!)
        let searchResult = self.searchTask(taskID: updatedTask.orderID! as UUID)
        
        if(searchResult != nil){
            do{
                let taskToUpdate = searchResult!
                
                taskToUpdate.coffeeQuantity = updatedTask.coffeeQuantity
                taskToUpdate.coffeeSize = updatedTask.coffeeSize
                taskToUpdate.coffeeType = updatedTask.coffeeType
                
                try self.moc.save()
                print(#function, "Task updated successfully")
            }catch let error as NSError{
                print(#function, "Unable to update task \(error)")
            }
        }
        
        
    }
    
    func deleteTask(taskID : UUID){
        let searchResult = self.searchTask(taskID: taskID)
        
        if(searchResult != nil){
            do{
                self.moc.delete(searchResult!)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.saveContext()
                
                print(#function, "Task deleted successfully")
            }catch let error as NSError{
                print("Unable to delete task \(error)")
            }
        }
    }
    
    func getAllTodos() -> [ToDo]?{
        let fetchRequest = NSFetchRequest<ToDo>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "orderDateCreated", ascending: true)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            
            print(#function, "Fetch data : \(result as [ToDo])")
            
            return result as [ToDo]
        }catch let error as NSError{
            print("Could not fetch data \(error) \(error.code))")
        }
        
        return nil
    }
    
    
}
