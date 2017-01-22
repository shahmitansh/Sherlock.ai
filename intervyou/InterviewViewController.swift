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


var speechRecognitionEnabled = false
let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

////Parsing tones in each sentence
//var sentenceIndexArray = [Int]()
//var sentenceText = [String]()
//
//var emotionTonesBySentence = [String]()
//var scoresForEmotionTonesBySentence = [String]()
//
//var socialTonesBySentence = [String]()
//var scoresForSocialTonesBySentence = [String]()
//var languageTonesBySentence = [String]()
//var scoresForLanguageTonesBySentence = [String]()


//Parsing tone in the whole document
var UserEmotionTonesInDocument = ["Anger", "Disgust", "Fear", "Joy", "Sadness"]
var UserScoresForEmotionTonesInDocument = [Int]()

var UserLanguageTonesInDocument = ["Analytical", "Confident", "Tentative"]
var UserScoresForLanguageTonesInDocument = [Int]()

var UserSocialTonesInDocument = ["Openness", "Conscientiousness", "Extraversion", "Agreeableness", "Emotional Range"]
var UserScoresForSocialTonesInDocument = [Int]()

////
var emotionTonesInDocument = ["Anger", "Disgust", "Fear", "Joy", "Sadness"]
var scoresForEmotionTonesInDocument = [Int]()

var languageTonesInDocument = ["Analytical", "Confident", "Tentative"]
var scoresForLanguageTonesInDocument = [Int]()

var socialTonesInDocument = ["Openness", "Conscientiousness", "Extraversion", "Agreeableness", "Emotional Range"]
var scoresForSocialTonesInDocument = [Int]()

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


class InterviewViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var loadingNextQuestion: UIActivityIndicatorView!
    @IBOutlet weak var nextQuestion: UIButton!
    var timer: Timer!
    var arrayOfQuestions = [String]()
    var questionToAsk = 0
    
    //WATSON properties
    var documentToneJSON: String = ""
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //SPEECH RECOGNITION properties
    var speechRecognizedAlready: Bool = false
    
    var recognizedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {  //5
            case .authorized:
                speechRecognitionEnabled = true
                
            case .denied:
                speechRecognitionEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                speechRecognitionEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                speechRecognitionEnabled = false
                print("Speech recognition not yet authorized")
            }
        }
        
        print("recording")
        
        questionLabel.text = "\(arrayOfQuestions[questionToAsk])"
        //speak(string: "\(arrayOfQuestions[questionToAsk])")
        startRecording();
        
        // Do any additional setup after loading the view.
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        //change this
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil && !self.speechRecognizedAlready{
                
                //different sentence structures
                
                self.recognizedText = (result?.bestTranscription.formattedString)!
                
                print("HERE: \(self.recognizedText)")
                isFinal = (result?.isFinal)!
                return
            }
            
            if ((error != nil || isFinal) && !self.speechRecognizedAlready) {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.speechRecognizedAlready = true
                self.watsonFunction(Answer: self.recognizedText, isUser: true)
                return
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func watsonFunction(Answer: String, isUser: Bool) {
        
        let username = "376ed9bb-a62b-4720-9e84-d0f75bfb5b87"
        let password = "F7Fp3zI5Cb0Q"
        let version = "2017-01-21" // use today's date for the most recent version
        let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)
        
        let text = Answer
        let failure = { (error: Error) in print(error) }
        
        var countSentencesInDocument = 0
        
        toneAnalyzer.getTone(ofText: text, failure: failure) { tones in
            
            self.documentToneJSON = (String(describing: tones))
            
            var counter = 0
            
            //adding scores to arrays
            
            if( !isUser){
                for index in 0...self.documentToneJSON.characters.count-1{
                    
                    if(self.documentToneJSON[index..<index+5] == "score"){
                        counter += 1
                        
                        if(counter >= 1 && counter <= 5){
                            scoresForEmotionTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                        else if(counter > 5 && counter <= 8){
                            
                            scoresForLanguageTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                        else if(counter > 8 && counter <= 13){
                            scoresForSocialTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                    }
                }
                print(String(describing: tones));
            }
            else{
                for index in 0...self.documentToneJSON.characters.count-1{
                    
                    if(self.documentToneJSON[index..<index+5] == "score"){
                        counter += 1
                        
                        if(counter >= 1 && counter <= 5){
                            UserScoresForEmotionTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                        else if(counter > 5 && counter <= 8){
                            
                            UserScoresForLanguageTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                        else if(counter > 8 && counter <= 13){
                            UserScoresForSocialTonesInDocument.append(Int(self.documentToneJSON[index+7..<index+13])!)
                        }
                    }
                }
                
            }
        }
    }

    @IBAction func nextQuestion(_ sender: Any) {
        
        questionToAsk += 1
        
        if(questionToAsk == 3){
            
            self.performSegue(withIdentifier: "toResult", sender: Any?.self)
            
        }
        
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.nextQuestion.alpha = 0
            self.questionLabel.alpha = 0
        })
        nextQuestion.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(pauseBetweenQuestions), userInfo: nil, repeats: false)
        
        loadingNextQuestion.startAnimating()
    
        
    }
    
    /*
    func speak(string: String)
    {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    */
    
    func pauseBetweenQuestions(){
        nextQuestion.isEnabled = true
        
        if(questionToAsk != 3){
        questionLabel.text = "\(arrayOfQuestions[questionToAsk])"
        }
        else{
            questionLabel.text = "Finish"
        }
        
        UIView.animate(withDuration: 1, delay: 0, animations: {
            self.nextQuestion.alpha = 1
            self.questionLabel.alpha = 1
        })
        
        self.speechRecognizedAlready = false
        //speak(string: arrayOfQuestions[questionToAsk])
        startRecording()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
