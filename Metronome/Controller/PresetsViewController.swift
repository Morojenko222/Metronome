//
//  PresetsViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 09.07.2021.
//

import UIKit

class PresetsViewController: UITableViewController {
    
    var mainController : MainController?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PresetCell", bundle: nil), forCellReuseIdentifier: "presetCell")
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddPresetBtnPress))

        tableView.reloadData()
    }
    
    @objc func onAddPresetBtnPress()
    {
        let presetsCount = DataContainer.Instance.presets.count
        loadPresetStructureScreen(presetsCount)
    }
    
    private func loadPresetStructureScreen (_ presetNum : Int)
    {
        let id = "presetEditVC"
        guard let presetsEditVC = storyboard?.instantiateViewController(identifier: id) as? PresetStructureController else {
            print("Error - Can't get PresetStructureId")
            return
        }
        
        DataContainer.Instance.presets.append(Preset(presetParts: []))
        
        presetsEditVC.modalPresentationStyle = .fullScreen
        presetsEditVC.mainController = mainController
        
        if let safeMC = mainController, let safeNavC = navigationController
        {
            safeMC.presetEditingLogic.pickedPresetNum = presetNum
            safeNavC.pushViewController(presetsEditVC, animated: true)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let presets = DataContainer.Instance.presets
        return presets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)
        //cell.textLabel?.text = String(activeData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        loadPresetStructureScreen(indexPath.row)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
