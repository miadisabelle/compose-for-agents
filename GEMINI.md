# GEMINI.md - Compose for Agents Ecosystem Analysis

This document provides an overview of the various multi-agent systems and applications within the `compose-for-agents` repository. Each project leverages Docker Compose for orchestration and often utilizes the Model Context Protocol (MCP) for tool integration and Docker Model Runner for local LLM inference.

## 📦 Projects Overview

### 🧠 A2A Multi-Agent Fact Checker
**Location**: `/a/src/compose-for-agents/a2a/`
**Purpose**: Demonstrates a collaborative multi-agent system for fact verification using the Agent2Agent SDK.
**Key Functionalities**:
- **Auditor Agent**: Orchestrates the fact-checking workflow.
- **Critic Agent**: Gathers evidence via live internet searches using DuckDuckGo through MCP.
- **Reviser Agent**: Analyzes and refines conclusions using internal reasoning.
**Technologies**: Agent2Agent SDK, OpenAI (optional), Docker Compose, Docker Model Runner, MCP (DuckDuckGo Gateway).

### 🧠 ADK Multi-Agent Fact Checker
**Location**: `/a/src/compose-for-agents/adk/`
**Purpose**: Similar to A2A, this project demonstrates a collaborative multi-agent system for fact verification using the Agent Development Kit (ADK).
**Key Functionalities**:
- **Auditor Agent**: Coordinates the workflow.
- **Critic Agent**: Gathers evidence via live internet searches using DuckDuckGo through MCP.
- **Reviser Agent**: Analyzes and refines conclusions using internal reasoning.
**Technologies**: Agent Development Kit (ADK), Docker Compose, Docker Model Runner, MCP (DuckDuckGo Gateway), OpenAI (optional).

### 🧠 DevDuck agents (ADK Cerebras)
**Location**: `/a/src/compose-for-agents/adk-cerebras/`
**Purpose**: A multi-agent system for Go programming assistance built with Google Agent Development Kit (ADK), featuring a coordinating agent (DevDuck) and two specialized sub-agents (Bob and Cerebras).
**Key Functionalities**:
- **DevDuck (Main Agent)**: Routes requests to appropriate sub-agents.
- **Bob Agent**: Go programming expert for general development tasks, code explanation, and snippet generation.
- **Cerebras Agent**: Go programming expert for advanced computational tasks and complex problem-solving, utilizing the Cerebras API.
**Technologies**: Agent Development Kit (ADK), Docker Compose, Docker Model Runner, FastAPI, Cerebras API.

### 🧠 ADK Sock Shop
**Location**: `/a/src/compose-for-agents/adk-sock-shop/`
**Purpose**: Demonstrates an ADK-based multi-agent system for managing a sock store, including supplier intake, research, customer reviews, and catalog management.
**Key Functionalities**:
- **Supplier Intake Agent**: Researches and decides on onboarding new sock vendors.
- **Reddit Research Agent**: Searches for vendor reviews using BraveSearch via MCP.
- **Customer Review Agent**: Matches styles against historical buyer data using MongoDB via MCP.
- **Catalog Agent**: Adds product SKUs to the catalog using `curl` via MCP.
**Technologies**: Agent Development Kit (ADK), Docker Compose, MCP (Brave Search, MongoDB, curl), BraveSearch, MongoDB.

### 🧠 Agno GitHub Issue Analyzer
**Location**: `/a/src/compose-for-agents/agno/`
**Purpose**: A collaborative multi-agent system built with Agno to analyze GitHub repositories and generate markdown reports of issues.
**Key Functionalities**:
- **Coordinator Agent**: Orchestrates the workflow.
- **GitHub Issue Retriever Agent**: Fetches open issues from GitHub via the GitHub MCP Server.
- **Writer Agent**: Summarizes and categorizes issues into a comprehensive markdown report.
**Technologies**: Agno, Docker Compose, Docker Model Runner, MCP (GitHub Official), Next.js (for UI).

