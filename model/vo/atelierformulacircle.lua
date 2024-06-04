local var0 = class("AtelierFormulaCircle", import("model.vo.BaseVO"))

var0.TYPE = {
	BASE = 1,
	SAIREN = 3,
	NORMAL = 2,
	ANY = 4
}
var0.ELEMENT_TYPE = {
	PYRO = 1,
	SAIREN = 5,
	ELECTRO = 3,
	ANEMO = 4,
	CRYO = 2,
	ANY = 0
}
var0.ELEMENT_NAME = {}

for iter0, iter1 in pairs(var0.ELEMENT_TYPE) do
	var0.ELEMENT_NAME[iter1] = iter0
end

var0.ELEMENT_RING_COLOR = {
	[var0.ELEMENT_TYPE.ANY] = "FFFED5",
	[var0.ELEMENT_TYPE.PYRO] = "F74F41",
	[var0.ELEMENT_TYPE.CRYO] = "64CAFF",
	[var0.ELEMENT_TYPE.ELECTRO] = "FFDD3F",
	[var0.ELEMENT_TYPE.ANEMO] = "B0E860",
	[var0.ELEMENT_TYPE.SAIREN] = "AF97FF"
}

function var0.bindConfigTable(arg0)
	return pg.activity_ryza_recipe_circle
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetIconPath(arg0)
	return arg0:getConfig("icon")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetProp(arg0)
	return arg0:getConfig("prop")
end

function var0.GetElement(arg0)
	if arg0:GetType() == var0.TYPE.SAIREN then
		return var0.ELEMENT_TYPE.SAIREN
	elseif arg0:GetType() == var0.TYPE.ANY then
		return var0.ELEMENT_TYPE.ANY
	end

	return arg0:GetProp()
end

function var0.GetElementName(arg0)
	return var0.ELEMENT_NAME[arg0:GetElement()]
end

function var0.GetRingElement(arg0, arg1)
	local var0 = arg0:GetElement()

	if arg0:GetType() == var0.TYPE.ANY and arg1 then
		if arg1:GetType() == AtelierMaterial.TYPE.SAIREN then
			var0 = var0.ELEMENT_TYPE.SAIREN
		else
			var0 = arg1:GetProps()[1]
		end
	end

	return var0
end

function var0.GetElementRingColor(arg0, arg1)
	local var0 = var0.ELEMENT_RING_COLOR[arg0:GetRingElement(arg1)]

	return SummerFeastScene.TransformColor(var0)
end

function var0.GetLevel(arg0)
	return arg0:getConfig("prop_level")
end

function var0.GetLimitItemID(arg0)
	return arg0:getConfig("ryza_item_id")
end

function var0.GetNeighbors(arg0)
	return arg0:getConfig("circle_connect")
end

function var0.GetFormulaId(arg0)
	return arg0:getConfig("recipe_id")
end

function var0.CanUseMaterial(arg0, arg1, arg2)
	local function var0()
		if arg2:GetProduction()[1] ~= DROP_TYPE_RYZA_DROP then
			return false
		end

		if arg2:GetProduction()[2] == arg1:GetConfigID() then
			return true
		end

		local var0 = AtelierMaterial.New({
			configId = arg2:GetProduction()[2]
		})

		return var0:GetType() == AtelierMaterial.TYPE.NEUTRALIZER and arg1:GetType() == AtelierMaterial.TYPE.NEUTRALIZER and var0:GetLevel() == arg1:GetLevel()
	end

	if arg0:GetType() == var0.TYPE.BASE or arg0:GetType() == var0.TYPE.SAIREN then
		return arg0:GetLimitItemID() == arg1:GetConfigID()
	elseif arg0:GetType() == var0.TYPE.NORMAL then
		if arg1:GetType() ~= AtelierMaterial.TYPE.NORMAL and arg1:GetType() ~= AtelierMaterial.TYPE.NEUTRALIZER then
			return false
		end

		if not table.contains(arg1:GetProps(), arg0:GetElement()) then
			return false
		end

		if var0() then
			return false
		end

		return arg1:GetLevel() == arg0:GetLevel()
	elseif arg0:GetType() == var0.TYPE.ANY then
		if arg1:GetType() ~= AtelierMaterial.TYPE.NORMAL and arg1:GetType() ~= AtelierMaterial.TYPE.NEUTRALIZER and arg1:GetType() ~= AtelierMaterial.TYPE.SAIREN then
			return false
		end

		if var0() then
			return false
		end

		return arg1:GetLevel() == arg0:GetLevel()
	end
end

return var0
