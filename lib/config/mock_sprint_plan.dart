const String kMockSprintPlanJson = '''
{
  "project_title": "SprintAI MVP",
  "stack": {
    "frontend": "Flutter",
    "backend": "Supabase",
    "database": "PostgreSQL"
  },
  "epics": [
    {
      "id": "E1",
      "name": "Core Analysis Flow",
      "description": "Implement PRD intake and AI analysis request lifecycle.",
      "story_points": 13,
      "tasks": [
        {
          "id": "E1-T1",
          "name": "Build PRD submission UI",
          "description": "Create stack selectors, multiline PRD input, and submit action.",
          "story_points": 5,
          "subtasks": [
            { "name": "Implement stack dropdowns", "story_points": 2 },
            { "name": "Add PRD text input validation", "story_points": 1 },
            { "name": "Handle loading and disabled submit state", "story_points": 2 }
          ],
          "acceptance_criteria": [
            "User can select frontend and backend before submit.",
            "Submit button is disabled while request is in flight."
          ],
          "risks": [
            "Large PRD input may increase response time."
          ]
        },
        {
          "id": "E1-T2",
          "name": "Integrate analyze_prd endpoint",
          "description": "Call Supabase edge function and parse strict JSON response.",
          "story_points": 8,
          "subtasks": [
            { "name": "Create AI service with request contract", "story_points": 3 },
            { "name": "Map backend error codes to localized dialogs", "story_points": 2 },
            { "name": "Validate mandatory fields in response", "story_points": 3 }
          ],
          "acceptance_criteria": [
            "Valid JSON response renders in the UI as a tree.",
            "Invalid JSON returns a structured error dialog."
          ],
          "risks": [
            "Edge function may return markdown code fences around JSON."
          ]
        }
      ]
    },
    {
      "id": "E2",
      "name": "Export and Session Experience",
      "description": "Enable plan exports and guest/auth session behavior.",
      "story_points": 8,
      "tasks": [
        {
          "id": "E2-T1",
          "name": "Add Jira CSV and Notion Markdown export",
          "description": "Convert generated plan to download-ready formats.",
          "story_points": 5,
          "subtasks": [
            { "name": "Flatten hierarchy into Jira CSV rows", "story_points": 2 },
            { "name": "Render markdown sections for Notion import", "story_points": 3 }
          ],
          "acceptance_criteria": [
            "Jira CSV contains Epic, Story, and Sub-task rows.",
            "Notion Markdown mirrors Epic/Task/Subtask hierarchy."
          ],
          "risks": [
            "Special characters in content can break CSV formatting."
          ]
        }
      ]
    }
  ]
}
''';
