//
//  TestViewController.swift
//  Community
//
//  Created by Blake Anderson on 1/16/20.
//  Copyright © 2020 Blake Anderson. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let button1 = UIButton(frame: CGRect(x: 30, y: 20, width: 20, height: 20))
    let button2 = UIButton(frame: CGRect(x: 60, y: 20, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

     /*   // Do any additional setup after loading the view.
        test.center = CGPoint(x: UIScreen.main.bounds.maxX/2, y: UIScreen.main.bounds.maxY/2)
        view.addSubview(test)
        view.backgroundColor = .white
            
        button1.backgroundColor = .red
        button1.addTarget(self, action: #selector(error), for: .touchDown)
        button2.backgroundColor = .green
        button2.addTarget(self, action: #selector(good), for: .touchDown)
        view.addSubview(button1)
        view.addSubview(button2)
     */
    }
    
    @objc func error() {
       // test.close()
    }
    
    @objc func good() {
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
