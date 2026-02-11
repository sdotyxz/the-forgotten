# 1-bit Obra Dinn 风格渲染使用说明

## 快速开始

### 1. 基础设置

创建场景结构：
```
MainScene
├── Camera3D
│   └── ObraDinnCamera (脚本)
└── CafeEnvironment (你的咖啡馆场景)
```

### 2. 相机设置

给 Camera3D 添加 `ObraDinnCamera.gd` 脚本：

```gdscript
# 在 Camera3D 的脚本中
extends ObraDinnCamera

func _ready():
    super._ready()
    # 自定义参数
    tiling = 192.0
    edge_threshold = 0.1
    invert_colors = false
```

### 3. 项目设置

必须启用深度缓冲：
```
项目设置 → 渲染 → 质量 → 驱动 → 深度 prepass: 启用
```

## Shader 参数说明

### obra_dinn_postprocess.gdshader

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `tiling` | float | 192.0 | 抖动纹理重复次数，值越大图案越小 |
| `edge_threshold` | float | 0.1 | 边缘检测敏感度，越小边缘越明显 |
| `depth_threshold` | float | 0.1 | 深度阈值，判断前后关系 |
| `use_cube_projection` | bool | true | 使用 3D 立方体投影（推荐） |
| `invert_colors` | bool | false | 反转黑白 |

### 射线方向参数（自动计算）

以下参数由 `ObraDinnCamera` 脚本每帧自动更新：
- `bl_ray`: 左下角射线方向
- `tl_ray`: 左上角射线方向
- `tr_ray`: 右上角射线方向
- `br_ray`: 右下角射线方向

## 自定义抖动纹理

### 方法 1: 使用内置 Bayer（默认）
脚本会自动创建 4x4 Bayer 矩阵纹理。

### 方法 2: 使用蓝噪声纹理
```gdscript
var blue_noise = load("res://assets/textures/blue_noise.png")
$Camera3D.post_process_material.set_shader_parameter("dither_texture", blue_noise)
```

### 方法 3: 创建自己的抖动纹理
推荐尺寸：64x64 或 128x128
- 灰度图
- 噪点分布均匀
- 避免明显图案

## 故障排除

### 画面全是黑/白
1. 检查深度缓冲是否启用
2. 调整 `edge_threshold` 和 `depth_threshold`
3. 检查相机 `near` 和 `far` 设置

### 边缘不明显
- 降低 `edge_threshold` (如 0.05)
- 确保物体有足够深度差异

### 抖动图案太大/太小
- 调整 `tiling` 参数 (32-512)

### 性能问题
- 降低渲染分辨率
- 关闭抗锯齿
- 减少场景复杂度

## 进阶：手动设置后处理

如果不想用 `ObraDinnCamera` 脚本，可以手动设置：

```gdscript
# 创建 CanvasLayer
var layer = CanvasLayer.new()
add_child(layer)

# 创建 ColorRect
var rect = ColorRect.new()
rect.anchor_right = 1.0
rect.anchor_bottom = 1.0
layer.add_child(rect)

# 设置材质
var shader = load("res://assets/shaders/obra_dinn_postprocess.gdshader")
var material = ShaderMaterial.new()
material.shader = shader
rect.material = material

# 手动传入射线（每帧更新）
material.set_shader_parameter("bl_ray", Vector3(-0.5, -0.5, -1))
material.set_shader_parameter("tl_ray", Vector3(-0.5, 0.5, -1))
material.set_shader_parameter("tr_ray", Vector3(0.5, 0.5, -1))
material.set_shader_parameter("br_ray", Vector3(0.5, -0.5, -1))
```

## 参考

- 原始教程：https://www.youtube.com/watch?v=Ap4fXGTOb7I
- GitHub：https://github.com/Madalaski/ObraDinnTutorial
- Obra Dinn GDC 演讲：https://www.youtube.com/watch?v=5ZgZ9I4T6Yc
