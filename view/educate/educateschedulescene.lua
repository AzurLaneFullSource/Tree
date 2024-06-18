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
	arg0_11.bgTF = arg0_11:findTF("anim_root/bg")
	arg0_11.topTF = arg0_11:findTF("anim_root/top")
	arg0_11.returnBtn = arg0_11:findTF("return_btn/return_btn", arg0_11.topTF)
	arg0_11.mainTF = arg0_11:findTF("anim_root/main")
	arg0_11.leftPanelTF = arg0_11:findTF("schedule_left", arg0_11.mainTF)
	arg0_11.targetTF = arg0_11:findTF("target", arg0_11.leftPanelTF)

	setText(arg0_11:findTF("title", arg0_11.targetTF), i18n("child_btn_target") .. ":")

	arg0_11.scheduleTF = arg0_11:findTF("schedule", arg0_11.leftPanelTF)
	arg0_11.dayList = UIItemList.New(arg0_11.scheduleTF, arg0_11:findTF("schedule/day_tpl", arg0_11.leftPanelTF))
	arg0_11.monthText = arg0_11:findTF("title/month", arg0_11.leftPanelTF)

	setText(arg0_11:findTF("title/right/content/month", arg0_11.leftPanelTF), i18n("word_month"))

	arg0_11.weekText = arg0_11:findTF("title/right/content/week", arg0_11.leftPanelTF)
	arg0_11.skipToggle = arg0_11:findTF("skip_toggle", arg0_11.leftPanelTF)
	arg0_11.skipToggleCom = arg0_11.skipToggle:GetComponent(typeof(Toggle))

	local var0_11 = PlayerPrefs.GetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0_11.playerID)

	triggerToggle(arg0_11.skipToggle, var0_11 == 1)
	setActive(arg0_11.skipToggle, true)
	setText(arg0_11:findTF("Text", arg0_11.skipToggle), i18n("child_plan_skip"))

	arg0_11.selectPanelTF = arg0_11:findTF("select_panel", arg0_11.leftPanelTF)

	setActive(arg0_11.selectPanelTF, false)

	arg0_11.selectCloseBtn = arg0_11:findTF("fold_btn", arg0_11.selectPanelTF)
	arg0_11.plansView = arg0_11:findTF("scrollview", arg0_11.selectPanelTF)
	arg0_11.rightPanelTF = arg0_11:findTF("result_right", arg0_11.mainTF)
	arg0_11.rightEmptyTF = arg0_11:findTF("empty", arg0_11.rightPanelTF)

	setText(arg0_11:findTF("Text", arg0_11.rightEmptyTF), i18n("child_schedule_empty_tip"))

	arg0_11.rightContentTF = arg0_11:findTF("content", arg0_11.rightPanelTF)
	arg0_11.buffUIList = UIItemList.New(arg0_11:findTF("buff_list", arg0_11.rightContentTF), arg0_11:findTF("buff_list/tpl", arg0_11.rightContentTF))
	arg0_11.avatarTF = arg0_11:findTF("avatar", arg0_11.rightContentTF)
	arg0_11.avatarImage = arg0_11:findTF("mask/Image", arg0_11.avatarTF)
	arg0_11.natureTF = arg0_11:findTF("nature/unlock", arg0_11.rightContentTF)
	arg0_11.natureLockTF = arg0_11:findTF("nature/lock", arg0_11.rightContentTF)

	setText(arg0_11:findTF("major_title/Text", arg0_11.rightContentTF), i18n("child_attr_name1"))
	setText(arg0_11:findTF("minor_title/Text", arg0_11.rightContentTF), i18n("child_attr_name2"))

	arg0_11.majorUIList = UIItemList.New(arg0_11:findTF("major", arg0_11.rightContentTF), arg0_11:findTF("major/tpl", arg0_11.rightContentTF))
	arg0_11.minorUIList = UIItemList.New(arg0_11:findTF("minor", arg0_11.rightContentTF), arg0_11:findTF("minor/tpl", arg0_11.rightContentTF))
	arg0_11.nextBtn = arg0_11:findTF("next_btn", arg0_11.rightPanelTF)
	arg0_11.topPanel = EducateTopPanel.New(arg0_11:findTF("top_right", arg0_11.topTF), arg0_11.event)

	arg0_11.topPanel:Load()

	arg0_11.resPanel = EducateResPanel.New(arg0_11:findTF("res", arg0_11.topTF), arg0_11.event)

	arg0_11.resPanel:Load()
