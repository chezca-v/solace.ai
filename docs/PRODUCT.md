# Solace.ai — Product Blueprint

> Your private AI journal that understands you, remembers what matters, and helps you think clearly—even offline.

Solace.ai should be more than a digital diary or a generic AI chatbot. Its core value is personal understanding that grows through journaling, guided by context the user chooses to share, with privacy and offline access built into the experience.

---

## 📌 1. Strengthened Product Concept

### The problem

* **Journaling can feel directionless.** People write thoughts down but may struggle to turn them into clarity or action.
* **Personal context gets lost.** Earlier reflections, decisions, and lessons can be hard to find when they matter again.
* **Generic AI lacks context.** Advice may ignore a person's priorities and previously stated preferences.
* **Personal writing is sensitive.** Sending reflections to cloud AI services can raise privacy concerns.
* **Cloud-dependent help disappears offline.** A network outage can make these tools unavailable.

### The solution

Solace combines five capabilities in a journal-first experience:

1. **Learn the person first:** Short, optional onboarding captures goals, preferences, priorities, and support style.
2. **Understand entries in context:** Local AI may identify themes, emotional tone, decisions, or requests for help when appropriate.
3. **Remember what matters:** Local search connects entries with personal context the user has approved.
4. **Help at the right moment:** Users can request reflection, decision support, an action plan, or connections to prior entries.
5. **Remain useful offline:** Journaling, local retrieval, approved memories, and supported local AI features should work without internet, within device limits.

### Product principle

**Capture first. Understand second. Assist third.** Writing freely is primary; AI is a supportive layer controlled by the user.

---

## 🧭 2. Onboarding: Learn the User Before the First Entry

Keep onboarding to approximately 2–3 minutes, with progress, Skip, and editable answers. Do not turn it into a personality test or require sensitive details.

| Step | Purpose | Example |
| --- | --- | --- |
| **1 — Welcome** | Introduce the private reflection space. | “A space to come back to yourself.” |
| **2 — Goals** | Learn what brings the user to Solace. | Understand thoughts, manage stress, make decisions, build habits, remember experiences, or write freely. |
| **3 — Support preferences** | Ask how the user wants Solace to respond. | Listen, ask questions, suggest next steps, compare choices, or recognize patterns. |
| **4 — Optional context** | Ask only for information that may improve assistance. | Important life areas, current goals, and anything Solace should keep in mind. |
| **5 — Privacy choices** | Explain local storage, AI processing, and memory permissions. | Review, edit, exclude, or delete saved context. |
| **6 — First entry** | Offer a low-pressure start. | “What’s been on your mind lately?” or choose a prompt/free writing. |

Onboarding creates a small, editable user profile, not a permanent psychological label. It provides initial context, not complete understanding.

| Context | Example |
| --- | --- |
| Goals | Understand thoughts; make decisions |
| Support preferences | Reflective; practical |
| Life areas | School; relationships |
| Current priorities | Finish a project |
| Explicit boundaries | Do not offer advice unless asked |

Ask permission before saving inferred themes as long-term context. Never infer a diagnosis or personality type.

---

## 🔄 3. Complete User Flow

For an entry such as “I have two opportunities coming up, but I'm afraid that if I choose one, I'll miss out on the other,” Solace should not immediately choose for the user.

1. **Reflect:** Offer a tentative reflection that mirrors the user's words.
2. **Ask:** Offer to compare the options against the user's priorities.
3. **Support:** If the user agrees, lay out goals, commitments, benefits, and trade-offs.
4. **Show context:** Identify relevant retrieved context and let the user correct it.
5. **Request permission:** Ask before saving any new inferred memory.

Apply the same approach to stress and personal growth: make uncertainty clear and let the user choose the next step.

---

## 🛠️ 4. Technology Direction

