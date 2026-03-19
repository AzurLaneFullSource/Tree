local var0_0 = class("EducateScheduleScene", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateScheduleUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.playerID = getProxy(PlayerProxy):getRawData().id
	arg0_3.educateProxy = getProxy(EducateProxy)
	arg0_3.char = arg0_3.educateProxy:GetCharData()
	arg0_3.curTime = arg0_3.educateProxy:GetCurTime()
	arg0_3.planProxy = arg0_3.educateProxy:GetPlanProxy()
	arg0_3.buffList = arg0_3.educateProxy:GetBuffList()
	arg0_3.natureIds = arg0_3.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0_3.majorIds = arg0_3.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MAJOR)
	arg0_3.minorIds = arg0_3.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MINOR)

	arg0_3:getLocalGridData()

	arg0_3.contextData.indexDatas = arg0_3.contextData.indexDatas or {}
end

function var0_0.clearLocalPlans(arg0_4)
	getProxy(EducateProxy):GetPlanProxy():ClearLocalPlansData()
	arg0_4:getLocalGridData()
	arg0_4:updateResultPanel()
	arg0_4:closeSelectPanel()
end

function var0_0.getLocalGridData(arg0_5)
	local var0_5 = arg0_5.char:GetNextWeekPlanCnt()

	arg0_5.gridData = {}

	for iter0_5 = 1, 6 do
		arg0_5.gridData[iter0_5] = {}

		for iter1_5 = 1, 3 do
			local var1_5 = iter1_5 <= var0_5 and EducateGrid.TYPE_EMPTY or EducateGrid.TYPE_LOCK

			arg0_5.gridData[iter0_5][iter1_5] = EducateGrid.New({
				type = var1_5
			})
		end
	end

	for iter2_5 = 1, 6 do
		arg0_5.selectDay = iter2_5

		for iter3_5 = 1, var0_5 do
			arg0_5.selectIndex = iter3_5

			local var2_5 = PlayerPrefs.GetString(EducateConst.PLANS_DATA_KEY .. arg0_5.playerID .. "_" .. iter2_5 .. "_" .. iter3_5)

			if var2_5 ~= "" then
				local var3_5 = string.split(var2_5, "_")
				local var4_5 = tonumber(var3_5[1])
				local var5_5 = tonumber(var3_5[2])

				if arg0_5:checkLocalPlan(var4_5, var5_5) then
					arg0_5.gridData[iter2_5][iter3_5] = EducateGrid.New({
						id = var4_5,
						type = var5_5
					})
				end
			end
		end
	end

	arg0_5.selectDay = nil
	arg0_5.selectIndex = nil

	arg0_5:recoverSpecEventForPlans()
end

function var0_0.checkLocalPlan(arg0_6, arg1_6, arg2_6)
	if arg2_6 == EducateGrid.TYPE_PLAN or arg2_6 == EducateGrid.TYPE_PLAN_OCCUPY then
		local var0_6 = EducatePlan.New(arg1_6)
		local var1_6 = var0_6:getConfig("pre_next")

		return arg0_6:CheckCondition(var0_6) and not var0_6:ExistNextPlanCanFill(arg0_6.char)
	end

	return false
end

function var0_0.recoverSpecEventForPlans(arg0_7)
	local var0_7 = arg0_7.educateProxy:GetEventProxy():GetPlanSpecEvents()

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var1_7 = iter1_7:GetGridIndexs()

		for iter2_7, iter3_7 in ipairs(var1_7) do
			local var2_7 = iter2_7 == 1 and EducateGrid.TYPE_EVENT or EducateGrid.TYPE_EVENT_OCCUPY
			local var3_7 = EducateGrid.New({
				type = var2_7,
				id = iter1_7.id
			})

			arg0_7:setGridDataForPlan(iter3_7[1], iter3_7[2], var3_7)
		end
	end
end

