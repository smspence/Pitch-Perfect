//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Shawn Spencer on 3/7/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!

    // The model in our MVC design
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        // Called when view is just about to be showed
        // to user. Good place to show / hide interface elements
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        stopButton.hidden = false
        recordingLabel.hidden = false
        recordButton.enabled = false

        // record the user's voice to a file

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        //See http://stackoverflow.com/questions/28096390/is-not-a-postfix-unary-operator
        //   To route the audio to different outputs:
        //   let options = AVAudioSessionCategoryOptions.MixWithOthers | AVAudioSessionCategoryOptions.DefaultToSpeaker
        //   or
        //   let options : AVAudioSessionCategoryOptions = .MixWithOthers | .DefaultToSpeaker
        //   or
        //   session.setCategory(AVAudioSessionCategoryPlayAndRecord,
        //                        withOptions: .MixWithOthers | .DefaultToSpeaker , error: &error)
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }

    // Implementation of method from protocol AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent

            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }else {
            println("error flag in audioRecorderDidFinishRecording")
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            // Get a reference to the view controller that we are segue-ing to (it is our PlaySoundsViewController)
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            // We know that we have passed in a RecordedAudio object as the sender when performSegueWithIdentifier was called
            //  so lets reference that here
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stop(sender: UIButton) {
        println("in stop")
        recordingLabel.hidden = true

        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

