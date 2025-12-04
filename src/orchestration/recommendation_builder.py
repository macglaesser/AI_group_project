import json
import sys

student_id = sys.argv[1]

with open(f'reports/{student_id}/profile_output.json', 'r') as f:
    student_profile = json.load(f)

with open(f'reports/{student_id}/matched_courses.json', 'r') as f:
    matched_courses = json.load(f)

with open(f'reports/{student_id}/academic_history.json', 'r') as f:
    academic_history_data = json.load(f)
    student_completed_courses = academic_history_data.get('academic_history', [])

with open(f'reports/{student_id}/prerequisites_map.json', 'r') as f:
    prerequisites_map_data = json.load(f)
    prerequisites_map = prerequisites_map_data.get('prerequisites_map', [])

completed_course_codes = {c['CourseCode'] for c in student_completed_courses}

recommendations = []
prerequisites_to_prioritize = {}

for rank, course in enumerate(matched_courses[:5], 1):
    eligibility_status = "eligible"
    missing_prerequisites = []

    if course['course_code'] in completed_course_codes:
        continue

    required_prereqs = [p['PrerequisiteCourseCode'] for p in prerequisites_map if p['CourseCode'] == course['course_code']]
    for prereq_code in required_prereqs:
        if prereq_code not in completed_course_codes:
            eligibility_status = "prerequisites_needed"
            missing_prerequisites.append(prereq_code)
            if prereq_code not in prerequisites_to_prioritize:
                prerequisites_to_prioritize[prereq_code] = f"Required for {course['course_code']}"

    recommendation_text = f"This course, {course['course_name']}, directly aligns with your interest in {student_profile['interests'][0]} and your career goal of {student_profile['career_goals']}. "
    if eligibility_status == "eligible":
        recommendation_text += "You have met all prerequisites, so you can take this course in the next semester. This will build on your strong subjects and prepare you for advanced topics in your field."
    else:
        recommendation_text += f"However, you are missing the following prerequisites: {', '.join(missing_prerequisites)}. I recommend you take these courses first, and then you will be ready to take {course['course_name']}."

    recommendations.append({
        "rank": rank,
        "course_id": course['course_id'],
        "course_code": course['course_code'],
        "course_name": course['course_name'],
        "credits": course['credits'],
        "difficulty_level": course['difficulty_level'],
        "relevance_score": course['relevance_score'],
        "eligibility_status": eligibility_status,
        "missing_prerequisites": missing_prerequisites,
        "recommendation_text": recommendation_text,
        "suggested_semester": "Spring 2026" if eligibility_status == "prerequisites_needed" else "Fall 2025"
    })

output = {
    "recommendations": recommendations,
    "total_recommendations": len(recommendations),
    "prerequisites_to_prioritize": [{"course_code": k, "reason": v} for k, v in prerequisites_to_prioritize.items()]
}

with open(f'reports/{student_id}/recommendations.json', 'w') as f:
    json.dump(output, f, indent=2)