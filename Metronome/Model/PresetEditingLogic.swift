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
            
            addOrUpdatePresetPartPosInfo(presetId, presetPartId)
            addOrUpdatePresetPosInfo(presetId)
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
    
    func addOrUpdatePresetPosInfo (_ presetId : Int)
    {
        if (!isPresetPosInfoPersist(presetId))
        {
            addPresetPosInfo(presetId)
        }
    }
    
    func addOrUpdatePresetPartPosInfo (_ presetId : Int, _ presetPartId : Int)
    {
        if (!isPresetPartPosInfoPersist(presetId, presetPartId))
        {
            addPartPosInfo(presetId, presetPartId)
        }
    }
    
    // MARK: CUD for presetPart
    func addPartPosInfo(_ presetId : Int, _ presetPartId : Int) {
        
        if let safeCoreData = _coreDataLogic
        {
            var presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            let presetPartPosWithPresetIdArray = presetPartPosArray.filter{$0.presetId == presetId}
            
            let presetPartPos = PresetPartPosEntity(context: _context)
            presetPartPos.pos = Int32(presetPartPosWithPresetIdArray.count)
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
    
    /*
    func updatePartPosInfoByPos(_ presetId : Int, _ presetPartId : Int, _ pos : Int) {
        if let safeCoreData = _coreDataLogic
        {
            let presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            
            for (i, _) in presetPartPosArray.enumerated()
            {
                //AAAAAAAAA####AAAAAHHHHH
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
    */
    
    func deletePartPos(_ row : Int, _ presetId : Int) {
        if let safeCoreData = _coreDataLogic
        {
            var presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            presetPartPosArray = presetPartPosArray.filter({$0.presetId == presetId})
            presetPartPosArray.sort{$0.pos < $1.pos}
            
            for i in row ..< presetPartPosArray.count {
                presetPartPosArray[i] = presetPartPosArray[i + 1]
            }
            
            _context.delete(presetPartPosArray.last!)
            presetPartPosArray.remove(at: presetPartPosArray.count - 1)
            
            DataContainer.Instance.presetPartPosInfoArray = presetPartPosArray
            safeCoreData.saveData()
        }
    }
    
    func deleteAllPartPosByPresetId(_ presetId : Int) {
        if let safeCoreData = _coreDataLogic
        {
            let presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
            let deletionElems = presetPartPosArray.filter({$0.presetId == presetId})
            let newPartPosArray = presetPartPosArray.filter({$0.presetId != presetId})
            
            for elem in deletionElems {
                _context.delete(elem)
            }
            safeCoreData.saveData()
            
            DataContainer.Instance.presetPartPosInfoArray = newPartPosArray
            
        }
    }
    
    
    
    // MARK: CUD for preset
    func addPresetPosInfo(_ presetId : Int) {
        
        if let safeCoreData = _coreDataLogic
        {
            var presetPosArray = DataContainer.Instance.presetPosInfoArray
            
            let presetPos = PresetPosEntity(context: _context)
            presetPos.presetId = Int32(presetId)
            presetPos.pos = Int32(presetPosArray.count)
            
            presetPosArray.append(presetPos)
            DataContainer.Instance.presetPosInfoArray = presetPosArray
            safeCoreData.saveData()
        }
        else
        {
            print("ERROR - _coreDataLogic == nil")
        }
    }
    
    /*
    func updatePresetPosInfoByPos(_ presetId : Int, _ pos : Int) {
        if let safeCoreData = _coreDataLogic
        {
            let presetPosArray = DataContainer.Instance.presetPosInfoArray
            
            for (i, _) in presetPosArray.enumerated()
            {
                if (presetPosArray[i].pos == pos)
                {
                    presetPosArray[i].presetId = Int32(presetId)
                    break
                }
            }
            
            DataContainer.Instance.presetPosInfoArray = presetPosArray
            safeCoreData.saveData()
        }
        else
        {
            print("ERROR - _coreDataLogic == nil")
        }
    }
 */
    
    func deletePresetPosByRow(_ row : Int) {
        if let safeCoreData = _coreDataLogic
        {
            var presetPosArray = DataContainer.Instance.presetPosInfoArray
            presetPosArray.sort{$0.pos < $1.pos}
            
            let presetId = Int(presetPosArray[row].presetId)
            
            for i in row ..< presetPosArray.count - 1 {
                presetPosArray[i].pos = presetPosArray[i + 1].pos
                presetPosArray[i].presetId = presetPosArray[i + 1].presetId
            }
            
            _context.delete(presetPosArray.last!)
            safeCoreData.saveData()
            
            presetPosArray.remove(at: presetPosArray.count - 1)
            DataContainer.Instance.presetPosInfoArray = presetPosArray
            deleteAllPartPosByPresetId(presetId)
            
            DataContainer.Instance.TEST_checkAllPosData()
        }
    }
    
    //MARK: Auxiliuary funcs
    
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
    
    func getPartPosById (_ presetId : Int, _ presetPartId : Int) -> Int
    {
        let presetPartPosArray = DataContainer.Instance.presetPartPosInfoArray
        
        for elem in presetPartPosArray {
            if (elem.presetPartId == presetPartId && elem.presetId == presetId)
            {
                return Int(elem.pos)
            }
        }
        
        print("WARNING - Can't find preset part pos by id")
        return 0
    }
    
    func getPresetPosById (_ presetId : Int) -> Int
    {
        let presetPosArray = DataContainer.Instance.presetPosInfoArray
        
        for elem in presetPosArray {
            if (elem.presetId == presetId)
            {
                return Int(elem.pos)
            }
        }
        
        print("WARNING - Can't find preset pos by id")
        return 0
    }
}
