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

	arg0_13:updateSecretaryIDs()
end

function var0_0.IsFirstGame(arg0_14)
	return arg0_14.gameCount == 1
end

function var0_0.UpdateGameStatus(arg0_15)
	arg0_15.gameStatus = EducateConst.STATUES_NORMAL

	if arg0_15.exsitEnding then
		arg0_15.gameStatus = EducateConst.STATUES_RESET
	elseif arg0_15:IsEndingTime() then
		arg0_15.gameStatus = EducateConst.STATUES_ENDING
	elseif arg0_15.taskProxy:CheckTargetSet() then
		arg0_15.gameStatus = EducateConst.STATUES_PREPARE
	end
end

function var0_0.GetGameStatus(arg0_16)
	return arg0_16.gameStatus
end

function var0_0.initVirtualStage(arg0_17)
	local var0_17 = getProxy(EducateProxy):GetTaskProxy():GetTargetId()
	local var1_17 = arg0_17.char:GetStage()

	if var0_17 ~= 0 and pg.child_target_set[var0_17].stage == var1_17 + 1 then
		arg0_17.isVirtualStage = true
	else
		arg0_17.isVirtualStage = false
	end
end

function var0_0.SetVirtualStage(arg0_18, arg1_18)
	arg0_18.isVirtualStage = arg1_18
end

function var0_0.InVirtualStage(arg0_19)
	return arg0_19.isVirtualStage
end

function var0_0.Reset(arg0_20, arg1_20)
	EducateTipHelper.ClearAllRecord()
	arg0_20:GetPlanProxy():ClearLocalPlansData()
	arg0_20:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_20
	})
end

function var0_0.Refresh(arg0_21, arg1_21)
	EducateTipHelper.ClearAllRecord()
	arg0_21:GetPlanProxy():ClearLocalPlansData()
	arg0_21:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_21
	})
end

function var0_0.GetCurTime(arg0_22)
	return arg0_22.curTime
end

function var0_0.UpdateTime(arg0_23)
	arg0_23.curTime.week = arg0_23.curTime.week + 1

	if arg0_23.curTime.week > 4 then
		arg0_23.curTime.week = 1
		arg0_23.curTime.month = arg0_23.curTime.month + 1
	end
end

function var0_0.OnNextWeek(arg0_24)
	arg0_24:SetVirtualStage(false)
	arg0_24:UpdateTime()
	arg0_24.char:OnNewWeek(arg0_24.curTime)
	arg0_24.planProxy:OnNewWeek(arg0_24.curTime)
	arg0_24.eventProxy:OnNewWeek(arg0_24.curTime)
	arg0_24.shopProxy:OnNewWeek(arg0_24.curTime)
	arg0_24.taskProxy:OnNewWeek(arg0_24.curTime)
	arg0_24:RefreshBuffs()
	arg0_24:RefreshOptions()

	arg0_24.siteRandomOpts = nil

	arg0_24:UpdateGameStatus()
	arg0_24:sendNotification(var0_0.TIME_UPDATED)
end

function var0_0.GetCharData(arg0_25)
	return arg0_25.char
end

function var0_0.GetPersonalityId(arg0_26)
	return arg0_26.char:GetPersonalityId()
end

function var0_0.UpdateRes(arg0_27, arg1_27, arg2_27)
	arg0_27.char:UpdateRes(arg1_27, arg2_27)
	arg0_27:sendNotification(var0_0.RESOURCE_UPDATED)
end

function var0_0.ReduceResForPlans(arg0_28)
	local var0_28, var1_28 = arg0_28.planProxy:GetCost()

	arg0_28:UpdateRes(EducateChar.RES_MONEY_ID, -var0_28)
	arg0_28:UpdateRes(EducateChar.RES_MOOD_ID, -var1_28)
end

function var0_0.ReduceResForCosts(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg1_29) do
		arg0_29:UpdateRes(iter1_29.id, -iter1_29.num)
	end
end

function var0_0.UpdateAttr(arg0_30, arg1_30, arg2_30)
	arg0_30.char:UpdateAttr(arg1_30, arg2_30)
	arg0_30:sendNotification(var0_0.ATTR_UPDATED)
end

function var0_0.CheckExtraAttr(arg0_31)
	return arg0_31.char:CheckExtraAttrAdd()
end

function var0_0.AddExtraAttr(arg0_32, arg1_32)
	arg0_32:UpdateAttr(arg1_32, arg0_32.char:getConfig("attr_2_add"))
	arg0_32.char:SetIsAddedExtraAttr(true)
end

function var0_0.GetPlanProxy(arg0_33)
	return arg0_33.planProxy
end

function var0_0.GetEventProxy(arg0_34)
	return arg0_34.eventProxy
