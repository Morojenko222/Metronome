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
            let requestPresetEntity : NSFetchRequest<PresetEntity> = PresetEntity.fetchRequest()
            let requestPresetPosEntity : NSFetchRequest<PresetPosEntity> = PresetPosEntity.fetchRequest()
            let requestPresetPartPosEntity : NSFetchRequest<PresetPartPosEntity> = PresetPartPosEntity.fetchRequest()
            
            do
            {
                DataContainer.Instance.presetsArray = try _context.fetch(requestPresetEntity)
                DataContainer.Instance.presetPosInfoArray = try _context.fetch(requestPresetPosEntity)
                DataContainer.Instance.presetPartPosInfoArray = try _context.fetch(requestPresetPartPosEntity)
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
        
        for presetPos in DataContainer.Instance.presetPosInfoArray {
            _context.delete(presetPos)
        }
        
        for presetPartPos in DataContainer.Instance.presetPartPosInfoArray {
            _context.delete(presetPartPos)
        }
        saveData()
        
        DataContainer.Instance.presetsArray.removeAll()
    }
}
