//
//  Constant.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

import UIKit

// MARK: - Global Var
let spinnerTable = UIActivityIndicatorView(style: .medium)
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height


// MARK: - Enum
enum FetchError : Error{
    case failed
}

// MARK: - Extenstion
extension UIViewController{
    // DOWNLOAD IMAGE ============
//    func downloadImage(_ link: String, linkwithCompletion completion: @escaping (UIImage?)->()) {
//        guard let url = try? URL(string: link) else { // SWIFT 5
//            completion(nil)
//            return
//        }
//        let imageURL = url
//        
//        let task = URLSession.shared.dataTask(with: imageURL) { (data, responce, _) in
//            if let data = data, let image = UIImage(data: data) {
//                completion(image)
//            }else{
//                completion(UIImage.init(named: "image"))
//            }
//        }
//        task.resume()
//    }
}

// MARK: - Struct
struct APIList{
    static let urlGetUserGlobal = "https://api.github.com/search/users?"
    //https://api.github.com/search/users?q=pikachu&per_page=100&page=11
//    static let urlListUserByUsername = urlGetUserGlobal + "
}

// SIMPLE ALERT
struct Show {
    static func SimpleAlert(root:UIViewController, title:String,message:String,buttonText:String) {
        Async.Do {
            let alert = UIAlertController(title: title, message:message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: buttonText, style: .default) { _ in })
            let rootVC = root
            rootVC.present(alert, animated: true){}
        }
    }
}

struct Async {
    static func Do (handler:@escaping () -> Void) {
        DispatchQueue.main.async {
            DispatchQueue.main.async(execute: {
                handler();
            });
        }
    }
}

