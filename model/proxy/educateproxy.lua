local var0_0 = class("EducateProxy", import(".NetProxy"))

var0_0.RESOURCE_UPDATED = "EducateProxy.RESOURCE_UPDATED"
var0_0.ATTR_UPDATED = "EducateProxy.ATTR_UPDATED"
var0_0.TIME_UPDATED = "EducateProxy.TIME_UPDATED"
var0_0.TIME_WEEKDAY_UPDATED = "EducateProxy.TIME_WEEKDAY_UPDATED"
var0_0.BUFF_ADDED = "EducateProxy.BUFF_ADDED"
var0_0.OPTION_UPDATED = "EducateProxy.OPTION_UPDATED"
var0_0.ENDING_ADDED = "EducateProxy.ENDING_ADDED"
var0_0.ITEM_ADDED = "EducateProxy.ITEM_ADDED"
var0_0.POLAROID_ADDED = "EducateProxy.POLAROID_ADDED"
var0_0.MEMORY_ADDED = "EducateProxy.MEMORY_ADDED"
var0_0.UNLCOK_NEW_SECRETARY_BY_CNT = "EducateProxy.UNLCOK_NEW_SECRETARY_BY_CNT"
var0_0.GUIDE_CHECK = "EducateProxy.GUIDE_CHECK"
var0_0.MAIN_SCENE_ADD_LAYER = "EducateProxy.MAIN_SCENE_ADD_LAYER"
var0_0.CLEAR_NEW_TIP = "EducateProxy.CLEAR_NEW_TIP"

function var0_0.register(arg0_1)
	arg0_1.planProxy = EducatePlanProxy.New(arg0_1)
	arg0_1.eventProxy = EducateEventProxy.New(arg0_1)
	arg0_1.shopProxy = EducateShopProxy.New(arg0_1)
	arg0_1.taskProxy = EducateTaskProxy.New(arg0_1)
	arg0_1.endTime = pg.gameset.child_end_data.description

	arg0_1:on(27021, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.tasks) do
			arg0_1.taskProxy:AddTask(iter1_2)
		end
	end)
	arg0_1:on(27022, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.ids) do
			arg0_1.taskProxy:RemoveTaskById(iter1_3)
		end
	end)
	arg0_1:on(27025, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.tasks) do
			arg0_1.taskProxy:UpdateTask(iter1_4)
		end
	end)
end

function var0_0.initData(arg0_5, arg1_5)
	arg0_5:sendNotification(GAME.EDUCATE_GET_ENDINGS)

	local var0_5 = arg1_5.child

	arg0_5.exsitEnding = var0_5.is_ending == 1 or false
	arg0_5.gameCount = var0_5.new_game_plus_count
	arg0_5.curTime = var0_5.cur_time or {
		week = 1,
		month = 3,
		day = 7
	}
	arg0_5.char = EducateChar.New(var0_5)

	arg0_5.eventProxy:SetUp({
		waitTriggerEventIds = var0_5.home_events,
		needRequestHomeEvents = var0_5.can_trigger_home_event == 1 or false,
		finishSpecEventIds = var0_5.spec_events
	})
	arg0_5.planProxy:SetUp({
		history = var0_5.plan_history,
		selectedPlans = var0_5.plans
	})
	arg0_5.shopProxy:SetUp({
		shops = var0_5.shop,
		discountEventIds = var0_5.discount_event_id
	})
	arg0_5.taskProxy:SetUp({
		targetId = var0_5.target,
		tasks = var0_5.tasks,
		finishMindTaskIds = var0_5.realized_wish,
		isGotTargetAward = var0_5.had_target_stage_award == 1 or false
	})
	arg0_5:initItems(var0_5.items)
	arg0_5:initPolaroids(var0_5.polaroids)

	arg0_5.memories = var0_5.memorys

	arg0_5:initBuffs(var0_5.buffs)
	arg0_5:initOptions(var0_5.option_records)

	arg0_5.siteRandomOpts = nil

	arg0_5:UpdateGameStatus()
	arg0_5:initVirtualStage()
	arg0_5:initUnlockSecretary(var0_5.is_special_secretary_valid == 1)

	arg0_5.requestDataEnd = true
end

