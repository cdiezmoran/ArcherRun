import SpriteKit
    
class CircularProgressNode : SKShapeNode {
    fileprivate var radius: CGFloat!
    fileprivate var startAngle: CGFloat!
    
    init(radius: CGFloat, color: SKColor, width: CGFloat, startAngle: CGFloat = CGFloat(M_PI_2)) {
        super.init()
        
        self.radius = radius
        self.strokeColor = color
        self.lineWidth = width
        self.startAngle = startAngle
        
        self.updateProgress(0.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func updateProgress(_ percentageCompleted: CGFloat) {
        let progress = percentageCompleted <= 0.0 ? 1.0 : (percentageCompleted >= 1.0 ? 0.0 : 1.0 - percentageCompleted)
        let endAngle = self.startAngle + progress * CGFloat(2.0 * M_PI)
        
        self.path = UIBezierPath(arcCenter: CGPoint.zero, radius: self.radius, startAngle: self.startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
}
