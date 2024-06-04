local var0 = class("EducateScheduleScene", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateScheduleUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.playerID = getProxy(PlayerProxy):getRawData().id
	arg0.educateProxy = getProxy(EducateProxy)
	arg0.char = arg0.educateProxy:GetCharData()
	arg0.curTime = arg0.educateProxy:GetCurTime()
	arg0.planProxy = arg0.educateProxy:GetPlanProxy()
	arg0.buffList = arg0.educateProxy:GetBuffList()
	arg0.natureIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0.majorIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MAJOR)
	arg0.minorIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MINOR)

	arg0:getLocalGridData()

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
end

function var0.clearLocalPlans(arg0)
	getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
	arg0:getLocalGridData()
	arg0:updateResultPanel()
	arg0:closeSelectPanel()
end

function var0.getLocalGridData(arg0)
	local var0 = arg0.char:GetNextWeekPlanCnt()

	arg0.gridData = {}

	for iter0 = 1, 6 do
		arg0.gridData[iter0] = {}

		for iter1 = 1, 3 do
			local var1 = iter1 <= var0 and EducateGrid.TYPE_EMPTY or EducateGrid.TYPE_LOCK

			arg0.gridData[iter0][iter1] = EducateGrid.New({
				type = var1
			})
		end
	end

	for iter2 = 1, 6 do
		arg0.selectDay = iter2

		for iter3 = 1, var0 do
			arg0.selectIndex = iter3

			local var2 = PlayerPrefs.GetString(EducateConst.PLANS_DATA_KEY .. arg0.playerID .. "_" .. iter2 .. "_" .. iter3)

			if var2 ~= "" then
				local var3 = string.split(var2, "_")
				local var4 = tonumber(var3[1])
				local var5 = tonumber(var3[2])

				if arg0:checkLocalPlan(var4, var5) then
					arg0.gridData[iter2][iter3] = EducateGrid.New({
						id = var4,
						type = var5
					})
				end
			end
		end
	end

	arg0.selectDay = nil
	arg0.selectIndex = nil

	arg0:recoverSpecEventForPlans()
end

function var0.checkLocalPlan(arg0, arg1, arg2)
	if arg2 == EducateGrid.TYPE_PLAN or arg2 == EducateGrid.TYPE_PLAN_OCCUPY then
		local var0 = EducatePlan.New(arg1)
		local var1 = var0:getConfig("pre_next")

		return arg0:CheckCondition(var0) and not var0:ExistNextPlanCanFill(arg0.char)
	end

	return false
end

function var0.recoverSpecEventForPlans(arg0)
	local var0 = arg0.educateProxy:GetEventProxy():GetPlanSpecEvents()

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1:GetGridIndexs()

		for iter2, iter3 in ipairs(var1) do
			local var2 = iter2 == 1 and EducateGrid.TYPE_EVENT or EducateGrid.TYPE_EVENT_OCCUPY
			local var3 = EducateGrid.New({
				type = var2,
				id = iter1.id
			})

			arg0:setGridDataForPlan(iter3[1], iter3[2], var3)
		end
	end
end

function var0.saveGridLocalData(arg0, arg1, arg2, arg3)
	local var0 = arg3.id .. "_" .. arg3.type

	PlayerPrefs.SetString(EducateConst.PLANS_DATA_KEY .. arg0.playerID .. "_" .. arg1 .. "_" .. arg2, var0)
end

function var0.setGridDataForPlan(arg0, arg1, arg2, arg3)
	if not arg0.gridData[arg1][arg2]:IsEmpty() then
		arg0:clearGridData(arg1, arg2)
	end

	local var0 = arg3:GetOccupyGridCnt()

	if var0 > 1 then
		for iter0 = 1, var0 - 1 do
			arg0.gridData[arg1][arg2 + iter0] = EducateGrid.New({
				type = EducateGrid.TYPE_PLAN_OCCUPY,
				id = arg3.id
			})

			arg0:saveGridLocalData(arg1, arg2 + iter0, arg0.gridData[arg1][arg2 + iter0])
		end
	end

	arg0.gridData[arg1][arg2] = arg3

	arg0:saveGridLocalData(arg1, arg2, arg3)
