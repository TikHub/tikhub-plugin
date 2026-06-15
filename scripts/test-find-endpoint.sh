#!/usr/bin/env bash
# TDD test for bin/tikhub-find-endpoint. Exit 0 = pass.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$ROOT/bin/tikhub-find-endpoint"

fails=0
expect_contains() { # $1 = output, $2 = needle, $3 = label
  if printf '%s' "$1" | grep -q -- "$2"; then echo "PASS: $3"; else echo "FAIL: $3 (missing: $2)"; fails=$((fails+1)); fi
}

out="$("$CLI" "one video" --platform tiktok 2>&1)"
expect_contains "$out" "/api/v1/tiktok/app/v3/fetch_one_video" "tiktok 'one video' finds fetch_one_video"

out2="$("$CLI" "user info" --platform instagram 2>&1)"
expect_contains "$out2" "/api/v1/instagram/v2/fetch_user_info" "instagram 'user info' finds fetch_user_info"

out3="$("$CLI" "comments" --platform youtube --method GET 2>&1)"
expect_contains "$out3" "/api/v1/youtube/web_v2/get_video_comments" "youtube 'comments' finds get_video_comments"

echo "----"; [ "$fails" -eq 0 ] && echo "all passed" || echo "$fails failed"
[ "$fails" -eq 0 ]
