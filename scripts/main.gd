extends Node3D

# Part 1 blockout: simple geometry only; art and gameplay come later.
func _ready() -> void:
	_build_shop()
	_build_lighting()


func _build_shop() -> void:
	_add_box("Floor", Vector3(0, -0.2, 0), Vector3(16, 0.4, 16), Color("#55545a"))
	_add_box("BackWall", Vector3(0, 2.0, -8), Vector3(16, 4, 0.35), Color("#55505a"))
	_add_box("LeftWall", Vector3(-8, 2.0, 0), Vector3(0.35, 4, 16), Color("#4c515b"))
	_add_box("RightWall", Vector3(8, 2.0, 0), Vector3(0.35, 4, 16), Color("#4c515b"))

	# Two low-poly shelf rows with colored placeholder goods.
	for row in range(2):
		var z := -2.8 + float(row) * 4.2
		_add_box("Shelf_%d_Base" % row, Vector3(0, 0.75, z), Vector3(5.8, 1.5, 1.25), Color("#806448"))
		_add_box("Shelf_%d_Top" % row, Vector3(0, 1.65, z), Vector3(6.0, 0.12, 1.4), Color("#b18a5d"))
		for item in range(5):
			var x := -2.2 + float(item) * 1.1
			var tint := [Color("#b84f49"), Color("#d3ad4e"), Color("#5a9b78"), Color("#668bb8"), Color("#b078a7")][item]
			_add_box("Placeholder_%d_%d" % [row, item], Vector3(x, 2.05, z), Vector3(0.65, 0.65, 0.72), tint)

	# Checkout counter near the entrance.
	_add_box("Checkout", Vector3(-4.7, 0.65, 5.1), Vector3(2.2, 1.3, 1.4), Color("#72533f"))


func _build_lighting() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "MainLight"
	sun.rotation_degrees = Vector3(-48, -32, 0)
	sun.light_energy = 0.85
	sun.shadow_enabled = true
	add_child(sun)

	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#78808f")
	env.ambient_light_energy = 0.45
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.environment = env
	add_child(environment)


func _add_box(node_name: String, position: Vector3, dimensions: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position
	add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.92
	mesh.material = material
	mesh_instance.mesh = mesh
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
