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
    
    var presets : [Preset] = []
    
    var pickedPresetNum = 0
    var pickedPresetStructNum = 0
    
    var currentPreset : Preset
    {
        get{return DataContainer.Instance.presets[pickedPresetNum]}
        set{DataContainer.Instance.presets[pickedPresetNum] = newValue}
    }
    
    var currentPresetStruct : PresetPart
    {
        get{return DataContainer.Instance.presets[pickedPresetNum].presetParts[pickedPresetStructNum]}
        set{DataContainer.Instance.presets[pickedPresetNum].presetParts[pickedPresetStructNum] = newValue}
    }
    
    func cleanEmptyPresets ()
    {
        var emptyNumbers : [Int] = []
        for (i, preset) in DataContainer.Instance.presets.enumerated() {
            if (preset.presetParts.count == 0)
            {
                emptyNumbers.append(i)
            }
        }
        
        for num in emptyNumbers {
            DataContainer.Instance.presets.remove(at: num)
        }
    }
}
