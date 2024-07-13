local var0_0 = class("AtelierFormulaCircle", import("model.vo.BaseVO"))

var0_0.TYPE = {
	BASE = 1,
	SAIREN = 3,
	NORMAL = 2,
	ANY = 4
}
var0_0.ELEMENT_TYPE = {
	PYRO = 1,
	SAIREN = 5,
	ELECTRO = 3,
	ANEMO = 4,
	CRYO = 2,
	ANY = 0
}
var0_0.ELEMENT_NAME = {}

for iter0_0, iter1_0 in pairs(var0_0.ELEMENT_TYPE) do
	var0_0.ELEMENT_NAME[iter1_0] = iter0_0
end

var0_0.ELEMENT_RING_COLOR = {
	[var0_0.ELEMENT_TYPE.ANY] = "FFFED5",
	[var0_0.ELEMENT_TYPE.PYRO] = "F74F41",
	[var0_0.ELEMENT_TYPE.CRYO] = "64CAFF",
	[var0_0.ELEMENT_TYPE.ELECTRO] = "FFDD3F",
	[var0_0.ELEMENT_TYPE.ANEMO] = "B0E860",
	[var0_0.ELEMENT_TYPE.SAIREN] = "AF97FF"
}

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_ryza_recipe_circle
end

function var0_0.GetConfigID(arg0_2)
	return arg0_2.configId
end

function var0_0.GetIconPath(arg0_3)
	return arg0_3:getConfig("icon")
end

function var0_0.GetType(arg0_4)
	return arg0_4:getConfig("type")
end

function var0_0.GetProp(arg0_5)
	return arg0_5:getConfig("prop")
end

function var0_0.GetElement(arg0_6)
	if arg0_6:GetType() == var0_0.TYPE.SAIREN then
		return var0_0.ELEMENT_TYPE.SAIREN
	elseif arg0_6:GetType() == var0_0.TYPE.ANY then
		return var0_0.ELEMENT_TYPE.ANY
	end

	return arg0_6:GetProp()
end

function var0_0.GetElementName(arg0_7)
	return var0_0.ELEMENT_NAME[arg0_7:GetElement()]
end

function var0_0.GetRingElement(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetElement()

	if arg0_8:GetType() == var0_0.TYPE.ANY and arg1_8 then
		if arg1_8:GetType() == AtelierMaterial.TYPE.SAIREN then
			var0_8 = var0_0.ELEMENT_TYPE.SAIREN
		else
			var0_8 = arg1_8:GetProps()[1]
		end
	end

	return var0_8
end

function var0_0.GetElementRingColor(arg0_9, arg1_9)
	local var0_9 = var0_0.ELEMENT_RING_COLOR[arg0_9:GetRingElement(arg1_9)]

	return SummerFeastScene.TransformColor(var0_9)
end

function var0_0.GetLevel(arg0_10)
	return arg0_10:getConfig("prop_level")
end

function var0_0.GetLimitItemID(arg0_11)
	return arg0_11:getConfig("ryza_item_id")
end

function var0_0.GetNeighbors(arg0_12)
	return arg0_12:getConfig("circle_connect")
end

function var0_0.GetFormulaId(arg0_13)
	return arg0_13:getConfig("recipe_id")
end

function var0_0.CanUseMaterial(arg0_14, arg1_14, arg2_14)
	local function var0_14()
		if arg2_14:GetProduction()[1] ~= DROP_TYPE_RYZA_DROP then
			return false
		end

		if arg2_14:GetProduction()[2] == arg1_14:GetConfigID() then
			return true
		end

		local var0_15 = AtelierMaterial.New({
			configId = arg2_14:GetProduction()[2]
		})

		return var0_15:GetType() == AtelierMaterial.TYPE.NEUTRALIZER and arg1_14:GetType() == AtelierMaterial.TYPE.NEUTRALIZER and var0_15:GetLevel() == arg1_14:GetLevel()
	end

	if arg0_14:GetType() == var0_0.TYPE.BASE or arg0_14:GetType() == var0_0.TYPE.SAIREN then
		return arg0_14:GetLimitItemID() == arg1_14:GetConfigID()
	elseif arg0_14:GetType() == var0_0.TYPE.NORMAL then
		if arg1_14:GetType() ~= AtelierMaterial.TYPE.NORMAL and arg1_14:GetType() ~= AtelierMaterial.TYPE.NEUTRALIZER then
			return false
		end

		if not table.contains(arg1_14:GetProps(), arg0_14:GetElement()) then
			return false
		end

		if var0_14() then
			return false
		end

		return arg1_14:GetLevel() == arg0_14:GetLevel()
	elseif arg0_14:GetType() == var0_0.TYPE.ANY then
		if arg1_14:GetType() ~= AtelierMaterial.TYPE.NORMAL and arg1_14:GetType() ~= AtelierMaterial.TYPE.NEUTRALIZER and arg1_14:GetType() ~= AtelierMaterial.TYPE.SAIREN then
			return false
		end

		if var0_14() then
			return false
		end

		return arg1_14:GetLevel() == arg0_14:GetLevel()
	end
end

return var0_0
