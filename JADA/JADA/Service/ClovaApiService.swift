//
//  ClovaApiService.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/13.
//

import Foundation

final class ClovaApiService {
    enum ApiError: Error {
        case apiError
        case dataReciveError
        case jsonDecodeError
        case httpRequestError
    }
    
    func fetchData(text: String, completion: @escaping (Result<SentimentModel, Error>) -> Void) {
        guard let request = requestApi(content: text) else { return }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("api Error :\n\(error.localizedDescription)")
                completion(.failure(ApiError.apiError))
                return
            }
            guard let data = data else {
                print("Error: 데이터를 받지 못함")
                completion(.failure(ApiError.dataReciveError))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP 요청 실패")
                completion(.failure(ApiError.httpRequestError))
                return
            }
            guard let result = try? JSONDecoder().decode(SentimentModel.self, from: data) else {
                print("Error: Json Decode 실패")
                completion(.failure(ApiError.jsonDecodeError))
                return
            }
            completion(.success(result))
        }.resume()
    }
    
    private func requestApi(content: String) -> URLRequest? {
        guard let url = URL(string: "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze") else { return nil }
        guard let body = try? JSONSerialization.data(withJSONObject: ["content" : content]) else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(Bundle.main.clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        urlRequest.setValue(Bundle.main.clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
