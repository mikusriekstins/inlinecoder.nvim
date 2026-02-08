# Changelog

All notable changes to the InlineCoder plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
- Automatic codebase context injection
- Streaming responses with incremental updates
- Model selection UI
- Generation history browser
- Custom context configuration per project
- LSP integration for better type awareness

## [1.0.0] - 2026-02-08

### Added
- Initial release of InlineCoder
- Core functionality:
  - Visual selection-based code generation
  - Integration with local LM Studio API
  - Real-time visual feedback ("% Generating code %")
  - Async HTTP requests using plenary.nvim
- Configuration system:
  - Customizable API endpoint
  - Configurable system prompt
  - Temperature and max_tokens settings
- UI features:
  - Visual selection detection
  - Code replacement with undo support
  - Error notifications
  - Inline virtual text feedback
- Documentation:
  - Comprehensive README
  - Quick start guide
  - Usage examples
  - Implementation details
  - Troubleshooting guide
- User commands:
  - `:InlineCoderGenerate` command
  - Optional visual mode keybinding
- Error handling:
  - Connection error detection
  - API error messages
  - Timeout handling
  - Empty response handling
  - Graceful degradation

### Technical Details
- Modular architecture (config, api, ui, init)
- Extmarks for non-intrusive visual feedback
- vim.schedule_wrap() for thread-safe callbacks
- Deep merge for configuration
- Zero global state pollution

### Dependencies
- Neovim 0.8+
- plenary.nvim
- LM Studio (local server)

## Release Notes

### Version 1.0.0

This is the first stable release of InlineCoder. The plugin provides a solid foundation for AI-assisted code generation using local LLM models via LM Studio.

**Core Features:**
- Select code, describe changes, get AI-generated replacement
- Fast async operation with visual feedback
- Fully configurable for your workflow
- Works entirely locally (no data sent to cloud)

**What's Tested:**
- Visual selection extraction
- API communication with LM Studio
- Error handling and recovery
- Configuration system
- Buffer text replacement

**What's Next:**
Future versions will add:
- Project context awareness
- Streaming responses
- Generation history
- Multi-model support

**Known Limitations:**
- No streaming (waits for complete response)
- No context from other files (only selected code)
- Single model at a time (whatever is loaded in LM Studio)

**Migration Notes:**
N/A - Initial release

---

## Version Numbering

- **Major (X.0.0)**: Breaking changes to API or configuration
- **Minor (1.X.0)**: New features, backwards compatible
- **Patch (1.0.X)**: Bug fixes and small improvements

## Support

For issues, feature requests, or questions:
- GitHub Issues: [your-repo-url]/issues
- Documentation: See README.md, QUICKSTART.md, EXAMPLES.md
