local var0_0 = class("IslandSendDressUpMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForSendDress"
end

local var1_0 = {
	"white",
	"blue",
	"purple",
	"golden"
}

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.itemFrameTF = arg0_2._tf:Find("item/icon_bg/frame")
	arg0_2.itemIconTF = arg0_2._tf:Find("item/icon_bg/icon")
	arg0_2.ownNum = arg0_2._tf:Find("own/ownCount")
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings

	arg0_3:FlushDressItem(var0_3)
end

function var0_0.FlushDressItem(arg0_4, arg1_4)
	local var0_4 = pg.island_dress_template[arg1_4.configId]

	if var0_4.icon ~= "" then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var0_4.icon), "", arg0_4.itemIconTF)
	end

	if var0_4.quality ~= 0 then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var1_0[var0_4.quality]), "", arg0_4.itemFrameTF)
	end

	local var1_4 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	setText(arg0_4.ownNum, var1_4:GetOwnDressCountByDressId(arg1_4.configId))
end

return var0_0
