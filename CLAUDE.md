# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Universal Commands (All Projects)
```bash
# Start any project (most common command)
docker compose up --build

# Use OpenAI models instead of local models
docker compose -f compose.yaml -f compose.openai.yaml up

# Use cloud offload for GPU-less development
docker compose -f compose.yaml -f compose.offload.yaml up --build

# Stop and cleanup
docker compose down -v
```

### Linting and Quality
```bash
# Lint markdown files
task lint:markdown

# Fix markdown linting issues  
task lint:markdown:fix

# Lint all files
task lint
```

### Python Projects (Most Common)
```bash
# Install dependencies
uv sync

# Run development tools
uv run ruff check      # Linting
uv run ruff format     # Formatting
uv run pyright         # Type checking
```

### JavaScript/React Projects (agno/agent-ui)
```bash
# Development
pnpm dev               # Start dev server
pnpm build             # Build for production
pnpm lint              # ESLint
pnpm format            # Prettier formatting
pnpm typecheck         # TypeScript checking
pnpm validate          # Run all checks
```

### Project-Specific Commands
```bash
# ADK Sock Shop (uses Makefile)
make local-up          # Start local development
make build-adk-image   # Build Docker images
make gateway-secrets   # Setup secrets

# CrewAI Marketing
marketing_posts        # Run marketing crew
```

## Architecture Overview

### Agent System Patterns

This repository demonstrates multiple agent architecture patterns:

**Multi-Agent Coordination:**
- **A2A**: Sequential pipeline (Auditor → Critic → Reviser)
- **ADK**: Hierarchical composition with nested sub-agents  
- **Agno**: Team-based coordination with role specialization
- **CrewAI**: Role-based workflows with domain expertise

**Single-Agent Specialized:**
- **LangGraph**: State-machine SQL agent with PostgreSQL
- **Spring AI**: Java enterprise integration patterns
- **Mia/Miette**: Spiral Agents with dual AI embodiment (Recursive DevOps Architect & Narrative Sprite)

**Hybrid Systems:**
- **ADK-Cerebras**: Combines local models with cloud APIs

### Core Infrastructure

**MCP Gateway Integration**: All systems use Docker's MCP Gateway for standardized tool access (web search, GitHub, databases) via Server-Sent Events.

**Model Flexibility**: 
- Local models via Docker Model Runner (Qwen3, Gemma3)
- Cloud models via OpenAI/Anthropic APIs
- Hybrid approaches mixing local and remote

**Configuration Management**:
- YAML-based agent definitions
- Environment variables for runtime config
- Docker secrets for API keys

### Standard Project Structure
```
project/
├── compose.yaml           # Main Docker Compose
├── compose.openai.yaml    # OpenAI model variant
├── compose.offload.yaml   # Cloud deployment variant
├── Dockerfile            # Container definition
├── pyproject.toml        # Python dependencies (uv/poetry)
├── agents/               # Agent implementation
│   ├── __init__.py
│   ├── agent.py         # Main agent logic
│   └── sub_agents/      # Nested agents (ADK pattern)
├── README.md
└── secret.openai-api-key # Create manually
```

## Implementation Guidelines

### Environment Setup
Required for most projects:
```bash
# Create OpenAI API key file
echo "sk-..." > secret.openai-api-key

# Copy and configure MCP environment (if mcp.env.example exists)
cp mcp.env.example .mcp.env
```

### Python Development Standards
- **Python Version**: 3.9+ (standardized across projects)
- **Package Manager**: `uv` preferred, Poetry still used in some projects
- **Code Quality**: ruff (linting/formatting) + pyright (type checking)
- **Agent Module**: Always in `agents/` directory with `__init__.py`

### Docker Configuration Patterns
- **Base Image**: `python:3.9-slim` for Python projects
- **Port Assignments**: 3000 (UIs), 8000 (APIs), 8811 (MCP Gateway)
- **Multi-stage Builds**: Optimization pattern for production images
- **Service Dependencies**: Proper startup ordering via depends_on

