//
//  InterviewViewController.swift
//  intervyou
//
//  Created by Ashwin Vivek on 1/21/17.
//  Copyright © 2017 BrianShih. All rights reserved.
//

import UIKit
import ToneAnalyzerV3
import Speech
import SwiftSiriWaveformView
import AVFoundation

var userName = ""
import AVFoundation

var speechRecognitionEnabled = false

let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
/////////////////////////////////////////////////////////////////////////

//Parsing tone in the whole document
var UserEmotionTonesInDocument = ["Anger", "Disgust", "Fear", "Joy", "Sadness"]
var UserScoresForEmotionTonesInDocument = [Double]()

var UserLanguageTonesInDocument = ["Analytical", "Confident", "Tentative"]
var UserScoresForLanguageTonesInDocument = [Double]()

var UserSocialTonesInDocument = ["Openness", "Conscientiousness", "Extraversion", "Agreeableness", "Emotional Range"]
var UserScoresForSocialTonesInDocument = [Double]()

////
var emotionTonesInDocument = ["Anger", "Disgust", "Fear", "Joy", "Sadness"]
var scoresForEmotionTonesInDocument = [Double]()

var languageTonesInDocument = ["Analytical", "Confident", "Tentative"]
var scoresForLanguageTonesInDocument = [Double]()

var socialTonesInDocument = ["Openness", "Conscientiousness", "Extraversion", "Agreeableness", "Emotional Range"]
var scoresForSocialTonesInDocument = [Double]()


var companyName = ""

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


class InterviewViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var tieImage: UIImageView!
    
    
    var speech_4 = ["Great", "Alright", "That’s cool"]
    var speech_5 = ["Awesome, I'd love to hear your thoughts on", "So lets talk about", "Now tell me what you think about"]
    
    var speech_6 = ["What else?", "Any final thoughts?", "Anything else you’d like to add?"]
    
    var speech_7 = ["That was great", "Alright that’s all we need", "Good job"]
    
    var speech_8 = ["I'm gonna forward my notes about our talk to my boss, Dr. Watson"]
    
    var speech_9 = ["Now let’s take a look at your fit for \(companyName)", "Here’s how \(companyName) and you can work together"]
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    @IBOutlet weak var dialogueLabel: UILabel!
    
    //var timer: Timer!
    
    var timeBetweenSherlockSpeaking: Timer!
    var counterForSpeech = 1
    
    var timer:Timer?
    var change:CGFloat = 0.01
    
    var speakQuestion3 = false
    
    //Speech dialogue
    
    var i = 0;
    
    @IBAction func playButton(_ sender: Any) {
        switch (i)
        {
            case 1: speak(string: speech_4[0]); break;
        case 2: speak (string: speech_5[0]); break;
        default: run(); break;
        }
        i = i+1;
        
        
    }
    
    func getName() -> String
    {
        let s = "\(UIDevice.current.name)"
        return s.replacingOccurrences(of: "s iPhone", with: "");
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        userName = getName()
        
        var speech_0 =
            [   "Good Morning \(userName). My name is Sherlock. Welcome to \(companyName). We’re gonna go through 3 questions to get to know you better. Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. Welcome to \(companyName). We’re gonna go through 3 questions to get to know you better. Shall we get started?",
                "Good Morning \(userName). My name is Sherlock. Welcome to \(companyName). Let’s talk about your fit at \(companyName). Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. Welcome to \(companyName). Let’s talk about your fit at \(companyName). Shall we get started?",
                "Good Morning \(userName). My name is Sherlock. Great to have you at \(companyName). We’re gonna go through 3 questions to get to know you better. Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. Great to have you at \(companyName). We’re gonna go through 3 questions to get to know you better. Shall we get started?",
                "Good Morning \(userName). My name is Sherlock. Great to have you at \(companyName). Let’s talk about your fit at \(companyName). Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. Great to have you at \(companyName). Let’s talk about your fit at \(companyName). Shall we get started?",
                "Good Morning \(userName). My name is Sherlock. I will be your virtual recruitment assistant at \(companyName). We’re gonna go through 3 questions to get to know you better. Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. I will be your virtual recruitment assistant at \(companyName). We’re gonna go through 3 questions to get to know you better. Shall we get started?",
                "Good Morning \(userName). My name is Sherlock. I will be your virtual recruitment assistant at \(companyName). Let’s talk about your fit at \(companyName). Whenever you are ready...",
                "Good Morning \(userName). My name is Sherlock. I will be your virtual recruitment assistant at \(companyName). Let’s talk about your fit at \(companyName). Shall we get started?"
        ]
        
        var message = speech_0[Int(arc4random_uniform(UInt32(speech_0.count)))]
        
        let s = message
        var r = [Range<String.Index>]()
        let t = s.linguisticTags(
            in: s.startIndex..<s.endIndex,
            scheme: NSLinguisticTagSchemeLexicalClass,
            tokenRanges: &r)
        var result = [String]()
        let ixs = t.enumerated().filter {
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].lowerBound}
        var prev = s.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                s[r].trimmingCharacters(
                    in: NSCharacterSet.whitespaces))
            prev = s.index(after: ix)
        }

        speak(string: speech_0[Int(arc4random_uniform(UInt32(speech_0.count)))])

        timeBetweenSherlockSpeaking = Timer.scheduledTimer(timeInterval: 13, target: self, selector: #selector(run), userInfo: nil, repeats: false)
        
        label.text = result[0]
        label2.text = result[1]
        label3.text = result[2]
        
        label.alpha = 0
        label.center.y += 50
        label2.alpha = 0
        label2.center.y += 50
        label3.alpha = 0
        label3.center.y += 50
        tieImage.alpha = 0
        tieImage.center.y += 50

        print("recording")
    }
    override func viewDidAppear(_ animated: Bool) {
        
        tieImage.image = UIImage(named: companyImage)
        /*
        switch companyName {
        case "IBM":
            tieImage.image = UIImage(named: companyImage)
            break
        case "Google":
            tieImage.image = UIImage(named: companyImage)
            break
        case "Snapchat":
            tieImage.image = UIImage(named: "Snap.png")
            break
        case "Goldman Sacks":
            tieImage.image = UIImage(named: "Goldman.png")
            break
        case "The US Army":
            tieImage.image = UIImage(named: "Military.png")
            break
        default:
            break
        }*/

        UIView.animate(withDuration: 1, animations: {
            self.label.alpha = 1
            self.label.center.y -= 50
        })
        delayWithSeconds(1) {
            UIView.animate(withDuration: 1, animations: {
                self.label2.alpha = 1
                self.label2.center.y -= 50
            })
        }
        
        delayWithSeconds(2) {
            UIView.animate(withDuration: 1, animations: {
                self.label3.alpha = 1
                self.label3.center.y -= 50
            })
        }
        
        delayWithSeconds(4) {
            UIView.animate(withDuration: 1, animations: {
                self.tieImage.alpha = 1
                self.tieImage.center.y -= 50
            })
        }
        
        
    }
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    //        questionLabel.text = "\(arrayOfQuestions[questionToAsk])"
    
    func speak(string: String)
    {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        //utterance.postUtteranceDelay = 2.0
        
        let synthesizer = AVSpeechSynthesizer()
        
        stopSpeech()
        
        if synthesizer.isSpeaking == false {
            synthesizer.speak(utterance)
        }
        
        //synthesizer.speak(utterance)
    }
    
    
    func randomNumber(range: ClosedRange<Int> = 1...6) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    
    func stopSpeech() {
        
        let synthesizer = AVSpeechSynthesizer()
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            var utterance = AVSpeechUtterance(string: "")
            synthesizer.speak(utterance)
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func run(){
        self.performSegue(withIdentifier: "toQuestions", sender: Any?.self)
    }
    func nextDialogue(){        //handles timing for computer dialogue
        
        var speech_1 = ["Welcome to \(companyName)", "Great to have you at \(companyName)", "I will be your virtual recruitment assistant at \(companyName)"]
        
        var speech_2 = ["We’re gonna go through 3 questions to get to know you better", "Let’s talk about your fit at \(companyName)"]
        
        print ("Reached here - \(counterForSpeech)")
        print ("Reached here - \(counterForSpeech)")
        
        if(counterForSpeech == 1){
            speak(string: speech_1[Int(arc4random_uniform(UInt32(speech_1.count)))])
            counterForSpeech+=1
            return
        }
        else if(counterForSpeech == 2){
            speak(string: speech_2[Int(arc4random_uniform(UInt32(speech_2.count)))])
            counterForSpeech+=1
            return
        }
        self.performSegue(withIdentifier: "toQuestions", sender: Any?.self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        speak(string: "Okay, let's go")
    }
}
