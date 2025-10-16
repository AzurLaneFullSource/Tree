local var0_0 = class("DailyLevelScene", import("..base.BaseUI"))
local var1_0 = 3
local var2_0 = 4
local var3_0 = 101

function var0_0.getUIName(arg0_1)
	return "DailyLevelUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3.blurPanel = arg0_3._tf:Find("blur_panel")
	arg0_3.topPanel = arg0_3._tf:Find("blur_panel/adapt/top")
	arg0_3.backBtn = arg0_3.topPanel:Find("back_button")
	arg0_3.listPanel = arg0_3._tf:Find("list_panel")
	arg0_3.content = arg0_3.listPanel:Find("list")

	setActive(arg0_3.content, true)

	arg0_3.dailylevelTpl = arg0_3:getTpl("list_panel/list/captertpl")
	arg0_3.descPanel = arg0_3._tf:Find("desc_panel")
	arg0_3.selectedPanel = arg0_3.descPanel:Find("selected")
	arg0_3.descMain = arg0_3.descPanel:Find("main_mask/main")
	arg0_3.stageTpl = arg0_3:getTpl("scrollview/content/stagetpl", arg0_3.descMain)
	arg0_3.stageScrollRect = arg0_3.descMain:Find("scrollview"):GetComponent(typeof(ScrollRect))
	arg0_3.stageContain = arg0_3.descMain:Find("scrollview/content")
	arg0_3.arrows = arg0_3._tf:Find("arrows")
	arg0_3.itemTpl = arg0_3:getTpl("item_tpl")
	arg0_3.selStageTF = arg0_3.selectedPanel:Find("stagetpl/info")
	arg0_3.selQuicklyTF = arg0_3.selStageTF.parent:Find("quickly/bg")
	arg0_3.selQuicklyTFSizeDeltaY = arg0_3.selQuicklyTF.sizeDelta.y
	arg0_3.descChallengeNum = arg0_3.descMain:Find("challenge_count")
	arg0_3.descChallengeText = arg0_3.descChallengeNum:Find("Text")
	arg0_3.challengeQuotaDaily = arg0_3.descMain:Find("challenge_count/label")
	arg0_3.challengeQuotaWeekly = arg0_3.descMain:Find("challenge_count/week_label")
	arg0_3.fleetEditView = arg0_3._tf:Find("fleet_edit")
	arg0_3.resource = arg0_3._tf:Find("resource")
	arg0_3.rightBtn = arg0_3._tf:Find("arrows/arrow1")
	arg0_3.leftBtn = arg0_3._tf:Find("arrows/arrow2")

	arg0_3:initItems()
end

function var0_0.getWeek()
	return (pg.TimeMgr.GetInstance():GetServerWeek())
end

function var0_0.setDailyCounts(arg0_5, arg1_5)
	arg0_5.dailyCounts = arg1_5
end

function var0_0.setActivity(arg0_6, arg1_6)
	arg0_6.bonusActivity = arg1_6
end

function var0_0.setShips(arg0_7, arg1_7)
	arg0_7.shipVOs = arg1_7
end

function var0_0.updateRes(arg0_8, arg1_8)
	arg0_8.player = arg1_8
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9._tf:Find("help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_daily_task.tip
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.backBtn, function()
		if arg0_9.descMode then
			if LeanTween.isTweening(go(arg0_9.stageContain)) or LeanTween.isTweening(go(arg0_9.selQuicklyTF)) then
				return
			end

			arg0_9:enableDescMode(false)
		else
			arg0_9:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.leftBtn, function()
		arg0_9:flipToSpecificCard(arg0_9:getNextCardId(true))
	end)
	onButton(arg0_9, arg0_9.rightBtn, function()
		arg0_9:flipToSpecificCard(arg0_9:getNextCardId(false))
	end)
	arg0_9:displayDailyLevels()

	if arg0_9.contextData.dailyLevelId then
		arg0_9:tryOpenDesc(arg0_9.contextData.dailyLevelId)
	else
		arg0_9:enableDescMode(false)
	end

	arg0_9:tryPlayGuide()
	arg0_9:ShowGuildTaskTip()
end

