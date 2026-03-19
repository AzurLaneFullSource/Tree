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

	setText(arg0_2.rightTF:Find("attrs/attr_title/Text"), i18n("child2_attr_title"))

	arg0_2.attrsTF = arg0_2.rightTF:Find("attrs/attrs")

	setText(arg0_2.rightTF:Find("talent/talent_title/Text"), i18n("child2_talent_title"))

	arg0_2.talentsTF = arg0_2.rightTF:Find("talent/talents")
	arg0_2.statusTF = arg0_2.rightTF:Find("status")

	setText(arg0_2.statusTF:Find("status_title/Text"), i18n("child2_status_title"))

	arg0_2.tarotTF = arg0_2.rightTF:Find("tarot")

	setText(arg0_2.tarotTF:Find("title/Text"), i18n("child2_tarot_title"))

	arg0_2.tarotIconTF = arg0_2.tarotTF:Find("bg/icon")
	arg0_2.tarotNameTF = arg0_2.tarotTF:Find("bg/name")
	arg0_2.tarotEntryTF = arg0_2.tarotTF:Find("bg/entry")

	arg0_2:InitRightPanel()

	arg0_2.skipToggle = arg0_2.rightTF:Find("skip/skip_toggle")

	setText(arg0_2.rightTF:Find("skip/Text"), i18n("child_plan_skip"))

	arg0_2.skipToggleCom = arg0_2.skipToggle:GetComponent(typeof(Toggle))
	arg0_2.nextBtn = arg0_2.rightTF:Find("next")
	arg0_2.nextTempBtn = arg0_2.rightTF:Find("next_temp")
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
	arg0_5:OverlayPanel(arg0_5.mainTF, {
		pbList = {
			arg0_5.mainTF:Find("bg")
		}
	})
	onButton(arg0_5, arg0_5.mainTF:Find("top/return_btn"), function()
		arg0_5:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.tarotTF:Find("bg"), function()
		arg0_5:emit(var0_0.GO_SUBLAYER, Context.New({
			mediator = NewEducateTarotEntryMediator,
			viewComponent = NewEducateTarotEntryLayer
		}))
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.skipToggle, function(arg0_8)
		PlayerPrefs.SetInt(arg0_5:GetSkipLocalKey(), arg0_8 and 1 or 0)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.nextBtn, function()
		arg0_5:OnClickNextBtn()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.nextTempBtn, function()
		arg0_5:OnClickNextBtn()
	end, SFX_PANEL)
	onScroll(arg0_5, arg0_5.statusTF:Find("status"), function(arg0_11)
		eachChild(arg0_5.statusUIList.container, function(arg0_12)
			triggerToggle(arg0_12, false)
		end)
	end)
	arg0_5:SetData()
	setActive(arg0_5.nextTempBtn, arg0_5.contextData.char:GetRoundData():NextIsTemp())

	local var0_5 = PlayerPrefs.GetInt(arg0_5:GetSkipLocalKey())

	triggerToggle(arg0_5.skipToggle, var0_5 == 1)
	arg0_5:UpdateTitle()
	arg0_5:FlushPlanView()
	arg0_5:UpdateCells()

	arg0_5.isTarotChar = arg0_5.contextData.char:GetPermanentData():IsTarotType()

	setActive(arg0_5.tarotTF, arg0_5.isTarotChar)
	setActive(arg0_5.statusTF, not arg0_5.isTarotChar)
	arg0_5:FlushTarot()

	arg0_5.talentRoundIds = arg0_5.contextData.char:GetRoundData():GetTalentRoundIds()

	arg0_5.talentUIList:align(#arg0_5.talentRoundIds)
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
			setToggleEnabled(arg2_20, arg0_19.isTarotChar)

			if arg0_19.isTarotChar then
				setText(arg2_20:Find("info/content/name"), var1_20.name)

				local var2_20 = arg0_19.contextData.char:GetAttr(var0_20)
				local var3_20, var4_20 = NewEducateInfoPanel.GetArrtInfo(var1_20.rank, var2_20)

				setText(arg2_20:Find("info/content/value"), var4_20)

				local var5_20, var6_20 = arg0_19.contextData.char:GetBenefitData():GetDisplayPctByDrop({
					type = NewEducateConst.DROP_TYPE.ATTR,
					id = var0_20
				})
				local var7_20 = i18n("child2_benefit_summary") .. var5_20 .. "%" .. "\n" .. i18n("child2_benefit_summary2") .. var6_20 .. "%"

				setText(arg2_20:Find("info/content/desc"), var7_20)
			end
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

	local var0_19 = arg0_19.statusTF:Find("status/content/content")

	arg0_19.statusUIList = UIItemList.New(var0_19, var0_19:Find("tpl"))

	arg0_19.statusUIList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventInit then
			arg0_19:UpdateStatus(arg1_22, arg2_22)
		end
	end)