end

function var0.clearGridData(arg0, arg1, arg2)
	local var0 = arg0.gridData[arg1][arg2]

	if var0:GetOccupyGridCnt() > 1 then
		for iter0, iter1 in pairs(arg0.gridData[arg1]) do
			if (iter1:IsPlanOccupy() or iter1:IsPlan()) and iter1.id == var0.id then
				arg0.gridData[arg1][iter0] = EducateGrid.New({
					type = EducateGrid.TYPE_EMPTY
				})

				arg0:saveGridLocalData(arg1, iter0, arg0.gridData[arg1][iter0])
			end
		end
	end

	arg0.gridData[arg1][arg2] = EducateGrid.New({
		type = EducateGrid.TYPE_EMPTY
	})

	arg0:saveGridLocalData(arg1, arg2, arg0.gridData[arg1][arg2])
end

function var0.findUI(arg0)
	arg0.bgTF = arg0:findTF("anim_root/bg")
	arg0.topTF = arg0:findTF("anim_root/top")
	arg0.returnBtn = arg0:findTF("return_btn/return_btn", arg0.topTF)
	arg0.mainTF = arg0:findTF("anim_root/main")
	arg0.leftPanelTF = arg0:findTF("schedule_left", arg0.mainTF)
	arg0.targetTF = arg0:findTF("target", arg0.leftPanelTF)

	setText(arg0:findTF("title", arg0.targetTF), i18n("child_btn_target") .. ":")

	arg0.scheduleTF = arg0:findTF("schedule", arg0.leftPanelTF)
	arg0.dayList = UIItemList.New(arg0.scheduleTF, arg0:findTF("schedule/day_tpl", arg0.leftPanelTF))
	arg0.monthText = arg0:findTF("title/month", arg0.leftPanelTF)

	setText(arg0:findTF("title/right/content/month", arg0.leftPanelTF), i18n("word_month"))

	arg0.weekText = arg0:findTF("title/right/content/week", arg0.leftPanelTF)
	arg0.skipToggle = arg0:findTF("skip_toggle", arg0.leftPanelTF)
	arg0.skipToggleCom = arg0.skipToggle:GetComponent(typeof(Toggle))

	local var0 = PlayerPrefs.GetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0.playerID)

	triggerToggle(arg0.skipToggle, var0 == 1)
	setActive(arg0.skipToggle, true)
	setText(arg0:findTF("Text", arg0.skipToggle), i18n("child_plan_skip"))

	arg0.selectPanelTF = arg0:findTF("select_panel", arg0.leftPanelTF)

	setActive(arg0.selectPanelTF, false)

	arg0.selectCloseBtn = arg0:findTF("fold_btn", arg0.selectPanelTF)
	arg0.plansView = arg0:findTF("scrollview", arg0.selectPanelTF)
	arg0.rightPanelTF = arg0:findTF("result_right", arg0.mainTF)
	arg0.rightEmptyTF = arg0:findTF("empty", arg0.rightPanelTF)

	setText(arg0:findTF("Text", arg0.rightEmptyTF), i18n("child_schedule_empty_tip"))

	arg0.rightContentTF = arg0:findTF("content", arg0.rightPanelTF)
	arg0.buffUIList = UIItemList.New(arg0:findTF("buff_list", arg0.rightContentTF), arg0:findTF("buff_list/tpl", arg0.rightContentTF))
	arg0.avatarTF = arg0:findTF("avatar", arg0.rightContentTF)
	arg0.avatarImage = arg0:findTF("mask/Image", arg0.avatarTF)
	arg0.natureTF = arg0:findTF("nature/unlock", arg0.rightContentTF)
	arg0.natureLockTF = arg0:findTF("nature/lock", arg0.rightContentTF)

	setText(arg0:findTF("major_title/Text", arg0.rightContentTF), i18n("child_attr_name1"))
	setText(arg0:findTF("minor_title/Text", arg0.rightContentTF), i18n("child_attr_name2"))

	arg0.majorUIList = UIItemList.New(arg0:findTF("major", arg0.rightContentTF), arg0:findTF("major/tpl", arg0.rightContentTF))
	arg0.minorUIList = UIItemList.New(arg0:findTF("minor", arg0.rightContentTF), arg0:findTF("minor/tpl", arg0.rightContentTF))
	arg0.nextBtn = arg0:findTF("next_btn", arg0.rightPanelTF)
	arg0.topPanel = EducateTopPanel.New(arg0:findTF("top_right", arg0.topTF), arg0.event)

	arg0.topPanel:Load()

	arg0.resPanel = EducateResPanel.New(arg0:findTF("res", arg0.topTF), arg0.event)

	arg0.resPanel:Load()
