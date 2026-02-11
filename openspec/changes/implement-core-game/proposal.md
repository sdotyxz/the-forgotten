# 变更提案：根据 GDD 实现游戏核心功能

## Why

根据 GDD.md 设计文档，需要将 The Forgotten 游戏从概念转化为可玩的原型。当前 Godot 项目为空壳，需要实现核心功能才能让游戏可玩。

## What Changes

- **1-bit 渲染系统**: 实现全屏后处理 Shader，包含深度边缘检测和 Bayer 抖动效果
- **场景旋转控制**: 鼠标拖动旋转等距场景，支持 R 键重置视角
- **物品收集系统**: 可点击的隐藏物品，射线检测交互，收集反馈
- **第一关场景**: 使用 KayKit Restaurant Bits (桌椅/吧台) 和 Kenney Mini Characters (顾客) 搭建咖啡馆，放置 3 个隐藏物品
- **UI 系统**: 物品清单显示、进度指示、操作提示

## Capabilities

### New Capabilities
- `rendering-1bit`: 1-bit 黑白后处理渲染系统
- `camera-control`: 等距视角相机旋转控制
- `item-collection`: 可收集物品交互系统
- `level-management`: 关卡管理和完成检测
- `ui-hud`: 游戏 HUD 和物品清单 UI

### Modified Capabilities
- (无)

## Impact

- **代码**: Godot 项目新增 scripts/、shaders/、scenes/ 内容
- **依赖**: 需要 Godot 4.6 的 Compatibility 渲染模式
- **性能**: 目标 60 FPS，后处理 Shader 需要深度缓冲支持
