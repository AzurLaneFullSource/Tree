local var0 = class("EducateProxy", import(".NetProxy"))

var0.RESOURCE_UPDATED = "EducateProxy.RESOURCE_UPDATED"
var0.ATTR_UPDATED = "EducateProxy.ATTR_UPDATED"
var0.TIME_UPDATED = "EducateProxy.TIME_UPDATED"
var0.TIME_WEEKDAY_UPDATED = "EducateProxy.TIME_WEEKDAY_UPDATED"
var0.BUFF_ADDED = "EducateProxy.BUFF_ADDED"
var0.OPTION_UPDATED = "EducateProxy.OPTION_UPDATED"
var0.ENDING_ADDED = "EducateProxy.ENDING_ADDED"
var0.ITEM_ADDED = "EducateProxy.ITEM_ADDED"
var0.POLAROID_ADDED = "EducateProxy.POLAROID_ADDED"
var0.MEMORY_ADDED = "EducateProxy.MEMORY_ADDED"
var0.UNLCOK_NEW_SECRETARY_BY_CNT = "EducateProxy.UNLCOK_NEW_SECRETARY_BY_CNT"
var0.GUIDE_CHECK = "EducateProxy.GUIDE_CHECK"
var0.MAIN_SCENE_ADD_LAYER = "EducateProxy.MAIN_SCENE_ADD_LAYER"
var0.CLEAR_NEW_TIP = "EducateProxy.CLEAR_NEW_TIP"

function var0.register(arg0)
	arg0.planProxy = EducatePlanProxy.New(arg0)
	arg0.eventProxy = EducateEventProxy.New(arg0)
	arg0.shopProxy = EducateShopProxy.New(arg0)
	arg0.taskProxy = EducateTaskProxy.New(arg0)
	arg0.endTime = pg.gameset.child_end_data.description

	arg0:on(27021, function(arg0)
		for iter0, iter1 in ipairs(arg0.tasks) do
			arg0.taskProxy:AddTask(iter1)
		end
	end)
	arg0:on(27022, function(arg0)
		for iter0, iter1 in ipairs(arg0.ids) do
			arg0.taskProxy:RemoveTaskById(iter1)
		end
	end)
	arg0:on(27025, function(arg0)
		for iter0, iter1 in ipairs(arg0.tasks) do
			arg0.taskProxy:UpdateTask(iter1)
		end
	end)
end

function var0.initData(arg0, arg1)
	arg0:sendNotification(GAME.EDUCATE_GET_ENDINGS)

	local var0 = arg1.child

	arg0.exsitEnding = var0.is_ending == 1 or false
	arg0.gameCount = var0.new_game_plus_count
	arg0.curTime = var0.cur_time or {
		week = 1,
		month = 3,
		day = 7
	}
	arg0.char = EducateChar.New(var0)

	arg0.eventProxy:SetUp({
		waitTriggerEventIds = var0.home_events,
		needRequestHomeEvents = var0.can_trigger_home_event == 1 or false,
		finishSpecEventIds = var0.spec_events
	})
	arg0.planProxy:SetUp({
		history = var0.plan_history,
		selectedPlans = var0.plans
	})
	arg0.shopProxy:SetUp({
		shops = var0.shop,
		discountEventIds = var0.discount_event_id
	})
	arg0.taskProxy:SetUp({
		targetId = var0.target,
		tasks = var0.tasks,
		finishMindTaskIds = var0.realized_wish,
		isGotTargetAward = var0.had_target_stage_award == 1 or false
	})
	arg0:initItems(var0.items)
	arg0:initPolaroids(var0.polaroids)

	arg0.memories = var0.memorys

	arg0:initBuffs(var0.buffs)
	arg0:initOptions(var0.option_records)

	arg0.siteRandomOpts = nil

	arg0:UpdateGameStatus()
	arg0:initVirtualStage()
	arg0:initUnlockSecretary(var0.is_special_secretary_valid == 1)

	arg0.requestDataEnd = true
end

function var0.CheckDataRequestEnd(arg0)
	return arg0.requestDataEnd
end

