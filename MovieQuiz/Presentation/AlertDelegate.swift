import UIKit

protocol AlertDelegate: AnyObject {
    func upadeteQuiz(quiz: QuizStep)
    func clearQuizImageBorder()
    func presentAlert(alert: UIAlertController)
    func setQuizImageBorder(width: CGFloat, color: CGColor)
    func setEnabledButtonsChooseAnswer(isEnable: Bool)
}
