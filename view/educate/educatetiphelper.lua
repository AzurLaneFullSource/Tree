local var0_0 = class("EducateTipHelper")

var0_0.system_save_key = "educate_system_unlcok_tip"
var0_0.system_tip_list = {
	[EducateConst.SYSTEM_GO_OUT] = i18n("child_unlock_out"),
	[EducateConst.SYSTEM_MEMORY] = i18n("child_unlock_memory"),
	[EducateConst.SYSTEM_POLAROID] = i18n("child_unlock_polaroid"),
	[EducateConst.SYSTEM_ENDING] = i18n("child_unlock_ending"),
	[EducateConst.SYSTEM_FAVOR_AND_MIND] = i18n("child_unlock_intimacy"),
	[EducateConst.SYSTEM_BUFF] = i18n("child_unlock_buff"),
	[EducateConst.SYSTEM_ATTR_2] = i18n("child_unlock_attr2"),
	[EducateConst.SYSTEM_ATTR_3] = i18n("child_unlock_attr3"),
	[EducateConst.SYSTEM_BAG] = i18n("child_unlock_bag")
}

function var0_0.GetSystemUnlockTips()
	if not getProxy(EducateProxy):IsFirstGame() then
		return {}
	end

	local var0_1 = getProxy(PlayerProxy):getRawData().id
	local var1_1 = {}

	for iter0_1, iter1_1 in pairs(var0_0.system_tip_list) do
		if not (PlayerPrefs.GetInt(var0_1 .. var0_0.system_save_key .. iter0_1, 0) == 1) and EducateHelper.IsSystemUnlock(iter0_1) then
			table.insert(var1_1, iter0_1)
		end
	end

	return var1_1
end

function var0_0.SaveSystemUnlockTip(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_2 .. var0_0.system_save_key .. arg0_2, 1)
	PlayerPrefs.Save()
end

function var0_0.ClearSystemUnlockTips()
	local var0_3 = getProxy(PlayerProxy):getRawData().id

	for iter0_3, iter1_3 in pairs(var0_0.system_tip_list) do
		local var1_3 = var0_3 .. var0_0.system_save_key .. iter0_3

		if PlayerPrefs.HasKey(var1_3) then
			PlayerPrefs.DeleteKey(var1_3)
			PlayerPrefs.Save()
		end
	end
end

var0_0.site_save_key = "educate_site_unlcok_tip"
var0_0.needTipSiteIds = {}

for iter0_0, iter1_0 in ipairs(pg.child_site.all) do
	if pg.child_site[iter1_0].type == 1 then
		table.insert(var0_0.needTipSiteIds, iter1_0)
	end
end

function var0_0.GetSiteUnlockTipIds()
	if not getProxy(EducateProxy):IsFirstGame() then
		return {}
	end

	local var0_4 = getProxy(PlayerProxy):getRawData().id
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(var0_0.needTipSiteIds) do
		if not (PlayerPrefs.GetInt(var0_4 .. var0_0.site_save_key .. iter1_4, 0) == 1) and EducateHelper.IsSiteUnlock(iter1_4, true) then
			table.insert(var1_4, iter1_4)
			var0_0.SetNewTip(var0_0.NEW_SITE, iter1_4)
		end
	end

	return var1_4
end

function var0_0.SaveSiteUnlockTipId(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_5 .. var0_0.site_save_key .. arg0_5, 1)
	PlayerPrefs.Save()
end

function var0_0.ClearSiteUnlockTipIds()
	local var0_6 = getProxy(PlayerProxy):getRawData().id

	for iter0_6, iter1_6 in ipairs(pg.child_site.all) do
		local var1_6 = var0_6 .. var0_0.site_save_key .. iter1_6

		if PlayerPrefs.HasKey(var1_6) then
			PlayerPrefs.DeleteKey(var1_6)
			PlayerPrefs.Save()
		end
	end
end

var0_0.plan_save_key = "educate_plan_unlcok_tip"
var0_0.needTipPlanIds = {}

