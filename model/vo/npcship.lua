local var0 = class("NpcShip", import(".Ship"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = pg.ship_data_template[arg0.configId]

	for iter0 = 1, 3 do
		if not arg0.equipments[iter0] then
			local var1 = var0["equip_id_" .. iter0]

			arg0.equipments[iter0] = var1 > 0 and Equipment.New({
				id = var1
			}) or false
		end
	end

	arg0.isNpc = true
end

function var0.getExp(arg0)
	return 0
end

function var0.addExp(arg0, arg1, arg2)
	return
end

function var0.getIntimacy(arg0)
	return pg.intimacy_template[arg0:getIntimacyLevel()].lower_bound
end

function var0.getIntimacyLevel(arg0)
	return 2
end

function var0.setIntimacy(arg0, arg1)
	return
end

function var0.getEnergy(arg0)
	return pg.ship_data_template[arg0.configId].energy
end

function var0.setEnergy(arg0, arg1)
	return
end

return var0
