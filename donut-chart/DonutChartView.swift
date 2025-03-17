import UIKit
import CoreGraphics

final class DonutChartView: UIView {
    let items: [DonutChartItem] = [
        .init(percentage: 29, color: .dcGreen),
        .init(percentage: 38, color: .dcBlue),
        .init(percentage: 13, color: .dcLightBlue),
        .init(percentage: 20, color: .dcPurple),
    ]

    private var spacing: CGFloat {
        .pi / 100
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let innerItems = items.map {
            DonutChartItem(percentage: $0.percentage, color: $0.color.withAlphaComponent(0.08))
        }
        drawCirle(items: innerItems, center: .init(x: 200, y: 200), radius: 100, lineWidth: 20, alpha: 1)
        drawCirle(items: items, center: .init(x: 200, y: 200), radius: 115, lineWidth: 5, alpha: 1)
        drawPercentageLabels(items: items, center: .init(x: 200, y: 200), radius: 100)
    }

    private func drawCirle(
        items: [DonutChartItem],
        center: CGPoint,
        radius: CGFloat,
        lineWidth: CGFloat,
        alpha: CGFloat
    ) {
        var startAngle: CGFloat = -.pi / 2
        let segments = items.map { item -> (startAngle: CGFloat, endAngle: CGFloat, color: UIColor) in
            let endAngle = (startAngle + 2 * .pi * item.percentage / 100)
            let segment = (startAngle, endAngle - spacing, item.color)
            startAngle = endAngle
            return segment
        }

        for segment in segments {
            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: segment.startAngle,
                endAngle: segment.endAngle,
                clockwise: true
            )
            segment.color.setStroke()
            path.lineWidth = lineWidth
            path.stroke()
        }
    }

    private func drawPercentageLabels(items: [DonutChartItem], center: CGPoint, radius: CGFloat) {
        var startAngle: CGFloat = -.pi / 2
        
        for item in items {
            // Calculate the segment angle
            let segmentAngle = 2 * .pi * item.percentage / 100
            
            // Use the start angle of the segment for label positioning
            let labelAngle = startAngle
            
            // Calculate the position for the text (right on the arc)
            let labelRadius = radius
            
            // Create and configure the text attributes
            let percentText = "\(Int(item.percentage))%"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: item.color
            ]
            
            // Save current graphics state
            guard let context = UIGraphicsGetCurrentContext() else { continue }
            context.saveGState()
            
            // Translate to the position on the circle where text should go
            let x = center.x + labelRadius * cos(labelAngle)
            let y = center.y + labelRadius * sin(labelAngle)
            context.translateBy(x: x, y: y)
            
            // Calculate proper rotation angle for the text
            // Add π/2 to make text tangent to the circle at this point
            var textAngle = labelAngle + .pi / 2
            
            // Adjust angle based on quadrant to make all text readable from outside
            if labelAngle > 0 && labelAngle < .pi {
                textAngle += .pi
            }
            
            // Apply rotation
            context.rotate(by: textAngle)
            
            // Calculate the text size
            let textSize = percentText.size(withAttributes: attributes)
            
            // Position the text properly at the start point
            // Offset text based on quadrant to avoid overlapping with segment start
            let textX: CGFloat
            let textY = -textSize.height / 2
            
            // Adjust text position based on which quadrant we're in
            if labelAngle >= -0.5 * .pi && labelAngle < 0 {
                // Top-right quadrant
                textX = 0 // Align left edge with segment start
            } else if labelAngle >= 0 && labelAngle < 0.5 * .pi {
                // Bottom-right quadrant
                textX = -textSize.width // Align right edge with segment start
            } else if labelAngle >= 0.5 * .pi && labelAngle < .pi {
                // Bottom-left quadrant
                textX = -textSize.width // Align right edge with segment start
            } else {
                // Top-left quadrant
                textX = 0 // Align left edge with segment start
            }
            
            // Draw the text
            percentText.draw(at: CGPoint(x: textX, y: textY), withAttributes: attributes)
            
            // Restore the graphics state
            context.restoreGState()
            
            // Update the start angle for the next segment
            startAngle += segmentAngle
        }
    }
}

struct DonutChartItem {
    let percentage: CGFloat
    let color: UIColor
}

extension UIColor {
    static var dcGreen = UIColor(red: 59 / 255, green: 237 / 255, blue: 141 / 255, alpha: 1.0)
    static var dcBlue = UIColor(red: 78 / 255, green: 167 / 255, blue: 248 / 255, alpha: 1.0)
    static var dcLightBlue = UIColor(red: 29 / 255, green: 220 / 255, blue: 246 / 255, alpha: 1.0)
    static var dcPurple = UIColor.init(red: 146 / 255, green: 95 / 255, blue: 253 / 255, alpha: 1.0)
}

#Preview {
    DonutChartView()
}
