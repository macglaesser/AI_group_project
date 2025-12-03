# Final Project Reflection

## Business Problem & Context
- **Problem Solved**: Automated personalized course recommendations for students based on academic history, interests, and career goals. Replaces manual advisor-based course planning.
- **Business Value**: Reduces advisor workload, improves student retention through better course fit, enables data-driven academic planning at scale.
- **Estimated Savings**: ~15 mins per student consultation (100+ students/semester = 25+ hours saved). At $50/hr advisor time = $1,250/semester per advisor. For a university with 50 advisors = $62,500/semester.

## GenAI Application
- **Why GenAI**: Multi-dimensional scoring (interest, career, difficulty, strategy) requires nuanced judgment. LLMs excel at context-aware evaluation beyond simple rule-based systems.
- **Agentic Workflows**: Perfect fit. Separation into Profile Analyzer → Course Matcher → Recommendation Builder mirrors human advisor workflow (analyze student, evaluate options, build plan). Each agent has clear input/output contract.
- **Limitations/Risks**: 
  - Hallucinations in course recommendations (might suggest non-existent courses)
  - Bias in career goal interpretation (may reinforce stereotypes)
  - Recommendation quality depends entirely on accurate student data
  - Requires fallback mechanism if scores don't differentiate courses well

## Technical Setup
- **AI CLI**: Claude AI via `.claude/commands/` integration (orchestrator pattern)
- **Sub-Agents**: 3 specialized agents
  - Profile Analyzer: Parses academic history, calculates GPA, extracts intent
  - Course Matcher: 4-criterion weighted scoring algorithm
  - Recommendation Builder: Prerequisite verification, eligibility checking
- **Tools Used**:
  - Built-in: SQLite3 queries, JSON parsing, file I/O
  - Custom: `database_queries.py` for 4 parameterized SQL queries
  - No MCP servers configured (future opportunity)
- **Why This Setup**: Mirrors real advisor workflow. JSON-only agent outputs ensure reliable parsing. SQLite provides lightweight persistence. Streamlit dashboard separates concerns (workflow vs UI).

## Development Experience

### What Went Right
- **Agent Specialization**: Breaking workflow into 3 agents reduced complexity—each agent could focus on single task with clear JSON contracts.
- **JSON-Only Output**: Forcing strict JSON output eliminated parsing errors; agents naturally adapted to structure.
- **Database Queries**: Parameterized SQL queries were flexible enough to handle complex joins across 8 tables without hardcoding.
- **Prerequisite Checking**: Simple eligibility logic (all prerequisites met? yes/no) was surprisingly effective for edge cases.

### What Went Wrong
- **Agent Output Validation**: Initially agents included markdown/explanations in JSON. Required strict prompts + examples to force JSON-only output.
- **Course Matching Scoring**: Agents sometimes inflated scores for weak matches. Fixed by adding "be honest about scores" guidance + scoring guidelines.
- **Prerequisite Chains**: Didn't initially handle transitive prerequisites (A requires B, B requires C). SQL now traverses chain.
- **HTML Report Generation**: Not fully implemented—currently saved as structured data. Would need template engine for production.

**[TODO: ADD YOUR EXPERIENCE HERE]**
- What challenges did YOU personally hit?
- How long did specific tasks actually take?
- What was harder/easier than you expected?
- Any bugs that surprised you?

### Interesting/Surprising Learnings
- **Prompt Precision Matters**: Even small wording changes ("return ONLY JSON" vs "output JSON") significantly impact compliance. Specificity > clarity.
- **Agent Handoffs**: Passing JSON between agents is reliable if contracts are clear, but requires discipline in schema definition.
- **Scoring Algorithms**: Weighted scoring with AI reasoning produces better results than pure algorithmic scoring—AI catches context that formulas miss.
- **Cost of Orchestration**: Each agent call costs money. 3 sequential agents = 3 API calls per student. Caching would be essential for scale.

**[TODO: ADD YOUR LEARNINGS HERE]**
- What surprised YOU about working with agentic AI?
- Any unexpected behaviors from Claude?
- What did you learn about your own workflow?
- Any "aha moments" with prompt engineering?

## If You Started Over
- **Different Approach**: Would implement agent caching layer immediately rather than sequential calls. Could reduce latency 70%+.
- **More Time On**: Testing edge cases (students with no completed courses, prerequisites not in catalog, circular dependencies).
- **Less Time On**: Custom HTML templating—would use Jinja2 from start instead of building custom.
- **Advice**: 
  1. Start with crystal-clear input/output contracts for each agent (saves debugging time)
  2. Use JSON exclusively for inter-agent communication (reduces parsing errors)
  3. Build validation layer early (catch bad data before it hits agents)
  4. Test with real messy data, not clean examples (prerequisites will have gaps/errors)
  5. Plan for caching—sequential agent calls get expensive fast

**[TODO: ADD YOUR PERSONAL INSIGHTS HERE]**
- What would YOU do differently if starting fresh?
- Did you discover any shortcuts/workarounds?
- What tools would you have picked from the start?
- Anything you'd skip entirely?

## Business Impact Assessment
- **Production Deployment**: 
  - Would need: User authentication, audit logging, feedback collection (did recommendations help?), A/B testing
  - Add MCP servers for course search, prerequisite verification, advisor override mechanism
  - Implement result caching (same student profile generates same results for 24hrs)
  
- **Scale Requirements**:
  - Current: ~100-300 students/semester = manageable sequential processing
  - At Scale: Would need parallel processing + job queue (Celery/RabbitMQ)
  - API endpoints instead of CLI interface
  - Result caching + vectorized search (k-nearest-neighbor for similar students)
  
- **ROI Calculation**:
  - **Inputs**: 500-student university, $50/hr advisor cost, 15 min saved per student
  - **Annual Benefit**: 500 students × 0.25 hrs × $50 × 2 semesters = **$12,500/year**
  - **Development Cost**: ~200 hours eng time = $20,000 (one-time)
  - **Maintenance**: ~5 hrs/month = $3,000/year
  - **Payback**: 1.6 years for $500 student cohort; scales better with larger schools
  - **Intangible Benefits**: Improved student retention (+2% = $250k+), better course fit, reduced course drops