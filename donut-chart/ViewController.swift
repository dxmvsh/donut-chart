import UIKit

class ViewController: UIViewController {
    private let chartView = DonutChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chartView.widthAnchor.constraint(equalToConstant: 400),
            chartView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}

#Preview {
    let viewController = ViewController()
    return viewController.view
}
