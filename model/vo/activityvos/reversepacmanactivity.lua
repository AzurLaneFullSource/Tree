local var0_0 = class("ReversePacmanActivity", import(".VirtualBagActivity"))

var0_0.KEY_VIRTUAL_ITEM = 1
var0_0.KEY_STAGE_DATA = 2
var0_0.KEY_FAVORABILITY = 3

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)
	pg.m02:sendNotification(GAME.GET_ACTIVITY_SHOP)
end

function var0_0.GetVitemNumber(arg0_2, arg1_2)
	return var0_0.super.getVitemNumber(arg0_2, arg1_2)
end

function var0_0.SetVitemNumber(arg0_3, arg1_3, arg2_3)
	var0_0.super.setVitemNumber(arg0_3, arg1_3, arg2_3)
end

function var0_0.AddVitemNumber(arg0_4, arg1_4, arg2_4)
	var0_0.super.addVitemNumber(arg0_4, arg1_4, arg2_4)
end

function var0_0.SubVitemNumber(arg0_5, arg1_5, arg2_5)
	var0_0.super.subVitemNumber(arg0_5, arg1_5, arg2_5)
end

function var0_0.GetStageDataList(arg0_6)
	return arg0_6.data1KeyValueList[var0_0.KEY_STAGE_DATA] or {}
end

function var0_0.UpdatePassStage(arg0_7, arg1_7, arg2_7)
	arg0_7.data1KeyValueList[var0_0.KEY_STAGE_DATA] = arg0_7.data1KeyValueList[var0_0.KEY_STAGE_DATA] or {}

	local var0_7 = arg0_7.data1KeyValueList[var0_0.KEY_STAGE_DATA][arg1_7] or 0

	if var0_7 == 0 or arg2_7 < var0_7 then
		arg0_7.data1KeyValueList[var0_0.KEY_STAGE_DATA][arg1_7] = arg2_7
	end
end

function var0_0.IsUnlockStage(arg0_8, arg1_8)
	local var0_8 = pg.activity_chasing_level[arg1_8].unlock_date

	return var0_8 and pg.TimeMgr.GetInstance():passTime(var0_8[1])
end

function var0_0.GetRoleIds(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9:GetFavorabilityList()) do
		table.insert(var0_9, iter0_9)
	end

	return var0_9
end

function var0_0.GetFavorabilityList(arg0_10)
	return arg0_10.data1KeyValueList[var0_0.KEY_FAVORABILITY] or {}
end

function var0_0.AddFavorability(arg0_11, arg1_11, arg2_11)
	arg0_11.data1KeyValueList[var0_0.KEY_FAVORABILITY] = arg0_11.data1KeyValueList[var0_0.KEY_FAVORABILITY] or {}
	arg0_11.data1KeyValueList[var0_0.KEY_FAVORABILITY][arg1_11] = (arg0_11.data1KeyValueList[var0_0.KEY_FAVORABILITY][arg1_11] or 0) + arg2_11
end

function var0_0.GetFavorability(arg0_12, arg1_12)
	return arg0_12.data1KeyValueList[var0_0.KEY_FAVORABILITY] and arg0_12.data1KeyValueList[var0_0.KEY_FAVORABILITY][arg1_12] or 0
end

function var0_0.readyToAchieve(arg0_13)
	if arg0_13:isEnd() then
		return false
	end

	return arg0_13:GetHireTip() or arg0_13:GetTechnologyTip() or arg0_13:GetTaskTip() or arg0_13:GetGameTip()
end

function var0_0.GetHireTip(arg0_14)
	local var0_14 = ReversePacmanTools.GetInterviewItemID()

	if ReversePacmanTools.GetItemCnt(var0_14) <= 0 then
		return false
	end

	if arg0_14.data1KeyValueList[var0_0.KEY_FAVORABILITY] == nil then
		return true
	end

	local var1_14 = ReversePacmanTools.GetActivity():getConfig("config_client").chasing_char

	for iter0_14, iter1_14 in ipairs(var1_14) do
		if arg0_14.data1KeyValueList[var0_0.KEY_FAVORABILITY][iter1_14] == nil then
			return true
		end
	end

	return false
end

function var0_0.GetTechnologyTip(arg0_15)
	if not ReversePacmanTools.HasHireRole() then
		return false
	end

	return arg0_15:GetGiftTip() or arg0_15:GetRoleSkillTip() or arg0_15:GetPlayerSkillTip()
end