function var0_0.initItems(arg0_14)
	local var0_14 = getProxy(DailyLevelProxy)

	var0_14:setDailyTip(false)

	arg0_14.dailyCounts = var0_14:getRawData()

	local var1_14 = pg.expedition_daily_template

	arg0_14.dailyLevelTFs = {}
	arg0_14.dailyList = _.reverse(Clone(var1_14.all))

	for iter0_14 = #arg0_14.dailyList, 1, -1 do
		local var2_14 = var1_14[arg0_14.dailyList[iter0_14]].limit_period
		local var3_14 = var1_14[arg0_14.dailyList[iter0_14]].insert_daily

		if var2_14 and type(var2_14) == "table" then
			if not pg.TimeMgr.GetInstance():inTime(var2_14) then
				table.remove(arg0_14.dailyList, iter0_14)
			end
		elseif var3_14 == 1 then
			table.remove(arg0_14.dailyList, iter0_14)
		end
	end

	arg0_14:sortDailyList()
	arg0_14:updateShowCenter()

	if arg0_14.contextData.dailyLevelId then
		local var4_14 = arg0_14.contextData.dailyLevelId

		table.removebyvalue(arg0_14.dailyList, var4_14)
		table.insert(arg0_14.dailyList, math.ceil(#var1_14.all / 2), var4_14)
	end

	for iter1_14, iter2_14 in pairs(arg0_14.dailyList) do
		arg0_14.dailyLevelTFs[iter2_14] = cloneTplTo(arg0_14.dailylevelTpl, arg0_14.content, iter2_14)
	end
end

function var0_0.sortDailyList(arg0_15)
	if #arg0_15.dailyList % 2 ~= 1 then
		table.insert(arg0_15.dailyList, var3_0)
	end

	table.sort(arg0_15.dailyList, function(arg0_16, arg1_16)
		return tonumber(pg.expedition_daily_template[arg0_16].sort) > tonumber(pg.expedition_daily_template[arg1_16].sort)
	end)
end

function var0_0.updateShowCenter(arg0_17)
	if not arg0_17.dailyList or #arg0_17.dailyList == 0 then
		return
	end

	local var0_17 = #arg0_17.dailyList
	local var1_17 = pg.expedition_daily_template
	local var2_17 = math.ceil(var0_17 / 2)
	local var3_17

	for iter0_17 = 1, var0_17 do
		local var4_17 = var1_17[arg0_17.dailyList[iter0_17]]

		if var4_17.show_with_count and var4_17.show_with_count == 1 then
			local var5_17 = var4_17.id
			local var6_17 = arg0_17.dailyCounts and arg0_17.dailyCounts[var5_17] or 0

			if var4_17.limit_time - var6_17 > 0 then
				var3_17 = var3_17 or iter0_17
			end
		end
	end

	if var3_17 then
		local var7_17 = var2_17 - var3_17 < 0 and true or false
		local var8_17 = math.abs(var2_17 - var3_17)

		for iter1_17 = 1, var8_17 do
			local var9_17

			if var7_17 then
				local var10_17 = table.remove(arg0_17.dailyList, 1)

				table.insert(arg0_17.dailyList, var10_17)
			else
				local var11_17 = table.remove(arg0_17.dailyList, #arg0_17.dailyList)

				table.insert(arg0_17.dailyList, 1, var11_17)
			end
		end
	end
end

function var0_0.displayDailyLevels(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.dailyLevelTFs) do
		arg0_18:initDailyLevel(iter0_18)
	end

	arg0_18.content:GetComponent(typeof(EnhancelScrollView)).onCenterClick = function(arg0_19)
		arg0_18:tryOpenDesc(tonumber(arg0_19.name))
	end
	arg0_18.centerAniItem = nil
	arg0_18.centerCardId = nil
	arg0_18.checkAniTimer = Timer.New(function()
		if not arg0_18.descMode then
			local var0_20
			local var1_20

			for iter0_20, iter1_20 in pairs(arg0_18.dailyLevelTFs) do
				GetComponent(iter1_20, typeof(CanvasGroup)).alpha = 1

				if not var0_20 and not var1_20 then
					var0_20 = iter1_20
					var1_20 = iter1_20
				elseif iter1_20.anchoredPosition.x < var0_20.anchoredPosition.x then
					var0_20 = iter1_20
				elseif iter1_20.anchoredPosition.x > var1_20.anchoredPosition.x then
					var1_20 = iter1_20
				end
			end

			GetComponent(var0_20, typeof(CanvasGroup)).alpha = 0.5
			GetComponent(var1_20, typeof(CanvasGroup)).alpha = 0.5
		end

		for iter2_20, iter3_20 in pairs(arg0_18.dailyLevelTFs) do
			local var2_20 = iter3_20.localScale.x >= 0.98

			if arg0_18.centerAniItem == iter3_20 and var2_20 then
				return
			else
				if var2_20 then
					arg0_18.centerAniItem = iter3_20
					arg0_18.centerCardId = iter2_20
				end

				local var3_20 = iter3_20:Find("icon/card")

				if var3_20 then
					local var4_20 = var3_20:Find("mask/char"):GetComponent(typeof(Animator))
					local var5_20 = var3_20:Find("effect")

					setActive(var5_20, var2_20)

					if var4_20 then
						var4_20.speed = var2_20 and 1 or 0
					end
				end
			end
		end
	end, 0.1, -1)

	arg0_18.checkAniTimer:Start()
end

function var0_0.tryOpenDesc(arg0_21, arg1_21)
	local var0_21 = arg0_21.dailyLevelTFs[arg1_21]
	local var1_21 = pg.expedition_daily_template[arg1_21]

	if table.contains(var1_21.weekday, tonumber(arg0_21:getWeek())) then
		arg0_21:openDailyDesc(arg1_21)
	else
		pg.TipsMgr.GetInstance():ShowTips(var1_21.tips)
	end
end

function var0_0.CanOpenDailyLevel(arg0_22)
	local var0_22 = pg.expedition_daily_template[arg0_22]
	local var1_22 = false

	if table.contains(var0_22.weekday, tonumber(var0_0.getWeek())) then
		var1_22 = true
	end

	return var1_22, var0_22.tips
end

function var0_0.getNextCardId(arg0_23, arg1_23)
	local var0_23 = table.indexof(arg0_23.dailyList, arg0_23.centerCardId)

	if arg1_23 then
		var0_23 = var0_23 - 1

		if var0_23 <= 0 then
			var0_23 = #arg0_23.dailyList or var0_23
		end
	else
		var0_23 = var0_23 + 1
		var0_23 = var0_23 > #arg0_23.dailyList and 1 or var0_23
	end

	return arg0_23.dailyList[var0_23]
end

function var0_0.initDailyLevel(arg0_24, arg1_24)
	local var0_24 = pg.expedition_daily_template[arg1_24]
	local var1_24 = arg0_24.dailyLevelTFs[arg1_24]
	local var2_24 = table.contains(var0_24.weekday, tonumber(arg0_24:getWeek()))

	if var2_24 then
		arg0_24.index = arg1_24
	end

	setActive(findTF(var1_24, "lock"), not var2_24 and not table.isEmpty(var0_24.weekday))
	setText(findTF(var1_24, "name"), var0_24.title)
	setActive(findTF(var1_24, "time"), false)

	if arg0_24.bonusActivity and not arg0_24.bonusActivity:isEnd() then
		local var3_24 = checkExist(underscore.detect(arg0_24.bonusActivity:getConfig("config_data"), function(arg0_25)
			return arg0_25[1] == arg1_24
		end), {
			2
		})

		setText(var1_24:Find("bonus/Text"), i18n("dailyLevel_bonus_activity"))
		setActive(var1_24:Find("bonus"), tobool(var3_24))

		if var3_24 then
			updateDrop(var1_24:Find("bonus/IconTpl"), Drop.Create(var3_24))
		end
	else
		setActive(var1_24:Find("bonus"), false)
	end

	local var4_24 = findTF(var1_24, "icon")

	PoolMgr.GetInstance():GetPrefab("dailyui/" .. var0_24.pic, "", true, function(arg0_26)
		arg0_26 = tf(arg0_26)

		arg0_26:SetParent(var4_24, false)

		arg0_26.localPosition = Vector3.zero
		arg0_26.name = "card"
	end)
	setText(findTF(var1_24, "Text"), "")
	setActive(findTF(var1_24, "lastTime"), false)

	local var5_24 = Clone(var0_24.limit_period)
	local var6_24

	if var5_24 and type(var5_24) == "table" and pg.TimeMgr.GetInstance():inTime(var5_24) then
		local var7_24 = pg.TimeMgr.GetInstance():GetServerTime()

		var6_24 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5_24[2][1][1],
			month = var5_24[2][1][2],
			day = var5_24[2][1][3],
			hour = var5_24[2][2][1],
			min = var5_24[2][2][2],
			sec = var5_24[2][2][3]
		}) - var7_24
	end

	if var6_24 then
		local var8_24 = ""
		local var9_24 = ""

		if var6_24 > 86400 then
			var8_24 = math.floor(tonumber(var6_24) / 86400)
			var9_24 = i18n("word_date")
		elseif var6_24 >= 3600 then
			var8_24 = math.floor(tonumber(var6_24) / 3600)
			var9_24 = i18n("word_hour")
		elseif var6_24 > 0 then
			var8_24 = math.floor(tonumber(var6_24) / 60)
			var9_24 = i18n("word_minute")
		end

		setText(findTF(var1_24, "lastTime/content/text"), tostring(var8_24) .. " ")
		setText(findTF(var1_24, "lastTime/content/word"), tostring(var9_24))
		setActive(findTF(var1_24, "lastTime"), true)
	end

	arg0_24:UpdateDailyLevelCnt(arg1_24)
end

function var0_0.UpdateDailyLevelCnt(arg0_27, arg1_27)
	local var0_27 = pg.expedition_daily_template[arg1_27]
	local var1_27 = arg0_27.dailyLevelTFs[arg1_27]
	local var2_27 = findTF(var1_27, "count")
	local var3_27 = arg0_27.dailyCounts[arg1_27] or 0

	if var0_27.limit_time == 0 then
		setText(var2_27, "N/A")
	else
		setText(var2_27, string.format("%d/%d", var0_27.limit_time - var3_27, var0_27.limit_time))
	end

	setActive(var2_27, var0_27.limit_time > 0)
end

function var0_0.openDailyDesc(arg0_28, arg1_28)
	arg0_28.curId = arg1_28

	arg0_28:enableDescMode(true)
	arg0_28:displayStageList(arg1_28)
end

function var0_0.UpdateDailyLevelCntForDescPanel(arg0_29, arg1_29)
	local var0_29 = pg.expedition_daily_template[arg1_29]
	local var1_29 = arg0_29.dailyCounts[arg1_29] or 0

	if var0_29.limit_time == 0 then
		setText(arg0_29.descChallengeText, i18n("challenge_count_unlimit"))
	else
		setText(arg0_29.descChallengeText, string.format("%d/%d", var0_29.limit_time - var1_29, var0_29.limit_time))
	end
end

function var0_0.displayStageList(arg0_30, arg1_30)
	arg0_30.dailyLevelId = arg1_30
	arg0_30.contextData.dailyLevelId = arg0_30.dailyLevelId

	local var0_30 = pg.expedition_daily_template[arg1_30]

	arg0_30:UpdateDailyLevelCntForDescPanel(arg1_30)
	setActive(arg0_30.challengeQuotaDaily, var0_30.limit_type == 1)
	setActive(arg0_30.challengeQuotaWeekly, var0_30.limit_type == 2)
	removeAllChildren(arg0_30.stageContain)

	arg0_30.stageTFs = {}

	local var1_30 = _.sort(var0_30.expedition_and_lv_limit_list, function(arg0_31, arg1_31)
		local var0_31 = arg0_31[2] <= arg0_30.player.level and 1 or 0
		local var1_31 = arg1_31[2] <= arg0_30.player.level and 1 or 0

		if arg0_31[2] == arg1_31[2] then
			return arg0_31[1] < arg1_31[1]
		end

		if var0_31 == var1_31 then
			if var0_31 == 1 then
				return arg0_31[2] > arg1_31[2]
			else
				return arg0_31[2] < arg1_31[2]
			end
		else
			return var1_31 < var0_31
		end
	end)

	for iter0_30, iter1_30 in ipairs(var1_30) do
		local var2_30 = iter1_30[1]
		local var3_30 = iter1_30[2]

		arg0_30.stageTFs[var2_30] = cloneTplTo(arg0_30.stageTpl, arg0_30.stageContain)

		local var4_30 = {
			id = var2_30,
			level = var3_30
		}

		arg0_30:updateStage(var4_30)
	end
end

function var0_0.updateStageTF(arg0_32, arg1_32, arg2_32)
	local var0_32 = pg.expedition_data_template[arg2_32.id]

	setText(findTF(arg1_32, "left_panel/name"), var0_32.name)
	setText(findTF(arg1_32, "left_panel/lv/Text"), "Lv." .. arg2_32.level)

	local var1_32 = arg1_32:Find("mask")

	setActive(var1_32, arg2_32.level > arg0_32.player.level)

	if arg2_32.level > arg0_32.player.level then
		setText(var1_32:Find("msg/msg_contain/Text"), "Lv." .. arg2_32.level .. " ")

		if PLATFORM_CODE == PLATFORM_US then
			var1_32:Find("msg/msg_contain/Text"):SetAsLastSibling()
		end
	end

	local var2_32 = UIItemList.New(arg1_32:Find("scrollView/right_panel"), arg0_32.itemTpl)

	var2_32:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var0_32.award_display[arg1_33 + 1]

			updateDrop(arg2_33, {
				type = var0_33[1],
				id = var0_33[2],
				count = var0_33[3]
			})
			setActive(arg2_33, arg1_33 <= 3)
		end
	end)
	var2_32:align(#var0_32.award_display)
	setImageSprite(arg1_32, getImageSprite(findTF(arg0_32.resource, "normal_bg")))
	setActive(findTF(arg1_32, "score"), false)
	onButton(arg0_32, var1_32, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_unopened"))
	end, SFX_PANEL)
end

function var0_0.updateStage(arg0_35, arg1_35)
	local var0_35 = arg0_35.stageTFs[arg1_35.id]:Find("info")

	arg0_35:updateStageTF(var0_35, arg1_35)
	onButton(arg0_35, var0_35, function()
		if getProxy(DailyLevelProxy):CanQuickBattle(arg1_35.id) then
			local var0_36 = pg.expedition_daily_template[arg0_35.dailyLevelId]

			if (arg0_35.dailyCounts[arg0_35.dailyLevelId] or 0) >= var0_36.limit_time then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

				return
			end

			if LeanTween.isTweening(go(arg0_35.descMain)) or LeanTween.isTweening(go(arg0_35.listPanel)) then
				return
			end

			arg0_35:OnSelectStage(arg1_35)
		else
			arg0_35:OnOpenPreCombat(arg1_35)
		end
	end, SFX_PANEL)
end

function var0_0.OnOpenPreCombat(arg0_37, arg1_37)
	local var0_37 = pg.expedition_daily_template[arg0_37.dailyLevelId]

	if (arg0_37.dailyCounts[arg0_37.dailyLevelId] or 0) >= var0_37.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	setActive(arg0_37.blurPanel, false)
	arg0_37:emit(DailyLevelMediator.ON_STAGE, arg1_37)
end

function var0_0.OnSelectStage(arg0_38, arg1_38)
	local var0_38 = arg0_38.selectedPanel:Find("stagetpl/info")

	onButton(arg0_38, var0_38, function()
		arg0_38:EnableOrDisable(arg1_38, false)
	end, SFX_PANEL)
	onButton(arg0_38, arg0_38.selectedPanel, function()
		arg0_38:EnableOrDisable(arg1_38, false)
	end, SFX_PANEL)
	arg0_38:EnableOrDisable(arg1_38, true)
end

function var0_0.EnableOrDisable(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.stageTFs[arg1_41.id]:Find("quickly")

	if LeanTween.isTweening(go(arg0_41.stageContain)) or LeanTween.isTweening(go(arg0_41.selQuicklyTF)) then
		return
	end

	local var1_41 = arg0_41.stageContain:GetComponent(typeof(VerticalLayoutGroup)).padding.top
	local var2_41 = arg0_41.stageContain.parent:InverseTransformPoint(var0_41.parent.position)
	local var3_41 = -1 * var1_41 - var2_41.y

	if arg2_41 then
		arg0_41:updateStageTF(arg0_41.selStageTF, arg1_41)
		arg0_41:UpdateBattleBtn(arg1_41)
		arg0_41:DoSelectedAnimation(var0_41, var3_41, function()
			arg0_41.selectedStage = arg1_41
		end)
	else
		arg0_41:DoUnselectAnimtion(var0_41, function()
			arg0_41.selectedStage = nil
		end)
	end
end

function var0_0.DoSelectedAnimation(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = math.abs(arg2_44) / 2000

	seriesAsync({
		function(arg0_45)
			arg0_44.stageScrollRect.enabled = false

			pg.UIMgr.GetInstance():BlurPanel(arg0_44.selectedPanel)

			arg1_44.sizeDelta = Vector2(arg1_44.sizeDelta.x, 0)

			setActive(arg1_44, true)

			local var0_45 = arg0_44.stageContain.anchoredPosition

			arg0_44.stageContainLposY = var0_45.y
			arg0_44.offsetY = arg2_44

			LeanTween.value(go(arg0_44.stageContain), var0_45.y, var0_45.y + arg2_44, var0_44):setOnUpdate(System.Action_float(function(arg0_46)
				arg0_44.stageContain.anchoredPosition = Vector3(var0_45.x, arg0_46, 0)

				local var0_46 = arg0_44.selectedPanel:InverseTransformPoint(arg1_44.parent.position)

				arg0_44.selStageTF.parent.localPosition = Vector3(var0_46.x, var0_46.y, 0)
				arg0_44.selQuicklyTF.sizeDelta = Vector2(arg0_44.selQuicklyTF.sizeDelta.x, 0)

				setActive(arg0_44.selectedPanel, true)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_45))
		end,
		function(arg0_47)
			local var0_47 = arg1_44:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_44.selQuicklyTF), 0, arg0_44.selQuicklyTFSizeDeltaY, 0.1):setOnUpdate(System.Action_float(function(arg0_48)
				var0_47.preferredHeight = arg0_48
				arg0_44.selQuicklyTF.sizeDelta = Vector2(arg0_44.selQuicklyTF.sizeDelta.x, arg0_48)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_47))
		end
	}, arg3_44)
end

function var0_0.DoUnselectAnimtion(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49.stageContain.anchoredPosition

	seriesAsync({
		function(arg0_50)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49.selectedPanel, arg0_49._tf)
			setActive(arg0_49.selectedPanel, false)

			local var0_50 = arg1_49:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_49.selQuicklyTF), arg0_49.selQuicklyTFSizeDeltaY, 0, 0.1):setOnUpdate(System.Action_float(function(arg0_51)
				var0_50.preferredHeight = arg0_51
				arg0_49.selQuicklyTF.sizeDelta = Vector2(arg0_49.selQuicklyTF.sizeDelta.x, arg0_51)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_50))
		end,
		function(arg0_52)
			local var0_52 = var0_49.y - arg0_49.offsetY
			local var1_52 = var0_52 / 2000

			LeanTween.value(go(arg0_49.stageContain), var0_49.y, var0_52, 0.15):setOnUpdate(System.Action_float(function(arg0_53)
				arg0_49.stageContain.anchoredPosition = Vector3(var0_49.x, arg0_53, 0)
			end)):setDelay(0.1):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_52))
		end
	}, function()
		arg0_49.stageScrollRect.enabled = true

		arg2_49()
	end)
