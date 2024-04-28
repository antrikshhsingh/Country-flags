import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL) {
        contentMode = .scaleAspectFill
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data,
                  let image = UIImage(data: data) else {
                print("Invalid response or data")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