end

function var0_0.UpdateTitle(arg0_23)
	if arg0_23.contextData.char:GetRoundData():IsEndless() then
		arg0_23:UpdateEndlessTitle()
	else
		arg0_23:UpdateNormalTitle()
	end

	local var0_23 = arg0_23.contextData.char:GetRoundData():getConfig("main_background")

	setImageSprite(arg0_23.bgTF, LoadSprite("bg/" .. var0_23), false)
end

function var0_0.UpdateNormalTitle(arg0_24)
	local var0_24, var1_24, var2_24 = arg0_24.contextData.char:GetRoundData():GetProgressInfo()

	setText(arg0_24.titleRoundTF, var0_24)
	setText(arg0_24.targetTF:Find("round"), i18n("child2_assess_round", var1_24))

	local var3_24 = arg0_24.contextData.char:GetAttrSum()

	setText(arg0_24.targetTF:Find("target"), i18n("child2_schedule_target", var3_24, var2_24))
	setText(arg0_24.targetTF:Find("value"), (var3_24 < var2_24 and setColorStr(var3_24, "#ff6767") or var3_24) .. "/" .. var2_24)
end

function var0_0.UpdateEndlessTitle(arg0_25)
	local var0_25, var1_25, var2_25 = arg0_25.contextData.char:GetRoundData():GetEndlessProgressInfos()

	setText(arg0_25.titleRoundTF, var0_25)
	setText(arg0_25.targetTF:Find("round"), i18n("child2_assess_round", 0))

	local var3_25 = arg0_25.contextData.char:GetAttrSum()

	setText(arg0_25.targetTF:Find("target"), i18n("child2_schedule_target", var3_25, var2_25))
	setText(arg0_25.targetTF:Find("value"), (var3_25 < var2_25 and setColorStr(var3_25, "#ff6767") or var3_25) .. "/" .. var2_25)
end

function var0_0.UpdateCells(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.cells) do
		arg0_26:UpdateCell(iter0_26)
	end
end

function var0_0.UpdateCellReduce(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.cells) do
		local var0_27 = arg0_27.cells[iter0_27].tf

		setActive(var0_27:Find("unlock/reduce"), arg0_27.cells[iter0_27].plan and iter0_27 + 1 == arg0_27.selectedCellIdx)
	end
end

function var0_0.UpdateCell(arg0_28, arg1_28)
	local var0_28 = arg0_28.cells[arg1_28].tf
	local var1_28 = arg0_28.cells[arg1_28].plan

	var0_28.name = arg1_28

	local var2_28 = arg1_28 <= arg0_28.unlockPlanNum

	setActive(var0_28:Find("unlock"), var2_28)
	setActive(var0_28:Find("lock"), not var2_28)

	if var2_28 then
		setActive(var0_28:Find("unlock/arrows"), false)
		setActive(var0_28:Find("unlock/icon"), var1_28)
		setActive(var0_28:Find("unlock/reduce"), var1_28 and arg1_28 + 1 == arg0_28.selectedCellIdx)

		if var1_28 then
			LoadImageSpriteAsync("neweducateicon/" .. var1_28:getConfig("icon_square"), var0_28:Find("unlock/icon"))
		end
	end

	onButton(arg0_28, var0_28, function()
		if var1_28 and arg1_28 + 1 == arg0_28.selectedCellIdx then
			arg0_28.cells[arg1_28].plan = nil
			arg0_28.selectedCellIdx = math.max(arg0_28.selectedCellIdx - 1, 1)

			arg0_28:UpdateCell(arg1_28)
			arg0_28:UpdateCellReduce()
			arg0_28:UpdateReuslt()
		end
	end, SFX_PANEL)
end

