import 'dart:convert';

import 'package:universal_html/html.dart' as html;

import '../models/sprint_plan_model.dart';

class ExportService {
  const ExportService();

  void exportJiraCsv(SprintPlan plan) {
    final rows = <List<String>>[
      ['Issue Type', 'Summary', 'Description', 'Story Points', 'Parent'],
    ];

    for (final epic in plan.epics) {
      rows.add(['Epic', epic.name, epic.description, epic.storyPoints.toString(), '']);
      for (final task in epic.tasks) {
        rows.add(['Story', task.name, task.description, task.storyPoints.toString(), epic.id]);
        for (final subtask in task.subtasks) {
          rows.add(['Sub-task', subtask.name, '', subtask.storyPoints.toString(), task.id]);
        }
      }
    }

    final csv = rows.map(_csvRow).join('\n');
    _downloadText(
      fileName: '${_slug(plan.projectTitle)}_jira.csv',
      content: csv,
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  void exportNotionMarkdown(SprintPlan plan) {
    final buffer = StringBuffer('# ${plan.projectTitle}\n\n');

    for (final epic in plan.epics) {
      buffer.writeln('## Epic: ${epic.name} (${epic.storyPoints} SP)');
      buffer.writeln();
      buffer.writeln(epic.description);
      buffer.writeln();

      for (final task in epic.tasks) {
        buffer.writeln('### Task: ${task.name} (${task.storyPoints} SP)');
        buffer.writeln();
        buffer.writeln(task.description);
        buffer.writeln();

        for (final subtask in task.subtasks) {
          buffer.writeln('- Subtask: ${subtask.name} (${subtask.storyPoints} SP)');
        }
        buffer.writeln();

        buffer.writeln('**Acceptance Criteria:**');
        for (final criterion in task.acceptanceCriteria) {
          buffer.writeln('- $criterion');
        }
        buffer.writeln();

        buffer.writeln('**Risks:**');
        for (final risk in task.risks) {
          buffer.writeln('- $risk');
        }
        buffer.writeln();
      }
    }

    _downloadText(
      fileName: '${_slug(plan.projectTitle)}_notion.md',
      content: buffer.toString(),
      mimeType: 'text/markdown;charset=utf-8',
    );
  }

  String _csvRow(List<String> values) {
    return values
        .map((value) => '"${value.replaceAll('"', '""')}"')
        .toList()
        .join(',');
  }

  void _downloadText({
    required String fileName,
    required String content,
    required String mimeType,
  }) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }

  String _slug(String input) {
    final value = input.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return value.isEmpty ? 'sprint_plan' : value;
  }
}
