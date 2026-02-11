# 技术设计：核心游戏实现

## 1. 场景结构

```
Main (Node3D)
├── Camera3D
│   └── CameraController (脚本)
├── DirectionalLight3D
├── CafeEnvironment (Node3D)
│   └── Level1 (导入的场景)
├── Items (Node3D)
│   └── [Item1, Item2, ...] (可收集物品)
├── CanvasLayer
│   ├── UI (Control)
│   │   ├── ItemListContainer (Panel)
│   │   └── ResetButton (Button)
│   └── PostProcess (ColorRect + Shader)
└── GameManager (Node + 脚本)
```

## 2. 相机控制实现

### 2.1 方案选择
**轨道相机 (Orbit Camera)**
- 相机围绕场景中心旋转
- 保持高度和距离不变
- 仅 Y 轴旋转变化

### 2.2 关键代码结构
```gdscript
class_name CameraController
extends Camera3D

@export var rotation_sensitivity: float = 0.5
@export var smooth_speed: float = 10.0

var target_rotation: float = 0.0
var is_dragging: bool = false

func _input(event):
    if event is InputEventMouseMotion and is_dragging:
        target_rotation -= event.relative.x * rotation_sensitivity
```

## 3. 1-bit Shader 实现

### 3.1 方案
**后处理 Shader** (ColorRect 全屏覆盖)

### 3.2 Shader 结构
```glsl
shader_type canvas_item

uniform sampler2D screen_texture: hint_screen_texture
uniform sampler2D depth_texture: hint_depth_texture

// 边缘检测 + 抖动
void fragment() {
    // 1. 采样深度和颜色
    // 2. Sobel 边缘检测
    // 3. Bayer 抖动
    // 4. 输出黑白
}
```

### 3.3 高亮实现
- 使用额外的 Viewport 渲染层
- Shader 中检测高亮遮罩
- 反色效果

## 4. 物品交互

### 4.1 射线检测
```gdscript
func _input(event):
    if event is InputEventMouseButton and event.pressed:
        var mouse_pos = get_viewport().get_mouse_position()
        var ray = camera.project_ray(mouse_pos)
        # 射线检测碰撞
```

### 4.2 物品类
```gdscript
class_name CollectibleItem
extends Area3D

@export var item_name: String
signal item_clicked(item_name)
```

## 5. UI 实现

### 5.1 物品清单
- GridContainer 动态生成图标
- 收集后图标变灰/打勾

### 5.2 响应式布局
- 使用 Control 锚点系统
- 适配不同分辨率

## 6. 文件命名
- `camera_controller.gd`
- `collectible_item.gd`
- `item_manager.gd`
- `obra_dinn_postprocess.gdshader`
