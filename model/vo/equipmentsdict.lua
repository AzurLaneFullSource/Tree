local var0 = class("EquipmentsDict")

function var0.Ctor(arg0)
	local var0 = {}
	local var1 = getProxy(EquipmentProxy):GetEquipmentsRaw()

	for iter0, iter1 in pairs(var1) do
		var0[iter1.id] = var0[iter1.id] or {}

		table.insert(var0[iter1.id], CreateShell(iter1))
	end

	for iter2, iter3 in pairs(getProxy(BayProxy):GetEquipsInShipsRaw()) do
		var0[iter3.id] = var0[iter3.id] or {}

		table.insert(var0[iter3.id], iter3)
	end

	arg0.data = var0
end

function var0.GetSameTypeInEquips(arg0, arg1)
	local var0 = {}
	local var1 = arg0.data
	local var2 = Equipment.getConfigData(arg1)

	while var2 do
		if var1[var2.id] then
			table.insertto(var0, var1[var2.id])
		end

		var2 = var2.next and Equipment.getConfigData(var2.next)
	end

	return var0
end

function var0.GetEquipmentTransformCandicates(arg0, arg1)
	local var0 = arg0:GetSameTypeInEquips(arg1)
	local var1 = _.map(var0, function(arg0)
		return {
			type = DROP_TYPE_EQUIP,
			id = arg0.id,
			template = arg0
		}
	end)
	local var2 = Equipment.GetEquipComposeCfgStatic({
		equip_id = arg1
	})

	if var2 then
		local var3 = getProxy(BagProxy):getItemById(var2.material_id) or Item.New({
			count = 0,
			id = var2.material_id
		})

		table.insert(var1, 1, {
			type = DROP_TYPE_ITEM,
			id = var2.material_id,
			template = var3,
			composeCfg = var2
		})
	end

	return var1
end

function var0.GetEquipTraceBack(arg0, arg1, arg2, arg3)
	local var0 = arg0.data

	arg2 = arg2 or {
		arg1
	}
	arg3 = arg3 or {}

	local var1 = EquipmentProxy.GetTransformSources(arg1)

	if #var1 == 0 then
		table.insert(arg3, arg2)
	end

	for iter0, iter1 in ipairs(var1) do
		local var2 = pg.equip_upgrade_data[iter1].upgrade_from
		local var3 = iter0 == #var1 and arg2 or Clone(arg2)

		table.insert(var3, var2)

		var3.formulas = var3.formulas or {}

		table.insert(var3.formulas, 1, iter1)

		local var4 = arg0:GetEquipmentTransformCandicates(var2)

		if _.any(var4, function(arg0)
			if arg0.type == DROP_TYPE_ITEM then
				return arg0.template.count >= arg0.composeCfg.material_num
			elseif arg0.type == DROP_TYPE_EQUIP then
				return arg0.template.count > 0
			end
		end) then
			var3.candicates = var4

			table.insert(arg3, var3)
		elseif var2 == 0 then
			assert(false, "ERROR Source Equip ID 0")

			var3.candicates = {
				setmetatable({
					id = 0
				}, Equipment)
			}

			table.insert(arg3, var3)
		else
			arg0:GetEquipTraceBack(var2, var3, arg3)
		end
	end

	return arg3
end

function var0.GetSortedEquipTraceBack(arg0, ...)
	local var0 = arg0:GetEquipTraceBack(...)

	table.sort(var0, function(arg0, arg1)
		if #arg0 ~= #arg1 then
			return #arg0 < #arg1
		else
			for iter0 = 1, #arg0 do
				if arg0[iter0] ~= arg1[iter0] then
					return arg0[iter0] < arg1[iter0]
				end
			end

			return false
		end
	end)

	return var0
end

function var0.FindTheEquip(arg0, arg1)
	local var0 = arg0.data

	if not arg1 or not var0[arg1.id] then
		return
	end

	for iter0, iter1 in ipairs(var0[arg1.id]) do
		if EquipmentProxy.SameEquip(arg1, iter1) then
			return iter0, iter1
		end
	end
end

function var0.AddEquipment(arg0, arg1)
	local var0 = arg0.data

	var0[arg1.id] = var0[arg1.id] or {}

	local var1 = arg0:FindTheEquip(arg1) or #var0[arg1.id] + 1

	var0[arg1.id][var1] = arg1
end

function var0.RemoveEquipment(arg0, arg1)
	local var0 = arg0.data

	if not arg1 or not var0[arg1.id] then
		return
	end

	local var1 = arg0:FindTheEquip(arg1)

	if not var1 then
		return
	end

	table.remove(var0[arg1.id], var1)
end

function var0.UpdateEquipment(arg0, arg1)
	if arg1.count == 0 then
		arg0:RemoveEquipment(arg1)
	else
		arg0:AddEquipment(arg1)
	end
end

return var0
