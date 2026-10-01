local var0_0 = class("DailyLevelScene", import("..base.BaseUI"))
local var1_0 = 3
local var2_0 = 4
local var3_0 = 101

function var0_0.getUIName(arg0_1)
	return "DailyLevelUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"cue/level.b"
	}
	local var1_2 = {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not var1_2[arg0_3] then
			var1_2[arg0_3] = true

			table.insert(var0_2, arg0_3)
		end
	end

	local var3_2 = pg.expedition_daily_template

	for iter0_2, iter1_2 in ipairs(var3_2.all or {}) do
		local var4_2 = var3_2[iter1_2]

		if var4_2 then
			var2_2("dailyui/" .. var4_2.pic)

			for iter2_2, iter3_2 in ipairs(var4_2.expedition_and_lv_limit_list or {}) do
				local var5_2 = pg.expedition_data_template[iter3_2[1]]

				if var5_2 then
					for iter4_2, iter5_2 in ipairs(var5_2.award_display or {}) do
						var2_2(Drop.Create(iter5_2):getIcon())
					end
				end
			end
		end
	end

	if arg0_2.bonusActivity and not arg0_2.bonusActivity:isEnd() then
		for iter6_2, iter7_2 in ipairs(arg0_2.bonusActivity:getConfig("config_data") or {}) do
			local var6_2 = iter7_2[2]

			if var6_2 then
				var2_2(Drop.Create(var6_2):getIcon())
			end
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.ResUISettings(arg0_4)
	return true
end

function var0_0.init(arg0_5)
	arg0_5.blurPanel = arg0_5._tf:Find("blur_panel")
	arg0_5.topPanel = arg0_5._tf:Find("blur_panel/adapt/top")
	arg0_5.backBtn = arg0_5.topPanel:Find("back_button")
	arg0_5.listPanel = arg0_5._tf:Find("list_panel")
	arg0_5.content = arg0_5.listPanel:Find("list")

	setActive(arg0_5.content, true)

	arg0_5.dailylevelTpl = arg0_5:getTpl("list_panel/list/captertpl")
	arg0_5.descPanel = arg0_5._tf:Find("desc_panel")
	arg0_5.selectedPanel = arg0_5.descPanel:Find("selected")
	arg0_5.descMain = arg0_5.descPanel:Find("main_mask/main")
	arg0_5.stageTpl = arg0_5:getTpl("scrollview/content/stagetpl", arg0_5.descMain)
	arg0_5.stageScrollRect = arg0_5.descMain:Find("scrollview"):GetComponent(typeof(ScrollRect))
	arg0_5.stageContain = arg0_5.descMain:Find("scrollview/content")
	arg0_5.arrows = arg0_5._tf:Find("arrows")
	arg0_5.itemTpl = arg0_5:getTpl("item_tpl")
	arg0_5.selStageTF = arg0_5.selectedPanel:Find("stagetpl/info")
	arg0_5.selQuicklyTF = arg0_5.selStageTF.parent:Find("quickly/bg")
	arg0_5.selQuicklyTFSizeDeltaY = arg0_5.selQuicklyTF.sizeDelta.y
	arg0_5.descChallengeNum = arg0_5.descMain:Find("challenge_count")
	arg0_5.descChallengeText = arg0_5.descChallengeNum:Find("Text")
	arg0_5.challengeQuotaDaily = arg0_5.descMain:Find("challenge_count/label")
	arg0_5.challengeQuotaWeekly = arg0_5.descMain:Find("challenge_count/week_label")
	arg0_5.fleetEditView = arg0_5._tf:Find("fleet_edit")
	arg0_5.resource = arg0_5._tf:Find("resource")
	arg0_5.rightBtn = arg0_5._tf:Find("arrows/arrow1")
	arg0_5.leftBtn = arg0_5._tf:Find("arrows/arrow2")

	arg0_5:initItems()
end

function var0_0.getWeek()
	return (pg.TimeMgr.GetInstance():GetServerWeek())
end

function var0_0.setDailyCounts(arg0_7, arg1_7)
	arg0_7.dailyCounts = arg1_7
end

function var0_0.setActivity(arg0_8, arg1_8)
	arg0_8.bonusActivity = arg1_8
end

function var0_0.setShips(arg0_9, arg1_9)
	arg0_9.shipVOs = arg1_9
end

function var0_0.updateRes(arg0_10, arg1_10)
	arg0_10.player = arg1_10
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11._tf:Find("help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_daily_task.tip
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.backBtn, function()
		if arg0_11.descMode then
			if LeanTween.isTweening(go(arg0_11.stageContain)) or LeanTween.isTweening(go(arg0_11.selQuicklyTF)) then
				return
			end

			arg0_11:enableDescMode(false)
		else
			arg0_11:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.leftBtn, function()
		arg0_11:flipToSpecificCard(arg0_11:getNextCardId(true))
	end)
	onButton(arg0_11, arg0_11.rightBtn, function()
		arg0_11:flipToSpecificCard(arg0_11:getNextCardId(false))
	end)
	arg0_11:displayDailyLevels()

	if arg0_11.contextData.dailyLevelId then
		arg0_11:tryOpenDesc(arg0_11.contextData.dailyLevelId)
	else
		arg0_11:enableDescMode(false)
	end

	arg0_11:tryPlayGuide()
	arg0_11:ShowGuildTaskTip()
end

function var0_0.initItems(arg0_16)
	local var0_16 = getProxy(DailyLevelProxy)

	var0_16:setDailyTip(false)

	arg0_16.dailyCounts = var0_16:getRawData()

	local var1_16 = pg.expedition_daily_template

	arg0_16.dailyLevelTFs = {}
	arg0_16.dailyList = _.reverse(Clone(var1_16.all))

	for iter0_16 = #arg0_16.dailyList, 1, -1 do
		local var2_16 = var1_16[arg0_16.dailyList[iter0_16]].limit_period
		local var3_16 = var1_16[arg0_16.dailyList[iter0_16]].insert_daily

		if var2_16 and type(var2_16) == "table" then
			if not pg.TimeMgr.GetInstance():inTime(var2_16) then
				table.remove(arg0_16.dailyList, iter0_16)
			end
		elseif var3_16 == 1 then
			table.remove(arg0_16.dailyList, iter0_16)
		end
	end

	arg0_16:sortDailyList()
	arg0_16:updateShowCenter()

	if arg0_16.contextData.dailyLevelId then
		local var4_16 = arg0_16.contextData.dailyLevelId

		table.removebyvalue(arg0_16.dailyList, var4_16)
		table.insert(arg0_16.dailyList, math.ceil(#var1_16.all / 2), var4_16)
	end

	for iter1_16, iter2_16 in pairs(arg0_16.dailyList) do
		arg0_16.dailyLevelTFs[iter2_16] = cloneTplTo(arg0_16.dailylevelTpl, arg0_16.content, iter2_16)
	end
end

function var0_0.sortDailyList(arg0_17)
	if #arg0_17.dailyList % 2 ~= 1 then
		table.insert(arg0_17.dailyList, var3_0)
	end

	table.sort(arg0_17.dailyList, function(arg0_18, arg1_18)
		return tonumber(pg.expedition_daily_template[arg0_18].sort) > tonumber(pg.expedition_daily_template[arg1_18].sort)
	end)
end

function var0_0.updateShowCenter(arg0_19)
	if not arg0_19.dailyList or #arg0_19.dailyList == 0 then
		return
	end

	local var0_19 = #arg0_19.dailyList
	local var1_19 = pg.expedition_daily_template
	local var2_19 = math.ceil(var0_19 / 2)
	local var3_19

	for iter0_19 = 1, var0_19 do
		local var4_19 = var1_19[arg0_19.dailyList[iter0_19]]

		if var4_19.show_with_count and var4_19.show_with_count == 1 then
			local var5_19 = var4_19.id
			local var6_19 = arg0_19.dailyCounts and arg0_19.dailyCounts[var5_19] or 0

			if var4_19.limit_time - var6_19 > 0 then
				var3_19 = var3_19 or iter0_19
			end
		end
	end

	if var3_19 then
		local var7_19 = var2_19 - var3_19 < 0 and true or false
		local var8_19 = math.abs(var2_19 - var3_19)

		for iter1_19 = 1, var8_19 do
			local var9_19

			if var7_19 then
				local var10_19 = table.remove(arg0_19.dailyList, 1)

				table.insert(arg0_19.dailyList, var10_19)
			else
				local var11_19 = table.remove(arg0_19.dailyList, #arg0_19.dailyList)

				table.insert(arg0_19.dailyList, 1, var11_19)
			end
		end
	end
end

function var0_0.displayDailyLevels(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.dailyLevelTFs) do
		arg0_20:initDailyLevel(iter0_20)
	end

	arg0_20.content:GetComponent(typeof(EnhancelScrollView)).onCenterClick = function(arg0_21)
		arg0_20:tryOpenDesc(tonumber(arg0_21.name))
	end
	arg0_20.centerAniItem = nil
	arg0_20.centerCardId = nil
	arg0_20.checkAniTimer = Timer.New(function()
		if not arg0_20.descMode then
			local var0_22
			local var1_22

			for iter0_22, iter1_22 in pairs(arg0_20.dailyLevelTFs) do
				GetComponent(iter1_22, typeof(CanvasGroup)).alpha = 1

				if not var0_22 and not var1_22 then
					var0_22 = iter1_22
					var1_22 = iter1_22
				elseif iter1_22.anchoredPosition.x < var0_22.anchoredPosition.x then
					var0_22 = iter1_22
				elseif iter1_22.anchoredPosition.x > var1_22.anchoredPosition.x then
					var1_22 = iter1_22
				end
			end

			GetComponent(var0_22, typeof(CanvasGroup)).alpha = 0.5
			GetComponent(var1_22, typeof(CanvasGroup)).alpha = 0.5
		end

		for iter2_22, iter3_22 in pairs(arg0_20.dailyLevelTFs) do
			local var2_22 = iter3_22.localScale.x >= 0.98

			if arg0_20.centerAniItem == iter3_22 and var2_22 then
				return
			else
				if var2_22 then
					arg0_20.centerAniItem = iter3_22
					arg0_20.centerCardId = iter2_22
				end

				local var3_22 = iter3_22:Find("icon/card")

				if var3_22 then
					local var4_22 = var3_22:Find("mask/char"):GetComponent(typeof(Animator))
					local var5_22 = var3_22:Find("effect")

					setActive(var5_22, var2_22)

					if var4_22 then
						var4_22.speed = var2_22 and 1 or 0
					end
				end
			end
		end
	end, 0.1, -1)

	arg0_20.checkAniTimer:Start()
end

function var0_0.tryOpenDesc(arg0_23, arg1_23)
	local var0_23 = arg0_23.dailyLevelTFs[arg1_23]
	local var1_23 = pg.expedition_daily_template[arg1_23]

	if table.contains(var1_23.weekday, tonumber(arg0_23:getWeek())) then
		arg0_23:openDailyDesc(arg1_23)
	else
		pg.TipsMgr.GetInstance():ShowTips(var1_23.tips)
	end
end

function var0_0.CanOpenDailyLevel(arg0_24)
	local var0_24 = pg.expedition_daily_template[arg0_24]
	local var1_24 = false

	if table.contains(var0_24.weekday, tonumber(var0_0.getWeek())) then
		var1_24 = true
	end

	return var1_24, var0_24.tips
end

function var0_0.getNextCardId(arg0_25, arg1_25)
	local var0_25 = table.indexof(arg0_25.dailyList, arg0_25.centerCardId)

	if arg1_25 then
		var0_25 = var0_25 - 1

		if var0_25 <= 0 then
			var0_25 = #arg0_25.dailyList or var0_25
		end
	else
		var0_25 = var0_25 + 1
		var0_25 = var0_25 > #arg0_25.dailyList and 1 or var0_25
	end

	return arg0_25.dailyList[var0_25]
end

function var0_0.initDailyLevel(arg0_26, arg1_26)
	local var0_26 = pg.expedition_daily_template[arg1_26]
	local var1_26 = arg0_26.dailyLevelTFs[arg1_26]
	local var2_26 = table.contains(var0_26.weekday, tonumber(arg0_26:getWeek()))

	if var2_26 then
		arg0_26.index = arg1_26
	end

	setActive(findTF(var1_26, "lock"), not var2_26 and not table.isEmpty(var0_26.weekday))
	setText(findTF(var1_26, "name"), var0_26.title)
	setActive(findTF(var1_26, "time"), false)

	if arg0_26.bonusActivity and not arg0_26.bonusActivity:isEnd() then
		local var3_26 = checkExist(underscore.detect(arg0_26.bonusActivity:getConfig("config_data"), function(arg0_27)
			return arg0_27[1] == arg1_26
		end), {
			2
		})

		setText(var1_26:Find("bonus/Text"), i18n("dailyLevel_bonus_activity"))
		setActive(var1_26:Find("bonus"), tobool(var3_26))

		if var3_26 then
			updateDrop(var1_26:Find("bonus/IconTpl"), Drop.Create(var3_26))
		end
	else
		setActive(var1_26:Find("bonus"), false)
	end

	local var4_26 = findTF(var1_26, "icon")

	PoolMgr.GetInstance():GetPrefab("dailyui/" .. var0_26.pic, "", true, function(arg0_28)
		arg0_28 = tf(arg0_28)

		arg0_28:SetParent(var4_26, false)

		arg0_28.localPosition = Vector3.zero
		arg0_28.name = "card"
	end)
	setText(findTF(var1_26, "Text"), "")
	setActive(findTF(var1_26, "lastTime"), false)

	local var5_26 = Clone(var0_26.limit_period)
	local var6_26

	if var5_26 and type(var5_26) == "table" and pg.TimeMgr.GetInstance():inTime(var5_26) then
		local var7_26 = pg.TimeMgr.GetInstance():GetServerTime()

		var6_26 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5_26[2][1][1],
			month = var5_26[2][1][2],
			day = var5_26[2][1][3],
			hour = var5_26[2][2][1],
			min = var5_26[2][2][2],
			sec = var5_26[2][2][3]
		}) - var7_26
	end

	if var6_26 then
		local var8_26 = ""
		local var9_26 = ""

		if var6_26 > 86400 then
			var8_26 = math.floor(tonumber(var6_26) / 86400)
			var9_26 = i18n("word_date")
		elseif var6_26 >= 3600 then
			var8_26 = math.floor(tonumber(var6_26) / 3600)
			var9_26 = i18n("word_hour")
		elseif var6_26 > 0 then
			var8_26 = math.floor(tonumber(var6_26) / 60)
			var9_26 = i18n("word_minute")
		end

		setText(findTF(var1_26, "lastTime/content/text"), tostring(var8_26) .. " ")
		setText(findTF(var1_26, "lastTime/content/word"), tostring(var9_26))
		setActive(findTF(var1_26, "lastTime"), true)
	end

	arg0_26:UpdateDailyLevelCnt(arg1_26)
end

function var0_0.UpdateDailyLevelCnt(arg0_29, arg1_29)
	local var0_29 = pg.expedition_daily_template[arg1_29]
	local var1_29 = arg0_29.dailyLevelTFs[arg1_29]
	local var2_29 = findTF(var1_29, "count")
	local var3_29 = arg0_29.dailyCounts[arg1_29] or 0

	if var0_29.limit_time == 0 then
		setText(var2_29, "N/A")
	else
		setText(var2_29, string.format("%d/%d", var0_29.limit_time - var3_29, var0_29.limit_time))
	end

	setActive(var2_29, var0_29.limit_time > 0)
end

function var0_0.openDailyDesc(arg0_30, arg1_30)
	arg0_30.curId = arg1_30

	arg0_30:enableDescMode(true)
	arg0_30:displayStageList(arg1_30)
end

function var0_0.UpdateDailyLevelCntForDescPanel(arg0_31, arg1_31)
	local var0_31 = pg.expedition_daily_template[arg1_31]
	local var1_31 = arg0_31.dailyCounts[arg1_31] or 0

	if var0_31.limit_time == 0 then
		setText(arg0_31.descChallengeText, i18n("challenge_count_unlimit"))
	else
		setText(arg0_31.descChallengeText, string.format("%d/%d", var0_31.limit_time - var1_31, var0_31.limit_time))
	end
end

function var0_0.displayStageList(arg0_32, arg1_32)
	arg0_32.dailyLevelId = arg1_32
	arg0_32.contextData.dailyLevelId = arg0_32.dailyLevelId

	local var0_32 = pg.expedition_daily_template[arg1_32]

	arg0_32:UpdateDailyLevelCntForDescPanel(arg1_32)
	setActive(arg0_32.challengeQuotaDaily, var0_32.limit_type == 1)
	setActive(arg0_32.challengeQuotaWeekly, var0_32.limit_type == 2)
	removeAllChildren(arg0_32.stageContain)

	arg0_32.stageTFs = {}

	local var1_32 = _.sort(var0_32.expedition_and_lv_limit_list, function(arg0_33, arg1_33)
		local var0_33 = arg0_33[2] <= arg0_32.player.level and 1 or 0
		local var1_33 = arg1_33[2] <= arg0_32.player.level and 1 or 0

		if arg0_33[2] == arg1_33[2] then
			return arg0_33[1] < arg1_33[1]
		end

		if var0_33 == var1_33 then
			if var0_33 == 1 then
				return arg0_33[2] > arg1_33[2]
			else
				return arg0_33[2] < arg1_33[2]
			end
		else
			return var1_33 < var0_33
		end
	end)

	for iter0_32, iter1_32 in ipairs(var1_32) do
		local var2_32 = iter1_32[1]
		local var3_32 = iter1_32[2]

		arg0_32.stageTFs[var2_32] = cloneTplTo(arg0_32.stageTpl, arg0_32.stageContain)

		local var4_32 = {
			id = var2_32,
			level = var3_32
		}

		arg0_32:updateStage(var4_32)
	end
end

function var0_0.updateStageTF(arg0_34, arg1_34, arg2_34)
	local var0_34 = pg.expedition_data_template[arg2_34.id]

	setText(findTF(arg1_34, "left_panel/name"), var0_34.name)
	setText(findTF(arg1_34, "left_panel/lv/Text"), "Lv." .. arg2_34.level)

	local var1_34 = arg1_34:Find("mask")

	setActive(var1_34, arg2_34.level > arg0_34.player.level)

	if arg2_34.level > arg0_34.player.level then
		setText(var1_34:Find("msg/msg_contain/Text"), "Lv." .. arg2_34.level .. " ")

		if PLATFORM_CODE == PLATFORM_US then
			var1_34:Find("msg/msg_contain/Text"):SetAsLastSibling()
		end
	end

	local var2_34 = UIItemList.New(arg1_34:Find("scrollView/right_panel"), arg0_34.itemTpl)

	var2_34:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = var0_34.award_display[arg1_35 + 1]

			updateDrop(arg2_35, {
				type = var0_35[1],
				id = var0_35[2],
				count = var0_35[3]
			})
			setActive(arg2_35, arg1_35 <= 3)
		end
	end)
	var2_34:align(#var0_34.award_display)
	setImageSprite(arg1_34, getImageSprite(findTF(arg0_34.resource, "normal_bg")))
	setActive(findTF(arg1_34, "score"), false)
	onButton(arg0_34, var1_34, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_unopened"))
	end, SFX_PANEL)
end

function var0_0.updateStage(arg0_37, arg1_37)
	local var0_37 = arg0_37.stageTFs[arg1_37.id]:Find("info")

	arg0_37:updateStageTF(var0_37, arg1_37)
	onButton(arg0_37, var0_37, function()
		if getProxy(DailyLevelProxy):CanQuickBattle(arg1_37.id) then
			local var0_38 = pg.expedition_daily_template[arg0_37.dailyLevelId]

			if (arg0_37.dailyCounts[arg0_37.dailyLevelId] or 0) >= var0_38.limit_time then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

				return
			end

			if LeanTween.isTweening(go(arg0_37.descMain)) or LeanTween.isTweening(go(arg0_37.listPanel)) then
				return
			end

			arg0_37:OnSelectStage(arg1_37)
		else
			arg0_37:OnOpenPreCombat(arg1_37)
		end
	end, SFX_PANEL)
end

function var0_0.OnOpenPreCombat(arg0_39, arg1_39)
	local var0_39 = pg.expedition_daily_template[arg0_39.dailyLevelId]

	if (arg0_39.dailyCounts[arg0_39.dailyLevelId] or 0) >= var0_39.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	setActive(arg0_39.blurPanel, false)
	arg0_39:emit(DailyLevelMediator.ON_STAGE, arg1_39)
end

function var0_0.OnSelectStage(arg0_40, arg1_40)
	local var0_40 = arg0_40.selectedPanel:Find("stagetpl/info")

	onButton(arg0_40, var0_40, function()
		arg0_40:EnableOrDisable(arg1_40, false)
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.selectedPanel, function()
		arg0_40:EnableOrDisable(arg1_40, false)
	end, SFX_PANEL)
	arg0_40:EnableOrDisable(arg1_40, true)
end

function var0_0.EnableOrDisable(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.stageTFs[arg1_43.id]:Find("quickly")

	if LeanTween.isTweening(go(arg0_43.stageContain)) or LeanTween.isTweening(go(arg0_43.selQuicklyTF)) then
		return
	end

	local var1_43 = arg0_43.stageContain:GetComponent(typeof(VerticalLayoutGroup)).padding.top
	local var2_43 = arg0_43.stageContain.parent:InverseTransformPoint(var0_43.parent.position)
	local var3_43 = -1 * var1_43 - var2_43.y

	if arg2_43 then
		arg0_43:updateStageTF(arg0_43.selStageTF, arg1_43)
		arg0_43:UpdateBattleBtn(arg1_43)
		arg0_43:DoSelectedAnimation(var0_43, var3_43, function()
			arg0_43.selectedStage = arg1_43
		end)
	else
		arg0_43:DoUnselectAnimtion(var0_43, function()
			arg0_43.selectedStage = nil
		end)
	end
end

function var0_0.DoSelectedAnimation(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = math.abs(arg2_46) / 2000

	seriesAsync({
		function(arg0_47)
			arg0_46.stageScrollRect.enabled = false

			pg.UIMgr.GetInstance():BlurPanel(arg0_46.selectedPanel)

			arg1_46.sizeDelta = Vector2(arg1_46.sizeDelta.x, 0)

			setActive(arg1_46, true)

			local var0_47 = arg0_46.stageContain.anchoredPosition

			arg0_46.stageContainLposY = var0_47.y
			arg0_46.offsetY = arg2_46

			LeanTween.value(go(arg0_46.stageContain), var0_47.y, var0_47.y + arg2_46, var0_46):setOnUpdate(System.Action_float(function(arg0_48)
				arg0_46.stageContain.anchoredPosition = Vector3(var0_47.x, arg0_48, 0)

				local var0_48 = arg0_46.selectedPanel:InverseTransformPoint(arg1_46.parent.position)

				arg0_46.selStageTF.parent.localPosition = Vector3(var0_48.x, var0_48.y, 0)
				arg0_46.selQuicklyTF.sizeDelta = Vector2(arg0_46.selQuicklyTF.sizeDelta.x, 0)

				setActive(arg0_46.selectedPanel, true)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_47))
		end,
		function(arg0_49)
			local var0_49 = arg1_46:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_46.selQuicklyTF), 0, arg0_46.selQuicklyTFSizeDeltaY, 0.1):setOnUpdate(System.Action_float(function(arg0_50)
				var0_49.preferredHeight = arg0_50
				arg0_46.selQuicklyTF.sizeDelta = Vector2(arg0_46.selQuicklyTF.sizeDelta.x, arg0_50)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_49))
		end
	}, arg3_46)
end

function var0_0.DoUnselectAnimtion(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51.stageContain.anchoredPosition

	seriesAsync({
		function(arg0_52)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_51.selectedPanel, arg0_51._tf)
			setActive(arg0_51.selectedPanel, false)

			local var0_52 = arg1_51:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0_51.selQuicklyTF), arg0_51.selQuicklyTFSizeDeltaY, 0, 0.1):setOnUpdate(System.Action_float(function(arg0_53)
				var0_52.preferredHeight = arg0_53
				arg0_51.selQuicklyTF.sizeDelta = Vector2(arg0_51.selQuicklyTF.sizeDelta.x, arg0_53)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_52))
		end,
		function(arg0_54)
			local var0_54 = var0_51.y - arg0_51.offsetY
			local var1_54 = var0_54 / 2000

			LeanTween.value(go(arg0_51.stageContain), var0_51.y, var0_54, 0.15):setOnUpdate(System.Action_float(function(arg0_55)
				arg0_51.stageContain.anchoredPosition = Vector3(var0_51.x, arg0_55, 0)
			end)):setDelay(0.1):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0_54))
		end
	}, function()
		arg0_51.stageScrollRect.enabled = true

		arg2_51()
	end)