end

function var0.addListener(arg0)
	setActive(arg0:findTF("clear_btn", arg0.topTF), false)
	onButton(arg0, arg0:findTF("clear_btn", arg0.topTF), function()
		arg0:clearLocalPlans()
		arg0.resPanel:Flush()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("index_btn", arg0.selectPanelTF), function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas) or {},
			callback = function(arg0)
				arg0.typeIndex = arg0.typeIndex
				arg0.costIndex = arg0.costIndex
				arg0.awardResIndex = arg0.awardResIndex
				arg0.awardNatureIndex = arg0.awardNatureIndex
				arg0.awardAttr1Index = arg0.awardAttr1Index
				arg0.awardAttr2Index = arg0.awardAttr2Index

				arg0:updateIndexDatas()
				arg0:updatePlanList()
			end
		}

		arg0:emit(EducateScheduleMediator.OPEN_FILTER_LAYER, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.returnBtn, function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0.selectCloseBtn, function()
		arg0:closeSelectPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		local var0 = {}
		local var1

		table.insert(var0, function(arg0)
			if arg0:haveEmpty() then
				arg0:emit(var0.EDUCATE_ON_MSG_TIP, {
					content = i18n("child_schedule_sure_tip"),
					onYes = function()
						var1 = true
					end,
					onExit = function()
						if var1 then
							arg0()
						end
					end
				})
			else
				arg0()
			end
		end)
		table.insert(var0, function(arg0)
			if getProxy(EducateProxy):GetCharData().site > 0 then
				arg0:emit(var0.EDUCATE_ON_MSG_TIP, {
					content = i18n("child_schedule_sure_tip2"),
					onYes = function()
						arg0()
					end
				})
			else
				arg0()
			end
		end)
		seriesAsync(var0, function()
			arg0:executePlans(arg0.skipToggleCom.isOn)
		end)
	end, SFX_PANEL)
	onToggle(arg0, arg0.skipToggle, function(arg0)
		PlayerPrefs.SetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0.playerID, arg0 and 1 or 0)
	end, SFX_PANEL)
end

function var0.haveEmpty(arg0)
	for iter0 = 1, 6 do
		for iter1 = 1, 3 do
			if arg0.gridData[iter0][iter1]:IsEmpty() then
				return true
			end
		end
	end

	return false
end

function var0.allEmpty(arg0)
	for iter0 = 1, 6 do
		for iter1 = 1, 3 do
			local var0 = arg0.gridData[iter0][iter1]

			if not var0:IsEmpty() and not var0:IsLock() then
				return false
			end
		end
	end

	return true
end

function var0.executePlans(arg0, arg1)
	arg0:emit(EducateScheduleMediator.GET_PLANS, {
		gridData = arg0.gridData,
		isSkip = arg1
	})
end

