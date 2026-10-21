<div align="center">

[![AgentBar — Two agents. One glance. Codex·Claude 주간 잔여량 두 줄 메뉴바. 소스 기반 재현, 예시 데이터.](https://heeyoung37-37.github.io/agentbar/assets/readme-hero.png)](https://heeyoung37-37.github.io/agentbar/)

**Codex와 Claude Code의 주간 잔여량을, 하나의 macOS 메뉴바에서.**

[**Mac용 다운로드 ↓**](https://github.com/heeyoung37-37/agentbar/releases/download/v0.1.0/AgentBar-0.1.0-macos-arm64.zip)　·　[릴리스 노트](https://github.com/heeyoung37-37/agentbar/releases/tag/v0.1.0)　·　[**Project Page ↗**](https://heeyoung37-37.github.io/agentbar/)　·　[빌드 가이드](DEVELOPMENT.md)

`v0.1.0`　 `Apple Silicon · M1 이상`　 `macOS 14+`　 `MIT`

</div>

## 필요한 정보만, 필요한 자리에

위에는 **Codex**, 아래에는 **Claude**. 이름 · 주간 잔여 % · 막대를 고정된 열에 정렬합니다. 숫자가 `100%`에서 한 자리로 바뀌어도 간격을 유지합니다.

| 고정 열 정렬 | 절제된 메뉴바 | 이어지는 날짜 |
|:---|:---|:---|
| 모노스페이스 숫자와 고정된 퍼센트 열로 두 줄을 단정하게 유지합니다. | 주간 막대의 `W`를 생략하고 macOS 기본 단색으로 표시합니다. 상세 화면의 기존 색상은 유지합니다. | Claude 비용 차트도 최근 30일 날짜 칸을 유지합니다. 완전히 스캔된 미사용 날짜만 0으로 표시합니다. |

<details>
<summary>기존 메뉴바 예시 보기</summary>

![메뉴바 예시: Codex 62%, Claude 97% 남음](docs/menubar.png)

*실제 계정 정보가 없는 예시 데이터입니다. 제품 페이지와 상단 이미지는 소스 기반 재현이며 실제 크기·서체·막대는 macOS 환경에 따라 다릅니다.*

</details>

## 이렇게 사용하세요

1. **시작 전에** — 두 제공자의 주간 잔여량을 함께 확인합니다.
2. **작업 중에** — 코드나 문서를 그대로 두고 메뉴바에서 남은 양을 확인합니다.
3. **돌아볼 때** — 앱의 상세 화면에서 최근 30일 비용 추이를 살펴봅니다.

## 설치

1. [v0.1.0 ZIP](https://github.com/heeyoung37-37/agentbar/releases/download/v0.1.0/AgentBar-0.1.0-macos-arm64.zip)을 받고 압축을 풉니다.
2. `AgentBar.app`을 **응용 프로그램** 폴더로 옮깁니다.
3. 기존 **CodexBar / AgentBar를 종료**하고, 동봉된 `Apply AgentBar Preset.command`를 실행합니다.
4. AgentBar를 열고 **본인의 Codex·Claude 계정**을 연결합니다.

> **설치 전 확인**
>
> Apple Silicon(M1 이상) · macOS 14 이상용입니다. **자체 서명(ad-hoc)이며 Apple 공증은 받지 않았습니다.** 다운로드 출처와 [릴리스의 SHA256SUMS](https://github.com/heeyoung37-37/agentbar/releases/tag/v0.1.0)를 확인하세요. macOS가 실행을 차단하면 시스템 설정 → 개인정보 보호 및 보안에서 해당 앱의 실행 여부를 직접 확인하세요.

- 기존 CodexBar와 **설정·앱 식별자를 공유**하므로 동시에 실행하지 마세요.
- 프리셋은 두 제공자를 활성화하고 **기존 표시 설정을 덮어씁니다**. 로그인 정보는 포함되지 않습니다.
- 브라우저 세션 이용 시 각자의 로그인과 macOS 권한 설정이 필요할 수 있습니다.
- 자동 업데이트는 꺼져 있습니다. 새 버전은 [Releases](https://github.com/heeyoung37-37/agentbar/releases)에서 수동 설치합니다.

## 소스와 빌드

[CodexBar v0.76.0](https://github.com/steipete/CodexBar/tree/v0.76.0) 기반 비공식 수정판입니다. 원본 전체를 중복 저장하는 대신 고정된 원본 커밋, 수정 패치와 빌드 스크립트를 제공합니다. 내부 실행 파일과 일부 설정 화면에는 CodexBar 이름이 남아 있습니다.

```bash
bash scripts/prepare-source.sh  # 원본 다운로드, SHA-256 검증, 패치 적용
bash scripts/build.sh          # Xcode / Swift 6.2 이상 / Python 3 필요
```

[개발·검증 기록](DEVELOPMENT.md) · [수정 패치](patches/agentbar.patch) · [제3자 고지](THIRD_PARTY_NOTICES.md)

## Project Page

메뉴바 미리보기와 사용 예시는 [**Project Page**](https://heeyoung37-37.github.io/agentbar/)에서 살펴보세요.

앱 소스·빌드 스크립트·문서는 기본 브랜치에서 관리하고, 인터랙티브 소개 페이지는 별도 [`gh-pages` 브랜치](https://github.com/heeyoung37-37/agentbar/tree/gh-pages)에서 배포합니다. 앱 설치는 기존 [GitHub Releases](https://github.com/heeyoung37-37/agentbar/releases)에서 진행합니다.

---

Original: [Peter Steinberger / CodexBar](https://github.com/steipete/CodexBar) · [MIT License](LICENSE)  
AgentBar modifications: [heeyoung37-37](https://github.com/heeyoung37-37) · MIT  
OpenAI 또는 Anthropic의 공식 제품이 아닙니다.
