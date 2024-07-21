extends Resource

class_name ItemFromResource

enum Type {
	knife,
	beer,
	hat,
	tinCan,
	cheesee
}

@export var item_name: String
@export var type: Type
@export var texture: Texture2D

func get_type() -> Type:
	return type

func get_item_name() -> String:
	return item_name

func get_texture() -> Texture:
	if texture:
		if texture is AtlasTexture:
			var img := Image.new()
			var img_texture := ImageTexture.new()
			img = texture.get_image()
			img_texture = img_texture.create_from_image(img)
			return img_texture
		return texture
	return null
