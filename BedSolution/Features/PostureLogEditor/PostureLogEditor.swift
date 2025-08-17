//
//  PostureLogEditor.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI
import PhotosUI

struct PostureLogEditor: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var onLoading: Bool = false
    
    private var loadIndicator: some View {
        VStack(spacing: 0) {
            Image(.load)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundColorSet(theme.colorTheme.onSurface)
            Text("사진 불러오는 중")
                .textStyle(theme.textTheme.bodyLarge)
                .foregroundColorSet(theme.colorTheme.onSurface)
        }
    }
    
    var body: some View {
        VStack {
            Text("자세 변경 기록")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
                .frame(height: 45)
            Spacer()
            if onLoading {
                loadIndicator
                    .transition(.scale)
            } else if let selectedImage {
                selectedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .transition(.blurReplace)
            } else {
                VStack {
                    Image(.noPostureLog)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    Text("자세 이미지를 등록해주세요")
                        .textStyle(theme.textTheme.bodyLarge)
                        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                }
                .transition(.opacity)
            }
            Spacer()
            Button(action: { showPhotoPicker.toggle() }) {
                Text("기록하기")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                type: .emphasized,
                option: .fiilled,
                primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary
            )
            
            Button(action: { dismiss() }) {
                Text("닫기")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                type: .emphasized,
                option: .outline,
                primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary
            )
        }
        .backgroundColorSet(theme.colorTheme.surface)
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem)
        .onChange(of: selectedItem) { _, selection in
            onImageSelected(selection)
        }
    }
    
    private func onImageSelected(_ item: PhotosPickerItem?) {
        guard let item else {
            selectedImage = nil
            return
        }
        Task {
            withAnimation { onLoading = true }
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImg = UIImage(data: data) {
                let base = uiImg.downscaled(maxDimension: 2048)
                if let (jpg, _) = base.jpegDataUnder(maxByte: 512*1024) {
                    if let preview = UIImage(data: jpg) {
                        selectedImage = Image(uiImage: preview)
                    } else {
                        selectedImage = Image(uiImage: base)
                    }
                } else {
                    if let fallback = base.jpegData(compressionQuality: 0.8),
                       let preview = UIImage(data: fallback) {
                        selectedImage = Image(uiImage: preview)
                    } else {
                        selectedImage = Image(uiImage: base)
                    }
                }
            } else {
               selectedImage = nil
            }
            withAnimation { onLoading = false }
        }
    }
}

#Preview {
    PostureLogEditor()
}
