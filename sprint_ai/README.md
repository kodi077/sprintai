# SprintAI (스프린트 AI)

**AI-Powered PRD to Sprint Planning Generator**

SprintAI converts Product Requirement Documents into structured sprint plans with Epics, Tasks, Subtasks, Story Points, Acceptance Criteria, and Risk Factors — powered by Google Gemini 2.5 Flash.

## Stack

- **Frontend**: Flutter Web
- **Backend / Auth / DB**: Supabase (Edge Functions + PostgreSQL + Auth)
- **AI**: Google Gemini 2.5 Flash API (Free Tier)
- **Deployment**: Vercel

## Getting Started

```bash
flutter pub get
flutter run -d chrome
```

## Build for Production

```bash
flutter build web --release --base-href /
```
