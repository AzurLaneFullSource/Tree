local var0_0 = class("NewEducateScheduleScene", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.PLAN_CNT = 5
var0_0.TALENT_CNT = 4

function var0_0.getUIName(arg0_1)
	return "NewEducateScheduleUI"
end

function var0_0.init(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.bgTF = arg0_2.rootTF:Find("bg")
	arg0_2.mainTF = arg0_2.rootTF:Find("main")
	arg0_2.leftTF = arg0_2.rootTF:Find("main/left")

	local var0_2 = arg0_2.leftTF:Find("title")

	arg0_2.titleRoundTF = var0_2:Find("round_container/title_round")

	setText(var0_2:Find("title_front"), i18n("child2_plan_title_front"))
	setText(var0_2:Find("title_back"), i18n("child2_plan_title_back"))

	arg0_2.targetTF = arg0_2.leftTF:Find("target")

	arg0_2:InitPlanView()

	arg0_2.planCountTF = arg0_2.leftTF:Find("cell_title/Text")

	local var1_2 = arg0_2.leftTF:Find("cells")
	local var2_2 = arg0_2.leftTF:Find("cell_tpl")

	setActive(var2_2, false)

	arg0_2.cells = {}

	for iter0_2 = 1, var0_0.PLAN_CNT do
		arg0_2.cells[iter0_2] = {
			tf = cloneTplTo(var2_2, var1_2, iter0_2)
		}
	end

	arg0_2.rightTF = arg0_2.rootTF:Find("main/right")
	arg0_2.effectTF = arg0_2.rightTF:Find("effect")
	arg0_2.moneyTF = arg0_2.rightTF:Find("money")
	arg0_2.moodTF = arg0_2.rightTF:Find("mood")

	setText(arg0_2.rightTF:Find("attr_title/Text"), i18n("child2_attr_title"))

	arg0_2.attrsTF = arg0_2.rightTF:Find("attrs")

	setText(arg0_2.rightTF:Find("talent_title/Text"), i18n("child2_talent_title"))

	arg0_2.talentsTF = arg0_2.rightTF:Find("talents")

	setText(arg0_2.rightTF:Find("status_title/Text"), i18n("child2_status_title"))

	arg0_2.statusTF = arg0_2.rightTF:Find("status")

	arg0_2:InitRightPanel()

	arg0_2.skipToggle = arg0_2.rightTF:Find("skip/skip_toggle")

	setText(arg0_2.rightTF:Find("skip/Text"), i18n("child_plan_skip"))

	arg0_2.skipToggleCom = arg0_2.skipToggle:GetComponent(typeof(Toggle))
	arg0_2.nextBtn = arg0_2.rightTF:Find("next")
end

function var0_0.GetSkipLocalKey(arg0_3)
	return NewEducateConst.NEW_EDUCATE_SKIP_PLANS_ANIM .. "_" .. arg0_3.playerID .. "_" .. arg0_3.contextData.char.id
end

function var0_0.SetData(arg0_4)
	arg0_4.playerID = getProxy(PlayerProxy):getRawData().id
	arg0_4.planList = arg0_4.contextData.char:GetPlanList()
	arg0_4.attrIds = arg0_4.contextData.char:GetAttrIds()
	arg0_4.talents = arg0_4.contextData.char:GetTalentList()
	arg0_4.status = arg0_4.contextData.char:GetStatusList()
	arg0_4.unlockPlanNum = arg0_4.contextData.char:GetRoundData():getConfig("plan_num")
	arg0_4.moneyResId = arg0_4.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.MONEY)
	arg0_4.moodResId = arg0_4.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.MOOD)
	arg0_4.selectedCellIdx = 1
	arg0_4.discountInfos = arg0_4.contextData.char:GetPlanDiscountInfos()
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_5.mainTF, {
		pbList = {
			arg0_5.mainTF:Find("bg")
		},
		groupName = LayerWeightConst.GROUP_EDUCATE
	})
	onButton(arg0_5, arg0_5.mainTF:Find("top/return_btn"), function()
		arg0_5:onBackPressed()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.skipToggle, function(arg0_7)
		PlayerPrefs.SetInt(arg0_5:GetSkipLocalKey(), arg0_7 and 1 or 0)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.nextBtn, function()
		local var0_8 = {}
		local var1_8 = ""
		local var2_8 = false

		if arg0_5.selectedCnt < arg0_5.unlockPlanNum then
			var1_8 = i18n("child2_schedule_sure_tip")
			var2_8 = true
		end

		if arg0_5.contextData.char:GetPoint() > 0 then
			var1_8 = var2_8 and i18n("child2_schedule_sure_tip3") or i18n("child2_schedule_sure_tip2")
		end

		table.insert(var0_8, function(arg0_9)
			if var1_8 ~= "" then
				arg0_5:emit(var0_0.ON_BOX, {
					content = var1_8,
					onYes = arg0_9
				})
			else
				arg0_9()
			end
		end)
		seriesAsync(var0_8, function()
			arg0_5:emit(NewEducateScheduleMediator.ON_SELECTED_PLANS, arg0_5.skipToggleCom.isOn, arg0_5.cells)
		end)
	end, SFX_PANEL)
	onScroll(arg0_5, arg0_5.statusTF, function(arg0_11)
		eachChild(arg0_5.statusUIList.container, function(arg0_12)
			triggerToggle(arg0_12, false)
		end)
	end)
	arg0_5:SetData()

	local var0_5 = PlayerPrefs.GetInt(arg0_5:GetSkipLocalKey())

	triggerToggle(arg0_5.skipToggle, var0_5 == 1)
	arg0_5:UpdateTitle()
	arg0_5:FlushPlanView()
	arg0_5:UpdateCells()
	arg0_5.talentUIList:align(var0_0.TALENT_CNT)
	arg0_5.statusUIList:align(#arg0_5.status)
	arg0_5:UpdateReuslt()
	arg0_5:CheckUpgradePlans()
end

function var0_0.CheckUpgradePlans(arg0_13)
	local var0_13 = underscore.select(arg0_13.planList, function(arg0_14)
		return arg0_14:GetNextId() and arg0_13.contextData.char:IsMatchComplex(arg0_14:getConfig("level_condition"))
	end)

	if #var0_13 > 0 then
		local var1_13 = {}

		underscore.select(var0_13, function(arg0_15)
			table.insert(var1_13, arg0_15.id)
		end)
		arg0_13:emit(NewEducateScheduleMediator.ON_UPGRADE_PLANS, var1_13)
	else
		NewEducateGuideSequence.CheckGuide(arg0_13.__cname)
	end
end

function var0_0.OnUpgradePlans(arg0_16)
	arg0_16.planList = getProxy(NewEducateProxy):GetCurChar():GetPlanList()

	arg0_16:FlushPlanView()
	NewEducateGuideSequence.CheckGuide(arg0_16.__cname)
end

function var0_0.InitPlanView(arg0_17)
	local var0_17 = arg0_17.leftTF:Find("plan_view/content")
	local var1_17 = var0_17:Find("tpl")

	setText(var1_17:Find("condition/Text"), i18n("child2_plan_upgrade_condition"))

	arg0_17.planUIList = UIItemList.New(var0_17, var1_17)

	arg0_17.planUIList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg0_17:UpdatePlan(arg1_18, arg2_18)
		end
	end)
