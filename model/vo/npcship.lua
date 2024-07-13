local var0_0 = class("NpcShip", import(".Ship"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = pg.ship_data_template[arg0_1.configId]

	for iter0_1 = 1, 3 do
		if not arg0_1.equipments[iter0_1] then
			local var1_1 = var0_1["equip_id_" .. iter0_1]

			arg0_1.equipments[iter0_1] = var1_1 > 0 and Equipment.New({
				id = var1_1
			}) or false
		end
	end

	arg0_1.isNpc = true
end

function var0_0.getExp(arg0_2)
	return 0
end

function var0_0.addExp(arg0_3, arg1_3, arg2_3)
	return
end

function var0_0.getIntimacy(arg0_4)
	return pg.intimacy_template[arg0_4:getIntimacyLevel()].lower_bound
end

function var0_0.getIntimacyLevel(arg0_5)
	return 2
end

function var0_0.setIntimacy(arg0_6, arg1_6)
	return
end

function var0_0.getEnergy(arg0_7)
	return pg.ship_data_template[arg0_7.configId].energy
end

function var0_0.setEnergy(arg0_8, arg1_8)
	return
end

return var0_0
