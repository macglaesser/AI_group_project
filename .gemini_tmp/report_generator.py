import json
from datetime import datetime

# --- 1. Load Data ---
with open('reports/profile_output.json', 'r') as f:
    profile_data = json.load(f)

with open('reports/recommendations.json', 'r', encoding='utf-16') as f:
    recommendations_data = json.load(f)

# --- 2. Define HTML Structure and CSS ---
html_template = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Recommendation Report for {student_id}</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }}
        .container {{
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }}
        h1, h2, h3 {{
            color: #1a2b4d;
            margin-top: 0;
        }}
        h1 {{
            font-size: 2.5em;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }}
        h2 {{
            font-size: 1.8em;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 8px;
            margin-top: 30px;
        }}
        .section {{
            margin-bottom: 30px;
        }}
        .summary-grid, .profile-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }}
        .summary-item, .profile-item {{
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }}
        .summary-item strong, .profile-item strong {{
            display: block;
            color: #1a2b4d;
            margin-bottom: 5px;
        }}
        .recommendation {{
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin-bottom: 20px;
            overflow: hidden;
        }}
        .rec-header {{
            background: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }}
        .rec-header h3 {{
            margin: 0;
            font-size: 1.4em;
        }}
        .rec-body {{
            padding: 20px;
        }}
        .rec-details {{
            display: flex;
            gap: 30px;
            margin-bottom: 15px;
        }}
        .rec-details div span {{
            font-weight: bold;
        }}
        .status {{
            padding: 5px 12px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 0.9em;
            text-transform: uppercase;
        }}
        .status-eligible {{
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }}
        .status-prerequisites_needed {{
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }}
        .prereq-list, .next-steps-list {{
            list-style-type: none;
            padding: 0;
        }}
        .prereq-list li, .next-steps-list li {{
            background: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 8px;
        }}
        .prereq-list li code, .next-steps-list li code {{
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
        }}
        @media print {{
            body {{
                background-color: #fff;
                padding: 0;
            }}
            .container {{
                box-shadow: none;
                border: 1px solid #ccc;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="section" id="executive-summary">
            <h1>Course Recommendation Report</h1>
            <p>Prepared for: <strong>{student_name}</strong> (ID: {student_id})</p>
            <div class="summary-grid">
                <div class="summary-item"><strong>Cumulative GPA</strong> {gpa}</div>
                <div class="summary-item"><strong>Major</strong> {major}</div>
                <div class="summary-item"><strong>Academic Standing</strong> {standing}</div>
            </div>
        </div>

        <div class="section" id="profile-analysis">
            <h2>Student Profile Analysis</h2>
            <p>{analysis_summary}</p>
            <div class="profile-grid">
                <div class="profile-item"><strong>Strong Subjects</strong> {strong_subjects}</div>
                <div class="profile-item"><strong>Identified Interests</strong> {interests}</div>
                <div class="profile-item"><strong>Career Goals</strong> {career_goals}</div>
                <div class="profile-item"><strong>Recommended Difficulty</strong> Level {preferred_difficulty}</div>
            </div>
        </div>

        <div class="section" id="course-recommendations">
            <h2>Top 5 Course Recommendations</h2>
            {course_recommendations_html}
        </div>

        <div class="section" id="prerequisite-roadmap">
            <h2>Prerequisite Roadmap</h2>
            <p>To unlock your top recommendations, prioritize completing the following prerequisites:</p>
            {prerequisites_html}
        </div>

        <div class="section" id="next-steps">
            <h2>Next Steps</h2>
            <ul class="next-steps-list">
                <li>Review these recommendations and discuss them with your academic advisor.</li>
                <li>Use the course codes provided (e.g., <code>FIN 3301</code>) to look up class schedules and register for the upcoming semester.</li>
                <li>If you have questions about prerequisites or your degree plan, contact your major's advising office.</li>
            </ul>
        </div>
    </div>
</body>
</html>
"""

# --- 3. Generate HTML Content from Data ---

# Course Recommendations
course_recs_html = ""
for rec in recommendations_data['recommendations']:
    status_class = f"status-{rec['eligibility_status']}"
    status_text = rec['eligibility_status'].replace('_', ' ').title()
    missing_prereqs_html = ""
    if rec['missing_prerequisites']:
        missing_prereqs_html = f"<p><strong>Missing Prerequisites:</strong> {', '.join(rec['missing_prerequisites'])}</p>"

    course_recs_html += f"""
    <div class="recommendation">
        <div class="rec-header">
            <h3>{rec['rank']}. {rec['course_code']} - {rec['course_name']}</h3>
            <span class="status {status_class}">{status_text}</span>
        </div>
        <div class="rec-body">
            <div class="rec-details">
                <div><span>Department:</span> {rec.get('department', 'N/A')}</div>
                <div><span>Credits:</span> {rec['credits']}</div>
                <div><span>Difficulty:</span> {rec['difficulty_level']}</div>
                <div><span>Relevance:</span> {rec['relevance_score']}/100</div>
            </div>
            <p>{rec['recommendation_text']}</p>
            {missing_prereqs_html}
            <p><strong>Suggested Semester:</strong> {rec['suggested_semester']}</p>
        </div>
    </div>
    """

# Prerequisite Roadmap
prereqs_html = "<ul class='prereq-list'>"
if recommendations_data['prerequisites_to_prioritize']:
    for prereq in recommendations_data['prerequisites_to_prioritize']:
        prereqs_html += f"<li><code>{prereq['course_code']}</code> - {prereq['reason']}</li>"
else:
    prereqs_html += "<li>No prerequisites need to be prioritized at this time. You are eligible for your top recommendations!</li>"
prereqs_html += "</ul>"


# --- 4. Populate and Write Final HTML ---
final_html = html_template.format(
    student_id=profile_data['student_id'],
    student_name=f"{profile_data.get('FirstName', '')} {profile_data.get('LastName', '')}".strip(),
    gpa=profile_data['gpa'],
    major=profile_data.get('Major', 'N/A'),
    standing=profile_data.get('AcademicStanding', 'N/A'),
    analysis_summary=profile_data['analysis_summary'],
    strong_subjects=', '.join(profile_data['strong_subjects']),
    interests=', '.join(profile_data['interests']),
    career_goals=profile_data['career_goals'],
    preferred_difficulty=profile_data['preferred_difficulty'],
    course_recommendations_html=course_recs_html,
    prerequisites_html=prereqs_html
)

timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
output_filename = f"reports/recommendation_report_{profile_data['student_id']}_{timestamp}.html"

with open(output_filename, 'w', encoding='utf-8') as f:
    f.write(final_html)

print(f"Report generated successfully: {output_filename}")