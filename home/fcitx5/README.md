# Fcitx5 主题

术语见根目录的 [GLOSSARY.md](../../GLOSSARY.md)。

## 候选项高亮背景

`macos-light` 和 `macos-dark` 的候选项高亮背景来自
`[InputPanel/Highlight]` 指定的 `highlight.png`，圆角和中间填充都来自图片。
`HighlightCandidateColor` 控制选中候选项的文字颜色；
`HighlightBackgroundColor` 控制预编辑文本的高亮背景。

`[InputPanel/Highlight/Margin]` 定义图片的九宫格切片边距。
中心切片必须有正的宽度和高度：

```text
中心宽度 = 图片宽度 − Left − Right > 0
中心高度 = 图片高度 − Top − Bottom > 0
```

两个主题的 `highlight.png` 均为 39×39。左右边距各为 19，
上下边距各为 8，中心切片为 1×23。
候选文字的留白由 `[InputPanel/TextMargin]` 单独控制。

## 升级后中间填充消失

原配置的左右切片边距各为 20，中心宽度为 −1。
[Fcitx5 5.1.21](https://github.com/fcitx/fcitx5/blob/5.1.21/src/ui/classic/theme.cpp)
会把无效的中心宽度按 1 像素绘制；
[5.1.22](https://github.com/fcitx/fcitx5/blob/5.1.22/src/ui/classic/theme.cpp)
开始跳过非正尺寸的中心区域。
升级跨越这个版本后，会出现两端高亮圆角仍在、中间背景透明的现象。

2026-10-08 使用官方各版本的主题加载和绘制代码离屏验证：

| 配置 | Fcitx5 版本 | 高亮中心透明度 alpha |
| --- | --- | --- |
| Left=20、Right=20 | 5.1.21 | 255（不透明） |
| Left=20、Right=20 | 5.1.22、5.1.23 | 0（透明） |
| Left=19、Right=19 | 5.1.23 | 255（不透明） |

5.1.23 下，修正后的明暗主题在 1、1.25、1.5、2 倍缩放和
64、100、180、320 像素宽度下共 32 项检查全部通过。
此验证覆盖候选高亮背景绘制；实际应用中的显示需要应用 Home Manager
配置并重新加载输入法后确认。
