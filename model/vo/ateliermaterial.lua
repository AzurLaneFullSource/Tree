local var0 = class("AtelierMaterial", import("model.vo.BaseVO"))

var0.TYPE = {
	STRENGTHEN = 5,
	SAIREN = 4,
	NORMAL = 1,
	NEUTRALIZER = 2,
	TOOL = 6,
	MOD = 3
}
var0.ELEMENT_TYPE = {
	CRYO = 2,
	SAIREN = 5,
	ELECTRO = 3,
	ANEMO = 4,
	PYRO = 1
}

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.count = arg0.count or 0
end

function var0.bindConfigTable(arg0)
	return pg.activity_ryza_item
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetIconPath(arg0)
	return "props/" .. arg0:getConfig("icon")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("display")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetProps(arg0)
	return arg0:getConfig("prop")
end

function var0.GetLevel(arg0)
	return arg0:getConfig("prop_level")
end

function var0.GetSource(arg0)
	return arg0:getConfig("get_access")
end

function var0.GetBuffs(arg0)
	local var0 = arg0:getConfig("benefit_buff")

	return type(var0) == "table" and var0 or nil
end

function var0.GetVoices(arg0)
	return arg0:getConfig("got_voice")
end

local var1 = {
	1,
	1,
	1,
	0,
	0
}

function var0.GetBaseCircleTransform(arg0)
	local var0 = arg0:getConfig("base_circle")

	return type(var0) == "table" and var0 or var1
end

function var0.GetNormalCircleTransform(arg0)
	local var0 = arg0:getConfig("normal_circle")

	return type(var0) == "table" and var0 or var1
end

function var0.IsNormal(arg0)
	local var0 = arg0:GetType()

	return var0 == var0.TYPE.NORMAL or var0 == var0.TYPE.MOD or var0 == var0.TYPE.SAIREN
end

function var0.UpdateRyzaItem(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = ItemRarity.Rarity2Print(arg1:GetRarity())

	setImageSprite(findTF(arg0, "icon_bg"), GetSpriteFromAtlas("weaponframes", "bg" .. var0))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1:GetIconPath(), "", var1)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:GetName(), arg2)
	setIconColorful(arg0, arg1:GetRarity(), arg2)
end

return var0