function var0_0.saveGridLocalData(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg3_8.id .. "_" .. arg3_8.type

	PlayerPrefs.SetString(EducateConst.PLANS_DATA_KEY .. arg0_8.playerID .. "_" .. arg1_8 .. "_" .. arg2_8, var0_8)
end

function var0_0.setGridDataForPlan(arg0_9, arg1_9, arg2_9, arg3_9)
	if not arg0_9.gridData[arg1_9][arg2_9]:IsEmpty() then
		arg0_9:clearGridData(arg1_9, arg2_9)
	end

	local var0_9 = arg3_9:GetOccupyGridCnt()

	if var0_9 > 1 then
		for iter0_9 = 1, var0_9 - 1 do
			arg0_9.gridData[arg1_9][arg2_9 + iter0_9] = EducateGrid.New({
				type = EducateGrid.TYPE_PLAN_OCCUPY,
				id = arg3_9.id
			})

			arg0_9:saveGridLocalData(arg1_9, arg2_9 + iter0_9, arg0_9.gridData[arg1_9][arg2_9 + iter0_9])
		end
	end

	arg0_9.gridData[arg1_9][arg2_9] = arg3_9

	arg0_9:saveGridLocalData(arg1_9, arg2_9, arg3_9)
end

function var0_0.clearGridData(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.gridData[arg1_10][arg2_10]

	if var0_10:GetOccupyGridCnt() > 1 then
		for iter0_10, iter1_10 in pairs(arg0_10.gridData[arg1_10]) do
			if (iter1_10:IsPlanOccupy() or iter1_10:IsPlan()) and iter1_10.id == var0_10.id then
				arg0_10.gridData[arg1_10][iter0_10] = EducateGrid.New({
					type = EducateGrid.TYPE_EMPTY
				})

				arg0_10:saveGridLocalData(arg1_10, iter0_10, arg0_10.gridData[arg1_10][iter0_10])
			end
		end
	end

	arg0_10.gridData[arg1_10][arg2_10] = EducateGrid.New({
		type = EducateGrid.TYPE_EMPTY
	})

	arg0_10:saveGridLocalData(arg1_10, arg2_10, arg0_10.gridData[arg1_10][arg2_10])
end

function var0_0.findUI(arg0_11)
	arg0_11.bgTF = arg0_11._tf:Find("anim_root/bg")
	arg0_11.topTF = arg0_11._tf:Find("anim_root/top")
	arg0_11.returnBtn = arg0_11.topTF:Find("return_btn/return_btn")
	arg0_11.mainTF = arg0_11._tf:Find("anim_root/main")
	arg0_11.leftPanelTF = arg0_11.mainTF:Find("schedule_left")
	arg0_11.targetTF = arg0_11.leftPanelTF:Find("target")

	setText(arg0_11.targetTF:Find("title"), i18n("child_btn_target") .. ":")

	arg0_11.scheduleTF = arg0_11.leftPanelTF:Find("schedule")
	arg0_11.dayList = UIItemList.New(arg0_11.scheduleTF, arg0_11.leftPanelTF:Find("schedule/day_tpl"))
	arg0_11.monthText = arg0_11.leftPanelTF:Find("title/month")

	setText(arg0_11.leftPanelTF:Find("title/right/content/month"), i18n("word_month"))

	arg0_11.weekText = arg0_11.leftPanelTF:Find("title/right/content/week")
	arg0_11.skipToggle = arg0_11.leftPanelTF:Find("skip_toggle")
	arg0_11.skipToggleCom = arg0_11.skipToggle:GetComponent(typeof(Toggle))

	local var0_11 = PlayerPrefs.GetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0_11.playerID)

	triggerToggle(arg0_11.skipToggle, var0_11 == 1)
	setActive(arg0_11.skipToggle, true)
	setText(arg0_11.skipToggle:Find("Text"), i18n("child_plan_skip"))

	arg0_11.skipEventToggle = arg0_11.leftPanelTF:Find("skip_toggle_event")
	arg0_11.skipEventToggleCom = arg0_11.skipEventToggle:GetComponent(typeof(Toggle))

	local var1_11 = PlayerPrefs.GetInt(EducateConst.SKIP_PLANS_EVENT_ANIM_KEY .. "_" .. arg0_11.playerID)

	triggerToggle(arg0_11.skipEventToggle, var1_11 == 1)
	setActive(arg0_11.skipEventToggle, true)
	setText(arg0_11.skipEventToggle:Find("Text"), i18n("child_plan_skip_event"))

	arg0_11.selectPanelTF = arg0_11.leftPanelTF:Find("select_panel")

	setActive(arg0_11.selectPanelTF, false)

	arg0_11.selectCloseBtn = arg0_11.selectPanelTF:Find("fold_btn")
	arg0_11.plansView = arg0_11.selectPanelTF:Find("scrollview")
	arg0_11.rightPanelTF = arg0_11.mainTF:Find("result_right")
	arg0_11.rightEmptyTF = arg0_11.rightPanelTF:Find("empty")

	setText(arg0_11.rightEmptyTF:Find("Text"), i18n("child_schedule_empty_tip"))

	arg0_11.rightContentTF = arg0_11.rightPanelTF:Find("content")
	arg0_11.buffUIList = UIItemList.New(arg0_11.rightContentTF:Find("buff_list"), arg0_11.rightContentTF:Find("buff_list/tpl"))
	arg0_11.avatarTF = arg0_11.rightContentTF:Find("avatar")
	arg0_11.avatarImage = arg0_11.avatarTF:Find("mask/Image")
	arg0_11.natureTF = arg0_11.rightContentTF:Find("nature/unlock")
	arg0_11.natureLockTF = arg0_11.rightContentTF:Find("nature/lock")

	setText(arg0_11.rightContentTF:Find("major_title/Text"), i18n("child_attr_name1"))
	setText(arg0_11.rightContentTF:Find("minor_title/Text"), i18n("child_attr_name2"))

	arg0_11.majorUIList = UIItemList.New(arg0_11.rightContentTF:Find("major"), arg0_11.rightContentTF:Find("major/tpl"))
	arg0_11.minorUIList = UIItemList.New(arg0_11.rightContentTF:Find("minor"), arg0_11.rightContentTF:Find("minor/tpl"))
	arg0_11.nextBtn = arg0_11.rightPanelTF:Find("next_btn")
	arg0_11.topPanel = EducateTopPanel.New(arg0_11.topTF:Find("top_right"), arg0_11.event)

	arg0_11.topPanel:Load()

	arg0_11.resPanel = EducateResPanel.New(arg0_11.topTF:Find("res"), arg0_11.event)

	arg0_11.resPanel:Load()
end

function var0_0.addListener(arg0_12)
	setActive(arg0_12.topTF:Find("clear_btn"), false)
	onButton(arg0_12, arg0_12.topTF:Find("clear_btn"), function()
		arg0_12:clearLocalPlans()
		arg0_12.resPanel:ActionInvoke("Flush")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.selectPanelTF:Find("index_btn"), function()
		local var0_14 = {
			indexDatas = Clone(arg0_12.contextData.indexDatas) or {},
			callback = function(arg0_15)
				arg0_12.typeIndex = arg0_15.typeIndex
				arg0_12.costIndex = arg0_15.costIndex
				arg0_12.awardResIndex = arg0_15.awardResIndex
				arg0_12.awardNatureIndex = arg0_15.awardNatureIndex
				arg0_12.awardAttr1Index = arg0_15.awardAttr1Index
				arg0_12.awardAttr2Index = arg0_15.awardAttr2Index

				arg0_12:updateIndexDatas()
				arg0_12:updatePlanList()
			end
		}

		arg0_12:emit(EducateScheduleMediator.OPEN_FILTER_LAYER, var0_14)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.returnBtn, function()
		arg0_12:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.selectCloseBtn, function()
		arg0_12:closeSelectPanel()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.nextBtn, function()
		local var0_18 = {}
		local var1_18

		table.insert(var0_18, function(arg0_19)
			if arg0_12:haveEmpty() then
				arg0_12:emit(var0_0.EDUCATE_ON_MSG_TIP, {
					content = i18n("child_schedule_sure_tip"),
					onYes = function()
						var1_18 = true
					end,
					onExit = function()
						if var1_18 then
							arg0_19()
						end
					end
				})
			else
				arg0_19()
			end
		end)
		table.insert(var0_18, function(arg0_22)
			if getProxy(EducateProxy):GetCharData().site > 0 then
				arg0_12:emit(var0_0.EDUCATE_ON_MSG_TIP, {
					content = i18n("child_schedule_sure_tip2"),
					onYes = function()
						arg0_22()
					end
				})
			else
				arg0_22()
			end
		end)
		seriesAsync(var0_18, function()
			arg0_12:executePlans(arg0_12.skipToggleCom.isOn, arg0_12.skipEventToggleCom.isOn)
		end)
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.skipToggle, function(arg0_25)
		PlayerPrefs.SetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0_12.playerID, arg0_25 and 1 or 0)
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.skipEventToggle, function(arg0_26)
		PlayerPrefs.SetInt(EducateConst.SKIP_PLANS_EVENT_ANIM_KEY .. "_" .. arg0_12.playerID, arg0_26 and 1 or 0)
	end, SFX_PANEL)
