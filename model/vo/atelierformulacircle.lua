local var0_0 = class("AtelierFormulaCircle", import("model.vo.BaseVO"))

var0_0.TYPE = {
	ELEMENT = 6,
	SAIREN = 3,
	ELEMENT_CATEGORY = 8,
	BASE = 1,
	NORMAL = 2,
	ANY = 4,
	CATEGORY = 7,
	NONE = 5
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
var0_0.ELEMENT_LIGHT_COLOR = {
	[var0_0.ELEMENT_TYPE.ANY] = "7F96FF",
	[var0_0.ELEMENT_TYPE.PYRO] = "FF7072",
	[var0_0.ELEMENT_TYPE.CRYO] = "73E2FF",
	[var0_0.ELEMENT_TYPE.ELECTRO] = "FFD782",
	[var0_0.ELEMENT_TYPE.ANEMO] = "75FB8F",
	[var0_0.ELEMENT_TYPE.SAIREN] = "EB84FF"
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

function var0_0.GetCategory(arg0_6)
	return arg0_6:getConfig("prop_type")
end

function var0_0.GetElement(arg0_7)
	if arg0_7:GetType() == var0_0.TYPE.SAIREN then
		return var0_0.ELEMENT_TYPE.SAIREN
	elseif arg0_7:GetType() == var0_0.TYPE.ANY then
		return var0_0.ELEMENT_TYPE.ANY
	end

	return arg0_7:GetProp()
end

function var0_0.GetElementName(arg0_8)
	return var0_0.ELEMENT_NAME[arg0_8:GetElement()]
end

function var0_0.GetRingElement(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetElement()

	if arg0_9:GetType() == var0_0.TYPE.ANY and arg1_9 then
		if arg1_9:GetType() == AtelierMaterial.TYPE.SAIREN then
			var0_9 = var0_0.ELEMENT_TYPE.SAIREN
		else
			var0_9 = arg1_9:GetProps()[1]
		end
	end

	return var0_9
end

function var0_0.GetElementRingColor(arg0_10, arg1_10)
	local var0_10 = var0_0.ELEMENT_RING_COLOR[arg0_10:GetRingElement(arg1_10)]

	return SummerFeastScene.TransformColor(var0_10)
end

function var0_0.GetElementLightColor(arg0_11, arg1_11)
	local var0_11 = var0_0.ELEMENT_LIGHT_COLOR[arg0_11:GetRingElement(arg1_11)]

	return SummerFeastScene.TransformColor(var0_11)
end

function var0_0.GetLevel(arg0_12)
	return arg0_12:getConfig("prop_level")
end

function var0_0.GetLimitItemID(arg0_13)
	return arg0_13:getConfig("ryza_item_id")
end

function var0_0.GetNeighbors(arg0_14)
	return arg0_14:getConfig("circle_connect")
end

function var0_0.GetFormulaId(arg0_15)
	return arg0_15:getConfig("recipe_id")
end

function var0_0.GetStarList(arg0_16)
	return arg0_16:getConfig("star_list")
end

function var0_0.CanUseMaterial(arg0_17, arg1_17, arg2_17, arg3_17)
	arg3_17 = arg3_17 or 1

	if arg1_17:GetVersion() ~= arg3_17 then
		return false
	end

	local var0_17 = arg0_17:GetType()
	local var1_17 = arg1_17:GetType()
	local var2_17 = arg1_17:GetCategory()

	local function var3_17()
		if arg2_17:GetProduction()[1] ~= DROP_TYPE_RYZA_DROP then
			return false
		end

		if arg2_17:GetProduction()[2] == arg1_17:GetConfigID() then
			return true
		end

		local var0_18 = AtelierMaterial.New({
			configId = arg2_17:GetProduction()[2]
		})

		return var0_18:GetType() == AtelierMaterial.TYPE.NEUTRALIZER and var1_17 == AtelierMaterial.TYPE.NEUTRALIZER and var0_18:GetLevel() == arg1_17:GetLevel()
	end

	local var4_17 = arg0_17:GetLimitItemID()

	if var4_17 ~= 0 then
		return var4_17 == arg1_17:GetConfigID()
	elseif var0_17 == var0_0.TYPE.NORMAL then
		if var1_17 ~= AtelierMaterial.TYPE.NORMAL and var1_17 ~= AtelierMaterial.TYPE.NEUTRALIZER then
			return false
		end

		if not table.contains(arg1_17:GetProps(), arg0_17:GetElement()) then
			return false
		end

		if var3_17() then
			return false
		end

		return arg1_17:GetLevel() == arg0_17:GetLevel()
	elseif var0_17 == var0_0.TYPE.ANY then
		if var1_17 ~= AtelierMaterial.TYPE.NORMAL and var1_17 ~= AtelierMaterial.TYPE.NEUTRALIZER and var1_17 ~= AtelierMaterial.TYPE.SAIREN then
			return false
		end

		if var3_17() then
			return false
		end

		return arg1_17:GetLevel() == arg0_17:GetLevel()
	elseif var0_17 == var0_0.TYPE.NONE then
		return var2_17 ~= 0
	elseif var0_17 == var0_0.TYPE.ELEMENT then
		return table.contains(arg1_17:GetProps(), arg0_17:GetElement()) and var2_17 ~= 0
	elseif var0_17 == var0_0.TYPE.CATEGORY then
		return var2_17 == arg0_17:GetCategory()
	elseif var0_17 == var0_0.TYPE.ELEMENT_CATEGORY then
		return table.contains(arg1_17:GetProps(), arg0_17:GetElement()) and var2_17 == arg0_17:GetCategory()
	end
end

return var0_0
