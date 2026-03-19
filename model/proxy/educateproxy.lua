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

	arg0_5.endingBuyCnt = var0_5.ending_buy_count
	arg0_5.memoryBuyCnt = var0_5.memory_buy_count
	arg0_5.polaroidBuyCnt = var0_5.polaroid_buy_count
	arg0_5.requestDataEnd = true
end

function var0_0.CheckDataRequestEnd(arg0_6)
	return arg0_6.requestDataEnd
end

function var0_0.GetSelectInfo(arg0_7)
	local var0_7 = EducateHelper.GetShowMonthNumber(arg0_7.curTime.month) .. i18n("word_month") .. i18n("word_which_week", arg0_7.curTime.week)

	return {
		bg = arg0_7.char:GetBGName(),
		name = arg0_7.char:GetName(),
		gameCnt = arg0_7.gameCount,
		progressStr = arg0_7.isUnlockSecretary and var0_7 or i18n("child2_not_start")
	}
end

function var0_0.CheckGuide(arg0_8, arg1_8)
	arg0_8:sendNotification(var0_0.GUIDE_CHECK, {
		view = arg1_8
	})
end

function var0_0.MainAddLayer(arg0_9, arg1_9)
	arg0_9:sendNotification(var0_0.MAIN_SCENE_ADD_LAYER, arg1_9)
end

function var0_0.initItems(arg0_10, arg1_10)
	arg0_10.itemData = {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		arg0_10.itemData[iter1_10.id] = EducateItem.New(iter1_10)
	end
end

function var0_0.initOptions(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		var0_11[iter1_11.id] = iter1_11.count
	end

	arg0_11.siteOptionData = {}

	for iter2_11, iter3_11 in ipairs(pg.child_site_option.all) do
		local var1_11 = EducateSiteOption.New(iter3_11, var0_11[iter3_11])

		arg0_11.siteOptionData[iter3_11] = var1_11
	end
end

function var0_0.initRandomOpts(arg0_12, arg1_12)
	arg0_12.siteRandomOpts = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		arg0_12.siteRandomOpts[iter1_12.site_id] = iter1_12.option_ids
	end
end

function var0_0.NeedRequestOptsData(arg0_13)
	return not arg0_13.siteRandomOpts
end

function var0_0.initBuffs(arg0_14, arg1_14)
	arg0_14.buffData = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		arg0_14.buffData[iter1_14.id] = EducateBuff.New(iter1_14)
	end
end

function var0_0.initPolaroids(arg0_15, arg1_15)
	arg0_15.polaroidData = {}

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		arg0_15.polaroidData[iter1_15.id] = EducatePolaroid.New(iter1_15)
	end
end

function var0_0.SetEndings(arg0_16, arg1_16, arg2_16)
	arg0_16.endings = arg2_16
	arg0_16.completeEndings = arg1_16

	arg0_16:updateSecretaryIDs(false)
end

function var0_0.IsFirstGame(arg0_17)
	return arg0_17.gameCount == 1
end

function var0_0.GetGameCnt(arg0_18)
	return arg0_18.gameCount
end

function var0_0.UpdateGameStatus(arg0_19)
	arg0_19.gameStatus = EducateConst.STATUES_NORMAL

	if arg0_19.exsitEnding then
		arg0_19.gameStatus = EducateConst.STATUES_RESET
	elseif arg0_19:IsEndingTime() then
		arg0_19.gameStatus = EducateConst.STATUES_ENDING
	elseif arg0_19.taskProxy:CheckTargetSet() then
		arg0_19.gameStatus = EducateConst.STATUES_PREPARE
	end
end

function var0_0.GetGameStatus(arg0_20)
	return arg0_20.gameStatus
end

function var0_0.initVirtualStage(arg0_21)
	local var0_21 = getProxy(EducateProxy):GetTaskProxy():GetTargetId()
	local var1_21 = arg0_21.char:GetStage()

	if var0_21 ~= 0 and pg.child_target_set[var0_21].stage == var1_21 + 1 then
		arg0_21.isVirtualStage = true
	else
		arg0_21.isVirtualStage = false
	end
end

function var0_0.SetVirtualStage(arg0_22, arg1_22)
	arg0_22.isVirtualStage = arg1_22
end

function var0_0.InVirtualStage(arg0_23)
	return arg0_23.isVirtualStage
end

function var0_0.Reset(arg0_24, arg1_24)
	EducateTipHelper.ClearAllRecord()
	arg0_24:GetPlanProxy():ClearLocalPlansData()
	arg0_24:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_24
	})
