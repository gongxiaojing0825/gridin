//
//  TextToSpeechManager.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-26.
//

import Foundation

import AVFoundation


class TextToSpeechManager: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    @Published var state: T2SState = .idle
    private var speechSynthesizer = AVSpeechSynthesizer()
    private var lastSpokenText: String?

    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    func synthesizeSpeech(from text: String) {
        lastSpokenText = text
        speak(text: text)
    }

    private func speak(text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        state = .synthesizing
        speechSynthesizer.speak(utterance)
    }

    func pauseSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
            state = .paused
        }
    }

    func resumeSpeech() {
        if state == .paused {
            speechSynthesizer.continueSpeaking()
        }
    }

    func stopSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            state = .idle
        }
    }

    func restartSpeech() {
        if let text = lastSpokenText {
            speak(text: text)
        }
    }

    // AVSpeechSynthesizerDelegate methods
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        state = .playing
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state = .idle
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        state = .paused
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        state = .playing
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didReceiveError error: Error, for utterance: AVSpeechUtterance) {
        state = .error(error.localizedDescription)
    }
}
