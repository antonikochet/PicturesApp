//
//  AppAssembly.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 20.03.2022.
//

import UIKit

class AppAssembly {
    class func assemblyList() -> UIViewController {
        let viewController = PicturesListViewController()
        let viewModel = PicturesListViewModel()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    class func assemblyDetail(_ photo: Photo) -> UIViewController {
        let viewController = PicturesDetailViewController()
        let viewModel = PicturesDetailViewModel(photo)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
