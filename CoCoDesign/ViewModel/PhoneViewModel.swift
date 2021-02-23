//
//  PhoneViewModel.swift
//  CoCoDesign
//
//  Created by apple on 2/19/21.
//

import Foundation

class PhoneViewModel: ObservableObject {
    @Published var token: Token = Token()
    private let service = Service()
    
    func postRequest(phone: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let parameters: [String: Any] = ["phone": "0123123123"]

        //create the url with NSURL
        let url = URL(string: "https://f55eb7f2a760.ngrok.io/api/v1/phone/verify")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }

    func login(_ phone: Phone) {
        service.request(input: RequestPhoneInput(phone: phone)) { results in
            switch results {
            case let .success(token):
                self.token = token
            case .failure:
                break
            }
        }
    }
}
