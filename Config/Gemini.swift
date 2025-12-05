//
//  Gemini.swift
//  Invest
//
//  Created by Harshith Harijeevan on 12/3/25.
//

//static let geminiAPIKey = "AIzaSyCzTMJ2fDWR1Yi7fMQ1wInc70axoBjv5Uc"
import Foundation

struct Config {
    static let apiKey = "AIzaSyCzTMJ2fDWR1Yi7fMQ1wInc70axoBjv5Uc"
}

func callGemini(prompt: String) async throws -> String {
    let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

    let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-latest:generateContent")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(Config.apiKey, forHTTPHeaderField: "x-goog-api-key")
    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

    let (data, _) = try await URLSession.shared.data(for: request)

    // Debug raw response
    if let raw = String(data: data, encoding: .utf8) {
        print("Gemini raw response: \(raw)")
    }

    // Parse response
    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
       let candidates = json["candidates"] as? [[String: Any]],
       let content = candidates.first?["content"] as? [String: Any],
       let parts = content["parts"] as? [[String: Any]],
       let text = parts.first?["text"] as? String {
        return text
    }

    throw NSError(domain: "GeminiError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected Gemini response"])
}