function var0.initItems(arg0, arg1)
	arg0.itemData = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.itemData[iter1.id] = EducateItem.New(iter1)
	end
end

function var0.initOptions(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		var0[iter1.id] = iter1.count
	end

	arg0.siteOptionData = {}

	for iter2, iter3 in ipairs(pg.child_site_option.all) do
		local var1 = EducateSiteOption.New(iter3, var0[iter3])

		arg0.siteOptionData[iter3] = var1
	end
end

function var0.initRandomOpts(arg0, arg1)
	arg0.siteRandomOpts = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.siteRandomOpts[iter1.site_id] = iter1.option_ids
	end
end

function var0.NeedRequestOptsData(arg0)
	return not arg0.siteRandomOpts
end

function var0.initBuffs(arg0, arg1)
	arg0.buffData = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.buffData[iter1.id] = EducateBuff.New(iter1)
	end
end

function var0.initPolaroids(arg0, arg1)
	arg0.polaroidData = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.polaroidData[iter1.id] = EducatePolaroid.New(iter1)
	end
end

function var0.SetEndings(arg0, arg1)
	arg0.endings = arg1

	arg0:updateSecretaryIDs()
end

function var0.IsFirstGame(arg0)
	return arg0.gameCount == 1
end

function var0.UpdateGameStatus(arg0)
	arg0.gameStatus = EducateConst.STATUES_NORMAL

	if arg0.exsitEnding then
		arg0.gameStatus = EducateConst.STATUES_RESET
	elseif arg0:IsEndingTime() then
		arg0.gameStatus = EducateConst.STATUES_ENDING
	elseif arg0.taskProxy:CheckTargetSet() then
		arg0.gameStatus = EducateConst.STATUES_PREPARE
	end
end

function var0.GetGameStatus(arg0)
	return arg0.gameStatus
end

function var0.initVirtualStage(arg0)
	local var0 = getProxy(EducateProxy):GetTaskProxy():GetTargetId()
	local var1 = arg0.char:GetStage()

	if var0 ~= 0 and pg.child_target_set[var0].stage == var1 + 1 then
		arg0.isVirtualStage = true
	else
		arg0.isVirtualStage = false
	end
end

function var0.SetVirtualStage(arg0, arg1)
	arg0.isVirtualStage = arg1
end

function var0.InVirtualStage(arg0)
	return arg0.isVirtualStage
end

function var0.Reset(arg0, arg1)
	EducateTipHelper.ClearAllRecord()
	arg0:GetPlanProxy():ClearLocalPlansData()
	arg0:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1
	})
end

function var0.Refresh(arg0, arg1)
	EducateTipHelper.ClearAllRecord()
	arg0:GetPlanProxy():ClearLocalPlansData()
	arg0:sendNotification(GAME.EDUCATE_REQUEST, {
		callback = arg1
	})
end

function var0.GetCurTime(arg0)
	return arg0.curTime
end

function var0.UpdateTime(arg0)
	arg0.curTime.week = arg0.curTime.week + 1

	if arg0.curTime.week > 4 then
		arg0.curTime.week = 1
		arg0.curTime.month = arg0.curTime.month + 1
	end
end

function var0.OnNextWeek(arg0)
	arg0:SetVirtualStage(false)
	arg0:UpdateTime()
	arg0.char:OnNewWeek(arg0.curTime)
	arg0.planProxy:OnNewWeek(arg0.curTime)
	arg0.eventProxy:OnNewWeek(arg0.curTime)
	arg0.shopProxy:OnNewWeek(arg0.curTime)
	arg0.taskProxy:OnNewWeek(arg0.curTime)
	arg0:RefreshBuffs()
	arg0:RefreshOptions()

	arg0.siteRandomOpts = nil

	arg0:UpdateGameStatus()
	arg0:sendNotification(var0.TIME_UPDATED)
end

function var0.GetCharData(arg0)
	return arg0.char
end

function var0.GetPersonalityId(arg0)
	return arg0.char:GetPersonalityId()
end

function var0.UpdateRes(arg0, arg1, arg2)
	arg0.char:UpdateRes(arg1, arg2)
	arg0:sendNotification(var0.RESOURCE_UPDATED)
