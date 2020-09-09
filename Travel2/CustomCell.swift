//
//  CustomCell.swift
//  Travel2
//
//  Created by user on 2020/09/05.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import FirebaseUI
class CustomCell: UICollectionViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // PostDataの内容をセルに表示
          func setPostData(_ postData: PostData) {
    // 画像の表示
           
            ImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id  + ".jpg")
            ImageView.sd_setImage(with: imageRef)
            
    }
}