end

function var0_0.UpdateBattleBtn(arg0_55, arg1_55)
	local var0_55 = arg0_55.selectedPanel:Find("stagetpl/info").parent:Find("quickly/bg")
	local var1_55 = pg.expedition_daily_template[arg0_55.dailyLevelId].limit_time - (arg0_55.dailyCounts[arg0_55.dailyLevelId] or 0)
	local var2_55 = var0_55:Find("challenge")

	onButton(arg0_55, var2_55, function()
		arg0_55:OnOpenPreCombat(arg1_55)
	end, SFX_PANEL)
	setText(var2_55:Find("Text"), i18n("daily_level_quick_battle_label2"))

	local var3_55 = var0_55:Find("mult")

	onButton(arg0_55, var3_55, function()
		arg0_55:OnQuickBattle(arg1_55, var1_55)
	end, SFX_PANEL)

	local var4_55 = var0_55:Find("once")

	onButton(arg0_55, var4_55, function()
		arg0_55:OnQuickBattle(arg1_55, 1)
	end, SFX_PANEL)
	setText(var3_55:Find("label"), i18n("daily_level_quick_battle_label1", "   ", COLOR_WHITE))
	setText(var3_55:Find("Text"), "<color=" .. COLOR_GREEN .. ">" .. math.max(1, var1_55) .. "</color>")
	setText(var4_55:Find("label"), i18n("daily_level_quick_battle_label3"))
	setText(var4_55:Find("Text"), "")

	if var1_55 == 0 then
		arg0_55:EnableOrDisable(arg1_55, false)
	end
