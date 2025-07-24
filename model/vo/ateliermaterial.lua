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

function var0_0.GetCategory(arg0_13)
	return arg0_13:getConfig("prop_type")
end

function var0_0.GetVersion(arg0_14)
	return arg0_14:getConfig("version")
end

function var0_0.IsShow(arg0_15)
	return arg0_15:getConfig("is_show")
end

local var1_0 = {
	1,
	1,
	1,
	0,
	0
}

function var0_0.GetBaseCircleTransform(arg0_16)
	local var0_16 = arg0_16:getConfig("base_circle")

	return type(var0_16) == "table" and var0_16 or var1_0
end

function var0_0.GetNormalCircleTransform(arg0_17)
	local var0_17 = arg0_17:getConfig("normal_circle")

	return type(var0_17) == "table" and var0_17 or var1_0
end

function var0_0.IsNormal(arg0_18)
	local var0_18 = arg0_18:GetType()

	return var0_18 == var0_0.TYPE.NORMAL or var0_18 == var0_0.TYPE.MOD or var0_18 == var0_0.TYPE.SAIREN
end

function var0_0.UpdateRyzaItem(arg0_19, arg1_19, arg2_19)
	arg2_19 = arg2_19 or {}

	local var0_19 = ItemRarity.Rarity2Print(arg1_19:GetRarity())

	setImageSprite(findTF(arg0_19, "icon_bg"), GetSpriteFromAtlas("weaponframes", "bg" .. var0_19))
	setFrame(findTF(arg0_19, "icon_bg/frame"), var0_19)

	local var1_19 = findTF(arg0_19, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_19:GetIconPath(), "", var1_19)
	setIconStars(arg0_19, false)
	setIconName(arg0_19, arg1_19:GetName(), arg2_19)
	setIconColorful(arg0_19, arg1_19:GetRarity(), arg2_19)
end

return var0_0
