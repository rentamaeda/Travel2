//
//  PostTableViewCell.swift
//  Travel2
//
//  Created by user on 2020/08/29.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import FirebaseUI
class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var Custom: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // カスタムセルの登録
              let nib = UINib(nibName: "CustomCell", bundle: nil)
              Custom.register(nib, forCellWithReuseIdentifier: "Cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionViewDataSourceDelegate
           <D: UICollectionViewDataSource & UICollectionViewDelegate>
           (dataSourceDelegate: D, forRow row: Int) {
           
           Custom.delegate = dataSourceDelegate
           Custom.dataSource = dataSourceDelegate
           Custom.tag = row
           Custom.reloadData()
           
       }
     // PostDataの内容をセルに表示
        func setPostData(_ postData: PostData) {
        
            // キャプションの表示
            self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
            // 日時の表示
                       self.dateLabel.text = "\(postData.postdate!)"
/*
            // 日時の表示
            self.dateLabel.text = ""
           if let date = postData.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.string(from: date)
                self.dateLabel.text = dateString
            }
*/
            // いいね数の表示
            let likeNumber = postData.likes.count
            likeLabel.text = "\(likeNumber)"

            // いいねボタンの表示
            if postData.isLiked {
                let buttonImage = UIImage(named: "like_exist")
                self.likeButton.setImage(buttonImage, for: .normal)
            } else {
                let buttonImage = UIImage(named: "like_none")
                self.likeButton.setImage(buttonImage, for: .normal)
            }
        }
   

    }