end

function var0_0.OnQuickBattle(arg0_59, arg1_59, arg2_59)
	if arg2_59 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	if PlayerPrefs.GetInt("daily_level_quick_battle_tip", 0) == 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dailyLevel_quickfinish"),
			onYes = function()
				arg0_59:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_59.dailyLevelId, arg1_59.id, arg2_59)
			end
		})
		PlayerPrefs.SetInt("daily_level_quick_battle_tip", 1)
		PlayerPrefs.Save()
	else
		arg0_59:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_59.dailyLevelId, arg1_59.id, arg2_59)
	end
end

function var0_0.enableDescMode(arg0_61, arg1_61, arg2_61)
	arg0_61.descMode = arg1_61

	setActive(arg0_61._tf:Find("help_btn"), not arg1_61)

	local function var0_61(arg0_62, arg1_62, arg2_62)
		if LeanTween.isTweening(go(arg0_62)) then
			LeanTween.cancel(go(arg0_62))
		end

		LeanTween.moveX(rtf(arg0_62), arg1_62, 0.3):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
			if arg2_62 then
				arg2_62()
			end
		end))
	end

	local function var1_61()
		for iter0_64, iter1_64 in pairs(arg0_61.dailyLevelTFs) do
			setButtonEnabled(iter1_64, not arg1_61)

			if iter0_64 ~= arg0_61.curId then
				if LeanTween.isTweening(go(iter1_64)) then
					LeanTween.cancel(go(iter1_64))
				end

				local var0_64 = GetComponent(iter1_64, typeof(CanvasGroup))

				if arg1_61 then
					LeanTween.value(go(iter1_64), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_65)
						var0_64.alpha = arg0_65
					end))
				else
					LeanTween.value(go(iter1_64), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_66)
						var0_64.alpha = arg0_66
					end))
				end
			end
		end
	end

	local function var2_61()
		setActive(arg0_61.listPanel, true)
		setActive(arg0_61.content, true)
		setActive(arg0_61.descPanel, arg1_61)
		setActive(arg0_61.arrows, not arg1_61)
	end

	if arg1_61 then
		var2_61()
		var1_61()
		var0_61(arg0_61.listPanel, -622, function()
			var0_61(arg0_61.descMain, 0, arg2_61)
		end)
	else
		if arg0_61.selectedStage then
			arg0_61:EnableOrDisable(arg0_61.selectedStage, false)
		end

		var2_61()
		var1_61()
		var0_61(arg0_61.listPanel, 0)
		var0_61(arg0_61.descMain, -1342, arg2_61)
	end
