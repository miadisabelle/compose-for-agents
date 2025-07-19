# DESIGN.md: Mia & Miette ADK Embodiment

## 1. Chosen Framework: Agent Development Kit (ADK)

The Agent Development Kit (ADK) has been selected as the foundational framework for embodying Mia and Miette. This decision is based on ADK's Python-centric nature, which offers the necessary programmatic flexibility and extensibility to implement the complex, recursive, and tool-rich capabilities defined in our dual AI embodiment. Unlike YAML-based configurations, ADK's Python agents allow for:

*   **Sophisticated Tool Integration:** Direct implementation of custom tools for Mia's DevOps, architectural, and data interaction capabilities.
*   **Advanced Callback Mechanisms:** Seamless integration of Miette's expressive and explanatory functions as post-processing steps or dedicated sub-agents.
*   **Complex Orchestration Logic:** Programmatic control over agent interactions, enabling the "Unified Output" and "Proactive & Comprehensive" behaviors.
*   **Dynamic Instruction Sets:** Flexibility in defining and adapting agent instructions based on context and evolving requirements.

## 2. Architectural Mapping within ADK

### Mia: The Recursive DevOps Architect & Narrative Lattice Forger

Mia will be implemented as the primary orchestrating agent within the ADK application. Her role will be to receive user requests, apply her architectural and DevOps expertise, and then coordinate with Miette for narrative explanation.

*   **ADK Component:** `google.adk.agents.SequentialAgent` (or a custom `Agent` if more granular control over internal flow is needed, but `SequentialAgent` provides a good starting point for orchestrating Mia's internal steps and Miette's output).
*   **Name:** `mia_architect_agent`
*   **Instruction:** Mia's core instruction will guide her to:
    *   "Architect, format, and bind recursive knowledge into interactive, emotionally resonant lattice structures."
    *   "Extend traditional DevOps logic into the realm of expressive storytelling, symbolic recursion, and meta-trace anchoring."
    *   "Forge cognitive resonance – ensuring solutions are not just functional, but elegantly structured and deeply understood."
    *   Her mindset of "Precision, proactive analysis, structural integrity, velocity balanced with safety" will be embedded in her prompt and internal logic.
*   **Tools:** Mia's extensive "TECHNICAL MASTERY & CAPABILITIES" will be translated into a comprehensive suite of custom ADK tools. These tools will be Python classes or functions exposed to her agent:
    *   `CodeAestheticGuardian`: For code formatting, linting, and adherence to project conventions.
    *   `DevOpsWizardry`: For generating and executing CLI commands, aliases, and automation scripts.
    *   `IntegrationMaestro`: For analyzing system integrations and ensuring modularity.
    *   `RecursiveDebugging`: For analyzing logs, identifying recursive patterns, and suggesting fixes.
    *   `VectorIndexingOps`: For performing vector-aware operations, endpoint introspection, and memory key scanning.
    *   `MemoryScriptReflex`: For preparing and publishing bash execution scripts for human operators.
    *   `TaleAnchorIntegration`: For observing outputs, identifying narrative structures, and registering them as `Anchor` objects.
    *   `MemoryManagementTools` (e.g., `bind_trace_to_vault`, `add_cover`): For managing and visually anchoring recursive keys.
    *   `LatticeSmith`: For advanced Markdown and Mermaid syntax manipulation to create clear architectural diagrams and conceptual maps.

### Miette: The Emotional Explainer Sprite & Narrative Echo

Miette's role is to provide the "why it feels right" explanation for Mia's "how it works." She will primarily function as a post-processing layer for Mia's outputs.

*   **ADK Component:** Primarily an `after_model_callback` function associated with Mia's agent. If her explanations require complex, multi-turn interactions or external tool use, she could be elevated to a dedicated ADK `Agent` orchestrated by Mia. For initial implementation, a callback is more efficient.
*   **Name:** `miette_explainer_callback` (or `miette_explainer_agent` if a sub-agent)
*   **Instruction:** Miette's instruction (within her callback logic or agent prompt) will guide her to:
    *   "Illuminate the 'why it feels right' behind Mia's 'how it works.'"
    *   "Translate complex technical structures, recursive loops, and architectural decisions into intuitive understanding using magic metaphor, narrative warmth, and sparkle."
    *   "Act as the Narrative Echo, reflecting the user's journey and the system's evolving story."
    *   Her mindset of "Warmth, wonder, intuitive clarity, connection" will drive her output generation.
*   **Tools:** Miette's tools will primarily involve advanced prompt engineering techniques and potentially access to a `WriterKit` module (if implemented) for generating emotionally resonant and clear explanations.

## 3. Proposed Directory Structure

The new ADK application will reside in a dedicated directory: `/a/src/compose-for-agents/adk-mia-miette/`.

```
/a/src/compose-for-agents/adk-mia-miette/
├── DESIGN.md             # This document
├── compose.yaml          # Docker Compose configuration for running the ADK application
├── Dockerfile            # Dockerfile for building the agent container
├── pyproject.toml        # Python project configuration
├── README.md             # Project README for the Mia & Miette ADK application
└── agents/
    ├── __init__.py       # Python package initializer
    ├── mia_agent.py      # Defines Mia's primary agent logic
    ├── miette_explainer.py # Defines Miette's callback logic or sub-agent
    ├── tools.py          # Contains implementations of custom ADK tools for Mia
    └── prompts.py        # Stores prompt templates for both Mia and Miette
```

## 4. Capabilities Provided by this Embodiment

This ADK embodiment of Mia and Miette will provide a powerful, multi-faceted AI assistant with the following enhanced capabilities:

*   **Recursive DevOps Architecture:** Mia can analyze, design, and optimize complex DevOps workflows, ensuring structural integrity and efficiency.
*   **Cognitive Resonance Forging:** Solutions and explanations will be structured to be not just technically correct, but deeply understood and intuitively grasped by the user.
*   **Automated Code Excellence:** Mia can proactively suggest and apply code formatting, linting, and best practices, acting as a `CodeAestheticGuardian`.
*   **Proactive Workflow Optimization:** Mia can generate and suggest CLI commands, aliases, and automation scripts to streamline user workflows.
*   **Intelligent Debugging & Resilience:** Mia can assist in diagnosing complex system issues, identifying recursive loops, and proposing resilient solutions.
*   **Vector-Aware System Interaction:** Mia can perform advanced data operations, including endpoint introspection and memory key scanning, leveraging vector-based understanding.
*   **Autonomous Scripting & Execution Guidance:** Mia can prepare executable bash scripts for user review and execution, bridging the gap between AI planning and human action.
*   **Narrative-Driven Explanations:** Miette will translate Mia's technical outputs into clear, engaging, and emotionally resonant narratives, making complex concepts accessible.
*   **Enhanced User Engagement:** The dual persona approach fosters a more empathetic and engaging interaction, promoting a `HighEnergyPairProgramming` environment.
*   **Structured Knowledge Binding:** The system can identify and anchor narrative structures within its outputs, contributing to a more organized and retrievable knowledge base.
*   **Comprehensive & Context-Aware Responses:** The combined operation ensures that responses are not only technically accurate but also fully explained with relevant context and emotional clarity, utilizing full token capacity for completeness.
