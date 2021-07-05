//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {

    public var highStrokeNum = 4
    
    private var timer = Timer()
    private var beepTime = 60
    private let INIT_TEMPO = 60
    private var needToUpdateTimer = false
    private var timerStarted = false
    private var currentStrokeNum = 0
    
    private var playerHighSound : AVAudioPlayer!
    private var playerLowSound : AVAudioPlayer!
    
    //private var player: AVAudioPlayer
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    @IBOutlet var sizeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(INIT_TEMPO)
        initController ()
        setupGestures()
    }
    
    private func initController ()
    {
        minusTenTempoBtn.tempo = -10
        minusOneTempoBtn.tempo = -1
        plusOneTempoBtn.tempo = 1
        plusTenTempoBtn.tempo = 10
        
        playerHighSound = getAudioPlayer(soundName: "met1", soundExt: "wav")
        playerLowSound = getAudioPlayer(soundName: "met2", soundExt: "wav")
    }
    
    private func setupGestures ()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeFirstSize))
        tap.numberOfTapsRequired = 1
        sizeBtn.addGestureRecognizer(tap)
    }
    
    @objc
    private func changeFirstSize()
    {
        guard let sizeVC = storyboard?.instantiateViewController(identifier: "sizeVC") else {
            print("Error, can't create sizeVC")
            return
        }
        
        sizeVC.modalPresentationStyle = .custom
        sizeVC.modalTransitionStyle = .crossDissolve
        sizeVC.preferredContentSize = CGSize(width: 250, height: 250)
        (sizeVC as! SizeViewController).senderViewController = self
        
        self.present(sizeVC, animated: true)
    }

    private func startMetronome ()
    {
        timer.invalidate()
        playSound ()
        updateTimer()
        timerStarted = true
    }
    
    private func stopMetronome ()
    {
        timer.invalidate()
        currentStrokeNum = 0
        timerStarted = false
    }
    
    private func updateTimer ()
    {
        let interval = 60.0 / Double(beepTime)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false, block: { Timer in
            self.playSound ()
            self.updateTimer()
        })
    }
    
    private func playSound ()
    {
        var currPlayer : AVAudioPlayer
        
        if (currentStrokeNum == highStrokeNum)
        {
            currentStrokeNum = 0
        }
        
        if (currentStrokeNum == 0)
        {
            currPlayer = playerHighSound
        }
        else
        {
            currPlayer = playerLowSound
        }
        
        currPlayer.currentTime = 0
        if (!currPlayer.isPlaying)
        {
            currPlayer.play()
        }
        
        currentStrokeNum += 1
    }
    
    private func updateTempoView ()
    {
        tempoLabel.text = String(beepTime)
    }
    
    private func getAudioPlayer (soundName : String, soundExt : String) -> AVAudioPlayer
    {
        let soundUrl = Bundle.main.url(forResource: soundName, withExtension: soundExt)
        
        var player : AVAudioPlayer

        do
        {
            player = try AVAudioPlayer(contentsOf: soundUrl!)
            player.prepareToPlay()
        }
        catch
        {
            fatalError("Error - \(error)")
        }
        
        return player
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton) {
        if (!timerStarted)
        {
            startMetronome ()
        }
        else
        {
            stopMetronome()
        }
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        beepTime += sender.tempo
        updateTempoView ()
    }
}