end

function var0_0.Refresh(arg0_25, arg1_25)
	EducateTipHelper.ClearAllRecord()
	arg0_25:GetPlanProxy():ClearLocalPlansData()
	arg0_25:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1_25
	})
end

function var0_0.GetCurTime(arg0_26)
	return arg0_26.curTime
end

function var0_0.UpdateTime(arg0_27)
	arg0_27.curTime.week = arg0_27.curTime.week + 1

	if arg0_27.curTime.week > 4 then
		arg0_27.curTime.week = 1
		arg0_27.curTime.month = arg0_27.curTime.month + 1
	end
end

function var0_0.OnNextWeek(arg0_28)
	arg0_28:SetVirtualStage(false)
	arg0_28:UpdateTime()
	arg0_28.char:OnNewWeek(arg0_28.curTime)
	arg0_28.planProxy:OnNewWeek(arg0_28.curTime)
	arg0_28.eventProxy:OnNewWeek(arg0_28.curTime)
	arg0_28.shopProxy:OnNewWeek(arg0_28.curTime)
	arg0_28.taskProxy:OnNewWeek(arg0_28.curTime)
	arg0_28:RefreshBuffs()
	arg0_28:RefreshOptions()

	arg0_28.siteRandomOpts = nil

	arg0_28:UpdateGameStatus()
	arg0_28:sendNotification(var0_0.TIME_UPDATED)
end

function var0_0.GetCharData(arg0_29)
	return arg0_29.char
end

function var0_0.GetPersonalityId(arg0_30)
	return arg0_30.char:GetPersonalityId()
end

function var0_0.UpdateRes(arg0_31, arg1_31, arg2_31)
	arg0_31.char:UpdateRes(arg1_31, arg2_31)
	arg0_31:sendNotification(var0_0.RESOURCE_UPDATED)
end

function var0_0.ReduceResForPlans(arg0_32)
	local var0_32, var1_32 = arg0_32.planProxy:GetCost()

	arg0_32:UpdateRes(EducateChar.RES_MONEY_ID, -var0_32)
	arg0_32:UpdateRes(EducateChar.RES_MOOD_ID, -var1_32)
end

