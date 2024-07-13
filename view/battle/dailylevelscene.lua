local var0_0 = class("DailyLevelScene", import("..base.BaseUI"))
local var1_0 = 3
local var2_0 = 4
local var3_0 = 101

function var0_0.getUIName(arg0_1)
	return "dailylevelui"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3.blurPanel = arg0_3:findTF("blur_panel")
	arg0_3.topPanel = arg0_3:findTF("blur_panel/adapt/top")
	arg0_3.backBtn = arg0_3:findTF("back_button", arg0_3.topPanel)
	arg0_3.listPanel = arg0_3:findTF("list_panel")
	arg0_3.content = arg0_3:findTF("list", arg0_3.listPanel)

	setActive(arg0_3.content, true)

	arg0_3.dailylevelTpl = arg0_3:getTpl("list_panel/list/captertpl")
	arg0_3.descPanel = arg0_3:findTF("desc_panel")
	arg0_3.selectedPanel = arg0_3.descPanel:Find("selected")
	arg0_3.descMain = arg0_3:findTF("main_mask/main", arg0_3.descPanel)
	arg0_3.stageTpl = arg0_3:getTpl("scrollview/content/stagetpl", arg0_3.descMain)
	arg0_3.stageScrollRect = arg0_3:findTF("scrollview", arg0_3.descMain):GetComponent(typeof(ScrollRect))
	arg0_3.stageContain = arg0_3:findTF("scrollview/content", arg0_3.descMain)
	arg0_3.arrows = arg0_3:findTF("arrows")
	arg0_3.itemTpl = arg0_3:getTpl("item_tpl")
	arg0_3.selStageTF = arg0_3.selectedPanel:Find("stagetpl/info")
	arg0_3.selQuicklyTF = arg0_3.selStageTF.parent:Find("quickly/bg")
	arg0_3.selQuicklyTFSizeDeltaY = arg0_3.selQuicklyTF.sizeDelta.y
	arg0_3.descChallengeNum = arg0_3:findTF("challenge_count", arg0_3.descMain)
	arg0_3.descChallengeText = arg0_3:findTF("Text", arg0_3.descChallengeNum)
	arg0_3.challengeQuotaDaily = arg0_3:findTF("challenge_count/label", arg0_3.descMain)
	arg0_3.challengeQuotaWeekly = arg0_3:findTF("challenge_count/week_label", arg0_3.descMain)
	arg0_3.fleetEditView = arg0_3:findTF("fleet_edit")
	arg0_3.resource = arg0_3:findTF("resource")
	arg0_3.rightBtn = arg0_3:findTF("arrows/arrow1")
	arg0_3.leftBtn = arg0_3:findTF("arrows/arrow2")

	arg0_3:initItems()
end

function var0_0.getWeek()
	return (pg.TimeMgr.GetInstance():GetServerWeek())
end

function var0_0.setDailyCounts(arg0_5, arg1_5)
	arg0_5.dailyCounts = arg1_5
end

function var0_0.setShips(arg0_6, arg1_6)
	arg0_6.shipVOs = arg1_6
end