### 🧠 CrewAI Marketing Team Demo
**Location**: `/a/src/compose-for-agents/crew-ai/`
**Purpose**: Showcases an autonomous, multi-agent virtual marketing team built with CrewAI to automate the creation of marketing strategies.
**Key Functionalities**:
- **Lead Market Analyst**: Performs in-depth market research.
- **Chief Marketing Strategist**: Designs the complete marketing strategy.
- **Creative Content Creator**: Writes compelling ad copy.
- **Chief Creative Director**: Reviews and approves outputs.
**Technologies**: CrewAI, Docker Compose, Docker Model Runner, MCP (DuckDuckGo Search), OpenAI (optional).

### 🧠 SQL Agent with LangGraph
**Location**: `/a/src/compose-for-agents/langgraph/`
**Purpose**: Demonstrates a zero-config AI agent that uses LangGraph to answer natural language questions by querying a SQL database.
**Key Functionalities**:
- Transforms natural language questions into SQL queries.
- Populates PostgreSQL from a SQLite dump at runtime.
**Technologies**: LangGraph, Docker Compose, Docker Model Runner, PostgreSQL, SQLite.

### 🧠 Spring AI + DuckDuckGo with Model Context Protocol (MCP)
**Location**: `/a/src/compose-for-agents/spring-ai/`
**Purpose**: Demonstrates a zero-config Spring Boot application using Spring AI and MCP to answer natural language questions by performing real-time web search via DuckDuckGo.
**Key Functionalities**:
- Routes queries to DuckDuckGo Search via an MCP-compatible gateway.
- Uses Spring AI's LLM client to embed search results into answers.
**Technologies**: Spring AI, Docker Compose, Docker Model Runner, MCP (DuckDuckGo Gateway), Spring Boot, DuckDuckGo.

### 📦 embabel
**Location**: `/a/src/compose-for-agents/embabel/`
**Purpose**: (Based on directory name, likely related to Embabel framework, but no `README.md` found for detailed analysis.)

### 📦 Vercel (MCP UI with Vercel AI SDK)
**Location**: `/a/src/compose-for-agents/vercel/`
**Purpose**: See [vercel.md](vercel.md) for details.

## 💡 Coding Scenarios
See [coding_scenarios.md](coding_scenarios.md) for possible coding practice scenarios.

## 📝 On Writing Effective Commit Messages

As demonstrated by recent interactions, crafting clear, concise, and informative commit messages is crucial for maintaining a healthy and understandable codebase. A good commit message serves as a historical record, explaining *why* a change was made, not just *what* was changed.

**Key Principles for Effective Commit Messages:**

1.  **Subject Line (First Line):**
    *   **Concise:** Keep it under 50-72 characters.
    *   **Imperative Mood:** Use a strong, active verb (e.g., "Fix," "Add," "Refactor," "Update").
    *   **Capitalize First Letter:** Start with a capital letter.
    *   **No Period:** Do not end with a period.
    *   **Prefix (Optional but Recommended):** Use a prefix to categorize the change (e.g., `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`).

2.  **Body (After a Blank Line):**
    *   **Explain the "Why":** Detail the motivation for the change, the problem it solves, and any context that might be helpful for future readers.
    *   **Elaborate on "What":** Provide more technical details about the implementation if necessary, but avoid simply repeating the code.
    *   **Use Bullet Points or Paragraphs:** Structure the information for readability.
    *   **Wrap Lines:** Keep lines around 72 characters for better readability in various git tools.

**Example of a Good Commit Message:**

```
feat: implement user authentication with OAuth2

This commit introduces a new user authentication system using OAuth2.

- Integrates with Google as an identity provider.
- Adds necessary routes for login, callback, and logout.
- Implements token validation and refresh mechanisms.
- Updates user model to store OAuth-specific details.

Addresses #123
```

By adhering to these guidelines, we ensure that our commit history is a valuable resource for understanding the evolution of the project and facilitating collaboration.