function var0_0.CheckDataRequestEnd(arg0_6)
	return arg0_6.requestDataEnd
end

function var0_0.initItems(arg0_7, arg1_7)
	arg0_7.itemData = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		arg0_7.itemData[iter1_7.id] = EducateItem.New(iter1_7)
	end
end

function var0_0.initOptions(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		var0_8[iter1_8.id] = iter1_8.count
	end

	arg0_8.siteOptionData = {}

	for iter2_8, iter3_8 in ipairs(pg.child_site_option.all) do
		local var1_8 = EducateSiteOption.New(iter3_8, var0_8[iter3_8])

		arg0_8.siteOptionData[iter3_8] = var1_8
	end
end

function var0_0.initRandomOpts(arg0_9, arg1_9)
	arg0_9.siteRandomOpts = {}

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		arg0_9.siteRandomOpts[iter1_9.site_id] = iter1_9.option_ids
	end
end

function var0_0.NeedRequestOptsData(arg0_10)
	return not arg0_10.siteRandomOpts
end

function var0_0.initBuffs(arg0_11, arg1_11)
	arg0_11.buffData = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		arg0_11.buffData[iter1_11.id] = EducateBuff.New(iter1_11)
	end
end

function var0_0.initPolaroids(arg0_12, arg1_12)
	arg0_12.polaroidData = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		arg0_12.polaroidData[iter1_12.id] = EducatePolaroid.New(iter1_12)
	end
end

function var0_0.SetEndings(arg0_13, arg1_13)
	arg0_13.endings = arg1_13

	arg0_13:updateSecretaryIDs(false)
end

function var0_0.GetSelectInfo(arg0_14)
	local var0_14 = EducateHelper.GetShowMonthNumber(arg0_14.curTime.month) .. i18n("word_month") .. i18n("word_which_week", arg0_14.curTime.week)

	return {
		bg = arg0_14.char:GetBGName(),
		name = arg0_14.char:GetName(),
		gameCnt = arg0_14.gameCount,
		progressStr = arg0_14.isUnlockSecretary and var0_14 or i18n("child2_not_start")
	}
end

function var0_0.IsFirstGame(arg0_15)
	return arg0_15.gameCount == 1
end

function var0_0.UpdateGameStatus(arg0_16)
	arg0_16.gameStatus = EducateConst.STATUES_NORMAL

	if arg0_16.exsitEnding then
		arg0_16.gameStatus = EducateConst.STATUES_RESET
	elseif arg0_16:IsEndingTime() then
		arg0_16.gameStatus = EducateConst.STATUES_ENDING
	elseif arg0_16.taskProxy:CheckTargetSet() then
		arg0_16.gameStatus = EducateConst.STATUES_PREPARE
	end
end

function var0_0.GetGameStatus(arg0_17)
	return arg0_17.gameStatus
end

function var0_0.initVirtualStage(arg0_18)
	local var0_18 = getProxy(EducateProxy):GetTaskProxy():GetTargetId()
	local var1_18 = arg0_18.char:GetStage()

	if var0_18 ~= 0 and pg.child_target_set[var0_18].stage == var1_18 + 1 then
		arg0_18.isVirtualStage = true
	else
		arg0_18.isVirtualStage = false
	end
end

function var0_0.SetVirtualStage(arg0_19, arg1_19)
	arg0_19.isVirtualStage = arg1_19
end

function var0_0.InVirtualStage(arg0_20)
	return arg0_20.isVirtualStage
end

function var0_0.Reset(arg0_21, arg1_21)
	EducateTipHelper.ClearAllRecord()
	arg0_21:GetPlanProxy():ClearLocalPlansData()
	arg0_21:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_21
	})
end

function var0_0.Refresh(arg0_22, arg1_22)
	EducateTipHelper.ClearAllRecord()
	arg0_22:GetPlanProxy():ClearLocalPlansData()
	arg0_22:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_22
	})
end

function var0_0.GetCurTime(arg0_23)
	return arg0_23.curTime
end

function var0_0.UpdateTime(arg0_24)
	arg0_24.curTime.week = arg0_24.curTime.week + 1

	if arg0_24.curTime.week > 4 then
		arg0_24.curTime.week = 1
		arg0_24.curTime.month = arg0_24.curTime.month + 1
	end
