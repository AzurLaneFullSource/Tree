local var0_0 = class("AtelierMaterial", import("model.vo.BaseVO"))

var0_0.TYPE = {
	STRENGTHEN = 5,
	SAIREN = 4,
	NORMAL = 1,
	NEUTRALIZER = 2,
	TOOL = 6,
	MOD = 3
}
var0_0.ELEMENT_TYPE = {
	CRYO = 2,
	SAIREN = 5,
	ELECTRO = 3,
	ANEMO = 4,
	PYRO = 1
}

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.count = arg0_1.count or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_ryza_item
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

function var0_0.GetType(arg0_7)
	return arg0_7:getConfig("type")
end

function var0_0.GetProps(arg0_8)
	return arg0_8:getConfig("prop")
end

function var0_0.GetLevel(arg0_9)
	return arg0_9:getConfig("prop_level")
end

function var0_0.GetSource(arg0_10)
	return arg0_10:getConfig("get_access")
end

function var0_0.GetBuffs(arg0_11)
	local var0_11 = arg0_11:getConfig("benefit_buff")

	return type(var0_11) == "table" and var0_11 or nil
end

function var0_0.GetVoices(arg0_12)
	return arg0_12:getConfig("got_voice")
end

local var1_0 = {
	1,
	1,
	1,
	0,
	0
}

function var0_0.GetBaseCircleTransform(arg0_13)
	local var0_13 = arg0_13:getConfig("base_circle")

	return type(var0_13) == "table" and var0_13 or var1_0
end

function var0_0.GetNormalCircleTransform(arg0_14)
	local var0_14 = arg0_14:getConfig("normal_circle")

	return type(var0_14) == "table" and var0_14 or var1_0
end

function var0_0.IsNormal(arg0_15)
	local var0_15 = arg0_15:GetType()

	return var0_15 == var0_0.TYPE.NORMAL or var0_15 == var0_0.TYPE.MOD or var0_15 == var0_0.TYPE.SAIREN
end

function var0_0.UpdateRyzaItem(arg0_16, arg1_16, arg2_16)
	arg2_16 = arg2_16 or {}

	local var0_16 = ItemRarity.Rarity2Print(arg1_16:GetRarity())

	setImageSprite(findTF(arg0_16, "icon_bg"), GetSpriteFromAtlas("weaponframes", "bg" .. var0_16))
	setFrame(findTF(arg0_16, "icon_bg/frame"), var0_16)

	local var1_16 = findTF(arg0_16, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_16:GetIconPath(), "", var1_16)
	setIconStars(arg0_16, false)
	setIconName(arg0_16, arg1_16:GetName(), arg2_16)
	setIconColorful(arg0_16, arg1_16:GetRarity(), arg2_16)
end

return var0_0
