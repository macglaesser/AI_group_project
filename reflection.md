# Final Project Reflection

## Business Problem & Context
- **What problem does your solution solve?**
  - The goal is to solve the common pain points students and advisors encounter when creating semester schedules or mapping out multi-year degree plans. Students often struggle to identify which courses to take, when to take them, and how to align their schedules with graduation requirements. Advisors face challenges in providing personalized guidance efficiently and are overburdened with repetitive tasks.
- **Why is this valuable to a business?**
  - This is valuable to an entity (such as SMU) because it enhances student satisfaction and retention by simplifying the course selection process. It also reduces the workload on academic advisors, allowing them to focus on more complex student needs and improving overall operational efficiency.
- **What's the estimated time/cost savings or value created?**
  - Students visit advisors 3-5 times per semester for scheduling questions. Current manual process taking 15-30 minutes per session. Automation happens in seconds. Potentially saving hundreds of hours per semester across the student body, leading to significant cost savings for the institution. Advisors spend 60-70% of their time on scheduling tasks, which could be reduced significantly with this solution. Avoids bottle necks with Advisor availability during peak times (registration periods).

## GenAI Application
- **Why did you choose to use GenAI for this problem?**
  - GenAI is well-suited for this problem due to its ability to understand and process complex academic requirements, degree plans, catalog descriptions, and prerequisites in natural language. GenAI can then generate personalized course recommendations tailored to individual student needs, making it an ideal tool for automating the scheduling process.
- **How does GenAI improve upon existing solutions?**
  - Existing solutions often rely on static databases or rule-based systems that lack flexibility and personalization. GenAI can interpret a wide range of inputs, including student preferences, academic history, and degree requirements, to provide dynamic and context-aware recommendations. This leads to a more tailored experience for students and advisors, improving satisfaction and outcomes.
- **What makes this a good use case for agentic workflows vs. traditional software?**
  - Traditional software solutions often rely on rigid rule-based systems that may not adapt well to the nuances of individual student needs and changing academic requirements. Agentic workflows powered by GenAI can dynamically interpret and respond to diverse inputs, providing more personalized and context-aware recommendations. This flexibility allows for a more user-centric approach, enhancing the overall experience for both students and advisors.
- **What are the limitations or risks of using AI here?**
  - Limitations include potential inaccuracies in course recommendations if the AI misinterprets degree requirements or student preferences. There is also a risk of bias in the training data, which could lead to unfair or suboptimal suggestions. Additionally, reliance on AI may reduce human oversight, potentially leading to errors that could impact students' academic progress. Ensuring data privacy and security is also a critical concern when handling sensitive student information.

## Technical Setup
- **Which AI coding CLI did you use? (Claude Code, Gemini CLI, Cursor, other)**
  - For this project, we used GitHub Copilot's Agentic system to streamline the development process. The models we selected were mainly Claude Haiku 4.5 and Claude Sonnet 4.5. GitHub Copilot successfully provided code suggestions and helped automate repetitive coding tasks, allowing us to focus on higher-level design and implementation. For the Agentic Workflow, we utilized the Gemini CLI to orchestrate the multi-agent interactions and manage the overall workflow with the .claude framework; therefore it will work for either Claude or Gemini CLI.
- **What sub-agents did you leverage?**
  - We developed three specialized agents: the Profile Analyzer Agent, the Course Matcher Agent, and the Recommendation Builder Agent. Each agent had distinct responsibilities, from analyzing student profiles to matching courses and building personalized reports for each student to review.
- **What tools (built-in, MCP, or custom) did you use?**
  - Built-in tools: SQLite3 database queries (parameterized SQL), JSON serialization/parsing, Python file I/O, system arguments
  - Custom tools: `database_queries.py` script that executes 4 specialized SQL queries (student profile, academic history, available courses, prerequisites map)
  - No MCP servers configured (identified as future enhancement opportunity)
  - External integration: SQLite database (`sqlite_database.db`) for data persistence, Streamlit 1.51.0 for dashboard UI, Plotly 6.5.0 for visualizations, Pandas 2.3.3 for data processing
- **Why did you choose this particular setup?**
  - The three-agent architecture mirrors real-world academic advisor workflow: analyze student → match courses → build recommendations. This separation of concerns allows each agent to specialize and improves reliability of outputs.
  - JSON-only communication between agents ensures structured, parseable results without markdown or explanations that could cause parsing failures.
  - SQLite provides lightweight, single-file database persistence that works well for institutional use without requiring complex server infrastructure.
  - Streamlit framework was chosen for rapid dashboard development and easy deployment—no complex frontend build required.
  - Parameterized SQL queries prevent injection attacks and provide flexibility for complex multi-table joins across the academic database schema.

## Development Experience

### What Went Right
- **What worked better than expected?**
  - SQLite worked surprisingly well as a lightweight database solution for prototyping the academic data model. Its simplicity allowed us to focus on building the AI agents and workflow without complex database administration. Everything connected well with the database for both the workflow and the dashboard.
  - Natural language processing handled complex academic requirements and course descriptions better than expected, allowing for accurate course matching and recommendation generation.
  - GitHub worked well for team collaboration, version control, and issue tracking throughout the project.
  - Proof of concept built in days not weeks
