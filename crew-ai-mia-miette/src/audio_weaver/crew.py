import yaml
from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task
from pydantic import BaseModel
from audio_weaver.tools import shell_tool
import os

@CrewBase
class AudioWeaverCrew:
    """AudioWeaver crew"""

    agents_config = "config/agents.yaml"
    tasks_config = "config/tasks.yaml"
    inputs_config = "config/input.yaml"

    def __init__(self) -> None:
        with open(os.path.join(os.path.dirname(__file__), self.inputs_config)) as f:
            self.inputs = yaml.safe_load(f)

    @agent
    def mia_agent(self) -> Agent:
        return Agent(
            config=self.agents_config["mia"],  # type: ignore
            tools=[shell_tool],
            verbose=True,
        )

    @task
    def audio_generation_task(self) -> Task:
        return Task(
            config=self.tasks_config["audio_generation_task"],  # type: ignore
            agent=self.mia_agent(),
        )

    @crew
    def crew(self) -> Crew:
        """Creates the AudioWeaver crew"""
        return Crew(
            agents=[self.mia_agent()],
            tasks=[self.audio_generation_task()],
            process=Process.sequential,
            verbose=True,
        )