end

function var0_0.UpdateBattleBtn(arg0_57, arg1_57)
	local var0_57 = arg0_57.selectedPanel:Find("stagetpl/info").parent:Find("quickly/bg")
	local var1_57 = pg.expedition_daily_template[arg0_57.dailyLevelId].limit_time - (arg0_57.dailyCounts[arg0_57.dailyLevelId] or 0)
	local var2_57 = var0_57:Find("challenge")

	onButton(arg0_57, var2_57, function()
		arg0_57:OnOpenPreCombat(arg1_57)
	end, SFX_PANEL)
	setText(var2_57:Find("Text"), i18n("daily_level_quick_battle_label2"))

	local var3_57 = var0_57:Find("mult")

	onButton(arg0_57, var3_57, function()
		arg0_57:OnQuickBattle(arg1_57, var1_57)
	end, SFX_PANEL)

	local var4_57 = var0_57:Find("once")

	onButton(arg0_57, var4_57, function()
		arg0_57:OnQuickBattle(arg1_57, 1)
	end, SFX_PANEL)
	setText(var3_57:Find("label"), i18n("daily_level_quick_battle_label1", "   ", COLOR_WHITE))
	setText(var3_57:Find("Text"), "<color=" .. COLOR_GREEN .. ">" .. math.max(1, var1_57) .. "</color>")
	setText(var4_57:Find("label"), i18n("daily_level_quick_battle_label3"))
	setText(var4_57:Find("Text"), "")

	if var1_57 == 0 then
		arg0_57:EnableOrDisable(arg1_57, false)
	end
