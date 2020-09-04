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
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var localImages: [UIImage] = []

    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CollectionView.delegate = self
       self.CollectionView.dataSource = self

    }
    @IBAction func button(_ sender: Any) {
        let pickerController = DKImagePickerController()
        // 選択可能な枚数を20にする
        pickerController.maxSelectableCount = 20
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(completeBlock: { (image, info) in
                    // ここで取り出せる
                    //assetsにライブラリの画像をいれる
                                      if let image = image {
                                       self.localImages.append(image)
                                       self.CollectionView.reloadData()
                                       }
                })
                
            }
            
            
        }
        
        self.present(pickerController, animated: true) {}
    }
    @IBAction func Button(_ sender: Any) {
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
                                                                self.present(postViewController, animated: true, completion: nil)
                      
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return localImages.count  // ←修正する

        }
                func numberOfSections(in collectionView: UICollectionView) -> Int {
                      return 1
                  }

                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                      //①
                      let cell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TestCollectionViewCell
                      //②
                    // Cellに値を設定する.  --- ここから ---
    //                let task = taskArray[indexPath.row]
    //                cell.textLabel?.text = task.title

                      //③
                  //  cell.imageView.image = localImages[indexPath.row]
                    cell.backgroundColor = .red
                    cell.imageView.image = localImages[indexPath.row]


                    //⑤
                     return cell

                  }
    


}

