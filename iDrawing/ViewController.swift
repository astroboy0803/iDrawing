//
//  ViewController.swift
//  iDrawing
//
//  Created by BruceHuang on 2021/6/28.
//

import UIKit

class ViewController: UIViewController {
    
    private let circleView: CircleView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        self.setupLayout()
        self.circleView.setup(dataProvider: .init(topic: "", lineWidth: nil, strokeColor: nil, fillColor: nil))
    }
    
    private func setupLayout() {
        self.circleView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.circleView)
        NSLayoutConstraint.activate([
            self.circleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.circleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.circleView.widthAnchor.constraint(equalToConstant: 200),
            self.circleView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.run()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.drawCircle()
//        }
    }
    
    @IBAction private func doPress(_ sender: UIButton) {
        print("press....")
    }
    
    private func run() {
        let segment = 10000
        let basePercent = CGFloat(1)/CGFloat(segment)
        for degree in 0...segment {
            let percent = CGFloat(degree) * basePercent
            let deadLine: DispatchTime = .now() + 0.001 * Double(degree)
            DispatchQueue.main.asyncAfter(deadline: deadLine) {
                self.circleView.show(percent: percent)
            }
            if degree >= segment {
                let endDeadLine = deadLine + 1
                DispatchQueue.main.asyncAfter(deadline: endDeadLine) {
                    self.circleView.hide()
                }
            }
        }
    }

    private func drawCircle() {
        let lineWidth: CGFloat = 6
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
//        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 100, y: 100, width: 80, height: 80))
//        shape.path = ovalPath.cgPath
        
//        let arcCornerPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: 40, startAngle: .zero, endAngle: .pi * 2, clockwise: false)
//        shape.path = arcCornerPath.cgPath
        let segment = 10
        let basePercent = CGFloat(segment)/CGFloat(100)
        for degree in 0...segment {
            let percent = CGFloat(degree) * basePercent
            let endAngle = .pi * 2 * percent
            let deadLine: DispatchTime = .now() + 0.5 * Double(degree)
            DispatchQueue.main.asyncAfter(deadline: deadLine) {
                let arcCornerPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: 40, startAngle: .zero, endAngle: endAngle, clockwise: true)
                shape.path = arcCornerPath.cgPath
                self.circleView.show(percent: percent)
            }
        }
        
        self.view.layer.addSublayer(shape)
    }
}

