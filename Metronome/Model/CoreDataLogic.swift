//
//  DataCoreLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 10.08.2021.
//

import Foundation
import CoreData

class CoreDataLogic {
    
    var context : NSManagedObjectContext
    
    init(_ inputAppDelegate : AppDelegate) {
        context = inputAppDelegate.persistentContainer.viewContext
    }
    
    // MARK: Methods to Open, Store and Fetch data

        func saveData()
        {
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving context \(error)")
            }
        }

        func loadData()
        {
            let request : NSFetchRequest<PresetEntity> = PresetEntity.fetchRequest()
            
            do
            {
                DataContainer.Instance.presetsArray = try context.fetch(request)
            }
            catch
            {
                print("Error - \(error)")
            }
        }
}
