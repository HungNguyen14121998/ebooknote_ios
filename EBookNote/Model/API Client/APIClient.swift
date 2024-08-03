//
//  APIClient.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/26/24.
//

import Foundation
import UIKit

class APIClient {
    
    struct Auth {
        static var accessToken = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let base = "https://ebooknote-be-1.onrender.com/api/v1/"
        
        case login
        case register
        case logout
        case getBooks
        case createBook
        case updateBook
        case deleteBook
        case getHistory
        case createHistory
        case updateHistory
        case deleteHistory
        case uploadImage
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "users/login"
            case .register:
                return Endpoints.base + "users/register"
            case .logout:
                return Endpoints.base + "users/logout"
            case .getBooks, .createBook, .updateBook, .deleteBook:
                return Endpoints.base + "book"
            case .getHistory, .createHistory, .updateHistory, .deleteHistory:
                return Endpoints.base + "history"
            case.uploadImage:
                return Endpoints.base + "book/upload"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Authentication
    class func login(username: String, password: String, completion: @escaping (LoginResponseModel?, Error?) -> Void) {
        let body = LoginRequestModel(username: username, password: password)
                                     
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    let responseObject = try decoder.decode(LoginResponseModel.self, from: data)
                    Auth.accessToken = responseObject.token
                    Auth.userId = responseObject.userId
                    print("token: \(Auth.accessToken)")
                    print("userId: \(Auth.userId)")
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else if httpResponse?.statusCode == 401 {
                    let error = NSError(domain: "Incorrect username or password!", code: 401)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else if httpResponse?.statusCode == 400 {
                    let error = NSError(domain: "Please provide username and password!", code: 400)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else { // 500
                    let error = NSError(domain: "Server response error!", code: 400)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func register(username: String, password: String, completion: @escaping (RegisterResponseModel?, Error?) -> Void) {
        let body = RegisterRequestModel(username: username, password: password)
                                     
        var request = URLRequest(url: Endpoints.register.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 201 {
                    let responseObject = try decoder.decode(RegisterResponseModel.self, from: data)
                    Auth.accessToken = responseObject.token
                    print("token: \(Auth.accessToken)")
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else if httpResponse?.statusCode == 401 {
                    let error = NSError(domain: "Username is exist!", code: 401)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else if httpResponse?.statusCode == 400 {
                    let error = NSError(domain: "Please provide username and password!", code: 400)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else { // 500
                    let error = NSError(domain: "Server response error!", code: 400)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (CommonResponse?, Error?) -> Void) {
        
    }
    
    // MARK: - Book
    class func getBooks(completion: @escaping ([BookResponseModel], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getBooks.url)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: Constant.httpHeaderAuthorization)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(BooksResponseModel.self, from: data)
                let result = responseObject.data
                DispatchQueue.main.async {
                    completion(result, error)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    class func createBook(book: BookRequestModel, completion: @escaping (CommonResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createBook.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(book)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: Constant.httpHeaderAuthorization)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    let responseObject = try decoder.decode(CommonResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else if httpResponse?.statusCode == 401 {
                    let error = NSError(domain: "Book is exist!", code: 401)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                } else { // 500
                    let error = NSError(domain: "Server response error!", code: 400)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Upload image
    class func uploadImage(bookName: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        let imageData = image.jpegData(compressionQuality: 0.8)!
        var request = URLRequest(url: Endpoints.uploadImage.url)
        request.httpMethod = "PATCH"
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Set the Content-Type to multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add image data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(bookName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                completion(false)
                return
            }
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Download image
    class func downloadImage(path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let stringURl = "https://ebooknote-be-1.onrender.com/\(path)"
        guard let url = URL(string: stringURl) else {return}
        // Create URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle error
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                // Handle invalid data
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert data to image"])
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            // Return the image
            DispatchQueue.main.async {
                completion(image, nil)
            }
        }
        
        // Start the task
        task.resume()
    }

    
    // MARK: - History
    
    class func createHistory(history: HistoryRequestModel, completion: @escaping (CommonResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createHistory.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(history)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: Constant.httpHeaderAuthorization)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CommonResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func updateHistory(history: HistoryRequestModel, completion: @escaping (CommonResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateHistory.url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(history)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: Constant.httpHeaderAuthorization)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CommonResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func deleteHistory(history: HistoryRequestModel, completion: @escaping (CommonResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.deleteHistory.url)
        request.httpMethod = "DELETE"
        request.httpBody = try! JSONEncoder().encode(history)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderAccept)
        request.addValue(Constant.applicationJson, forHTTPHeaderField: Constant.httpHeaderContentType)
        request.setValue( "Bearer \(Auth.accessToken)", forHTTPHeaderField: Constant.httpHeaderAuthorization)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CommonResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
