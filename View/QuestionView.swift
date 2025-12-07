//
//  QuestionCardView.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/2/25.
//

import SwiftUI
import SwiftData

struct QuestionView: View {
    @StateObject private var viewModel: QuestionViewModel
    
    init(questions: [QuestionModel], context: ModelContext) {
        _viewModel = StateObject(wrappedValue: QuestionViewModel(questions: questions, context: context))
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func getColor(for option: String) -> (background: Color, stroke: Color) {
        guard let currentQ = viewModel.currentQuestion else { return (.clear, .clear) }
        
        let isCorrect = (option == currentQ.answer)
        let isSelected = (option == viewModel.selectedOption)

        guard viewModel.isAnswered else {
            return (.gray.opacity(0.15), .clear)
        }
        
        if isCorrect {
            return (.green.opacity(0.3), .green)
        } else if isSelected && !isCorrect {
            return (.red.opacity(0.3), .red)
        } else {
            return (.gray.opacity(0.15), .clear)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            if viewModel.currentQuestion != nil {
                HStack {
                    Text("Score: \(viewModel.score)")
                    Spacer()
                    Text("Question \(viewModel.currentQuestionIndex + 1) / \(viewModel.allQuestions.count)")
                }
                .font(.headline)
                .padding(.horizontal)
            }
            
            if let currentQ = viewModel.currentQuestion {
                
                Text(currentQ.question)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Generating options...")
                        Text("This may take a few seconds")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }

                
                if !currentQ.options.isEmpty {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(currentQ.options, id: \.self) { option in
                            let colors = getColor(for: option)
                            
                            Button(action: {
                                guard !viewModel.isAnswered else { return }
                                viewModel.checkAnswer(selectedOption: option)
                            }) {
                                Text(option)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primary)
                                    .padding(15)
                                    .frame(maxWidth: .infinity, minHeight: 60)
                                    .background(colors.background)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(colors.stroke, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.isAnswered)
                        }
                    }
                    .padding(.horizontal)
                }

                if viewModel.isAnswered {
                    Button("Next Question") {
                        viewModel.goToNextQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                } else if currentQ.options.isEmpty {
                    Button("Generate Options") {
                        Task {
                            await viewModel.generateOptions()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
                
            } else {
                Text("Quiz Complete! 🏆")
                    .font(.largeTitle)
                Text("Your Final Score is \(viewModel.score) out of \(viewModel.allQuestions.count).")
                    .font(.title3)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
