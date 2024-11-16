pg = pg or {}

local var0_0 = pg

this = {}
var0_0.SpineCharCustomInfo = this
this.char_material_default_alpha = {}

function this.GetCharMaterial(arg0_1)
	local var0_1

	if table.contains(var0_0.SpineCharCustomInfo.char_material_default_alpha, arg0_1) then
		var0_1 = LoadAny("spinematerials", "CharDefaultAlpha", typeof(Material))
		var0_1.name = "SkeletonGraphicDefault"
	end

	return var0_1
end
