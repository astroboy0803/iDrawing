//
//  CircleView.swift
//  iDrawing
//
//  Created by BruceHuang on 2021/6/28.
//

import UIKit

public final class CircleView: UIView {
    
    struct SetupProvider {
        let topic: String?
        let lineWidth: CGFloat?
        let strokeColor: UIColor?
        let fillColor: UIColor?
    }
    
    private let drawView: UIView = .init()
    
    private let topicLabel: UILabel = .init()
    
    private var lineWidth: CGFloat = 5
    
    private var strokeColor: CGColor = UIColor.white.cgColor
    
    private var fillColor: CGColor = UIColor.clear.cgColor
    
    private var topic: String?
    
    private lazy var shaper: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = self.lineWidth
        shape.strokeColor = self.strokeColor
        shape.fillColor = self.fillColor
        return shape
    }()
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSetup()
    }
    
    private func initSetup() {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10
        self.drawView.layer.addSublayer(self.shaper)
        self.topicLabel.textAlignment = .center
        self.topicLabel.font = .systemFont(ofSize: 20)
        self.topicLabel.textColor = .white
        self.topicLabel.adjustsFontSizeToFitWidth = true
        self.topicLabel.minimumScaleFactor = 0.6
        self.setupLayout()
    }
    
    private func setupLayout() {
        [drawView, topicLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
        NSLayoutConstraint.activate([
            self.drawView.topAnchor.constraint(equalTo: self.topAnchor),
            self.drawView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.drawView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.drawView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            self.topicLabel.topAnchor.constraint(equalTo: self.drawView.bottomAnchor),
            self.topicLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.topicLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.topicLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: 設定屬性
    final func setup(dataProvider: SetupProvider) {
        if let lineWidth = dataProvider.lineWidth, lineWidth > 0 {
            self.lineWidth = lineWidth
        }
        if let fillColor = dataProvider.fillColor {
            self.fillColor = fillColor.cgColor
        }
        if let strokeColor = dataProvider.strokeColor {
            self.strokeColor = strokeColor.cgColor
        }
        self.topic = dataProvider.topic
    }
    
    // MARK: 顯示
    final func show(percent: CGFloat) {
        self.isHidden = false
        let endAngle = .pi * 2 * percent
        let minEdge = min(self.drawView.frame.width, self.drawView.frame.height)
        let radius = (minEdge - lineWidth * 2) / 2
        let arcCornerPath = UIBezierPath(arcCenter: self.drawView.center, radius: radius, startAngle: .zero, endAngle: endAngle, clockwise: true)
        self.shaper.path = arcCornerPath.cgPath
        
        let showPercent = String(format: "%0.2f", 100 * percent)
        if let topic = self.topic {
            self.topicLabel.isHidden = false
            if !topic.isEmpty {
                self.topicLabel.text = "\(topic): \(showPercent) %"
            } else {
                self.topicLabel.text = "\(showPercent)%"
            }
        } else {
            self.topicLabel.isHidden = true
        }
    }
    
    // MARK: 隱藏
    final func hide() {
        self.isHidden = true
    }
}
