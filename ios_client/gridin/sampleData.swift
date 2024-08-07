//
//  sampleData.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import Foundation

let AI = "AI"

// Updated sample data with conversations about driving behaviors
let sampleEvents = [
    Incident(time: "10:00 AM, Apr 22, 2024", location: "123 Main St, Anytown", targetName: "John Doe", summary: "Discussion about safe following distance.", description: "John Doe engaged in a conversation with an AI driving assistant about maintaining a safe following distance while driving. The AI provided advice on the '3-second rule' and its importance in preventing rear-end collisions.", warningFlag: false, latitude: 37.7749, longitude: -122.4194, videoLink: "eqoiX8lbVh4", conversations: [
        Conversation(role: AI, message: "Hello John, I've noticed you often drive quite close to the vehicle in front. Let's discuss safe following distances.", warningType: .None, level: .Low),
        Conversation(role: "John Doe", message: "I didn't realize I was doing that. What's considered safe?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "A good rule of thumb is the '3-second rule'. Allow at least 3 seconds between you and the car ahead.", warningType: .None, level: .Low),
        Conversation(role: "John Doe", message: "How do I measure that while driving?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "When the car ahead passes a fixed point, count 'one-thousand-one, one-thousand-two, one-thousand-three'. You shouldn't reach that point before finishing.", warningType: .None, level: .Low),
        Conversation(role: "John Doe", message: "That makes sense. I'll try to practice this.", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Great! This will significantly improve your safety on the road.", warningType: .None, level: .Low)
    ]),
    Incident(time: "02:00 PM, Apr 21, 2024", location: "456 Elm St, Anytown", targetName: "Jane Smith", summary: "Tips on eco-friendly acceleration.", description: "Jane Smith received advice from an AI driving assistant about eco-friendly acceleration techniques. The conversation covered gradual acceleration and its benefits for fuel efficiency and reduced emissions.", warningFlag: false, latitude: 37.8715, longitude: -122.2730, videoLink: "eqoiX8lbVh4", conversations: [
        Conversation(role: AI, message: "Hi Jane, I've observed your driving pattern. Would you like some tips on eco-friendly acceleration?", warningType: .None, level: .Low),
        Conversation(role: "Jane Smith", message: "Sure, I'm always looking to improve my driving efficiency.", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Great! Try to accelerate gradually. Aim to take about 5 seconds to accelerate to 20 mph from a stop.", warningType: .None, level: .Low),
        Conversation(role: "Jane Smith", message: "Won't that slow down traffic behind me?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Not significantly. It's a balance. This technique can improve fuel efficiency by up to 40% without causing delays.", warningType: .None, level: .Low),
        Conversation(role: "Jane Smith", message: "That's impressive! I'll give it a try.", warningType: .None, level: .Low)
    ]),
    Incident(time: "09:15 AM, Apr 20, 2024", location: "789 Pine St, Anytown", targetName: "Alice Johnson", summary: "Discussing proper use of turn signals.", description: "Alice Johnson engaged in a conversation with an AI driving assistant about the importance of using turn signals correctly. The discussion emphasized how proper signaling improves road safety and communication between drivers.", warningFlag: false, latitude: 37.6879, longitude: -122.4702, videoLink: "eqoiX8lbVh4", conversations: [
        Conversation(role: AI, message: "Hello Alice, I've noticed you sometimes forget to use your turn signals. Shall we discuss their importance?", warningType: .None, level: .Low),
        Conversation(role: "Alice Johnson", message: "Oh, I didn't realize I was forgetting. Yes, let's talk about it.", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Using turn signals is crucial for communicating your intentions to other drivers. It significantly reduces accident risks.", warningType: .None, level: .Low),
        Conversation(role: "Alice Johnson", message: "I see. When exactly should I use them?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Use them before turning, changing lanes, or even pulling over. Aim to signal at least 100 feet before your maneuver.", warningType: .None, level: .Low),
        Conversation(role: "Alice Johnson", message: "That's helpful. I'll make a conscious effort to use them more consistently.", warningType: .None, level: .Low)
    ]),
    Incident(time: "05:30 PM, Apr 19, 2024", location: "321 Cedar St, Anytown", targetName: "Bob White", summary: "Advice on reducing harsh braking.", description: "Bob White received guidance from an AI driving assistant on reducing instances of harsh braking. The conversation covered techniques for smoother deceleration and its benefits for safety, fuel efficiency, and vehicle maintenance.", warningFlag: false, latitude: 37.8044, longitude: -122.2712, videoLink: "eqoiX8lbVh4", conversations: [
        Conversation(role: AI, message: "Hi Bob, I've noticed frequent harsh braking in your driving. Would you like some tips to improve this?", warningType: .None, level: .Low),
        Conversation(role: "Bob White", message: "Yes, please. I didn't realize I was braking harshly.", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Try to anticipate stops by looking further ahead. Begin slowing down earlier by easing off the accelerator.", warningType: .None, level: .Low),
        Conversation(role: "Bob White", message: "That makes sense. Any other tips?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Maintain a safe following distance. This gives you more time to react and brake smoothly.", warningType: .None, level: .Low),
        Conversation(role: "Bob White", message: "I see how that could help. I'll work on implementing these tips.", warningType: .None, level: .Low)
    ]),
    Incident(time: "11:00 AM, Apr 18, 2024", location: "654 Oak St, Anytown", targetName: "Clara Blue", summary: "Discussion on optimal tire pressure.", description: "Clara Blue engaged in a conversation with an AI driving assistant about maintaining optimal tire pressure. The discussion covered the importance of proper inflation for safety, fuel efficiency, and tire longevity.", warningFlag: false, latitude: 37.7749, longitude: -122.4194, videoLink: "eqoiX8lbVh4", conversations: [
        Conversation(role: AI, message: "Hello Clara, when was the last time you checked your tire pressure?", warningType: .None, level: .Low),
        Conversation(role: "Clara Blue", message: "Honestly, I can't remember. Is it that important?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Yes, it's crucial. Proper tire pressure improves safety, fuel efficiency, and tire lifespan.", warningType: .None, level: .Low),
        Conversation(role: "Clara Blue", message: "I had no idea. How often should I check it?", warningType: .None, level: .Low),
        Conversation(role: AI, message: "Aim to check your tire pressure at least once a month and before long trips. The correct pressure is usually listed on a sticker inside the driver's door frame.", warningType: .None, level: .Low),
        Conversation(role: "Clara Blue", message: "Thank you! I'll make sure to check them this weekend.", warningType: .None, level: .Low)
    ])
]
