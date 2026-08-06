local var0_0 = class("IslandSeasonRedDotHelper")
local var1_0 = "IslandSeasonRedDotHelper.FirstEnter_11111"
local var2_0 = "IslandSeasonRedDotHelper.FirstEnterShopPhase_1111111"
local var3_0 = "IslandSeasonRedDotHelper.FirstEnterReview_1111111"

function var0_0.TipActivity(arg0_1)
	return arg0_1:readyToAchieve() or var0_0.IsFirstEnterAct(arg0_1)
end

function var0_0.IsFirstEnterAct(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var1_0 .. var0_2 .. "_" .. arg0_2.id, 0) == 0
end

function var0_0.UpdateActEnterTip(arg0_3)
	local var0_3 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var1_0 .. var0_3 .. "_" .. arg0_3.id, 1)
	PlayerPrefs.Save()
end

function var0_0.AnyActShouldTip()
	local var0_4 = getProxy(ActivityProxy):getIslandPanelActivities()

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if var0_0.TipActivity(iter1_4) then
			return true
		end
	end

	return false
end

function var0_0.TipShopShowPhase(arg0_5)
	if arg0_5 == 1 then
		return var0_0.IsFirstEnterShopPhase(arg0_5)
	else
		return var0_0.UnlockShopPhase(arg0_5) and var0_0.IsFirstEnterShopPhase(arg0_5)
	end
end

function var0_0.UnlockShopPhase(arg0_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason():getConfig("shop_id")[arg0_6]
	local var1_6 = getProxy(IslandProxy):GetIsland():GetShopAgency():GetSeasonShops()[var0_6]

	return var1_6 and var1_6:IsInTime()
end

function var0_0.IsFirstEnterShopPhase(arg0_7)
	local var0_7 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var2_0 .. var0_7 .. "_" .. arg0_7, 0) == 0
end

function var0_0.UpdateEnterShopPhase(arg0_8)
	local var0_8 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var2_0 .. var0_8 .. "_" .. arg0_8, 1)
	PlayerPrefs.Save()
end

function var0_0.AnyShopShouldTip()
	local var0_9 = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason():getConfig("shop_id")

	for iter0_9 = 1, #var0_9 do
		if var0_0.TipShopShowPhase(iter0_9) then
			return true
		end
	end

	return false
end

function var0_0.AnyPtCanGet()
	return getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetSeason():GanGetPtAward()
end

function var0_0.AnyTaskCanGet()
	local var0_11 = getProxy(IslandProxy):GetIsland()
	local var1_11 = var0_11:GetTaskAgency()
	local var2_11 = var0_11:GetSeasonAgency():GetSeason():GetTaskIds()

	for iter0_11 = 1, #var2_11 do
		local var3_11 = var1_11:GetTask(var2_11[iter0_11])

		if var3_11 and var3_11:IsSubmitOnUI() and var3_11:IsFinish() then
			return true
		end
	end

	return false
end

function var0_0.TipRank()
	return false
end

function var0_0.TipReview()
	return var0_0.IsFirstEnterReview()
end

function var0_0.IsFirstEnterReview()
	local var0_14 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var3_0 .. var0_14, 0) == 0
end

function var0_0.UpdateEnterReview()
	local var0_15 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var3_0 .. var0_15, 1)
	PlayerPrefs.Save()
end

function var0_0.TipTag(arg0_16)
	if arg0_16 == IslandSeasonPage.PAGE_ACTIVITY then
		return var0_0.AnyActShouldTip()
	elseif arg0_16 == IslandSeasonPage.PAGE_PT then
		return var0_0.AnyPtCanGet()
	elseif arg0_16 == IslandSeasonPage.PAGE_TASK then
		return var0_0.AnyTaskCanGet()
	elseif arg0_16 == IslandSeasonPage.PAGE_SHOP then
		return var0_0.AnyShopShouldTip()
	elseif arg0_16 == IslandSeasonPage.PAGE_RANK then
		return var0_0.TipRank()
	elseif arg0_16 == IslandSeasonPage.PAGE_REVIEW then
		return var0_0.TipReview()
	end

	return false
end

function var0_0.TipSeason()
	return var0_0.AnyActShouldTip() or var0_0.AnyShopShouldTip() or var0_0.AnyPtCanGet() or var0_0.AnyTaskCanGet() or var0_0.TipRank() or var0_0.TipReview()
end

return var0_0