end

function var0_0.OnQuickBattle(arg0_61, arg1_61, arg2_61)
	if arg2_61 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	if PlayerPrefs.GetInt("daily_level_quick_battle_tip", 0) == 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dailyLevel_quickfinish"),
			onYes = function()
				arg0_61:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_61.dailyLevelId, arg1_61.id, arg2_61)
			end
		})
		PlayerPrefs.SetInt("daily_level_quick_battle_tip", 1)
		PlayerPrefs.Save()
	else
		arg0_61:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0_61.dailyLevelId, arg1_61.id, arg2_61)
	end
end

function var0_0.enableDescMode(arg0_63, arg1_63, arg2_63)
	arg0_63.descMode = arg1_63

	setActive(arg0_63._tf:Find("help_btn"), not arg1_63)

	local function var0_63(arg0_64, arg1_64, arg2_64)
		if LeanTween.isTweening(go(arg0_64)) then
			LeanTween.cancel(go(arg0_64))
		end

		LeanTween.moveX(rtf(arg0_64), arg1_64, 0.3):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
			if arg2_64 then
				arg2_64()
			end
		end))
	end

	local function var1_63()
		for iter0_66, iter1_66 in pairs(arg0_63.dailyLevelTFs) do
			setButtonEnabled(iter1_66, not arg1_63)

			if iter0_66 ~= arg0_63.curId then
				if LeanTween.isTweening(go(iter1_66)) then
					LeanTween.cancel(go(iter1_66))
				end

				local var0_66 = GetComponent(iter1_66, typeof(CanvasGroup))

				if arg1_63 then
					LeanTween.value(go(iter1_66), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_67)
						var0_66.alpha = arg0_67
					end))
				else
					LeanTween.value(go(iter1_66), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_68)
						var0_66.alpha = arg0_68
					end))
				end
			end
		end
	end

	local function var2_63()
		setActive(arg0_63.listPanel, true)
		setActive(arg0_63.content, true)
		setActive(arg0_63.descPanel, arg1_63)
		setActive(arg0_63.arrows, not arg1_63)
	end

	if arg1_63 then
		var2_63()
		var1_63()
		var0_63(arg0_63.listPanel, -622, function()
			var0_63(arg0_63.descMain, 0, arg2_63)
		end)
	else
		if arg0_63.selectedStage then
			arg0_63:EnableOrDisable(arg0_63.selectedStage, false)
		end

		var2_63()
		var1_63()
		var0_63(arg0_63.listPanel, 0)
		var0_63(arg0_63.descMain, -1342, arg2_63)
	end
