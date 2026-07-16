# Universal Academic Project Report Generator — Master Prompt

This is a reusable prompt template reverse-engineered from a complete B.E. project report
(front matter → 8 chapters → 6 appendices, with all diagrams and tables). Fill in the
placeholders in `{{double braces}}` and paste the entire "MASTER PROMPT" section into any
AI tool (or use it yourself as a writing checklist) to generate a same-structure report for a
different project.

---

## HOW TO USE
1. Replace every `{{PLACEHOLDER}}` with your project's actual details.
2. Paste the "MASTER PROMPT" block (everything after the formatting spec) into Claude/ChatGPT/etc.
3. Generate chapter-by-chapter if the AI truncates — the structure below is built to be requested
   in chunks (Front Matter → Ch1–2 → Ch3–4 → Ch5–6 → Ch7–8 → Appendices) without losing consistency.

---

## DOCUMENT FORMATTING SPECIFICATION
(Give this to whatever tool typesets the final .docx)

| Element | Spec |
|---|---|
| Font family | Times New Roman (entire document, including tables/captions) |
| Main heading (Chapter titles, e.g. "CHAPTER 4 SYSTEM DESIGN") | 16 pt, Bold, Centered |
| Sub-heading (Section/subsection titles, e.g. "4.1 System Architecture Diagram") | 14 pt, Bold, Left-aligned |
| Body text | 12 pt, Regular |
| Line spacing | 1.5 |
| Paragraph alignment | Justified |
| Page numbers — front matter (Acknowledgement, Abstract, ToC, List of Figures/Tables) | Lowercase Roman numerals (ii, iii, iv…) |
| Page numbers — Chapters 1 onward through Appendices | Arabic numerals, continuous (1, 2, 3 … through appendices) |
| Running header on body pages | `Salariann    Dept. of Information Technology, 4062` |
| Figure caption style | "Figure X.Y: Description" — centered below the figure |
| Table caption style | "Table X.Y: Description" — centered above the table |
| Numbering | Figures/Tables numbered per-chapter (4.1, 4.2 … reset each chapter) |
| Margins | 1 inch all sides (1.5 inch left if binding) |
| Code listings | Monospace font, numbered lines, captioned "Listing X.Y: Description" |

---

## MASTER PROMPT (paste this into the AI, with placeholders filled)