end

function var0_0.InitRightPanel(arg0_19)
	arg0_19.attrUIList = UIItemList.New(arg0_19.attrsTF, arg0_19.attrsTF:Find("tpl"))

	arg0_19.attrUIList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventInit then
			local var0_20 = arg0_19.attrIds[arg1_20 + 1]
			local var1_20 = pg.child2_attr[var0_20]

			LoadImageSpriteAsync("neweducateicon/" .. var1_20.icon, arg2_20:Find("icon_bg/icon"))
			setScrollText(arg2_20:Find("name_mask/name"), var1_20.name)
		elseif arg0_20 == UIItemList.EventUpdate then
			arg0_19:UpdateAttr(arg1_20, arg2_20)
		end
	end)

	arg0_19.talentUIList = UIItemList.New(arg0_19.talentsTF, arg0_19.talentsTF:Find("tpl"))

	arg0_19.talentUIList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventInit then
			arg0_19:UpdateTalent(arg1_21, arg2_21)
		end
	end)

	local var0_19 = arg0_19.statusTF:Find("content/content")

	arg0_19.statusUIList = UIItemList.New(var0_19, var0_19:Find("tpl"))

	arg0_19.statusUIList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventInit then
			arg0_19:UpdateStatus(arg1_22, arg2_22)
		end
	end)
end

