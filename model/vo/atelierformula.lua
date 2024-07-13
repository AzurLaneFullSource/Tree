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

function var0_0.IsFormualCanComposite(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = arg1_14:GetItems()

	local function var2_14(arg0_15)
		local var0_15 = var0_14[arg0_15:GetConfigID()] or Clone(var1_14[arg0_15:GetConfigID()])

		assert(var0_15, "Using Unexist material")

		var0_15.count = var0_15.count - 1
		var0_14[arg0_15:GetConfigID()] = var0_15
	end

	local var3_14 = _.map(arg0_14:GetCircleList(), function(arg0_16)
		return AtelierFormulaCircle.New({
			configId = arg0_16
		})
	end)

	if _.any(var3_14, function(arg0_17)
		if arg0_17:GetType() == AtelierFormulaCircle.TYPE.BASE or arg0_17:GetType() == AtelierFormulaCircle.TYPE.SAIREN then
			local var0_17 = arg0_17:GetLimitItemID()
			local var1_17 = var0_14[var0_17] or var1_14[var0_17]

			if var1_17 and var1_17.count > 0 then
				var2_14(var1_17)
			else
				return true
			end
		end
	end) then
		return false
	end

	local var4_14 = AtelierMaterial.bindConfigTable()

	local function var5_14(arg0_18)
		for iter0_18, iter1_18 in ipairs(var4_14.all) do
			local var0_18 = var0_14[iter1_18] or var1_14[iter1_18]

			if var0_18 and var0_18.count > 0 and arg0_18:CanUseMaterial(var0_18, arg0_14) then
				var2_14(var0_18)

				return
			end
		end

		return true
	end

	if _.any(var3_14, function(arg0_19)
		if arg0_19:GetType() == AtelierFormulaCircle.TYPE.NORMAL then
			return var5_14(arg0_19)
		end
	end) then
		return false
	end

	if _.any(var3_14, function(arg0_20)
		if arg0_20:GetType() == AtelierFormulaCircle.TYPE.ANY then
			return var5_14(arg0_20)
		end
	end) then
		return false
	end

	return true
end

return var0_0