end

function var0_0.haveEmpty(arg0_27)
	for iter0_27 = 1, 6 do
		for iter1_27 = 1, 3 do
			if arg0_27.gridData[iter0_27][iter1_27]:IsEmpty() then
				return true
			end
		end
	end

	return false
end

function var0_0.allEmpty(arg0_28)
	for iter0_28 = 1, 6 do
		for iter1_28 = 1, 3 do
			local var0_28 = arg0_28.gridData[iter0_28][iter1_28]

			if not var0_28:IsEmpty() and not var0_28:IsLock() then
				return false
			end
		end
	end

	return true
end

function var0_0.executePlans(arg0_29, arg1_29, arg2_29)
	arg0_29:emit(EducateScheduleMediator.GET_PLANS, {
		gridData = arg0_29.gridData,
		isSkip = arg1_29,
		isSkipEvent = arg2_29
	})
end

function var0_0.didEnter(arg0_30)
	arg0_30:updateBg()
	arg0_30:initTimeTitle()
	arg0_30:initTargetText()
	arg0_30:updateIndexDatas()
	arg0_30:initSchedulePanel()
	arg0_30:initSelectPlans()
	arg0_30:initResultPanel()
	arg0_30:checkTips()
	arg0_30:OverlayPanel(arg0_30.mainTF, {
		pbList = {
			arg0_30.mainTF:Find("bg")
		}
	})
	arg0_30:OverlayPanel(arg0_30.topTF, {
		groupDelta = 1
	})
