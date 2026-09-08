local var0_0 = class("ReversePacmanDorm", import("model.vo.Dorm.Dorm"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.reversePacmanShips = {}
end

function var0_0.GetMapSize(arg0_2)
	local var0_2 = 0
	local var1_2 = 0
	local var2_2 = BackYardConst.MAX_REVERSE_PACMAN_MAP_SIZE
	local var3_2 = var2_2.x
	local var4_2 = var2_2.y

	return Vector4(var0_2, var1_2, var3_2, var4_2)
end

function var0_0.GetPutFurnitureList(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = require("GameCfg.backyardTheme.theme_reverse_pacman")
	local var2_3 = ReversePacmanThemeTemplate.New({
		id = -1,
		furniture_put_list = var1_3.furnitures or {}
	}, 1, arg0_3:GetMapSize())
	local var3_3 = var2_3 and var2_3:GetAllFurniture() or {}

	for iter0_3, iter1_3 in pairs(var3_3) do
		table.insert(var0_3, iter1_3)
	end

	table.sort(var0_3, BackyardThemeFurniture._LoadWeight)

	return var0_3
end

function var0_0.GetBayShipOnFloor(arg0_4, arg1_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.reversePacmanShips) do
		table.insert(var0_4, iter1_4)
	end

	return var0_4
end

function var0_0.AddShip(arg0_5, arg1_5)
	table.insert(arg0_5.reversePacmanShips, arg1_5)
end

return var0_0
