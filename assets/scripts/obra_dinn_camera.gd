class_name ObraDinnCamera
extends Camera3D

## Obra Dinn 风格 1-bit 后处理相机
## 计算相机射线并传递给后处理 shader

@export var post_process_material: ShaderMaterial
@export var tiling: float = 192.0:
    set(value):
        tiling = value
        _update_shader_params()
@export var edge_threshold: float = 0.1:
    set(value):
        edge_threshold = value
        _update_shader_params()
@export var invert_colors: bool = false:
    set(value):
        invert_colors = value
        _update_shader_params()

func _ready():
    _setup_post_process()
    _update_shader_params()

func _setup_post_process():
    """设置后处理层"""
    # 创建 CanvasLayer
    var canvas_layer = CanvasLayer.new()
    canvas_layer.name = "PostProcessLayer"
    add_child(canvas_layer)
    
    # 创建全屏 ColorRect
    var color_rect = ColorRect.new()
    color_rect.name = "PostProcessRect"
    color_rect.anchor_right = 1.0
    color_rect.anchor_bottom = 1.0
    color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
    canvas_layer.add_child(color_rect)
    
    # 如果没有提供材质，创建默认材质
    if post_process_material == null:
        var shader = load("res://assets/shaders/obra_dinn_postprocess.gdshader")
        post_process_material = ShaderMaterial.new()
        post_process_material.shader = shader
        
        # 加载默认纹理
        var dither_texture = _create_bayer_texture()
        post_process_material.set_shader_parameter("dither_texture", dither_texture)
    
    color_rect.material = post_process_material

func _create_bayer_texture() -> ImageTexture:
    """创建 Bayer 4x4 抖动纹理"""
    var bayer_data = [
        0, 8, 2, 10,
        12, 4, 14, 6,
        3, 11, 1, 9,
        15, 7, 13, 5
    ]
    
    var img = Image.create(4, 4, false, Image.FORMAT_L8)
    for y in range(4):
        for x in range(4):
            var val = float(bayer_data[y * 4 + x]) / 16.0
            img.set_pixel(x, y, Color(val, val, val))
    
    return ImageTexture.create_from_image(img)

func _update_shader_params():
    """更新 shader 参数"""
    if post_process_material:
        post_process_material.set_shader_parameter("tiling", tiling)
        post_process_material.set_shader_parameter("edge_threshold", edge_threshold)
        post_process_material.set_shader_parameter("invert_colors", invert_colors)

func _process(_delta):
    """每帧更新相机射线"""
    if post_process_material == null:
        return
    
    # 计算视锥体四个角的射线方向
    var bl = _get_ray_direction(0.0, 0.0)
    var tl = _get_ray_direction(0.0, 1.0)
    var tr = _get_ray_direction(1.0, 1.0)
    var br = _get_ray_direction(1.0, 0.0)
    
    # 传入 shader
    post_process_material.set_shader_parameter("bl_ray", bl)
    post_process_material.set_shader_parameter("tl_ray", tl)
    post_process_material.set_shader_parameter("tr_ray", tr)
    post_process_material.set_shader_parameter("br_ray", br)

func _get_ray_direction(x: float, y: float) -> Vector3:
    """
    根据视口坐标 (0-1) 获取世界空间的射线方向
    等同于 Unity 的 camera.ViewportPointToRay
    """
    # 将视口坐标转换为 NDC (-1 到 1)
    var ndc_x = x * 2.0 - 1.0
    var ndc_y = (1.0 - y) * 2.0 - 1.0  # Y 轴翻转
    
    # 构建 NDC 空间中的点 (在远平面上)
    var ndc_point = Vector3(ndc_x, ndc_y, 1.0)
    
    # 获取投影矩阵
    var proj_matrix = get_camera_projection()
    
    # NDC 转视图空间
    var view_point = proj_matrix.inverse() * Vector4(ndc_point.x, ndc_point.y, ndc_point.z, 1.0)
    view_point = Vector3(view_point.x, view_point.y, view_point.z) / view_point.w
    
    # 视图空间转世界空间
    var world_point = global_transform * view_point
    
    # 射线方向
    return (world_point - global_position).normalized()

func get_camera_projection() -> Projection:
    """获取相机的投影矩阵"""
    if projection == PROJECTION_ORTHOGONAL:
        return Projection.create_orthogonal(-size, size, -size, size, near, far)
    else:
        var fov_rad = deg_to_rad(fov)
        return Projection.create_perspective(fov_rad, get_viewport().get_visible_rect().size.x / get_viewport().get_visible_rect().size.y, near, far)

# 编辑器调试
func _get_configuration_warnings() -> PackedStringArray:
    var warnings = PackedStringArray()
    
    if projection != PROJECTION_ORTHOGONAL:
        warnings.append("推荐使用正交投影 (Orthogonal) 以获得最佳 1-bit 效果")
    
    return warnings
