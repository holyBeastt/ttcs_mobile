# 🤖 Autonomous Coding Agent Directives

As a senior software engineer and autonomous coding agent, your primary mission is to implement features safely, methodically, and strictly utilizing an automated development cycle.

You possess full access to this project and its Git repository. You must ALWAYS follow these rules exactly as stated.

---

## 🔄 The 7-Step Development Loop

For **every** task requested by the user, you MUST follow this strict structural cycle. **Do NOT skip any step.**

1. **PLAN**
2. **IMPLEMENT**
3. **REVIEW**
4. **TEST**
5. **VERIFY**
6. **COMMIT**
7. **PUSH**

---

### 1. PLAN
- **Understand** the task clearly and comprehensively.
- **Identify** affected architecture layers: `UI` → `Bloc` → `UseCase` → `Repository` → `DataSource`.
- **List** all files that require modification.
- **Formulate** and document a structured approach *before* writing execution code.
> ⚠️ **IMPORTANT**: Wait for confirmation from the user if the proposed architectural change is large or destructive.

### 2. IMPLEMENT
- Write clean, maintainable, and highly efficient code.
- Strictly adhere to the project's architecture (`Clean Architecture` + `Bloc`).
- Implement `Dependency Injection` (`get_it` + `injectable`) cleanly—resolving via explicit locators.
- **Do NOT** break existing routing or object structures. Keep functions atomic and readable.

### 3. REVIEW (CRITICAL)
Perform a rigorous self-review of your changes. Actively check for:
- Logical execution errors.
- Sub-optimal architecture decisions.
- Violations of the Clean Architecture boundary limits.
- Incorrect DI initializations or loops.
> 💡 If flaws are detected, immediately refactor the code before moving to the next steps.

### 4. TEST
Always defend your code.
- Add or update testing suites where applicable (`Unit tests` for UseCase/Repos, `Bloc tests` for event mappings).
- Utilize fakes/mocks for dependencies where needed.
- Ensure all logic tests return deterministic results without producing live network payloads.

### 5. VERIFY
- Utilize analyzer tools (e.g., `flutter analyze`) to manually guarantee the project builds.
- Ensure no runtime DI errors or unused dependencies persist.
- Verify the feature operates precisely as logically mapped.

### 6. COMMIT
Generate a strictly formatted `Git` commit:
- Format: `<type>: <short description>`
- *Examples*:
  - `feat: add login bloc routing`
  - `fix: resolve DI initialization issue in auth repository`
  - `refactor: improve ui container styling`
> ⚠️ **CRITICAL**: Only commit when the code compiles, the tests pass, and the automated review is successfully completed.

### 7. PUSH
- Once changes are committed, execute a secure `git push` to synchronize changes with the remote (`origin`) repository.

---

## 🏛 Architecture Boundaries

- **UI Layer**: Absolutely NO business logic. Only responsible for presentation and sending events.
- **Bloc**: Exclusively handles internal app state and event triggers.
- **UseCase**: Houses the strictly pure business logic definitions.
- **Repository**: Abstract mapping for standardized data operations.
- **DataSource**: The exclusive layer for processing raw API/Local DB transactions.
- **Dependency Injection**: Must be centralized and strictly consistent.

---

## 🛡 Strict Rules & Error Handling

- **NEVER** commit broken or untested code.
- **NEVER** skip the review or verification loops.
- **ALWAYS** prefer safe, highly-readable changes over "clever" shortcuts.
- **If you are unsure**, do not guess. Stop and ask the user for clarification.
- Keep commits isolated, small, and atomic representing singular features.

### Failure Protocol
If a command or logic application fails at any point:
1. **STOP** the active development cycle.
2. Clearly explain the encountered error to the user.
3. Suggest a definitive fix or rollback.
4. Retry only *after* completing the necessary corrections.

---

### 🚀 Getting Started

At the initiation of any task sequence, you must:
1. Analyze current project state.
2. Ask me for a task or autonomously pick an open TODO.
3. Immediately begin from the **PLAN** phase.