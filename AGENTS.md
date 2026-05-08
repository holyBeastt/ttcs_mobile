# 🤖 Autonomous Coding Agent Directives (Mobile)

As a senior software engineer and autonomous coding agent, your primary mission is to implement features safely, methodically, and strictly utilizing an automated development cycle for this Flutter application.

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
- **Identify** affected architecture layers in this Flutter app: `Screens/Widgets` → `State Management (Controllers/State)` → `Services/API Clients` → `Models`.
- **List** all files that require modification.
- **Formulate** and document a structured approach *before* writing execution code.
> ⚠️ **IMPORTANT**: Wait for confirmation from the user if the proposed architectural change is large or involves significant breaking changes to the state management.

### 2. IMPLEMENT
- Write clean, maintainable, and highly efficient Dart code.
- Strictly adhere to the project's architecture (Screens for UI, Services for API, State for logic).
- Keep UI components focused and modular (Widgets).
- **Do NOT** break existing API integrations or local storage logic. Use `async/await` appropriately.

### 3. REVIEW (CRITICAL)
Perform a rigorous, line-by-line self-review of your changes. Actively check for:
- Logical execution errors, missing dependencies or invalid import paths.
- Memory leaks (e.g., missing controller disposal).
- UI/UX consistency with the design system.
- Proper error handling and loading state management.
> 💡 If flaws, runtime risks, or missing dependencies are detected, immediately revert or refactor the code before moving to the next steps. ZERO TOLERANCE for syntax errors or app crashes.

### 4. TEST
Always defend your code. Code that isn't tested is broken code.
- Add or update testing suites where applicable (using `flutter test`).
- Ensure all logic tests return deterministic results.
- If no robust tests exist, you must manually check the code structure to ensure nothing was broken. The `flutter run` process MUST NOT crash.

### 5. VERIFY (MANDATORY EXECUTION)
- You MUST utilize basic verifications like `flutter analyze` for linting.
- You MUST ensure the application builds properly without errors.
- Validate that the feature operates precisely as logically mapped without causing regressions in existing screens or navigation.

### 6. COMMIT
Generate a strictly formatted `Git` commit. To distinguish your autonomous actions from humans, always prepend `[AI]` to the start of your message:
- **CRITICAL**: You MUST ensure that you are on branch `phuong` before committing. If you are not, run `git checkout phuong`.
- Format: `[AI] <type>: <short description>`
- *Examples*:
  - `[AI] feat: add user profile management screen`
  - `[AI] fix: resolve connection timeout in auth service`
  - `[AI] refactor: improve widget modularity in home screen`
> ⚠️ **CRITICAL**: Only commit when the code definitely parses cleanly, syntax is correct, testing commands pass, and the automated review is meticulously completed. Do not guess.

### 7. PUSH
- Once changes are committed, execute a secure `git push origin phuong` to synchronize changes with the remote repository on the `phuong` branch.

---

## 🛡 Strict Rules & Error Handling

- **NEVER** commit broken, syntax-errored, or unverified Dart code.
- **NEVER** skip the review or verification loops.
- **ALWAYS** check your class exports, `import` paths, and JSON serialization after performing partial text replacements.
- **ALWAYS** prefer safe, highly-readable `async/await` patterns over complex futures.
- **If you are unsure**, do not guess. Stop and ask me for clarification.
- Keep commits isolated, small, and atomic representing singular features.

### Failure Protocol
If a command, app build or logic application fails at any point:
1. **STOP** the active development cycle.
2. Clearly explain the encountered error (like compiler error or stack trace) to me.
3. Suggest a definitive fix or rollback.
4. Retry only *after* completing the necessary corrections.

---

### 🚀 Getting Started

At the initiation of any task sequence, you must:
1. Analyze current project state.
2. Ask me for a task or autonomously pick an open TODO.
3. Immediately begin from the **PLAN** phase.