//
//  HomeViewController.swift
//  Travel2
//
//  Created by user on 2020/08/29.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate ,UICollectionViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    // 投稿データを格納する配列
      var postArray: [PostData] = []
    // Firestoreのリスナー
     var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           print("DEBUG_PRINT: viewWillAppear")

           if Auth.auth().currentUser != nil {
               // ログイン済み
               if listener == nil {
                   // listener未登録なら、登録してスナップショットを受信する
                   let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                   listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                       if let error = error {
                           print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                           return
                       }
                       // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                       self.postArray = querySnapshot!.documents.map { document in
                           print("DEBUG_PRINT: document取得 \(document.documentID)")
                           let postData = PostData(document: document)
                           return postData
                       }
                       // TableViewの表示を更新する
                       self.tableView.reloadData()
                   }
               }
           } else {
               // ログイン未(またはログアウト済み)
               if listener != nil {
                   // listener登録済みなら削除してpostArrayをクリアする
                   listener.remove()
                   listener = nil
                   postArray = []
                   tableView.reloadData()
               }
           }
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return postArray.count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // セルを取得してデータを設定する
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
           cell.setPostData(postArray[indexPath.row])
        cell.Custom.reloadData()

           return cell
       }
    // セル内のボタンがタップされた時に呼ばれるメソッド
          @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
              print("DEBUG_PRINT: likeボタンがタップされました。")

              // タップされたセルのインデックスを求める
              let touch = event.allTouches?.first
              let point = touch!.location(in: self.tableView)
              let indexPath = tableView.indexPathForRow(at: point)

              // 配列からタップされたインデックスのデータを取り出す
              let postData = postArray[indexPath!.row]

              // likesを更新する
              if let myid = Auth.auth().currentUser?.uid {
                  // 更新データを作成する
                  var updateValue: FieldValue
                  if postData.isLiked {
                      // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                      updateValue = FieldValue.arrayRemove([myid])
                  } else {
                      // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                      updateValue = FieldValue.arrayUnion([myid])
                  }
                  // likesに更新データを書き込む
                  let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                  postRef.updateData(["likes": updateValue])
              }
          }
}
//extensionでcollectionViewについて
extension HomeViewController:    UICollectionViewDelegateFlowLayout{
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        return cell
        
    }
}

//extension ViewController: UITableViewDataSource, UITableViewDelegate
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//      return 3
//  }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 240, height: 180)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
//        return cell
//
//    }
//}
//  //extensionでcollectionViewについて
//extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return 3
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 240, height: 180)
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
//
//            switch (collectionView.tag) {
//            case 0:
//                cell.imageView.image = UIImage(named: dogs[indexPath.row]["imageName"]!)
//                cell.textLabel.text = dogs[indexPath.row]["name"]
//
//            case 1:
//                cell.imageView.image = UIImage(named: dogs2[indexPath.row]["imageName"]!)
//                cell.textLabel.text = dogs2[indexPath.row]["name"]
//
//            case 2:
//                cell.imageView.image = UIImage(named: dogs3[indexPath.row]["imageName"]!)
//                cell.textLabel.text = dogs3[indexPath.row]["name"]
//
//            default:
//                print("section error")
//            }
//            return cell
//        }
//    }