end

function var0_0.addListener(arg0_12)
	setActive(arg0_12:findTF("clear_btn", arg0_12.topTF), false)
	onButton(arg0_12, arg0_12:findTF("clear_btn", arg0_12.topTF), function()
		arg0_12:clearLocalPlans()
		arg0_12.resPanel:Flush()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12:findTF("index_btn", arg0_12.selectPanelTF), function()
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
			arg0_12:executePlans(arg0_12.skipToggleCom.isOn)
		end)
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.skipToggle, function(arg0_25)
		PlayerPrefs.SetInt(EducateConst.SKIP_PLANS_ANIM_KEY .. "_" .. arg0_12.playerID, arg0_25 and 1 or 0)
	end, SFX_PANEL)
end

function var0_0.haveEmpty(arg0_26)
	for iter0_26 = 1, 6 do
		for iter1_26 = 1, 3 do
			if arg0_26.gridData[iter0_26][iter1_26]:IsEmpty() then
				return true
			end
		end
	end

	return false
end

function var0_0.allEmpty(arg0_27)
	for iter0_27 = 1, 6 do
		for iter1_27 = 1, 3 do
			local var0_27 = arg0_27.gridData[iter0_27][iter1_27]

			if not var0_27:IsEmpty() and not var0_27:IsLock() then
				return false
			end
		end
	end

	return true
end

function var0_0.executePlans(arg0_28, arg1_28)
	arg0_28:emit(EducateScheduleMediator.GET_PLANS, {
		gridData = arg0_28.gridData,
		isSkip = arg1_28
	})
end

function var0_0.didEnter(arg0_29)
	arg0_29:updateBg()
	arg0_29:initTimeTitle()
	arg0_29:initTargetText()
	arg0_29:updateIndexDatas()
	arg0_29:initSchedulePanel()
	arg0_29:initSelectPlans()
	arg0_29:initResultPanel()
	arg0_29:checkTips()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_29.mainTF, {
		pbList = {
			arg0_29:findTF("bg", arg0_29.mainTF)
		},
		groupName = LayerWeightConst.GROUP_EDUCATE
	})
	pg.UIMgr.GetInstance():OverlayPanel(arg0_29.topTF, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0_0.checkTips(arg0_30)
	arg0_30.newUnlcokPlanIds = EducateTipHelper.GetPlanUnlockTipIds()

	if #arg0_30.newUnlcokPlanIds > 0 then
		arg0_30:emit(var0_0.EDUCATE_ON_UNLOCK_TIP, {
			type = EducateUnlockTipLayer.UNLOCK_TYPE_PLAN,
			list = arg0_30.newUnlcokPlanIds
		})
	end
end

function var0_0.updateBg(arg0_31)
	local var0_31 = LoadSprite("bg/" .. arg0_31.char:GetBGName())

	setImageSprite(arg0_31.bgTF, var0_31, false)
end

function var0_0.initTimeTitle(arg0_32)
	local var0_32 = EducateHelper.GetTimeAfterWeeks(arg0_32.curTime, 1)
	local var1_32 = EducateHelper.GetShowMonthNumber(var0_32.month)

	setText(arg0_32.monthText, var1_32)

	local var2_32 = i18n("number_" .. var0_32.week)

	setText(arg0_32.weekText, i18n("word_which_week", var2_32))
end

function var0_0.initTargetText(arg0_33)
	arg0_33.showAttrSubtype = 0

	local var0_33 = arg0_33.educateProxy:GetTaskProxy()

	if not var0_33:CanGetTargetAward() then
		setText(arg0_33:findTF("Text", arg0_33.targetTF), i18n("child_task_finish_all"))
		setActive(arg0_33:findTF("icon", arg0_33.targetTF), false)
	else
		local var1_33 = var0_33:FilterByGroup(var0_33:GetTargetTasksForShow())[1]

		if not var1_33 then
			setActive(arg0_33.targetTF, false)
		end

		setText(arg0_33:findTF("Text", arg0_33.targetTF), var1_33:getConfig("name"))

		if var1_33:GetType() == EducateTask.TYPE_ATTR then
			setActive(arg0_33:findTF("icon", arg0_33.targetTF), true)

			arg0_33.showAttrSubtype = var1_33:getConfig("sub_type")

			local var2_33 = type(arg0_33.showAttrSubtype) == "string" and arg0_33.showAttrSubtype or arg0_33.showAttrSubtype[1]

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var2_33, arg0_33:findTF("icon", arg0_33.targetTF))
		else
			setActive(arg0_33:findTF("icon", arg0_33.targetTF), false)
		end
	end
