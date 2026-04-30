# Clicker (working title)

Godot game project that began as a spontaneous prototype and is currently being reworked into a cleaner and more maintainable codebase.

The game is still in an early stage. It runs without major issues, while content and gameplay systems are actively being expanded as part of ongoing development.

## Current State

Right now the project is in a transition period:

- the original prototype code is still present,
- newer systems are being introduced alongside it,
- the main focus is on improving structure and long-term maintainability.

Because of that, the repository is less about a finished game loop and more about building a stronger foundation for future development.

## Rebuild Direction

The ongoing rebuild is mainly about moving the project:

- from global, tightly coupled state to more isolated runtime systems,
- from direct UI reads and manual synchronization to signal-driven updates,
- from loosely structured content definitions to resource-based databases,
- from larger prototype-style scripts to smaller systems with clearer responsibilities.

The goal is to make the project easier to extend, easier to reason about, and less fragile as new features are added.

## What Is Being Reworked

### From `Global` State To Runtime Managers

The older version of the project relies heavily on the `Global` autoload to hold gameplay state, UI state, timers, and content references in one place.

The newer direction moves active gameplay flow into dedicated runtime objects such as [`GameManager.gd`](/E:/GodotProjects/Clicker/scripts/model/logic/GameManager.gd), runtime instance classes, and focused logic controllers.

Why:

- to reduce coupling between systems,
- to avoid one large singleton becoming responsible for everything,
- to make combat, progression, and UI flow easier to separate.

### From Hardwired Content To Data-Driven Resources

Another part of the rebuild is the shift toward data stored in `Resource` files under `assets/resources/`.

[`GenericDatabase.gd`](/E:/GodotProjects/Clicker/scripts/model/databases/GenericDatabase.gd) is the base used by databases such as item, enemy, stage, skill, and character class databases. These databases load content by ID and provide a cleaner way to access game data.

### From Monolithic Combat Logic To Smaller Systems

Combat is being split into smaller parts such as:

- [`CombatController.gd`](/E:/GodotProjects/Clicker/scripts/model/logic/CombatController.gd)
- [`AttackController.gd`](/E:/GodotProjects/Clicker/scripts/model/logic/AttackController.gd)
- [`DamageResolver.gd`](/E:/GodotProjects/Clicker/scripts/model/logic/DamageResolver.gd)

Instead of handling timing, damage, combat state, and flow in one place, these responsibilities are being separated.

### From Manual UI Refreshes To Signals

The rebuild also moves UI updates toward Godot signals.

This can already be seen in newer systems such as stats, skills, inventory, and combat-related updates, where changes in runtime state emit events that UI nodes react to.

## Summary

This is still an early game project, but the main work currently happening in the repository is the transition from a quickly assembled prototype into a more deliberate Godot architecture.
