import SwiftUI
import PDFKit

struct Sop: View {
    var body: some View {
        PDFKitView(pdfName: "sop")
            .aspectRatio(contentMode: .fit) // 使用fit適應螢幕大小
    }
}

struct PDFKitView: UIViewRepresentable {
    var pdfName: String
    func makeUIView(context: Context) -> PDFKitView.UIViewType {
        guard let path = Bundle.main.path(forResource: pdfName, ofType: "pdf") else {
            fatalError("Could not find PDF file named \(pdfName).pdf")
        }
        let url = URL(fileURLWithPath: path)
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) // 設置 PDFView 的 frame
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true // 设置自动缩放以适应视图大小
        pdfView.displayMode = .singlePageContinuous // 設置顯示模式為單頁連續
        pdfView.maxScaleFactor = 4.0 // 設置最大縮放倍率
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update code when needed
    }
}

struct Sop_Previews: PreviewProvider {
    static var previews: some View {
        Sop()
    }
}