function var0.didEnter(arg0)
	arg0:updateBg()
	arg0:initTimeTitle()
	arg0:initTargetText()
	arg0:updateIndexDatas()
	arg0:initSchedulePanel()
	arg0:initSelectPlans()
	arg0:initResultPanel()
	arg0:checkTips()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.mainTF, {
		pbList = {
			arg0:findTF("bg", arg0.mainTF)
		},
		groupName = LayerWeightConst.GROUP_EDUCATE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0.topTF, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0.checkTips(arg0)
	arg0.newUnlcokPlanIds = EducateTipHelper.GetPlanUnlockTipIds()

	if #arg0.newUnlcokPlanIds > 0 then
		arg0:emit(var0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_PLAN,
			list = arg0.newUnlcokPlanIds
		})
	end
end

function var0.updateBg(arg0)
	local var0 = LoadSprite("bg/" .. arg0.char:GetBGName())

	setImageSprite(arg0.bgTF, var0, false)
end

function var0.initTimeTitle(arg0)
	local var0 = EducateHelper.GetTimeAfterWeeks(arg0.curTime, 1)
	local var1 = EducateHelper.GetShowMonthNumber(var0.month)

	setText(arg0.monthText, var1)

	local var2 = i18n("number_" .. var0.week)

	setText(arg0.weekText, i18n("word_which_week", var2))
end

function var0.initTargetText(arg0)
	arg0.showAttrSubtype = 0

	local var0 = arg0.educateProxy:GetTaskProxy()

	if not var0:CanGetTargetAward() then
		setText(arg0:findTF("Text", arg0.targetTF), i18n("child_task_finish_all"))
		setActive(arg0:findTF("icon", arg0.targetTF), false)
	else
		local var1 = var0:FilterByGroup(var0:GetTargetTasksForShow())[1]

		if not var1 then
			setActive(arg0.targetTF, false)
		end

		setText(arg0:findTF("Text", arg0.targetTF), var1:getConfig("name"))

		if var1:GetType() == EducateTask.TYPE_ATTR then
			setActive(arg0:findTF("icon", arg0.targetTF), true)

			arg0.showAttrSubtype = var1:getConfig("sub_type")

			local var2 = type(arg0.showAttrSubtype) == "string" and arg0.showAttrSubtype or arg0.showAttrSubtype[1]

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var2, arg0:findTF("icon", arg0.targetTF))
		else
			setActive(arg0:findTF("icon", arg0.targetTF), false)
		end
	end
end

function var0.updateIndexDatas(arg0)
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
	arg0.contextData.indexDatas.costIndex = arg0.costIndex
	arg0.contextData.indexDatas.awardResIndex = arg0.awardResIndex
	arg0.contextData.indexDatas.awardNatureIndex = arg0.awardNatureIndex
	arg0.contextData.indexDatas.awardAttr1Index = arg0.awardAttr1Index
	arg0.contextData.indexDatas.awardAttr2Index = arg0.awardAttr2Index
end

function var0.initSchedulePanel(arg0)
	arg0.dayList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1

			arg2.name = tostring(var0)

			GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var0, arg0:findTF("title", arg2), true)

			for iter0 = 1, 3 do
				local var1 = arg0:findTF("cells", arg2):GetChild(iter0 - 1)
				local var2 = arg0.planProxy:GetGridBgName(var0, iter0)

				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2[1], arg0:findTF("empty", var1), true)
				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2[2], arg0:findTF("plan/name_bg", var1), true)
				onButton(arg0, var1, function()
					local var0 = arg0.gridData[var0][iter0]

					if var0:IsEvent() or var0:IsEventOccupy() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
					else
						arg0:openSelectPanel(var0, iter0)
					end
				end, SFX_PANEL)
			end
		end

		if arg0 == UIItemList.EventUpdate then
			arg0:updateDayGrids(arg1, arg2)
		end
	end)
	arg0.dayList:align(6)
end

