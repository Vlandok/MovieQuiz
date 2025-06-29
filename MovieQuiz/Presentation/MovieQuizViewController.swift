import UIKit

final class MovieQuizViewController: UIViewController, AlertDelegate {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!

    private let presenter = MovieQuizPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        presenter.viewDidLoad()
    }
    
    func upadeteQuiz(quiz: QuizStep) {
        imageView.image = quiz.image
        textLabel.text = quiz.question
        counterLabel.text = quiz.questionNumber
    }
    
    func clearQuizImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func setQuizImageBorder(width: CGFloat, color: CGColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color
    }
    
    func setEnabledButtonsChooseAnswer(isEnable: Bool) {
        buttonsStackView.isUserInteractionEnabled = isEnable
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }

}