function var0_0.ReduceResForCosts(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(arg1_33) do
		arg0_33:UpdateRes(iter1_33.id, -iter1_33.num)
	end
end

function var0_0.UpdateAttr(arg0_34, arg1_34, arg2_34)
	arg0_34.char:UpdateAttr(arg1_34, arg2_34)
	arg0_34:sendNotification(var0_0.ATTR_UPDATED)
end

function var0_0.CheckExtraAttr(arg0_35)
	return arg0_35.char:CheckExtraAttrAdd()
end

function var0_0.AddExtraAttr(arg0_36, arg1_36)
	arg0_36:UpdateAttr(arg1_36, arg0_36.char:getConfig("attr_2_add"))
	arg0_36.char:SetIsAddedExtraAttr(true)
end

function var0_0.GetPlanProxy(arg0_37)
	return arg0_37.planProxy
end

function var0_0.GetEventProxy(arg0_38)
	return arg0_38.eventProxy
end

function var0_0.GetShopProxy(arg0_39)
	return arg0_39.shopProxy
end

function var0_0.GetTaskProxy(arg0_40)
	return arg0_40.taskProxy
end

function var0_0.GetAllEndings(arg0_41)
	return arg0_41.endings
end

function var0_0.GetCompleteEndings(arg0_42)
	return arg0_42.completeEndings
end

function var0_0.GetEndingBuyCnt(arg0_43)
	return arg0_43.endingBuyCnt
end

function var0_0.AddEndingBuyCnt(arg0_44)
	arg0_44.endingBuyCnt = arg0_44.endingBuyCnt + 1
end

function var0_0.AddEnding(arg0_45, arg1_45, arg2_45)
	arg0_45.exsitEnding = true

	arg0_45:UpdateGameStatus()

	if not table.contains(arg0_45.completeEndings, arg1_45) then
		table.insert(arg0_45.completeEndings, arg1_45)
	end

	local var0_45 = false

	for iter0_45, iter1_45 in ipairs(arg2_45) do
		if not table.contains(arg0_45.endings, iter1_45) then
			table.insert(arg0_45.endings, iter1_45)

			var0_45 = true
		end
	end

	if var0_45 then
		arg0_45:updateSecretaryIDs(true)
		arg0_45:sendNotification(var0_0.ENDING_ADDED)
	end
end

function var0_0.AddEndingFromBuy(arg0_46, arg1_46)
	if table.contains(arg0_46.endings, arg1_46) then
		return
	end

	table.insert(arg0_46.endings, arg1_46)
	arg0_46:updateSecretaryIDs(true)
	arg0_46:sendNotification(var0_0.ENDING_ADDED)
end

function var0_0.IsEndingTime(arg0_47)
	local var0_47 = arg0_47:GetCurTime()

	if var0_47.month >= arg0_47.endTime[1] and var0_47.week >= arg0_47.endTime[2] and var0_47.day >= arg0_47.endTime[3] then
		return true
	end

	return false
end

function var0_0.GetEndingResult(arg0_48)
	local var0_48 = underscore.select(pg.child_ending.all, function(arg0_49)
		local var0_49 = pg.child_ending[arg0_49].condition

		return arg0_48.char:CheckEndCondition(var0_49)
	end)

	assert(#var0_48 > 0, "not matching ending")

	return var0_48
end

function var0_0.GetBuffData(arg0_50)
	return arg0_50.buffData
end

function var0_0.GetBuffList(arg0_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in pairs(arg0_51.buffData) do
		table.insert(var0_51, iter1_51)
	end

	return var0_51
end

function var0_0.AddBuff(arg0_52, arg1_52)
	if arg0_52.buffData[arg1_52] then
		arg0_52.buffData[arg1_52]:ResetEndTime()
	else
		arg0_52.buffData[arg1_52] = EducateBuff.New({
			id = arg1_52
		})
	end

	arg0_52:sendNotification(var0_0.BUFF_ADDED)
end

function var0_0.RefreshBuffs(arg0_53)
	for iter0_53, iter1_53 in pairs(arg0_53.buffData) do
		if iter1_53:IsEnd() then
			arg0_53.buffData[iter1_53.id] = nil
		end
	end
end

function var0_0.GetAttrBuffEffects(arg0_54, arg1_54)
	local var0_54 = {}

	for iter0_54, iter1_54 in pairs(arg0_54.buffData) do
		if iter1_54:IsAttrType() and iter1_54:IsId(arg1_54) then
			table.insert(var0_54, iter1_54)
		end
	end

	return EducateBuff.GetBuffEffects(var0_54)
end

function var0_0.GetResBuffEffects(arg0_55, arg1_55)
	local var0_55 = {}

	for iter0_55, iter1_55 in pairs(arg0_55.buffData) do
		if iter1_55:IsResType() and iter1_55:IsId(arg1_55) then
			table.insert(var0_55, iter1_55)
		end
	end

	return EducateBuff.GetBuffEffects(var0_55)
end

function var0_0.GetOptionById(arg0_56, arg1_56)
	return arg0_56.siteOptionData[arg1_56]
end

function var0_0.UpdateOptionData(arg0_57, arg1_57)
	arg0_57.siteOptionData[arg1_57.id] = arg1_57

	arg0_57:sendNotification(var0_0.OPTION_UPDATED)
end

function var0_0.RefreshOptions(arg0_58)
	local var0_58 = arg0_58:GetCurTime()

	for iter0_58, iter1_58 in pairs(arg0_58.siteOptionData) do
		iter1_58:OnWeekUpdate(var0_58)
	end
end

function var0_0.GetShowSiteIds(arg0_59)
	return underscore.select(pg.child_site.all, function(arg0_60)
		return pg.child_site[arg0_60].type == 1 and EducateHelper.IsSiteUnlock(arg0_60, arg0_59:IsFirstGame())
	end)
end

function var0_0.GetOptionsBySiteId(arg0_61, arg1_61)
	local var0_61 = pg.child_site[arg1_61].option
	local var1_61 = arg0_61:GetCurTime()
	local var2_61 = {}
	local var3_61 = {}

	underscore.each(var0_61, function(arg0_62)
		local var0_62 = arg0_61.siteOptionData[arg0_62]

		if var0_62 and var0_62:IsShow(var1_61) then
			if var0_62:IsReplace() then
				var3_61[var0_62:getConfig("replace")] = var0_62
			else
				table.insert(var2_61, var0_62)
			end
		end
	end)
	underscore.each(var2_61, function(arg0_63)
		if var3_61[arg0_63.id] then
			table.removebyvalue(var2_61, arg0_63)
			table.insert(var2_61, var3_61[arg0_63.id])
		end
	end)

	local var4_61 = arg0_61.siteRandomOpts and arg0_61.siteRandomOpts[arg1_61] or {}

	underscore.each(var4_61, function(arg0_64)
		local var0_64 = arg0_61.siteOptionData[arg0_64]

		if var0_64:IsShow(var1_61) then
			table.insert(var2_61, var0_64)
		end
	end)
	table.sort(var2_61, CompareFuncs({
		function(arg0_65)
			return arg0_65:getConfig("order")
		end,
		function(arg0_66)
			return arg0_66.id
		end
	}))

	return var2_61
end

function var0_0.GetItemData(arg0_67)
	return arg0_67.itemData
end

function var0_0.GetItemList(arg0_68)
	local var0_68 = {}

	for iter0_68, iter1_68 in pairs(arg0_68.itemData) do
		table.insert(var0_68, iter1_68)
	end

	return var0_68
end

function var0_0.AddItem(arg0_69, arg1_69, arg2_69)
	if arg0_69.itemData[arg1_69] then
		arg0_69.itemData[arg1_69]:AddCount(arg2_69)
	else
		arg0_69.itemData[arg1_69] = EducateItem.New({
			id = arg1_69,
			num = arg2_69
		})
	end

	arg0_69:sendNotification(var0_0.ITEM_ADDED)
end

function var0_0.GetItemCntById(arg0_70, arg1_70)
	return arg0_70.itemData[arg1_70] and arg0_70.itemData[arg1_70].count or 0
end

function var0_0.GetPolaroidData(arg0_71)
	return arg0_71.polaroidData
end

function var0_0.GetPolaroidBuyCnt(arg0_72)
	return arg0_72.polaroidBuyCnt
end

function var0_0.AddPolaroidBuyCnt(arg0_73)
	arg0_73.polaroidBuyCnt = arg0_73.polaroidBuyCnt + 1
end

function var0_0.GetPolaroidList(arg0_74)
	local var0_74 = {}

	for iter0_74, iter1_74 in pairs(arg0_74.polaroidData) do
		table.insert(var0_74, iter1_74)
	end

	return var0_74
end

function var0_0.GetPolaroidIdList(arg0_75)
	local var0_75 = {}

	for iter0_75, iter1_75 in pairs(arg0_75.polaroidData) do
		table.insert(var0_75, iter0_75)
	end

	return var0_75
end

function var0_0.AddPolaroid(arg0_76, arg1_76)
	if arg0_76.polaroidData[arg1_76] then
		return
	end

	arg0_76.polaroidData[arg1_76] = EducatePolaroid.New({
		id = arg1_76,
		time = arg0_76:GetCurTime()
	})

	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_POLAROID)
	arg0_76:updateSecretaryIDs(true)
	arg0_76:sendNotification(var0_0.POLAROID_ADDED)
end

function var0_0.IsExistPolaroidByGroup(arg0_77, arg1_77)
	local var0_77 = pg.child_polaroid.get_id_list_by_group[arg1_77]

	return underscore.any(var0_77, function(arg0_78)
		return arg0_77.polaroidData[arg0_78]
	end)
end

function var0_0.CanGetPolaroidByGroup(arg0_79, arg1_79)
	local var0_79 = pg.child_polaroid.get_id_list_by_group[arg1_79]

	return underscore.any(var0_79, function(arg0_80)
		return arg0_79:CanGetPolaroidById(arg0_80)
	end)
end

function var0_0.CanGetPolaroidById(arg0_81, arg1_81)
	local var0_81 = arg0_81.char:GetStage()
	local var1_81 = arg0_81:GetPersonalityId()
	local var2_81 = pg.child_polaroid[arg1_81]

	if table.contains(var2_81.stage, var0_81) then
		if var2_81.xingge == "" then
			return true
		end

		return table.contains(var2_81.xingge, var1_81)
	end

	return false
end

function var0_0.GetPolaroidGroupCnt(arg0_82)
	local var0_82 = 0
	local var1_82 = 0

	for iter0_82, iter1_82 in pairs(pg.child_polaroid.get_id_list_by_group) do
		if arg0_82:IsExistPolaroidByGroup(iter0_82) then
			var0_82 = var0_82 + 1
		end

		var1_82 = var1_82 + 1
	end

	return var0_82, var1_82
end

function var0_0.GetMemories(arg0_83)
	return arg0_83.memories
end

function var0_0.AddMemory(arg0_84, arg1_84)
	if table.contains(arg0_84.memories, arg1_84) then
		return
	end

	table.insert(arg0_84.memories, arg1_84)
	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MEMORY, arg1_84)
	arg0_84:sendNotification(var0_0.MEMORY_ADDED)
end

function var0_0.GetMemoryBuyCnt(arg0_85)
	return arg0_85.memoryBuyCnt
end

function var0_0.CheckGuide(arg0_86, arg1_86, arg2_86)
	arg0_86:sendNotification(var0_0.GUIDE_CHECK, {
		view = arg1_86,
		popActivityWindow = arg2_86
	})
end

function var0_0.AddMemoryBuyCnt(arg0_87)
	arg0_87.memoryBuyCnt = arg0_87.memoryBuyCnt + 1
end

function var0_0.initUnlockSecretary(arg0_88, arg1_88)
	arg0_88.isUnlockSecretary = arg1_88
	arg0_88.unlockSecretaryTaskId = (function()
		for iter0_89, iter1_89 in ipairs(pg.secretary_special_ship.all) do
			if pg.secretary_special_ship[iter1_89].unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT then
				return pg.secretary_special_ship[iter1_89].unlock[1]
			end
		end
	end)()
	arg0_88.unlcokTipByPolaroidCnt = {}

	for iter0_88, iter1_88 in ipairs(pg.secretary_special_ship.all) do
		local var0_88 = pg.secretary_special_ship[iter1_88]

		if var0_88.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1_88 = var0_88.unlock[1]

			if not table.contains(arg0_88.unlcokTipByPolaroidCnt, var1_88) then
				table.insert(arg0_88.unlcokTipByPolaroidCnt, var1_88)
			end
		end
	end
end

function var0_0.GetUnlockSecretaryTaskId(arg0_90)
	return arg0_90.unlockSecretaryTaskId
end

function var0_0.SetSecretaryUnlock(arg0_91)
	arg0_91.isUnlockSecretary = true

	arg0_91:updateSecretaryIDs(false)
end

function var0_0.CheckNewSecretaryTip(arg0_92)
	local var0_92 = arg0_92:GetPolaroidGroupCnt()

	if table.contains(arg0_92.unlcokTipByPolaroidCnt, var0_92) then
		arg0_92:updateSecretaryIDs(false)
		arg0_92:sendNotification(var0_0.UNLCOK_NEW_SECRETARY_BY_CNT)

		return true
	end

	return false
end

function var0_0.checkSecretaryID(arg0_93, arg1_93, arg2_93)
	if arg2_93 == "or" then
		for iter0_93, iter1_93 in ipairs(arg1_93) do
			if table.contains(arg0_93.endings, iter1_93[1]) then
				return true
			end
		end

		return false
	elseif arg2_93 == "and" then
		for iter2_93, iter3_93 in ipairs(arg1_93) do
			if not table.contains(arg0_93.endings, iter3_93) then
				return false
			end

			return true
		end
	end

	return false
end

function var0_0.updateSecretaryIDs(arg0_94, arg1_94)
	if not arg0_94:IsUnlockSecretary() then
		arg0_94.unlockSecretaryIds = {}

		return
	end

	local var0_94

	if arg1_94 then
		var0_94 = Clone(NewEducateHelper.GetAllUnlockSecretaryIds())
	end

	arg0_94.unlockSecretaryIds = {}

	local var1_94, var2_94 = arg0_94:GetPolaroidGroupCnt()

	for iter0_94, iter1_94 in ipairs(pg.secretary_special_ship.get_id_list_by_tb_id[0]) do
		local var3_94 = pg.secretary_special_ship[iter1_94].unlock_type
		local var4_94 = pg.secretary_special_ship[iter1_94].unlock

		switch(var3_94, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				if arg0_94:IsUnlockSecretary() then
					table.insert(arg0_94.unlockSecretaryIds, iter1_94)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var4_94[1] and var1_94 >= var4_94[1] then
					table.insert(arg0_94.unlockSecretaryIds, iter1_94)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var4_94[1] then
					if type(var4_94[1]) == "table" then
						if arg0_94:checkSecretaryID(var4_94, "or") then
							table.insert(arg0_94.unlockSecretaryIds, iter1_94)
						end
					elseif type(var4_94[1]) == "number" and arg0_94:checkSecretaryID(var4_94, "and") then
						table.insert(arg0_94.unlockSecretaryIds, iter1_94)
					end
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_SHOP] = function()
				if var4_94[1] and getProxy(ShipSkinProxy):hasSkin(var4_94[1]) then
					table.insert(arg0_94.unlockSecretaryIds, iter1_94)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_STORY] = function()
				return
			end
		})
	end

	if arg1_94 then
		getProxy(SettingsProxy):UpdateEducateCharTip(var0_94)
	end
end

function var0_0.GetEducateGroupList(arg0_100)
	local var0_100 = {}

	for iter0_100, iter1_100 in pairs(pg.secretary_special_ship.get_id_list_by_group) do
		table.insert(var0_100, EducateCharGroup.New(iter0_100))
	end

	return var0_100
end

function var0_0.GetStoryInfo(arg0_101)
	return arg0_101.char:GetPaintingName(), arg0_101.char:GetCallName(), arg0_101.char:GetBGName()
end

function var0_0.GetSecretaryIDs(arg0_102)
	return arg0_102.unlockSecretaryIds
end

function var0_0.GetPolaroidCnt(arg0_103)
	return #arg0_103:GetPolaroidIdList()
end

function var0_0.IsUnlockSecretary(arg0_104)
	return arg0_104.isUnlockSecretary
end

function var0_0.remove(arg0_105)
	return
end

return var0_0