function var0._updateGrid(arg0, arg1, arg2)
	setActive(arg1, not arg2:IsLock())

	if not arg2:IsLock() then
		setActive(arg0:findTF("empty", arg1), arg2:IsEmpty())

		arg1:GetComponent(typeof(Image)).enabled = not arg2:IsEmpty()

		setActive(arg0:findTF("plan", arg1), not arg2:IsEmpty())

		if arg2:IsPlan() or arg2:IsPlanOccupy() then
			LoadImageSpriteAsync("educateprops/" .. arg2.data:getConfig("icon"), arg0:findTF("plan/icon", arg1), true)
			setScrollText(arg0:findTF("plan/name_bg/Text", arg1), arg2.data:getConfig("name"))
		end

		if arg2:IsEvent() or arg2:IsEventOccupy() then
			local var0 = arg2.data:getConfig("type_param")[1] or ""

			LoadImageSpriteAsync("educateprops/" .. var0, arg0:findTF("plan/icon", arg1), true)
			setScrollText(arg0:findTF("plan/name_bg/Text", arg1), i18n("child_plan_event"))
		end
	end
end

function var0.updateDayGrids(arg0, arg1, arg2)
	local var0 = arg1 + 1

	for iter0 = 1, 3 do
		local var1 = arg0:findTF("cells", arg2):GetChild(iter0 - 1)

		var1.name = tostring(iter0)

		local var2 = arg0.gridData[var0][iter0]

		arg0:_updateGrid(var1, var2)
	end
end

function var0.initSelectPlans(arg0)
	arg0.plansRect = arg0.plansView:GetComponent("LScrollRect")
	arg0.planCards = {}

	function arg0.plansRect.onInitItem(arg0)
		local var0 = EducateSchedulePlanCard.New(arg0, arg0)

		arg0.planCards[arg0] = var0
	end

	function arg0.plansRect.onUpdateItem(arg0, arg1)
		local var0 = arg0.planCards[arg1]

		if not var0 then
			local var1 = EducateSchedulePlanCard.New(arg1, arg0)

			arg0.planCards[arg1] = var1
		end

		local var2 = arg0.showPlans[arg0 + 1]
		local var3 = 0
		local var4 = arg0.gridData[arg0.selectDay][arg0.selectIndex]

		if var4 and var4:IsPlanOccupy() or var4:IsPlan() then
			var3 = var4.id
		end

		var0:update(var2, var3)
	end

	function arg0.plansRect.onReturnItem(arg0, arg1)
		return
	end

	for iter0 = 1, 3 do
		local var0 = arg0:findTF("day/cells", arg0.selectPanelTF):GetChild(iter0 - 1)

		onButton(arg0, var0, function()
			local var0 = arg0.gridData[arg0.selectDay][iter0]

			if var0:IsEvent() or var0:IsEventOccupy() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
			else
				arg0.selectIndex = iter0

				arg0:updateSelectdDay()
				arg0:updatePlanList()
			end
		end, SFX_PANEL)
	end
end

function var0.openSelectPanel(arg0, arg1, arg2)
	LoadImageSpriteAtlasAsync("ui/educatescheduleui_atlas", arg1, arg0:findTF("day/title", arg0.selectPanelTF), true)
	setActive(arg0.selectPanelTF, true)
	setActive(arg0.scheduleTF, false)

	arg0.selectDay = arg1
	arg0.selectIndex = arg2

	arg0:updateSelectdDay()
	arg0:updatePlanList()
end

function var0.updateSelectdDay(arg0)
	for iter0 = 1, 3 do
		local var0 = arg0:findTF("day/cells", arg0.selectPanelTF):GetChild(iter0 - 1)
		local var1 = arg0.gridData[arg0.selectDay][iter0]
		local var2 = arg0.planProxy:GetGridBgName(arg0.selectDay, iter0)

		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2[1], arg0:findTF("empty", var0), true)
		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2[2], arg0:findTF("plan/name_bg", var0), true)
		setActive(arg0:findTF("selected", var0), arg0.selectIndex == iter0)
		arg0:_updateGrid(var0, var1)
	end
end

