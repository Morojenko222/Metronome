//
//  PresetViewLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 19.08.2021.
//

import Foundation

class PresetViewLogic
{
    private var _presetViewController : PresetsViewController
    var presetInfoArray : [Preset] = []
    
    init(_ presetVC : PresetsViewController) {
        _presetViewController = presetVC
    }
    
    func updateCellArray ()
    {
        var presetsRowInfo = DataContainer.Instance.presetPosInfoArray
        presetsRowInfo.sort(by: {$0.pos < $1.pos})

        presetInfoArray.removeAll()
        
        for elem in presetsRowInfo {
            let presetNameText = String("Preset \(elem.presetId)")
            let cellElem = Preset(presetId: Int(elem.presetId), presetLabelText: presetNameText)
            presetInfoArray.append(cellElem)
        }
    }
    
    func removePreset(_ removingPresetId : Int, _ indexPath : IndexPath) {
        if let mc = _presetViewController.mainController
        {
            
            for (i, _) in presetInfoArray.enumerated() {
                if (presetInfoArray[i].presetId == removingPresetId)
                {
                    presetInfoArray.remove(at: i)
                    mc.presetEditingLogic.deletePresetById(removingPresetId)
                    mc.presetEditingLogic.deletePresetPosByRow(i)

                    break
                }
            }

            updateCellArray ()
            _presetViewController.tableView.reloadData()
        }
    }
    
    func getFreeIdForNewPreset () -> Int
    {
        let idsSet = DataContainer.Instance.getPresetsIdsSet()
        let sortedSet = idsSet.sorted()
        let lastId = sortedSet.last
        
        if let safeLastId = lastId
        {
            for i in 0...safeLastId
            {
                if (!sortedSet.contains(i))
                {
                    return i
                }
            }
            
            return safeLastId + 1
        }
        else
        {
            return 0
        }
    }
}
