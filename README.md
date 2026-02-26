# ryong-skills

개인 Codex 스킬 모음 저장소입니다.

## Skill Index

| Skill | One-line Description | 상세 문서 |
|---|---|---|
| `ryong-youtube-summary` | 유튜브 링크에서 transcript/chapters/metadata를 추출해 한국어 섹션형 요약을 생성하는 스킬 | [docs/ryong-youtube-summary.md](./docs/ryong-youtube-summary.md) |

## Repository Structure

- `skills/`: 실제 스킬 폴더 (`SKILL.md`, `agents/`, `scripts/`, `assets/`)
- `docs/`: 배포/소개 문서

## Quick Start

```bash
# 예시: 스킬 폴더 복사
cp -R skills/ryong-youtube-summary "$CODEX_HOME/skills/"
```