function var0_0.UpdateTitle(arg0_23)
	local var0_23, var1_23, var2_23 = arg0_23.contextData.char:GetRoundData():GetProgressInfo()

	setText(arg0_23.titleRoundTF, var0_23)
	setText(arg0_23.targetTF:Find("round"), i18n("child2_assess_round", var1_23))

	local var3_23 = arg0_23.contextData.char:GetAttrSum()

	setText(arg0_23.targetTF:Find("target"), i18n("child2_schedule_target", var3_23, var2_23))
	setText(arg0_23.targetTF:Find("value"), (var3_23 < var2_23 and setColorStr(var3_23, "#ff6767") or var3_23) .. "/" .. var2_23)

	local var4_23 = arg0_23.contextData.char:GetRoundData():getConfig("main_background")

	setImageSprite(arg0_23.bgTF, LoadSprite("bg/" .. var4_23), false)
end

function var0_0.UpdateCells(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.cells) do
		arg0_24:UpdateCell(iter0_24)
	end
end

function var0_0.UpdateCellReduce(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.cells) do
		local var0_25 = arg0_25.cells[iter0_25].tf

		setActive(var0_25:Find("unlock/reduce"), arg0_25.cells[iter0_25].plan and iter0_25 + 1 == arg0_25.selectedCellIdx)
	end
end

function var0_0.UpdateCell(arg0_26, arg1_26)
	local var0_26 = arg0_26.cells[arg1_26].tf
	local var1_26 = arg0_26.cells[arg1_26].plan

	var0_26.name = arg1_26

	local var2_26 = arg1_26 <= arg0_26.unlockPlanNum

	setActive(var0_26:Find("unlock"), var2_26)
	setActive(var0_26:Find("lock"), not var2_26)

	if var2_26 then
		setActive(var0_26:Find("unlock/arrows"), false)
		setActive(var0_26:Find("unlock/icon"), var1_26)
		setActive(var0_26:Find("unlock/reduce"), var1_26 and arg1_26 + 1 == arg0_26.selectedCellIdx)

		if var1_26 then
			LoadImageSpriteAsync("neweducateicon/" .. var1_26:getConfig("icon_square"), var0_26:Find("unlock/icon"))
		end
	end

	onButton(arg0_26, var0_26, function()
		if var1_26 and arg1_26 + 1 == arg0_26.selectedCellIdx then
			arg0_26.cells[arg1_26].plan = nil
			arg0_26.selectedCellIdx = math.max(arg0_26.selectedCellIdx - 1, 1)

			arg0_26:UpdateCell(arg1_26)
			arg0_26:UpdateCellReduce()
			arg0_26:UpdateReuslt()
		end
	end, SFX_PANEL)
end

