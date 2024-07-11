//
//  ViewController.swift
//  Lib
//
//  Created by 関琢磨 on 2024/07/11.
//

import UIKit
import SnapKit
import Kingfisher
import Lottie

extension UIView {
    func applyConstraintSuperViewSafeArea() {
        // self.superviewがnilならクラッシュ
        guard let superview else {
            fatalError()
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

class ViewController: UIViewController {
    var play:Bool = false
    var cnt:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        
        let label = UILabel()
        stackview.addArrangedSubview(label)
//        label.isHidden = true
        
        let imageview = UIImageView()
        stackview.addArrangedSubview(imageview)
//        imageview.isHidden = true
        
//        let gitlabel = UILabel()
//        stackview.addArrangedSubview(gitlabel)
        
        
        self.view.addSubview(stackview)
        stackview.applyConstraintSuperViewSafeArea()
        
        let animationView = LottieAnimationView()
//        animationView.backgroundColor =

        let animation = LottieAnimation.named("animation.json", subdirectory: nil)

        animationView.contentMode = .scaleAspectFit
        animationView.animation = animation
        stackview.addArrangedSubview(animationView)
        
        
        let urlStr: String = "https://picsum.photos/200/300"
        label.text = urlStr
        let url = URL(string: urlStr)!
        
        Task {
            do {
                let (data, urlResponse) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "dataは画像じゃないよ", code: 100)
                }
                
                //　本当はここでUI側に渡して画面に表示したりする
                imageview.image = image
            } catch let error {
                print(error)
            }
        }
        let button = UIButton(type: .roundedRect)
        button.setTitle("reload",for:.normal)
        button.backgroundColor = .red
        stackview.addArrangedSubview(button)
        button.addAction(.init(handler: { _ in 
            if self.play == false{
                animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
                self.play = true
                self.cnt = self.cnt + 1
                if self.cnt == 5{
                    button.setTitle("reset", for: .normal)
                }
            }else{
                animationView.pause()
                self.play = false
                if self.cnt == 5{
                    animationView.stop()
                    self.cnt = 0
                    button.setTitle("reload",for:.normal)
                }
            }
            imageview.kf.indicatorType = .activity
            imageview.kf.setImage(with: URL(string: "https://picsum.photos/200/300"))
            
        }), for: .touchUpInside)

        
        
        let textfield = UITextField()
        stackview.addArrangedSubview(textfield)
    }
}
#Preview{
    ViewController()
}

