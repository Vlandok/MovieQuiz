import UIKit

final class MovieQuizViewController: UIViewController, AlertDelegate,
    UIStateDelegate
{

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let presenter = MovieQuizPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        presenter.uiStateDelegate = self
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
    
    func setVisibilityContent(_ visible: Bool) {
        contentStackView.isHidden = !visible
    }
    
    func setVisibilityLoadingIndicator(_ isVisible: Bool) {
        if isVisible {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }

}