function var0.updatePlanList(arg0)
	if arg0.selectIndex ~= 0 then
		arg0.showPlans = arg0:filter(arg0.planProxy:GetShowPlans(arg0.char:GetNextWeekStage(), arg0.selectDay, arg0.selectIndex))

		arg0:sortPlans()
		arg0.plansRect:SetTotalCount(#arg0.showPlans, -1)
	end
end

function var0.sortPlans(arg0)
	table.sort(arg0.showPlans, CompareFuncs({
		function(arg0)
			return table.contains(arg0.newUnlcokPlanIds, arg0.id) and 0 or 1
		end,
		function(arg0)
			return arg0:IsMatchAttr(arg0.char) and 0 or 1
		end,
		function(arg0)
			return arg0:CheckResultBySubType(EducateConst.DROP_TYPE_ATTR, arg0.showAttrSubtype) and 0 or 1
		end,
		function(arg0)
			return -arg0:getConfig("rare")
		end,
		function(arg0)
			return arg0.id
		end
	}))

	arg0.newUnlcokPlanIds = {}
end

function var0.OnPlanCardClick(arg0, arg1)
	local var0, var1 = arg0:CheckCondition(arg1)

	if var0 then
		local var2 = EducateGrid.New({
			type = EducateGrid.TYPE_PLAN,
			id = arg1.id
		})

		arg0:setGridDataForPlan(arg0.selectDay, arg0.selectIndex, var2)
		arg0:updateSelectdDay()
		arg0:updateResultPanel()
		arg0:closeSelectPanel()
	else
		pg.TipsMgr.GetInstance():ShowTips(var1)
	end
end

function var0.filter(arg0, arg1)
	return underscore.select(arg1, function(arg0)
		return EducatePlanIndexConst.filterByType(arg0, arg0.typeIndex) and EducatePlanIndexConst.filterByCost(arg0, arg0.costIndex) and EducatePlanIndexConst.filterByAwardRes(arg0, arg0.awardResIndex) and EducatePlanIndexConst.filterByAwardNature(arg0, arg0.awardNatureIndex) and EducatePlanIndexConst.filterByAwardAttr1(arg0, arg0.awardAttr1Index) and EducatePlanIndexConst.filterByAwardAttr2(arg0, arg0.awardAttr2Index)
	end)
end

function var0.closeSelectPanel(arg0)
	setActive(arg0.selectPanelTF, false)
	setActive(arg0.scheduleTF, true)
	arg0.dayList:align(6)
end

function var0.CheckCondition(arg0, arg1)
	local var0 = arg0.gridData[arg0.selectDay][arg0.selectIndex]

	if var0:IsEvent() or var0:IsEventOccupy() then
		return false, i18n("child_schedule_event_tip")
	end

	local var1 = var0.data
	local var2, var3, var4 = arg1:GetCost()

	if var4 > 1 and not arg0:CheckRemainGrid(var4, var0.id) then
		return false, i18n("child_plan_check_tip1")
	end

	if not arg1:IsMatchAttr(arg0.char) then
		return false, i18n("child_plan_check_tip2")
	end

	if not arg1:IsInStage(arg0.char:GetNextWeekStage()) then
		return false, i18n("child_plan_check_tip6")
	end

	local var5 = arg1:getConfig("pre")[1]

	if not arg1:IsMatchPre(arg0.planProxy:GetHistoryCntById(var5)) then
		return false, i18n("child_plan_check_tip3")
	end

	local var6, var7 = arg0:getPlansCost()
	local var8 = 0
	local var9 = 0

	if var0:IsPlan() or var0:IsPlanOccupy() then
		local var10

		var8, var10 = var1:GetCost()
	end

	if arg0.char.money < var6 + var2 - var8 then
		return false, i18n("child_plan_check_tip4")
	end

	return true
end

function var0.CheckRemainGrid(arg0, arg1, arg2)
	local var0 = arg0.selectIndex + arg1 - 1

	if var0 > 3 then
		return false
	end

	for iter0 = arg0.selectIndex + 1, var0 do
		local var1 = arg0.gridData[arg0.selectDay][iter0]

		if not var1:IsEmpty() and (not var1:IsPlanOccupy() or var1.id ~= arg2) then
			return false
		end
	end

	return true
end

function var0.showBuffBox(arg0, arg1)
	arg0:emit(var0.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_BUFF,
			id = arg1
		}
	})
