//
//  UserInteractor.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

import Foundation

protocol ProtInteractor {
    var presenter : ProtPresenter? { get set }
    
    func getUser(query : String)
}

class UserInteractor : ProtInteractor{
    var presenter: ProtPresenter?
    
    func getUser(query : String){
        guard let url = URL(string: APIList.urlGetUserGlobal + query) else {return}
        print("url : \(url)")
        print("request activate")
//        var responseError = Response.self
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard let data = data, error == nil else {
                self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                return
            }
            
            do{
                let responseError = try JSONDecoder().decode(Response.self, from: data)
                self.presenter?.interactorPageExceed(with: .success(responseError))
            }catch{
                print("check error")
                do{
                    let response = try JSONDecoder().decode(User.self, from: data)
                    self.presenter?.interactorDidFetchUsers(with: .success(response))
                }catch{
                    print("error fetch = \(error)")
                    self.presenter?.interactorDidFetchUsers(with: .failure(error))
                }
            }
        })

        task.resume()
    }

}
