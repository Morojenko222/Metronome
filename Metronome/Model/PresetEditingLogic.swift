//
//  PresetEditingLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 01.08.2021.
//

import Foundation
import CoreData

class PresetEditingLogic {
    
    private var _context : NSManagedObjectContext
    private var _coreDataLogic : CoreDataLogic?
    
    init(_ inputAppDelegate : AppDelegate, _ coreDataLogic : CoreDataLogic) {
        _context = inputAppDelegate.persistentContainer.viewContext
        _coreDataLogic = coreDataLogic
    }

    // TODO: Make editing logic
    func updatePickedPresetPart (metronomeLogic : MetronomeLogic)
    {
        if let safeCoreData = _coreDataLogic
        {
            let presetStructElem = PresetEntity(context: _context)
            presetStructElem.presetId = Int32(DataContainer.Instance.pickedPresetId)
            presetStructElem.presetPartId = Int32(DataContainer.Instance.pickedPresetStructId)
            presetStructElem.bpm = Int32 (metronomeLogic.beepTime)
            presetStructElem.size1 = Int32 (metronomeLogic.sizeHighStrokeNum)
            presetStructElem.size2 = Int32 (4)
            presetStructElem.count = Int32 (metronomeLogic.presetTactsCount)
            presetStructElem.noteSizeDivider = Int32 (metronomeLogic.noteSizeDivider)
            
            DataContainer.Instance.presetsArray.append(presetStructElem)
            safeCoreData.saveData()
        }
    }
    
    func deletePresetById (_ id : Int)
    {
        if let safeCoreData = _coreDataLogic
        {
            let presetArrayById = DataContainer.Instance.getElemsByPresetId(id)

            let presetArray = DataContainer.Instance.presetsArray
            let filteredPresetArray = presetArray.filter{$0.presetId != id}
                DataContainer.Instance.presetsArray = filteredPresetArray
            
            for elem in presetArrayById {
                // It leads to make zero elem in presetArray. We need do this
                // after removing this elem from presetArray
                _context.delete(elem)
                
            safeCoreData.saveData()
            }
        }
    }
 
    func deletePresetPartById (_ id : Int)
    {
        if let safeCoreData = _coreDataLogic
        {
            let currentPresetId = DataContainer.Instance.pickedPresetId
            let presetArray = DataContainer.Instance.presetsArray
            
            for (i, _) in presetArray.enumerated()
            {
                if (presetArray[i].presetId == currentPresetId && presetArray[i].presetPartId == id)
                {
                    _context.delete(presetArray[i])
                    safeCoreData.saveData()
                    DataContainer.Instance.presetsArray.remove(at: i)
                    break
                }
            }
        }
    }
}