for iter2_0, iter3_0 in ipairs(pg.child_plan.all) do
	if #pg.child_plan[iter3_0].pre > 0 then
		table.insert(var0_0.needTipPlanIds, iter3_0)
	end
end

function var0_0.GetPlanUnlockTipIds()
	local var0_7 = getProxy(PlayerProxy):getRawData().id
	local var1_7 = {}
	local var2_7 = getProxy(EducateProxy):GetPlanProxy()

	for iter0_7, iter1_7 in ipairs(var0_0.needTipPlanIds) do
		if not (PlayerPrefs.GetInt(var0_7 .. var0_0.plan_save_key .. iter1_7, 0) == 1) then
			local var3_7 = pg.child_plan[iter1_7].pre

			if var2_7:GetHistoryCntById(var3_7[1]) >= var3_7[2] then
				table.insert(var1_7, iter1_7)
			end
		end
	end

	return var1_7
end

function var0_0.SavePlanUnlockTipId(arg0_8)
	local var0_8 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_8 .. var0_0.plan_save_key .. arg0_8, 1)
	PlayerPrefs.Save()
end

function var0_0.ClearPlanUnlockTipIds()
	local var0_9 = getProxy(PlayerProxy):getRawData().id

	for iter0_9, iter1_9 in ipairs(var0_0.needTipPlanIds) do
		local var1_9 = var0_9 .. var0_0.plan_save_key .. iter1_9

		if PlayerPrefs.HasKey(var1_9) then
			PlayerPrefs.DeleteKey(var1_9)
			PlayerPrefs.Save()
		end
	end
end

function var0_0.ClearAllRecord()
	var0_0.ClearSystemUnlockTips()
	var0_0.ClearSiteUnlockTipIds()
	var0_0.ClearPlanUnlockTipIds()
end

var0_0.NEW_MEMORY = 1
var0_0.NEW_POLAROID = 2
var0_0.NEW_MIND_TASK = 3
var0_0.NEW_SITE = 4
var0_0.new_tip_keys = {
	[var0_0.NEW_MEMORY] = "educate_memory_new_tip",
	[var0_0.NEW_POLAROID] = "educate_polaroid_new_tip",
	[var0_0.NEW_MIND_TASK] = "educate_mind_task_new_tip",
	[var0_0.NEW_SITE] = "educate_site_new_tip"
}

function var0_0.SetNewTip(arg0_11, arg1_11)
	local var0_11 = getProxy(PlayerProxy):getRawData().id
	local var1_11 = arg1_11 and tostring(arg1_11) or ""
	local var2_11 = var0_0.new_tip_keys[arg0_11] .. var1_11

	if PlayerPrefs.GetInt(var0_11 .. var2_11, 0) == 1 then
		return
	end

	PlayerPrefs.SetInt(var0_11 .. var2_11, 1)
	PlayerPrefs.Save()
end

function var0_0.IsShowNewTip(arg0_12, arg1_12)
	local var0_12 = getProxy(PlayerProxy):getRawData().id
	local var1_12 = arg1_12 and tostring(arg1_12) or ""
	local var2_12 = var0_0.new_tip_keys[arg0_12] .. var1_12

	return PlayerPrefs.GetInt(var0_12 .. var2_12, 0) == 1
end

function var0_0.ClearNewTip(arg0_13, arg1_13)
	local var0_13 = getProxy(PlayerProxy):getRawData().id
	local var1_13 = arg1_13 and tostring(arg1_13) or ""
	local var2_13 = var0_0.new_tip_keys[arg0_13] .. var1_13
	local var3_13 = var0_13 .. var2_13

	if PlayerPrefs.HasKey(var3_13) then
		PlayerPrefs.DeleteKey(var3_13)
		PlayerPrefs.Save()
		pg.m02:sendNotification(EducateProxy.CLEAR_NEW_TIP, {
			index = arg0_13,
			id = arg1_13
		})
	end
end

return var0_0
