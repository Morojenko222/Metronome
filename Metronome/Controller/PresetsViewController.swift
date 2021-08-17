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
    
    internal override func viewWillAppear(_ animated: Bool) {
        mainController?.coreDataLogic.loadData()
        //DataContainer.Instance.cleanEmptyPresets()
        tableView.reloadData()
    }
    
    @objc func onAddPresetBtnPress()
    {
        let presetCount = DataContainer.Instance.getPresetsCount()
        DataContainer.Instance.pickedPresetId = presetCount
        loadPresetStructureScreen()
    }
    
    private func loadPresetStructureScreen ()
    {
        let id = "presetEditVC"
        guard let presetsEditVC = storyboard?.instantiateViewController(identifier: id) as? PresetStructureController else {
            print("Error - Can't get PresetStructureId")
            return
        }
        
        presetsEditVC.modalPresentationStyle = .fullScreen
        presetsEditVC.mainController = mainController
        
        if let safeNavC = navigationController
        {
            safeNavC.pushViewController(presetsEditVC, animated: true)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let presetsCount = DataContainer.Instance.getPresetsCount()
        
        return presetsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath) as! PresetCell
        
        let presetsSet = DataContainer.Instance.getPresetsSet()
        let presetsArray = presetsSet.sorted()
        cell.presetNameLabel.text = String("Preset \(presetsArray[indexPath.row])")
        cell.indexPath = indexPath
        cell.presetViewController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DataContainer.Instance.pickedPresetId = indexPath.row
        loadPresetStructureScreen()
    }    
}
