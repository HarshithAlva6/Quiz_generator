//
//  ContentView.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var qc: [QuestionModel]

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purple)
                        .frame(height: 200)
                        .padding(25)
                    VStack {
                        Text("Are you curious to identify your movie recommendations?")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 40)
                    }
                }
                HStack {
                    NavigationLink(destination: QuizView()) {
                        Image(systemName: "pencil.line")
                        Text("Quiz Attempt")
                    }
                    .buttonStyle(.glassProminent)
                    .shadow(radius: 10)
                    NavigationLink(destination: QuizEditorView()) {
                        Image(systemName: "pencil.circle")
                        Text("Question Editor")
                    }
                    .buttonStyle(.glass)
                    .shadow(radius: 20)
                }
            }
 
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: QuestionModel.self, inMemory: true)
}
