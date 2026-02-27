import 'package:universal_html/html.dart' as html;

import '../models/sprint_plan_model.dart';

class ExportUtils {
  static void exportToJiraCsv(SprintPlan plan) {
    final rows = <List<String>>[
      <String>[
        'Issue Type',
        'Summary',
        'Description',
        'Story Points',
        'Parent',
      ],
    ];

    for (final epic in plan.epics) {
      rows.add(<String>[
        'Epic',
        epic.name,
        epic.description,
        epic.storyPoints.toString(),
        '',
      ]);

      for (final task in epic.tasks) {
        rows.add(<String>[
          'Story',
          task.name,
          task.description,
          task.storyPoints.toString(),
          epic.id,
        ]);

        for (final subtask in task.subtasks) {
          rows.add(<String>[
            'Sub-task',
            subtask.name,
            '',
            subtask.storyPoints.toString(),
            task.id,
          ]);
        }
      }
    }

    final csvString = rows
        .map((row) => row.map(_escapeCsvCell).join(','))
        .join('\n');

    final blob = html.Blob(<String>[csvString], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', '${plan.projectTitle}_jira.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static void exportToNotionMarkdown(SprintPlan plan) {
    final buffer = StringBuffer()
      ..writeln('# ${plan.projectTitle}')
      ..writeln();

    for (final epic in plan.epics) {
      buffer.writeln('## Epic: ${epic.name} (${epic.storyPoints} SP)');
      buffer.writeln(epic.description);
      buffer.writeln();

      for (final task in epic.tasks) {
        buffer.writeln('### Task: ${task.name} (${task.storyPoints} SP)');
        buffer.writeln(task.description);
        buffer.writeln();

        for (final subtask in task.subtasks) {
          buffer.writeln(
            '- Subtask: ${subtask.name} (${subtask.storyPoints} SP)',
          );
        }
        buffer.writeln();

        buffer.writeln('**완료 조건:**');
        for (final criterion in task.acceptanceCriteria) {
          buffer.writeln('- $criterion');
        }
        buffer.writeln();

        buffer.writeln('**리스크:**');
        for (final risk in task.risks) {
          buffer.writeln('- $risk');
        }
        buffer.writeln();
      }
    }

    final markdownString = buffer.toString();
    final blob = html.Blob(<String>[markdownString], 'text/markdown');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', '${plan.projectTitle}_notion.md')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static String _escapeCsvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