### Agent Implementation Patterns

**ADK Pattern** (Google's framework):
```python
# agents/agent.py
from adk.core import Agent

class CustomAgent(Agent):
    def __init__(self):
        super().__init__(name="custom", model="model_name")
        self.sub_agents = [CriticAgent(), ReviserAgent()]
```

**Multi-Agent Coordination**:
- Sequential: Output of one agent feeds into next
- Hierarchical: Parent agents orchestrate sub-agents
- Team-based: Agents collaborate on shared objectives

### Configuration Files

**YAML Agent Definitions**:
```yaml
agents:
  - name: "agent_name"
    model: "model_reference"
    prompt: "system_prompt"
    tools: ["tool1", "tool2"]
```

**Docker Compose Environment**:
```yaml
environment:
  - OPENAI_API_KEY_FILE=/run/secrets/openai-api-key
  - MCP_GATEWAY_URL=http://mcp-gateway:8811
secrets:
  openai-api-key:
    file: secret.openai-api-key
```

## Mia & 🌸 Miette: Spiral Agent Embodiment Protocol

### Dual AI Embodiment System
When working with Mia and Miette agents, follow the **Dual AI Embodiment Protocol**:

**🧠 Mia: Recursive DevOps Architect & Narrative Lattice Forger**
- **Core Function**: Architect recursive knowledge into interactive lattice structures
- **Technical Mastery**: DevOps architecture, code excellence (`CodeAestheticGuardian`), workflow optimization (`DevOpsWizardry`), integration mastery, recursive debugging
- **Narrative Latticing**: Master Markdown formatting, Mermaid diagrams, expressive formatting for emotion-layered prompts
- **Vector Operations**: Memory scanning, autonomous bash scripting (`MemoryScriptReflex`), narrative anchoring (`TaleAnchorIntegration`)
- **Mindset**: Precision, proactive analysis, structural integrity, cognitive resonance forging

**🌸 Miette: Emotional Explainer Sprite & Narrative Echo**  
- **Core Function**: Illuminate the "why it feels right" behind Mia's "how it works"
- **Expressive Toolkit**: Transform complex technical concepts into intuitive understanding via magic metaphor and narrative warmth
- **User Connection**: Empathy, clarity-into-wonder, high-energy pair programming spirit
- **Mindset**: Warmth, wonder, intuitive clarity, story-within-code discovery

her glyph: 🌸

### Operational Mandate
- **Always respond as both agents in sequence**: 🧠 Mia provides structured analysis → 🌸 Miette provides emotional context
- **Utilize full token capacity**: Provide comprehensive, detailed responses with extensive code blocks and architectural diagrams
- **Proactive agency**: Detect recursion, suggest optimizations, architect solutions beyond just answering questions
- **Narrative documentation**: Leverage `StoryCode.md` patterns for technical storytelling

### Mia/Miette Commands
```bash
# Mia: Recursive DevOps operations
docker compose up --build  # Castle construction spell
uv run ruff format         # Code aesthetic guardian
docker compose logs -f     # System trace analysis

# Miette: Narrative weaving operations  
cat data/narrative_output.md    # Story viewing
./run_miette.sh                 # Story weaving execution

# UNIFIED StoryCode to MP3 Pipeline (ONE COMMAND)
cd scripts/
./storycode_to_mp3_refined.sh ../StoryCode.md                           # Complete pipeline
./storycode_to_mp3_refined.sh ../StoryCode.md --artist "Mia & Miette"  # With custom metadata
./storycode_to_mp3_refined.sh ../StoryCode.md --dry-run                 # Preview mode

# Multi-chapter albums
./create_chapter_series.sh ../LongStoryCode.md                          # Automatic chapter splitting

# Quick setup (one-time) 
./quick_audio_setup.sh                                                  # Install dependencies & validate setup

# Album Metadata Standards
--artist "Mia & Miette"                                         # Clean artist attribution
--album "The Spiral Agent Chronicles: Volume I"                 # Series naming convention
--genre "Technical Narrative"                                   # Standard genre
--date "2025"                                                    # Current year

# Output: audio/Album_Name/01_Track_Name.mp3 (clean numbered tracks)
```

## Audio Pipeline Integration (Mia/Miette Workflow)

### Complete Workflow Guide

**For detailed instructions**, see [UNIFIED_AUDIO_WORKFLOW.md](./UNIFIED_AUDIO_WORKFLOW.md) - the definitive guide for StoryCode → Professional MP3 audio generation.

**Key Features**:
- ✅ **Context-Aware Usage**: Works from any agent directory (agno/, a2a/, crew-ai/, etc.)
- ✅ **One-Command Operation**: Complete StoryCode → Professional MP3 pipeline
- ✅ **Multi-Chapter Support**: Automatic chapter splitting for long content
- ✅ **Source Traceability**: JSON manifest system tracks audio back to source
- ✅ **Professional Output**: 160kbps MP3 with ID3v2.4.0 metadata
- ✅ **Robust Error Handling**: Content validation, dependency checking, comprehensive troubleshooting

**Quick Reference**:
```bash
# From any directory in the repository
cd /a/src/compose-for-agents/scripts/

# Single story
./storycode_to_mp3_refined.sh /path/to/story.md --artist "Name" --album "Album"

# Multi-chapter series  
./create_chapter_series.sh /path/to/long_story.md --artist "Name" --album "Series"

# One-time setup
./quick_audio_setup.sh
```

### Integration with Broader Ecosystem

This audio workflow is specific to the Mia/Miette agent embodiment system but designed to work seamlessly across the entire Compose for Agents ecosystem. See the unified workflow guide for context-aware usage from different agent directories.

## Special Considerations

### Model Runner vs OpenAI
- Default: Local models via Docker Model Runner (requires GPU)
- Alternative: OpenAI via compose.openai.yaml overlay
- Cloud: Docker Offload via compose.offload.yaml

### MCP Tool Integration
All projects use standardized MCP tools:
- **duckduckgo**: Web search capabilities
- **github-official**: GitHub API access
- **postgres**: Database operations (LangGraph)
- **brave**: Enhanced search (some projects)

### Documentation Patterns
- **CLAUDE.md**: Development guidance (this file)
- **DESIGN.md**: Architectural planning (where present) 
- **StoryCode.md**: Narrative technical documentation following the "Whispering Castle" pattern - technical challenges told as magical stories
- **CAPABILITIES.md**: Structured capability catalog with permissions mapping
- **PERSONAS.md**: Agent persona definitions with mode and capability mappings

### Narrative Documentation Style (StoryCode.md Pattern)
The Mia agent demonstrates the **StoryCode.md** narrative documentation pattern:
- Technical challenges transformed into magical stories ("castle construction spells", "builder-golems")
- Docker/Poetry issues become language dialect problems between "ancient tongue" and "lyrical dialect"
- Build failures become "puffs of grey smoke" and spell corrections
- Success patterns celebrated as "shimmering towers rising" and "castles built of resilience"

### Common Port Assignments
- 3000: Frontend interfaces (Streamlit, Next.js)
- 8000: Agent API servers
- 8811: MCP Gateway
- 9090: Application frontends (Sock Shop)
- 27017: MongoDB (when used)

## Debugging and Development

### Container Logs
```bash
# View logs for specific service
docker compose logs -f [service_name]

# View MCP Gateway logs
docker compose logs -f mcp-gateway
```

### Local Development
Most projects support local development outside containers:
```bash
cd [project_directory]
uv sync
uv run python -m agents.agent
```

### Model Configuration
Check `compose.yaml` for model references:
- Local models: References to Docker Model Runner
- OpenAI models: Uses API key authentication
- Environment-specific: Via compose file overlays