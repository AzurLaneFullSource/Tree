local var0 = class("EducateItem", import("model.vo.BaseVO"))

var0.TYPE_BOOK = 1
var0.TYPE_MUSICAL = 2
var0.TYPE_TOOL = 3
var0.TYPE_SUDRIES = 4
var0.RARITY2FRAME = {
	"rarity_grey",
	"rarity_green",
	"rarity_blue",
	"rarity_purple",
	"rarity_orange"
}
var0.USE_TYPE_UNDEFINED = "usage_undefined"
var0.USE_TYPE_DROP = "usage_drop"

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.count = arg1.num or 0
end

function var0.bindConfigTable(arg0)
	return pg.child_item
end

function var0.CanUse(arg0)
	return arg0:getConfig("usage") ~= var0.USE_TYPE_UNDEFINED
end

function var0.IsEnough(arg0, arg1)
	return arg1 <= arg0.count
end

function var0.Consume(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.AddCount(arg0, arg1)
	arg0.count = arg0.count + arg1
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetIcon(arg0)
	return arg0:getConfig("icon")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetFrameName(arg0)
	return var0.RARITY2FRAME[arg0:GetRarity()]
end

function var0.IsShow(arg0)
	return arg0:getConfig("is_show") == 1
end

function var0.GetShowInfo(arg0)
	return {
		type = EducateConst.DROP_TYPE_ITEM,
		id = arg0.id,
		number = arg0.count
	}
end

return var0
