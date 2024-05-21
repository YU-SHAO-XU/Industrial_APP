//
//  ContentView.swift
//  Industrial_APP
//
//  Created by User on 2023/4/30.
//

import SwiftUI
import PDFKit

struct Sop: View {
    var body: some View {
        PDFKitView(pdfName: "sop")
            .aspectRatio(contentMode: .fit)
    }
}

struct PDFKitView: UIViewRepresentable {
    var pdfName: String
    func makeUIView(context: Context) -> PDFKitView.UIViewType {
        guard let path = Bundle.main.path(forResource: pdfName, ofType: "pdf") else {
            fatalError("Could not find PDF file named \(pdfName).pdf")
        }
        let url = URL(fileURLWithPath: path)
        let pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
    }
}

struct Sop_Previews: PreviewProvider {
    static var previews: some View {
        Sop()
    }
}
