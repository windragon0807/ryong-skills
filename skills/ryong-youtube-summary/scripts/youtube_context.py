#!/usr/bin/env python3
import argparse
import glob
import platform
import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


def run_cmd(cmd, cwd=None, allow_fail=False):
    proc = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if proc.returncode != 0 and not allow_fail:
        raise RuntimeError(proc.stderr.strip() or "command failed")
    return proc.stdout


def strip_vtt(text):
    lines = []
    for raw in text.splitlines():
        line = raw.strip("\ufeff")
        if not line:
            continue
        if line.startswith("WEBVTT"):
            continue
        if "-->" in line:
            continue
        if line.isdigit():
            continue
        if line.startswith("NOTE"):
            continue
        line = re.sub(r"<[^>]+>", "", line)
        line = re.sub(r"\\b[a-zA-Z]\\b", lambda m: m.group(0), line)
        if line:
            lines.append(line)

    merged = []
    prev = None
    for line in lines:
        if line != prev:
            merged.append(line)
        prev = line
    return "\n".join(merged)


def main():
    parser = argparse.ArgumentParser(description="Extract YouTube metadata + transcript text via yt-dlp")
    parser.add_argument("url", help="YouTube URL")
    parser.add_argument("--lang-priority", default="ko.*,en.*", help="Subtitle language preference (yt-dlp format)")
    parser.add_argument("--output", default="-", help="Output JSON file path, or - for stdout")
    args = parser.parse_args()

    if shutil.which("yt-dlp") is None:
        os_name = platform.system().lower()
        if os_name == "darwin":
            hint = "brew install yt-dlp"
        elif os_name == "windows":
            hint = "winget install yt-dlp.yt-dlp  (or: choco install yt-dlp)"
        else:
            hint = "Install yt-dlp with your package manager (apt/dnf/pacman)"
        raise SystemExit(f"yt-dlp is required. Install command: {hint}")

    with tempfile.TemporaryDirectory() as tmp:
        info_raw = run_cmd(["yt-dlp", "--skip-download", "--dump-single-json", args.url])
        info = json.loads(info_raw)

        run_cmd(
            [
                "yt-dlp",
                "--skip-download",
                "--write-auto-sub",
                "--write-sub",
                "--sub-langs",
                args.lang_priority,
                "--sub-format",
                "vtt",
                "-o",
                "%(id)s.%(ext)s",
                args.url,
            ],
            cwd=tmp,
            allow_fail=True,
        )

        vtt_files = sorted(glob.glob(str(Path(tmp) / "*.vtt")))
        transcript = ""
        if vtt_files:
            transcript = strip_vtt(Path(vtt_files[0]).read_text(encoding="utf-8", errors="ignore"))

        out = {
            "url": args.url,
            "video_id": info.get("id"),
            "title": info.get("title"),
            "channel": info.get("channel") or info.get("uploader"),
            "duration": info.get("duration"),
            "upload_date": info.get("upload_date"),
            "description": info.get("description"),
            "chapters": info.get("chapters") or [],
            "tags": info.get("tags") or [],
            "transcript_available": bool(transcript),
            "transcript": transcript,
        }

        output = json.dumps(out, ensure_ascii=False, indent=2)
        if args.output == "-":
            print(output)
        else:
            Path(args.output).write_text(output, encoding="utf-8")
            print(args.output)


if __name__ == "__main__":
    main()