function var0_0.updateRes(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8:findTF("help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_daily_task.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.backBtn, function()
		if arg0_8.descMode then
			if LeanTween.isTweening(go(arg0_8.stageContain)) or LeanTween.isTweening(go(arg0_8.selQuicklyTF)) then
				return
			end

			arg0_8:enableDescMode(false)
		else
			arg0_8:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.leftBtn, function()
		arg0_8:flipToSpecificCard(arg0_8:getNextCardId(true))
	end)
	onButton(arg0_8, arg0_8.rightBtn, function()
		arg0_8:flipToSpecificCard(arg0_8:getNextCardId(false))
	end)
	arg0_8:displayDailyLevels()

	if arg0_8.contextData.dailyLevelId then
		arg0_8:tryOpenDesc(arg0_8.contextData.dailyLevelId)
	else
		arg0_8:enableDescMode(false)
	end

	arg0_8:tryPlayGuide()
	arg0_8:ShowGuildTaskTip()
end

function var0_0.initItems(arg0_13)
	local var0_13 = getProxy(DailyLevelProxy)

	var0_13:setDailyTip(false)

	arg0_13.dailyCounts = var0_13:getRawData()

	local var1_13 = pg.expedition_daily_template

	arg0_13.dailyLevelTFs = {}
	arg0_13.dailyList = _.reverse(Clone(var1_13.all))

	for iter0_13 = #arg0_13.dailyList, 1, -1 do
		local var2_13 = var1_13[arg0_13.dailyList[iter0_13]].limit_period
		local var3_13 = var1_13[arg0_13.dailyList[iter0_13]].insert_daily

		if var2_13 and type(var2_13) == "table" then
			if not pg.TimeMgr:GetInstance():inTime(var2_13) then
				table.remove(arg0_13.dailyList, iter0_13)
			end
		elseif var3_13 == 1 then
			table.remove(arg0_13.dailyList, iter0_13)
		end
	end

	arg0_13:sortDailyList()
	arg0_13:updateShowCenter()

	if arg0_13.contextData.dailyLevelId then
		local var4_13 = arg0_13.contextData.dailyLevelId

		table.removebyvalue(arg0_13.dailyList, var4_13)
		table.insert(arg0_13.dailyList, math.ceil(#var1_13.all / 2), var4_13)
	end

	for iter1_13, iter2_13 in pairs(arg0_13.dailyList) do
		arg0_13.dailyLevelTFs[iter2_13] = cloneTplTo(arg0_13.dailylevelTpl, arg0_13.content, iter2_13)
	end
end

function var0_0.sortDailyList(arg0_14)
	if #arg0_14.dailyList % 2 ~= 1 then
		table.insert(arg0_14.dailyList, var3_0)
	end

	table.sort(arg0_14.dailyList, function(arg0_15, arg1_15)
		return tonumber(pg.expedition_daily_template[arg0_15].sort) > tonumber(pg.expedition_daily_template[arg1_15].sort)
	end)
end

function var0_0.updateShowCenter(arg0_16)
	if not arg0_16.dailyList or #arg0_16.dailyList == 0 then
		return
	end

	local var0_16 = #arg0_16.dailyList
	local var1_16 = pg.expedition_daily_template
	local var2_16 = math.ceil(var0_16 / 2)
	local var3_16

	for iter0_16 = 1, var0_16 do
		local var4_16 = var1_16[arg0_16.dailyList[iter0_16]]

		if var4_16.show_with_count and var4_16.show_with_count == 1 then
			local var5_16 = var4_16.id
			local var6_16 = arg0_16.dailyCounts and arg0_16.dailyCounts[var5_16] or 0

			if var4_16.limit_time - var6_16 > 0 then
				var3_16 = var3_16 or iter0_16
			end
		end
	end

	if var3_16 then
		local var7_16 = var2_16 - var3_16 < 0 and true or false
		local var8_16 = math.abs(var2_16 - var3_16)

		for iter1_16 = 1, var8_16 do
			local var9_16

			if var7_16 then
				local var10_16 = table.remove(arg0_16.dailyList, 1)

				table.insert(arg0_16.dailyList, var10_16)
			else
				local var11_16 = table.remove(arg0_16.dailyList, #arg0_16.dailyList)

				table.insert(arg0_16.dailyList, 1, var11_16)
			end
		end
	end
end

function var0_0.displayDailyLevels(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.dailyLevelTFs) do
		arg0_17:initDailyLevel(iter0_17)
	end

	arg0_17.content:GetComponent(typeof(EnhancelScrollView)).onCenterClick = function(arg0_18)
		arg0_17:tryOpenDesc(tonumber(arg0_18.name))
	end
	arg0_17.centerAniItem = nil
	arg0_17.centerCardId = nil
	arg0_17.checkAniTimer = Timer.New(function()
		if not arg0_17.descMode then
			local var0_19
			local var1_19

			for iter0_19, iter1_19 in pairs(arg0_17.dailyLevelTFs) do
				GetComponent(iter1_19, typeof(CanvasGroup)).alpha = 1

				if not var0_19 and not var1_19 then
					var0_19 = iter1_19
					var1_19 = iter1_19
				elseif iter1_19.anchoredPosition.x < var0_19.anchoredPosition.x then
					var0_19 = iter1_19
				elseif iter1_19.anchoredPosition.x > var1_19.anchoredPosition.x then
					var1_19 = iter1_19
				end
			end

			GetComponent(var0_19, typeof(CanvasGroup)).alpha = 0.5
			GetComponent(var1_19, typeof(CanvasGroup)).alpha = 0.5
		end

		for iter2_19, iter3_19 in pairs(arg0_17.dailyLevelTFs) do
			local var2_19 = iter3_19.localScale.x >= 0.98

			if arg0_17.centerAniItem == iter3_19 and var2_19 then
				return
			else
				if var2_19 then
					arg0_17.centerAniItem = iter3_19
					arg0_17.centerCardId = iter2_19
				end

				local var3_19 = arg0_17:findTF("icon/card", iter3_19)

				if var3_19 then
					local var4_19 = arg0_17:findTF("mask/char", var3_19):GetComponent(typeof(Animator))
					local var5_19 = arg0_17:findTF("effect", var3_19)

					setActive(var5_19, var2_19)

					if var4_19 then
						var4_19.speed = var2_19 and 1 or 0
					end
				end
			end
		end
	end, 0.1, -1)

	arg0_17.checkAniTimer:Start()
end

function var0_0.tryOpenDesc(arg0_20, arg1_20)
	local var0_20 = arg0_20.dailyLevelTFs[arg1_20]
	local var1_20 = pg.expedition_daily_template[arg1_20]

	if table.contains(var1_20.weekday, tonumber(arg0_20:getWeek())) then
		arg0_20:openDailyDesc(arg1_20)
	else
		pg.TipsMgr.GetInstance():ShowTips(var1_20.tips)
	end
end

function var0_0.CanOpenDailyLevel(arg0_21)
	local var0_21 = pg.expedition_daily_template[arg0_21]
	local var1_21 = false

	if table.contains(var0_21.weekday, tonumber(var0_0.getWeek())) then
		var1_21 = true
	end

	return var1_21, var0_21.tips
end

function var0_0.getNextCardId(arg0_22, arg1_22)
	local var0_22 = table.indexof(arg0_22.dailyList, arg0_22.centerCardId)

	if arg1_22 then
		var0_22 = var0_22 - 1

		if var0_22 <= 0 then
			var0_22 = #arg0_22.dailyList or var0_22
		end
	else
		var0_22 = var0_22 + 1
		var0_22 = var0_22 > #arg0_22.dailyList and 1 or var0_22
	end

	return arg0_22.dailyList[var0_22]
end

function var0_0.initDailyLevel(arg0_23, arg1_23)
	local var0_23 = pg.expedition_daily_template[arg1_23]
	local var1_23 = arg0_23.dailyLevelTFs[arg1_23]
	local var2_23 = table.contains(var0_23.weekday, tonumber(arg0_23:getWeek()))

	if var2_23 then
		arg0_23.index = arg1_23
	end

	setActive(findTF(var1_23, "lock"), not var2_23 and not table.isEmpty(var0_23.weekday))
	setText(findTF(var1_23, "name"), var0_23.title)
	setActive(findTF(var1_23, "time"), false)

	local var3_23 = findTF(var1_23, "icon")

	PoolMgr.GetInstance():GetPrefab("dailyui/" .. var0_23.pic, "", true, function(arg0_24)
		arg0_24 = tf(arg0_24)

		arg0_24:SetParent(var3_23, false)

		arg0_24.localPosition = Vector3.zero
		arg0_24.name = "card"
	end)
	setText(findTF(var1_23, "Text"), "")
	setActive(findTF(var1_23, "lastTime"), false)

	local var4_23 = Clone(var0_23.limit_period)
	local var5_23

	if var4_23 and type(var4_23) == "table" and pg.TimeMgr:GetInstance():inTime(var4_23) then
		local var6_23 = pg.TimeMgr:GetInstance():GetServerTime()

		var5_23 = pg.TimeMgr:GetInstance():Table2ServerTime({
			year = var4_23[2][1][1],
			month = var4_23[2][1][2],
			day = var4_23[2][1][3],
			hour = var4_23[2][2][1],
			min = var4_23[2][2][2],
			sec = var4_23[2][2][3]
		}) - var6_23
	end

	if var5_23 then
		local var7_23 = ""
		local var8_23 = ""

		if var5_23 > 86400 then
			var7_23 = math.floor(tonumber(var5_23) / 86400)
			var8_23 = i18n("word_date")
		elseif var5_23 >= 3600 then
			var7_23 = math.floor(tonumber(var5_23) / 3600)
			var8_23 = i18n("word_hour")
		elseif var5_23 > 0 then
			var7_23 = math.floor(tonumber(var5_23) / 60)
			var8_23 = i18n("word_minute")
		end

		setText(findTF(var1_23, "lastTime/content/text"), tostring(var7_23) .. " ")
		setText(findTF(var1_23, "lastTime/content/word"), tostring(var8_23))
		setActive(findTF(var1_23, "lastTime"), true)
	end

	arg0_23:UpdateDailyLevelCnt(arg1_23)
end

function var0_0.UpdateDailyLevelCnt(arg0_25, arg1_25)
	local var0_25 = pg.expedition_daily_template[arg1_25]
	local var1_25 = arg0_25.dailyLevelTFs[arg1_25]
	local var2_25 = findTF(var1_25, "count")
	local var3_25 = arg0_25.dailyCounts[arg1_25] or 0

	if var0_25.limit_time == 0 then
		setText(var2_25, "N/A")
	else
		setText(var2_25, string.format("%d/%d", var0_25.limit_time - var3_25, var0_25.limit_time))
	end

	setActive(var2_25, var0_25.limit_time > 0)
end

function var0_0.openDailyDesc(arg0_26, arg1_26)
	arg0_26.curId = arg1_26

	arg0_26:enableDescMode(true)
	arg0_26:displayStageList(arg1_26)
end

function var0_0.UpdateDailyLevelCntForDescPanel(arg0_27, arg1_27)
	local var0_27 = pg.expedition_daily_template[arg1_27]
	local var1_27 = arg0_27.dailyCounts[arg1_27] or 0

	if var0_27.limit_time == 0 then
		setText(arg0_27.descChallengeText, i18n("challenge_count_unlimit"))
	else
		setText(arg0_27.descChallengeText, string.format("%d/%d", var0_27.limit_time - var1_27, var0_27.limit_time))
	end
end

function var0_0.displayStageList(arg0_28, arg1_28)
	arg0_28.dailyLevelId = arg1_28
	arg0_28.contextData.dailyLevelId = arg0_28.dailyLevelId

	local var0_28 = pg.expedition_daily_template[arg1_28]

	arg0_28:UpdateDailyLevelCntForDescPanel(arg1_28)
	setActive(arg0_28.challengeQuotaDaily, var0_28.limit_type == 1)
	setActive(arg0_28.challengeQuotaWeekly, var0_28.limit_type == 2)
	removeAllChildren(arg0_28.stageContain)

	arg0_28.stageTFs = {}

	local var1_28 = _.sort(var0_28.expedition_and_lv_limit_list, function(arg0_29, arg1_29)
		local var0_29 = arg0_29[2] <= arg0_28.player.level and 1 or 0
		local var1_29 = arg1_29[2] <= arg0_28.player.level and 1 or 0

		if arg0_29[2] == arg1_29[2] then
			return arg0_29[1] < arg1_29[1]
		end

		if var0_29 == var1_29 then
			if var0_29 == 1 then
				return arg0_29[2] > arg1_29[2]
			else
				return arg0_29[2] < arg1_29[2]
			end
		else
			return var1_29 < var0_29
		end
	end)

	for iter0_28, iter1_28 in ipairs(var1_28) do
		local var2_28 = iter1_28[1]
		local var3_28 = iter1_28[2]

		arg0_28.stageTFs[var2_28] = cloneTplTo(arg0_28.stageTpl, arg0_28.stageContain)

		local var4_28 = {
			id = var2_28,
			level = var3_28
		}

		arg0_28:updateStage(var4_28)
	end
end

function var0_0.updateStageTF(arg0_30, arg1_30, arg2_30)
	local var0_30 = pg.expedition_data_template[arg2_30.id]

	setText(findTF(arg1_30, "left_panel/name"), var0_30.name)
	setText(findTF(arg1_30, "left_panel/lv/Text"), "Lv." .. arg2_30.level)

	local var1_30 = arg0_30:findTF("mask", arg1_30)

	setActive(var1_30, arg2_30.level > arg0_30.player.level)

	if arg2_30.level > arg0_30.player.level then
		setText(arg0_30:findTF("msg/msg_contain/Text", var1_30), "Lv." .. arg2_30.level .. " ")

		if PLATFORM_CODE == PLATFORM_US then
			arg0_30:findTF("msg/msg_contain/Text", var1_30):SetAsLastSibling()
		end
	end

	local var2_30 = UIItemList.New(arg0_30:findTF("scrollView/right_panel", arg1_30), arg0_30.itemTpl)

	var2_30:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var0_30.award_display[arg1_31 + 1]

			updateDrop(arg2_31, {
				type = var0_31[1],
				id = var0_31[2],
				count = var0_31[3]
			})
			setActive(arg2_31, arg1_31 <= 3)
		end
	end)
	var2_30:align(#var0_30.award_display)
	setImageSprite(arg1_30, getImageSprite(findTF(arg0_30.resource, "normal_bg")))
	setActive(findTF(arg1_30, "score"), false)
	onButton(arg0_30, var1_30, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_unopened"))
	end, SFX_PANEL)
end

function var0_0.updateStage(arg0_33, arg1_33)
	local var0_33 = arg0_33.stageTFs[arg1_33.id]:Find("info")

	arg0_33:updateStageTF(var0_33, arg1_33)
	onButton(arg0_33, var0_33, function()
		if getProxy(DailyLevelProxy):CanQuickBattle(arg1_33.id) then
			local var0_34 = pg.expedition_daily_template[arg0_33.dailyLevelId]

			if (arg0_33.dailyCounts[arg0_33.dailyLevelId] or 0) >= var0_34.limit_time then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

				return
			end

			if LeanTween.isTweening(go(arg0_33.descMain)) or LeanTween.isTweening(go(arg0_33.listPanel)) then
				return
			end

			arg0_33:OnSelectStage(arg1_33)
		else
			arg0_33:OnOpenPreCombat(arg1_33)
		end
	end, SFX_PANEL)
end

function var0_0.OnOpenPreCombat(arg0_35, arg1_35)
	local var0_35 = pg.expedition_daily_template[arg0_35.dailyLevelId]

	if (arg0_35.dailyCounts[arg0_35.dailyLevelId] or 0) >= var0_35.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	setActive(arg0_35.blurPanel, false)
	arg0_35:emit(DailyLevelMediator.ON_STAGE, arg1_35)
end

function var0_0.OnSelectStage(arg0_36, arg1_36)
	local var0_36 = arg0_36.selectedPanel:Find("stagetpl/info")

	onButton(arg0_36, var0_36, function()
		arg0_36:EnableOrDisable(arg1_36, false)
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36.selectedPanel, function()
		arg0_36:EnableOrDisable(arg1_36, false)
	end, SFX_PANEL)
	arg0_36:EnableOrDisable(arg1_36, true)
end

function var0_0.EnableOrDisable(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.stageTFs[arg1_39.id]:Find("quickly")

	if LeanTween.isTweening(go(arg0_39.stageContain)) or LeanTween.isTweening(go(arg0_39.selQuicklyTF)) then
		return
	end

	local var1_39 = arg0_39.stageContain:GetComponent(typeof(VerticalLayoutGroup)).padding.top
	local var2_39 = arg0_39.stageContain.parent:InverseTransformPoint(var0_39.parent.position)
	local var3_39 = -1 * var1_39 - var2_39.y

	if arg2_39 then
		arg0_39:updateStageTF(arg0_39.selStageTF, arg1_39)
		arg0_39:UpdateBattleBtn(arg1_39)
		arg0_39:DoSelectedAnimation(var0_39, var3_39, function()
			arg0_39.selectedStage = arg1_39
		end)
	else
		arg0_39:DoUnselectAnimtion(var0_39, function()
			arg0_39.selectedStage = nil
		end)
	end
end

function var0_0.DoSelectedAnimation(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = math.abs(arg2_42) / 2000

	seriesAsync({
		function(arg0_43)
			arg0_42.stageScrollRect.enabled = false

			pg.UIMgr.GetInstance():BlurPanel(arg0_42.selectedPanel, true, {
				groupName = LayerWeightConst.GROUP_DAILY,
				weight = LayerWeightConst.BASE_LAYER - 1
			})

			arg1_42.sizeDelta = Vector2(arg1_42.sizeDelta.x, 0)

			setActive(arg1_42, true)

			local var0_43 = arg0_42.stageContain.anchoredPosition

			arg0_42.stageContainLposY = var0_43.y
			arg0_42.offsetY = arg2_42

			LeanTween.value(go(arg0_42.stageContain), var0_43.y, var0_43.y + arg2_42, var0_42):setOnUpdate(System.Action_float(function(arg0_44)
				arg0_42.stageContain.anchoredPosition = Vector3(var0_43.x, arg0_44, 0)

				local var0_44 = arg0_42.selectedPanel:InverseTransformPoint(arg1_42.parent.position)

				arg0_42.selStageTF.parent.localPosition = Vector3(var0_44.x, var0_44.y, 0)
				arg0_42.selQuicklyTF.sizeDelta = Vector2(arg0_42.selQuicklyTF.sizeDelta.x, 0)

				setActive(arg0_42.selectedPanel, true)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_43))
		end,
		function(arg0_45)
			local var0_45 = arg1_42:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_42.selQuicklyTF), 0, arg0_42.selQuicklyTFSizeDeltaY, 0.1):setOnUpdate(System.Action_float(function(arg0_46)
				var0_45.preferredHeight = arg0_46
				arg0_42.selQuicklyTF.sizeDelta = Vector2(arg0_42.selQuicklyTF.sizeDelta.x, arg0_46)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_45))
		end
	}, arg3_42)
end

function var0_0.DoUnselectAnimtion(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47.stageContain.anchoredPosition

	seriesAsync({
		function(arg0_48)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_47.selectedPanel, arg0_47._tf)
			setActive(arg0_47.selectedPanel, false)

			local var0_48 = arg1_47:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_47.selQuicklyTF), arg0_47.selQuicklyTFSizeDeltaY, 0, 0.1):setOnUpdate(System.Action_float(function(arg0_49)
				var0_48.preferredHeight = arg0_49
				arg0_47.selQuicklyTF.sizeDelta = Vector2(arg0_47.selQuicklyTF.sizeDelta.x, arg0_49)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_48))
		end,
		function(arg0_50)
			local var0_50 = var0_47.y - arg0_47.offsetY
			local var1_50 = var0_50 / 2000

			LeanTween.value(go(arg0_47.stageContain), var0_47.y, var0_50, 0.15):setOnUpdate(System.Action_float(function(arg0_51)
				arg0_47.stageContain.anchoredPosition = Vector3(var0_47.x, arg0_51, 0)
			end)):setDelay(0.1):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_50))
		end
	}, function()
		arg0_47.stageScrollRect.enabled = true

		arg2_47()
	end)
