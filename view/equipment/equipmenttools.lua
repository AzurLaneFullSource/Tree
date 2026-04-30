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
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(pg.spweapon_data_statistics.get_id_list_by_unique) do
		for iter2_4, iter3_4 in ipairs(pg.ship_data_template.get_id_list_by_group_type[iter0_4]) do
			if string.find(string.lower(pg.ship_data_statistics[iter3_4].name), arg0_4) then
				var0_4 = table.insertto(var0_4, iter1_4)

				break
			end
		end
	end
end

return var0_0