end

function var0.initResultPanel(arg0)
	arg0.resPanel:FlushAddValue("", "")
	arg0.buffUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			onButton(arg0, arg2, function()
				arg0:showBuffBox(arg0.buffList[arg1 + 1].id)
			end, SFX_PANEL)
		end
	end)
	arg0.buffUIList:align(#arg0.buffList)

	local var0 = arg0:findTF("content", arg0.natureTF)
	local var1 = arg0:findTF("progress", arg0.avatarTF)
	local var2 = arg0.char:GetPaintingName()

	setImageSprite(arg0:findTF("mask/Image", arg0.avatarTF), LoadSprite("squareicon/" .. var2), true)

	for iter0, iter1 in ipairs(arg0.natureIds) do
		local var3 = var0:GetChild(iter0 - 1)

		setActive(arg0:findTF("tip", var3), false)

		var3.name = iter1

		setScrollText(arg0:findTF("mask/Text", var3), pg.child_attr[iter1].name .. " " .. arg0.char:GetAttrById(iter1))
	end

	arg0.majorUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0.majorIds[arg1 + 1]

			arg2.name = var0

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0, arg0:findTF("icon", arg2), true)
			setScrollText(arg0:findTF("name_mask/name", arg2), pg.child_attr[var0].name)

			local var1 = arg0.char:GetAttrInfo(var0)

			setText(arg0:findTF("grade/Text", arg2), var1)
			setText(arg0:findTF("before_value", arg2), arg0.char:GetAttrById(var0))

			local var2 = EducateConst.GRADE_2_COLOR[var1][2]

			setActive(arg0:findTF("gradient", arg2), false)
			setImageColor(arg0:findTF("grade", arg2), Color.NewHex(var2))
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = tonumber(arg2.name)
			local var4 = arg0.char:GetAttrById(var3)

			if arg0.attrResults and arg0.attrResults[var3] then
				var4 = var4 + arg0.attrResults[var3]

				setActive(arg0:findTF("gradient", arg2), true)
				setImageColor(arg0:findTF("arrow", arg2), Color.NewHex("9efffe"))
				setText(arg0:findTF("after_value", arg2), setColorStr(var4, "#9efffe"))
			else
				setActive(arg0:findTF("gradient", arg2), false)
				setImageColor(arg0:findTF("arrow", arg2), Color.NewHex("dddedf"))
				setText(arg0:findTF("after_value", arg2), setColorStr(var4, "#ffffff"))
			end
		end
	end)
	arg0.minorUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0.minorIds[arg1 + 1]

			arg2.name = var0

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0, arg0:findTF("icon", arg2), true)
			setText(arg0:findTF("value", arg2), arg0.char:GetAttrById(var0))
		elseif arg0 == UIItemList.EventUpdate then
			local var1 = tonumber(arg2.name)
			local var2 = arg0.char:GetAttrById(var1)

			setText(arg0:findTF("name", arg2), pg.child_attr[var1].name)

			if arg0.attrResults and arg0.attrResults[var1] then
				var2 = var2 .. setColorStr("+" .. arg0.attrResults[var1], "#9efffe")
			end

			setText(arg0:findTF("value", arg2), var2)
		end
	end)

	arg0.attrResults, arg0.resResult = {}, {}

	arg0:updateResultPanel()
end

