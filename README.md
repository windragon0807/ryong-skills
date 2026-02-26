# ryong-skills

개인 AI 에이전트(Codex/Claude/Cursor)에서 공통으로 쓰기 위한 스킬 모음 저장소입니다.

## Skill Index

| Skill | One-line Description | 상세 문서 |
|---|---|---|
| `ryong-youtube-summary` | 유튜브 링크에서 transcript/chapters/metadata를 추출해 한국어 섹션형 요약을 생성하는 스킬 | [docs/ryong-youtube-summary.md](./docs/ryong-youtube-summary.md) |

## Repository Structure

- `skills/`: 실제 스킬 폴더 (`SKILL.md`, `agents/`, `scripts/`, `assets/`)
- `docs/`: 배포/소개 문서
- `scripts/`: 설치/연결 보조 스크립트

## Quick Start

```bash
# 1) 레포 가져오기
git clone https://github.com/windragon0807/ryong-skills.git
cd ryong-skills

# 2) 각 에이전트의 skills 디렉터리에 심링크 연결
# 추천: 에이전트 자동 탐색 후 선택
./scripts/link-skill.sh ryong-youtube-summary

# 경로를 직접 지정하고 싶으면 2번째 인자로 전달
# Codex 예시
# ./scripts/link-skill.sh ryong-youtube-summary "$CODEX_HOME/skills"
# ./scripts/link-skill.sh ryong-youtube-summary "<CLAUDE_SKILLS_DIR>"
# ./scripts/link-skill.sh ryong-youtube-summary "<CURSOR_SKILLS_DIR>"
```

## Multi-Agent Linking Policy

- 스킬의 원본은 이 레포(`skills/`)를 단일 소스로 관리합니다.
- 각 에이전트에는 복사 대신 심링크로 연결합니다.
- 업데이트 시에는 `git pull`만 하면 연결된 에이전트에서 바로 최신 스킬을 사용합니다.

## Interactive Mode Note

- `./scripts/link-skill.sh ryong-youtube-summary`의 자동 탐색 모드는 터미널에서 사용자 입력(`read`)을 받을 수 있을 때만 동작합니다.
- Codex/Claude/Cursor를 GUI로 사용하더라도, 내장 터미널 또는 시스템 터미널에서 실행하면 정상 동작합니다.
- GUI 버튼/폼처럼 비대화형 실행 환경에서는 경로를 직접 지정해 실행하세요.
