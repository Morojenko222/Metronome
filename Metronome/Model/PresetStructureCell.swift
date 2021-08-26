//
//  PresetStructureCell.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 19.07.2021.
//

import UIKit

class PresetStructureCell: UITableViewCell {

    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    var indexPath : IndexPath?
    var presetPartId = -1
    var presetStructureController : PresetStructureController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deletePresetStructureOnPress(_ sender: UIButton) {
        if let presController = presetStructureController, let safeIndexPath = indexPath
        {
            presController.presetStructureViewLogic!.removePresetPart(presetPartId, safeIndexPath)
        }
    }
}
