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
    
    func getElemsOfCurrentPreset () -> [PresetEntity] {
        let arrayWithId = presetsArray.filter{elem in
            return elem.presetId == pickedPresetId
        }
        return arrayWithId
    }
    
    func getPresetsCount () -> Int {
        var presetsSet = Set<Int>()
        for preset in presetsArray {
            presetsSet.insert(Int(preset.presetId))
        }
        
        return presetsSet.count
    }
    
    func getPresetsSet () -> Set<Int> {
        var presetsSet = Set<Int>()
        for preset in presetsArray {
            presetsSet.insert(Int(preset.presetId))
        }
        
        return presetsSet
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
    
}
