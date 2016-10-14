//
//  Splash.swift
//  Surface Swift
//
//  Created by Webchimp on 27/09/16.
//  Copyright © 2016 AppBuilders. All rights reserved.
//

import Foundation
import UIKit

class Splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splashPanel:SfPanel! = SfPanel();
            let lalaPanel:SfPanel! = SfPanel();
        
        let splashView:UIView! = UIView();
        splashView.backgroundColor = UIColor.cyanColor();
        
        let lalaView:UIView! = UIView();
        lalaView.backgroundColor = UIColor.redColor();
        
        //(splashPanel.view = splashView;
        splashPanel.setView(splashView);
        splashPanel.setSize(-100, height: -100);
        
        splashPanel.append(lalaPanel);
        lalaPanel.setView(lalaView);
        lalaPanel.setSize(-50, height: -50).setMargin(100, right: 0, bottom: 0, left: 0);
        
        self.view.addSubview(splashView);
        self.view.addSubview(lalaView);
        
        splashPanel.update();
        
    }
    
}
