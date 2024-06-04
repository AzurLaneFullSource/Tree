local var0 = class("AtelierActivity", import(".VirtualBagActivity"))

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.items = {}
	arg0.completeAllTools = false
	arg0.slots = _.map({
		1,
		2,
		3,
		4,
		5
	}, function()
		return {
			0,
			0
		}
	end)

	arg0:InitAllFormulas()
end

function var0.GetItems(arg0)
	return arg0.items
end

function var0.InitItems(arg0, arg1)
	_.each(arg1, function(arg0)
		local var0 = arg0.key
		local var1 = arg0.value

		arg0.items[var0] = arg0.items[var0] or AtelierMaterial.New({
			configId = var0
		})
		arg0.items[var0].count = arg0.items[var0].count + var1
	end)
end

function var0.GetSlots(arg0)
	return arg0.slots
end

function var0.UpdateBuffSlots(arg0, arg1)
	_.each(arg1, function(arg0)
		arg0.slots[arg0.pos] = {
			arg0.itemid,
			arg0.itemnum
		}
	end)
end

function var0.AddItem(arg0, arg1)
	local var0 = arg1:GetConfigID()
	local var1 = arg1.count

	arg0.items[var0] = arg0.items[var0] or AtelierMaterial.New({
		configId = var0
	})
	arg0.items[var0].count = arg0.items[var0].count + var1
end

function var0.GetItemById(arg0, arg1)
	return arg0.items[arg1]
end

function var0.subItemCount(arg0, arg1, arg2)
	if not arg0.items[arg1] then
		return
	end

	arg0.items[arg1].count = math.max(0, arg0.items[arg1].count - arg2)
end

function var0.GetAllVitems(arg0)
	return table.map(arg0:GetItems(), function(arg0)
		return arg0.count
	end)
end

function var0.getVitemNumber(arg0, arg1)
	local var0 = arg0:GetItemById(arg1)

	return var0 and var0.count or 0
end

function var0.addVitemNumber(arg0, arg1, arg2)
	arg0:AddItem(AtelierMaterial.New({
		configId = arg1,
		count = arg2
	}))
end

function var0.subVitemNumber(arg0, arg1, arg2)
	arg0:subItemCount(arg1, arg2)
end

function var0.GetFormulas(arg0)
	return arg0.formulas
end

function var0.InitAllFormulas(arg0)
	arg0.formulas = {}

	_.each(pg.activity_ryza_recipe.all, function(arg0)
		arg0.formulas[arg0] = AtelierFormula.New({
			configId = arg0
		})
	end)
end

function var0.InitFormulaUseCounts(arg0, arg1)
	_.each(arg1, function(arg0)
		local var0 = arg0.key
		local var1 = arg0.value

		arg0.formulas[var0]:SetUsedCount(var1)
	end)
	arg0:CheckCompleteAllTool()
end

function var0.AddFormulaUseCount(arg0, arg1, arg2)
	arg0.formulas[arg1]:SetUsedCount(arg0.formulas[arg1]:GetUsedCount() + arg2)
	arg0:CheckCompleteAllTool()
end

function var0.CheckCompleteAllTool(arg0)
	if arg0.completeAllTools then
		return
	end

	arg0.completeAllTools = _.all(_.values(arg0.formulas), function(arg0)
		if arg0:GetType() ~= AtelierFormula.TYPE.TOOL then
			return true
		end

		return not arg0:IsAvaliable()
	end)
end

function var0.IsCompleteAllTools(arg0)
	return arg0.completeAllTools
end

function var0.IsActivityBuffMap(arg0)
	return ChapterConst.IsAtelierMap(arg0) and arg0:getMapType() > Map.ACTIVITY_EASY
end

return var0
