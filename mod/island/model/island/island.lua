local var0_0 = class("Island", import(".BaseIsland"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.public_data)
	arg0_1:InitPrivateData(arg1_1.private_data)

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.private_data.furniture_list or {}) do
		table.insert(var0_1, IslandFurniture.New(iter1_1))
	end

	arg0_1:GetAgoraAgency():SetFurnitures(var0_1)
	arg0_1:GetInventoryAgency():SetLevel(arg1_1.public_data.storage_level)
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	arg0_2.accessAgency = IslandAccessAgency.New(arg0_2, arg1_2)
	arg0_2.inventoryAgency = IslandInventoryAgency.New(arg0_2, arg1_2)
	arg0_2.orderAgency = IslandOrderAgency.New(arg0_2, arg1_2)
	arg0_2.shopAgency = IslandShopAgency.New(arg0_2, arg1_2)
	arg0_2.buildingAgency = IslandBuildingAgency.New(arg0_2, arg1_2)
	arg0_2.taskAgency = IslandTaskAgency.New(arg0_2, arg1_2)
end

function var0_0.IsPrivate(arg0_3)
	return true
end

function var0_0.GetAccessAgency(arg0_4)
	return arg0_4.accessAgency
end

function var0_0.GetInventoryAgency(arg0_5)
	return arg0_5.inventoryAgency
end

function var0_0.GetOrderAgency(arg0_6)
	return arg0_6.orderAgency
end

function var0_0.GetShopAgency(arg0_7)
	return arg0_7.shopAgency
end

function var0_0.GetTaskAgency(arg0_8)
	return arg0_8.taskAgency
end

function var0_0.GetBuildingAgency(arg0_9)
	return arg0_9.buildingAgency
end

function var0_0.UpdatePerDay(arg0_10)
	var0_0.super.UpdatePerDay(arg0_10)
	arg0_10:GetOrderAgency():UpdatePerDay()
	arg0_10:GetTaskAgency():UpdatePerDay()
end

function var0_0.UpdatePerSecond(arg0_11)
	var0_0.super.UpdatePerDay(arg0_11)

	if arg0_11.buildingAgency then
		arg0_11.buildingAgency:UpdatePerSecond()
	end

	arg0_11:GetTaskAgency():UpdatePerSecond()
end

return var0_0
