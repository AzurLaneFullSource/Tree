local var0 = class("AtelierFormula", import("model.vo.BaseVO"))

var0.TYPE = {
	TOOL = 3,
	EQUIP = 1,
	OTHER = 4,
	ITEM = 2
}

function var0.bindConfigTable(arg0)
	return pg.activity_ryza_recipe
end

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.times = arg0.times or 0
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetIconPath(arg0)
	return arg0:getConfig("icon")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("display")
end

function var0.GetMaxLimit(arg0)
	return arg0:getConfig("item_num")
end

function var0.SetUsedCount(arg0, arg1)
	arg0.times = arg1
end

function var0.GetUsedCount(arg0)
	return arg0.times
end

function var0.IsAvaliable(arg0)
	return arg0:GetMaxLimit() < 0 or arg0:GetUsedCount() < arg0:GetMaxLimit()
end

function var0.GetProduction(arg0)
	return arg0:getConfig("item_id")
end

function var0.GetCircleList(arg0)
	return arg0:getConfig("recipe_circle")
end

function var0.IsFormualCanComposite(arg0, arg1)
	local var0 = {}
	local var1 = arg1:GetItems()

	local function var2(arg0)
		local var0 = var0[arg0:GetConfigID()] or Clone(var1[arg0:GetConfigID()])

		assert(var0, "Using Unexist material")

		var0.count = var0.count - 1
		var0[arg0:GetConfigID()] = var0
	end

	local var3 = _.map(arg0:GetCircleList(), function(arg0)
		return AtelierFormulaCircle.New({
			configId = arg0
		})
	end)

	if _.any(var3, function(arg0)
		if arg0:GetType() == AtelierFormulaCircle.TYPE.BASE or arg0:GetType() == AtelierFormulaCircle.TYPE.SAIREN then
			local var0 = arg0:GetLimitItemID()
			local var1 = var0[var0] or var1[var0]

			if var1 and var1.count > 0 then
				var2(var1)
			else
				return true
			end
		end
	end) then
		return false
	end

	local var4 = AtelierMaterial.bindConfigTable()

	local function var5(arg0)
		for iter0, iter1 in ipairs(var4.all) do
			local var0 = var0[iter1] or var1[iter1]

			if var0 and var0.count > 0 and arg0:CanUseMaterial(var0, arg0) then
				var2(var0)

				return
			end
		end

		return true
	end

	if _.any(var3, function(arg0)
		if arg0:GetType() == AtelierFormulaCircle.TYPE.NORMAL then
			return var5(arg0)
		end
	end) then
		return false
	end

	if _.any(var3, function(arg0)
		if arg0:GetType() == AtelierFormulaCircle.TYPE.ANY then
			return var5(arg0)
		end
	end) then
		return false
	end

	return true
end

return var0
