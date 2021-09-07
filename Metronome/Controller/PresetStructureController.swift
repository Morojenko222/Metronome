//
//  PresetStructureController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 21.07.2021.
//

import UIKit

class PresetStructureController: UITableViewController {
    
    
    var mainController : MainController?
    var presetStructureViewLogic : PresetStructureViewLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PresetStructureCell", bundle: nil), forCellReuseIdentifier: "presetStructureCell")
        tableView.rowHeight = 60.0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddPresetPartBtnPress))
        
        presetStructureViewLogic = PresetStructureViewLogic(self)
    }
    
    @objc func onAddPresetPartBtnPress()
    {
        let presetStructs = DataContainer.Instance.getElemsOfCurrentPreset()
        DataContainer.Instance.pickedPresetStructId = presetStructs.count
        goToSetPresetPartScreen()
    }
    
    func goToSetPresetPartScreen ()
    {
        performSegue(withIdentifier: "toEditPresetStruct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPresetStruct" {
            if let mainVCSafe = segue.destination as? MainController {
                mainVCSafe.inPresetMode = true
                mainVCSafe.modalPresentationStyle = .fullScreen
            }
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        presetStructureViewLogic!.updateCellArray()
        tableView.reloadData()
    }
    
    internal override func viewWillDisappear(_ animated: Bool) {
        presetStructureViewLogic!.stopPlaying()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataContainer.Instance.getElemsOfCurrentPreset().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetStructureCell", for: indexPath) as! PresetStructureCell
        
        if let safePSVL = presetStructureViewLogic
        {
            if (indexPath.row == 0)
            {
                safePSVL.presetPartCellArray.removeAll()
            }
            
            cell.presetStructureController = self
            cell.indexPath = indexPath
            cell.presetPartId = safePSVL.presetPartInfoArray[indexPath.row].id
            
            let bpm = safePSVL.presetPartInfoArray[indexPath.row].bpm
            let count = safePSVL.presetPartInfoArray[indexPath.row].count
            let size = safePSVL.presetPartInfoArray[indexPath.row].size_1
            
            cell.bpmLabel.text = "BMM: \(bpm)"
            cell.countLabel.text = "Count: \(count)"
            cell.sizeLabel.text = "Size: \(size)"
            safePSVL.presetPartCellArray.append(cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DataContainer.Instance.pickedPresetStructId = indexPath.row
        goToSetPresetPartScreen()
    }

    func playBtnHandler (_ indexPath : IndexPath)
    {
        presetStructureViewLogic?.playPart(indexPath)
    }
}
