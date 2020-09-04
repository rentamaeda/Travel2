//
//  PostViewController.swift
//  Travel2
//
//  Created by user on 2020/08/29.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import DKImagePickerController

class PostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    var selectedImg :  [UIImage] = []
    let Image = "iconfinder_Summer_Holidays_travel_holidays_vacation_suitcase_luggage_6622921"
    var assets: [DKAsset] = []
    var localImages: [UIImage] = []

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBAction func handlePostButton(_ sender: Any) {
//        // 画像をJPEG形式に変換する
//              let imageData = image.jpegData(compressionQuality: 0.75)
//              // 画像と投稿データの保存場所を定義する
//              let postRef = Firestore.firestore().collection(Const.PostPath).document()
//              let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
//              // HUDで投稿処理中の表示を開始
//              SVProgressHUD.show()
//              // Storageに画像をアップロードする
//              let metadata = StorageMetadata()
//              metadata.contentType = "image/jpeg"
//              imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
//                  if error != nil {
//                      // 画像のアップロード失敗
//                      print(error!)
//                      SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
//                      // 投稿処理をキャンセルし、先頭画面に戻る
//                      UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
//                      return
//                  }
//                  // FireStoreに投稿データを保存する
//                  let name = Auth.auth().currentUser?.displayName
//                  let postDic = [
//                      "name": name!,
//                      "caption": self.textField.text!,
//                      "date": FieldValue.serverTimestamp(),
//                      "postdate": self.dateField.text!,
//                      ] as [String : Any]
//                  postRef.setData(postDic)
//                  // HUDで投稿完了を表示する
//                  SVProgressHUD.showSuccess(withStatus: "投稿しました")
//                  // 投稿処理が完了したので先頭画面に戻る
//                 UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
//              }
    }

    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
              self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
            //  imageView.image = image
        // Do any additional setup after loading the view.
        // 受け取った画像をcollectionViewに設定する
        
        CollectionView.delegate = self
        CollectionView.dataSource = self

        
    }
    
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("nember表示されてる")
        return assets.count
                }
              func numberOfSections(in collectionView: UICollectionView) -> Int {
                    return 1
                }
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            let asset = assets[indexPath.item]
                          asset.fetchFullScreenImage(completeBlock: { (image:UIImage?, info) in
                      //assetsにライブラリの画像をいれる
                                      if let image = image {

                                        cell.imageView.image = image
                                       
                                        
                            }
                })
          
                        
          
             cell.imgeWidth.constant = UIScreen.main.bounds.width/3-30
             cell.imageHeight.constant = 150
                     return cell
                
           }
   

}