end

function var0_0.flipToSpecificCard(arg0_69, arg1_69)
	local var0_69 = arg0_69.content:GetComponent(typeof(EnhancelScrollView))

	for iter0_69, iter1_69 in pairs(arg0_69.dailyLevelTFs) do
		if arg1_69 == iter0_69 then
			local var1_69 = iter1_69:GetComponent(typeof(EnhanceItem))

			var0_69:SetHorizontalTargetItemIndex(var1_69.scrollViewItemIndex)
		end
	end
end

function var0_0.tryPlayGuide(arg0_70)
	pg.SystemGuideMgr.GetInstance():PlayDailyLevel(function()
		triggerButton(arg0_70._tf:Find("help_btn"))
	end)
end

function var0_0.ShowGuildTaskTip(arg0_72)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForDailyBattle()
end

function var0_0.clearTween(arg0_73)
	if arg0_73.tweens then
		cancelTweens(arg0_73.tweens)
	end

	local function var0_73(arg0_74)
		if LeanTween.isTweening(go(arg0_74)) then
			LeanTween.cancel(go(arg0_74))
		end
	end

	for iter0_73, iter1_73 in pairs(arg0_73.dailyLevelTFs) do
		var0_73(iter1_73)
	end

	var0_73(arg0_73.listPanel)
	var0_73(arg0_73.descMain)
end

function var0_0.onBackPressed(arg0_75)
	if arg0_75.descMode then
		if LeanTween.isTweening(go(arg0_75.stageContain)) or LeanTween.isTweening(go(arg0_75.selQuicklyTF)) then
			return
		end

		arg0_75:enableDescMode(false)

		return
	end

	var0_0.super.onBackPressed(arg0_75)
end

function var0_0.willExit(arg0_76)
	if arg0_76.selectedStage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_76.selectedPanel, arg0_76._tf)
	end

	arg0_76:clearTween()

	if arg0_76.checkAniTimer then
		arg0_76.checkAniTimer:Stop()

		arg0_76.checkAniTimer = nil
	end
end

return var0_0
