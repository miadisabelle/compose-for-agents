# Coding Scenarios for Practice

Here are 3 coding scenarios you could practice within this repository:

### 1. Enhance the `ADK Multi-Agent Fact Checker` with a new search tool:
*   **Task**: Integrate an additional web search tool (e.g., Google Search, Bing Search) into the `Critic` agent within the `adk` project.
*   **Details**: This would involve modifying the agent's tool definitions and potentially the MCP gateway configuration to allow the `Critic` agent to use multiple search providers for gathering evidence.

### 2. Implement a new agent in the `Agno GitHub Issue Analyzer` for sentiment analysis:
*   **Task**: Add a new "Sentiment Analyzer" agent to the `agno` project.
*   **Details**: This new agent would take the retrieved GitHub issue descriptions, perform sentiment analysis (e.g., positive, negative, neutral), and then pass this information to the `Writer` agent for inclusion in the final report. This involves creating a new agent definition and integrating it into the existing Agno workflow.

### 3. Add a new data source to the `SQL Agent with LangGraph`:
*   **Task**: Modify the `langgraph` project to allow the SQL agent to query an additional data source.
*   **Details**: This could involve enabling the agent to connect to and query data from a CSV file, another SQLite database, or even a simple in-memory dataset, in addition to the existing `Chinook.db`. This would require updating the data loading mechanism and potentially the agent's query generation logic.
