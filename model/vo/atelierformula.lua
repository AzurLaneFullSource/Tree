local var0_0 = class("AtelierFormula", import("model.vo.BaseVO"))

var0_0.TYPE = {
	TOOL = 3,
	EQUIP = 1,
	OTHER = 4,
	ITEM = 2
}

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_ryza_recipe
end

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.times = arg0_2.times or 0
end

function var0_0.GetConfigID(arg0_3)
	return arg0_3.configId
end

function var0_0.GetName(arg0_4)
	return arg0_4:getConfig("name")
end

function var0_0.GetIconPath(arg0_5)
	return arg0_5:getConfig("icon")
end

function var0_0.GetType(arg0_6)
	return arg0_6:getConfig("type")
end

function var0_0.GetDesc(arg0_7)
	return arg0_7:getConfig("display")
end

function var0_0.GetMaxLimit(arg0_8)
	return arg0_8:getConfig("item_num")
end

function var0_0.SetUsedCount(arg0_9, arg1_9)
	arg0_9.times = arg1_9
end

function var0_0.GetUsedCount(arg0_10)
	return arg0_10.times
end

function var0_0.IsAvaliable(arg0_11)
	return arg0_11:GetMaxLimit() < 0 or arg0_11:GetUsedCount() < arg0_11:GetMaxLimit()
end

function var0_0.GetProduction(arg0_12)
	return arg0_12:getConfig("item_id")
end

function var0_0.GetCircleList(arg0_13)
	return arg0_13:getConfig("recipe_circle")
end

function var0_0.GetShapeID(arg0_14)
	return arg0_14:getConfig("shape")
end

function var0_0.IsFormualCanComposite(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}
	local var1_15 = arg1_15:GetItems()

	local function var2_15(arg0_16)
		local var0_16 = var0_15[arg0_16:GetConfigID()] or Clone(var1_15[arg0_16:GetConfigID()])

		assert(var0_16, "Using Unexist material")

		var0_16.count = var0_16.count - 1
		var0_15[arg0_16:GetConfigID()] = var0_16
	end

	local var3_15 = _.map(arg0_15:GetCircleList(), function(arg0_17)
		return AtelierFormulaCircle.New({
			configId = arg0_17
		})
	end)

	if _.any(var3_15, function(arg0_18)
		local var0_18 = arg0_18:GetLimitItemID()

		if var0_18 ~= 0 then
			local var1_18 = var0_15[var0_18] or var1_15[var0_18]

			if var1_18 and var1_18.count > 0 then
				var2_15(var1_18)
			else
				return true
			end
		end
	end) then
		return false
	end

	local var4_15 = AtelierMaterial.bindConfigTable()

	local function var5_15(arg0_19)
		for iter0_19, iter1_19 in ipairs(var4_15.all) do
			local var0_19 = var0_15[iter1_19] or var1_15[iter1_19]

			if var0_19 and var0_19.count > 0 and arg0_19:CanUseMaterial(var0_19, arg0_15, arg2_15) then
				var2_15(var0_19)

				return
			end
		end

		return true
	end

	local var6_15 = {
		AtelierFormulaCircle.TYPE.NORMAL,
		AtelierFormulaCircle.TYPE.ANY,
		AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY,
		AtelierFormulaCircle.TYPE.CATEGORY,
		AtelierFormulaCircle.TYPE.ELEMENT,
		AtelierFormulaCircle.TYPE.NONE
	}

	for iter0_15, iter1_15 in ipairs(var6_15) do
		if _.any(var3_15, function(arg0_20)
			if arg0_20:GetLimitItemID() == 0 then
				if arg0_20:GetType() == iter1_15 then
					return var5_15(arg0_20)
				end
			else
				return false
			end
		end) then
			return false
		end
	end

	return true
end

return var0_0
