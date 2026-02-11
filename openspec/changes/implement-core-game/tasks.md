# 任务列表

## 1. 搭建测试场景

### 1.1 创建主场景基础
- [ ] 1.1.1 创建 main.tscn 主场景
- [ ] 1.1.2 添加等距相机 (isometric camera: -30°, 45°)
- [ ] 1.1.3 设置三点灯光系统 (key light, fill light, rim light)
- [ ] 1.1.4 配置 Godot 项目渲染设置 (Mobile 模式、深度缓冲)

### 1.2 导入并配置 KayKit Restaurant Bits
- [ ] 1.2.1 从 KayKit/Restaurant_Bits/Assets/gltf/ 导入资源
  - chair_A.gltf, chair_B.gltf (椅子)
  - table_A.gltf, table_B.gltf (桌子)
  - counter.gltf, bar_A.gltf (吧台)
- [ ] 1.2.2 为每个模型创建简化碰撞体 (Box/Convex)
- [ ] 1.2.3 移除默认材质 (使用 1-bit shader 统一处理)
- [ ] 1.2.4 创建 asset_import_config.gd - 批量导入设置

### 1.3 放置餐厅布局 (网格对齐)
- [ ] 1.3.1 创建场景布局节点结构
- [ ] 1.3.2 放置 2x 双人桌 + 2x 四人桌 (网格对齐)
- [ ] 1.3.3 放置吧台 counter (2 段组合)
- [ ] 1.3.4 添加地面网格/地板
- [ ] 1.3.5 应用 PhysicsMaterial (friction=1, rough=true)

### 1.4 导入并配置 Kenney Mini Characters
- [ ] 1.4.1 从 kenney_mini-characters/Models/GLTF format/ 导入
  - character_male_a.gltf ~ character_male_f
  - character_female_a.gltf ~ character_female_f
- [ ] 1.4.2 创建 customer_spawner.gd - 顾客生成器
- [ ] 1.4.3 创建 customer_animation_tree.tres - 闲置动画
- [ ] 1.4.4 放置 3 个就座顾客 (idle 循环)

### 1.5 放置测试物品
- [ ] 1.5.1 创建 3 个可收集物品 (钥匙、手机、书籍)
- [ ] 1.5.2 为每个物品添加 Area3D 碰撞体
- [ ] 1.5.3 设置物品的可见性/隐藏逻辑

## 2. 1-bit 渲染

- [ ] 2.1 创建 obra_dinn_postprocess.gdshader
- [ ] 2.2 实现深度边缘检测 (Sobel)
- [ ] 2.3 实现 Bayer 4x4 抖动
- [ ] 2.4 在测试场景验证纯黑白输出

## 3. 相机控制

- [ ] 3.1 创建 camera_controller.gd
- [ ] 3.2 实现后处理自动设置
- [ ] 3.3 实现鼠标拖动旋转
- [ ] 3.4 实现 R 键重置视角

## 4. 游戏管理器

- [ ] 4.1 创建 game_manager.gd
- [ ] 4.2 实现关卡数据配置
- [ ] 4.3 实现物品收集逻辑
- [ ] 4.4 实现关卡完成检测

## 5. 可收集物品

- [ ] 5.1 创建 collectible_item.gd
- [ ] 5.2 添加 Area3D 碰撞体
- [ ] 5.3 实现射线检测交互
- [ ] 5.4 实现点击收集反馈

## 6. UI 实现

- [ ] 6.1 添加物品清单 UI
- [ ] 6.2 添加进度显示
- [ ] 6.3 添加操作提示

## 7. 集成测试

- [ ] 7.1 测试完整游戏流程
- [ ] 7.2 验证 60 FPS 性能
- [ ] 7.3 修复发现的问题
