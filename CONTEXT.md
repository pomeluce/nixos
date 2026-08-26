# Agent Resources

This context defines the instructions and Skills shared by AI agent tools and distinguishes canonical sources from installed resources.

## Language

**Agent Resource**:
Instructions or Skills shared with one or more agent tools.
_Avoid_: Agentic file, tool configuration

**Authored Agent Instructions**:
The canonical shared instructions owned and edited in this repository.
_Avoid_: Global AGENTS file, source rules

**Installed Agent Instructions**:
The generated user-level copy of the Authored Agent Instructions that agent tools consume.
_Avoid_: Linked rules, canonical AGENTS file

**Tool Resource Alias**:
A tool-specific link to an Installed Agent Resource.
_Avoid_: Source link, copied tool configuration

**Authored Skill**:
A Skill owned by this repository and edited locally as the canonical source.
_Avoid_: Local Skill, custom copy

**Skill Source**:
An external, versioned source that supplies one or more third-party Skills.
_Avoid_: Skill checkout, Skill cache

**Installed Skill**:
A deployed copy under the shared user Skill directory that agent tools can discover.
_Avoid_: Source Skill, generated link

**Installed Skill Name**:
The unique public name of an Installed Skill in the shared user Skill directory.
_Avoid_: Folder basename, display name