function var0.updateResultPanel(arg0)
	local var0 = arg0:allEmpty()

	setActive(arg0.rightEmptyTF, var0)
	setActive(arg0.rightContentTF, not var0)

	if not var0 then
		arg0.attrResults, arg0.resResult = arg0:getPlansResult()

		arg0.majorUIList:align(#arg0.majorIds)
		arg0.minorUIList:align(#arg0.minorIds)

		local var1, var2 = arg0:getPlansCost()
		local var3 = arg0.resResult[EducateChar.RES_MONEY_ID] or 0
		local var4 = arg0.resResult[EducateChar.RES_MOOD_ID] or 0
		local var5 = var3 - var1 >= 0 and "+" .. var3 - var1 or var3 - var1
		local var6 = var4 - var2 >= 0 and "+" .. var4 - var2 or var4 - var2

		arg0.resPanel:FlushAddValue(var6, var5)

		local var7 = EducateHelper.IsShowNature()

		setActive(arg0.natureTF, var7)
		setActive(arg0.natureLockTF, not var7)

		if var7 then
			local var8 = arg0:findTF("content", arg0.natureTF)

			eachChild(var8, function(arg0)
				local var0 = tonumber(arg0.name)

				if arg0.attrResults and arg0.attrResults[var0] and arg0.attrResults[var0] ~= 0 then
					local var1 = arg0.attrResults[var0]
					local var2 = var1 > 0 and "+" or ""
					local var3 = var1 > 0 and "39bfff" or "a9a9a9"

					setActive(arg0:findTF("tip", arg0), true)
					setImageColor(arg0:findTF("tip", arg0), Color.NewHex(var3))
					setText(arg0:findTF("tip/Text", arg0), var2 .. var1)
				else
					setActive(arg0:findTF("tip", arg0), false)
				end
			end)
		end
	end
end

function var0.getPlansResult(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.gridData) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:IsPlan() then
				for iter4, iter5 in ipairs(iter3.data:GetResult()) do
					if iter5[1] == EducateConst.DROP_TYPE_ATTR then
						local var2 = var0[iter5[2]] or 0

						var0[iter5[2]] = var2 + iter5[3]
					elseif iter5[1] == EducateConst.DROP_TYPE_RES then
						local var3 = var1[iter5[2]] or 0

						var1[iter5[2]] = var3 + iter5[3]
					end
				end
			end
		end
	end

	return var0, var1
end

function var0.getPlansCost(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = {}

	for iter0, iter1 in pairs(arg0.gridData) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:IsPlan() then
				local var3, var4 = iter3.data:GetCost()

				var0 = var0 + var3
				var1 = var1 + var4
			end
		end
	end

	return var0, var1
end

function var0.getRemainGridCnt(arg0, arg1, arg2)
	local var0 = arg0.gridData[arg1]
	local var1 = 1

	for iter0, iter1 in pairs(var0) do
		if arg2 < iter0 and iter1:IsEmpty() then
			var1 = var1 + 1
		end
	end

	return var1
end

function var0.DoRecommend(arg0)
	local var0 = arg0.char:GetAttrSortIds()

	for iter0, iter1 in pairs(arg0.gridData) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:IsEmpty() then
				local var1, var2 = arg0:getPlansCost()
				local var3 = arg0:getRemainGridCnt(iter0, iter2)
				local var4 = arg0.planProxy:GetRecommendPlan(iter0, iter2, arg0.char, var1, var2, var3, var0)

				if var4 then
					local var5 = EducateGrid.New({
						type = EducateGrid.TYPE_PLAN,
						id = var4.id
					})

					arg0:setGridDataForPlan(iter0, iter2, var5)
				end
			end
		end
	end

	arg0:updateResultPanel()
	arg0:closeSelectPanel()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.selectPanelTF) then
		arg0:closeSelectPanel()
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.willExit(arg0)
	arg0.topPanel:Destroy()

	arg0.topPanel = nil

	arg0.resPanel:Destroy()

	arg0.resPanel = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.mainTF, arg0:findTF("anim_root"))
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.topTF, arg0:findTF("anim_root"))

	for iter0, iter1 in pairs(arg0.planCards) do
		iter1:dispose()
	end
end

return var0
