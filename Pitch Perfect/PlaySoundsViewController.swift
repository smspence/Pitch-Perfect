//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shawn Spencer on 3/8/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    // The model in our MVC design
    //  this will be set by RecordSoundsViewController
    var receivedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var fileUrl = NSURL.fileURLWithPath( filePath )
//            audioPlayer = AVAudioPlayer(contentsOfURL: fileUrl, error: nil)
//            audioPlayer.enableRate = true
//        }else {
//            println("could not find file movie_quote.mp3")
//        }

        audioEngine = AVAudioEngine()
    }

    override func viewWillAppear(animated: Bool) {
        // Called when view is just about to be showed
        // to user. Good place to show / hide interface elements

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSoundSlow(sender: UIButton) {
        println("in playSoundSlow")
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func playSoundFast(sender: UIButton) {
        println("in playSoundFast")
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }

    @IBAction func playSoundChipmunk(sender: UIButton) {
        println("in playSoundChipmunk")
        playAudioWithChangedPitch(1200)
    }

    @IBAction func playSoundDarthVader(sender: UIButton) {
        println("in playSoundDarthVader")
        playAudioWithChangedPitch(-1200)
    }

    func playAudioWithChangedPitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch

        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func stopPlayback(sender: UIButton) {
        println("in stopPlayback")
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
}
