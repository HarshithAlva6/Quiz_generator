//
//  QuizEditorView.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/3/25.
//
import SwiftUI
import SwiftData

struct QuizEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var saved: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange.opacity(0.2))
                        .shadow(radius: 20)

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Question")
                            .font(.headline)

                        TextField("Type your question here...", text: $question)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)

                        Text("Correct Answer")
                            .font(.headline)

                        TextField("Type the correct answer...", text: $answer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                    }
                    .padding(20)
                }
                Button(action: saveQuestion) {
                    Text("Save Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if saved {
                    Text("✅ Saved!")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
            }
            .padding()
        }
        .navigationTitle("Edit Question")
    }
    private func saveQuestion() {
        guard !question.isEmpty, !answer.isEmpty else { return }

        let newItem = QuestionModel(question: question, answer: answer)
        modelContext.insert(newItem)

        try? modelContext.save()

        saved = true
    }
}

#Preview {
    NavigationView {
        QuizEditorView()
            .modelContainer(for: QuestionModel.self)
    }
}

