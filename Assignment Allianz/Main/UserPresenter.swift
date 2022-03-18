//
//  UserPresenter.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

import UIKit

protocol ProtPresenter {
    var router : ProtRouter? {get set}
    var interactor : ProtInteractor? {get set}
    var view : ProtView? {get set}
    
    func interactorDidFetchUsers(with result: Result<User, Error>)
    func interactorPageExceed(with result: Result<Response, Error>)
    func getUserWithQuery(query : String)
    func alertWithAction(vc:UIViewController, errorMsg : String, title : String)
}

class UserPresenter : ProtPresenter{
    var interactor: ProtInteractor? {
        didSet{
//            interactor?.getUser(query: "q=''", isExceededPage : false)
        }
    }
    var view: ProtView?
    var router: ProtRouter?
    
    // Download Image
    static func downloadImage(_ link: String, linkwithCompletion completion: @escaping (UIImage?)->()) {
        guard let url = try? URL(string: link) else { // SWIFT 5
            completion(nil)
            return
        }
        let imageURL = url
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, responce, _) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }else{
                completion(UIImage.init(named: "image"))
            }
        }
        task.resume()
    }
    
    // SHOW ALERT ===========
    func alertWithAction(vc:UIViewController, errorMsg : String, title : String){
        let msg = title
        let ac = UIAlertController(title: msg, message: errorMsg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.view?.loadMoreData()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            spinnerTable.stopAnimating()
            NSLog("Cancel Pressed")
        }
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        vc.present(ac, animated:  true)
    }
    
    func getUserWithQuery(query : String){
        print("query : \(query)")
        interactor?.getUser(query: query)
    }
    
    func interactorDidFetchUsers(with result: Result<User, Error>) {
        switch result {
        case .success(let user):
            view?.updateData(with: user)
        case .failure:
            view?.updateError(error: "Empty / Error fetch data, please try again!")
        }
    }
    
    func interactorPageExceed(with result: Result<Response, Error>) {
        switch result {
        
        case .success(let user):
            view?.updateError(error: user.message)
        case .failure:
            view?.updateError(error: "Empty / Error fetch data, please try again!")
        }
    }
}
