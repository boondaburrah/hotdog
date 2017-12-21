extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _input(event):
	if event.is_action("ui_cancel"):
		print("quit requested")
		self.get_tree().quit()

func _ready():
	var portal_in = self.get_node("portin")
	var portal_out= self.get_node("portout")
	var portal_out_pos = portal_out.get_transform().origin - portal_in.get_transform().origin
	var portal_out_rot = portal_out.get_rotation() - portal_in.get_rotation()
	self.set_process_input(true)
	self.get_node("PortalRoot").set_transform(portal_in.get_transform())
	self.get_node("PortalRoot/outpoint").set_translation(portal_out_pos)
	self.get_node("PortalRoot/outpoint").set_rotation(portal_out_rot)
	#self.get_node("PortalRoot/outpoint").set_transform(
	#	Transform(
	#		# portal_in.get_transform().basis, # FIXME: not handling rotation portal exit
	#		portal_out.get_transform().basis,
	#		portal_in.get_transform().origin + portal_out.get_transform().origin))