end

function var0_0.GetShopProxy(arg0_35)
	return arg0_35.shopProxy
end

function var0_0.GetTaskProxy(arg0_36)
	return arg0_36.taskProxy
end

function var0_0.GetFinishEndings(arg0_37)
	return arg0_37.endings
end

function var0_0.AddEnding(arg0_38, arg1_38)
	arg0_38.exsitEnding = true

	arg0_38:UpdateGameStatus()

	if table.contains(arg0_38.endings, arg1_38) then
		return
	end

	table.insert(arg0_38.endings, arg1_38)

	local var0_38 = Clone(arg0_38:GetSecretaryIDs())

	arg0_38:updateSecretaryIDs()
	getProxy(SettingsProxy):UpdateEducateCharTip(var0_38)
	arg0_38:sendNotification(var0_0.ENDING_ADDED)
end

function var0_0.IsEndingTime(arg0_39)
	local var0_39 = arg0_39:GetCurTime()

	if var0_39.month >= arg0_39.endTime[1] and var0_39.week >= arg0_39.endTime[2] and var0_39.day >= arg0_39.endTime[3] then
		return true
	end

	return false
end

function var0_0.GetEndingResult(arg0_40)
	local var0_40 = underscore.detect(pg.child_ending.all, function(arg0_41)
		local var0_41 = pg.child_ending[arg0_41].condition

		return arg0_40.char:CheckEndCondition(var0_41)
	end)

	assert(var0_40, "not matching ending")

	return var0_40
end

function var0_0.GetBuffData(arg0_42)
	return arg0_42.buffData
end

