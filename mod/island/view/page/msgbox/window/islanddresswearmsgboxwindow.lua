local var0_0 = class("IslandDressWearMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForDressWear"
end

local var1_0 = {
	"white",
	"blue",
	"purple",
	"golden"
}

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.dressRect = arg0_2._tf:Find("dress_container/dress"):GetComponent("LScrollRect")

	function arg0_2.dressRect.onUpdateItem(arg0_3, arg1_3)
		arg0_2:OnDressUpdateItem(arg0_3, arg1_3)
	end
end

function var0_0.OnShow(arg0_4)
	var0_0.super.OnShow(arg0_4)

	local var0_4 = arg0_4.settings

	arg0_4.dressRect:SetTotalCount(#arg0_4.settings.needconfirmDressList, 0)
end

function var0_0.OnDressUpdateItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg2_5.transform
	local var1_5 = arg0_5.settings.needconfirmDressList[arg1_5 + 1]
	local var2_5 = pg.island_dress_template[var1_5.dress_id]

	if var2_5.icon ~= "" then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var2_5.icon), "", var0_5:Find("icon"))
	end

	if var2_5.quality ~= 0 then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var1_0[var2_5.quality]), "", var0_5:Find("frame"))
	end

	local var3_5 = IslandShip.StaticGetPrefab(var1_5.ship_id)

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var3_5, "", var0_5:Find("shipHold/ship_icon"))
end

return var0_0
