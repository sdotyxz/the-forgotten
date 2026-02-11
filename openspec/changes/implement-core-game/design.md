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
- 不导入外部美术资源（使用 CSG 几何体）
- 不实现多关卡切换
- 不实现音效系统

## Decisions

### 渲染方案：后处理 Shader
**选择：** 使用全屏后处理 Shader 实现 1-bit 效果
**原因：**
- 不需要修改每个材质
- 支持深度边缘检测
- Godot 4.6 Compatibility 模式完全支持

### 场景搭建：CSGBox3D
**选择：** 使用 Godot 内置 CSG 几何体搭建场景
**原因：**
- 无需导入外部模型
- 快速原型验证
- 易于调整布局

### 物品交互：射线检测
**选择：** 使用 Camera3D 射线检测实现点击
**原因：**
- 标准 3D 点击交互方式
- 支持任意角度点击
- 与旋转系统兼容

## Risks / Trade-offs

**Risk:** CSG 几何体性能可能不如导入模型
→ Mitigation: 场景简单，物体数量少，性能影响可接受

**Risk:** 1-bit Shader 在低分辨率下效果不佳
→ Mitigation: 保持 1280x720 分辨率，抖动图案清晰可见
