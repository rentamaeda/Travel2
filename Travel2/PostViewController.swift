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
    override func viewDidLoad() {
           super.viewDidLoad()
           
           CollectionView.delegate = self
           CollectionView.dataSource = self

        CollectionView.reloadData()
       }
    override func viewDidAppear(_ animated: Bool) {
    }
    @IBAction func handlePostButton(_ sender: Any) {
SVProgressHUD.show()
   //              // 画像と投稿データの保存場所を定義する
   let postRef = Firestore.firestore().collection(Const.PostPath).document()
 
   for i in 0...localImages.count - 1 {
    let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + "\(i)" + ".jpg")
     
     // Storageに画像をアップロードする
     let metadata = StorageMetadata()
     metadata.contentType = "image/jpeg"
     
       print("for分の中")
       let jpegImg = localImages[i].toJPEGData()
       imageRef.putData(jpegImg, metadata: metadata) { (metadata, error) in
           if error != nil {
               // 画像のアップロード失敗
               print(error!)
               SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
               // 投稿処理をキャンセルし、先頭画面に戻る
               UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
               return
           }
       }
   }
                  // FireStoreに投稿データを保存する
                  let name = Auth.auth().currentUser?.displayName
                  let postDic = [
                      "name": name!,
                      "caption": self.textField.text!,
                      "date": FieldValue.serverTimestamp(),
                      "postdate": self.dateField.text!,
                      ] as [String : Any]
                  postRef.setData(postDic)
                  // HUDで投稿完了を表示する
                  SVProgressHUD.showSuccess(withStatus: "投稿しました")
                  // 投稿処理が完了したので先頭画面に戻る
                 UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
              
    }

    @IBAction func handleCancelButton(_ sender: Any) {
        // 加工画面に戻る
              self.dismiss(animated: true, completion: nil)
    }
   
    //MARK:- Delegate
      //    --------------------------------------------------------------------------------
      //    collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
      //    --------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                self.localImages.append(image)

            }
        })
         //セルのサイズ
                 let cellWidthSize = UIScreen.main.bounds.width / 3
                 
                 cell.imageWidth.constant = cellWidthSize
                 cell.imageHeight.constant = cellWidthSize
                 
                 cell.imageView.contentMode = .scaleToFill
                 
                 return cell
    }
    
}

public extension UIImage {
    
    // MARK: Public Methods
    
    /// イメージ→PNGデータに変換する
    ///
    /// - Returns: 変換後のPNGデータ
    func toPNGData() -> Data {
        guard let data = self.pngData() else {
            print("イメージをPNGデータに変換できませんでした。")
            return Data()
        }
        
        return data
    }
    
    /// イメージ→JPEGデータに変換する
    ///
    /// - Returns: 変換後のJPEGデータ
    func toJPEGData() -> Data {
        guard let data = self.jpegData(compressionQuality: 0.5) else {
            print("イメージをJPEGデータに変換できませんでした。")
            return Data()
        }
        
        return data
    }
    
}
