import json

with open('reports/profile_output.json', 'r') as f:
    student_profile = json.load(f)

with open('reports/available_courses.json', 'r') as f:
    available_courses_data = json.load(f)
    available_courses = available_courses_data.get('available_courses', [])

def calculate_relevance_score(course, student_profile):
    score = 0
    match_reasoning_list = []

    # 1. Interest Alignment (40% weight)
    interest_keywords = student_profile['interests']
    course_text = (course['CourseName'] + ' ' + course['Description'] + ' ' + course['DepartmentName']).lower()
    
    direct_interest_matches = 0
    for interest in interest_keywords:
        if interest.lower() in course_text:
            direct_interest_matches += 1
            match_reasoning_list.append(f"Aligns with interest in '{interest}'.")
    
    interest_score = (direct_interest_matches / len(interest_keywords)) if interest_keywords else 0
    score += interest_score * 40

    # 2. Career Relevance (30% weight)
    career_keywords = [student_profile['career_goals'].lower()] if student_profile['career_goals'] else []
    career_relevance = 0
    for keyword in career_keywords:
        if keyword in course_text:
            career_relevance = 1.0
            match_reasoning_list.append(f"Highly relevant for career goal of '{student_profile['career_goals']}'.")
            break
    
    if any(k in course_text for k in ["finance", "financial", "investment", "investments", "banking", "corporate", "valuation", "mergers", "acquisitions", "computer science", "programming", "data structures", "algorithms"]):
        if career_relevance == 0:
            career_relevance = 0.7
            match_reasoning_list.append("Contains general keywords relevant to career goals.")

    score += career_relevance * 30

    # 3. Difficulty Match (20% weight)
    difficulty_diff = abs(course['DifficultyLevel'] - student_profile['preferred_difficulty'])
    if difficulty_diff == 0:
        difficulty_match_score = 1.0
        match_reasoning_list.append("Difficulty level matches preferred difficulty.")
    elif difficulty_diff == 1:
        difficulty_match_score = 0.7
        match_reasoning_list.append("Difficulty level is close to preferred difficulty.")
    elif difficulty_diff == 2:
        difficulty_match_score = 0.4
        match_reasoning_list.append("Difficulty level is somewhat different from preferred difficulty.")
    else:
        difficulty_match_score = 0.1
        match_reasoning_list.append("Difficulty level is significantly different from preferred difficulty.")
    score += difficulty_match_score * 20

    # 4. Strategic Value (10% weight)
    strategic_value_score = 0
    if course['DepartmentName'] in student_profile['strong_subjects']:
        strategic_value_score += 0.6
        match_reasoning_list.append(f"Builds on strong subject '{course['DepartmentName']}'.")
    if student_profile.get('Major') and student_profile['Major'].lower() in course_text:
        strategic_value_score += 0.4
        match_reasoning_list.append(f"Relevant to student's major in '{student_profile['Major']}'.")
    score += strategic_value_score * 10
    
    final_score = min(score, 100.0)
    match_reasoning = " ".join(list(set(match_reasoning_list)))
    return round(final_score, 2), match_reasoning

matched_courses = []
for course in available_courses:
    relevance_score, match_reasoning = calculate_relevance_score(course, student_profile)
    course_copy = course.copy()
    course_copy['relevance_score'] = relevance_score
    course_copy['match_reasoning'] = match_reasoning
    matched_courses.append(course_copy)

matched_courses.sort(key=lambda x: x['relevance_score'], reverse=True)

top_12_matched_courses = matched_courses[:12]

output_courses = []
for course in top_12_matched_courses:
    output_courses.append({
        "course_id": str(course['CourseID']),
        "course_code": course['CourseCode'],
        "course_name": course['CourseName'],
        "description": course['Description'],
        "department": course['DepartmentName'],
        "credits": course['CreditHours'],
        "difficulty_level": course['DifficultyLevel'],
        "prerequisites": course['PrerequisiteCourseIDs'].split(',') if course['PrerequisiteCourseIDs'] else [],
        "relevance_score": course['relevance_score'],
        "match_reasoning": course['match_reasoning']
    })

with open('reports/matched_courses.json', 'w') as f:
    json.dump(output_courses, f, indent=2)