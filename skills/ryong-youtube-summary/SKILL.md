---
name: ryong-youtube-summary
description: Summarize YouTube videos directly from a URL without using external summarizer services. Use when a user shares a YouTube link and wants a Korean summary built from retrievable data such as transcript, chapters, title, and description.
---

# YouTube Direct Summary

## Overview

Use the YouTube URL itself as the primary input and generate the final summary directly.
Do not route through any intermediate summarizer service.

## Prerequisites

- Require `python3` and `yt-dlp`.
- Check dependency:
```bash
yt-dlp --version
```

## Install by OS

### macOS

```bash
brew install yt-dlp
```

### Windows

```powershell
winget install yt-dlp.yt-dlp
```

Alternative:

```powershell
choco install yt-dlp
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y yt-dlp
```

### Linux (Fedora)

```bash
sudo dnf install -y yt-dlp
```

### Linux (Arch)

```bash
sudo pacman -S --noconfirm yt-dlp
```

## One-Step Setup Scripts

- macOS/Linux:
```bash
bash scripts/setup.sh
```
- Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1
```

## Dependency Consent Policy

- Always check whether required dependencies are available before extraction.
- If dependencies are missing, ask user for explicit consent before installing.
- If user approves:
  - Run the appropriate setup script for the current OS.
  - Re-run extraction and continue the summary workflow.
- If user declines:
  - Do not attempt installation.
  - Explain that the skill requires `python3` and `yt-dlp` to run from URL directly.
  - Provide OS-specific install commands and offer transcript-paste fallback.

## Workflow

1. Confirm target output
- Collect URL and preferred depth (`short`, `standard`, `deep`).
- If missing, default to `standard`.

2. Extract source context from URL
- If `python3` or `yt-dlp` is missing, follow `Dependency Consent Policy` first.
- Run:
```bash
python3 scripts/youtube_context.py "<youtube-url>" --output /tmp/youtube_context.json
```
- This should collect:
  - metadata (title, channel, duration, description)
  - chapters/timestamps (if available)
  - transcript text (if subtitle retrieval succeeds)

3. Build summary from extracted data
- Primary source: transcript.
- Secondary source: chapters + description when transcript is partial.
- If transcript is not available, clearly mark the output as metadata-based summary.

4. Produce Korean deliverable
- Keep facts grounded in extracted text.
- Separate `확인된 내용` and `추정/해석` when uncertain.
- Never invent timestamps, quotes, or claims.

5. Quality check
- Ensure output answers:
  - 무엇을 말하는 영상인가
  - 핵심 주장/정보는 무엇인가
  - 시청자 관점의 다음 액션은 무엇인가

## Output Format

Use a readable blog-style summary with clear sections, not a flat bullet dump.
Use friendly Korean style (`~어요` / `~해요`) for the entire output.

```markdown
📌 [핵심 질문형 제목]

[핵심 답변 단락 1~2개. 영상의 결론과 가치 제안을 먼저 설명합니다.]

💡 [핵심 포인트 N가지]

- [핵심 포인트 1]
- [핵심 포인트 2]
- [핵심 포인트 3]
- [필요 시 추가]

[요약 브리지 단락]
[이 영상을 왜 봐야 하는지, 누구에게 유용한지 자연스럽게 설명합니다.]

1. [대주제]
1.1. [하위 주제]
[설명 단락]

1.2. [하위 주제]
[설명 단락]

2. [다음 대주제]
2.1. [하위 주제]
[설명 단락]

2.2. [하위 주제]
[설명 단락]

[마무리 단락]
[전체 요약과 활용 포인트를 정리합니다.]
```

## Fidelity Rules

- Keep critical facts, claims, and examples from source material. Do not drop key points for brevity.
- Do not alter meaning. If uncertain, mark uncertainty explicitly instead of rewriting assertively.
- Prefer paragraph-based narrative. Use lists only where they improve clarity.
- Avoid repetitive filler and duplicate sentences from auto-captions.
- Never claim direct video watching.
- Never fabricate unavailable transcript content, timestamps, quotes, or metrics.
- If extraction fails, report the exact missing piece and continue with available data only.
- If required dependencies are unavailable, ask for install permission first; install only on approval.
