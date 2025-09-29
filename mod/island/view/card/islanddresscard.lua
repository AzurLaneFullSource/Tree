local var0_0 = class("IslandDressCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.selectGos = {
		arg0_1.tf:Find("select")
	}
	arg0_1.canSendTF = arg0_1.tf:Find("canSend")
	arg0_1.ownNumTF = arg0_1.tf:Find("icon/count_bg")
	arg0_1.ownNumText = arg0_1.ownNumTF:Find("count")
	arg0_1.redDot = arg0_1.tf:Find("red_dot")
	arg0_1.shipHoldTF = arg0_1.tf:Find("shipHold")
	arg0_1.shipIcon = arg0_1.shipHoldTF:Find("ship_icon")
	arg0_1.exclusionTF = arg0_1.tf:Find("exclusion_item")
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

	setScrollText(arg0_2.tf:Find("textMask/Text"), var0_2.name)

	if var0_2.icon ~= "" then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var0_2.icon), "", arg0_2.tf:Find("icon"))
	end

	if var0_2.quality ~= 0 then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var1_0[var0_2.quality]), "", arg0_2.tf:Find("frame"))
	end

	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.selectGos) do
		setActive(iter1_3, arg1_3)
	end
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
