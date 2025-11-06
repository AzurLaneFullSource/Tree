local var0_0 = {
	IsMatchKey = function(arg0_1, arg1_1)
		if not arg1_1 or arg1_1 == "" then
			return true
		end

		arg1_1 = string.lower(string.gsub(arg1_1, "%.", "%%."))

		return underscore.any(arg0_1, function(arg0_2)
			return string.find(string.lower(arg0_2), arg1_1)
		end)
	end
}

function var0_0.IsMatchEquipmentSkinKey(arg0_3, arg1_3)
	local var0_3 = {
		pg.equip_skin_template[arg0_3].name
	}

	return var0_0.IsMatchKey(var0_3, arg1_3)
end

function var0_0.GetMatchSpEquipmentListKeyByShip(arg0_4)
	local var0_4 = var0_0.GetMatchShipGroupListKey(arg0_4)
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var2_4 = pg.spweapon_data_statistics.get_id_list_by_unique[iter1_4]

		if var2_4 ~= nil then
			var1_4 = table.insertto(var1_4, var2_4)
		end
	end

	return var1_4
end

function var0_0.GetMatchShipGroupListKey(arg0_5)
	if arg0_5 == "" then
		return {}
	end

	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(pg.ship_data_statistics.all) do
		local var1_5 = pg.ship_data_statistics[iter1_5].name

		if var0_0.IsMatchKey({
			var1_5
		}, arg0_5) then
			local var2_5 = math.floor(iter1_5 / 10)

			if not table.contains(var0_5, var2_5) then
				table.insert(var0_5, var2_5)
			end
		end
	end

	return var0_5
end

return var0_0