end

function var0_0.checkTips(arg0_31)
	arg0_31.newUnlcokPlanIds = EducateTipHelper.GetPlanUnlockTipIds()

	if #arg0_31.newUnlcokPlanIds > 0 then
		arg0_31:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_PLAN,
			list = arg0_31.newUnlcokPlanIds
		})
	end
end

function var0_0.updateBg(arg0_32)
	local var0_32 = LoadSprite("bg/" .. arg0_32.char:GetBGName())

	setImageSprite(arg0_32.bgTF, var0_32, false)
end

function var0_0.initTimeTitle(arg0_33)
	local var0_33 = EducateHelper.GetTimeAfterWeeks(arg0_33.curTime, 1)
	local var1_33 = EducateHelper.GetShowMonthNumber(var0_33.month)

	setText(arg0_33.monthText, var1_33)

	local var2_33 = i18n("number_" .. var0_33.week)

	setText(arg0_33.weekText, i18n("word_which_week", var2_33))
end

function var0_0.initTargetText(arg0_34)
	arg0_34.showAttrSubtype = 0

	local var0_34 = arg0_34.educateProxy:GetTaskProxy()

	if not var0_34:CanGetTargetAward() then
		setText(arg0_34.targetTF:Find("Text"), i18n("child_task_finish_all"))
		setActive(arg0_34.targetTF:Find("icon"), false)
	else
		local var1_34 = var0_34:FilterByGroup(var0_34:GetTargetTasksForShow())[1]

		if not var1_34 then
			setActive(arg0_34.targetTF, false)
		end

		setText(arg0_34.targetTF:Find("Text"), var1_34:getConfig("name"))

		if var1_34:GetType() == EducateTask.TYPE_ATTR then
			setActive(arg0_34.targetTF:Find("icon"), true)

			arg0_34.showAttrSubtype = var1_34:getConfig("sub_type")

			local var2_34 = type(arg0_34.showAttrSubtype) == "string" and arg0_34.showAttrSubtype or arg0_34.showAttrSubtype[1]

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var2_34, arg0_34.targetTF:Find("icon"))
		else
			setActive(arg0_34.targetTF:Find("icon"), false)
		end
	end
end

function var0_0.updateIndexDatas(arg0_35)
	arg0_35.contextData.indexDatas = arg0_35.contextData.indexDatas or {}
	arg0_35.contextData.indexDatas.typeIndex = arg0_35.typeIndex
	arg0_35.contextData.indexDatas.costIndex = arg0_35.costIndex
	arg0_35.contextData.indexDatas.awardResIndex = arg0_35.awardResIndex
	arg0_35.contextData.indexDatas.awardNatureIndex = arg0_35.awardNatureIndex
	arg0_35.contextData.indexDatas.awardAttr1Index = arg0_35.awardAttr1Index
	arg0_35.contextData.indexDatas.awardAttr2Index = arg0_35.awardAttr2Index
end

function var0_0.initSchedulePanel(arg0_36)
	arg0_36.dayList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventInit then
			local var0_37 = arg1_37 + 1

			arg2_37.name = tostring(var0_37)

			GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var0_37, arg2_37:Find("title"), true)

			for iter0_37 = 1, 3 do
				local var1_37 = arg2_37:Find("cells"):GetChild(iter0_37 - 1)
				local var2_37 = arg0_36.planProxy:GetGridBgName(var0_37, iter0_37)

				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_37[1], var1_37:Find("empty"), true)
				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_37[2], var1_37:Find("plan/name_bg"), true)
				onButton(arg0_36, var1_37, function()
					local var0_38 = arg0_36.gridData[var0_37][iter0_37]

					if var0_38:IsEvent() or var0_38:IsEventOccupy() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
					else
						arg0_36:openSelectPanel(var0_37, iter0_37)
					end
				end, SFX_PANEL)
			end
		end

		if arg0_37 == UIItemList.EventUpdate then
			arg0_36:updateDayGrids(arg1_37, arg2_37)
		end
	end)
	arg0_36.dayList:align(6)
end

