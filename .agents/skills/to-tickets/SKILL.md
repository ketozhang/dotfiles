---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets (or one Epic with a Smart Checklist), each declaring its blocking edges, written in the user's Jira layout (Title, Summary, Description in Jira wiki markup, Smart Checklist).
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it.

The issue tracker is Jira with a Smart Checklist field. If no Jira tool access is available, output paste-ready blocks in chat (see step 5) instead of asking the user to configure a tracker.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a column, retype a shared symbol) whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket; green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets to the configured tracker

Publish the approved tickets. Every ticket uses the **ticket layout** below, whatever the tracker; only where it lands and the shape of the blocking edges change:

- **Jira without tool access** (default when no tracker is configured) → output each ticket in chat, in dependency order (blockers first), as four separate paste-ready code blocks: **Title**, **Summary**, **Description**, **Smart Checklist**. Use placeholders `<T1>`, `<T2>`, … for blocking edges and `<EPIC>` for the parent, so the user can substitute real issue keys.
- **Jira or another real tracker with tool access** → publish one issue per ticket in dependency order (blockers first) so blocking edges reference real identifiers. Use the platform's native blocking link where it has one and drop the "Blocked by" bullet in that case. If the source was an existing issue or Epic, make each ticket its child. Apply the `ready-for-agent` label unless instructed otherwise.
- **Local files** → write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order, containing the same four sections. One ticket per file, never a combined file.

If the user asks for a single **Epic** instead of separate tickets, write one ticket in the same layout covering the whole plan, and turn each approved slice into a Smart Checklist item whose detail line names the items that gate it.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means top to bottom.

Do NOT close or modify any parent issue.

<ticket-layout>

Follow this layout exactly. Description uses Jira Data Center wiki markup (`h2.`, `h3.`, `*` bullets), not Markdown. Do not add `h2. Summary` or `h2. Description` headings: those are Jira fields, not sections.

**Title**: a short imperative phrase.

**Summary**:

```
One standalone sentence, imperative, stating what this ticket delivers.

A short paragraph that sets the context and motivates why the work is needed.
```

**Description**:

```
h2. Design
A short paragraph summarizing the design components and decisions.

h3. <Component or decision A>
One to three sentences.

h3. <Component or decision B>
One to three sentences.

h3. Scope
In scope:
* ...
Out of scope:
* ...

h3. Implementation Details
* Parent: <EPIC>   (omit if there is no parent)
* Blocked by: <T1>, <T2>, or None (can start immediately)
* Constraints, ordering, open questions the implementer must settle.

h2. Acceptance Criteria
* Observable, verifiable outcome 1
* Observable, verifiable outcome 2
```

Add as many component/decision `h3.` sections as the design needs, but only for decisions already made or that constrain the work. Do not enumerate every dimension; leave the rest to the implementer's discretion.

**Smart Checklist**:

```
- Todo item 1
- Todo item 2
Details if needed. Keep it 1-3 lines long.
```

Checklist items are imperative todos. Detail lines are optional, sit directly under their item, and stay within 1–3 lines.

</ticket-layout>

In every form, avoid specific file paths or code snippets: they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.
