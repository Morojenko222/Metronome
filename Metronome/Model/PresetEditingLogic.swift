//
//  PresetEditingLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 01.08.2021.
//

import Foundation
import CoreData

class PresetEditingLogic {
    
    var context : NSManagedObjectContext
    
    init(_ inputAppDelegate : AppDelegate) {
        context = inputAppDelegate.persistentContainer.viewContext
    }

    func updatePickedPresetPart (metronomeLogic : MetronomeLogic)
    {
        let presetStructElem = PresetEntity(context: context)
        presetStructElem.presetId = Int32(DataContainer.Instance.pickedPresetId)
        presetStructElem.presetPartId = Int32(DataContainer.Instance.pickedPresetStructId)
        presetStructElem.bpm = Int32 (metronomeLogic.beepTime)
        presetStructElem.size1 = Int32 (metronomeLogic.sizeHighStrokeNum)
        presetStructElem.size2 = Int32 (4)
        presetStructElem.count = Int32 (metronomeLogic.presetTactsCount)
        presetStructElem.noteSizeDivider = Int32 (metronomeLogic.noteSizeDivider)
        
        DataContainer.Instance.presetsArray.append(presetStructElem)
        /*
        let data = DataContainer.Instance
        
        if (data.pickedPresetStructNum >= data.currentPreset.presetParts.count)
        {
            data.currentPreset.presetParts.append(newPresetPart)
        }
        else
        {
            data.currentPresetStruct = newPresetPart
        }
 */
    }
    
    func deletePresetById (_ id : Int)
    {
        let presetArray = DataContainer.Instance.getElemsByPresetId(id)

        for elem in presetArray {
            context.delete(elem)
            
        let filteredPresetArray = presetArray.filter{$0.presetId != id}
            DataContainer.Instance.presetsArray = filteredPresetArray
        }
    }
 
    func deletePresetPartById (_ id : Int)
    {
        let currentPresetId = DataContainer.Instance.pickedPresetId
        let presetArray = DataContainer.Instance.presetsArray
        
        for (i, _) in presetArray.enumerated()
        {
            if (presetArray[i].presetId == currentPresetId && presetArray[i].presetPartId == id)
            {
                context.delete(presetArray[i])
                DataContainer.Instance.presetsArray.remove(at: i)
                break
            }
        }
    }
}
