//
//  ImageSelectViewController.swift
//  Travel2
//
//  Created by user on 2020/08/29.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CLImageEditor
import Photos

import DKImagePickerController
class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate ,DKImageAssetExporterObserver{
     var localImages: [UIImage] = []



    @IBAction func handleLibraryButton(_ sender: Any) {
                 let pickerController = DKImagePickerController()
        // 選択可能な枚数を20にする
        pickerController.maxSelectableCount = 20
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            
            // 選択された画像はassetsに入れて返却されるのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(completeBlock: { (image:UIImage?, info) in
                    // ここで取り出せる
                    //self.imageView.image = image
                    //assetsにライブラリの画像をいれる
                   if let image = image {
                    self.localImages.append(image)
                   
                    }
                })
            }
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
                       self.present(postViewController, animated: true, completion: nil)
            }
                   
                   self.present(pickerController, animated: true) {}
    }
    
   
    
    

    @IBAction func handleCameraButton(_ sender: Any) {
        // カメラを指定してピッカーを開く
              if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  let pickerController = UIImagePickerController()
                  pickerController.delegate = self
                  pickerController.sourceType = .camera
                  self.present(pickerController, animated: true, completion: nil)
                
              }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じる
             self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
        }
  
            
        // 写真を撮影選択したときに呼ばれるメソッド
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 if info[.originalImage] != nil {
                     // 撮影/選択された画像を取得する
                     let image = info[.originalImage] as! UIImage

                     // あとでCLImageEditorライブラリで加工する
                     print("DEBUG_PRINT: image = \(image)")
                     // CLImageEditorにimageを渡して、加工画面を起動する。
                     let editor = CLImageEditor(image: image)!
                     editor.delegate = self
                     picker.present(editor, animated: true, completion: nil)
                 }
             }
            // CLImageEditorで加工が終わったときに呼ばれるメソッド
            func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
                // 投稿画面を開く
                let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
                postViewController.image = image!
                editor.present(postViewController, animated: true, completion: nil)
            }
             func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                 // ImageSelectViewController画面を閉じてタブ画面に戻る
                 //self.presentingViewController?.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)

             }
            // CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
               func imageEditorDidCancel(_ editor: CLImageEditor!) {
                   // ImageSelectViewController画面を閉じてタブ画面に戻る
                  // self.presentingViewController?.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)

               }
        }