function var0_0._updateGrid(arg0_39, arg1_39, arg2_39)
	setActive(arg1_39, not arg2_39:IsLock())

	if not arg2_39:IsLock() then
		setActive(arg1_39:Find("empty"), arg2_39:IsEmpty())

		arg1_39:GetComponent(typeof(Image)).enabled = not arg2_39:IsEmpty()

		setActive(arg1_39:Find("plan"), not arg2_39:IsEmpty())

		if arg2_39:IsPlan() or arg2_39:IsPlanOccupy() then
			LoadImageSpriteAsync("educateprops/" .. arg2_39.data:getConfig("icon"), arg1_39:Find("plan/icon"), true)
			setScrollText(arg1_39:Find("plan/name_bg/Text"), arg2_39.data:getConfig("name"))
		end

		if arg2_39:IsEvent() or arg2_39:IsEventOccupy() then
			local var0_39 = arg2_39.data:getConfig("type_param")[1] or ""

			LoadImageSpriteAsync("educateprops/" .. var0_39, arg1_39:Find("plan/icon"), true)
			setScrollText(arg1_39:Find("plan/name_bg/Text"), i18n("child_plan_event"))
		end
	end
end

function var0_0.updateDayGrids(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40 + 1

	for iter0_40 = 1, 3 do
		local var1_40 = arg2_40:Find("cells"):GetChild(iter0_40 - 1)

		var1_40.name = tostring(iter0_40)

		local var2_40 = arg0_40.gridData[var0_40][iter0_40]

		arg0_40:_updateGrid(var1_40, var2_40)
	end
end

function var0_0.initSelectPlans(arg0_41)
	arg0_41.plansRect = arg0_41.plansView:GetComponent("LScrollRect")
	arg0_41.planCards = {}

	function arg0_41.plansRect.onInitItem(arg0_42)
		local var0_42 = EducateSchedulePlanCard.New(arg0_42, arg0_41)

		arg0_41.planCards[arg0_42] = var0_42
	end

	function arg0_41.plansRect.onUpdateItem(arg0_43, arg1_43)
		local var0_43 = arg0_41.planCards[arg1_43]

		if not var0_43 then
			local var1_43 = EducateSchedulePlanCard.New(arg1_43, arg0_41)

			arg0_41.planCards[arg1_43] = var1_43
		end

		local var2_43 = arg0_41.showPlans[arg0_43 + 1]
		local var3_43 = 0
		local var4_43 = arg0_41.gridData[arg0_41.selectDay][arg0_41.selectIndex]

		if var4_43 and var4_43:IsPlanOccupy() or var4_43:IsPlan() then
			var3_43 = var4_43.id
		end

		var0_43:update(var2_43, var3_43)
	end

	function arg0_41.plansRect.onReturnItem(arg0_44, arg1_44)
		return
	end

	for iter0_41 = 1, 3 do
		local var0_41 = arg0_41.selectPanelTF:Find("day/cells"):GetChild(iter0_41 - 1)

		onButton(arg0_41, var0_41, function()
			local var0_45 = arg0_41.gridData[arg0_41.selectDay][iter0_41]

			if var0_45:IsEvent() or var0_45:IsEventOccupy() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
			else
				arg0_41.selectIndex = iter0_41

				arg0_41:updateSelectdDay()
				arg0_41:updatePlanList()
			end
		end, SFX_PANEL)
	end
end

function var0_0.openSelectPanel(arg0_46, arg1_46, arg2_46)
	LoadImageSpriteAtlasAsync("ui/educatescheduleui_atlas", arg1_46, arg0_46.selectPanelTF:Find("day/title"), true)
	setActive(arg0_46.selectPanelTF, true)
	setActive(arg0_46.scheduleTF, false)

	arg0_46.selectDay = arg1_46
	arg0_46.selectIndex = arg2_46

	arg0_46:updateSelectdDay()
	arg0_46:updatePlanList()
end

function var0_0.updateSelectdDay(arg0_47)
	for iter0_47 = 1, 3 do
		local var0_47 = arg0_47.selectPanelTF:Find("day/cells"):GetChild(iter0_47 - 1)
		local var1_47 = arg0_47.gridData[arg0_47.selectDay][iter0_47]
		local var2_47 = arg0_47.planProxy:GetGridBgName(arg0_47.selectDay, iter0_47)

		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_47[1], var0_47:Find("empty"), true)
		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_47[2], var0_47:Find("plan/name_bg"), true)
		setActive(var0_47:Find("selected"), arg0_47.selectIndex == iter0_47)
		arg0_47:_updateGrid(var0_47, var1_47)
	end
end

