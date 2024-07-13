local var0_0 = class("EducateItem", import("model.vo.BaseVO"))

var0_0.TYPE_BOOK = 1
var0_0.TYPE_MUSICAL = 2
var0_0.TYPE_TOOL = 3
var0_0.TYPE_SUDRIES = 4
var0_0.RARITY2FRAME = {
	"rarity_grey",
	"rarity_green",
	"rarity_blue",
	"rarity_purple",
	"rarity_orange"
}
var0_0.USE_TYPE_UNDEFINED = "usage_undefined"
var0_0.USE_TYPE_DROP = "usage_drop"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.num or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_item
end

function var0_0.CanUse(arg0_3)
	return arg0_3:getConfig("usage") ~= var0_0.USE_TYPE_UNDEFINED
end

function var0_0.IsEnough(arg0_4, arg1_4)
	return arg1_4 <= arg0_4.count
end

function var0_0.Consume(arg0_5, arg1_5)
	arg0_5.count = arg0_5.count - arg1_5
end

function var0_0.AddCount(arg0_6, arg1_6)
	arg0_6.count = arg0_6.count + arg1_6
end

function var0_0.GetType(arg0_7)
	return arg0_7:getConfig("type")
end

function var0_0.GetIcon(arg0_8)
	return arg0_8:getConfig("icon")
end

function var0_0.GetName(arg0_9)
	return arg0_9:getConfig("name")
end

function var0_0.GetRarity(arg0_10)
	return arg0_10:getConfig("rarity")
end

function var0_0.GetFrameName(arg0_11)
	return var0_0.RARITY2FRAME[arg0_11:GetRarity()]
end

function var0_0.IsShow(arg0_12)
	return arg0_12:getConfig("is_show") == 1
end

function var0_0.GetShowInfo(arg0_13)
	return {
		type = EducateConst.DROP_TYPE_ITEM,
		id = arg0_13.id,
		number = arg0_13.count
	}
end

return var0_0
