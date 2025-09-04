local var0_0 = class("IslandCustomerHudPanel", import("Mod.Island.Core.View.IslandBaseHudPanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandCustomerHud"
end

function var0_0.OnInit(arg0_2)
	arg0_2.hudImage = arg0_2._tf:Find("hudImage")
	arg0_2.unitPosition = pg.island_world_objects[arg0_2.unitId].param.position
	arg0_2.images = pg.island_set.island_manage_bubble_resource.key_value_varchar
	arg0_2.durations = pg.island_set.island_manage_bubble_duration.key_value_varchar
	arg0_2.cds = pg.island_set.island_manage_bubble_cd.key_value_varchar

	GetImageSpriteFromAtlasAsync(arg0_2.images[math.random(#arg0_2.images)], "", arg0_2.hudImage)

	arg0_2.timer = Timer.New(function()
		arg0_2.active = not arg0_2.active

		if arg0_2.active then
			GetImageSpriteFromAtlasAsync(arg0_2.images[math.random(#arg0_2.images)], "", arg0_2.hudImage)

			arg0_2.timer.duration = math.random(arg0_2.durations[1], arg0_2.durations[2])
		else
			arg0_2.timer.duration = math.random(arg0_2.cds[1], arg0_2.cds[2])
		end
	end, math.random(arg0_2.durations[1], arg0_2.durations[2]), -1)

	arg0_2.timer:Start()
end

function var0_0.OnDispose(arg0_4)
	arg0_4.timer:Stop()

	arg0_4.timer = nil

	var0_0.super.OnDispose(arg0_4)
end

return var0_0