end

function var0_0.UpdateBattleBtn(arg0_53, arg1_53)
	local var0_53 = arg0_53.selectedPanel:Find("stagetpl/info").parent:Find("quickly/bg")
	local var1_53 = pg.expedition_daily_template[arg0_53.dailyLevelId].limit_time - (arg0_53.dailyCounts[arg0_53.dailyLevelId] or 0)
	local var2_53 = var0_53:Find("challenge")

	onButton(arg0_53, var2_53, function()
		arg0_53:OnOpenPreCombat(arg1_53)
	end, SFX_PANEL)
	setText(var2_53:Find("Text"), i18n("daily_level_quick_battle_label2"))

	local var3_53 = var0_53:Find("mult")

	onButton(arg0_53, var3_53, function()
		arg0_53:OnQuickBattle(arg1_53, var1_53)
	end, SFX_PANEL)

	local var4_53 = var0_53:Find("once")

	onButton(arg0_53, var4_53, function()
		arg0_53:OnQuickBattle(arg1_53, 1)
	end, SFX_PANEL)
	setText(var3_53:Find("label"), i18n("daily_level_quick_battle_label1", "   ", COLOR_WHITE))
	setText(var3_53:Find("Text"), "<color=" .. COLOR_GREEN .. ">" .. math.max(1, var1_53) .. "</color>")
	setText(var4_53:Find("label"), i18n("daily_level_quick_battle_label3"))
	setText(var4_53:Find("Text"), "")

	if var1_53 == 0 then
		arg0_53:EnableOrDisable(arg1_53, false)
	end
