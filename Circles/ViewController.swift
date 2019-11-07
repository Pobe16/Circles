//
//  ViewController.swift
//  Circles
//
//  Created by Mikolaj Lukasik on 04/11/2019.
//  Copyright © 2019 Mikolaj Lukasik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var lastTouch : CGPoint?
    var greatCircleDance : Int = 0
    let resetButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 120, height: 60)))
    let explanationLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 60)))
    
    @IBOutlet var gr: UITapGestureRecognizer!
    @IBOutlet var sgr: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gr.addTarget(self, action: #selector(handleTap))
        sgr.addTarget(self, action: #selector(handleSwipe))
        
        view.addGestureRecognizer(gr)
        view.addGestureRecognizer(sgr)
        prepareResetButton()
        prepareExplanationLabel()
        
    }
    
    func prepareExplanationLabel(){
        explanationLabel.text = "Start tapping!"
        explanationLabel.backgroundColor = UIColor(named: "buttonBackground")
        explanationLabel.clipsToBounds = true
        explanationLabel.textAlignment = .center
        explanationLabel.layer.cornerRadius = explanationLabel .frame.height / 2
        view.addSubview(explanationLabel)
        explanationLabel.font = explanationLabel.font.withSize(25)
        view.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        explanationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        explanationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        explanationLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func prepareResetButton() {
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = UIColor(named: "buttonBackground")
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
        resetButton.layer.zPosition = .greatestFiniteMagnitude
        resetButton.addTarget(self, action: #selector(resetShapes), for: .touchUpInside)
        view.addSubview(resetButton)
        resetButton.titleLabel?.font = resetButton.titleLabel?.font.withSize(25)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        resetButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        resetButton.isHidden = true
        
    }
    
    @objc func resetShapes (sender: UIButton) {
        view.subviews.forEach { shape in
            if shape != resetButton {
                UIView.animate(
                    withDuration: 0.75,
                    delay: 0,
                    usingSpringWithDamping: 0.75,
                    initialSpringVelocity: 0.25,
                    options: [],
                    animations: {
                        shape.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    },
                    completion: { (finished : Bool) in
                        if finished {shape.removeFromSuperview()}
                    }
                )
            }
            
        }
        UIView.animate(
            withDuration: 0.75,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: [],
            animations: {self.resetButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)},
            completion: { (finished : Bool) in
                if finished {self.resetButton.isHidden = true}
            }
        )
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        lastTouch = sender.location(ofTouch: 0, in: view)
        print("Tap")
        print(lastTouch ?? "Error in generating point.")
        
        let newView = makeView()
        
        newView.transform = CGAffineTransform(scaleX: 0.2, y: 0.5)
        view.addSubview(newView)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: [],
            animations: {newView.transform = .identity},
            completion: nil
        )
        
        
        if resetButton.isHidden {
            self.resetButton.isHidden = false
            UIView.animate(
                withDuration: 0.75,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0,
                options: [],
                animations: {self.resetButton.transform = .identity},
                completion: nil
            )
        }
        
        if explanationLabel.isHidden == false {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0,
                options: [],
                animations: {self.explanationLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)},
                completion: { (finished : Bool) in
                    if finished {self.explanationLabel.isHidden = true}
                }
            )
        }
        self.spreadViewsAround()
        
                       
    }
    
    
    @objc func handleSwipe(sender: UIPanGestureRecognizer) {
        print("Swipe")
//        view.subviews.last?.removeFromSuperview()
        
    }
    
    func spreadViewsAround() {
        let lastAdded = view.subviews.last

        view.subviews.forEach {  shape in
            if shape != lastAdded && shape != resetButton {
                let initialDistanceX = shape.center.x - lastAdded!.center.x
                let initialDistanceY = shape.center.y - lastAdded!.center.y
                let distanceBetweenCentres =  (initialDistanceX*initialDistanceX + initialDistanceY*initialDistanceY).squareRoot()
                
                let distanceBetweenShapes = shape.frame.size.width/2 + lastAdded!.frame.size.width/2
                
                if distanceBetweenCentres < distanceBetweenShapes {
                    
                    let proportionalDistance = distanceBetweenShapes / distanceBetweenCentres
                    
                    let lastAddedPosition = lastAdded!.center
                    
                    let size = shape.frame.size
                    
                    let moveShapeByX = initialDistanceX * proportionalDistance + (initialDistanceX > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                    
                    let moveShapeByY = initialDistanceY * proportionalDistance + (initialDistanceY > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                    
                    let newPosition = CGPoint(
                        x: lastAddedPosition.x + moveShapeByX - shape.frame.size.width/2,
                        y: lastAddedPosition.y + moveShapeByY - shape.frame.size.width/2
                    )
                    
                    UIView.animate(
                        withDuration: 0.5,
                        delay: 0,
                        usingSpringWithDamping: 0.25,
                        initialSpringVelocity: 0,
                        options: [],
                        animations: {
                           shape.frame = CGRect(origin: newPosition, size: size)
                        },
                        completion: {(finished : Bool) in
                            if finished {self.theGreatShapeDance()}
                        }
                    )
                    
                    
                                    
                }
            }
        }
    }
    
    func removeShapesOutOfBounds() {
        var shapesDeleted = 0
         view.subviews.forEach { shape in
            if  (
                    shape.center.x + shape.frame.size.width/2 < 0 ||
                    shape.center.y + shape.frame.size.height/2 < 0
                ) || (
                    shape.center.x - shape.frame.size.width/2 > view.bounds.maxX ||
                    shape.center.y - shape.frame.size.height/2 > view.bounds.maxY
                )
            {
                shapesDeleted += 1
                shape.removeFromSuperview()
            }
        }
        shapesDeleted > 0 ? print("Deleted \(shapesDeleted) shapes.") : nil
    }
    
    func theGreatShapeDance() {
        var shapesMoved = 0
        var shapeMoved = false
        view.subviews.reversed().forEach{ mainShape in
            let currentShape = mainShape
            view.subviews.forEach { shape in
                if shape != currentShape && shape != resetButton {
                    let initialDistanceX = shape.center.x - currentShape.center.x
                    let initialDistanceY = shape.center.y - currentShape.center.y
                    let distanceBetweenCentres =  (initialDistanceX * initialDistanceX + initialDistanceY * initialDistanceY).squareRoot()
                    
                    let distanceBetweenShapes = shape.frame.size.width/2 + currentShape.frame.size.width/2
                    

                    if distanceBetweenCentres < distanceBetweenShapes {
                        shapeMoved = true
                        shapesMoved += 1
                        
                        let proportionalDistance = distanceBetweenShapes / distanceBetweenCentres
                        
                        let lastAddedPosition = currentShape.center
                        
                        let size = shape.frame.size
                        
                        let moveShapeByX = initialDistanceX * proportionalDistance + (initialDistanceX > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                        
                        let moveShapeByY = initialDistanceY * proportionalDistance + (initialDistanceY > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                        
                        let newPosition = CGPoint(
                            x: lastAddedPosition.x + moveShapeByX - shape.frame.size.width/2,
                            y: lastAddedPosition.y + moveShapeByY - shape.frame.size.width/2
                        )
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0 ,
                            usingSpringWithDamping: 0.25,
                            initialSpringVelocity: 0,
                            options: [],
                            animations: {
                               shape.frame = CGRect(origin: newPosition, size: size)
                            },
                            completion: nil
                        )
                        
                        
                    }
                }
            }
            
        }
        greatCircleDance += 1
        print("This dance moved \(shapesMoved) shapes.")
        removeShapesOutOfBounds()
        if shapeMoved && greatCircleDance < 150 {
            theGreatShapeDance()
        } else {
            print("The Great Circle Dance has run \(greatCircleDance) times. There are \(view.subviews.count) shapes.")
            greatCircleDance = 0
        }
    }
    
    
    
    func makeView() -> UIView {
        let longerSizeOfSuperView : CGFloat = max(view.bounds.maxX, view.bounds.maxY)
        
        let size = makeRandomSize(inRange: longerSizeOfSuperView/10...longerSizeOfSuperView/3)
        
        let shorterSizeOfTheThing : CGFloat = min(size.width, size.height)
        
        let position = makeRandomPosition(usingWidth: size.width, andHeight: size.height)
        
        let newView = UIView()
        
        newView.frame = CGRect(origin: position, size: size)
//        newView.backgroundColor = makeRandomColor()
        let gradient = CAGradientLayer()

        gradient.frame = newView.bounds
        gradient.cornerRadius = makeRandomCornerRadius(usingWidth: shorterSizeOfTheThing)
        gradient.colors = [makeRandomColor().cgColor, makeRandomColor().cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = Int.random(in: 0...1) == 1 ? CGPoint(
            x: 1,
            y: CGFloat.random(in: 0.0 ... 1.0)
        ) : CGPoint(
            x: CGFloat.random(in: 0.0 ... 1.0),
            y: 1
        )
        newView.layer.insertSublayer(gradient, at: 0)
        newView.layer.cornerRadius = makeRandomCornerRadius(usingWidth: shorterSizeOfTheThing)
        
        
        
        return newView
        
    }
    
    func makeRandomSize(inRange range: ClosedRange<CGFloat>) -> CGSize {
        let width = CGFloat.random(in: range)
//        let height = CGFloat.random(in: range)
//        return CGSize(width: width, height: height)
        return CGSize(width: width, height: width)
    }
    
    func makeRandomPosition(usingWidth width: CGFloat, andHeight height: CGFloat) -> CGPoint {
        let exactX = (lastTouch?.x ?? view.center.x) - (width/2)
        let exactY = (lastTouch?.y ?? view.center.y) - (height/2)
        
        let rangeOfXPosition: ClosedRange<CGFloat> = exactX-50 ... exactX+50
        let rangeOfYPosition: ClosedRange<CGFloat> = exactY-50 ... exactY+50
        
        
//      This is how it was done in example - total randomness, all within range.
//      I want to make it show up on (or in close vicinity of) tap. /\/\/\
//
//        let maxX = view.bounds.maxX - width
//        let rangeOfXPosition = view.bounds.minX ... maxX
//
//        let maxY = view.bounds.maxY - height
//        let rangeOfYPosition = view.bounds.minY ... maxY

        let x = CGFloat.random(in: rangeOfXPosition)
        let y = CGFloat.random(in: rangeOfYPosition)

        return CGPoint(x: x, y: y)
    }
    
    func makeRandomColor() -> UIColor {
        
//        let randomRange : ClosedRange<CGFloat> = 0...255
        let pastelRange : ClosedRange<CGFloat> = 127...255
        
        let randomRed = CGFloat.random(in: pastelRange) / 255
        let randomGreen = CGFloat.random(in: pastelRange) / 255
        let randomBlue = CGFloat.random(in: pastelRange) / 255
//        let randomRed = CGFloat.random(in: randomRange) / 255
//        let randomGreen = CGFloat.random(in: randomRange) / 255
//        let randomBlue = CGFloat.random(in: randomRange) / 255
        let randomAlpha = CGFloat.random(in: 0.6...1)
        
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: randomAlpha)
    }

    func makeRandomCornerRadius(usingWidth width: CGFloat) -> CGFloat {
//        return CGFloat.random(in: 0...(width/2))
        return width/2
    }

}