end

function var0_0.updateIndexDatas(arg0_34)
	arg0_34.contextData.indexDatas = arg0_34.contextData.indexDatas or {}
	arg0_34.contextData.indexDatas.typeIndex = arg0_34.typeIndex
	arg0_34.contextData.indexDatas.costIndex = arg0_34.costIndex
	arg0_34.contextData.indexDatas.awardResIndex = arg0_34.awardResIndex
	arg0_34.contextData.indexDatas.awardNatureIndex = arg0_34.awardNatureIndex
	arg0_34.contextData.indexDatas.awardAttr1Index = arg0_34.awardAttr1Index
	arg0_34.contextData.indexDatas.awardAttr2Index = arg0_34.awardAttr2Index
end

function var0_0.initSchedulePanel(arg0_35)
	arg0_35.dayList:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventInit then
			local var0_36 = arg1_36 + 1

			arg2_36.name = tostring(var0_36)

			GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var0_36, arg0_35:findTF("title", arg2_36), true)

			for iter0_36 = 1, 3 do
				local var1_36 = arg0_35:findTF("cells", arg2_36):GetChild(iter0_36 - 1)
				local var2_36 = arg0_35.planProxy:GetGridBgName(var0_36, iter0_36)

				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_36[1], arg0_35:findTF("empty", var1_36), true)
				GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_36[2], arg0_35:findTF("plan/name_bg", var1_36), true)
				onButton(arg0_35, var1_36, function()
					local var0_37 = arg0_35.gridData[var0_36][iter0_36]

					if var0_37:IsEvent() or var0_37:IsEventOccupy() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
					else
						arg0_35:openSelectPanel(var0_36, iter0_36)
					end
				end, SFX_PANEL)
			end
		end

		if arg0_36 == UIItemList.EventUpdate then
			arg0_35:updateDayGrids(arg1_36, arg2_36)
		end
	end)
	arg0_35.dayList:align(6)
end

function var0_0._updateGrid(arg0_38, arg1_38, arg2_38)
	setActive(arg1_38, not arg2_38:IsLock())

	if not arg2_38:IsLock() then
		setActive(arg0_38:findTF("empty", arg1_38), arg2_38:IsEmpty())

		arg1_38:GetComponent(typeof(Image)).enabled = not arg2_38:IsEmpty()

		setActive(arg0_38:findTF("plan", arg1_38), not arg2_38:IsEmpty())

		if arg2_38:IsPlan() or arg2_38:IsPlanOccupy() then
			LoadImageSpriteAsync("educateprops/" .. arg2_38.data:getConfig("icon"), arg0_38:findTF("plan/icon", arg1_38), true)
			setScrollText(arg0_38:findTF("plan/name_bg/Text", arg1_38), arg2_38.data:getConfig("name"))
		end

		if arg2_38:IsEvent() or arg2_38:IsEventOccupy() then
			local var0_38 = arg2_38.data:getConfig("type_param")[1] or ""

			LoadImageSpriteAsync("educateprops/" .. var0_38, arg0_38:findTF("plan/icon", arg1_38), true)
			setScrollText(arg0_38:findTF("plan/name_bg/Text", arg1_38), i18n("child_plan_event"))
		end
	end
