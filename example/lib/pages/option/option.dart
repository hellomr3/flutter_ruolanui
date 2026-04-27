import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatefulWidget {
  const Option({super.key});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  Set<int> _selected = {};
  Set<int> _selectedIcons = {};

  final List<String> _tags = [
    "Flutter",
    "Dart",
    "iOS",
    "Android",
    "React Native",
    "SwiftUI",
    "Kotlin",
    "Java",
    "TypeScript",
    "Python",
    "Rust",
    "Go",
    "Vue",
    "React",
    "Angular",
    "Node.js",
    "Docker",
    "Kubernetes",
    "GraphQL",
    "REST API",
    "Firebase",
    "AWS",
    "GCP",
    "Azure",
    "MongoDB",
    "PostgreSQL",
    "Redis",
    "Nginx",
    "CI/CD",
    "Git",
  ];

  final List<IconOptionItem> _iconOptions = const [
    IconOptionItem(icon: Icons.camera_alt_outlined, label: "拍照"),
    IconOptionItem(icon: Icons.photo_library_outlined, label: "相册"),
    IconOptionItem(icon: Icons.videocam_outlined, label: "录像"),
    IconOptionItem(icon: Icons.insert_drive_file_outlined, label: "文件"),
    IconOptionItem(icon: Icons.location_on_outlined, label: "位置"),
    IconOptionItem(icon: Icons.contact_phone_outlined, label: "联系人"),
    IconOptionItem(icon: Icons.music_note_outlined, label: "音乐"),
    IconOptionItem(icon: Icons.link_outlined, label: "链接"),
    IconOptionItem(icon: Icons.qr_code, label: "扫码"),
    IconOptionItem(icon: Icons.wallet_outlined, label: "钱包"),
    IconOptionItem(icon: Icons.favorite_outline, label: "收藏"),
    IconOptionItem(icon: Icons.star_outline, label: "星标"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              PrimaryBtn(
                label: "显示选项",
                onPressed: () {
                  showSampleOptionsDialog(
                      options: ["拍照", "摄像"], context: context);
                },
              ),
              PrimaryBtn(
                label: "确认弹窗",
                onPressed: () {
                  showConfirmDialog(
                      context: context, title: "提示", content: "确定要删除吗？");
                },
              ),
              PrimaryBtn(
                label: "大量选项弹窗（纯文本）",
                onPressed: () async {
                  final result = await showTextWrapOptionsDialog(
                    context: context,
                    title: "选择技术栈",
                    initialSelected: _selected,
                    options: _tags,
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      setState(() => _selected = data);
                    }
                  });
                },
              ),
              // 展示纯文本已选结果
              if (_selected.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selected
                        .map((i) => TextTag(label: _tags[i], selected: true))
                        .toList(),
                  ),
                ),
              PrimaryBtn(
                label: "大量选项弹窗（图标+文本）",
                onPressed: () async {
                  final result = await showIconTextWrapOptionsDialog(
                    context: context,
                    title: "选择功能",
                    initialSelected: _selectedIcons,
                    options: _iconOptions,
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      setState(() => _selectedIcons = data);
                    }
                  });
                },
              ),
              // 展示图标已选结果
              if (_selectedIcons.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedIcons
                        .map((i) => TextTag(
                              selected: true,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_iconOptions[i].icon, size: 14),
                                  const SizedBox(width: 4),
                                  Text(_iconOptions[i].label),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              PrimaryBtn(
                label: "单选弹窗（自定义Widget）",
                onPressed: () async {
                  final colors = [
                    Colors.red,
                    Colors.orange,
                    Colors.amber,
                    Colors.green,
                    Colors.teal,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ];
                  final labels = [
                    "红色",
                    "橙色",
                    "琥珀",
                    "绿色",
                    "青色",
                    "蓝色",
                    "靛蓝",
                    "紫色",
                  ];
                  final options = List.generate(
                    colors.length,
                    (i) => IconOptionItem(
                        icon: Icons.circle, label: labels[i]),
                  );
                  final result = await showWrapOptionsDialog<IconOptionItem>(
                    context: context,
                    title: "选择颜色（单选）",
                    options: options,
                    multiSelect: false,
                    spacing: 16,
                    runSpacing: 16,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return IconTextOption(
                        label: item.label,
                        isSelected: isSelected,
                        onTap: onTap,
                        iconBuilder: (selected, fgColor) {
                          return Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      );
                    },
                  );
                  result.onSuccess((data) {
                    if (data != null && data.isNotEmpty) {
                      final index = data.first;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("选择了: ${labels[index]}")),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
