//
//  BasicLayoutController.swift
//
//  Created by Home on 2019.
//  Copyright 2017-2018 NoStoryboardsAtAll Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

// creating enumerations for describing tap location in horizontal and vertical
enum VerticalLocation: Int {
    case top
    case bottom
}
enum HorizontalLocation: Int {
    case left
    case right
}

// tuple type that will be store the location of the view
typealias PointLocation = (VerticalLocation, HorizontalLocation)

class AnimateAutoLayoutController: UIViewController {
    // constant view's side length
    let padding: CGFloat = 69.0
    
    // view to animate
    let animatedView: MyView = MyView()
    
    // variable to store inital view location constraints
    // (at the start of the app the view ) will be placed at the center of the screen
    var initialConstraints: [NSLayoutConstraint] = []
    
    // location constraints for all cases
    var topLeftConstraints: [NSLayoutConstraint] = []
    var topRightConstraints: [NSLayoutConstraint] = []
    var bottomLeftConstraints: [NSLayoutConstraint] = []
    var bottomRightConstraints: [NSLayoutConstraint] = []

    // Do any additional setup here
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // Setup your view and constraints here
    override func loadView() {
        super.loadView()
        prepareView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        // add the handler of single tap to view controller
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(singleTap)
    }
    
    private func prepareView() {
        // prepare the constraints
        initialConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ]
        
        topLeftConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ]
        
        topRightConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ]
        
        bottomLeftConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ]
        
        bottomRightConstraints = [
            animatedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ]
        
        // add view to superview
        view.addSubview(animatedView)
        // activate initial constraints
        NSLayoutConstraint.activate(initialConstraints)
    }

    private func pointLocation(at location: CGPoint, in view: UIView) -> PointLocation {
        var result = PointLocation(.top, .left)
        
        // if location of the tap if less than half og the screen in vertical,
        // store .top in first value of the tuple, .bottom in other case
        result.0 = location.y <= view.frame.size.height * 0.5 ? .top : .bottom

        // if location of the tap if less than half og the screen in horizontal,
        // store .left in first value of the tuple, .right in other case
        result.1 = location.x <= view.frame.size.width * 0.5 ? .left : .right
        
        return result
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: view)
        let quarter = pointLocation(at: location, in: view)
        
        // deactivate current constraints
        NSLayoutConstraint.deactivate(initialConstraints + topLeftConstraints + topRightConstraints +
            bottomLeftConstraints + bottomRightConstraints)
        
        // activate set of the constraints depend on tap location
        switch quarter {
        case (.top, .left):
            NSLayoutConstraint.activate(topLeftConstraints)
        case (.top, .right):
            NSLayoutConstraint.activate(topRightConstraints)
        case (.bottom, .left):
            NSLayoutConstraint.activate(bottomLeftConstraints)
        case (.bottom, .right):
            NSLayoutConstraint.activate(bottomRightConstraints)
        }
        
        // call UIView.animate method
        UIView.animate(withDuration: 0.69, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: {
            // call layoutIfNeeded of the SUPERVIEW to star animation
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
