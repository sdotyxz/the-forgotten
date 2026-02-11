extends SceneTree

var start_time = 0
const TARGET_DURATION = 10.0  # 录制10秒

func _init():
    start_time = Time.get_ticks_msec()
    print("🎬 咖啡馆场景录制开始")
    call_deferred("start_game")

func start_game():
    # 1. 加载场景
    var scene = preload("res://scenes/levels/level_01_cafe.tscn").instantiate()
    root.add_child(scene)
    
    print("✅ 场景加载完成")
    await wait(1.0)  # 等待场景初始化
    
    # 2. 旋转摄像机展示场景
    var camera = scene.get_node("Camera3D")
    if camera:
        print("📹 开始旋转展示...")
        await rotate_camera(camera, scene)
    
    # 3. 填充剩余时间
    var remaining = get_remaining_time()
    if remaining > 0:
        print("⏱️ 等待剩余时间...")
        await wait(remaining)
    
    print("✅ 录制完成")
    quit()

func rotate_camera(camera: Camera3D, scene: Node3D):
    # 围绕场景中心旋转
    var center = Vector3(0, 0, 0)
    var radius = 14.14  # sqrt(10^2 + 10^2) 保持与摄像机原位置相同距离
    var height = 10.0
    
    # 从 45度 旋转到 225度
    var start_angle = PI / 4  # 45度
    var end_angle = 5 * PI / 4  # 225度 (额外180度)
    var steps = 120  # 2秒 @ 60fps
    
    for i in range(steps):
        var t = float(i) / float(steps)
        var angle = start_angle + (end_angle - start_angle) * t
        
        camera.position = Vector3(
            radius * cos(angle),
            height,
            radius * sin(angle)
        )
        camera.look_at(center, Vector3.UP)
        
        await process_frame
    
    print("📹 旋转完成")

func get_remaining_time() -> float:
    var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
    return max(0, TARGET_DURATION - elapsed)

func wait(sec: float):
    await create_timer(sec).timeout
