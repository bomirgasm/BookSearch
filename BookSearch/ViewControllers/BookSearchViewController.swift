//
//  BookSearchViewController.swift
//  BookSearch
//
//  Created by Suzie Kim on 5/17/25.
//


import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    
    // MARK: - UI
    private let searchBar = UISearchBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            if section == 0 && !self.recentBooks.isEmpty {
                // 가로 스크롤 섹션
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80 * 3), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 12
                return section
            } else {
                // 세로 스크롤 섹션
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 12
                return section
            }
        }

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        cv.backgroundColor = .white
        return cv
    }()

    // MARK: - Data
    private var recentBooks: [Book] = []
    private var searchResults: [Book] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDelegate()
    }

    // MARK: - UI 세팅
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.placeholder = "책 제목을 검색하세요"

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupDelegate() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - API 호출
    private func fetchBooks(query: String) {
        APIManager.shared.searchBooks(query: query) { [weak self] books in
            self?.searchResults = books
            self?.collectionView.reloadData()
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        fetchBooks(query: keyword)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults.removeAll()
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BookSearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    /* func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recentBooks.isEmpty ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recentBooks.isEmpty {
            return searchResults.count
        } else {
            return section == 0 ? recentBooks.count : searchResults.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        let book = (recentBooks.isEmpty || indexPath.section == 1) ? searchResults[indexPath.item] : recentBooks[indexPath.item]
        cell.configure(with: book)
        return cell
    }*/

    // 셀 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: 80)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book: Book
        if recentBooks.isEmpty {
            book = searchResults[indexPath.item]
        } else {
            book = indexPath.section == 0 ? recentBooks[indexPath.item] : searchResults[indexPath.item]
        }

        let detailVC = BookDetailViewController(book: book)
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }*/


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentBooks = RecentBookManager.shared.fetch()
        collectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recentBooks.isEmpty ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recentBooks.isEmpty {
            return searchResults.count
        } else {
            return section == 0 ? recentBooks.count : searchResults.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }

        let book: Book
        var style: BookCell.BookCellStyle = indexPath.section == 0 && !recentBooks.isEmpty ? .recent : .searchResult



        if recentBooks.isEmpty {
            book = searchResults[indexPath.item]
            style = .searchResult
        } else {
            if indexPath.section == 0 {
                book = recentBooks[indexPath.item]
                style = .recent
            } else {
                book = searchResults[indexPath.item]
                style = .searchResult
            }
        }

        cell.configure(with: book, style: style)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book: Book
        if recentBooks.isEmpty {
            book = searchResults[indexPath.item]
        } else {
            book = indexPath.section == 0 ? recentBooks[indexPath.item] : searchResults[indexPath.item]
        }

        let detailVC = BookDetailViewController(book: book)
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }

    
}

/*
import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    
    // MARK: - UI
    private let searchBar = UISearchBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            if section == 0 && !self.recentBooks.isEmpty {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(240), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 12
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 12
                return section
            }
        }

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        cv.backgroundColor = .white
        return cv
    }()

    // MARK: - Data
    private var recentBooks: [Book] = []
    private var searchResults: [Book] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentBooks = RecentBookManager.shared.fetch()
        collectionView.reloadData()
    }

    // MARK: - UI 세팅
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.placeholder = "책 제목을 검색하세요"

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupDelegate() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - API 호출
    private func fetchBooks(query: String) {
        APIManager.shared.searchBooks(query: query) { [weak self] books in
            self?.searchResults = books
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        fetchBooks(query: keyword)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults.removeAll()
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BookSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recentBooks.isEmpty ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 && !recentBooks.isEmpty ? recentBooks.count : searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let book: Book
        let style: BookCell.BookCellStyle
        
        if recentBooks.isEmpty {
            book = searchResults[indexPath.item]
            style = .searchResult
        } else {
            if indexPath.section == 0 {
                book = recentBooks[indexPath.item]
                style = .recent
            } else {
                book = searchResults[indexPath.item]
                style = .searchResult
            }
        }
        
        cell.configure(with: book, style: style)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book: Book
        if recentBooks.isEmpty {
            book = searchResults[indexPath.item]
        }
    }
}*/