end

function var0_0.OnNextWeek(arg0_25)
	arg0_25:SetVirtualStage(false)
	arg0_25:UpdateTime()
	arg0_25.char:OnNewWeek(arg0_25.curTime)
	arg0_25.planProxy:OnNewWeek(arg0_25.curTime)
	arg0_25.eventProxy:OnNewWeek(arg0_25.curTime)
	arg0_25.shopProxy:OnNewWeek(arg0_25.curTime)
	arg0_25.taskProxy:OnNewWeek(arg0_25.curTime)
	arg0_25:RefreshBuffs()
	arg0_25:RefreshOptions()

	arg0_25.siteRandomOpts = nil

	arg0_25:UpdateGameStatus()
	arg0_25:sendNotification(var0_0.TIME_UPDATED)
end

function var0_0.GetCharData(arg0_26)
	return arg0_26.char
end

function var0_0.GetPersonalityId(arg0_27)
	return arg0_27.char:GetPersonalityId()
end

function var0_0.UpdateRes(arg0_28, arg1_28, arg2_28)
	arg0_28.char:UpdateRes(arg1_28, arg2_28)
	arg0_28:sendNotification(var0_0.RESOURCE_UPDATED)
end

function var0_0.ReduceResForPlans(arg0_29)
	local var0_29, var1_29 = arg0_29.planProxy:GetCost()

	arg0_29:UpdateRes(EducateChar.RES_MONEY_ID, -var0_29)
	arg0_29:UpdateRes(EducateChar.RES_MOOD_ID, -var1_29)
end

