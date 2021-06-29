//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {

    private var timer = Timer()
    private var beepTime = 60
    private let INIT_TEMPO = 60
    private var needToUpdateTimer = false
    private var highStrokeNum = 4
    private var currentStrokeNum = 0
    
    private var playerHighSound : AVAudioPlayer!
    private var playerLowSound : AVAudioPlayer!
    
    //private var player: AVAudioPlayer
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(INIT_TEMPO)
        initController ()
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

    private func startMetronome ()
    {
        timer.invalidate()
        updateTimer()
    }
    
    private func StartTimer ()
    {
        timer.invalidate()
        playSound ()
        updateTimer()
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
    
    @IBAction func onStepperChange(_ sender: UIStepper) {
        let val = Int(sender.value)
        tempoLabel.text = String(val)
        beepTime = val
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton) {
        startMetronome ()
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        beepTime += sender.tempo
        updateTempoView ()
    }
}
