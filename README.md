# BookSearch

## 개요

**BookSearch**는 Kakao Book API를 활용해 도서를 검색하고, 상세 정보를 확인하거나 Core Data에 저장할 수 있는 iOS 앱입니다. 사용자가 책을 검색하고, 최근 본 도서를 확인하거나 관심 있는 책을 저장할 수 있도록 지원합니다. UIKit 기반으로 구현되었으며 SnapKit, UICollectionViewCompositionalLayout 등을 사용하여 레이아웃을 구성했습니다.

---

## 주요 기능

- **도서 검색**  
  - Kakao Book API를 통해 도서 검색  
  - 제목, 저자, 가격 등의 정보를 표시  

- **도서 상세 보기**  
  - 이미지, 제목, 저자, 가격, 책 소개 제공  
  - '담기' 버튼을 통해 Core Data에 저장 가능  

- **도서 저장 (담기)**  
  - 저장된 책은 "담은 책" 탭에서 확인 가능  
  - Core Data 기반 저장/삭제 기능 제공  

- **최근 본 책**  
  - 도서 상세 보기 진입 시 최근 본 책으로 자동 저장  
  - 최대 10권까지 저장되며, 검색 화면 상단에서 가로 스크롤로 표시  
  - 최근 본 책이 없으면 해당 섹션은 숨김 처리  

- **실시간 검색 초기화**  
  - 검색창에 입력을 지우면 자동으로 검색 결과 초기화  

---

## 사용 기술

- `UIKit`
- `SnapKit`
- `UICollectionViewCompositionalLayout`
- `CoreData`
- `Kakao Book REST API`
- `URLSession`

---

## 프로젝트 구조

```
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
```

---

## 실행 방법

1. [Kakao Developers](https://developers.kakao.com/)에 로그인해 **REST API 키**를 발급받습니다.
2. `APIManager.swift`에 본인의 API 키를 삽입합니다.
   ```swift
   private let apiKey = "KakaoAK YOUR_REST_API_KEY"
3. BookSearch.xcodeproj를 열고 빌드 및 실행합니다.
