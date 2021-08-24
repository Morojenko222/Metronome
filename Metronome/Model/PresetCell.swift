//
//  PresetCell.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 15.07.2021.
//

import UIKit

class PresetCell: UITableViewCell {

    @IBOutlet var presetNameLabel: UILabel!

    var indexPath : IndexPath?
    var presetId = -1
    var presetViewController : PresetsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("Checks")
        // Configure the view for the selected state
    }
 */
    
    @IBAction func deleteBtnOnPress(_ sender: UIButton) {
        
        if let presController = presetViewController, let mc = presController.mainController,
           let safeIndexPath = indexPath
        {
            presController.presetViewLogic!.removePreset(presetId, safeIndexPath)
            //mc.presetEditingLogic.deletePresetById(presetId)
            //presController.tableView.deleteRows(at: [safeIndexPath], with: .automatic)
            //presController.tableView.reloadData()
            /*
            var elems = DataContainer.Instance.getElemsByPresetId(cellId)
            for elem in elems {
                
            }
 */
            print("Delete btn")
        }
    }
}
