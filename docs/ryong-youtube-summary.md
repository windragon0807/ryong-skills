# Ryong YouTube Summary

`ryong-youtube-summary`는 유튜브 링크를 직접 읽어 한국어 요약을 만들어주는 Codex 스킬입니다.
중간 요약 서비스 없이 `transcript`, `chapters`, `metadata`를 기반으로 결과를 생성합니다.

## 어떤 문제를 해결하나요?

- 영상 길이가 길어도 핵심 내용을 빠르게 파악하고 싶을 때
- 검색/코딩/노트 작업 전에 영상 내용을 먼저 구조화하고 싶을 때
- 기계적인 bullet 요약이 아니라 읽기 쉬운 블로그형 요약이 필요할 때

## 핵심 기능

- 유튜브 URL에서 메타데이터/자막/챕터 추출
- 한국어 친숙체(`~어요`, `~해요`) 기반 요약
- 섹션형 출력(`📌 핵심 질문`, `💡 핵심 포인트`, 본문 구조화)
- 누락/왜곡 방지 규칙(Fidelity Rules) 적용
- 의존성 누락 시 사용자 동의 기반 설치 플로우

## 요구사항

- `python3`
- `yt-dlp`

## 설치 방법

### macOS

```bash
brew install yt-dlp
```

### Windows

```powershell
winget install yt-dlp.yt-dlp
```

대안:

```powershell
choco install yt-dlp
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y yt-dlp
```

## 원클릭 설치 스크립트

- macOS/Linux

```bash
bash scripts/setup.sh
```

- Windows PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1
```

## 사용 방법

1. Codex에서 유튜브 링크를 전달합니다.
2. 스킬이 링크에서 `transcript/chapters/metadata`를 수집합니다.
3. 스킬이 한국어 섹션형 요약으로 정리합니다.

직접 실행 예시:

```bash
python3 scripts/youtube_context.py "https://www.youtube.com/watch?v=VIDEO_ID" --output /tmp/youtube_context.json
```

## 출력 스타일

요약은 아래 스타일을 기본으로 사용합니다.

- `📌` 질문형 제목으로 핵심 먼저 전달
- `💡` 핵심 포인트를 짧게 정리
- 본문은 대주제/하위주제로 가독성 있게 구성
- 결론과 활용 포인트로 마무리

## 정확도 정책

- 핵심 사실/사례/수치를 가능한 한 유지합니다.
- 의미를 바꾸지 않습니다.
- 불확실한 내용은 불확실하다고 명시합니다.
- 없는 타임스탬프/인용/수치를 만들지 않습니다.

## 의존성 동의 정책

- `python3` 또는 `yt-dlp`가 없으면 먼저 설치 동의를 요청합니다.
- 동의하면 OS별 스크립트로 설치 후 작업을 이어갑니다.
- 거절하면 설치 가이드와 함께 transcript 붙여넣기 대안을 제공합니다.

## 파일 위치

- 스킬 본문: `/Users/ryong/Documents/ryong-skills/skills/ryong-youtube-summary/SKILL.md`
- 에이전트 메타: `/Users/ryong/Documents/ryong-skills/skills/ryong-youtube-summary/agents/openai.yaml`
- 추출 스크립트: `/Users/ryong/Documents/ryong-skills/skills/ryong-youtube-summary/scripts/youtube_context.py`