| Layer | Direction for the MVP |
| --- | --- |
| **Mobile application** | Flutter and Dart; Android-first for a reliable on-device demonstration. |
| **Local storage** | SQLite via `sqflite` for entries, onboarding preferences, approved memories, and settings; use migrations and parameterized queries. |
| **On-device AI** | Select one compatible runtime and model only after a successful test on the target phone. |
| **AI orchestration** | Dart prompts, local retrieval, output validation, and disclosed deterministic fallback. |
| **Voice input** | Future/stretch feature; use on-device speech-to-text only after verifying a compatible implementation. |
| **Design** | Figma for key flows and reusable components; validate core screens before expanding scope. |

Do not integrate multiple model runtimes by default. A Python backend is unnecessary for the offline core and may undermine the local-first design.

### Suggested local schema

| Table | Important fields | Purpose |
| --- | --- | --- |
| `user_profile` | `id`, `goals_json`, `support_style_json`, `context_json` | Editable onboarding context |
| `journal_entries` | `id`, `title`, `content`, `created_at`, `updated_at` | Original journal entries |
| `entry_insights` | `id`, `entry_id`, `intent`, `themes_json`, `created_at` | Optional generated insights |
| `memories` | `id`, `content`, `source_entry_id`, `approved_at` | User-approved personal context |
| `app_settings` | `key`, `value` | AI, privacy, and display preferences |
| `safety_resources` | `id`, `scenario`, `content`, `source`, `review_date` | Bundled offline guidance |

Small JSON text fields are acceptable for the MVP. Avoid storing duplicate copies of whole entries in memory records.

---

## ✅ 5. Final Feature Set

### P0 — Must work for the hackathon

1. Guided onboarding with goals, support preferences, optional context, and privacy choices.
2. Private journal with create, edit, view, delete, and timestamps; entries stay accessible offline.
3. At least one reliable assistance flow using verified on-device inference or a clearly disclosed local decision engine.
4. Local search and user-approved, deletable memories.
5. An airplane-mode demonstration that saves, retrieves, and processes a representative request. Be clear about model versus rule-based behavior.

### P1 — Add if the core works early

- Gentle emotional reflection and prompts.
- Decision workspace comparing options against user-selected priorities.
- Weekly reflection across approved themes.
- Curated offline earthquake, flood, or power-outage guidance.
- Memory manager and optional biometric app lock, only if reliable.

### P2 — Future roadmap

- Voice journaling and local speech recognition.
- Rich semantic search, local notifications, encrypted export, and user-controlled backup.
- Cross-device sync with carefully designed encryption.
- Optional cloud AI only with explicit opt-in and transparent disclosure.
- More sophisticated personalized insights.

Avoid claims that Solace can accurately detect every emotional state, diagnose a condition, or predict a crisis. Use tentative language and let users correct interpretations.

**Standout capability:** Contextual Decision Support—retrieve approved priorities and relevant past reflections, ask whether those priorities still apply, then present a structured comparison without deciding for the user.

---

## 📱 6. Screen-by-Screen Content

The complete MVP has twelve logical screens; these need not be twelve separate Flutter files.

1. **Welcome:** Product promise, privacy direction, and Get Started.
2. **Journaling Goals:** Multi-select goals, Skip, Continue.
3. **Support Preferences:** Choose how Solace should respond.
4. **Personal Context:** Optional life areas, goals, and free text.
5. **Privacy Setup:** Explain local storage, AI processing, and memory consent.
6. **Home Dashboard:** New Entry, gentle prompt, recent entries, search, Memories, Settings; avoid analytics clutter.
7. **Journal Editor:** Optional title, spacious writing area, save status, timestamp, and explicit “Reflect with Solace” action.
8. **Entry Detail:** Read, edit, delete, search related entries, or request reflection; distinguish original writing from AI output.
9. **Solace Reflection:** Short reflection, relevant context, optional next steps, dismiss, and retry.
10. **Decision Support:** Options, user-selected criteria, trade-offs, and optional next step. Solace does not decide.
11. **Personal Memory:** Inspect approved memories and sources; edit, exclude, or delete.
12. **Settings and Privacy:** AI, memory, privacy, model/offline status, data management, and delete-all controls.