function var0_0.GetGiftTip(arg0_16)
	local var0_16 = ReversePacmanTools.GetGiftItemID()
	local var1_16 = ReversePacmanTools.GetItemCnt(var0_16)

	if var1_16 < 0 then
		return false
	end

	local var2_16 = getProxy(PlayerProxy):getRawData().id
	local var3_16 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	if PlayerPrefs.GetString(string.format("REVERSE_PACMAN_GIFT_%s_%s", var2_16, arg0_16.id)) == var3_16 then
		return false
	end

	for iter0_16, iter1_16 in pairs(arg0_16:GetFavorabilityList()) do
		if ReversePacmanTools.GetMaxFavorabilityValue(iter0_16) > ReversePacmanTools.GetFavorabilityValue(iter0_16) and var1_16 >= pg.activity_chasing_character[iter0_16].need[2] then
			return true
		end
	end

	return false
end

function var0_0.SetGiftTip(arg0_17)
	local var0_17 = getProxy(PlayerProxy):getRawData().id
	local var1_17 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	PlayerPrefs.SetString(string.format("REVERSE_PACMAN_GIFT_%s_%s", var0_17, arg0_17.id), var1_17)
	pg.m02:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
end

function var0_0.GetRoleSkillTip(arg0_18)
	if ReversePacmanTools:GetTechnologyPTDrop():getOwnedCount() <= 0 then
		return false
	end

	local var0_18 = getProxy(PlayerProxy):getRawData().id
	local var1_18 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	if PlayerPrefs.GetString(string.format("REVERSE_PACMAN_ROLE_SKILL_%s_%s", var0_18, arg0_18.id)) == var1_18 then
		return false
	end

	for iter0_18, iter1_18 in ipairs(arg0_18:getConfig("config_client").technologyShopIDList) do
		local var2_18 = pg.activity_shop_template[iter1_18]

		if getProxy(ShopsProxy):getActivityShopById(var2_18.activity):getGoodsById(iter1_18):CheckCntLimit() then
			return true
		end
	end

	return false
end

function var0_0.SetRoleSkillTip(arg0_19)
	local var0_19 = getProxy(PlayerProxy):getRawData().id
	local var1_19 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	PlayerPrefs.SetString(string.format("REVERSE_PACMAN_ROLE_SKILL_%s_%s", var0_19, arg0_19.id), var1_19)
	pg.m02:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
end

function var0_0.GetPlayerSkillTip(arg0_20)
	if ReversePacmanTools:GetTechnologyPTDrop():getOwnedCount() <= 0 then
		return false
	end

	local var0_20 = getProxy(PlayerProxy):getRawData().id
	local var1_20 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	if PlayerPrefs.GetString(string.format("REVERSE_PACMAN_PLAYER_SKILL_%s_%s", var0_20, arg0_20.id)) == var1_20 then
		return false
	end

	for iter0_20, iter1_20 in ipairs(arg0_20:getConfig("config_client").playerSkillShopIDList) do
		local var2_20 = pg.activity_shop_template[iter1_20]

		if getProxy(ShopsProxy):getActivityShopById(var2_20.activity):getGoodsById(iter1_20):CheckCntLimit() then
			return true
		end
	end

	return false
end

function var0_0.SetPlayerSkillTip(arg0_21)
	local var0_21 = getProxy(PlayerProxy):getRawData().id
	local var1_21 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	PlayerPrefs.SetString(string.format("REVERSE_PACMAN_PLAYER_SKILL_%s_%s", var0_21, arg0_21.id), var1_21)
	pg.m02:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
end

function var0_0.GetTaskTip(arg0_22)
	local var0_22 = arg0_22:getConfig("config_client").taskActivityID
	local var1_22 = getProxy(ActivityProxy):getActivityById(var0_22)

	return var1_22 and var1_22:readyToAchieve()
end

function var0_0.GetGameTip(arg0_23)
	if not ReversePacmanTools.HasHireRole() then
		return false
	end

	local var0_23 = ReversePacmanTools.GetUnPassLevelIds()

	if #var0_23 <= 0 then
		return false
	end

	for iter0_23, iter1_23 in ipairs(var0_23) do
		if arg0_23:IsLevelTip(iter1_23) then
			return true
		end
	end

	return false
end

function var0_0.IsLevelTip(arg0_24, arg1_24)
	local var0_24 = getProxy(PlayerProxy):getRawData().id
	local var1_24 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
	local var2_24 = string.format("REVERSE_PACMAN_LEVEL_TIP_%s_%s_%s_%s", var0_24, arg0_24.id, var1_24, arg1_24)

	if PlayerPrefs.GetInt(var2_24) ~= 1 then
		return true
	end

	return false
end

function var0_0.SetLevelTip(arg0_25, arg1_25)
	local var0_25 = getProxy(PlayerProxy):getRawData().id
	local var1_25 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
	local var2_25 = string.format("REVERSE_PACMAN_LEVEL_TIP_%s_%s_%s_%s", var0_25, arg0_25.id, var1_25, arg1_25)

	PlayerPrefs.SetInt(var2_25, 1)
end

return var0_0