end

function var0.ReduceResForPlans(arg0)
	local var0, var1 = arg0.planProxy:GetCost()

	arg0:UpdateRes(EducateChar.RES_MONEY_ID, -var0)
	arg0:UpdateRes(EducateChar.RES_MOOD_ID, -var1)
end

function var0.ReduceResForCosts(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:UpdateRes(iter1.id, -iter1.num)
	end
end

function var0.UpdateAttr(arg0, arg1, arg2)
	arg0.char:UpdateAttr(arg1, arg2)
	arg0:sendNotification(var0.ATTR_UPDATED)
end

function var0.CheckExtraAttr(arg0)
	return arg0.char:CheckExtraAttrAdd()
end

function var0.AddExtraAttr(arg0, arg1)
	arg0:UpdateAttr(arg1, arg0.char:getConfig("attr_2_add"))
	arg0.char:SetIsAddedExtraAttr(true)
end

function var0.GetPlanProxy(arg0)
	return arg0.planProxy
end

function var0.GetEventProxy(arg0)
	return arg0.eventProxy
end

function var0.GetShopProxy(arg0)
	return arg0.shopProxy
end

function var0.GetTaskProxy(arg0)
	return arg0.taskProxy
end

function var0.GetFinishEndings(arg0)
	return arg0.endings
end

function var0.AddEnding(arg0, arg1)
	arg0.exsitEnding = true

	arg0:UpdateGameStatus()

	if table.contains(arg0.endings, arg1) then
		return
	end

	table.insert(arg0.endings, arg1)

	local var0 = Clone(arg0:GetSecretaryIDs())

	arg0:updateSecretaryIDs()
	getProxy(SettingsProxy):UpdateEducateCharTip(var0)
	arg0:sendNotification(var0.ENDING_ADDED)
end

function var0.IsEndingTime(arg0)
	local var0 = arg0:GetCurTime()

	if var0.month >= arg0.endTime[1] and var0.week >= arg0.endTime[2] and var0.day >= arg0.endTime[3] then
		return true
	end

	return false
end

function var0.GetEndingResult(arg0)
	local var0 = underscore.detect(pg.child_ending.all, function(arg0)
		local var0 = pg.child_ending[arg0].condition

		return arg0.char:CheckEndCondition(var0)
	end)

	assert(var0, "not matching ending")

	return var0
end

function var0.GetBuffData(arg0)
	return arg0.buffData
end

function var0.GetBuffList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.buffData) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.AddBuff(arg0, arg1)
	if arg0.buffData[arg1] then
		arg0.buffData[arg1]:ResetEndTime()
	else
		arg0.buffData[arg1] = EducateBuff.New({
			id = arg1
		})
	end

	arg0:sendNotification(var0.BUFF_ADDED)
end

function var0.RefreshBuffs(arg0)
	for iter0, iter1 in pairs(arg0.buffData) do
		if iter1:IsEnd() then
			arg0.buffData[iter1.id] = nil
		end
	end
end

function var0.GetAttrBuffEffects(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.buffData) do
		if iter1:IsAttrType() and iter1:IsId(arg1) then
			table.insert(var0, iter1)
		end
	end

	return EducateBuff.GetBuffEffects(var0)
end

function var0.GetResBuffEffects(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.buffData) do
		if iter1:IsResType() and iter1:IsId(arg1) then
			table.insert(var0, iter1)
		end
	end

	return EducateBuff.GetBuffEffects(var0)
end

function var0.GetOptionById(arg0, arg1)
	return arg0.siteOptionData[arg1]
end

function var0.UpdateOptionData(arg0, arg1)
	arg0.siteOptionData[arg1.id] = arg1

	arg0:sendNotification(var0.OPTION_UPDATED)
end

function var0.RefreshOptions(arg0)
	local var0 = arg0:GetCurTime()

	for iter0, iter1 in pairs(arg0.siteOptionData) do
		iter1:OnWeekUpdate(var0)
	end
end

function var0.GetShowSiteIds(arg0)
	return underscore.select(pg.child_site.all, function(arg0)
		return pg.child_site[arg0].type == 1 and EducateHelper.IsSiteUnlock(arg0, arg0:IsFirstGame())
	end)
