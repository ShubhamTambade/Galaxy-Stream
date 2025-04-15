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
        
        pushTheGoLiveController()
    }
    
    @IBAction func Audience(_ sender: UIButton) {
        pushTheGoLiveController()
    }
    
    func pushTheGoLiveController() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GSTGoLiveViewContoler") as? GSTGoLiveViewContoler {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
