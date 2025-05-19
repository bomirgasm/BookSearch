import UIKit
import SnapKit

protocol BookDetailDelegate: AnyObject {
    func didAddBook(_ book: Book)
}

class BookDetailViewController: UIViewController {

    // MARK: - Properties
    private let book: Book
    weak var delegate: BookDetailDelegate?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let imageView = UIImageView()
    private let priceLabel = UILabel()
    private let contentsLabel = UILabel()

    private let closeButton = UIButton()
    private let saveButton = UIButton()

    // MARK: - Init
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Life Cycle

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didAddBook(book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }

    // MARK: - UI 구성
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [titleLabel, authorLabel, imageView, priceLabel, contentsLabel].forEach {
            contentView.addSubview($0)
        }

        // 스타일 설정
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textAlignment = .center

        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textAlignment = .center

        contentsLabel.font = .systemFont(ofSize: 20)
        contentsLabel.numberOfLines = 0
        contentsLabel.lineBreakMode = .byWordWrapping
        contentsLabel.setContentHuggingPriority(.required, for: .vertical)
        contentsLabel.setContentCompressionResistancePriority(.required, for: .vertical)


        imageView.contentMode = .scaleAspectFit

        closeButton.setTitle("X", for: .normal)
        closeButton.backgroundColor = .lightGray
        closeButton.layer.cornerRadius = 25
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)

        saveButton.setTitle("담기", for: .normal)
        saveButton.backgroundColor = .green
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 25
        saveButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)

        layout()
    }

    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100) // 버튼 공간 확보
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(280)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }


        // 너비 기준 anchorView 하나 만들기 (예: 전체 가로 너비 100 기준)
        let containerView = UIView()
        view.addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(50)
        }

        // 버튼 추가 및 비율 설정
        containerView.addSubview(closeButton)
        containerView.addSubview(saveButton)

        closeButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(saveButton.snp.width).multipliedBy(1.0 / 3.0) // 비율
        }

        saveButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            
            $0.leading.equalTo(closeButton.snp.trailing).offset(12)
            
            $0.trailing.equalToSuperview()

        }


    }

    // MARK: - 데이터 바인딩
    private func configure() {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        priceLabel.text = "\(book.price ?? 0)원"
        contentsLabel.text = book.contents

        if let url = URL(string: book.thumbnail) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func dismissModal() {
        dismiss(animated: true)
    }

    @objc private func saveBook() {
        CoreDataManager.shared.save(book: book)
        delegate?.didAddBook(book)
        dismiss(animated: true)
    }
    
    // 1) 가장 아래에 추가
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RecentBookManager.shared.add(book)
    }

}
