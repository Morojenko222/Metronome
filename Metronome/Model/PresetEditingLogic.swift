//
//  PresetEditingLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 01.08.2021.
//

import Foundation

class PresetEditingLogic {
    
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
    
    func updatePickedPresetPart (metronomeLogic : MetronomeLogic)
    {
        let newPresetPart = PresetPart(bpm: metronomeLogic.beepTime, size_1: metronomeLogic.sizeHighStrokeNum, size_2: 4, count: metronomeLogic.presetTactsCount, noteSizeDivider: metronomeLogic.noteSizeDivider)
        
        if (pickedPresetStructNum >= currentPreset.presetParts.count)
        {
            currentPreset.presetParts.append(newPresetPart)
        }
        else
        {
            currentPresetStruct = newPresetPart
        }
    }
}