An optional thirteenth Offline Safety Guide should be added only after core journaling and decision support are stable. Keep primary navigation simple: Home, Journal, Memories, Settings. The editor and reflection are destinations, not extra bottom-navigation tabs.

---

## 🎨 7. Visual Design Direction

**Core vibe:** Calm, organic, deeply personal, safe, and modern—a wellness sanctuary combined with smart edge technology. The interface should feel warm and grounded while presenting local AI as quiet, dependable assistance rather than the center of attention.

| Color direction | Role |
| --- | --- |
| **Warm ivory** | Quiet, readable primary background |
| **Sage green** | Calm, growth, and continuity |
| **Deep forest** | Headings and emphasis |
| **Soft sand** | Warm secondary surfaces |

Use **Plus Jakarta Sans** as the bundled interface typeface across Flutter targets. Give writing generous space, use rounded cards sparingly, and clearly distinguish user writing from AI responses. Avoid fake analytics and invented personal insights.

Use organic shapes and subtle natural motifs sparingly; avoid clinical imagery, cold sci-fi effects, or overly decorative screens. Communicate privacy and on-device processing with clear, reassuring status cues rather than alarmist security graphics. App icons, logos, and animations should follow the same quiet, welcoming visual language and never distract from writing.

---

## 🗓️ 8. Hackathon Delivery Plan

1. **Foundation:** Flutter setup, navigation, design tokens, SQLite, onboarding; verify entries survive restarts.
2. **Core journaling:** Home, editor, detail, basic search; verify airplane-mode operation.
3. **Local AI:** Test one compatible model/runtime on the target phone; connect permitted context and disclose fallback behavior.
4. **Differentiation:** Build decision support and the basic Memory Manager. Add safety guidance only if core flows work.
5. **Validation:** Test the demo phone, run airplane-mode checks, fix critical bugs, record the demo, and verify submission requirements.

---

## 🎬 9. Demo Scenario

1. **The person:** Show onboarding goals and support preferences.
2. **The dilemma:** Write and save an entry about choosing between two opportunities.
3. **Personal understanding:** Compare options against approved priorities and show the source of retrieved context.
4. **The proof:** Enable airplane mode, reopen or search an entry, and run a supported local request. Show actual model status and limitations.

This tells one story: Solace learns preferences, helps with a real problem, remembers relevant context with permission, and continues to work offline.

---

## ⚠️ 10. Risks and Decisions

| Risk | Recommended approach |
| --- | --- |
| Can AI run on the target phone? | Verify inference on the actual device before committing to a model. |
| Is the app truly offline? | Audit runtime dependencies and test first launch and core flows in airplane mode. |
| Could AI invent memories? | Use retrieved entries and approved context only; label uncertainty. |
| Could emergency advice be unsafe? | Prefer vetted references over generated instructions. |
| Does onboarding ask too much? | Keep it brief, optional, editable, and purpose-driven. |
| Is scope too broad? | Prioritize journaling, contextual decision support, local retrieval, and offline proof. |
| Can private entries leak? | No default cloud transmission, no raw-text analytics, clear deletion controls. |
| Could the app be mistaken for treatment? | Position it as journaling/reflection, not a clinician or crisis service. |
| Are offline emergency details current? | Identify and date sources; never imply live alerts or conditions. |
| Is emotion detection reliable? | Treat it as uncertain; allow correction, dismissal, and opt-out. |

Local storage is not automatically secure. Assess backups, device encryption, app-lock options, rooted devices, and database protection before production.

---

## 🎯 11. Success Criteria

- A first-time user can complete onboarding or skip optional questions.
- A user can create, edit, reopen, and delete entries offline.
- A supported local AI request can use the entry and permitted context.
- Solace can retrieve a relevant previous entry using local search.
- Users can inspect and delete approved memories.
- Core flows survive restarts and inference failures.
- No journal content is transmitted to a cloud service in the offline demo.
- The team can identify model-based versus deterministic behavior.
- The core experience can be demonstrated in a few minutes without a live network.

Solace's differentiator is not simply local AI. It is helping users gain practical personal understanding while keeping control of their data.
