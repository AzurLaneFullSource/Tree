local var0_0 = class("WorkBenchItem", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_workbench_item
end

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.count = arg0_2.count or 0
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetRarity(arg0_4)
	return arg0_4:getConfig("rarity")
end

function var0_0.GetIconPath(arg0_5)
	return "props/" .. arg0_5:getConfig("icon")
end

function var0_0.GetDesc(arg0_6)
	return arg0_6:getConfig("display")
end

function var0_0.GetSource(arg0_7)
	return arg0_7:getConfig("get_access")
end

function var0_0.UpdateDrop(arg0_8, arg1_8, arg2_8)
	arg2_8 = arg2_8 or {}

	local var0_8 = ItemRarity.Rarity2Print(arg1_8:GetRarity())

	setImageSprite(findTF(arg0_8, "icon_bg"), GetSpriteFromAtlas("weaponframes", "bg" .. var0_8))
	setFrame(findTF(arg0_8, "icon_bg/frame"), var0_8)

	local var1_8 = findTF(arg0_8, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_8:GetIconPath(), "", var1_8)
	setIconStars(arg0_8, false)
	setIconName(arg0_8, arg1_8:GetName(), arg2_8)
	setIconColorful(arg0_8, arg1_8:GetRarity(), arg2_8)
end

return var0_0
