//
//  DataCoreLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 10.08.2021.
//

import Foundation
import CoreData

class CoreDataLogic {
    
    private var _context : NSManagedObjectContext
    
    init(_ inputAppDelegate : AppDelegate) {
        _context = inputAppDelegate.persistentContainer.viewContext
    }
    
    // MARK: Methods to Open, Store and Fetch data

        func saveData()
        {
            do
            {
                try _context.save()
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
                DataContainer.Instance.presetsArray = try _context.fetch(request)
            }
            catch
            {
                print("Error - \(error)")
            }
        }
    
    func cleanAllData() {
        for preset in DataContainer.Instance.presetsArray {
            _context.delete(preset)
        }
        saveData()
        
        DataContainer.Instance.presetsArray.removeAll()
    }
}
