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
        let presetsSet = DataContainer.Instance.getPresetsIdsSet()
        let presetsArray = presetsSet.sorted()
        
        presetInfoArray.removeAll()
        for elem in presetsArray {
            let presetNameText = String("Preset \(elem)")
            let cellElem = Preset(presetId: elem, presetLabelText: presetNameText)
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

                    break
                }
            }
            
            //_presetViewController.tableView.deleteRows(at: [indexPath], with: .automatic)
            updateCellArray ()
            _presetViewController.tableView.reloadData()
            //_presetViewController.tableView.reloadData()
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