function var0_0.updatePlanList(arg0_48)
	if arg0_48.selectIndex ~= 0 then
		arg0_48.showPlans = arg0_48:filter(arg0_48.planProxy:GetShowPlans(arg0_48.char:GetNextWeekStage(), arg0_48.selectDay, arg0_48.selectIndex))

		arg0_48:sortPlans()
		arg0_48.plansRect:SetTotalCount(#arg0_48.showPlans, -1)
	end
end

function var0_0.sortPlans(arg0_49)
	table.sort(arg0_49.showPlans, CompareFuncs({
		function(arg0_50)
			return table.contains(arg0_49.newUnlcokPlanIds, arg0_50.id) and 0 or 1
		end,
		function(arg0_51)
			return arg0_51:IsMatchAttr(arg0_49.char) and 0 or 1
		end,
		function(arg0_52)
			return arg0_52:CheckResultBySubType(EducateConst.DROP_TYPE_ATTR, arg0_49.showAttrSubtype) and 0 or 1
		end,
		function(arg0_53)
			return -arg0_53:getConfig("rare")
		end,
		function(arg0_54)
			return arg0_54.id
		end
	}))

	arg0_49.newUnlcokPlanIds = {}
end

function var0_0.OnPlanCardClick(arg0_55, arg1_55)
	local var0_55, var1_55 = arg0_55:CheckCondition(arg1_55)

	if var0_55 then
		local var2_55 = EducateGrid.New({
			type = EducateGrid.TYPE_PLAN,
			id = arg1_55.id
		})

		arg0_55:setGridDataForPlan(arg0_55.selectDay, arg0_55.selectIndex, var2_55)
		arg0_55:updateSelectdDay()
		arg0_55:updateResultPanel()
		arg0_55:closeSelectPanel()
	else
		pg.TipsMgr.GetInstance():ShowTips(var1_55)
	end
end

function var0_0.filter(arg0_56, arg1_56)
	return underscore.select(arg1_56, function(arg0_57)
		return EducatePlanIndexConst.filterByType(arg0_57, arg0_56.typeIndex) and EducatePlanIndexConst.filterByCost(arg0_57, arg0_56.costIndex) and EducatePlanIndexConst.filterByAwardRes(arg0_57, arg0_56.awardResIndex) and EducatePlanIndexConst.filterByAwardNature(arg0_57, arg0_56.awardNatureIndex) and EducatePlanIndexConst.filterByAwardAttr1(arg0_57, arg0_56.awardAttr1Index) and EducatePlanIndexConst.filterByAwardAttr2(arg0_57, arg0_56.awardAttr2Index)
	end)
end

function var0_0.closeSelectPanel(arg0_58)
	setActive(arg0_58.selectPanelTF, false)
	setActive(arg0_58.scheduleTF, true)
	arg0_58.dayList:align(6)
end

function var0_0.CheckCondition(arg0_59, arg1_59)
	local var0_59 = arg0_59.gridData[arg0_59.selectDay][arg0_59.selectIndex]

	if var0_59:IsEvent() or var0_59:IsEventOccupy() then
		return false, i18n("child_schedule_event_tip")
	end

	local var1_59 = var0_59.data
	local var2_59, var3_59, var4_59 = arg1_59:GetCost()

	if var4_59 > 1 and not arg0_59:CheckRemainGrid(var4_59, var0_59.id) then
		return false, i18n("child_plan_check_tip1")
	end

	if not arg1_59:IsMatchAttr(arg0_59.char) then
		return false, i18n("child_plan_check_tip2")
	end

	if not arg1_59:IsInStage(arg0_59.char:GetNextWeekStage()) then
		return false, i18n("child_plan_check_tip6")
	end

	local var5_59 = arg1_59:getConfig("pre")[1]

	if not arg1_59:IsMatchPre(arg0_59.planProxy:GetHistoryCntById(var5_59)) then
		return false, i18n("child_plan_check_tip3")
	end

	local var6_59, var7_59 = arg0_59:getPlansCost()
	local var8_59 = 0
	local var9_59 = 0

	if var0_59:IsPlan() or var0_59:IsPlanOccupy() then
		local var10_59

		var8_59, var10_59 = var1_59:GetCost()
	end

	if arg0_59.char.money < var6_59 + var2_59 - var8_59 then
		return false, i18n("child_plan_check_tip4")
	end

	return true
end

function var0_0.CheckRemainGrid(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg0_60.selectIndex + arg1_60 - 1

	if var0_60 > 3 then
		return false
	end

	for iter0_60 = arg0_60.selectIndex + 1, var0_60 do
		local var1_60 = arg0_60.gridData[arg0_60.selectDay][iter0_60]

		if not var1_60:IsEmpty() and (not var1_60:IsPlanOccupy() or var1_60.id ~= arg2_60) then
			return false
		end
	end

	return true
end

function var0_0.showBuffBox(arg0_61, arg1_61)
	arg0_61:emit(var0_0.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_BUFF,
			id = arg1_61
		}
	})
end

