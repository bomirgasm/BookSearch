# BookSearch

프로젝트 개요
BookSearch는 Kakao Book API를 활용하여 도서를 검색하고, 검색한 도서를 CoreData에 저장하거나 최근 본 도서를 관리할 수 있는 iOS 앱입니다. UIKit 기반으로 구현되었으며, 컴포지셔널 레이아웃과 SnapKit을 사용하여 유연한 UI 구성을 목표로 합니다.

주요 기능
도서 검색

검색어를 입력하면 Kakao Book API를 통해 도서 정보를 검색합니다.

검색 결과는 제목, 저자, 가격 정보로 표시됩니다.

도서 상세 보기

검색 결과 셀을 선택하면 해당 도서의 상세 정보를 보여주는 모달이 나타납니다.

도서 이미지, 제목, 저자, 가격, 내용 등을 포함합니다.

도서 저장 (담기)

상세 화면에서 ‘담기’ 버튼을 누르면 해당 도서를 CoreData에 저장합니다.

저장된 도서는 탭바에서 '담은 책' 화면을 통해 확인 가능합니다.

최근 본 도서

도서 상세 화면을 방문한 기록을 로컬에 저장하여 '최근 본 도서' 목록을 제공합니다.

검색 결과 화면의 최상단에 가로 스크롤 형태로 표시됩니다.

최대 10개까지 저장되며, 가장 최근 본 도서가 가장 왼쪽에 위치합니다.

실시간 검색 결과 초기화

검색어 입력창의 텍스트가 비워지면 자동으로 검색 결과 리스트가 초기화됩니다.

사용 기술
UIKit

SnapKit – 오토레이아웃 DSL

UICollectionViewCompositionalLayout – 섹션 별 레이아웃 구분

CoreData – 저장된 도서 및 최근 본 도서 관리

URLSession / Kakao REST API – 도서 검색 API

프로젝트 구조
markdown
복사
편집
BookSearch/
├── Models/
│   └── Book.swift
├── Views/
│   └── BookCell.swift
├── ViewControllers/
│   ├── BookSearchViewController.swift
│   ├── BookDetailViewController.swift
│   └── SavedBooksViewController.swift
├── Managers/
│   ├── APIManager.swift
│   ├── CoreDataManager.swift
│   └── RecentBookManager.swift
├── Resources/
│   └── Assets.xcassets
└── Supporting Files/
    └── AppDelegate.swift, SceneDelegate.swift
실행 방법
Kakao Developers에서 REST API 키를 발급받아 APIManager 파일에 삽입합니다.

Xcode에서 BookSearch.xcodeproj를 열고 시뮬레이터 또는 실제 기기에서 실행합니다.

참고 사항
API 응답에 따라 도서 내용이 짧을 수 있으며, 이는 UI의 문제는 아닙니다.

CoreData 모델은 SavedBook 엔티티를 기반으로 하며, 중복 저장을 방지하기 위해 ISBN을 기준으로 식별합니다.

최근 본 도서 기능은 UserDefaults 또는 CoreData를 통해 관리할 수 있으며, 본 프로젝트는 UserDefaults 기반 커스텀 매니저를 사용합니다.