function var0_0.GetBuffList(arg0_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in pairs(arg0_43.buffData) do
		table.insert(var0_43, iter1_43)
	end

	return var0_43
end

function var0_0.AddBuff(arg0_44, arg1_44)
	if arg0_44.buffData[arg1_44] then
		arg0_44.buffData[arg1_44]:ResetEndTime()
	else
		arg0_44.buffData[arg1_44] = EducateBuff.New({
			id = arg1_44
		})
	end

	arg0_44:sendNotification(var0_0.BUFF_ADDED)
end

function var0_0.RefreshBuffs(arg0_45)
	for iter0_45, iter1_45 in pairs(arg0_45.buffData) do
		if iter1_45:IsEnd() then
			arg0_45.buffData[iter1_45.id] = nil
		end
	end
end

function var0_0.GetAttrBuffEffects(arg0_46, arg1_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.buffData) do
		if iter1_46:IsAttrType() and iter1_46:IsId(arg1_46) then
			table.insert(var0_46, iter1_46)
		end
	end

	return EducateBuff.GetBuffEffects(var0_46)
end

function var0_0.GetResBuffEffects(arg0_47, arg1_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in pairs(arg0_47.buffData) do
		if iter1_47:IsResType() and iter1_47:IsId(arg1_47) then
			table.insert(var0_47, iter1_47)
		end
	end

	return EducateBuff.GetBuffEffects(var0_47)
end

function var0_0.GetOptionById(arg0_48, arg1_48)
	return arg0_48.siteOptionData[arg1_48]
end

function var0_0.UpdateOptionData(arg0_49, arg1_49)
	arg0_49.siteOptionData[arg1_49.id] = arg1_49

	arg0_49:sendNotification(var0_0.OPTION_UPDATED)
end

function var0_0.RefreshOptions(arg0_50)
	local var0_50 = arg0_50:GetCurTime()

	for iter0_50, iter1_50 in pairs(arg0_50.siteOptionData) do
		iter1_50:OnWeekUpdate(var0_50)
	end
end

function var0_0.GetShowSiteIds(arg0_51)
	return underscore.select(pg.child_site.all, function(arg0_52)
		return pg.child_site[arg0_52].type == 1 and EducateHelper.IsSiteUnlock(arg0_52, arg0_51:IsFirstGame())
	end)
end

function var0_0.GetOptionsBySiteId(arg0_53, arg1_53)
	local var0_53 = pg.child_site[arg1_53].option
	local var1_53 = arg0_53:GetCurTime()
	local var2_53 = {}
	local var3_53 = {}

	underscore.each(var0_53, function(arg0_54)
		local var0_54 = arg0_53.siteOptionData[arg0_54]

		if var0_54 and var0_54:IsShow(var1_53) then
			if var0_54:IsReplace() then
				var3_53[var0_54:getConfig("replace")] = var0_54
			else
				table.insert(var2_53, var0_54)
			end
		end
	end)
	underscore.each(var2_53, function(arg0_55)
		if var3_53[arg0_55.id] then
			table.removebyvalue(var2_53, arg0_55)
			table.insert(var2_53, var3_53[arg0_55.id])
		end
	end)

	local var4_53 = arg0_53.siteRandomOpts and arg0_53.siteRandomOpts[arg1_53] or {}

	underscore.each(var4_53, function(arg0_56)
		local var0_56 = arg0_53.siteOptionData[arg0_56]

		if var0_56:IsShow(var1_53) then
			table.insert(var2_53, var0_56)
		end
	end)
	table.sort(var2_53, CompareFuncs({
		function(arg0_57)
			return arg0_57:getConfig("order")
		end,
		function(arg0_58)
			return arg0_58.id
		end
	}))

	return var2_53
end

function var0_0.GetItemData(arg0_59)
	return arg0_59.itemData
end

function var0_0.GetItemList(arg0_60)
	local var0_60 = {}

	for iter0_60, iter1_60 in pairs(arg0_60.itemData) do
		table.insert(var0_60, iter1_60)
	end

	return var0_60
end

function var0_0.AddItem(arg0_61, arg1_61, arg2_61)
	if arg0_61.itemData[arg1_61] then
		arg0_61.itemData[arg1_61]:AddCount(arg2_61)
	else
		arg0_61.itemData[arg1_61] = EducateItem.New({
			id = arg1_61,
			num = arg2_61
		})
	end

	arg0_61:sendNotification(var0_0.ITEM_ADDED)
end

function var0_0.GetItemCntById(arg0_62, arg1_62)
	return arg0_62.itemData[arg1_62] and arg0_62.itemData[arg1_62].count or 0
end

function var0_0.GetPolaroidData(arg0_63)
	return arg0_63.polaroidData
end

function var0_0.GetPolaroidList(arg0_64)
	local var0_64 = {}

	for iter0_64, iter1_64 in pairs(arg0_64.polaroidData) do
		table.insert(var0_64, iter1_64)
	end

	return var0_64
end

function var0_0.GetPolaroidIdList(arg0_65)
	local var0_65 = {}

	for iter0_65, iter1_65 in pairs(arg0_65.polaroidData) do
		table.insert(var0_65, iter0_65)
	end

	return var0_65
end

function var0_0.AddPolaroid(arg0_66, arg1_66)
	if arg0_66.polaroidData[arg1_66] then
		return
	end

	arg0_66.polaroidData[arg1_66] = EducatePolaroid.New({
		id = arg1_66,
		time = arg0_66:GetCurTime()
	})

	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_POLAROID)

	local var0_66 = Clone(arg0_66:GetSecretaryIDs())

	arg0_66:updateSecretaryIDs()
	getProxy(SettingsProxy):UpdateEducateCharTip(var0_66)
	arg0_66:sendNotification(var0_0.POLAROID_ADDED)
end

function var0_0.IsExistPolaroidByGroup(arg0_67, arg1_67)
	local var0_67 = pg.child_polaroid.get_id_list_by_group[arg1_67]

	return underscore.any(var0_67, function(arg0_68)
		return arg0_67.polaroidData[arg0_68]
	end)
end

function var0_0.CanGetPolaroidByGroup(arg0_69, arg1_69)
	local var0_69 = pg.child_polaroid.get_id_list_by_group[arg1_69]

	return underscore.any(var0_69, function(arg0_70)
		return arg0_69:CanGetPolaroidById(arg0_70)
	end)
end

function var0_0.CanGetPolaroidById(arg0_71, arg1_71)
	local var0_71 = arg0_71.char:GetStage()
	local var1_71 = arg0_71:GetPersonalityId()
	local var2_71 = pg.child_polaroid[arg1_71]

	if table.contains(var2_71.stage, var0_71) then
		if var2_71.xingge == "" then
			return true
		end

		return table.contains(var2_71.xingge, var1_71)
	end

	return false
end

function var0_0.GetPolaroidGroupCnt(arg0_72)
	local var0_72 = 0
	local var1_72 = 0

	for iter0_72, iter1_72 in pairs(pg.child_polaroid.get_id_list_by_group) do
		if arg0_72:IsExistPolaroidByGroup(iter0_72) then
			var0_72 = var0_72 + 1
		end

		var1_72 = var1_72 + 1
	end

	return var0_72, var1_72
end

function var0_0.GetMemories(arg0_73)
	return arg0_73.memories
end

function var0_0.AddMemory(arg0_74, arg1_74)
	if table.contains(arg0_74.memories, arg1_74) then
		return
	end

	table.insert(arg0_74.memories, arg1_74)
	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MEMORY, arg1_74)
	arg0_74:sendNotification(var0_0.MEMORY_ADDED)
end