end

function var0_0.updateDayGrids(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39 + 1

	for iter0_39 = 1, 3 do
		local var1_39 = arg0_39:findTF("cells", arg2_39):GetChild(iter0_39 - 1)

		var1_39.name = tostring(iter0_39)

		local var2_39 = arg0_39.gridData[var0_39][iter0_39]

		arg0_39:_updateGrid(var1_39, var2_39)
	end
end

function var0_0.initSelectPlans(arg0_40)
	arg0_40.plansRect = arg0_40.plansView:GetComponent("LScrollRect")
	arg0_40.planCards = {}

	function arg0_40.plansRect.onInitItem(arg0_41)
		local var0_41 = EducateSchedulePlanCard.New(arg0_41, arg0_40)

		arg0_40.planCards[arg0_41] = var0_41
	end

	function arg0_40.plansRect.onUpdateItem(arg0_42, arg1_42)
		local var0_42 = arg0_40.planCards[arg1_42]

		if not var0_42 then
			local var1_42 = EducateSchedulePlanCard.New(arg1_42, arg0_40)

			arg0_40.planCards[arg1_42] = var1_42
		end

		local var2_42 = arg0_40.showPlans[arg0_42 + 1]
		local var3_42 = 0
		local var4_42 = arg0_40.gridData[arg0_40.selectDay][arg0_40.selectIndex]

		if var4_42 and var4_42:IsPlanOccupy() or var4_42:IsPlan() then
			var3_42 = var4_42.id
		end

		var0_42:update(var2_42, var3_42)
	end

	function arg0_40.plansRect.onReturnItem(arg0_43, arg1_43)
		return
	end

	for iter0_40 = 1, 3 do
		local var0_40 = arg0_40:findTF("day/cells", arg0_40.selectPanelTF):GetChild(iter0_40 - 1)

		onButton(arg0_40, var0_40, function()
			local var0_44 = arg0_40.gridData[arg0_40.selectDay][iter0_40]

			if var0_44:IsEvent() or var0_44:IsEventOccupy() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_schedule_event_tip"))
			else
				arg0_40.selectIndex = iter0_40

				arg0_40:updateSelectdDay()
				arg0_40:updatePlanList()
			end
		end, SFX_PANEL)
	end
end

function var0_0.openSelectPanel(arg0_45, arg1_45, arg2_45)
	LoadImageSpriteAtlasAsync("ui/educatescheduleui_atlas", arg1_45, arg0_45:findTF("day/title", arg0_45.selectPanelTF), true)
	setActive(arg0_45.selectPanelTF, true)
	setActive(arg0_45.scheduleTF, false)

	arg0_45.selectDay = arg1_45
	arg0_45.selectIndex = arg2_45

	arg0_45:updateSelectdDay()
	arg0_45:updatePlanList()
end

function var0_0.updateSelectdDay(arg0_46)
	for iter0_46 = 1, 3 do
		local var0_46 = arg0_46:findTF("day/cells", arg0_46.selectPanelTF):GetChild(iter0_46 - 1)
		local var1_46 = arg0_46.gridData[arg0_46.selectDay][iter0_46]
		local var2_46 = arg0_46.planProxy:GetGridBgName(arg0_46.selectDay, iter0_46)

		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_46[1], arg0_46:findTF("empty", var0_46), true)
		GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", var2_46[2], arg0_46:findTF("plan/name_bg", var0_46), true)
		setActive(arg0_46:findTF("selected", var0_46), arg0_46.selectIndex == iter0_46)
		arg0_46:_updateGrid(var0_46, var1_46)
	end