end

function var0_0.flipToSpecificCard(arg0_71, arg1_71)
	local var0_71 = arg0_71.content:GetComponent(typeof(EnhancelScrollView))

	for iter0_71, iter1_71 in pairs(arg0_71.dailyLevelTFs) do
		if arg1_71 == iter0_71 then
			local var1_71 = iter1_71:GetComponent(typeof(EnhanceItem))

			var0_71:SetHorizontalTargetItemIndex(var1_71.scrollViewItemIndex)
		end
	end
end

function var0_0.tryPlayGuide(arg0_72)
	pg.SystemGuideMgr.GetInstance():PlayDailyLevel(function()
		triggerButton(arg0_72._tf:Find("help_btn"))
	end)
end

function var0_0.ShowGuildTaskTip(arg0_74)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForDailyBattle()
end

function var0_0.clearTween(arg0_75)
	if arg0_75.tweens then
		cancelTweens(arg0_75.tweens)
	end

	local function var0_75(arg0_76)
		if LeanTween.isTweening(go(arg0_76)) then
			LeanTween.cancel(go(arg0_76))
		end
	end

	for iter0_75, iter1_75 in pairs(arg0_75.dailyLevelTFs) do
		var0_75(iter1_75)
	end

	var0_75(arg0_75.listPanel)
	var0_75(arg0_75.descMain)
end

function var0_0.onBackPressed(arg0_77)
	if arg0_77.descMode then
		if LeanTween.isTweening(go(arg0_77.stageContain)) or LeanTween.isTweening(go(arg0_77.selQuicklyTF)) then
			return
		end

		arg0_77:enableDescMode(false)

		return
	end

	var0_0.super.onBackPressed(arg0_77)
end

function var0_0.willExit(arg0_78)
	if arg0_78.selectedStage then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_78.selectedPanel, arg0_78._tf)
	end

	arg0_78:clearTween()

	if arg0_78.checkAniTimer then
		arg0_78.checkAniTimer:Stop()

		arg0_78.checkAniTimer = nil
	end
end

return var0_0