- **Which AI tools/agents were most helpful?**
  - Profile Analyzer Agent nailed parsing student history and extracting interests from natural language. Gave us a solid foundation for the other agents.
  - Course Matcher Agent's weighted scoring worked really well for ranking courses. AI understood the nuances between course content and student goals better than we expected.
  - Recommendation Builder Agent's prerequisite checking kept us from recommending courses students couldn't actually take.
  - GitHub Copilot cut down a lot of boilerplate code work, which freed us up to focus on agent design.
  - Gemini CLI handled the multi-agent orchestration pretty smoothly overall.
- **What was easier than you thought?**
  - The multi-agent orchestration using Gemini CLI was more straightforward than anticipated.
  - The integration of the Streamlit dashboard with the SQLite database was smoother than expected, enabling real-time data visualization with minimal setup.

### What Went Wrong
- **What challenges or roadblocks did you hit?**
  - Foreign key issues in the database schema caused the workflow and webapp to fail initially. We had to restructure how prerequisites linked to courses to prevent unintended deletions.
  - The agentic workflow required multiple iterations to get JSON parsing and inter-agent communication correct.
  - Validating the correctness of course recommendations against degree requirements was challenging and required manual review.
- **Where did AI tools/agents struggle or fail?**
  - Gemini CLI sometimes struggled with orchestrating multi-agent interactions, especially when gathering and parsing data from the database. Session consistency was an issue. We'd need to re-prompt or adjust context between runs to get reliable behavior.
- **What bugs or issues took longest to resolve?**
  - Debugging the SQL queries took significant time, especially getting the prerequisites join to work correctly across multiple tables. 
  - The foreign key issue happened multiple times and had to prompt copilot several times to allow the connections to the database to work without errors.


### Interesting/Surprising Learnings
- **What surprised you about working with agentic AI?**
  - Design choices were automated to a greater extent than expected, allowing us to focus on high-level architecture. This surprised us, as we anticipated more manual coding.
  - GenAI's ability to understand complex academic requirements and generate tailored recommendations was impressive and exceeded our expectations.
  - Unexpected course pairings that the AI suggested based on student interests and career goals revealed insights we hadn't considered, but actually made sense upon review.
- **What did you learn about prompt engineering or workflow design?**
  - Specificity is key. Clearly defining each agent's role and expected outputs upfront made a big difference in workflow reliability. Vague instructions led to parsing failures.
  - Iterative refinement of prompts based on observed outputs was essential to achieving the desired behavior from each agent. We went through at least 3 to 4 iterations per agent before outputs became reliable.
- **How did this change your understanding of AI capabilities?**
  - We really underestimated how well GenAI could handle domain-specific knowledge like academic course planning. It showed us that with the right prompts and data, AI can tackle complex, specialized tasks effectively. What surprised us most was that the AI could catch connections between student interests and courses that weren't obvious from just reading descriptions, suggesting course combinations that made sense even to domain experts upon reflection.

## If You Started Over
- **What would you do differently?**
  - Use MCP servers for live university system integration, real-time course availability, enrollment caps, and transcript data without manual data syncing.
  - Integrate a chatbot for real-time student and advisor Q&A on course recommendations.
  - Build in more robust explanations as to why certain courses were recommended to increase trust and transparency.
  - Involve advisors in the design phase earlier to validate our assumptions about course matching logic.
  - Test with diverse populations of students (first-generation, transfer, international, etc.) to stress-test scenarios from the beginning.
- **What would you spend more/less time on?**
  - More time on testing and validation of course recommendations against real student scenarios.
  - More time on refining the user interface and experience of the dashboard to ensure ease of use for students and advisors. The current version is functional but not optimized for user experience.
  - Less time on initial database schema design. We could have leveraged existing academic database schemas to save time instead of building from scratch.
- **What advice would you give to someone doing a similar project?**
  - Start with a clear understanding of the academic requirements and workflows involved in course scheduling.
  - Understand what agents you need and clearly define their responsibilities upfront and before starting development.
  - Engage with actual students and advisors early in the design process to gather requirements and feedback.
  - Leverage existing tools and frameworks to speed up development, but be prepared to customize as needed for specific academic contexts.

## Business Impact Assessment
- **How would this work in a real production environment?**
  - This solution could be integrated into a university's existing student information system, providing real-time course recommendations during the registration process. Students would provide thier id number and specific interests, then a report would be generated and sent to them. From there the studnets could explore the recommend classes in the dashboard or refine their prompt for differnt courses. It would require collaboration with IT departments to ensure data security and compliance with educational regulations. The dashboard could be hosted on the university's intranet or cloud infrastructure, accessible to students and advisors.
- **What would be needed to deploy this at scale?**
  - Robust database infrastructure to handle large volumes of student and course data.
  - Integration with existing student information systems for real-time data access.
  - Scalable hosting solutions for the dashboard application to accommodate many concurrent users.
  - Ongoing maintenance and updates to ensure the system remains accurate and relevant with changing course offerings and degree requirements.
  - Training and support for students and advisors to effectively use the new tools.
- **What's the ROI if a company implemented this? (make reasonable assumptions)**
  - The ROI could be significant, with potential savings of hundreds of advisor hours per semester and improved student satisfaction leading to higher retention rates. Assuming an average advisor salary and the number of students served, the cost savings from reduced advisor workload could offset the development and maintenance costs within a few semesters. Additionally, improved course selection could lead to better academic outcomes, further enhancing the institution's reputation and attractiveness to prospective students.  - For example, if an advisor's time is valued at $50/hour and the system saves 200 hours per semester, that's a $10,000 saving per semester. Over a year, this amounts to $20,000 in savings per advisor.