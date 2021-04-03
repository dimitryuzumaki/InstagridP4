//
//  ViewController.swift
//  Instagrid
//
//  Created by Dimitry Aumont on 27/03/2021.
//
import UIKit

class ViewController: UIViewController {
    //MARK: -Properties
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var plusButtons: [UIButton]!
    @IBOutlet weak var gridView: UIView!
    private var buttonView : UIButton?
    private var swipeGestureRecognizer : UISwipeGestureRecognizer?
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(animateGridView))
        swipeGestureRecognizer?.addTarget(self, action: #selector(shareGridView))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        gridView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    //MARK: -plus buttons are typed
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        buttonView = sender
        present(vc, animated: true)
    }
    //MARK: -the bottom buttons are touched by the user to change the central grid
    
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        for layoutButton in layoutButtons {
            layoutButton.isSelected = false
        }
        sender.isSelected = true
        switch sender.tag {
        case 0 :
            plusButtons[1].isHidden = true
            plusButtons[3].isHidden = false
        case 1 :
            plusButtons[1].isHidden = false
            plusButtons[3].isHidden = true
        case 2 :
            plusButtons[1].isHidden = false
            plusButtons[3].isHidden = false
        default: break
        }
    }
    
    @objc func setUpSwipeDirection(){
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation ==
            .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        }else {
            swipeGestureRecognizer?.direction = .up
        }
    }
    //MARK: -central grid animation
    
    @objc func animateGridView(constraint: CGFloat){
        print("animation")
        if swipeGestureRecognizer?.direction == .up{
            
            UIView.animate(withDuration: 0.5) {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }
        } else   {
            UIView.animate(withDuration:0.5) {
                self.gridView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }
            
        }
    }
    //MARK: -the central grid can be shared by the user and he can also save it's photos
    @objc func shareGridView(){
        print("partage")
        guard let image = gridView.asImage() else {return}
        let items = [image]
        let ac = UIActivityViewController(activityItems: items  , applicationActivities: nil)
        present(ac, animated: true)
        ac.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5) {
                self.gridView.transform = .identity
            }
        }
    }
}

extension ViewController:
    //MARK: -UIImagePickerController is used to integrate photos into the application
    
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            buttonView?.setImage(nil, for: .normal)
            buttonView?.setBackgroundImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