function var0_0.ReduceResForCosts(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(arg1_30) do
		arg0_30:UpdateRes(iter1_30.id, -iter1_30.num)
	end
end

function var0_0.UpdateAttr(arg0_31, arg1_31, arg2_31)
	arg0_31.char:UpdateAttr(arg1_31, arg2_31)
	arg0_31:sendNotification(var0_0.ATTR_UPDATED)
end

function var0_0.CheckExtraAttr(arg0_32)
	return arg0_32.char:CheckExtraAttrAdd()
end

function var0_0.AddExtraAttr(arg0_33, arg1_33)
	arg0_33:UpdateAttr(arg1_33, arg0_33.char:getConfig("attr_2_add"))
	arg0_33.char:SetIsAddedExtraAttr(true)
end

function var0_0.GetPlanProxy(arg0_34)
	return arg0_34.planProxy
end

function var0_0.GetEventProxy(arg0_35)
	return arg0_35.eventProxy
end

function var0_0.GetShopProxy(arg0_36)
	return arg0_36.shopProxy
end

function var0_0.GetTaskProxy(arg0_37)
	return arg0_37.taskProxy
end

function var0_0.GetFinishEndings(arg0_38)
	return arg0_38.endings
end

function var0_0.AddEnding(arg0_39, arg1_39)
	arg0_39.exsitEnding = true

	arg0_39:UpdateGameStatus()

	if table.contains(arg0_39.endings, arg1_39) then
		return
	end

	table.insert(arg0_39.endings, arg1_39)
	arg0_39:updateSecretaryIDs(true)
	arg0_39:sendNotification(var0_0.ENDING_ADDED)
end

function var0_0.IsEndingTime(arg0_40)
	local var0_40 = arg0_40:GetCurTime()

	if var0_40.month >= arg0_40.endTime[1] and var0_40.week >= arg0_40.endTime[2] and var0_40.day >= arg0_40.endTime[3] then
		return true
	end

	return false
end

function var0_0.GetEndingResult(arg0_41)
	local var0_41 = underscore.detect(pg.child_ending.all, function(arg0_42)
		local var0_42 = pg.child_ending[arg0_42].condition

		return arg0_41.char:CheckEndCondition(var0_42)
	end)

	assert(var0_41, "not matching ending")

	return var0_41
end

function var0_0.GetBuffData(arg0_43)
	return arg0_43.buffData
end

function var0_0.GetBuffList(arg0_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.buffData) do
		table.insert(var0_44, iter1_44)
	end

	return var0_44
end

function var0_0.AddBuff(arg0_45, arg1_45)
	if arg0_45.buffData[arg1_45] then
		arg0_45.buffData[arg1_45]:ResetEndTime()
	else
		arg0_45.buffData[arg1_45] = EducateBuff.New({
			id = arg1_45
		})
	end

	arg0_45:sendNotification(var0_0.BUFF_ADDED)
end

function var0_0.RefreshBuffs(arg0_46)
	for iter0_46, iter1_46 in pairs(arg0_46.buffData) do
		if iter1_46:IsEnd() then
			arg0_46.buffData[iter1_46.id] = nil
		end
	end
end

function var0_0.GetAttrBuffEffects(arg0_47, arg1_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.buffData) do
		if iter1_47:IsAttrType() and iter1_47:IsId(arg1_47) then
			table.insert(var0_47, iter1_47)
		end
	end

	return EducateBuff.GetBuffEffects(var0_47)
end

function var0_0.GetResBuffEffects(arg0_48, arg1_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.buffData) do
		if iter1_48:IsResType() and iter1_48:IsId(arg1_48) then
			table.insert(var0_48, iter1_48)
		end
	end

	return EducateBuff.GetBuffEffects(var0_48)
end

function var0_0.GetOptionById(arg0_49, arg1_49)
	return arg0_49.siteOptionData[arg1_49]
end

function var0_0.UpdateOptionData(arg0_50, arg1_50)
	arg0_50.siteOptionData[arg1_50.id] = arg1_50

	arg0_50:sendNotification(var0_0.OPTION_UPDATED)
end

function var0_0.RefreshOptions(arg0_51)
	local var0_51 = arg0_51:GetCurTime()

	for iter0_51, iter1_51 in pairs(arg0_51.siteOptionData) do
		iter1_51:OnWeekUpdate(var0_51)
	end
end

function var0_0.GetShowSiteIds(arg0_52)
	return underscore.select(pg.child_site.all, function(arg0_53)
		return pg.child_site[arg0_53].type == 1 and EducateHelper.IsSiteUnlock(arg0_53, arg0_52:IsFirstGame())
	end)
end

function var0_0.GetOptionsBySiteId(arg0_54, arg1_54)
	local var0_54 = pg.child_site[arg1_54].option
	local var1_54 = arg0_54:GetCurTime()
	local var2_54 = {}
	local var3_54 = {}

	underscore.each(var0_54, function(arg0_55)
		local var0_55 = arg0_54.siteOptionData[arg0_55]

		if var0_55 and var0_55:IsShow(var1_54) then
			if var0_55:IsReplace() then
				var3_54[var0_55:getConfig("replace")] = var0_55
			else
				table.insert(var2_54, var0_55)
			end
		end
	end)
	underscore.each(var2_54, function(arg0_56)
		if var3_54[arg0_56.id] then
			table.removebyvalue(var2_54, arg0_56)
			table.insert(var2_54, var3_54[arg0_56.id])
		end
	end)

	local var4_54 = arg0_54.siteRandomOpts and arg0_54.siteRandomOpts[arg1_54] or {}

	underscore.each(var4_54, function(arg0_57)
		local var0_57 = arg0_54.siteOptionData[arg0_57]

		if var0_57:IsShow(var1_54) then
			table.insert(var2_54, var0_57)
		end
	end)
	table.sort(var2_54, CompareFuncs({
		function(arg0_58)
			return arg0_58:getConfig("order")
		end,
		function(arg0_59)
			return arg0_59.id
		end
	}))

	return var2_54
end

function var0_0.GetItemData(arg0_60)
	return arg0_60.itemData
end

function var0_0.GetItemList(arg0_61)
	local var0_61 = {}

	for iter0_61, iter1_61 in pairs(arg0_61.itemData) do
		table.insert(var0_61, iter1_61)
	end

	return var0_61
end

function var0_0.AddItem(arg0_62, arg1_62, arg2_62)
	if arg0_62.itemData[arg1_62] then
		arg0_62.itemData[arg1_62]:AddCount(arg2_62)
	else
		arg0_62.itemData[arg1_62] = EducateItem.New({
			id = arg1_62,
			num = arg2_62
		})
	end

	arg0_62:sendNotification(var0_0.ITEM_ADDED)
end

function var0_0.GetItemCntById(arg0_63, arg1_63)
	return arg0_63.itemData[arg1_63] and arg0_63.itemData[arg1_63].count or 0
end

function var0_0.GetPolaroidData(arg0_64)
	return arg0_64.polaroidData
end

function var0_0.GetPolaroidList(arg0_65)
	local var0_65 = {}

	for iter0_65, iter1_65 in pairs(arg0_65.polaroidData) do
		table.insert(var0_65, iter1_65)
	end

	return var0_65
end

function var0_0.GetPolaroidIdList(arg0_66)
	local var0_66 = {}

	for iter0_66, iter1_66 in pairs(arg0_66.polaroidData) do
		table.insert(var0_66, iter0_66)
	end

	return var0_66
end

function var0_0.AddPolaroid(arg0_67, arg1_67)
	if arg0_67.polaroidData[arg1_67] then
		return
	end

	arg0_67.polaroidData[arg1_67] = EducatePolaroid.New({
		id = arg1_67,
		time = arg0_67:GetCurTime()
	})

	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_POLAROID)
	arg0_67:updateSecretaryIDs(true)
	arg0_67:sendNotification(var0_0.POLAROID_ADDED)
