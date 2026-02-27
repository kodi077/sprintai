import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") ?? "";
// Model: Gemini 2.5 Flash (free tier — RPM: 5, RPD: 20)
const GEMINI_URL =
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const SYSTEM_PROMPT = `You are a senior software architect and agile planning expert.

Convert the provided PRD into a sprint-ready plan consisting of Epics, Tasks, and Subtasks.

Rules:
- Adjust complexity and story point estimates based on the selected frontend, backend, and database stack.
- Story points must follow the Fibonacci sequence: 1, 2, 3, 5, 8, 13, 21.
- Each task must include at least 2 acceptance criteria and at least 1 risk factor.
- Return STRICT, VALID JSON only.
- Do not include any explanations, markdown, commentary, or additional text.
- Your entire response must be a single valid JSON object matching the schema below.

Required JSON schema:
{
  "project_title": "string",
  "stack": { "frontend": "string", "backend": "string", "database": "string" },
  "epics": [
    {
      "id": "E1",
      "name": "string",
      "description": "string",
      "story_points": 8,
      "tasks": [
        {
          "id": "E1-T1",
          "name": "string",
          "description": "string",
          "story_points": 5,
          "subtasks": [{ "name": "string", "story_points": 2 }],
          "acceptance_criteria": ["string", "string"],
          "risks": ["string"]
        }
      ]
    }
  ]
}`;

function parseGeminiJson(rawText: string): Record<string, unknown> | null {
  const cleaned = rawText
    .replace(/^```json\s*/i, "")
    .replace(/^```\s*/i, "")
    .replace(/```\s*$/i, "")
    .trim();

  // 1) Direct parse
  try {
    const parsed = JSON.parse(cleaned);
    if (typeof parsed === "object" && parsed !== null) {
      return parsed as Record<string, unknown>;
    }
    // Sometimes model returns quoted JSON string
    if (typeof parsed === "string") {
      const reparsed = JSON.parse(parsed);
      if (typeof reparsed === "object" && reparsed !== null) {
        return reparsed as Record<string, unknown>;
      }
    }
  } catch {
    // Fall through to extraction parse
  }

  // 2) Extract first object block and parse
  const firstBrace = cleaned.indexOf("{");
  const lastBrace = cleaned.lastIndexOf("}");
  if (firstBrace >= 0 && lastBrace > firstBrace) {
    const sliced = cleaned.slice(firstBrace, lastBrace + 1);
    try {
      const parsed = JSON.parse(sliced);
      if (typeof parsed === "object" && parsed !== null) {
        return parsed as Record<string, unknown>;
      }
    } catch {
      // ignore
    }
  }

  return null;
}

// Helper: build a structured error response
function errorResponse(
  code: string,
  messageKo: string,
  retryAfterSec: number | null,
  httpStatus: number
): Response {
  return new Response(
    JSON.stringify({
      error: {
        code,
        message_ko: messageKo,
        retry_after_sec: retryAfterSec,
      },
    }),
    {
      status: httpStatus,
      headers: { "Content-Type": "application/json", ...CORS_HEADERS },
    }
  );
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  try {
    // Parse request body
    // Expected shape: { prdText, stack: { frontend, backend, database }, conversationId, mode }
    const body = await req.json();
    const { prdText, stack, conversationId, mode } = body;

    // Validate required fields
    if (!prdText || typeof prdText !== "string" || prdText.trim() === "") {
      return errorResponse(
        "BAD_REQUEST",
        "PRD 내용이 없습니다. 내용을 입력해주세요.",
        null,
        400
      );
    }
    if (!stack?.frontend || !stack?.backend) {
      return errorResponse(
        "BAD_REQUEST",
        "프레임워크와 백엔드를 선택해주세요.",
        null,
        400
      );
    }

    // Build the user message
    const userMessage = `Stack:
- Frontend: ${stack.frontend}
- Backend: ${stack.backend}
- Database: ${stack.database || "Not specified"}

PRD:
${prdText.trim()}`;

    // Call Gemini 2.5 Flash
    const geminiPayload = {
      contents: [
        { role: "user", parts: [{ text: SYSTEM_PROMPT }] },
        {
          role: "model",
          parts: [{ text: "Understood. I will return only strict JSON with no additional text." }],
        },
        { role: "user", parts: [{ text: userMessage }] },
      ],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 8192,
        responseMimeType: "application/json",
      },
    };

    const geminiResponse = await fetch(
      `${GEMINI_URL}?key=${GEMINI_API_KEY}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(geminiPayload),
      }
    );

    // Handle rate limit and quota errors from Gemini
    // IMPORTANT: Do NOT auto-retry. Return structured error immediately
    // to avoid wasting the 20 RPD free tier quota.
    if (geminiResponse.status === 429) {
      const errBody = await geminiResponse.text();
      // Distinguish RPM (per-minute) from RPD (daily) based on error body keywords
      const isDaily =
        errBody.includes("RESOURCE_EXHAUSTED") &&
        (errBody.includes("daily") || errBody.includes("quota"));
      if (isDaily) {
        return errorResponse(
          "DAILY_LIMIT",
          "무료 AI 요청 한도(일일)가 초과되었습니다. 내일 다시 시도해 주세요. ※ 데모 환경에서는 요청 횟수가 제한됩니다.",
          null,
          429
        );
      }
      return errorResponse(
        "RATE_LIMITED",
        "현재 분당 AI 요청 한도(분당)가 초과되었습니다. 약 1분 후 다시 시도해 주세요.",
        60,
        429
      );
    }

    if (!geminiResponse.ok) {
      return errorResponse(
        "SERVER_ERROR",
        "일시적인 오류입니다. 잠시 후 다시 시도해 주세요.",
        null,
        502
      );
    }

    // Parse Gemini response
    const geminiData = await geminiResponse.json();
    const rawText: string =
      geminiData.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
    console.log("[analyze_prd] gemini raw head:", rawText.slice(0, 500));

    const parsed = parseGeminiJson(rawText);
    if (!parsed) {
      console.error("[analyze_prd] JSON.parse failed", {
        rawHead: rawText.slice(0, 500),
        cleanedHead: rawText
          .replace(/^```json\s*/i, "")
          .replace(/^```\s*/i, "")
          .replace(/```\s*$/i, "")
          .trim()
          .slice(0, 500),
      });
      return errorResponse(
        "SERVER_ERROR",
        "AI가 올바른 형식의 응답을 반환하지 않았습니다. 다시 시도해 주세요.",
        null,
        422
      );
    }
    const plan = parsed;
    if (!plan.project_title || !Array.isArray(plan.epics)) {
      console.error("[analyze_prd] schema check failed", {
        keys: Object.keys(plan),
      });
      return errorResponse(
        "SERVER_ERROR",
        "AI 응답에 필수 항목이 누락되었습니다. 다시 시도해 주세요.",
        null,
        422
      );
    }

    // Return successful sprint plan
    return new Response(JSON.stringify({ data: plan }), {
      headers: { "Content-Type": "application/json", ...CORS_HEADERS },
    });
  } catch (err) {
    return errorResponse(
      "SERVER_ERROR",
      "일시적인 오류입니다. 잠시 후 다시 시도해 주세요.",
      null,
      500
    );
  }
});
