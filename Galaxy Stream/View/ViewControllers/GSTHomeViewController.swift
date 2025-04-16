//
//  GSTHomeViewController.swift
//  Galaxy Stream
//
//  Created by Shashi Gupta on 10/04/25.
//

import UIKit
import AgoraRtcKit

class GSTHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func broadcaster(_ sender: UIButton) {
        pushTheGoLiveController(role: .broadcaster)
    }
    
    @IBAction func Audience(_ sender: UIButton) {
        pushTheGoLiveController(role: .audience)
    }
    
    func pushTheGoLiveController(role:AgoraClientRole) {
        
        let vc = GSTGoLiveViewContoler(nibName: "GSTGoLiveViewContoler", bundle: nil)
        vc.role = role
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
