//
//  ViewController.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 09/09/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController, Encodable {
        
    let filename:String = "results"
    

    @IBAction func shareButtonAction(_ sender: Any) {
        let pdfData = [self.resourceUrl(forFileName: filename)]
        let vc = UIActivityViewController(activityItems: pdfData as [Any], applicationActivities: nil)
        present(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayPdf()
        // Do any additional setup after loading the view.
    }
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        if let resourceUrl = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            return resourceUrl
        }
        return nil
    }
    
      private func createPdfView(withFrame frame: CGRect) -> PDFView {
          let pdfView = PDFView(frame: frame)
          pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          pdfView.autoScales = true
          return pdfView
      }
      
      private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
          if let resourceUrl = self.resourceUrl(forFileName: fileName) {
              return PDFDocument(url: resourceUrl)
          }
          
          return nil
      }
      private func displayPdf() {
          let pdfView = self.createPdfView(withFrame: self.view.bounds)

          if let pdfDocument = self.createPdfDocument(forFileName: filename) {
              self.view.addSubview(pdfView)
              pdfView.document = pdfDocument
          }
      }
}
