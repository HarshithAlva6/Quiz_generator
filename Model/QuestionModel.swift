//
//  QuestionCardData.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/3/25.
//

import SwiftData
import Foundation

@Model
final class QuestionModel: Identifiable {
    var id: UUID
    var question: String
    var answer: String
    var options: [String] = []
    var timestamp = Date()

    init(id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}
let quizQuestions: [QuestionModel] = [
    QuestionModel(
        question: "Which keyword is used to declare a constant in Swift?",
        answer: "let"
    ),
    QuestionModel(
        question: "What is the primary difference between a struct and a class?",
        answer: "Structs are value types, classes are reference types"
    ),
    QuestionModel(
        question: "What is the default initial state of an Optional variable?",
        answer: "nil"
    ),
    QuestionModel(
        question: "Which property wrapper is used to automatically update a SwiftUI View when a class property changes?",
        answer: "@Published"
    ),
    QuestionModel(
        question: "What is the process of extracting the value from an Optional called?",
        answer: "Unwrapping"
    ),
    QuestionModel(
        question: "What is the main purpose of the 'guard' statement?",
        answer: "Early exit from a scope (function, loop, etc.)"
    ),
    QuestionModel(
        question: "In SwiftUI, what is the default arrangement container for horizontal layout?",
        answer: "HStack"
    ),
    QuestionModel(
        question: "What does the 'self' keyword refer to in an instance method?",
        answer: "The current instance of the type"
    ),
    QuestionModel(
        question: "What is the preferred way to iterate over a range of numbers in Swift?",
        answer: "For-in loop"
    ),
    QuestionModel(
        question: "Which protocol must a custom type conform to in order to be used as an element in a SwiftUI ForEach loop?",
        answer: "Identifiable"
    )
]

