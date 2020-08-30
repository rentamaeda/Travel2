//
//  ViewController.swift
//  Travel2
//
//  Created by user on 2020/08/29.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController  // 忘れないように
class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    
    @IBAction func button(_ sender: Any) {
        let pickerController = DKImagePickerController()
        // 選択可能な枚数を20にする
        pickerController.maxSelectableCount = 20
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(completeBlock: { (image, info) in
                    // ここで取り出せる
                    self.imageView.image = image
                })
                
            }
            
            
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

