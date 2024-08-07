//
//  SpeechDelegate.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-24.
//

import Foundation
import Speech
import AVFoundation
import Combine

// Enum to manage different states of the speech-to-text process

class SpeechToTextManager: NSObject, SFSpeechRecognizerDelegate, ObservableObject {
    // Observable properties
    @Published var state: S2TState = .idle
    @Published var transcription = ""

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }

    // Function to start capturing and transcribing user voice input
    func start() {
        // Ensure we have permission to use speech recognition
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.beginSession()
                case .denied:
                    self.state = .error("User denied access to speech recognition")
                case .restricted:
                    self.state = .error("Speech recognition restricted on this device")
                case .notDetermined:
                    self.state = .error("Speech recognition not yet authorized")
                @unknown default:
                    self.state = .error("Unknown authorization status")
                }
            }
        }
    }

    // Begin the actual session of capturing audio and transcribing
    private func beginSession() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            state = .idle
            return
        }

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            guard let recognitionRequest = recognitionRequest else {
                state = .error("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
                return
            }

            recognitionRequest.shouldReportPartialResults = true

            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
                guard let self = self else { return }

                if let result = result {
                    print("get transcription result: \(result.bestTranscription.formattedString)")
                    self.transcription = result.bestTranscription.formattedString
                    self.state = .transcribing
                }

                if error != nil || result?.isFinal == true {
                    self.audioEngine.stop()
                    audioEngine.inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.state = .idle
                }
            })

            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
            state = .transcribing
        } catch {
            state = .error("Could not start audio engine: \(error.localizedDescription)")
        }
    }

    // Function to stop capturing and transcribing
    func stop() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            state = .idle
        }
    }
}
