pg = pg or {}

local var0_0 = pg

this = {}
var0_0.SpineCharCustomInfo = this
this.char_material_default_alpha = {}

function this.GetCharMaterial(arg0_1)
	local var0_1

	if table.contains(var0_0.SpineCharCustomInfo.char_material_default_alpha, arg0_1) then
		PoolMgr:GetInstance():LoadAsset("spinematerials", "CharDefaultAlpha", false, typeof(Material), function(arg0_2)
			var0_1 = arg0_2
		end, true)

		var0_1.name = "SkeletonGraphicDefault"
	end

	return var0_1
end
