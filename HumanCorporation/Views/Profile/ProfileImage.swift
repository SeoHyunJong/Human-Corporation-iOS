//
//  ProfileImage.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//

import SwiftUI

struct ProfileImage: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 130, height: 130)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static private var image = (UIImage(named: "Mamong"))!
    static var previews: some View {
        ProfileImage(image: image)
    }
}