end

function var0_0.IsExistPolaroidByGroup(arg0_68, arg1_68)
	local var0_68 = pg.child_polaroid.get_id_list_by_group[arg1_68]

	return underscore.any(var0_68, function(arg0_69)
		return arg0_68.polaroidData[arg0_69]
	end)
end

function var0_0.CanGetPolaroidByGroup(arg0_70, arg1_70)
	local var0_70 = pg.child_polaroid.get_id_list_by_group[arg1_70]

	return underscore.any(var0_70, function(arg0_71)
		return arg0_70:CanGetPolaroidById(arg0_71)
	end)
end

function var0_0.CanGetPolaroidById(arg0_72, arg1_72)
	local var0_72 = arg0_72.char:GetStage()
	local var1_72 = arg0_72:GetPersonalityId()
	local var2_72 = pg.child_polaroid[arg1_72]

	if table.contains(var2_72.stage, var0_72) then
		if var2_72.xingge == "" then
			return true
		end

		return table.contains(var2_72.xingge, var1_72)
	end

	return false
end

function var0_0.GetPolaroidGroupCnt(arg0_73)
	local var0_73 = 0
	local var1_73 = 0

	for iter0_73, iter1_73 in pairs(pg.child_polaroid.get_id_list_by_group) do
		if arg0_73:IsExistPolaroidByGroup(iter0_73) then
			var0_73 = var0_73 + 1
		end

		var1_73 = var1_73 + 1
	end

	return var0_73, var1_73
end

function var0_0.GetMemories(arg0_74)
	return arg0_74.memories
end

function var0_0.AddMemory(arg0_75, arg1_75)
	if table.contains(arg0_75.memories, arg1_75) then
		return
	end

	table.insert(arg0_75.memories, arg1_75)
	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MEMORY, arg1_75)
	arg0_75:sendNotification(var0_0.MEMORY_ADDED)
end

function var0_0.CheckGuide(arg0_76, arg1_76)
	arg0_76:sendNotification(var0_0.GUIDE_CHECK, {
		view = arg1_76
	})
end

function var0_0.MainAddLayer(arg0_77, arg1_77)
	arg0_77:sendNotification(var0_0.MAIN_SCENE_ADD_LAYER, arg1_77)
end

function var0_0.initUnlockSecretary(arg0_78, arg1_78)
	arg0_78.isUnlockSecretary = arg1_78
	arg0_78.unlockSecretaryTaskId = (function()
		for iter0_79, iter1_79 in ipairs(pg.secretary_special_ship.all) do
			if pg.secretary_special_ship[iter1_79].unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT then
				return pg.secretary_special_ship[iter1_79].unlock[1]
			end
		end
	end)()
	arg0_78.unlcokTipByPolaroidCnt = {}

	for iter0_78, iter1_78 in ipairs(pg.secretary_special_ship.all) do
		local var0_78 = pg.secretary_special_ship[iter1_78]

		if var0_78.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1_78 = var0_78.unlock[1]

			if not table.contains(arg0_78.unlcokTipByPolaroidCnt, var1_78) then
				table.insert(arg0_78.unlcokTipByPolaroidCnt, var1_78)
			end
		end
	end