function var0_0.CheckGuide(arg0_75, arg1_75)
	arg0_75:sendNotification(var0_0.GUIDE_CHECK, {
		view = arg1_75
	})
end

function var0_0.MainAddLayer(arg0_76, arg1_76)
	arg0_76:sendNotification(var0_0.MAIN_SCENE_ADD_LAYER, arg1_76)
end

function var0_0.initUnlockSecretary(arg0_77, arg1_77)
	arg0_77.isUnlockSecretary = arg1_77
	arg0_77.unlockSecretaryTaskId = (function()
		for iter0_78, iter1_78 in ipairs(pg.secretary_special_ship.all) do
			if pg.secretary_special_ship[iter1_78].unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT then
				return pg.secretary_special_ship[iter1_78].unlock[1]
			end
		end
	end)()
	arg0_77.unlcokTipByPolaroidCnt = {}

	for iter0_77, iter1_77 in ipairs(pg.secretary_special_ship.all) do
		local var0_77 = pg.secretary_special_ship[iter1_77]

		if var0_77.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1_77 = var0_77.unlock[1]

			if not table.contains(arg0_77.unlcokTipByPolaroidCnt, var1_77) then
				table.insert(arg0_77.unlcokTipByPolaroidCnt, var1_77)
			end
		end
	end
end

function var0_0.GetUnlockSecretaryTaskId(arg0_79)
	return arg0_79.unlockSecretaryTaskId
end

function var0_0.SetSecretaryUnlock(arg0_80)
	arg0_80.isUnlockSecretary = true

	arg0_80:updateSecretaryIDs()
end

function var0_0.CheckNewSecretaryTip(arg0_81)
	local var0_81 = arg0_81:GetPolaroidGroupCnt()

	if table.contains(arg0_81.unlcokTipByPolaroidCnt, var0_81) then
		arg0_81:updateSecretaryIDs()
		arg0_81:sendNotification(var0_0.UNLCOK_NEW_SECRETARY_BY_CNT)

		return true
	end

	return false
end

function var0_0.checkSecretaryID(arg0_82, arg1_82, arg2_82)
	if arg2_82 == "or" then
		for iter0_82, iter1_82 in ipairs(arg1_82) do
			if table.contains(arg0_82.endings, iter1_82[1]) then
				return true
			end
		end

		return false
	elseif arg2_82 == "and" then
		for iter2_82, iter3_82 in ipairs(arg1_82) do
			if not table.contains(arg0_82.endings, iter3_82) then
				return false
			end

			return true
		end
	end

	return false
end

function var0_0.updateSecretaryIDs(arg0_83)
	if not arg0_83:IsUnlockSecretary() then
		arg0_83.unlockSecretaryIds = {}

		return
	end

	arg0_83.unlockSecretaryIds = {}

	local var0_83 = #arg0_83:GetPolaroidIdList()

	for iter0_83, iter1_83 in ipairs(pg.secretary_special_ship.all) do
		local var1_83 = pg.secretary_special_ship[iter1_83].unlock_type
		local var2_83 = pg.secretary_special_ship[iter1_83].unlock

		switch(var1_83, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				if arg0_83:IsUnlockSecretary() then
					table.insert(arg0_83.unlockSecretaryIds, iter1_83)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var2_83[1] and var0_83 >= var2_83[1] then
					table.insert(arg0_83.unlockSecretaryIds, iter1_83)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var2_83[1] then
					if type(var2_83[1]) == "table" then
						if arg0_83:checkSecretaryID(var2_83, "or") then
							table.insert(arg0_83.unlockSecretaryIds, iter1_83)
						end
					elseif type(var2_83[1]) == "number" and arg0_83:checkSecretaryID(var2_83, "and") then
						table.insert(arg0_83.unlockSecretaryIds, iter1_83)
					end
				end
			end
		})
	end
end

function var0_0.GetEducateGroupList(arg0_87)
	local var0_87 = {}

	for iter0_87, iter1_87 in pairs(pg.secretary_special_ship.get_id_list_by_group) do
		table.insert(var0_87, EducateCharGroup.New(iter0_87))
	end

	return var0_87
end

function var0_0.GetStoryInfo(arg0_88)
	return arg0_88.char:GetPaintingName(), arg0_88.char:GetCallName(), arg0_88.char:GetBGName()
end

function var0_0.GetSecretaryIDs(arg0_89)
	return arg0_89.unlockSecretaryIds
end

function var0_0.GetPolaroidCnt(arg0_90)
	return #arg0_90:GetPolaroidIdList()
end

function var0_0.IsUnlockSecretary(arg0_91)
	return arg0_91.isUnlockSecretary
end

function var0_0.remove(arg0_92)
	return
end

return var0_0
