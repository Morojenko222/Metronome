//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {
    
    //private var player: AVAudioPlayer
    let metronomeLogic = MetronomeLogic()
    let presetEditingLogic = PresetEditingLogic(UIApplication.shared.delegate as! AppDelegate)
    let coreDataLogic = CoreDataLogic(UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    @IBOutlet var sizeBtn: UIButton!
    @IBOutlet var size_2Btn: UIButton!
    @IBOutlet var backToPresetSBtn: UIButton!
    @IBOutlet var notesStackView: UIStackView!
    @IBOutlet var toPresetViewBtn: UIButton!
    @IBOutlet var tactsCountLabel: UILabel!
    @IBOutlet var plusTactBtn: TempoBtns!
    @IBOutlet var minusTactBtn: TempoBtns!
    @IBOutlet var addPresetBtn: TempoBtns!
    @IBOutlet var bottomContainer: UIView!
    
    
    private var notesBtns : [ButtonWithParam]?
    var inPresetMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(metronomeLogic.INIT_TEMPO)
        initController ()
        setupGestures()
        setupNoteButtons()
        setupBackToSButton()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isHidden = true
        
        toPresetViewBtn.isHidden = inPresetMode
        bottomContainer.isHidden = !inPresetMode
        backToPresetSBtn.isHidden = !inPresetMode
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        inPresetMode = false
        metronomeLogic.stopMetronome()
    }
    
    // MARK: - Initialization
    
    private func initController ()
    {
        minusTenTempoBtn.tempo = -10
        minusOneTempoBtn.tempo = -1
        plusOneTempoBtn.tempo = 1
        plusTenTempoBtn.tempo = 10
    }
    
    private func setupGestures ()
    {
        let tap_1 = MyTapGesture(target: self, action: #selector(changeSize))
        tap_1.numberOfTapsRequired = 1
        tap_1.strParam = "FirstSize"
        sizeBtn.addGestureRecognizer(tap_1)
        
        let tap_2 = MyTapGesture(target: self, action: #selector(changeSize))
        tap_2.numberOfTapsRequired = 1
        tap_2.strParam = "SecondSize"
        size_2Btn.addGestureRecognizer(tap_2)
    }
    
    private func setupNoteButtons ()
    {
        var btnsArray = [ButtonWithParam]()
        for subview in notesStackView.subviews {
                for subUiView in subview.subviews {
                    if let buttonView = subUiView as? ButtonWithParam
                    {
                        btnsArray.append(buttonView)
                    }
                }
        }

        for i in 0 ..< btnsArray.count {
            btnsArray[i].param = String(i)
            btnsArray[i].addTarget(self, action: #selector(onNoteBtnPress), for: .touchDown)
        }
    }
    
    private func setupBackToSButton ()
    {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "chevron.left")

        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " Back"))
        backToPresetSBtn.titleLabel!.text = fullString.string
    }
    
    @objc private func changeSize(sender : MyTapGesture)
    {
        if (sender.state != .ended)
        {
            return
        }
        
        guard let sizeVC = storyboard?.instantiateViewController(identifier: "sizeVC") else {
            print("Error, can't create sizeVC")
            return
        }
        
        let sizeVC_Casted = (sizeVC as! SizeViewController)
        sizeVC_Casted.modalPresentationStyle = .custom
        sizeVC_Casted.modalTransitionStyle = .crossDissolve
        sizeVC_Casted.preferredContentSize = CGSize(width: 250, height: 250)
        sizeVC_Casted.metronomeLogic = metronomeLogic
        
        switch sender.strParam {
        case "FirstSize":
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_1
            break
        case "SecondSize":
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_2
            break
        default:
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_1
        }
        
        sizeVC_Casted.sizeName = sender.strParam
        self.present(sizeVC_Casted, animated: true)
    }
    
    private func updateTempoView ()
    {
        tempoLabel.text = String(metronomeLogic.beepTime)
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton)
    {
        metronomeLogic.startMetronomeHandler()
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        metronomeLogic.beepTime += sender.tempo
        updateTempoView ()
    }
    
    @objc func onNoteBtnPress (_ sender: ButtonWithParam)
    {
        switch sender.param {
        case "0":
            metronomeLogic.noteSizeDivider = 1
            break
        case "1":
            metronomeLogic.noteSizeDivider = 2
            break
        case "2":
            metronomeLogic.noteSizeDivider = 3
            break
        case "3":
            metronomeLogic.noteSizeDivider = 4
            break
        default:
            metronomeLogic.noteSizeDivider = 1
        }
    }
    
    @IBAction func toPresetsVCButtonPress(_ sender: Any) {
        
        let id = "presetsVC"
        guard let presetsVC = storyboard?.instantiateViewController(identifier: id) as? PresetsViewController else {
            print("Error - Can't find VC with id = \(id)")
            return
        }
        
        presetsVC.modalPresentationStyle = .fullScreen
        presetsVC.mainController = self
        navigationController?.pushViewController(presetsVC, animated: true)
    }
    @IBAction func changeTactsCountBtnOnPress(_ sender: UIButton) {
        if let titleText = sender.titleLabel?.text
        {
            switch titleText {
            case "+1":
                metronomeLogic.changePresetTactsCount(1)
            case "-1":
                metronomeLogic.changePresetTactsCount(-1)
            default:
                metronomeLogic.changePresetTactsCount(1)
            }
            
            tactsCountLabel.text = String(metronomeLogic.presetTactsCount)
        }
    }
    @IBAction func addPresetBtnOnPress(_ sender: UIButton) {
        presetEditingLogic.updatePickedPresetPart(metronomeLogic: metronomeLogic)
        coreDataLogic.saveData()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backToStructBtnOnPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