end

function var0_0.OnQuickBattle(arg0_57, arg1_57, arg2_57)
	if arg2_57 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	if PlayerPrefs.GetInt("daily_level_quick_battle_tip", 0) == 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dailyLevel_quickfinish"),
			onYes = function()
				arg0_57:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_57.dailyLevelId, arg1_57.id, arg2_57)
			end
		})
		PlayerPrefs.SetInt("daily_level_quick_battle_tip", 1)
		PlayerPrefs.Save()
	else
		arg0_57:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_57.dailyLevelId, arg1_57.id, arg2_57)
	end
end

function var0_0.enableDescMode(arg0_59, arg1_59, arg2_59)
	arg0_59.descMode = arg1_59

	setActive(arg0_59:findTF("help_btn"), not arg1_59)

	local function var0_59(arg0_60, arg1_60, arg2_60)
		if LeanTween.isTweening(go(arg0_60)) then
			LeanTween.cancel(go(arg0_60))
		end

		LeanTween.moveX(rtf(arg0_60), arg1_60, 0.3):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
			if arg2_60 then
				arg2_60()
			end
		end))
	end

	local function var1_59()
		for iter0_62, iter1_62 in pairs(arg0_59.dailyLevelTFs) do
			setButtonEnabled(iter1_62, not arg1_59)

			if iter0_62 ~= arg0_59.curId then
				if LeanTween.isTweening(go(iter1_62)) then
					LeanTween.cancel(go(iter1_62))
				end

				local var0_62 = GetComponent(iter1_62, typeof(CanvasGroup))

				if arg1_59 then
					LeanTween.value(go(iter1_62), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_63)
						var0_62.alpha = arg0_63
					end))
				else
					LeanTween.value(go(iter1_62), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_64)
						var0_62.alpha = arg0_64
					end))
				end
			end
		end
	end

	local function var2_59()
		setActive(arg0_59.listPanel, true)
		setActive(arg0_59.content, true)
		setActive(arg0_59.descPanel, arg1_59)
		setActive(arg0_59.arrows, not arg1_59)
	end

	if arg1_59 then
		var2_59()
		var1_59()
		var0_59(arg0_59.listPanel, -622, function()
			var0_59(arg0_59.descMain, 0, arg2_59)
		end)
	else
		if arg0_59.selectedStage then
			arg0_59:EnableOrDisable(arg0_59.selectedStage, false)
		end

		var2_59()
		var1_59()
		var0_59(arg0_59.listPanel, 0)
		var0_59(arg0_59.descMain, -1342, arg2_59)
	end
