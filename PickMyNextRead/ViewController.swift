//
//  ViewController.swift
//  PickMyNextRead
//
//  Created by Claudia on 4/1/25.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 200, height: 350))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

       
    }
}

