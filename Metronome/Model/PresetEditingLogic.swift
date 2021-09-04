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

    func updatePickedPresetPart (metronomeLogic : MetronomeLogic)
    {
        if let safeCoreData = _coreDataLogic
        {
            let presetsArray = DataContainer.Instance.presetsArray
            let presetId = DataContainer.Instance.pickedPresetId
            let presetPartId = DataContainer.Instance.pickedPresetStructId
            
            // If preset part already exist
            for (i, _) in presetsArray.enumerated()
            {
                if (presetsArray[i].presetId == presetId && presetsArray[i].presetPartId == presetPartId)
                {
                    presetsArray[i].bpm = Int32 (metronomeLogic.beepTime)
                    presetsArray[i].size1 = Int32 (metronomeLogic.sizeHighStrokeNum)
                    presetsArray[i].size2 = Int32 (4)
                    presetsArray[i].count = Int32 (metronomeLogic.presetTactsCount)
                    presetsArray[i].noteSizeDivider = Int32 (metronomeLogic.noteSizeDivider)
                    
                    DataContainer.Instance.presetsArray = presetsArray
                    safeCoreData.saveData()
                    return
                }
            }
            
            // If it's not exsist
            
            let presetStructElem = PresetEntity(context: _context)
            presetStructElem.presetId = Int32(presetId)
            presetStructElem.presetPartId = Int32(presetPartId)
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
    
    // MARK: Commands for positions info
    
    func addOrUpdatePresetPartPosInfo ()
    {
        
    }
    
    // MARK: CUD for presetPart
    func addPartPosInfo(_ presetId : Int, _ presetPartId : Int) {
        
        if let safeCoreData = _coreDataLogic
        {
            var presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            presetPartPosArray.sort{$0.pos < $1.pos}
            let presetPartPos = PresetPartPosEntity(context: _context)
            presetPartPos.presetId = Int32(presetId)
            presetPartPos.presetPartId = Int32(presetPartId)
            
            presetPartPosArray.append(presetPartPos)
            DataContainer.Instance.presetPartPosInfoArray = presetPartPosArray
            safeCoreData.saveData()
        }
        else
        {
            print("ERROR - _coreDataLogic == nil")
        }
    }
    
    func updatePartPosInfoByPos(_ presetId : Int, _ presetPartId : Int, _ pos : Int) {
        if let safeCoreData = _coreDataLogic
        {
            let presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            
            for (i, _) in presetPartPosArray.enumerated()
            {
                if (presetPartPosArray[i].pos == pos)
                {
                    presetPartPosArray[i].presetId = Int32(presetId)
                    presetPartPosArray[i].presetPartId = Int32(presetPartId)
                    break
                }
            }
            
            DataContainer.Instance.presetPartPosInfoArray = presetPartPosArray
            safeCoreData.saveData()
        }
        else
        {
            print("ERROR - _coreDataLogic == nil")
        }
    }
    
    func deletePartPos(_ row : Int) {
        if let safeCoreData = _coreDataLogic
        {
            var presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            presetPartPosArray.sort{$0.pos < $1.pos}
            
            for i in row ..< presetPartPosArray.count {
                presetPartPosArray[i] = presetPartPosArray[i + 1]
            }
            
            presetPartPosArray.remove(at: presetPartPosArray.count - 1)
            
            DataContainer.Instance.presetPartPosInfoArray = presetPartPosArray
            safeCoreData.saveData()
        }
    }
    
    
    
    func isPresetPartPosInfoPersist(_ presetId : Int, _ presetPartId : Int) -> Bool {
        let presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
        let posArr = presetPartPosArray.filter{elem in
            return (elem.presetId == presetId && elem.presetPartId == presetPartId)
        }
        
        if (posArr.count > 0)
        {
            return true
        }
        
        return false
    }
    
    func isPresetPosInfoPersist(_ presetId : Int) -> Bool {
        let presetPosArray = DataContainer.Instance.presetPosInfoArray
        let posArr = presetPosArray.filter{elem in
            return (elem.presetId == presetId)
        }
        
        if (posArr.count > 0)
        {
            return true
        }
        
        return false
    }
}
