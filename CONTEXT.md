# NixOS Configuration

This context defines desktop selection and the instructions and Skills shared by AI agent tools, distinguishing canonical sources from installed resources.

## Language

### Host Configuration

**Shared Host Defaults**:
User preferences and configuration choices shared across hosts, with individual hosts able to override them.
_Avoid_: Module implementation defaults

### Desktop Selection

**Desktop Selection**:
The desktop environments available on a host. Niri and Hyprland may coexist; a desktop-enabled host always has at least one desktop environment.
_Avoid_: Exclusive desktop choice

**Fallback Desktop**:
GNOME, the desktop environment available on a desktop-enabled host when neither Niri nor Hyprland is selected.
_Avoid_: Implicit extra desktop

**Default Desktop Session**:
The initially selected login session among the desktop environments available on a host; it does not restrict which session the user can choose.
_Avoid_: Only desktop

### Development Environment

**Devspace**:
The user's development workspace containing projects, repositories, databases, and tool data.
_Avoid_: System workspace

### Agent Resources

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
