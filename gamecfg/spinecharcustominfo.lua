pg = pg or {}

local var0 = pg

this = {}
var0.SpineCharCustomInfo = this
this.char_material_default_alpha = {}

function this.GetCharMaterial(arg0)
	local var0

	if table.contains(var0.SpineCharCustomInfo.char_material_default_alpha, arg0) then
		PoolMgr:GetInstance():LoadAsset("spinematerials", "CharDefaultAlpha", false, typeof(Material), function(arg0)
			var0 = arg0
		end, false)

		var0.name = "SkeletonGraphicDefault"
	end

	return var0
end
