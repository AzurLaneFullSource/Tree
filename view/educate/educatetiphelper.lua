local var0 = class("EducateTipHelper")

var0.system_save_key = "educate_system_unlcok_tip"
var0.system_tip_list = {
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

function var0.GetSystemUnlockTips()
	if not getProxy(EducateProxy):IsFirstGame() then
		return {}
	end

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = {}

	for iter0, iter1 in pairs(var0.system_tip_list) do
		if not (PlayerPrefs.GetInt(var0 .. var0.system_save_key .. iter0, 0) == 1) and EducateHelper.IsSystemUnlock(iter0) then
			table.insert(var1, iter0)
		end
	end

	return var1
end

function var0.SaveSystemUnlockTip(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0 .. var0.system_save_key .. arg0, 1)
	PlayerPrefs.Save()
end

function var0.ClearSystemUnlockTips()
	local var0 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in pairs(var0.system_tip_list) do
		local var1 = var0 .. var0.system_save_key .. iter0

		if PlayerPrefs.HasKey(var1) then
			PlayerPrefs.DeleteKey(var1)
			PlayerPrefs.Save()
		end
	end
end

var0.site_save_key = "educate_site_unlcok_tip"
var0.needTipSiteIds = {}

for iter0, iter1 in ipairs(pg.child_site.all) do
	if pg.child_site[iter1].type == 1 then
		table.insert(var0.needTipSiteIds, iter1)
	end
end

function var0.GetSiteUnlockTipIds()
	if not getProxy(EducateProxy):IsFirstGame() then
		return {}
	end

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = {}

	for iter0, iter1 in ipairs(var0.needTipSiteIds) do
		if not (PlayerPrefs.GetInt(var0 .. var0.site_save_key .. iter1, 0) == 1) and EducateHelper.IsSiteUnlock(iter1, true) then
			table.insert(var1, iter1)
			var0.SetNewTip(var0.NEW_SITE, iter1)
		end
	end

	return var1
end

function var0.SaveSiteUnlockTipId(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0 .. var0.site_save_key .. arg0, 1)
	PlayerPrefs.Save()
end

function var0.ClearSiteUnlockTipIds()
	local var0 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(pg.child_site.all) do
		local var1 = var0 .. var0.site_save_key .. iter1

		if PlayerPrefs.HasKey(var1) then
			PlayerPrefs.DeleteKey(var1)
			PlayerPrefs.Save()
		end
	end
end

var0.plan_save_key = "educate_plan_unlcok_tip"
var0.needTipPlanIds = {}

for iter2, iter3 in ipairs(pg.child_plan.all) do
	if #pg.child_plan[iter3].pre > 0 then
		table.insert(var0.needTipPlanIds, iter3)
	end
end

function var0.GetPlanUnlockTipIds()
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = {}
	local var2 = getProxy(EducateProxy):GetPlanProxy()

	for iter0, iter1 in ipairs(var0.needTipPlanIds) do
		if not (PlayerPrefs.GetInt(var0 .. var0.plan_save_key .. iter1, 0) == 1) then
			local var3 = pg.child_plan[iter1].pre

			if var2:GetHistoryCntById(var3[1]) >= var3[2] then
				table.insert(var1, iter1)
			end
		end
	end

	return var1
end

function var0.SavePlanUnlockTipId(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0 .. var0.plan_save_key .. arg0, 1)
	PlayerPrefs.Save()
end

function var0.ClearPlanUnlockTipIds()
	local var0 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(var0.needTipPlanIds) do
		local var1 = var0 .. var0.plan_save_key .. iter1

		if PlayerPrefs.HasKey(var1) then
			PlayerPrefs.DeleteKey(var1)
			PlayerPrefs.Save()
		end
	end
end

function var0.ClearAllRecord()
	var0.ClearSystemUnlockTips()
	var0.ClearSiteUnlockTipIds()
	var0.ClearPlanUnlockTipIds()
end

var0.NEW_MEMORY = 1
var0.NEW_POLAROID = 2
var0.NEW_MIND_TASK = 3
var0.NEW_SITE = 4
var0.new_tip_keys = {
	[var0.NEW_MEMORY] = "educate_memory_new_tip",
	[var0.NEW_POLAROID] = "educate_polaroid_new_tip",
	[var0.NEW_MIND_TASK] = "educate_mind_task_new_tip",
	[var0.NEW_SITE] = "educate_site_new_tip"
}

function var0.SetNewTip(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = arg1 and tostring(arg1) or ""
	local var2 = var0.new_tip_keys[arg0] .. var1

	if PlayerPrefs.GetInt(var0 .. var2, 0) == 1 then
		return
	end

	PlayerPrefs.SetInt(var0 .. var2, 1)
	PlayerPrefs.Save()
end

function var0.IsShowNewTip(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = arg1 and tostring(arg1) or ""
	local var2 = var0.new_tip_keys[arg0] .. var1

	return PlayerPrefs.GetInt(var0 .. var2, 0) == 1
end

function var0.ClearNewTip(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = arg1 and tostring(arg1) or ""
	local var2 = var0.new_tip_keys[arg0] .. var1
	local var3 = var0 .. var2

	if PlayerPrefs.HasKey(var3) then
		PlayerPrefs.DeleteKey(var3)
		PlayerPrefs.Save()
		pg.m02:sendNotification(EducateProxy.CLEAR_NEW_TIP, {
			index = arg0,
			id = arg1
		})
	end
end

return var0
