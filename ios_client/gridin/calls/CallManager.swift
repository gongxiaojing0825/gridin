//
//  CallManager.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-26.
//

import Combine



class CallManager: ObservableObject {
    
    
    @Published private(set) var state: CallState = .idle
    
    private var speechToTextManager: SpeechToTextManager
    private var chatManager: ChatManager
    private var textToSpeechManager: TextToSpeechManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(speechToTextManager: SpeechToTextManager = SpeechToTextManager(), chatManager: ChatManager = ChatManager(), textToSpeechManager: TextToSpeechManager = TextToSpeechManager()) {
        self.speechToTextManager = speechToTextManager
        self.chatManager = chatManager
        self.textToSpeechManager = textToSpeechManager
        
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        speechToTextManager.$state
            .removeDuplicates() // Ensures that the state has changed before processing
            .scan((previous: S2TState.idle, current: S2TState.idle)) { previousStates, newState in
                // Update the tuple with the latest state
                return (previous: previousStates.current, current: newState)
            }
            .filter { previous, current in
                // Trigger only when the state changes from .transcribing to .idle
                previous == .transcribing && current == .idle
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                print("speechToTextManager state change: \(self.speechToTextManager.state)")
                // Process the transcription when the state changes to .idle
                self.processTranscription(self.speechToTextManager.transcription)
            }
            .store(in: &cancellables)
        
        let removedDuplicates = chatManager.$state.removeDuplicates()
        let scannedStates = removedDuplicates.scan((previous: ChatState.idle, current: ChatState.idle)) { previousStates, newState in
            return (previous: previousStates.current, current: newState)
        }
        let filteredStates = scannedStates.filter { previous, current in
            // Trigger only when the state changes from .waiting to .idle
            return previous == ChatState.waiting && current == ChatState.idle
        }
        let subscription = filteredStates.sink { [weak self] previous, current in
            // Assuming the answer is somehow determined here; adjust as per actual implementation

            self?.speakAnswer(self?.chatManager.answer)
        }
        subscription.store(in: &cancellables)
        
        textToSpeechManager.$state
            .removeDuplicates()
            .scan((previous: T2SState.idle, current: T2SState.idle)) { previousStates, newState in
                return (previous: previousStates.current, current: newState)
            }
            .sink { [weak self] state in
                self?.handleSpeechState(self?.textToSpeechManager.state ?? .idle)
            }
            .store(in: &cancellables)
    }
    
    func start() {
        
        switch state {
            case .idle, .error(_):
                state = .listening
                print("start recording...")
                speechToTextManager.start()
            default:
                return
        }
    }
    
    func stop() {
        guard state == .listening else { return }
        print("stop recording...")
        speechToTextManager.stop()
    }
    
    private func processTranscription(_ transcription: String?) {
        guard let transcription = transcription, !transcription.isEmpty else { return }
        print("transcription: \(transcription)")
        state = .processing
        chatManager.prompt(transcription)
    }
    
    private func speakAnswer(_ answer: String?) {
        guard let answer = answer, !answer.isEmpty else {
            state = .idle
            return
        }
        state = .speaking
        textToSpeechManager.synthesizeSpeech(from: answer)
    }
    
    private func handleSpeechState(_ t2sState: T2SState) {
        switch t2sState {
        case .idle:
            if state == .speaking {
                state = .idle
            }
        case .error(let message):
            state = .error(message)
        default:
            break
        }
    }
    
    func handleErrors() {
        if let error = speechToTextManager.state.errorValue() {
            state = .error(error)
        } else if let error = chatManager.state.errorValue() {
            state = .error(error)
        } else if let error = textToSpeechManager.state.errorValue() {
            state = .error(error)
        }
    }
    
    func getTranscription() -> String {
        return speechToTextManager.transcription ?? ""
    }
    
    func getAnswer() -> String {
        return chatManager.answer  ?? ""
    }
}