end

function var0_0.GetUnlockSecretaryTaskId(arg0_80)
	return arg0_80.unlockSecretaryTaskId
end

function var0_0.SetSecretaryUnlock(arg0_81)
	arg0_81.isUnlockSecretary = true

	arg0_81:updateSecretaryIDs(false)
end

function var0_0.CheckNewSecretaryTip(arg0_82)
	local var0_82 = arg0_82:GetPolaroidGroupCnt()

	if table.contains(arg0_82.unlcokTipByPolaroidCnt, var0_82) then
		arg0_82:updateSecretaryIDs(false)
		arg0_82:sendNotification(var0_0.UNLCOK_NEW_SECRETARY_BY_CNT)

		return true
	end

	return false
end

function var0_0.checkSecretaryID(arg0_83, arg1_83, arg2_83)
	if arg2_83 == "or" then
		for iter0_83, iter1_83 in ipairs(arg1_83) do
			if table.contains(arg0_83.endings, iter1_83[1]) then
				return true
			end
		end

		return false
	elseif arg2_83 == "and" then
		for iter2_83, iter3_83 in ipairs(arg1_83) do
			if not table.contains(arg0_83.endings, iter3_83) then
				return false
			end

			return true
		end
	end

	return false
end

function var0_0.updateSecretaryIDs(arg0_84, arg1_84)
	if not arg0_84:IsUnlockSecretary() then
		arg0_84.unlockSecretaryIds = {}

		return
	end

	local var0_84

	if arg1_84 then
		var0_84 = Clone(NewEducateHelper.GetAllUnlockSecretaryIds())
	end

	arg0_84.unlockSecretaryIds = {}

	local var1_84 = #arg0_84:GetPolaroidIdList()

	for iter0_84, iter1_84 in ipairs(pg.secretary_special_ship.get_id_list_by_tb_id[0]) do
		local var2_84 = pg.secretary_special_ship[iter1_84].unlock_type
		local var3_84 = pg.secretary_special_ship[iter1_84].unlock

		switch(var2_84, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				if arg0_84:IsUnlockSecretary() then
					table.insert(arg0_84.unlockSecretaryIds, iter1_84)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var3_84[1] and var1_84 >= var3_84[1] then
					table.insert(arg0_84.unlockSecretaryIds, iter1_84)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var3_84[1] then
					if type(var3_84[1]) == "table" then
						if arg0_84:checkSecretaryID(var3_84, "or") then
							table.insert(arg0_84.unlockSecretaryIds, iter1_84)
						end
					elseif type(var3_84[1]) == "number" and arg0_84:checkSecretaryID(var3_84, "and") then
						table.insert(arg0_84.unlockSecretaryIds, iter1_84)
					end
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_SHOP] = function()
				if var3_84[1] and getProxy(ShipSkinProxy):hasSkin(var3_84[1]) then
					table.insert(arg0_84.unlockSecretaryIds, iter1_84)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_STORY] = function()
				return
			end
		})
	end

	if arg1_84 then
		getProxy(SettingsProxy):UpdateEducateCharTip(var0_84)
	end
end

function var0_0.GetEducateGroupList(arg0_90)
	local var0_90 = {}

	for iter0_90, iter1_90 in pairs(pg.secretary_special_ship.get_id_list_by_group) do
		table.insert(var0_90, EducateCharGroup.New(iter0_90))
	end

	return var0_90
end

function var0_0.GetStoryInfo(arg0_91)
	return arg0_91.char:GetPaintingName(), arg0_91.char:GetCallName(), arg0_91.char:GetBGName()
end

function var0_0.GetSecretaryIDs(arg0_92)
	return arg0_92.unlockSecretaryIds
end

function var0_0.GetPolaroidCnt(arg0_93)
	return #arg0_93:GetPolaroidIdList()
end

function var0_0.IsUnlockSecretary(arg0_94)
	return arg0_94.isUnlockSecretary
end

function var0_0.remove(arg0_95)
	return
end

return var0_0
