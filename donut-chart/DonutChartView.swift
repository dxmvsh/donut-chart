import UIKit
import CoreGraphics

final class DonutChartView: UIView {
    let items: [DonutChartItem] = [
        .init(percentage: 29, color: .dcGreen),
        .init(percentage: 38, color: .dcBlue),
        .init(percentage: 13, color: .dcLightBlue),
        .init(percentage: 20, color: .dcPurple),
    ]

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCirle(center: .init(x: 200, y: 200), radius: 100, lineWidth: 5, alpha: 1)
    }

    private func drawCirle(center: CGPoint, radius: CGFloat, lineWidth: CGFloat, alpha: CGFloat) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        var startAngle: CGFloat = 0

        for item in items {
            let endAngle = startAngle + 2 * .pi * CGFloat(item.percentage) / 100
            context.setStrokeColor(item.color.cgColor)
            context.setLineWidth(20)

            context.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            context.strokePath()

            startAngle = endAngle
        }
    }
}

struct DonutChartItem {
    let percentage: Int
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
