local var0_0 = class("EquipmentsDict")

function var0_0.Ctor(arg0_1)
	local var0_1 = {}
	local var1_1 = getProxy(EquipmentProxy):GetEquipmentsRaw()

	for iter0_1, iter1_1 in pairs(var1_1) do
		var0_1[iter1_1.id] = var0_1[iter1_1.id] or {}

		table.insert(var0_1[iter1_1.id], CreateShell(iter1_1))
	end

	for iter2_1, iter3_1 in pairs(getProxy(BayProxy):GetEquipsInShipsRaw()) do
		var0_1[iter3_1.id] = var0_1[iter3_1.id] or {}

		table.insert(var0_1[iter3_1.id], iter3_1)
	end

	arg0_1.data = var0_1
end

function var0_0.GetSameTypeInEquips(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg0_2.data
	local var2_2 = Equipment.getConfigData(arg1_2)

	while var2_2 do
		if var1_2[var2_2.id] then
			table.insertto(var0_2, var1_2[var2_2.id])
		end

		var2_2 = var2_2.next and Equipment.getConfigData(var2_2.next)
	end

	return var0_2
end

function var0_0.GetEquipmentTransformCandicates(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetSameTypeInEquips(arg1_3)
	local var1_3 = _.map(var0_3, function(arg0_4)
		return {
			type = DROP_TYPE_EQUIP,
			id = arg0_4.id,
			template = arg0_4
		}
	end)
	local var2_3 = Equipment.GetEquipComposeCfgStatic({
		equip_id = arg1_3
	})

	if var2_3 then
		local var3_3 = getProxy(BagProxy):getItemById(var2_3.material_id) or Item.New({
			count = 0,
			id = var2_3.material_id
		})

		table.insert(var1_3, 1, {
			type = DROP_TYPE_ITEM,
			id = var2_3.material_id,
			template = var3_3,
			composeCfg = var2_3
		})
	end

	return var1_3
end

function var0_0.GetEquipTraceBack(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5.data

	arg2_5 = arg2_5 or {
		arg1_5
	}
	arg3_5 = arg3_5 or {}

	local var1_5 = EquipmentProxy.GetTransformSources(arg1_5)

	if #var1_5 == 0 then
		table.insert(arg3_5, arg2_5)
	end

	for iter0_5, iter1_5 in ipairs(var1_5) do
		local var2_5 = pg.equip_upgrade_data[iter1_5].upgrade_from
		local var3_5 = iter0_5 == #var1_5 and arg2_5 or Clone(arg2_5)

		table.insert(var3_5, var2_5)

		var3_5.formulas = var3_5.formulas or {}

		table.insert(var3_5.formulas, 1, iter1_5)

		local var4_5 = arg0_5:GetEquipmentTransformCandicates(var2_5)

		if _.any(var4_5, function(arg0_6)
			if arg0_6.type == DROP_TYPE_ITEM then
				return arg0_6.template.count >= arg0_6.composeCfg.material_num
			elseif arg0_6.type == DROP_TYPE_EQUIP then
				return arg0_6.template.count > 0
			end
		end) then
			var3_5.candicates = var4_5

			table.insert(arg3_5, var3_5)
		elseif var2_5 == 0 then
			assert(false, "ERROR Source Equip ID 0")

			var3_5.candicates = {
				setmetatable({
					id = 0
				}, Equipment)
			}

			table.insert(arg3_5, var3_5)
		else
			arg0_5:GetEquipTraceBack(var2_5, var3_5, arg3_5)
		end
	end

	return arg3_5
end

function var0_0.GetSortedEquipTraceBack(arg0_7, ...)
	local var0_7 = arg0_7:GetEquipTraceBack(...)

	table.sort(var0_7, function(arg0_8, arg1_8)
		if #arg0_8 ~= #arg1_8 then
			return #arg0_8 < #arg1_8
		else
			for iter0_8 = 1, #arg0_8 do
				if arg0_8[iter0_8] ~= arg1_8[iter0_8] then
					return arg0_8[iter0_8] < arg1_8[iter0_8]
				end
			end

			return false
		end
	end)

	return var0_7
end

function var0_0.FindTheEquip(arg0_9, arg1_9)
	local var0_9 = arg0_9.data

	if not arg1_9 or not var0_9[arg1_9.id] then
		return
	end

	for iter0_9, iter1_9 in ipairs(var0_9[arg1_9.id]) do
		if EquipmentProxy.SameEquip(arg1_9, iter1_9) then
			return iter0_9, iter1_9
		end
	end
end

function var0_0.AddEquipment(arg0_10, arg1_10)
	local var0_10 = arg0_10.data

	var0_10[arg1_10.id] = var0_10[arg1_10.id] or {}

	local var1_10 = arg0_10:FindTheEquip(arg1_10) or #var0_10[arg1_10.id] + 1

	var0_10[arg1_10.id][var1_10] = arg1_10
end

function var0_0.RemoveEquipment(arg0_11, arg1_11)
	local var0_11 = arg0_11.data

	if not arg1_11 or not var0_11[arg1_11.id] then
		return
	end

	local var1_11 = arg0_11:FindTheEquip(arg1_11)

	if not var1_11 then
		return
	end

	table.remove(var0_11[arg1_11.id], var1_11)
end

function var0_0.UpdateEquipment(arg0_12, arg1_12)
	if arg1_12.count == 0 then
		arg0_12:RemoveEquipment(arg1_12)
	else
		arg0_12:AddEquipment(arg1_12)
	end
end

return var0_0