function var0_0.initResultPanel(arg0_62)
	arg0_62.resPanel:ActionInvoke("FlushAddValue", "", "")
	arg0_62.buffUIList:make(function(arg0_63, arg1_63, arg2_63)
		if arg0_63 == UIItemList.EventUpdate then
			onButton(arg0_62, arg2_63, function()
				arg0_62:showBuffBox(arg0_62.buffList[arg1_63 + 1].id)
			end, SFX_PANEL)
		end
	end)
	arg0_62.buffUIList:align(#arg0_62.buffList)

	local var0_62 = arg0_62.natureTF:Find("content")
	local var1_62 = arg0_62.avatarTF:Find("progress")
	local var2_62 = arg0_62.char:GetPaintingName()

	setImageSprite(arg0_62.avatarTF:Find("mask/Image"), LoadSprite("squareicon/" .. var2_62), true)

	for iter0_62, iter1_62 in ipairs(arg0_62.natureIds) do
		local var3_62 = var0_62:GetChild(iter0_62 - 1)

		setActive(var3_62:Find("tip"), false)

		var3_62.name = iter1_62

		setScrollText(var3_62:Find("mask/Text"), pg.child_attr[iter1_62].name .. " " .. arg0_62.char:GetAttrById(iter1_62))
	end

	arg0_62.majorUIList:make(function(arg0_65, arg1_65, arg2_65)
		if arg0_65 == UIItemList.EventInit then
			local var0_65 = arg0_62.majorIds[arg1_65 + 1]

			arg2_65.name = var0_65

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_65, arg2_65:Find("icon"), true)
			setScrollText(arg2_65:Find("name_mask/name"), pg.child_attr[var0_65].name)

			local var1_65 = arg0_62.char:GetAttrInfo(var0_65)

			setText(arg2_65:Find("grade/Text"), var1_65)
			setText(arg2_65:Find("before_value"), arg0_62.char:GetAttrById(var0_65))

			local var2_65 = EducateConst.GRADE_2_COLOR[var1_65][2]

			setActive(arg2_65:Find("gradient"), false)
			setImageColor(arg2_65:Find("grade"), Color.NewHex(var2_65))
		elseif arg0_65 == UIItemList.EventUpdate then
			local var3_65 = tonumber(arg2_65.name)
			local var4_65 = arg0_62.char:GetAttrById(var3_65)

			if arg0_62.attrResults and arg0_62.attrResults[var3_65] then
				var4_65 = var4_65 + arg0_62.attrResults[var3_65]

				setActive(arg2_65:Find("gradient"), true)
				setImageColor(arg2_65:Find("arrow"), Color.NewHex("9efffe"))
				setText(arg2_65:Find("after_value"), setColorStr(var4_65, "#9efffe"))
			else
				setActive(arg2_65:Find("gradient"), false)
				setImageColor(arg2_65:Find("arrow"), Color.NewHex("dddedf"))
				setText(arg2_65:Find("after_value"), setColorStr(var4_65, "#ffffff"))
			end
		end
	end)
	arg0_62.minorUIList:make(function(arg0_66, arg1_66, arg2_66)
		if arg0_66 == UIItemList.EventInit then
			local var0_66 = arg0_62.minorIds[arg1_66 + 1]

			arg2_66.name = var0_66

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_66, arg2_66:Find("icon"), true)
			setText(arg2_66:Find("value"), arg0_62.char:GetAttrById(var0_66))
		elseif arg0_66 == UIItemList.EventUpdate then
			local var1_66 = tonumber(arg2_66.name)
			local var2_66 = arg0_62.char:GetAttrById(var1_66)

			setText(arg2_66:Find("name"), pg.child_attr[var1_66].name)

			if arg0_62.attrResults and arg0_62.attrResults[var1_66] then
				var2_66 = var2_66 .. setColorStr("+" .. arg0_62.attrResults[var1_66], "#9efffe")
			end

			setText(arg2_66:Find("value"), var2_66)
		end
	end)

	arg0_62.attrResults, arg0_62.resResult = {}, {}

	arg0_62:updateResultPanel()
end

