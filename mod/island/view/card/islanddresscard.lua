local var0_0 = class("IslandDressCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.selectGos = {
		arg0_1.tf:Find("select")
	}
end

local var1_0 = {
	"white",
	"blue",
	"purple",
	"golden"
}

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.configId = arg1_2

	local var0_2 = pg.island_dress_template[arg1_2]

	arg0_2.configType = var0_2.type

	setText(arg0_2.tf:Find("Text"), var0_2.name)

	if var0_2.icon ~= "" then
		GetImageSpriteFromAtlasAsync(string.format("IslandDressIcon/%s", var0_2.icon), "", arg0_2.tf:Find("icon"))
	end

	if var0_2.quality ~= 0 then
		GetImageSpriteFromAtlasAsync(string.format("IslandDressIcon/%s", var1_0[var0_2.quality]), "", arg0_2.tf:Find("frame"))
	end

	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.FlushRedDot(arg0_3)
	setActive(arg0_3.redDot, arg0_3.ship and arg0_3.ship:CanUpgradeMainSkill())
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	local var0_4 = arg1_4 == arg0_4.configId

	for iter0_4, iter1_4 in ipairs(arg0_4.selectGos) do
		setActive(iter1_4, var0_4)
	end
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
