## Context

本项目是 Godot 引擎开发的寻找隐藏物品游戏。需要为第一关"空旷早晨"搭建咖啡馆场景，作为教学关卡让玩家熟悉核心玩法。场景为纯静态展示，不需要交互功能。

**美术资源清单（来自 GDD）：**
- **KayKit Restaurant Bits**: 桌椅、吧台、餐具
- **KayKit Prototype Bits**: 基础几何、容器
- **Kenney Mini Characters**: 顾客

## Goals / Non-Goals

**Goals:**
- 创建完整的咖啡馆场景节点结构
- 配置吧台、桌椅、顾客、窗户和待找物品
- 设置合适的摄像机视角和灯光
- 确保场景在 Godot 编辑器中正确显示

**Non-Goals:**
- 不实现交互功能（点击、寻物逻辑等）
- 不添加动画或特效
- 不涉及游戏逻辑代码

## Decisions

**美术资源选择**：使用 KayKit 和 Kenney 资源包

| 物件类型 | 资源包 | 具体文件 |
|---------|--------|---------|
| **双人桌** | KayKit Restaurant Bits | `table_small_A.gltf` / `table_small_B.gltf` |
| **四人桌** | KayKit Restaurant Bits | `table_large_A.gltf` / `table_large_B.gltf` |
| **椅子** | KayKit Restaurant Bits | `chair_A.gltf` / `chair_B.gltf` |
| **吧台** | KayKit Restaurant Bits | `counter.gltf` |
| **咖啡机** | KayKit Restaurant Bits | `coffee_machine.gltf` 或 Prototype Bits |
| **餐具/容器** | KayKit Restaurant Bits | `cup_A.gltf`, `plate_A.gltf` |
| **收银员 NPC** | Kenney Mini Characters | `character_male_A.gltf` |
| **顾客 NPC** | Kenney Mini Characters | `character_male_*.gltf`, `character_female_*.gltf` (7-8个不同变体) |

- **理由**: 与 GDD 定义的美术风格一致，1-bit 黑白风格兼容

**场景组织方式**：使用 Godot 的 Node2D/Node3D 层级结构组织场景
- 根节点：CafeScene (Node2D/Node3D)
- 子节点分组：BarArea, Tables, Customers, Windows, HiddenItems
- 理由：清晰的层级便于后期添加交互和动画

**桌子布局**：采用分散式布局，模拟真实咖啡馆
- 双人桌：4张（靠墙或窗边）
- 四人桌：3-4张（中央区域）
- 理由：提供视觉多样性，为待找物品创造不同隐藏位置

**顾客位置**：
- 部分顾客坐在桌前
- 部分顾客站立或走动（静态）
- 理由：增加场景活力，营造咖啡馆氛围

**待找物品分布**：
- 手机：放置在桌面显眼位置
- 书籍：可能放在桌上或地面
- 钥匙：较小物品，可放在桌面角落
- 理由：作为教学关卡，物品应易于发现

**摄像机配置**：
- **投影模式**: 正交投影（Orthographic）
- **视角**: 等距视角，-30° 俯仰角 + 45° 水平旋转
- **位置**: (10, 10, 10) 世界坐标，看向原点
- **Size**: 15（视口大小，覆盖整个咖啡馆）
- **理由**: 等距视角是 GDD 定义的核心美术风格，便于玩家观察场景全貌

**灯光系统**（三点布光）：
- **主光源（Key Light）**: DirectionalLight3D
  - 位置: 右上角 (10, 10, 5)
  - 强度: 1.0
  - 产生主要阴影，定义物体体积感
- **补光（Fill Light）**: DirectionalLight3D 或 OmniLight3D
  - 位置: 左侧 (-5, 5, 5)
  - 强度: 0.4
  - 柔化阴影，防止纯黑区域
- **轮廓光（Rim Light）**: DirectionalLight3D
  - 位置: 后方 (0, 5, -10)
  - 强度: 0.6
  - 突出物体边缘，增强 1-bit 边缘检测效果
- **阴影**: 所有灯光启用 shadow_enabled = true
- **理由**: 三点布光是标准做法，阴影用于 1-bit Shader 的深度边缘检测

## Risks / Trade-offs

**素材依赖** → 使用占位图形或简单几何体，等待美术资源
**场景性能** → 静态场景性能开销低，无需优化
**后期扩展** → 预留交互节点结构，方便后续添加功能
