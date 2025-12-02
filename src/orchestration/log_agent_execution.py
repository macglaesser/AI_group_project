
import sys
import sqlite3
import json
import datetime

def get_db_connection():
    conn = sqlite3.connect(r'c:\Users\macgl\Projects\ai_group_project\sqlite_database.db')
    return conn

def main():
    if len(sys.argv) < 9:
        print("Usage: python log_agent_execution.py <student_id> <agent_name> <input_params_json> <output_data_json> <status> <recommendation_count> <query_count> <start_time_iso> <end_time_iso>")
        sys.exit(1)

    student_id = int(sys.argv[1])
    agent_name = sys.argv[2]
    input_params = sys.argv[3]
    output_data = sys.argv[4]
    status = sys.argv[5]
    recommendation_count = int(sys.argv[6])
    query_count = int(sys.argv[7])
    
    start_time_iso = sys.argv[8]
    end_time_iso = sys.argv[9]

    start_dt = datetime.datetime.fromisoformat(start_time_iso)
    end_dt = datetime.datetime.fromisoformat(end_time_iso)
    duration_ms = int((end_dt - start_dt).total_seconds() * 1000)

    conn = get_db_connection()
    cursor = conn.cursor()

    insert_query = """
    INSERT INTO AIAgentLogs 
    (AgentName, StudentID, ExecutionStartTime, ExecutionEndTime, ExecutionDurationMS, InputParameters, OutputData, ExecutionStatus, RecommendationCount, QueryCount)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    
    cursor.execute(insert_query, (
        agent_name,
        student_id,
        start_time_iso,
        end_time_iso,
        duration_ms,
        input_params,
        output_data,
        status,
        recommendation_count,
        query_count
    ))

    conn.commit()
    conn.close()
    print(f"Logged execution for student {student_id} to AIAgentLogs table.")

if __name__ == '__main__':
    main()
