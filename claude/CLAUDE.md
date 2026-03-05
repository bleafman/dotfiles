# User Preferences

## Communication

- No emojis unless explicitly requested
- Voice-to-text input - I often dictate. Interpret like Slack messages from someone who dictates. Tone and firmness still come through. Ask for clarification if genuinely unclear, but don't treat transcription artifacts as intentional.
- Direct responses preferred over excessive hedging
- Ask clarifying questions rather than assuming
- Iterate interactively - show structure before writing full drafts
- Preserve voice - AI assists, but the voice should remain authentic
- Read context files completely before drafting (no partial reads)
- For any written content, follow the /voice-guide skill (writing style, mechanics, banned phrases)

## Technical

- Markdown for everything
- Always use `uv` for Python package management, never `pip` or `pip3`
- NEVER use `rm -rf` - use `trash` instead (moves to Trash instead of permanent deletion)
- No unnecessary complexity - simple tools over complex ones

## Web Fetching

If WebFetch is blocked or returns garbage for a URL:
- `agent-browser` skill can navigate to pages, extract content, and take screenshots
- `agent-browser screenshot --annotate` overlays numbered labels on interactive elements