function var0_0.updateResultPanel(arg0_67)
	local var0_67 = arg0_67:allEmpty()

	setActive(arg0_67.rightEmptyTF, var0_67)
	setActive(arg0_67.rightContentTF, not var0_67)

	if not var0_67 then
		arg0_67.attrResults, arg0_67.resResult = arg0_67:getPlansResult()

		arg0_67.majorUIList:align(#arg0_67.majorIds)
		arg0_67.minorUIList:align(#arg0_67.minorIds)

		local var1_67, var2_67 = arg0_67:getPlansCost()
		local var3_67 = arg0_67.resResult[EducateChar.RES_MONEY_ID] or 0
		local var4_67 = arg0_67.resResult[EducateChar.RES_MOOD_ID] or 0
		local var5_67 = var3_67 - var1_67 >= 0 and "+" .. var3_67 - var1_67 or var3_67 - var1_67
		local var6_67 = var4_67 - var2_67 >= 0 and "+" .. var4_67 - var2_67 or var4_67 - var2_67

		arg0_67.resPanel:ActionInvoke("FlushAddValue", var6_67, var5_67)

		local var7_67 = EducateHelper.IsShowNature()

		setActive(arg0_67.natureTF, var7_67)
		setActive(arg0_67.natureLockTF, not var7_67)

		if var7_67 then
			local var8_67 = arg0_67.natureTF:Find("content")

			eachChild(var8_67, function(arg0_68)
				local var0_68 = tonumber(arg0_68.name)

				if arg0_67.attrResults and arg0_67.attrResults[var0_68] and arg0_67.attrResults[var0_68] ~= 0 then
					local var1_68 = arg0_67.attrResults[var0_68]
					local var2_68 = var1_68 > 0 and "+" or ""
					local var3_68 = var1_68 > 0 and "39bfff" or "a9a9a9"

					setActive(arg0_68:Find("tip"), true)
					setImageColor(arg0_68:Find("tip"), Color.NewHex(var3_68))
					setText(arg0_68:Find("tip/Text"), var2_68 .. var1_68)
				else
					setActive(arg0_68:Find("tip"), false)
				end
			end)
		end
	end
end

function var0_0.getPlansResult(arg0_69)
	local var0_69 = {}
	local var1_69 = {}

	for iter0_69, iter1_69 in ipairs(arg0_69.gridData) do
		for iter2_69, iter3_69 in ipairs(iter1_69) do
			if iter3_69:IsPlan() then
				for iter4_69, iter5_69 in ipairs(iter3_69.data:GetResult()) do
					if iter5_69[1] == EducateConst.DROP_TYPE_ATTR then
						local var2_69 = var0_69[iter5_69[2]] or 0

						var0_69[iter5_69[2]] = var2_69 + iter5_69[3]
					elseif iter5_69[1] == EducateConst.DROP_TYPE_RES then
						local var3_69 = var1_69[iter5_69[2]] or 0

						var1_69[iter5_69[2]] = var3_69 + iter5_69[3]
					end
				end
			end
		end
	end

	return var0_69, var1_69
end

function var0_0.getPlansCost(arg0_70)
	local var0_70 = 0
	local var1_70 = 0
	local var2_70 = {}

	for iter0_70, iter1_70 in pairs(arg0_70.gridData) do
		for iter2_70, iter3_70 in pairs(iter1_70) do
			if iter3_70:IsPlan() then
				local var3_70, var4_70 = iter3_70.data:GetCost()

				var0_70 = var0_70 + var3_70
				var1_70 = var1_70 + var4_70
			end
		end
	end

	return var0_70, var1_70
end

function var0_0.getRemainGridCnt(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71.gridData[arg1_71]
	local var1_71 = 1

	for iter0_71, iter1_71 in pairs(var0_71) do
		if arg2_71 < iter0_71 and iter1_71:IsEmpty() then
			var1_71 = var1_71 + 1
		end
	end

	return var1_71
end

function var0_0.DoRecommend(arg0_72)
	local var0_72 = arg0_72.char:GetAttrSortIds()

	for iter0_72, iter1_72 in pairs(arg0_72.gridData) do
		for iter2_72, iter3_72 in pairs(iter1_72) do
			if iter3_72:IsEmpty() then
				local var1_72, var2_72 = arg0_72:getPlansCost()
				local var3_72 = arg0_72:getRemainGridCnt(iter0_72, iter2_72)
				local var4_72 = arg0_72.planProxy:GetRecommendPlan(iter0_72, iter2_72, arg0_72.char, var1_72, var2_72, var3_72, var0_72)

				if var4_72 then
					local var5_72 = EducateGrid.New({
						type = EducateGrid.TYPE_PLAN,
						id = var4_72.id
					})

					arg0_72:setGridDataForPlan(iter0_72, iter2_72, var5_72)
				end
			end
		end
	end

	arg0_72:updateResultPanel()
	arg0_72:closeSelectPanel()
end

function var0_0.onBackPressed(arg0_73)
	if isActive(arg0_73.selectPanelTF) then
		arg0_73:closeSelectPanel()
	else
		var0_0.super.onBackPressed(arg0_73)
	end
end

function var0_0.willExit(arg0_74)
	arg0_74.topPanel:Destroy()

	arg0_74.topPanel = nil

	arg0_74.resPanel:Destroy()

	arg0_74.resPanel = nil

	arg0_74:UnOverlayPanel(arg0_74.mainTF, arg0_74._tf:Find("anim_root"))
	arg0_74:UnOverlayPanel(arg0_74.topTF, arg0_74._tf:Find("anim_root"))

	for iter0_74, iter1_74 in pairs(arg0_74.planCards) do
		iter1_74:dispose()
	end
end

return var0_0