```
Generate a complete academic Bachelor of Engineering project report titled
"Salariann - IT Job Market Platform" for the Information Technology department, submitted to
Savitribai Phule Pune University, by students Bhavesh Tayade, under the
guidance of Priyanka Kakde, at BVCOERI, Nashik,
academic year 2025-2026.

Project domain: An IT Job Market Platform for India featuring job aggregation, company insights, user contributions, and a unique Salariann Suitability Score based on city-specific cost-of-living metrics.
Core technologies involved: Flutter (Material 3), Node.js (Express), PostgreSQL, Supabase (Auth/Storage/Realtime), Docker
Core algorithms/models involved: Suitability Score Calculation Engine (calculates net monthly income against city-specific living expenses to generate a traffic-light viability score)

Follow this EXACT structure, depth, and proportion of content. Every chapter listed
must be present. Every diagram and table listed must be generated (as a described
figure suitable for redrawing in draw.io/Mermaid/TikZ, or as a literal Markdown
table). Do not skip the appendices.

=== FRONT MATTER ===
1. Title Page: project title, "SUBMITTED TO Savitribai Phule Pune University... IN PARTIAL
   FULFILLMENT...", degree name, student names + exam numbers, guide name,
   department, college, university, year.
2. Certificate Page: formal certification paragraph naming all students, guide,
   HOD, and Principal, with signature blocks.
3. Acknowledgement: one page thanking guide, HOD, Principal, faculty, and family —
   written in first person plural, sincere and specific (not generic filler).
4. Abstract: ~300–400 words, single paragraph or two, covering: (a) the problem
   domain and why existing approaches fall short, (b) the proposed system's core
   technical approach in 2-3 sentences naming the actual algorithms/frameworks
   used, (c) the system's architecture in one sentence (how many modules/layers),
   (d) 3-5 QUANTITATIVE result claims with specific numbers (precision/recall/F1/
   AUC/accuracy/latency/improvement %) — these numbers must reappear consistently
   in Chapter 7, (e) a closing "Keywords:" line with 8-10 comma-separated terms.
5. Table of Contents: full chapter + subsection listing with page numbers,
   mirroring the chapter list below.
6. List of Figures: one entry per diagram generated in Chapters 3, 4, and 7.
7. List of Tables: one entry per table generated across Chapters 2, 4, 5, 7, and
   Appendix D.

=== CHAPTER 1: INTRODUCTION ===
1.1 Background — 1-2 paragraphs framing the real-world problem and what the
    proposed system does about it, citing 2-3 inline pseudo-citations like [cite: N].
1.2 Problem Statement — numbered list of 3-5 concrete limitations of the status
    quo that this project directly addresses (each tied to a feature built later).
1.3 Objectives — numbered list of 5-6 objectives, each phrased as "To [verb] ...",
    each one mapping 1:1 to a system module described in Chapter 3.
1.4 Scope of the Project — bulleted list of 4-5 capability boundaries (what the
    system does and for whom).
1.5 Organization of the Report — one bullet per chapter (Ch.2 through Ch.8),
    one sentence summarizing each.

=== CHAPTER 2: LITERATURE SURVEY ===
2.1 Overview — paragraph framing how the field has evolved (rule-based →
    data-driven → AI-driven), ending with a sentence on what gap this chapter
    will expose.
2.2–2.4 — Three to four subsections, each covering an EXISTING category of
    solution relevant to IT Job Market & Career Discovery (e.g., "Traditional/Manual Methods",
    "Single-Purpose Tools", "ML/Statistical Approaches", "AI/LLM-based Approaches").
    Each subsection has 1-2 further nested subsections describing specific
    techniques, named real algorithms/tools, and stating strengths + concrete
    weaknesses.
2.5 Comparative Analysis — ONE TABLE (see Table Spec A below) comparing
    4-5 existing approaches against "Salariann - IT Job Market Platform (Proposed)" on columns:
    Approach | Method | Strengths | Weaknesses | [Domain-specific capability 1:
    Yes/No/Partial] | [Domain-specific capability 2: Yes/No/Partial]
2.6 Research Gap — numbered list of 3-4 gaps, each phrased as a missing
    capability, ending with a paragraph connecting them directly to the proposed
    system's value proposition.

  TABLE SPEC A (Comparative Analysis):
  | Approach | Method | Strengths | Weaknesses | Personalized/Adaptive? | End-to-End Integration? |

=== CHAPTER 3: PROPOSED SYSTEM ===
3.1 System Overview — paragraph + ONE HIGH-LEVEL ARCHITECTURE DIAGRAM
    (Figure 3.1) showing 4 boxes (Frontend / Backend API / AI-ML Services /
    Database) with labeled bidirectional arrows describing the data exchanged
    at each boundary (e.g., "User Input & Goals", "Generated Output", "Data
    Payload", "Inferences", "CRUD Ops").
3.2 System Components — one numbered subsection PER MODULE (3-4 modules
    matching the objectives in 1.3). For each module: 1 paragraph description +
    a bulleted list of 2-4 specific responsibilities. At least one module must
    include a labeled MATHEMATICAL FORMULA relevant to the domain (e.g., a
    similarity/scoring/loss function), presented in LaTeX-style notation with
    each variable explained in prose immediately after.
3.3 AI Integration and Data Flow — numbered list of 2-3 named mechanisms
    (e.g., "Automated Alignment", "Context-Aware Prompting", "Iterative
    Optimization") each with a one-paragraph explanation of how AI/ML is woven
    through the pipeline rather than bolted on.
3.4 Detailed Workflow of the System — numbered, chronological step list (7-9
    steps) tracing one full user journey end-to-end through every module named
    in 3.2.

=== CHAPTER 4: SYSTEM DESIGN ===
4.1 System Architecture Diagram — ONE DETAILED diagram (Figure 4.1), more
    granular than 3.1, naming actual frameworks in each box (e.g., specific
    frontend framework / API gateway tech / AI engine / DB tech / external APIs
    / auth service) with labeled arrows for protocols (REST/JSON, internal API,
    prompts/tokens, query/store).
4.2 Data Flow Diagram
    4.2.1 Level 0 — Context Diagram (Figure 4.2): single process bubble +
          2 external entities (User, External APIs) + labeled flows in both
          directions.
    4.2.2 Level 1 — Detailed DFD (Figure 4.3): break the single bubble into
          4-5 numbered processes (1.0, 2.0, 3.0...) + 2 data stores (D1, D2),
          showing how raw input becomes final output step by step.
4.3 UML Diagrams
    4.3.1 Use Case Diagram (Figure 4.4): system boundary box, 2 actors
          (primary human actor + external AI/system actor), 5 use-case ovals
          matching the objectives.
    4.3.2 Class Diagram (Figure 4.5 + Table 4.1): 5-6 classes matching the
          modules in 3.2, each with 3-4 attributes and 3 methods, plus
          relationship lines (uses/has-a) between them. ALSO produce
          Table 4.1 "Key Classes and Their Responsibilities" with columns
          Class | Attributes | Methods.
    4.3.3 Sequence Diagram (Figure 4.6): numbered message list (7-9 steps)
          across 3-4 lifelines representing the same workflow as 3.4 but at
          the object/method-call level.
    4.3.4 Activity Diagram (Figure 4.7): swimlane-free activity flow including
          at least one decision diamond with Yes/No branches and at least one
          decision diamond with 3 labeled options (Option A/B/C), ending in a
          merge before "End Session."
4.4 Database and Storage Design — Table 4.2 "Database Schema and Storage
    Strategy" with columns Collection/Table | Data Paradigm | Description & Key
    Fields (4-5 rows), PLUS Figure 4.8: an entity diagram showing each
    collection's key fields and 1:1 / 1:N relationship lines between them.

=== CHAPTER 5: TECHNOLOGY AND TOOLS OVERVIEW ===
5.1 Programming Languages — one subsection per language used, explaining WHY
    it was chosen for its specific layer.
5.2 [Domain] ML/AI Libraries — Table 5.1 "AI/ML Libraries and APIs Used" with
    columns Library/API | Version | Purpose (one row per major library/API,
    5-7 rows, each Purpose 1-2 sentences explaining its exact role in the
    pipeline).
5.3 Backend Framework — subsection(s) per backend technology/service.
5.4 Frontend Framework — subsection covering UI framework + state management +
    visualization libraries.
5.5 Database and Cloud Services — subsections for DB choice + auth service +
    hosting, each justified.
5.6 Development and Deployment Tools — Table 5.2 "Development Tools" with
    columns Tool | Purpose (5-6 rows: version control, IDE, API testing,
    containerization, notebook/experimentation, documentation tool).
5.7 Hardware Requirements — Table 5.3 with columns Component | Minimum
    Specification & Rationale (Processor, RAM, Storage, Network — 4 rows).
5.8 Software Requirements — Table 5.4 with columns Software | Version/Notes
    (OS, language runtime, backend runtime, database, browser — 5 rows).

=== CHAPTER 6: SYSTEM IMPLEMENTATION ===
6.1 Module-wise Implementation — intro paragraph on the implementation
    philosophy (modularity, async, scalability).
6.2–6.N — One subsection PER CORE MODULE (3-4 modules), each containing:
    (a) 1-2 paragraphs explaining the technical approach,
    (b) ONE CODE LISTING (15-40 lines, real working-style code in the
        project's actual language) with inline comments explaining non-obvious
        choices, captioned "Listing X.Y: [Module] using [Key Library]".
6.(N+1) System Workflow Algorithm — ONE formal pseudocode block ("Algorithm 1")
    with Require/Ensure preamble, numbered steps, at least one IF/ELSE branch
    and one WHILE loop representing an iterative refinement process, ending
    with a "return" statement.
6.(N+2) [Final service, e.g. Optimization/Export Service] — paragraph +
    one final code listing demonstrating the iterative refinement loop named
    in the algorithm above.

=== CHAPTER 7: RESULT AND PERFORMANCE ANALYSIS ===
7.1 Experimental Setup
    7.1.1 Benchmark Datasets — Table 7.1 with columns Dataset | Size | Source |
          Purpose (4 rows covering each major data type the system consumes).
    7.1.2 System Latency Baseline — Table 7.2 with columns Module | Avg.
          Latency (ms) | P95 Latency (ms) | Processing Type (CPU/Local vs
          API/Cloud) — 3-4 rows.
    7.1.3 Model Configuration & Hyperparameters — Table 7.3 with columns
          Hyperparameter | Value/Rationale (6-8 rows covering every tunable
          parameter mentioned in Ch.6).
7.2 Results — one numbered subsection per evaluated capability, EACH with its
    own table, and each table's numbers must match the Abstract's claims:
    7.2.1 [Primary NLP/extraction metric] — Table 7.4: Method | Precision |
          Recall | F1-Score, comparing 2-3 baselines against "Proposed".
    7.2.2 [Recommendation/ranking metric, if applicable] — Table 7.5:
          Algorithm | Precision@K | Recall@K | AUC, comparing baselines.
    7.2.3 [End-user outcome metric, e.g. before/after improvement] — Table 7.6:
          Category/Role | Avg. Initial Score | Avg. Optimized Score | Absolute
          Gain.
    7.2.4 [Structural/reliability metric for any generative AI output] —
          Table 7.7: Configuration | Valid Output (1st Try) | Valid Output
          (w/ Retries) | Avg. [unit] Generated.
    7.2.5 Training Convergence — Figure 7.1: described line chart (X-axis:
          training epochs/iterations, Y-axis: the key metric) with a written
          description of the curve's shape (starting value, inflection point,
          plateau value, and confirmation of no overfitting via a shaded
          validation band).
    7.2.6 System Resilience — Table 7.8: Scenario | Normal Operation | Failure
          Condition | System Response (a "circuit breaker"/graceful-degradation
          story for 2-3 critical external dependencies).
7.3 Performance Analysis Summary — numbered list (5 items) restating each
    headline metric in one sentence each, tying back to the objectives in 1.3.

=== CHAPTER 8: CONCLUSION AND FUTURE WORK ===
8.1 Summary of Contributions — numbered list (4-5 items), each a bolded
    contribution title + 1 paragraph, mapping 1:1 to the modules in Ch.3 and Ch.6.
8.2 Key Findings — bulleted list (4 items) each restating a Ch.7 metric with
    one sentence of interpretation (why it matters, not just what it is).
8.3 Limitations — bulleted list (3 items): at least one external-dependency
    risk, one data-freshness/staleness risk, one edge-case/cold-start-style risk.
8.4 Future Work — numbered list (5 items), each a named future direction
    (e.g., real-time data integration, open-source/self-hosted model migration,
    a richer interaction modality, a companion tool/extension, a
    community/network-effect feature), each 1-2 sentences.

=== REFERENCES ===
Numbered bibliography, IEEE style ([1], [2], ...), 12-14 entries mixing:
academic papers (with arXiv IDs where relevant for any AI/ML techniques used),
official documentation/whitepapers for every major framework/library named in
Ch.5, and any algorithm/technique original papers referenced in Ch.3 or Ch.6.

=== APPENDICES ===
Appendix A — System API Documentation: 2 REST endpoints, each with URL, HTTP
  verb, Description, and full Request/Response JSON payload examples using
  realistic field names from the project domain.
Appendix B — Database Schema Definitions: actual schema code (Mongoose/SQL DDL/
  Pydantic — match the DB choice in 5.5) for the 2 most important
  collections/tables, fully typed with required/default/enum constraints.
Appendix C — Prompt Engineering Templates (include ONLY if the project uses an
  LLM): the exact system prompt(s) used for generative tasks, with INSTRUCTIONS
  and a strict OUTPUT FORMAT/JSON schema block.
Appendix D — User Evaluation and Survey Instrument: the standard 10-item System
  Usability Scale (SUS) questionnaire as Table D.1, plus a one-line scoring
  note giving the beta-test average score and its qualitative grade.
Appendix E — Sample Generated Artifact: one full, realistic raw output example
  (JSON/code/document) that the system would produce for a typical use case,
  unedited and fully structured.
Appendix F — Environment Configuration Manifests: real dependency manifest
  files (requirements.txt / package.json / pom.xml — match the stack) with
  pinned version numbers, grouped by purpose with comment headers.

=== GLOBAL RULES ===
- Every chapter/section header must use the exact numbering scheme shown above
  (N.N, N.N.N).
- Every table and figure must be captioned and numbered per-chapter.
- All quantitative results introduced in the Abstract MUST reappear, identical,
  in Chapter 7.
- Tone: formal, third-person/passive academic register; no first-person except
  in the Acknowledgement.
- Do not use placeholder text like "Lorem ipsum" — every number, table value,
  and code snippet must be internally consistent and plausible for the stated
  domain.
- Apply the Document Formatting Specification (Times New Roman; 16pt chapter
  headings; 14pt sub-headings; 12pt body; 1.5 line spacing; justified) to the
  final typeset output.
```

---

## PLACEHOLDER CHECKLIST
Fill these in before pasting the Master Prompt anywhere:

- `Salariann - IT Job Market Platform`
- `Information Technology`
- `Savitribai Phule Pune University`
- `Bhavesh Tayade`
- `Priyanka Kakde`
- `BVCOERI`, `Nashik`, `4062`
- `2025-2026`
- `An IT Job Market Platform for India featuring job aggregation, company insights, user contributions, and a unique Salariann Suitability Score based on city-specific cost-of-living metrics.`
- `Flutter (Material 3), Node.js (Express), PostgreSQL, Supabase, Docker`
- `Suitability Score Calculation Engine`
- `Salariann` (for running header)

## NOTES ON ADAPTING DIAGRAMS
The source report builds every diagram as labeled boxes/arrows (suitable for
TikZ in LaTeX or simple shapes in Word/PowerPoint) rather than embedded images
from a drawing tool — this keeps the report reproducible without external
software. When generating: ask the AI to output diagrams either as (a) a
literal box-and-arrow description you redraw in draw.io/Lucidchart, or (b)
Mermaid syntax (`graph TD`, `classDiagram`, `sequenceDiagram`, `flowchart`)
which renders directly in many Markdown viewers and converts cleanly to images.
