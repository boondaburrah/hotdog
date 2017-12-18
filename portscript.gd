extends Spatial

var viewTex = Texture
var playerstats
var playerdiff

func _process(delta):
	self.playerdiff = self.get_global_transform().origin - self.playerstats.playerPos
	self.viewTex = self.get_node("outpoint/Viewport").get_render_target_texture()
	

func _ready():
	self.playerstats = self.get_node("/root/playerstats")
	self.get_node("inpoint").get_material_override().set_texture(FixedMaterial.PARAM_DIFFUSE, self.viewTex)