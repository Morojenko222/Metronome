//
//  PresetsViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 09.07.2021.
//

import UIKit
import MobileCoreServices

class PresetsViewController: UITableViewController
{
    
    var mainController : MainController?
    var presetViewLogic : PresetViewLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(UINib(nibName: "PresetCell", bundle: nil), forCellReuseIdentifier: "presetCell")
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        //tableView.setEditing(true, animated: true)

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddPresetBtnPress))
        
        presetViewLogic = PresetViewLogic(self)
        
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        presetViewLogic!.updateCellArray()
        tableView.reloadData()
    }
    
    @objc func onAddPresetBtnPress()
    {
        if let safePVL = presetViewLogic
        {
            let newPresetId = safePVL.getFreeIdForNewPreset()
            DataContainer.Instance.pickedPresetId = newPresetId
            loadPresetStructureScreen()
        }
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

        if let safePVL = presetViewLogic
        {
            cell.presetNameLabel.text = safePVL.presetInfoArray[indexPath.row].presetLabelText
            cell.presetId = safePVL.presetInfoArray[indexPath.row].presetId
            cell.presetViewController = self
            cell.indexPath = indexPath
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let safePVL = presetViewLogic
        {
            DataContainer.Instance.pickedPresetId = safePVL.presetInfoArray[indexPath.row].presetId
            loadPresetStructureScreen()
        }
    }
    
    // MARK: - Drag and drop support
    
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        if let safePVL = presetViewLogic
        {
            let place = safePVL.presetInfoArray[sourceIndex]
            safePVL.presetInfoArray.remove(at: sourceIndex)
            safePVL.presetInfoArray.insert(place, at: destinationIndex)
        }
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        if let safePVL = presetViewLogic
        {
            let preset = safePVL.presetInfoArray[indexPath.row]
            let itemProvider = NSItemProvider()
            itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
                
                let data = preset.presetLabelText.data(using: .utf8)
                completion(data, nil)
                return nil
            }
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        }
        
        return []
    }
    
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
}
