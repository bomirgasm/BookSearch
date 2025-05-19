//
//  BookCell.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/17/25.
//
import UIKit
import SnapKit

class BookCell: UICollectionViewCell {
    
    private var currentStyle: BookCellStyle = .searchResult
    
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let priceLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    static let identifier = "BookCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)

        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        // 공통 스타일
        titleLabel.font = .boldSystemFont(ofSize: 14)
        authorLabel.font = .systemFont(ofSize: 12)
        priceLabel.font = .systemFont(ofSize: 12)
        
        // 기본 숨김
        titleLabel.isHidden = true
        authorLabel.isHidden = true
        priceLabel.isHidden = true
        thumbnailImageView.isHidden = true

        // SnapKit 레이아웃
        thumbnailImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configure(with book: Book, style: BookCellStyle) {
        self.currentStyle = style // ⭐️ 상태 보존용

        switch style {
        case .recent:
            titleLabel.isHidden = true
            authorLabel.isHidden = true
            priceLabel.isHidden = true
            thumbnailImageView.isHidden = false
            contentView.layer.cornerRadius = contentView.frame.width / 2
            contentView.layer.masksToBounds = true

            // 이미지를 동기적으로 불러오기 (간단용)
            if let url = URL(string: book.thumbnail) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.thumbnailImageView.image = image
                        }
                    }
                }
            }

        case .searchResult:
            titleLabel.isHidden = false
            authorLabel.isHidden = false
            priceLabel.isHidden = false
            thumbnailImageView.isHidden = true
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = false

            titleLabel.text = book.title
            authorLabel.text = book.authors.joined(separator: ", ")
            priceLabel.text = "\(book.price ?? 0)원"
        }
    }

    enum BookCellStyle {
        case recent
        case searchResult
    }
}
