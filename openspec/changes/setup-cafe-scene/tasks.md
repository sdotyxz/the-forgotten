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

- [ ] 3.1 创建 Tables 节点组
- [ ] 3.2 导入 KayKit Restaurant Bits 桌椅资源：
  - 双人桌：`table_small_A.gltf`, `table_small_B.gltf`
  - 四人桌：`table_large_A.gltf`, `table_large_B.gltf`
  - 椅子：`chair_A.gltf`, `chair_B.gltf`
- [ ] 3.3 放置4张双人桌（靠墙或窗边位置）
- [ ] 3.4 放置3-4张四人桌（中央区域）
- [ ] 3.5 为每张桌子添加对应数量的椅子（KayKit `chair_A.gltf` / `chair_B.gltf`）
- [ ] 3.6 调整桌子间距，避免过于拥挤

## 4. 顾客布置

- [ ] 4.1 创建 Customers 节点组
- [ ] 4.2 导入 Kenney Mini Characters 资源（选择7-8个不同变体）：
  - 男性：`character_male_A.gltf` ~ `character_male_F.gltf`
  - 女性：`character_female_A.gltf` ~ `character_female_F.gltf`
- [ ] 4.3 添加7-8个顾客 NPC（从上述文件中选择不同变体）
- [ ] 4.4 将顾客分配到不同桌子（部分桌子留空）
- [ ] 4.5 调整顾客朝向（面向桌子或咖啡馆内部）
- [ ] 4.6 为部分顾客添加站立姿势（可选）

## 5. 窗户装饰

- [ ] 5.1 在左侧墙壁位置创建窗户区域
- [ ] 5.2 添加窗户框架和玻璃
- [ ] 5.3 添加百叶窗装饰（可部分打开）
- [ ] 5.4 添加窗户透入的光线效果

## 6. 待找物品放置

- [ ] 6.1 创建 HiddenItems 节点组
- [ ] 6.2 放置手机（选择一张桌子的桌面）
- [ ] 6.3 放置书籍（可选择桌面或地面）
- [ ] 6.4 放置钥匙（选择一张桌子的角落）
- [ ] 6.5 确保所有物品在摄像机视角下可见

## 7. 场景优化

- [ ] 7.1 统一调整所有元素的层级关系（z-index 或 y-sort）
- [ ] 7.2 检查元素对齐和视觉协调
- [ ] 7.3 在 Godot 编辑器中预览场景
- [ ] 7.4 保存并提交场景文件
