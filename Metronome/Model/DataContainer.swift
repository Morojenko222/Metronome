//
//  DataContainer.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 05.07.2021.
//

import Foundation

class DataContainer {
    
    static var Instance = DataContainer()
    
    let sizeData_1 = [1, 2, 3, 4, 5, 6, 7, 8]
    let sizeData_2 = [4, 8]
    
    var presetsArray : [PresetEntity] = []
    var presetPosInfoArray : [PresetPosEntity] = []
    var presetPartPosInfoArray : [PresetPartPosEntity] = []
    
    var pickedPresetId = 0
    var pickedPresetStructId = 0
    
    /*
    var currentPreset : PresetEntity
    {
        get{return DataContainer.Instance.presetsArray[pickedPresetId]}
        set{DataContainer.Instance.presetsArray[pickedPresetId] = newValue}
    }
 */
    
    /*
    func getPresetsCount () -> Int
    {
        var maxId = 0
        
        if (presetsArray.count == 0)
        {
            return 0
        }
        
        for elem in presetsArray {
            if (maxId < elem.presetId)
            {
                maxId = Int(elem.presetId)
            }
        }
        
        return maxId + 1;
    }
 */
    
    func getElemsByPresetId(_ id : Int) -> [PresetEntity] {
        let arrayWithId = presetsArray.filter{elem in
            return elem.presetId == id
        }
        return arrayWithId
    }
    
    func getElemsOfCurrentPreset () -> [PresetPart] {
        let arrayWithId = presetsArray.filter{elem in
            return elem.presetId == pickedPresetId
        }
        var presetParts : [PresetPart] = []
        for elem in arrayWithId {
            let newPartInfo = PresetPart(id: Int(elem.presetPartId) ,bpm: Int(elem.bpm), size_1: Int(elem.size1), size_2: Int(elem.size2), count: Int(elem.count), noteSizeDivider: Int(elem.noteSizeDivider))
            presetParts.append(newPartInfo)
        }
        
        return presetParts
    }
    
    func getPresetsIdsSet () -> Set<Int> {
        var presetsSet = Set<Int>()
        for preset in presetsArray {
            presetsSet.insert(Int(preset.presetId))
        }
        
        return presetsSet
    }
    
    func getPresetsCount () -> Int {
        let presetSet = getPresetsIdsSet ()
        return presetSet.count
    }
    
    
    /*
    func cleanEmptyPresets ()
    {
        var emptyNumbers : [Int] = []
        for (i, _) in DataContainer.Instance.presetsArray.enumerated() {
            if (presetsArray.count == 0)
            {
                emptyNumbers.append(i)
            }
        }
        
        for num in emptyNumbers {
            presetsArray.remove(at: num)
        }
    }
    */
    
    func TEST_checkAllPosData()
    {
        print("presetPosInfoArray")
        for elem in presetPosInfoArray {
            print("PresetId = \(elem.presetId), pos = \(elem.pos)")
        }
        
        print("presetPartPosInfoArray")
        for elem in presetPartPosInfoArray {
            print("PresetId = \(elem.presetId), PresetPartId = \(elem.presetPartId), pos = \(elem.pos)")
        }
    }
    
}