end

function var0.GetOptionsBySiteId(arg0, arg1)
	local var0 = pg.child_site[arg1].option
	local var1 = arg0:GetCurTime()
	local var2 = {}
	local var3 = {}

	underscore.each(var0, function(arg0)
		local var0 = arg0.siteOptionData[arg0]

		if var0 and var0:IsShow(var1) then
			if var0:IsReplace() then
				var3[var0:getConfig("replace")] = var0
			else
				table.insert(var2, var0)
			end
		end
	end)
	underscore.each(var2, function(arg0)
		if var3[arg0.id] then
			table.removebyvalue(var2, arg0)
			table.insert(var2, var3[arg0.id])
		end
	end)

	local var4 = arg0.siteRandomOpts and arg0.siteRandomOpts[arg1] or {}

	underscore.each(var4, function(arg0)
		local var0 = arg0.siteOptionData[arg0]

		if var0:IsShow(var1) then
			table.insert(var2, var0)
		end
	end)
	table.sort(var2, CompareFuncs({
		function(arg0)
			return arg0:getConfig("order")
		end,
		function(arg0)
			return arg0.id
		end
	}))

	return var2
end

function var0.GetItemData(arg0)
	return arg0.itemData
end

function var0.GetItemList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.itemData) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.AddItem(arg0, arg1, arg2)
	if arg0.itemData[arg1] then
		arg0.itemData[arg1]:AddCount(arg2)
	else
		arg0.itemData[arg1] = EducateItem.New({
			id = arg1,
			num = arg2
		})
	end

	arg0:sendNotification(var0.ITEM_ADDED)
end

function var0.GetItemCntById(arg0, arg1)
	return arg0.itemData[arg1] and arg0.itemData[arg1].count or 0
end

function var0.GetPolaroidData(arg0)
	return arg0.polaroidData
end

function var0.GetPolaroidList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.polaroidData) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetPolaroidIdList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.polaroidData) do
		table.insert(var0, iter0)
	end

	return var0
end

function var0.AddPolaroid(arg0, arg1)
	if arg0.polaroidData[arg1] then
		return
	end

	arg0.polaroidData[arg1] = EducatePolaroid.New({
		id = arg1,
		time = arg0:GetCurTime()
	})

	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_POLAROID)

	local var0 = Clone(arg0:GetSecretaryIDs())

	arg0:updateSecretaryIDs()
	getProxy(SettingsProxy):UpdateEducateCharTip(var0)
	arg0:sendNotification(var0.POLAROID_ADDED)
end

function var0.IsExistPolaroidByGroup(arg0, arg1)
	local var0 = pg.child_polaroid.get_id_list_by_group[arg1]

	return underscore.any(var0, function(arg0)
		return arg0.polaroidData[arg0]
	end)
end

function var0.CanGetPolaroidByGroup(arg0, arg1)
	local var0 = pg.child_polaroid.get_id_list_by_group[arg1]

	return underscore.any(var0, function(arg0)
		return arg0:CanGetPolaroidById(arg0)
	end)
end

function var0.CanGetPolaroidById(arg0, arg1)
	local var0 = arg0.char:GetStage()
	local var1 = arg0:GetPersonalityId()
	local var2 = pg.child_polaroid[arg1]

	if table.contains(var2.stage, var0) then
		if var2.xingge == "" then
			return true
		end

		return table.contains(var2.xingge, var1)
	end

	return false
end

