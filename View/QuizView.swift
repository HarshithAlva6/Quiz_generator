//
//  QuizView.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/2/25.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    //let questions: [QuestionModel] = quizQuestions
    @Query(sort: \QuestionModel.timestamp, order: .forward)
    private var questions: [QuestionModel]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Text("Movie Recommendation")
                ZStack {
                    VStack {
                        QuestionView(questions: questions, context: modelContext)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 20)
                    )
                }
                .padding(.top, 150)
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    QuizView()
}