end

function var0_0.flipToSpecificCard(arg0_67, arg1_67)
	local var0_67 = arg0_67.content:GetComponent(typeof(EnhancelScrollView))

	for iter0_67, iter1_67 in pairs(arg0_67.dailyLevelTFs) do
		if arg1_67 == iter0_67 then
			local var1_67 = iter1_67:GetComponent(typeof(EnhanceItem))

			var0_67:SetHorizontalTargetItemIndex(var1_67.scrollViewItemIndex)
		end
	end
end

function var0_0.tryPlayGuide(arg0_68)
	pg.SystemGuideMgr.GetInstance():PlayDailyLevel(function()
		triggerButton(arg0_68:findTF("help_btn"))
	end)
end

function var0_0.ShowGuildTaskTip(arg0_70)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForDailyBattle()
end

function var0_0.clearTween(arg0_71)
	if arg0_71.tweens then
		cancelTweens(arg0_71.tweens)
	end

	local function var0_71(arg0_72)
		if LeanTween.isTweening(go(arg0_72)) then
			LeanTween.cancel(go(arg0_72))
		end
	end

	for iter0_71, iter1_71 in pairs(arg0_71.dailyLevelTFs) do
		var0_71(iter1_71)
	end

	var0_71(arg0_71.listPanel)
	var0_71(arg0_71.descMain)
end

function var0_0.onBackPressed(arg0_73)
	if arg0_73.descMode then
		if LeanTween.isTweening(go(arg0_73.stageContain)) or LeanTween.isTweening(go(arg0_73.selQuicklyTF)) then
			return
		end

		arg0_73:enableDescMode(false)

		return
	end

	var0_0.super.onBackPressed(arg0_73)
end

function var0_0.willExit(arg0_74)
	if arg0_74.selectedStage then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_74.selectedPanel, arg0_74._tf)
	end

	arg0_74:clearTween()

	if arg0_74.checkAniTimer then
		arg0_74.checkAniTimer:Stop()

		arg0_74.checkAniTimer = nil
	end
end

return var0_0
