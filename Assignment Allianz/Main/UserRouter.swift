//
//  UserRouter.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

import UIKit

typealias StartPoint = UIViewController & ProtView

protocol ProtRouter {
    var startingApp : StartPoint? {get set}
    
    static func start() -> ProtRouter
}

class UserRouter : ProtRouter{
    var startingApp : StartPoint?
    
    static func start() -> ProtRouter {
        let router = UserRouter()
        
        var view : ProtView = UserView()
        var presenter : ProtPresenter = UserPresenter()
        var interactor : ProtInteractor = UserInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.startingApp = view as? StartPoint
        
        return router
    }
    
}