function var0.GetPolaroidGroupCnt(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(pg.child_polaroid.get_id_list_by_group) do
		if arg0:IsExistPolaroidByGroup(iter0) then
			var0 = var0 + 1
		end

		var1 = var1 + 1
	end

	return var0, var1
end

function var0.GetMemories(arg0)
	return arg0.memories
end

function var0.AddMemory(arg0, arg1)
	if table.contains(arg0.memories, arg1) then
		return
	end

	table.insert(arg0.memories, arg1)
	EducateTipHelper.SetNewTip(EducateTipHelper.NEW_MEMORY, arg1)
	arg0:sendNotification(var0.MEMORY_ADDED)
end

function var0.CheckGuide(arg0, arg1)
	arg0:sendNotification(var0.GUIDE_CHECK, {
		view = arg1
	})
end

function var0.MainAddLayer(arg0, arg1)
	arg0:sendNotification(var0.MAIN_SCENE_ADD_LAYER, arg1)
end

function var0.initUnlockSecretary(arg0, arg1)
	arg0.isUnlockSecretary = arg1
	arg0.unlockSecretaryTaskId = (function()
		for iter0, iter1 in ipairs(pg.secretary_special_ship.all) do
			if pg.secretary_special_ship[iter1].unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT then
				return pg.secretary_special_ship[iter1].unlock[1]
			end
		end
	end)()
	arg0.unlcokTipByPolaroidCnt = {}

	for iter0, iter1 in ipairs(pg.secretary_special_ship.all) do
		local var0 = pg.secretary_special_ship[iter1]

		if var0.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1 = var0.unlock[1]

			if not table.contains(arg0.unlcokTipByPolaroidCnt, var1) then
				table.insert(arg0.unlcokTipByPolaroidCnt, var1)
			end
		end
	end
end

function var0.GetUnlockSecretaryTaskId(arg0)
	return arg0.unlockSecretaryTaskId
end

function var0.SetSecretaryUnlock(arg0)
	arg0.isUnlockSecretary = true

	arg0:updateSecretaryIDs()
end

function var0.CheckNewSecretaryTip(arg0)
	local var0 = arg0:GetPolaroidGroupCnt()

	if table.contains(arg0.unlcokTipByPolaroidCnt, var0) then
		arg0:updateSecretaryIDs()
		arg0:sendNotification(var0.UNLCOK_NEW_SECRETARY_BY_CNT)

		return true
	end

	return false
end

function var0.checkSecretaryID(arg0, arg1, arg2)
	if arg2 == "or" then
		for iter0, iter1 in ipairs(arg1) do
			if table.contains(arg0.endings, iter1[1]) then
				return true
			end
		end

		return false
	elseif arg2 == "and" then
		for iter2, iter3 in ipairs(arg1) do
			if not table.contains(arg0.endings, iter3) then
				return false
			end

			return true
		end
	end

	return false
end

function var0.updateSecretaryIDs(arg0)
	if not arg0:IsUnlockSecretary() then
		arg0.unlockSecretaryIds = {}

		return
	end

	arg0.unlockSecretaryIds = {}

	local var0 = #arg0:GetPolaroidIdList()

	for iter0, iter1 in ipairs(pg.secretary_special_ship.all) do
		local var1 = pg.secretary_special_ship[iter1].unlock_type
		local var2 = pg.secretary_special_ship[iter1].unlock

		switch(var1, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				if arg0:IsUnlockSecretary() then
					table.insert(arg0.unlockSecretaryIds, iter1)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var2[1] and var0 >= var2[1] then
					table.insert(arg0.unlockSecretaryIds, iter1)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var2[1] then
					if type(var2[1]) == "table" then
						if arg0:checkSecretaryID(var2, "or") then
							table.insert(arg0.unlockSecretaryIds, iter1)
						end
					elseif type(var2[1]) == "number" and arg0:checkSecretaryID(var2, "and") then
						table.insert(arg0.unlockSecretaryIds, iter1)
					end
				end
			end
		})
	end
end

function var0.GetEducateGroupList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(pg.secretary_special_ship.get_id_list_by_group) do
		table.insert(var0, EducateCharGroup.New(iter0))
	end

	return var0
end

function var0.GetStoryInfo(arg0)
	return arg0.char:GetPaintingName(), arg0.char:GetCallName(), arg0.char:GetBGName()
end

function var0.GetSecretaryIDs(arg0)
	return arg0.unlockSecretaryIds
end

function var0.GetPolaroidCnt(arg0)
	return #arg0:GetPolaroidIdList()
end

function var0.IsUnlockSecretary(arg0)
	return arg0.isUnlockSecretary
end

function var0.remove(arg0)
	return
end

return var0
