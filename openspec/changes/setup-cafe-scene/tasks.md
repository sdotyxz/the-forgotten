## 1. 场景基础结构

- [x] 1.1 在 scenes/levels/ 目录创建 level_01_cafe.tscn 场景文件
- [x] 1.2 设置场景根节点（Node2D 或 Node3D，根据项目类型）
- [x] 1.3 配置摄像机位置和视角（俯视或斜45度视角）
- [x] 1.4 添加基础灯光（环境光 + 方向光/点光源）
- [x] 1.5 添加地板和墙壁基础几何体
- [x] 1.6 导入 KayKit Restaurant Bits 资源替换 CSG 几何体
  - 地板: floor_kitchen.gltf (缩放 10x)
  - 后墙: wall.gltf
  - 左墙: wall_window_closed.gltf
  - 右墙: wall.gltf

## 2. 吧台区域

- [x] 2.1 创建 BarArea 节点组
- [x] 2.2 导入 KayKit Restaurant Bits 吧台资源 (`counter.gltf`)
- [x] 2.3 添加收银台（使用 `counter.gltf` 或 Sprite 占位）
- [x] 2.4 添加咖啡机（使用 `coffee_machine.gltf` 或 Prototype Bits 占位）
- [x] 2.5 添加收银员 NPC（使用 Kenney `character_male_A.gltf`）
- [x] 2.6 调整吧台区域位置和大小

## 3. 桌椅布置

- [x] 3.1 创建 Tables 节点组
- [x] 3.2 导入 KayKit Restaurant Bits 桌椅资源（使用可用资源）：
  - 双人桌：使用 `table_round_A.gltf` 和 `table_medium.gltf` 缩放替代
  - 四人桌：使用 `table_medium.gltf` 放大替代
  - 椅子：使用 `Box_A.gltf` 和 `Box_B.gltf` 替代
- [x] 3.3 放置4张双人桌（靠墙或窗边位置）
- [x] 3.4 放置3张四人桌（中央区域）
- [x] 3.5 为每张桌子添加对应数量的椅子
- [x] 3.6 调整桌子间距，避免过于拥挤

## 4. 顾客布置

- [x] 4.1 创建 Customers 节点组
- [x] 4.2 导入 Kenney Mini Characters 资源（使用可用资源 `character-male-a.glb`）
- [x] 4.3 添加8个顾客 NPC（复用同一模型，不同位置和朝向）
- [x] 4.4 将顾客分配到不同桌子（部分桌子留空）
- [x] 4.5 调整顾客朝向（面向桌子或咖啡馆内部）
- [x] 4.6 为部分顾客添加站立姿势（1个站立）

## 5. 窗户装饰

- [x] 5.1 在左侧墙壁位置创建窗户区域
- [x] 5.2 添加窗户框架（使用缩放后的 Box 几何体）
- [x] 5.3 添加百叶窗装饰（使用缩放后的 Box_B 模拟）
- [x] 5.4 添加窗户透入的光线效果（DirectionalLight3D）

## 6. 待找物品放置

- [x] 6.1 创建 HiddenItems 节点组
- [x] 6.2 放置手机（在 Table1_Small 桌面，使用缩放 Box）
- [x] 6.3 放置书籍（在 Table4_Small 桌面，使用缩放 Box_B）
- [x] 6.4 放置钥匙（在 Table5_Large 桌面角落，使用缩放 Box）
- [x] 6.5 确保所有物品在摄像机视角下可见

## 7. 场景优化

- [x] 7.1 统一调整所有元素的层级关系（Node3D 层级结构已优化）
- [x] 7.2 检查元素对齐和视觉协调
- [x] 7.3 在 Godot 编辑器中预览场景
- [x] 7.4 保存并提交场景文件
