//
//  PDFViewerVC.swift
//  BookXpert
//
//  Created by APPLE on 23/04/25.
//

import UIKit
import PDFKit

class PDFViewerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "PDF Viewer"
        setupPDFView()
    }
    
    private func setupPDFView() {
        // Create and configure the PDFView
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.usePageViewController(true)
        pdfView.displayDirection = .horizontal
        
        // Add it to the view
        self.view.addSubview(pdfView)
        
        // Load the PDF file from bundle
        if let path = Bundle.main.path(forResource: "BalanceSheet", ofType: "pdf") {
            let url = URL(fileURLWithPath: path)
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            } else {
                print("Failed to create PDFDocument.")
            }
        } else {
            print("PDF file not found in bundle.")
        }
    }
    
}