function var0_0.UpdatePlan(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.showList[arg1_30 + 1]
	local var1_30 = var0_30:GetNextId()

	setText(arg2_30:Find("name"), var0_30:getConfig("name"))
	onButton(arg0_30, arg2_30, function()
		arg0_30:OnClickPlan(var0_30)
	end, SFX_PANEL)
	LoadImageSpriteAsync("neweducateicon/" .. var0_30:getConfig("icon_rectangle"), arg2_30:Find("icon"))

	local var2_30 = var0_30:GetCostShowInfos()
	local var3_30 = var0_30:GetCostWithBenefit(arg0_30.discountInfos)
	local var4_30 = UIItemList.New(arg2_30:Find("normal/cost"), arg2_30:Find("normal/cost/tpl"))

	var4_30:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var2_30[arg1_32 + 1]

			NewEducateHelper.UpdateVectorItem(arg2_32, var0_32, "-")

			local var1_32 = var3_30[arg1_32 + 1]

			if var1_32.number ~= var0_32.number then
				local var2_32 = "(" .. var1_32.number .. ")"

				setText(arg2_32:Find("value"), "-" .. var0_32.number .. var2_32)
			end
		end
	end)
	var4_30:align(#var2_30)
	LoadImageSpriteAtlasAsync("ui/neweducatescheduleui_atlas", var0_30:GetAwardBg(), arg2_30:Find("normal/award"))

	local var5_30 = var0_30:GetAwardShowInfos()
	local var6_30 = UIItemList.New(arg2_30:Find("normal/award"), arg2_30:Find("normal/award/tpl"))

	var6_30:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var5_30[arg1_33 + 1]

			NewEducateHelper.UpdateVectorItem(arg2_33, var0_33, var0_33.number > 0 and "+" or "")
		end
	end)
	var6_30:align(#var5_30)
	setActive(arg2_30:Find("toggle"), var1_30)

	if var1_30 then
		local var7_30 = var0_30:getConfig("condition_desc")
		local var8_30 = UIItemList.New(arg2_30:Find("condition/conditions"), arg2_30:Find("condition/conditions/tpl"))

		var8_30:make(function(arg0_34, arg1_34, arg2_34)
			if arg0_34 == UIItemList.EventUpdate then
				local var0_34 = var7_30[arg1_34 + 1]
				local var1_34 = arg0_30.contextData.char:LogicalOperator({
					operator = "||",
					conditions = var0_34[1]
				})
				local var2_34 = var0_34[2]

				if not var1_34 then
					var2_34 = string.gsub(var2_34, "f7f7f7", "ff6767")
				end

				setText(arg2_34:Find("name"), var2_34)
				setActive(arg2_34:Find("icon"), false)
				setActive(arg2_34:Find("value"), false)
			end
		end)
		var8_30:align(#var7_30)
	end
end

function var0_0.OnClickPlan(arg0_35, arg1_35)
	if arg0_35.selectedCellIdx > arg0_35.unlockPlanNum then
		return
	end

	seriesAsync({
		function(arg0_36)
			local var0_36, var1_36, var2_36 = arg0_35:CalcPlanResult(arg1_35)

			if arg0_35.contextData.char:GetRes(arg0_35.moneyResId) + arg0_35.moneyResult + var0_36 < 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("child_plan_check_tip4"))

				return
			end

			arg0_36()
		end
	}, function()
		arg0_35.cells[arg0_35.selectedCellIdx].plan = arg1_35

		arg0_35:UpdateCell(arg0_35.selectedCellIdx)

		arg0_35.selectedCellIdx = arg0_35.selectedCellIdx + 1

		arg0_35:UpdateCellReduce()
		arg0_35:UpdateReuslt()
	end)
end

function var0_0.FlushPlanView(arg0_38)
	arg0_38.showList = underscore.select(arg0_38.planList, function(arg0_39)
		return arg0_39:IsShow()
	end)

	arg0_38.planUIList:align(#arg0_38.showList)
end

function var0_0.FlushTarot(arg0_40)
	arg0_40.tarotId = arg0_40.contextData.char:GetTarotId()

	setActive(arg0_40.tarotIconTF, arg0_40.tarotId)

	if arg0_40.tarotId then
		LoadImageSpriteAsync("neweducateicon/" .. pg.child2_benefit_list[arg0_40.tarotId].item_icon_little, arg0_40.tarotIconTF)
	end

	setText(arg0_40.tarotNameTF, arg0_40.tarotId and pg.child2_benefit_list[arg0_40.tarotId].name or "EMPTY")

	arg0_40.entries = arg0_40.contextData.char:GetBenefitData():GetListByType(NewEducateBuff.TYPE.ENTRY)

	setText(arg0_40.tarotEntryTF, i18n("child2_entry_summary") .. #arg0_40.entries)
end

function var0_0.UpdateEffect(arg0_41, arg1_41)
	local var0_41 = arg0_41.contextData.char:GetMoodStage(arg1_41)

	setText(arg0_41.effectTF, string.gsub("$1", "$1", i18n("child2_mood_desc" .. var0_41)))
end

function var0_0.UpdateTalent(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.talents[arg1_42 + 1]

	setActive(arg2_42:Find("unlock"), var0_42)
	setActive(arg2_42:Find("lock"), not var0_42)
	setImageAlpha(arg2_42, var0_42 and 1 or 0.4)

	if var0_42 then
		LoadImageSpriteAsync("neweducateicon/" .. var0_42:getConfig("item_icon_little"), arg2_42:Find("unlock/icon"))
		setText(arg2_42:Find("unlock/name"), shortenString(var0_42:getConfig("name"), 5))
		setText(arg2_42:Find("unlock/info/content/name"), var0_42:getConfig("name"))
		setText(arg2_42:Find("unlock/info/content/desc"), var0_42:getConfig("desc"))
	end
end

function var0_0.UpdateStatus(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.status[arg1_43 + 1]

	LoadImageSpriteAsync("neweducateicon/" .. var0_43:getConfig("item_icon"), arg2_43:Find("icon"))

	local var1_43 = var0_43:getConfig("during_time")
	local var2_43 = var0_43:GetEndRound() - arg0_43.contextData.char:GetRoundData().round
	local var3_43 = var1_43 == -1 and i18n("child2_status_time2") or i18n("child2_status_time1", var2_43)

	setText(arg2_43:Find("time/Text"), var3_43)
	setText(arg2_43:Find("info/content/name"), var0_43:getConfig("name"))
	setText(arg2_43:Find("info/content/desc"), var0_43:getConfig("desc"))
end

function var0_0.CalcPlanResult(arg0_44, arg1_44)
	local var0_44 = 0
	local var1_44 = 0

	underscore.each(arg1_44:GetCostWithBenefit(arg0_44.discountInfos), function(arg0_45)
		switch(arg0_45.type, {
			[NewEducateConst.DROP_TYPE.RES] = function()
				if arg0_45.id == arg0_44.moneyResId then
					var0_44 = var0_44 + arg0_45.number
				elseif arg0_45.id == arg0_44.moodResId then
					var1_44 = var1_44 + arg0_45.number
				end
			end
		})
	end)

	local var2_44 = 0
	local var3_44 = 0
	local var4_44 = {}

	underscore.each(arg1_44:GetAwardShowInfos(), function(arg0_47)
		switch(arg0_47.type, {
			[NewEducateConst.DROP_TYPE.RES] = function()
				if arg0_47.id == arg0_44.moneyResId then
					var2_44 = var2_44 + arg0_47.number
				elseif arg0_47.id == arg0_44.moodResId then
					var3_44 = var3_44 + arg0_47.number
				end
			end,
			[NewEducateConst.DROP_TYPE.ATTR] = function()
				if not var4_44[arg0_47.id] then
					var4_44[arg0_47.id] = 0
				end

				var4_44[arg0_47.id] = var4_44[arg0_47.id] + arg0_47.number
			end
		})
	end)

	return var2_44 - var0_44, var3_44 - var1_44, var4_44
end

function var0_0.CalcCurResult(arg0_50)
	arg0_50.attrResult = {}
	arg0_50.moneyResult = 0
	arg0_50.moodResult = 0

	underscore.each(arg0_50.cells, function(arg0_51)
		if arg0_51.plan then
			local var0_51, var1_51, var2_51 = arg0_50:CalcPlanResult(arg0_51.plan)

			arg0_50.moneyResult = arg0_50.moneyResult + var0_51
			arg0_50.moodResult = arg0_50.moodResult + var1_51

			for iter0_51, iter1_51 in pairs(var2_51) do
				if not arg0_50.attrResult[iter0_51] then
					arg0_50.attrResult[iter0_51] = 0
				end

				arg0_50.attrResult[iter0_51] = arg0_50.attrResult[iter0_51] + iter1_51
			end
		end
	end)
end

function var0_0.GetColor(arg0_52, arg1_52)
	if arg1_52 == 0 then
		return "ffffff"
	else
		return arg1_52 > 0 and "2df7bc" or "ff6767"
	end
end

function var0_0.UpdateAttr(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53.attrIds[arg1_53 + 1]
	local var1_53 = arg0_53.contextData.char:GetAttr(var0_53)
	local var2_53, var3_53 = NewEducateInfoPanel.GetArrtInfo(pg.child2_attr[var0_53].rank, var1_53)

	setText(arg2_53:Find("rank/Text"), var2_53)
	setImageColor(arg2_53:Find("rank"), Color.NewHex(EducateConst.GRADE_2_COLOR[var2_53][2]))
	setText(arg2_53:Find("before_value"), var1_53)

	local var4_53 = arg0_53.attrResult[var0_53] or 0

	setText(arg2_53:Find("after_value"), var1_53 + var4_53)

	local var5_53 = arg0_53:GetColor(var4_53)

	setImageColor(arg2_53:Find("arrow"), Color.NewHex(var5_53))
	setTextColor(arg2_53:Find("after_value"), Color.NewHex(var5_53))
end

function var0_0.UpdateReuslt(arg0_54)
	arg0_54.selectedCnt = underscore.reduce(arg0_54.cells, 0, function(arg0_55, arg1_55)
		return arg0_55 + (arg1_55.plan and 1 or 0)
	end)

	setText(arg0_54.planCountTF, arg0_54.selectedCnt .. "/" .. arg0_54.unlockPlanNum)
	arg0_54:CalcCurResult()

	local var0_54 = arg0_54.contextData.char:GetRes(arg0_54.moneyResId)

	setText(arg0_54.moneyTF:Find("before_value"), var0_54)
	setText(arg0_54.moneyTF:Find("after_value"), var0_54 + arg0_54.moneyResult)

	local var1_54 = arg0_54:GetColor(arg0_54.moneyResult)

	setImageColor(arg0_54.moneyTF:Find("arrow"), Color.NewHex(var1_54))
	setTextColor(arg0_54.moneyTF:Find("after_value"), Color.NewHex(var1_54))

	local var2_54 = arg0_54.contextData.char:GetRes(arg0_54.moodResId)

	setText(arg0_54.moodTF:Find("before_value"), var2_54)

	local var3_54 = var2_54 + arg0_54.moodResult
	local var4_54 = math.max(pg.child2_resource[arg0_54.moodResId].min_value, var3_54)
	local var5_54 = math.min(pg.child2_resource[arg0_54.moodResId].max_value, var4_54)

	setText(arg0_54.moodTF:Find("after_value"), var5_54)

	local var6_54 = arg0_54:GetColor(arg0_54.moodResult)

	setImageColor(arg0_54.moodTF:Find("arrow"), Color.NewHex(var6_54))
	setTextColor(arg0_54.moodTF:Find("after_value"), Color.NewHex(var6_54))
	arg0_54:UpdateEffect(var5_54)
	arg0_54.attrUIList:align(#arg0_54.attrIds)
end

function var0_0.SetScheduleData(arg0_56, arg1_56)
	arg0_56.contextData.scheduleDataTable.OnScheduleDone = arg1_56
end

function var0_0.OnClickNextBtn(arg0_57)
	local var0_57 = {}
	local var1_57 = ""
	local var2_57 = false

	if arg0_57.selectedCnt < arg0_57.unlockPlanNum then
		var1_57 = i18n("child2_schedule_sure_tip")
		var2_57 = true
	end

	if arg0_57.contextData.char:GetPoint() > 0 then
		var1_57 = var2_57 and i18n("child2_schedule_sure_tip3") or i18n("child2_schedule_sure_tip2")
	end

	table.insert(var0_57, function(arg0_58)
		if var1_57 ~= "" then
			arg0_57:emit(var0_0.ON_BOX, {
				content = var1_57,
				onYes = arg0_58
			})
		else
			arg0_58()
		end
	end)
	seriesAsync(var0_57, function()
		arg0_57:emit(NewEducateScheduleMediator.ON_SELECTED_PLANS, arg0_57.skipToggleCom.isOn, arg0_57.cells)
	end)
end

function var0_0.willExit(arg0_60)
	arg0_60:UnOverlayPanel(arg0_60.mainTF, arg0_60.rootTF)
end

return var0_0
