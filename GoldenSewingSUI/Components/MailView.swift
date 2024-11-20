import MessageUI
import ModelsKit
import SwiftUI

public struct MailView: UIViewControllerRepresentable {
    let product: ProductModel
    
    @Binding var showMail: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["info@zolotoe-shitvo.kr.ua"])
        vc.setSubject("Заказ информации по артикулу \(product.id.value) из приложения")
        vc.setMessageBody(
            """
            <p>
            Здравствуйте!
            Интересует информация по выбранному мной изделию \"\(product.title)\"
            </p>
            <a href=\(product.link)> Источник</a>
            """, isHTML: true)
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    static func canSendMail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    public final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: (any Error)?
        ) {
            defer { parent.showMail = false }
            
            if let error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
        }
    }
}
