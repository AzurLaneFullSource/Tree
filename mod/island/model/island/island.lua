local var0_0 = class("Island", import(".BaseIsland"))

var0_0.EXP_ADD = "Island:EXP_ADD"

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.public_data)

	arg0_1.inventoryAgency = IslandInventoryAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.orderAgency = IslandOrderAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.shopAgency = IslandShopAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.seasonAgency = IslandSeasonAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.dressUpAgency = IslandDressUpAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.achievementAgency = IslandAchievementAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.globalBuffAgency = IslandGlobalBuffAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.actionAgency = IslandActionAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.npcFeedbackAgency = IslandNpcFeedbackAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.fishingAgency = IslandFishingAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.settingsAgency = IslandSettingsAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.bookAgency = IslandBookAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.cardDiyAgency = IslandCardDiyAgency.New(arg0_1, arg1_1.private_data)
	arg0_1.ticketAgency = IslandTicketAgency.New(arg0_1, arg1_1.private_data)

	arg0_1:GetAgoraAgency():InitPrivateData(arg1_1.private_data)
	arg0_1:AddDefaultAgoraData()
	arg0_1:GetFollowerAgency():InitPrivateData(arg1_1.private_data)
	arg0_1:GetInventoryAgency():InitPrivateData(arg1_1.public_data)
	arg0_1:GetSignInAgency():InitPrivateData(arg1_1.private_data)
	arg0_1:GetAccessAgency():InitPrivateData(arg1_1.private_data)
	arg0_1:GetBuildingAgency():InitPrivateData(arg1_1.private_data)
	arg0_1:GetWildCollectAgency():InitPrivateData(arg1_1.private_data)
end

function var0_0.IsPrivate(arg0_2)
	return true
end

function var0_0.AddExp(arg0_3, arg1_3)
	var0_0.super.AddExp(arg0_3, arg1_3)
	arg0_3:DispatchEvent(var0_0.EXP_ADD)
end

function var0_0.AddDefaultAgoraData(arg0_4)
	local var0_4 = pg.island_set.initial_furniture.key_value_varchar
	local var1_4 = arg0_4:GetAgoraAgency()

	for iter0_4, iter1_4 in ipairs(var0_4) do
		var1_4:RawAddFurniture(IslandFurniture.New({
			id = iter1_4[1],
			count = iter1_4[2]
		}))
	end
end

function var0_0.GetInventoryAgency(arg0_5)
	return arg0_5.inventoryAgency
end

function var0_0.GetFishingAgency(arg0_6)
	return arg0_6.fishingAgency
end

function var0_0.GetOrderAgency(arg0_7)
	return arg0_7.orderAgency
end

function var0_0.GetActionAgency(arg0_8)
	return arg0_8.actionAgency
end

function var0_0.GetNpcFeedbackAgency(arg0_9)
	return arg0_9.npcFeedbackAgency
end

function var0_0.GetShopAgency(arg0_10)
	return arg0_10.shopAgency
end

function var0_0.GetSeasonAgency(arg0_11)
	return arg0_11.seasonAgency
end

function var0_0.GetDressUpAgency(arg0_12)
	return arg0_12.dressUpAgency
end

function var0_0.GetAchievementAgency(arg0_13)
	return arg0_13.achievementAgency
end

function var0_0.GetGlobalBuffAgency(arg0_14)
	return arg0_14.globalBuffAgency
end

function var0_0.GetSettingsAgency(arg0_15)
	return arg0_15.settingsAgency
end

function var0_0.GetBookAgency(arg0_16)
	return arg0_16.bookAgency
end

function var0_0.GetCardDiyAgency(arg0_17)
	return arg0_17.cardDiyAgency
end

function var0_0.GetTicketAgency(arg0_18)
	return arg0_18.ticketAgency
end

function var0_0.GetSystemTipInfos(arg0_19)
	if not arg0_19:GetAblityAgency():IsUnlockPostManage() then
		return {
			awardCnt = 0,
			emptyCnt = 0,
			postFlag = 0,
			timestamps = {}
		}
	else
		local var0_19 = arg0_19:GetBuildingAgency():GetTipInfos()
		local var1_19 = arg0_19:GetManageAgency():GetTipInfos()

		return {
			postFlag = 1,
			awardCnt = var0_19.awardCnt + var1_19.awardCnt,
			emptyCnt = var0_19.emptyCnt + var1_19.emptyCnt,
			timestamps = table.mergeArray(var0_19.timestamps, var1_19.timestamps)
		}
	end
end

function var0_0.UpdatePerDay(arg0_20)
	var0_0.super.UpdatePerDay(arg0_20)
	arg0_20:GetOrderAgency():UpdatePerDay()
	arg0_20:GetTaskAgency():UpdatePerDay()
	arg0_20:GetNpcFeedbackAgency():UpdatePerDay()
end

function var0_0.UpdatePerSecond(arg0_21)
	var0_0.super.UpdatePerSecond(arg0_21)
	arg0_21:GetTaskAgency():UpdatePerSecond()
end

return var0_0