function var0_0.UpdatePlan(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.showList[arg1_28 + 1]
	local var1_28 = var0_28:GetNextId()

	setText(arg2_28:Find("name"), var0_28:getConfig("name"))
	onButton(arg0_28, arg2_28, function()
		arg0_28:OnClickPlan(var0_28)
	end, SFX_PANEL)
	LoadImageSpriteAsync("neweducateicon/" .. var0_28:getConfig("icon_rectangle"), arg2_28:Find("icon"))

	local var2_28 = var0_28:GetCostShowInfos()
	local var3_28 = var0_28:GetCostWithBenefit(arg0_28.discountInfos)
	local var4_28 = UIItemList.New(arg2_28:Find("normal/cost"), arg2_28:Find("normal/cost/tpl"))

	var4_28:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = var2_28[arg1_30 + 1]

			NewEducateHelper.UpdateVectorItem(arg2_30, var0_30, "-")

			local var1_30 = var3_28[arg1_30 + 1]

			if var1_30.number ~= var0_30.number then
				local var2_30 = "(" .. var1_30.number .. ")"

				setText(arg2_30:Find("value"), "-" .. var0_30.number .. var2_30)
			end
		end
	end)
	var4_28:align(#var2_28)
	LoadImageSpriteAtlasAsync("ui/neweducatescheduleui_atlas", var0_28:GetAwardBg(), arg2_28:Find("normal/award"))

	local var5_28 = var0_28:GetAwardShowInfos()
	local var6_28 = UIItemList.New(arg2_28:Find("normal/award"), arg2_28:Find("normal/award/tpl"))

	var6_28:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var5_28[arg1_31 + 1]

			NewEducateHelper.UpdateVectorItem(arg2_31, var0_31, var0_31.number > 0 and "+" or "")
		end
	end)
	var6_28:align(#var5_28)
	setActive(arg2_28:Find("toggle"), var1_28)

	if var1_28 then
		local var7_28 = var0_28:getConfig("condition_desc")
		local var8_28 = UIItemList.New(arg2_28:Find("condition/conditions"), arg2_28:Find("condition/conditions/tpl"))

		var8_28:make(function(arg0_32, arg1_32, arg2_32)
			if arg0_32 == UIItemList.EventUpdate then
				local var0_32 = var7_28[arg1_32 + 1]
				local var1_32 = arg0_28.contextData.char:LogicalOperator({
					operator = "||",
					conditions = var0_32[1]
				})
				local var2_32 = var0_32[2]

				if not var1_32 then
					var2_32 = string.gsub(var2_32, "f7f7f7", "ff6767")
				end

				setText(arg2_32:Find("name"), var2_32)
				setActive(arg2_32:Find("icon"), false)
				setActive(arg2_32:Find("value"), false)
			end
		end)
		var8_28:align(#var7_28)
	end
end

function var0_0.OnClickPlan(arg0_33, arg1_33)
	if arg0_33.selectedCellIdx > arg0_33.unlockPlanNum then
		return
	end

	seriesAsync({
		function(arg0_34)
			local var0_34, var1_34, var2_34 = arg0_33:CalcPlanResult(arg1_33)

			if arg0_33.contextData.char:GetRes(arg0_33.moneyResId) + arg0_33.moneyResult + var0_34 < 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_plan_check_tip4"))

				return
			end

			arg0_34()
		end
	}, function()
		arg0_33.cells[arg0_33.selectedCellIdx].plan = arg1_33

		arg0_33:UpdateCell(arg0_33.selectedCellIdx)

		arg0_33.selectedCellIdx = arg0_33.selectedCellIdx + 1

		arg0_33:UpdateCellReduce()
		arg0_33:UpdateReuslt()
	end)
end

function var0_0.FlushPlanView(arg0_36)
	arg0_36.showList = underscore.select(arg0_36.planList, function(arg0_37)
		return arg0_37:IsShow()
	end)

	arg0_36.planUIList:align(#arg0_36.showList)
end

function var0_0.UpdateEffect(arg0_38, arg1_38)
	local var0_38 = arg0_38.contextData.char:GetMoodStage(arg1_38)

	setText(arg0_38.effectTF, string.gsub("$1", "$1", i18n("child2_mood_desc" .. var0_38)))
end

function var0_0.UpdateTalent(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.talents[arg1_39 + 1]

	setActive(arg2_39:Find("unlock"), var0_39)
	setActive(arg2_39:Find("lock"), not var0_39)
	setImageAlpha(arg2_39, var0_39 and 1 or 0.4)

	if var0_39 then
		LoadImageSpriteAsync("neweducateicon/" .. var0_39:getConfig("item_icon_little"), arg2_39:Find("unlock/icon"))
		setText(arg2_39:Find("unlock/name"), shortenString(var0_39:getConfig("name"), 5))
		setText(arg2_39:Find("unlock/info/content/name"), var0_39:getConfig("name"))
		setText(arg2_39:Find("unlock/info/content/desc"), var0_39:getConfig("desc"))
	end
end

function var0_0.UpdateStatus(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.status[arg1_40 + 1]

	LoadImageSpriteAsync("neweducateicon/" .. var0_40:getConfig("item_icon"), arg2_40:Find("icon"))

	local var1_40 = var0_40:getConfig("during_time")
	local var2_40 = var0_40:GetEndRound() - arg0_40.contextData.char:GetRoundData().round
	local var3_40 = var1_40 == -1 and i18n("child2_status_time2") or i18n("child2_status_time1", var2_40)

	setText(arg2_40:Find("time/Text"), var3_40)
	setText(arg2_40:Find("info/content/name"), var0_40:getConfig("name"))
	setText(arg2_40:Find("info/content/desc"), var0_40:getConfig("desc"))
end

function var0_0.CalcPlanResult(arg0_41, arg1_41)
	local var0_41 = 0
	local var1_41 = 0

	underscore.each(arg1_41:GetCostWithBenefit(arg0_41.discountInfos), function(arg0_42)
		switch(arg0_42.type, {
			[NewEducateConst.DROP_TYPE.RES] = function()
				if arg0_42.id == arg0_41.moneyResId then
					var0_41 = var0_41 + arg0_42.number
				elseif arg0_42.id == arg0_41.moodResId then
					var1_41 = var1_41 + arg0_42.number
				end
			end
		})
	end)

	local var2_41 = 0
	local var3_41 = 0
	local var4_41 = {}

	underscore.each(arg1_41:GetAwardShowInfos(), function(arg0_44)
		switch(arg0_44.type, {
			[NewEducateConst.DROP_TYPE.RES] = function()
				if arg0_44.id == arg0_41.moneyResId then
					var2_41 = var2_41 + arg0_44.number
				elseif arg0_44.id == arg0_41.moodResId then
					var3_41 = var3_41 + arg0_44.number
				end
			end,
			[NewEducateConst.DROP_TYPE.ATTR] = function()
				if not var4_41[arg0_44.id] then
					var4_41[arg0_44.id] = 0
				end

				var4_41[arg0_44.id] = var4_41[arg0_44.id] + arg0_44.number
			end
		})
	end)

	return var2_41 - var0_41, var3_41 - var1_41, var4_41
end

function var0_0.CalcCurResult(arg0_47)
	arg0_47.attrResult = {}
	arg0_47.moneyResult = 0
	arg0_47.moodResult = 0

	underscore.each(arg0_47.cells, function(arg0_48)
		if arg0_48.plan then
			local var0_48, var1_48, var2_48 = arg0_47:CalcPlanResult(arg0_48.plan)

			arg0_47.moneyResult = arg0_47.moneyResult + var0_48
			arg0_47.moodResult = arg0_47.moodResult + var1_48

			for iter0_48, iter1_48 in pairs(var2_48) do
				if not arg0_47.attrResult[iter0_48] then
					arg0_47.attrResult[iter0_48] = 0
				end

				arg0_47.attrResult[iter0_48] = arg0_47.attrResult[iter0_48] + iter1_48
			end
		end
	end)
end

function var0_0.GetColor(arg0_49, arg1_49)
	if arg1_49 == 0 then
		return "ffffff"
	else
		return arg1_49 > 0 and "2df7bc" or "ff6767"
	end
end

function var0_0.UpdateAttr(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.attrIds[arg1_50 + 1]
	local var1_50 = arg0_50.contextData.char:GetAttr(var0_50)
	local var2_50, var3_50 = NewEducateInfoPanel.GetArrtInfo(pg.child2_attr[var0_50].rank, var1_50)

	setText(arg2_50:Find("rank/Text"), var2_50)
	setImageColor(arg2_50:Find("rank"), Color.NewHex(EducateConst.GRADE_2_COLOR[var2_50][2]))
	setText(arg2_50:Find("before_value"), var1_50)

	local var4_50 = arg0_50.attrResult[var0_50] or 0

	setText(arg2_50:Find("after_value"), var1_50 + var4_50)

	local var5_50 = arg0_50:GetColor(var4_50)

	setImageColor(arg2_50:Find("arrow"), Color.NewHex(var5_50))
	setTextColor(arg2_50:Find("after_value"), Color.NewHex(var5_50))
end

function var0_0.UpdateReuslt(arg0_51)
	arg0_51.selectedCnt = underscore.reduce(arg0_51.cells, 0, function(arg0_52, arg1_52)
		return arg0_52 + (arg1_52.plan and 1 or 0)
	end)

	setText(arg0_51.planCountTF, arg0_51.selectedCnt .. "/" .. arg0_51.unlockPlanNum)
	arg0_51:CalcCurResult()

	local var0_51 = arg0_51.contextData.char:GetRes(arg0_51.moneyResId)

	setText(arg0_51.moneyTF:Find("before_value"), var0_51)
	setText(arg0_51.moneyTF:Find("after_value"), var0_51 + arg0_51.moneyResult)

	local var1_51 = arg0_51:GetColor(arg0_51.moneyResult)

	setImageColor(arg0_51.moneyTF:Find("arrow"), Color.NewHex(var1_51))
	setTextColor(arg0_51.moneyTF:Find("after_value"), Color.NewHex(var1_51))

	local var2_51 = arg0_51.contextData.char:GetRes(arg0_51.moodResId)

	setText(arg0_51.moodTF:Find("before_value"), var2_51)

	local var3_51 = var2_51 + arg0_51.moodResult
	local var4_51 = math.max(pg.child_resource[arg0_51.moodResId].min_value, var3_51)
	local var5_51 = math.min(pg.child_resource[arg0_51.moodResId].max_value, var4_51)

	setText(arg0_51.moodTF:Find("after_value"), var5_51)

	local var6_51 = arg0_51:GetColor(arg0_51.moodResult)

	setImageColor(arg0_51.moodTF:Find("arrow"), Color.NewHex(var6_51))
	setTextColor(arg0_51.moodTF:Find("after_value"), Color.NewHex(var6_51))
	arg0_51:UpdateEffect(var5_51)
	arg0_51.attrUIList:align(#arg0_51.attrIds)
end

function var0_0.SetScheduleData(arg0_53, arg1_53)
	arg0_53.contextData.scheduleDataTable.OnScheduleDone = arg1_53
end

function var0_0.willExit(arg0_54)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54.mainTF, arg0_54.rootTF)
end

return var0_0
