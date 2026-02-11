# 技术设计

## 1. 文件结构

```
godot-project/
├── project.godot
├── scenes/
│   └── main.tscn          # 主场景（相机+环境+UI）
├── scripts/
│   ├── camera_controller.gd    # 相机旋转+后处理设置
│   ├── game_manager.gd         # 游戏状态管理
│   └── collectible_item.gd     # 可收集物品
└── assets/
    └── shaders/
        └── obra_dinn_postprocess.gdshader  # 1-bit 后处理
```

## 2. 1-bit 渲染实现

### 2.1 Shader 方案
- 类型：`canvas_item`
- 输入：`screen_texture`, `depth_texture`
- 算法：
  1. Sobel 边缘检测（基于深度）
  2. Bayer 4×4 抖动
  3. 阈值判断输出黑白

### 2.2 后处理设置
- CanvasLayer + ColorRect 全屏覆盖
- ShaderMaterial 应用 Shader
- 自动在 `_ready()` 中创建

## 3. 相机控制

### 3.1 轨道旋转
- 围绕场景中心 Y 轴旋转
- 保持高度和距离不变
- 等距角度：X=-30°, Y=45° + 旋转偏移

### 3.2 输入处理
- `InputEventMouseMotion` - 拖动旋转
- `KEY_R` - 重置

## 4. 物品交互

### 4.1 射线检测
```gdscript
var mouse_pos = get_viewport().get_mouse_position()
var from = camera.project_ray_origin(mouse_pos)
var to = from + camera.project_ray_normal(mouse_pos) * 1000
var query = PhysicsRayQueryParameters3D.create(from, to)
var result = space_state.intersect_ray(query)
```

### 4.2 物品类
- `Area3D` 碰撞体
- `item_name` 属性
- `collected` 状态

## 5. 场景搭建

### 5.1 使用 CSGBox3D
- 地板：20×1×20，白色
- 桌子：2×1×2，黑色
- 椅子：1×0.5×1，黑色
- 吧台/装饰：简单几何体

### 5.2 物品放置
- 钥匙：桌上
- 手机：吧台后
- 书籍：角落

## 6. UI 设计

- 顶部：物品清单（图标+名称）
- 底部：操作提示文字
- 进度：X/3 显示
