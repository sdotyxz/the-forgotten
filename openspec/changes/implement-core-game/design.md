# 技术设计

## Context

The Forgotten 是一个 1-bit 等距视角的隐藏物品游戏。当前 Godot 项目为空壳，需要实现完整的游戏循环。

## Goals / Non-Goals

**Goals:**
- 实现 1-bit 后处理渲染效果
- 实现场景旋转控制
- 实现物品收集系统
- 完成第一关可玩版本

**Non-Goals:**
- 不实现多关卡切换
- 不实现音效系统
- 不实现复杂动画系统（顾客仅使用 idle 循环）

## Decisions

### 渲染方案：后处理 Shader
**选择：** 使用全屏后处理 Shader 实现 1-bit 效果
**原因：**
- 不需要修改每个材质
- 支持深度边缘检测
- Godot 4.6 Compatibility 模式完全支持

### 场景搭建：导入 3D 资产 (KayKit + Kenney)
**选择：** 使用 KayKit Restaurant Bits 和 Kenney Mini Characters
**原因：**
- 高质量 1-bit 兼容的美术资源
- 丰富的桌椅、吧台、角色模型
- 适合咖啡馆主题
- 支持网格对齐放置

**资产来源：**
- KayKit Restaurant Bits: 桌椅、吧台、柜台
- Kenney Mini Characters: 12 个顾客角色 (idle 动画)

### 物品交互：射线检测
**选择：** 使用 Camera3D 射线检测实现点击
**原因：**
- 标准 3D 点击交互方式
- 支持任意角度点击
- 与旋转系统兼容

## Risks / Trade-offs

**Risk:** 导入资产需要手动配置碰撞体和材质剥离
→ Mitigation: 创建 asset_import_config.gd 批量处理

**Risk:** GLTF 资源文件较大，首次导入较慢
→ Mitigation: 使用 Godot 的 .import 缓存，只需导入一次

**Risk:** 1-bit Shader 在低分辨率下效果不佳
→ Mitigation: 保持 1280x720 分辨率，抖动图案清晰可见
