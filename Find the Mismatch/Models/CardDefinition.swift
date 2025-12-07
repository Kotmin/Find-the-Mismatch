//
//  CardDefinition.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import Foundation

struct CardDefinition {
    let id: String
    let title: String
    let asset: CardAsset
    let category: Category
}

struct CardCatalog {
    static let shared = CardCatalog()

    let all: [CardDefinition]

    private init() {
        all = [

               // MARK: Animals
               CardDefinition(id: "dog", title: "Dog", asset: .emoji("🐶"), category: .animals),
               CardDefinition(id: "cat", title: "Cat", asset: .emoji("🐱"), category: .animals),
               CardDefinition(id: "mouse", title: "Mouse", asset: .emoji("🐭"), category: .animals),
               CardDefinition(id: "lion", title: "Lion", asset: .emoji("🦁"), category: .animals),
               CardDefinition(id: "fox", title: "Fox", asset: .emoji("🦊"), category: .animals),

               // MARK: Food
               CardDefinition(id: "pizza", title: "Pizza", asset: .emoji("🍕"), category: .food),
               CardDefinition(id: "apple", title: "Apple", asset: .emoji("🍎"), category: .food),
               CardDefinition(id: "burger", title: "Burger", asset: .emoji("🍔"), category: .food),
               CardDefinition(id: "banana", title: "Banana", asset: .emoji("🍌"), category: .food),
               CardDefinition(id: "sushi", title: "Sushi", asset: .emoji("🍣"), category: .food),

               // MARK: Objects
               CardDefinition(id: "chair", title: "Chair", asset: .emoji("🪑"), category: .objects),
               CardDefinition(id: "laptop", title: "Laptop", asset: .emoji("💻"), category: .objects),
               CardDefinition(id: "key", title: "Key", asset: .emoji("🔑"), category: .objects),
               CardDefinition(id: "lightbulb", title: "Lightbulb", asset: .emoji("💡"), category: .objects),
               CardDefinition(id: "toolbox", title: "Toolbox", asset: .emoji("🧰"), category: .objects),

               // MARK: Weather
               CardDefinition(id: "sun", title: "Sun", asset: .emoji("☀️"), category: .weather),
               CardDefinition(id: "cloud", title: "Cloud", asset: .emoji("☁️"), category: .weather),
               CardDefinition(id: "rainbow", title: "Rainbow", asset: .emoji("🌈"), category: .weather),
               CardDefinition(id: "snowflake", title: "Snowflake", asset: .emoji("❄️"), category: .weather),
               CardDefinition(id: "storm", title: "Storm", asset: .emoji("🌩️"), category: .weather),

               // MARK: Pirates
               CardDefinition(id: "pirate", title: "Pirate", asset: .emoji("🏴‍☠️"), category: .pirates),
               CardDefinition(id: "treasure", title: "Treasure", asset: .emoji("💰"), category: .pirates),
               CardDefinition(id: "map", title: "Treasure Map", asset: .emoji("🗺️"), category: .pirates),
               CardDefinition(id: "hook", title: "Hook", asset: .emoji("🪝"), category: .pirates),
               CardDefinition(id: "pirate_flag", title: "Pirate Flag", asset: .emoji("🏴‍☠️"), category: .pirates),
               CardDefinition(id: "captain", title: "Captain", asset: .emoji("🧑‍✈️"), category: .pirates),

               // MARK: Science
               CardDefinition(id: "microscope", title: "Microscope", asset: .emoji("🔬"), category: .science),
               CardDefinition(id: "telescope", title: "Telescope", asset: .emoji("🔭"), category: .science),
               CardDefinition(id: "dna", title: "DNA", asset: .emoji("🧬"), category: .science),
               CardDefinition(id: "atom", title: "Atom", asset: .emoji("⚛️"), category: .science),

               // MARK: Space
               CardDefinition(id: "rocket", title: "Rocket", asset: .emoji("🚀"), category: .space),
               CardDefinition(id: "planet", title: "Planet", asset: .emoji("🪐"), category: .space),
               CardDefinition(id: "astronaut", title: "Astronaut", asset: .emoji("🧑‍🚀"), category: .space),
               CardDefinition(id: "star", title: "Star", asset: .emoji("⭐️"), category: .space),

               // MARK: Emotions
               CardDefinition(id: "happy", title: "Happy", asset: .emoji("😊"), category: .emotions),
               CardDefinition(id: "sad", title: "Sad", asset: .emoji("😢"), category: .emotions),
               CardDefinition(id: "angry", title: "Angry", asset: .emoji("😡"), category: .emotions),
               CardDefinition(id: "love", title: "Love", asset: .emoji("😍"), category: .emotions),

               // MARK: Mafia
               CardDefinition(id: "gangster", title: "Gangster", asset: .emoji("🕴️"), category: .mafia),
               CardDefinition(id: "gun", title: "Gun", asset: .emoji("🔫"), category: .mafia),
               CardDefinition(id: "moneybag", title: "Money Bag", asset: .emoji("💵"), category: .mafia),
               CardDefinition(id: "cigar", title: "Cigar", asset: .emoji("🚬"), category: .mafia),

               // MARK: Vehicles
               CardDefinition(id: "car", title: "Car", asset: .emoji("🚗"), category: .vehicles),
               CardDefinition(id: "bus", title: "Bus", asset: .emoji("🚌"), category: .vehicles),
               CardDefinition(id: "bicycle", title: "Bicycle", asset: .emoji("🚲"), category: .vehicles),
               CardDefinition(id: "motorcycle", title: "Motorcycle", asset: .emoji("🏍️"), category: .vehicles),

               // MARK: Music
               CardDefinition(id: "guitar", title: "Guitar", asset: .emoji("🎸"), category: .music),
               CardDefinition(id: "piano", title: "Piano", asset: .emoji("🎹"), category: .music),
               CardDefinition(id: "microphone", title: "Microphone", asset: .emoji("🎤"), category: .music),

               // MARK: Sports
               CardDefinition(id: "football", title: "Football", asset: .emoji("⚽️"), category: .sports),
               CardDefinition(id: "basketball", title: "Basketball", asset: .emoji("🏀"), category: .sports),
               CardDefinition(id: "tennis", title: "Tennis", asset: .emoji("🎾"), category: .sports),

               // MARK: Fantasy
               CardDefinition(id: "dragon", title: "Dragon", asset: .emoji("🐉"), category: .fantasy),
               CardDefinition(id: "wizard", title: "Wizard", asset: .emoji("🧙‍♂️"), category: .fantasy),
               CardDefinition(id: "sword", title: "Sword", asset: .emoji("🗡️"), category: .fantasy),

               // MARK: Professions
               CardDefinition(id: "doctor", title: "Doctor", asset: .emoji("👩‍⚕️"), category: .professions),
               CardDefinition(id: "police", title: "Police", asset: .emoji("👮‍♂️"), category: .professions),
               CardDefinition(id: "firefighter", title: "Firefighter", asset: .emoji("👨‍🚒"), category: .professions)
               ]
           }

    func definitions(for categories: [Category]) -> [CardDefinition] {
        all.filter { categories.contains($0.category) }
    }

    func definitions(for category: Category) -> [CardDefinition] {
        all.filter { $0.category == category }
    }
}
