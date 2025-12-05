//
//  QuestionCardModel.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/3/25.
//
//

import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
class QuestionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedOption: String? = nil
    @Published var isAnswered: Bool = false
    
    @Published var allQuestions: [QuestionModel]
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    
    private var modelContext: ModelContext
    
    var currentQuestion: QuestionModel? {
        guard currentQuestionIndex < allQuestions.count else { return nil }
        return allQuestions[currentQuestionIndex]
    }

    init(questions: [QuestionModel], context: ModelContext) {
        self.allQuestions = questions
        self.modelContext = context
    }
    
    func checkAnswer(selectedOption: String) {
        guard !isAnswered, let currentQ = currentQuestion else { return }
        self.selectedOption = selectedOption
        self.isAnswered = true
        
        if selectedOption == currentQ.answer {
            score += 1
        }
    }

    func goToNextQuestion() {
        guard currentQuestionIndex < allQuestions.count - 1 else {
            print("Quiz finished. Final Score: \(score) / \(allQuestions.count)")
            return
        }
        currentQuestionIndex += 1
        selectedOption = nil
        isAnswered = false
    }
    
    func generateOptions() async {
        guard let currentQ = currentQuestion else { return }
        isLoading = true
        errorMessage = nil

        let prompt = """
        Generate 3 incorrect but realistic multiple-choice distractor options for this question:
        "\(currentQ.question)"
        Return them as a simple list separated by newlines.
        """

        do {
            let response = try await callGemini(prompt: prompt)
            
            let distractors = response
                .components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            let newOptions = (distractors + [currentQ.answer]).shuffled()
            
            currentQ.options = newOptions
            allQuestions[currentQuestionIndex].options = newOptions
            
            // Save to SwiftData
            modelContext.insert(currentQ)
            try modelContext.save()
            
        } catch {
            errorMessage = "Failed to get options: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