end

function var0_0.updatePlanList(arg0_47)
	if arg0_47.selectIndex ~= 0 then
		arg0_47.showPlans = arg0_47:filter(arg0_47.planProxy:GetShowPlans(arg0_47.char:GetNextWeekStage(), arg0_47.selectDay, arg0_47.selectIndex))

		arg0_47:sortPlans()
		arg0_47.plansRect:SetTotalCount(#arg0_47.showPlans, -1)
	end
end

function var0_0.sortPlans(arg0_48)
	table.sort(arg0_48.showPlans, CompareFuncs({
		function(arg0_49)
			return table.contains(arg0_48.newUnlcokPlanIds, arg0_49.id) and 0 or 1
		end,
		function(arg0_50)
			return arg0_50:IsMatchAttr(arg0_48.char) and 0 or 1
		end,
		function(arg0_51)
			return arg0_51:CheckResultBySubType(EducateConst.DROP_TYPE_ATTR, arg0_48.showAttrSubtype) and 0 or 1
		end,
		function(arg0_52)
			return -arg0_52:getConfig("rare")
		end,
		function(arg0_53)
			return arg0_53.id
		end
	}))

	arg0_48.newUnlcokPlanIds = {}
end

function var0_0.OnPlanCardClick(arg0_54, arg1_54)
	local var0_54, var1_54 = arg0_54:CheckCondition(arg1_54)

	if var0_54 then
		local var2_54 = EducateGrid.New({
			type = EducateGrid.TYPE_PLAN,
			id = arg1_54.id
		})

		arg0_54:setGridDataForPlan(arg0_54.selectDay, arg0_54.selectIndex, var2_54)
		arg0_54:updateSelectdDay()
		arg0_54:updateResultPanel()
		arg0_54:closeSelectPanel()
	else
		pg.TipsMgr.GetInstance():ShowTips(var1_54)
	end
end

function var0_0.filter(arg0_55, arg1_55)
	return underscore.select(arg1_55, function(arg0_56)
		return EducatePlanIndexConst.filterByType(arg0_56, arg0_55.typeIndex) and EducatePlanIndexConst.filterByCost(arg0_56, arg0_55.costIndex) and EducatePlanIndexConst.filterByAwardRes(arg0_56, arg0_55.awardResIndex) and EducatePlanIndexConst.filterByAwardNature(arg0_56, arg0_55.awardNatureIndex) and EducatePlanIndexConst.filterByAwardAttr1(arg0_56, arg0_55.awardAttr1Index) and EducatePlanIndexConst.filterByAwardAttr2(arg0_56, arg0_55.awardAttr2Index)
	end)
end

function var0_0.closeSelectPanel(arg0_57)
	setActive(arg0_57.selectPanelTF, false)
	setActive(arg0_57.scheduleTF, true)
	arg0_57.dayList:align(6)
end

function var0_0.CheckCondition(arg0_58, arg1_58)
	local var0_58 = arg0_58.gridData[arg0_58.selectDay][arg0_58.selectIndex]

	if var0_58:IsEvent() or var0_58:IsEventOccupy() then
		return false, i18n("child_schedule_event_tip")
	end

	local var1_58 = var0_58.data
	local var2_58, var3_58, var4_58 = arg1_58:GetCost()

	if var4_58 > 1 and not arg0_58:CheckRemainGrid(var4_58, var0_58.id) then
		return false, i18n("child_plan_check_tip1")
	end

	if not arg1_58:IsMatchAttr(arg0_58.char) then
		return false, i18n("child_plan_check_tip2")
	end

	if not arg1_58:IsInStage(arg0_58.char:GetNextWeekStage()) then
		return false, i18n("child_plan_check_tip6")
	end

	local var5_58 = arg1_58:getConfig("pre")[1]

	if not arg1_58:IsMatchPre(arg0_58.planProxy:GetHistoryCntById(var5_58)) then
		return false, i18n("child_plan_check_tip3")
	end

	local var6_58, var7_58 = arg0_58:getPlansCost()
	local var8_58 = 0
	local var9_58 = 0

	if var0_58:IsPlan() or var0_58:IsPlanOccupy() then
		local var10_58

		var8_58, var10_58 = var1_58:GetCost()
	end

	if arg0_58.char.money < var6_58 + var2_58 - var8_58 then
		return false, i18n("child_plan_check_tip4")
	end

	return true
end

function var0_0.CheckRemainGrid(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg0_59.selectIndex + arg1_59 - 1

	if var0_59 > 3 then
		return false
	end

	for iter0_59 = arg0_59.selectIndex + 1, var0_59 do
		local var1_59 = arg0_59.gridData[arg0_59.selectDay][iter0_59]

		if not var1_59:IsEmpty() and (not var1_59:IsPlanOccupy() or var1_59.id ~= arg2_59) then
			return false
		end
	end

	return true
end

function var0_0.showBuffBox(arg0_60, arg1_60)
	arg0_60:emit(var0_0.EDUCATE_ON_ITEM, {
		drop = {
			number = 1,
			type = EducateConst.DROP_TYPE_BUFF,
			id = arg1_60
		}
	})
end

function var0_0.initResultPanel(arg0_61)
	arg0_61.resPanel:FlushAddValue("", "")
	arg0_61.buffUIList:make(function(arg0_62, arg1_62, arg2_62)
		if arg0_62 == UIItemList.EventUpdate then
			onButton(arg0_61, arg2_62, function()
				arg0_61:showBuffBox(arg0_61.buffList[arg1_62 + 1].id)
			end, SFX_PANEL)
		end
	end)
	arg0_61.buffUIList:align(#arg0_61.buffList)

	local var0_61 = arg0_61:findTF("content", arg0_61.natureTF)
	local var1_61 = arg0_61:findTF("progress", arg0_61.avatarTF)
	local var2_61 = arg0_61.char:GetPaintingName()

	setImageSprite(arg0_61:findTF("mask/Image", arg0_61.avatarTF), LoadSprite("squareicon/" .. var2_61), true)

	for iter0_61, iter1_61 in ipairs(arg0_61.natureIds) do
		local var3_61 = var0_61:GetChild(iter0_61 - 1)

		setActive(arg0_61:findTF("tip", var3_61), false)

		var3_61.name = iter1_61

		setScrollText(arg0_61:findTF("mask/Text", var3_61), pg.child_attr[iter1_61].name .. " " .. arg0_61.char:GetAttrById(iter1_61))
	end

	arg0_61.majorUIList:make(function(arg0_64, arg1_64, arg2_64)
		if arg0_64 == UIItemList.EventInit then
			local var0_64 = arg0_61.majorIds[arg1_64 + 1]

			arg2_64.name = var0_64

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_64, arg0_61:findTF("icon", arg2_64), true)
			setScrollText(arg0_61:findTF("name_mask/name", arg2_64), pg.child_attr[var0_64].name)

			local var1_64 = arg0_61.char:GetAttrInfo(var0_64)

			setText(arg0_61:findTF("grade/Text", arg2_64), var1_64)
			setText(arg0_61:findTF("before_value", arg2_64), arg0_61.char:GetAttrById(var0_64))

			local var2_64 = EducateConst.GRADE_2_COLOR[var1_64][2]

			setActive(arg0_61:findTF("gradient", arg2_64), false)
			setImageColor(arg0_61:findTF("grade", arg2_64), Color.NewHex(var2_64))
		elseif arg0_64 == UIItemList.EventUpdate then
			local var3_64 = tonumber(arg2_64.name)
			local var4_64 = arg0_61.char:GetAttrById(var3_64)

			if arg0_61.attrResults and arg0_61.attrResults[var3_64] then
				var4_64 = var4_64 + arg0_61.attrResults[var3_64]

				setActive(arg0_61:findTF("gradient", arg2_64), true)
				setImageColor(arg0_61:findTF("arrow", arg2_64), Color.NewHex("9efffe"))
				setText(arg0_61:findTF("after_value", arg2_64), setColorStr(var4_64, "#9efffe"))
			else
				setActive(arg0_61:findTF("gradient", arg2_64), false)
				setImageColor(arg0_61:findTF("arrow", arg2_64), Color.NewHex("dddedf"))
				setText(arg0_61:findTF("after_value", arg2_64), setColorStr(var4_64, "#ffffff"))
			end
		end
	end)
	arg0_61.minorUIList:make(function(arg0_65, arg1_65, arg2_65)
		if arg0_65 == UIItemList.EventInit then
			local var0_65 = arg0_61.minorIds[arg1_65 + 1]

			arg2_65.name = var0_65

			GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var0_65, arg0_61:findTF("icon", arg2_65), true)
			setText(arg0_61:findTF("value", arg2_65), arg0_61.char:GetAttrById(var0_65))
		elseif arg0_65 == UIItemList.EventUpdate then
			local var1_65 = tonumber(arg2_65.name)
			local var2_65 = arg0_61.char:GetAttrById(var1_65)

			setText(arg0_61:findTF("name", arg2_65), pg.child_attr[var1_65].name)

			if arg0_61.attrResults and arg0_61.attrResults[var1_65] then
				var2_65 = var2_65 .. setColorStr("+" .. arg0_61.attrResults[var1_65], "#9efffe")
			end

			setText(arg0_61:findTF("value", arg2_65), var2_65)
		end
	end)

	arg0_61.attrResults, arg0_61.resResult = {}, {}

	arg0_61:updateResultPanel()
end

function var0_0.updateResultPanel(arg0_66)
	local var0_66 = arg0_66:allEmpty()

	setActive(arg0_66.rightEmptyTF, var0_66)
	setActive(arg0_66.rightContentTF, not var0_66)

	if not var0_66 then
		arg0_66.attrResults, arg0_66.resResult = arg0_66:getPlansResult()

		arg0_66.majorUIList:align(#arg0_66.majorIds)
		arg0_66.minorUIList:align(#arg0_66.minorIds)

		local var1_66, var2_66 = arg0_66:getPlansCost()
		local var3_66 = arg0_66.resResult[EducateChar.RES_MONEY_ID] or 0
		local var4_66 = arg0_66.resResult[EducateChar.RES_MOOD_ID] or 0
		local var5_66 = var3_66 - var1_66 >= 0 and "+" .. var3_66 - var1_66 or var3_66 - var1_66
		local var6_66 = var4_66 - var2_66 >= 0 and "+" .. var4_66 - var2_66 or var4_66 - var2_66

		arg0_66.resPanel:FlushAddValue(var6_66, var5_66)

		local var7_66 = EducateHelper.IsShowNature()

		setActive(arg0_66.natureTF, var7_66)
		setActive(arg0_66.natureLockTF, not var7_66)

		if var7_66 then
			local var8_66 = arg0_66:findTF("content", arg0_66.natureTF)

			eachChild(var8_66, function(arg0_67)
				local var0_67 = tonumber(arg0_67.name)

				if arg0_66.attrResults and arg0_66.attrResults[var0_67] and arg0_66.attrResults[var0_67] ~= 0 then
					local var1_67 = arg0_66.attrResults[var0_67]
					local var2_67 = var1_67 > 0 and "+" or ""
					local var3_67 = var1_67 > 0 and "39bfff" or "a9a9a9"

					setActive(arg0_66:findTF("tip", arg0_67), true)
					setImageColor(arg0_66:findTF("tip", arg0_67), Color.NewHex(var3_67))
					setText(arg0_66:findTF("tip/Text", arg0_67), var2_67 .. var1_67)
				else
					setActive(arg0_66:findTF("tip", arg0_67), false)
				end
			end)
		end
	end
end

function var0_0.getPlansResult(arg0_68)
	local var0_68 = {}
	local var1_68 = {}

	for iter0_68, iter1_68 in ipairs(arg0_68.gridData) do
		for iter2_68, iter3_68 in ipairs(iter1_68) do
			if iter3_68:IsPlan() then
				for iter4_68, iter5_68 in ipairs(iter3_68.data:GetResult()) do
					if iter5_68[1] == EducateConst.DROP_TYPE_ATTR then
						local var2_68 = var0_68[iter5_68[2]] or 0

						var0_68[iter5_68[2]] = var2_68 + iter5_68[3]
					elseif iter5_68[1] == EducateConst.DROP_TYPE_RES then
						local var3_68 = var1_68[iter5_68[2]] or 0

						var1_68[iter5_68[2]] = var3_68 + iter5_68[3]
					end
				end
			end
		end
	end

	return var0_68, var1_68
end

function var0_0.getPlansCost(arg0_69)
	local var0_69 = 0
	local var1_69 = 0
	local var2_69 = {}

	for iter0_69, iter1_69 in pairs(arg0_69.gridData) do
		for iter2_69, iter3_69 in pairs(iter1_69) do
			if iter3_69:IsPlan() then
				local var3_69, var4_69 = iter3_69.data:GetCost()

				var0_69 = var0_69 + var3_69
				var1_69 = var1_69 + var4_69
			end
		end
	end

	return var0_69, var1_69
end

function var0_0.getRemainGridCnt(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70.gridData[arg1_70]
	local var1_70 = 1

	for iter0_70, iter1_70 in pairs(var0_70) do
		if arg2_70 < iter0_70 and iter1_70:IsEmpty() then
			var1_70 = var1_70 + 1
		end
	end

	return var1_70
end

function var0_0.DoRecommend(arg0_71)
	local var0_71 = arg0_71.char:GetAttrSortIds()

	for iter0_71, iter1_71 in pairs(arg0_71.gridData) do
		for iter2_71, iter3_71 in pairs(iter1_71) do
			if iter3_71:IsEmpty() then
				local var1_71, var2_71 = arg0_71:getPlansCost()
				local var3_71 = arg0_71:getRemainGridCnt(iter0_71, iter2_71)
				local var4_71 = arg0_71.planProxy:GetRecommendPlan(iter0_71, iter2_71, arg0_71.char, var1_71, var2_71, var3_71, var0_71)

				if var4_71 then
					local var5_71 = EducateGrid.New({
						type = EducateGrid.TYPE_PLAN,
						id = var4_71.id
					})

					arg0_71:setGridDataForPlan(iter0_71, iter2_71, var5_71)
				end
			end
		end
	end

	arg0_71:updateResultPanel()
	arg0_71:closeSelectPanel()
end

function var0_0.onBackPressed(arg0_72)
	if isActive(arg0_72.selectPanelTF) then
		arg0_72:closeSelectPanel()
	else
		var0_0.super.onBackPressed(arg0_72)
	end
end

function var0_0.willExit(arg0_73)
	arg0_73.topPanel:Destroy()

	arg0_73.topPanel = nil

	arg0_73.resPanel:Destroy()

	arg0_73.resPanel = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_73.mainTF, arg0_73:findTF("anim_root"))
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_73.topTF, arg0_73:findTF("anim_root"))

	for iter0_73, iter1_73 in pairs(arg0_73.planCards) do
		iter1_73:dispose()
	end
end

return var0_0
