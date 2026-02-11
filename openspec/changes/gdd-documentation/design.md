# 技术设计：GDD 文档结构

## 1. 文档组织

```
GDD.md
├── 元信息（赛事/主题/周期/引擎/风格）
├── 核心概念（钩子）
├── 核心循环（流程）
├── 美术风格（表格）
├── 技术实现（关键文件）
├── 关卡设计（表格）
├── 开发范围（任务列表）
└── 项目结构（目录树）
```

## 2. 技术实现细节

### 2.1 1-bit 渲染方案
**方案选择：** 全屏后处理 Shader

**原因：**
- 最快实现：不改动模型资源
- 最稳效果：轮廓清晰，适合寻物
- Godot 4.6 完全支持

**实现要点：**
- ColorRect 全屏覆盖
- ShaderMaterial 应用后处理
- 深度纹理用于边缘检测
- Bayer 矩阵用于抖动

### 2.2 文件结构
```
assets/
├── shaders/
│   └── obra_dinn_postprocess.gdshader
├── scripts/
│   └── obra_dinn_camera.gd
└── materials/
    ├── black_material.tres
    └── white_material.tres
```

## 3. 关卡设计模板

每个关卡 YAML 格式：
```yaml
level_1:
  name: "空旷早晨"
  items_count: 3
  difficulty: easy
  items:
    - key: {position: [x,y,z], hidden_by: null}
    - phone: {position: [x,y,z], hidden_by: counter}
    - book: {position: [x,y,z], hidden_by: null}
```

## 4. 资源导入规范

### 4.1 KayKit 资源
- 格式：GLTF/GLB
- 处理：移除贴图，应用纯色材质
- 位置：assets/models/kaykit/

### 4.2 Kenney 资源
- 格式：GLB
- 处理：同上
- 位置：assets/models/kenney/

## 5. 命名规范
- 场景：cafe_level_01.tscn
- 脚本：snake_case.gd
- 材质：descriptive_name.tres
