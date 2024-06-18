local var0_0 = class("AtelierActivity", import(".VirtualBagActivity"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.items = {}
	arg0_1.completeAllTools = false
	arg0_1.slots = _.map({
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

	arg0_1:InitAllFormulas()
end

function var0_0.GetItems(arg0_3)
	return arg0_3.items
end

function var0_0.InitItems(arg0_4, arg1_4)
	_.each(arg1_4, function(arg0_5)
		local var0_5 = arg0_5.key
		local var1_5 = arg0_5.value

		arg0_4.items[var0_5] = arg0_4.items[var0_5] or AtelierMaterial.New({
			configId = var0_5
		})
		arg0_4.items[var0_5].count = arg0_4.items[var0_5].count + var1_5
	end)
end

function var0_0.GetSlots(arg0_6)
	return arg0_6.slots
end

function var0_0.UpdateBuffSlots(arg0_7, arg1_7)
	_.each(arg1_7, function(arg0_8)
		arg0_7.slots[arg0_8.pos] = {
			arg0_8.itemid,
			arg0_8.itemnum
		}
	end)
end

function var0_0.AddItem(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetConfigID()
	local var1_9 = arg1_9.count

	arg0_9.items[var0_9] = arg0_9.items[var0_9] or AtelierMaterial.New({
		configId = var0_9
	})
	arg0_9.items[var0_9].count = arg0_9.items[var0_9].count + var1_9
end

function var0_0.GetItemById(arg0_10, arg1_10)
	return arg0_10.items[arg1_10]
end

function var0_0.subItemCount(arg0_11, arg1_11, arg2_11)
	if not arg0_11.items[arg1_11] then
		return
	end

	arg0_11.items[arg1_11].count = math.max(0, arg0_11.items[arg1_11].count - arg2_11)
end

function var0_0.GetAllVitems(arg0_12)
	return table.map(arg0_12:GetItems(), function(arg0_13)
		return arg0_13.count
	end)
end

function var0_0.getVitemNumber(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetItemById(arg1_14)

	return var0_14 and var0_14.count or 0
end

function var0_0.addVitemNumber(arg0_15, arg1_15, arg2_15)
	arg0_15:AddItem(AtelierMaterial.New({
		configId = arg1_15,
		count = arg2_15
	}))
end

function var0_0.subVitemNumber(arg0_16, arg1_16, arg2_16)
	arg0_16:subItemCount(arg1_16, arg2_16)
end

function var0_0.GetFormulas(arg0_17)
	return arg0_17.formulas
end

function var0_0.InitAllFormulas(arg0_18)
	arg0_18.formulas = {}

	_.each(pg.activity_ryza_recipe.all, function(arg0_19)
		arg0_18.formulas[arg0_19] = AtelierFormula.New({
			configId = arg0_19
		})
	end)
end

function var0_0.InitFormulaUseCounts(arg0_20, arg1_20)
	_.each(arg1_20, function(arg0_21)
		local var0_21 = arg0_21.key
		local var1_21 = arg0_21.value

		arg0_20.formulas[var0_21]:SetUsedCount(var1_21)
	end)
	arg0_20:CheckCompleteAllTool()
end

function var0_0.AddFormulaUseCount(arg0_22, arg1_22, arg2_22)
	arg0_22.formulas[arg1_22]:SetUsedCount(arg0_22.formulas[arg1_22]:GetUsedCount() + arg2_22)
	arg0_22:CheckCompleteAllTool()
end

function var0_0.CheckCompleteAllTool(arg0_23)
	if arg0_23.completeAllTools then
		return
	end

	arg0_23.completeAllTools = _.all(_.values(arg0_23.formulas), function(arg0_24)
		if arg0_24:GetType() ~= AtelierFormula.TYPE.TOOL then
			return true
		end

		return not arg0_24:IsAvaliable()
	end)
end

function var0_0.IsCompleteAllTools(arg0_25)
	return arg0_25.completeAllTools
end

function var0_0.IsActivityBuffMap(arg0_26)
	return ChapterConst.IsAtelierMap(arg0_26) and arg0_26:getMapType() > Map.ACTIVITY_EASY
end

return var0_0
