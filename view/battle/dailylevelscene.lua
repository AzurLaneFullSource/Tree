local var0 = class("DailyLevelScene", import("..base.BaseUI"))
local var1 = 3
local var2 = 4
local var3 = 101

function var0.getUIName(arg0)
	return "dailylevelui"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.init(arg0)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("blur_panel/adapt/top")
	arg0.backBtn = arg0:findTF("back_button", arg0.topPanel)
	arg0.listPanel = arg0:findTF("list_panel")
	arg0.content = arg0:findTF("list", arg0.listPanel)

	setActive(arg0.content, true)

	arg0.dailylevelTpl = arg0:getTpl("list_panel/list/captertpl")
	arg0.descPanel = arg0:findTF("desc_panel")
	arg0.selectedPanel = arg0.descPanel:Find("selected")
	arg0.descMain = arg0:findTF("main_mask/main", arg0.descPanel)
	arg0.stageTpl = arg0:getTpl("scrollview/content/stagetpl", arg0.descMain)
	arg0.stageScrollRect = arg0:findTF("scrollview", arg0.descMain):GetComponent(typeof(ScrollRect))
	arg0.stageContain = arg0:findTF("scrollview/content", arg0.descMain)
	arg0.arrows = arg0:findTF("arrows")
	arg0.itemTpl = arg0:getTpl("item_tpl")
	arg0.selStageTF = arg0.selectedPanel:Find("stagetpl/info")
	arg0.selQuicklyTF = arg0.selStageTF.parent:Find("quickly/bg")
	arg0.selQuicklyTFSizeDeltaY = arg0.selQuicklyTF.sizeDelta.y
	arg0.descChallengeNum = arg0:findTF("challenge_count", arg0.descMain)
	arg0.descChallengeText = arg0:findTF("Text", arg0.descChallengeNum)
	arg0.challengeQuotaDaily = arg0:findTF("challenge_count/label", arg0.descMain)
	arg0.challengeQuotaWeekly = arg0:findTF("challenge_count/week_label", arg0.descMain)
	arg0.fleetEditView = arg0:findTF("fleet_edit")
	arg0.resource = arg0:findTF("resource")
	arg0.rightBtn = arg0:findTF("arrows/arrow1")
	arg0.leftBtn = arg0:findTF("arrows/arrow2")

	arg0:initItems()
end

function var0.getWeek()
	return (pg.TimeMgr.GetInstance():GetServerWeek())
end

function var0.setDailyCounts(arg0, arg1)
	arg0.dailyCounts = arg1
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.updateRes(arg0, arg1)
	arg0.player = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_daily_task.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		if arg0.descMode then
			if LeanTween.isTweening(go(arg0.stageContain)) or LeanTween.isTweening(go(arg0.selQuicklyTF)) then
				return
			end

			arg0:enableDescMode(false)
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.leftBtn, function()
		arg0:flipToSpecificCard(arg0:getNextCardId(true))
	end)
	onButton(arg0, arg0.rightBtn, function()
		arg0:flipToSpecificCard(arg0:getNextCardId(false))
	end)
	arg0:displayDailyLevels()

	if arg0.contextData.dailyLevelId then
		arg0:tryOpenDesc(arg0.contextData.dailyLevelId)
	else
		arg0:enableDescMode(false)
	end

	arg0:tryPlayGuide()
	arg0:ShowGuildTaskTip()
end

function var0.initItems(arg0)
	local var0 = getProxy(DailyLevelProxy)

	var0:setDailyTip(false)

	arg0.dailyCounts = var0:getRawData()

	local var1 = pg.expedition_daily_template

	arg0.dailyLevelTFs = {}
	arg0.dailyList = _.reverse(Clone(var1.all))

	for iter0 = #arg0.dailyList, 1, -1 do
		local var2 = var1[arg0.dailyList[iter0]].limit_period
		local var3 = var1[arg0.dailyList[iter0]].insert_daily

		if var2 and type(var2) == "table" then
			if not pg.TimeMgr:GetInstance():inTime(var2) then
				table.remove(arg0.dailyList, iter0)
			end
		elseif var3 == 1 then
			table.remove(arg0.dailyList, iter0)
		end
	end

	arg0:sortDailyList()
	arg0:updateShowCenter()

	if arg0.contextData.dailyLevelId then
		local var4 = arg0.contextData.dailyLevelId

		table.removebyvalue(arg0.dailyList, var4)
		table.insert(arg0.dailyList, math.ceil(#var1.all / 2), var4)
	end

	for iter1, iter2 in pairs(arg0.dailyList) do
		arg0.dailyLevelTFs[iter2] = cloneTplTo(arg0.dailylevelTpl, arg0.content, iter2)
	end
end

function var0.sortDailyList(arg0)
	if #arg0.dailyList % 2 ~= 1 then
		table.insert(arg0.dailyList, var3)
	end

	table.sort(arg0.dailyList, function(arg0, arg1)
		return tonumber(pg.expedition_daily_template[arg0].sort) > tonumber(pg.expedition_daily_template[arg1].sort)
	end)
end

function var0.updateShowCenter(arg0)
	if not arg0.dailyList or #arg0.dailyList == 0 then
		return
	end

	local var0 = #arg0.dailyList
	local var1 = pg.expedition_daily_template
	local var2 = math.ceil(var0 / 2)
	local var3

	for iter0 = 1, var0 do
		local var4 = var1[arg0.dailyList[iter0]]

		if var4.show_with_count and var4.show_with_count == 1 then
			local var5 = var4.id
			local var6 = arg0.dailyCounts and arg0.dailyCounts[var5] or 0

			if var4.limit_time - var6 > 0 then
				var3 = var3 or iter0
			end
		end
	end

	if var3 then
		local var7 = var2 - var3 < 0 and true or false
		local var8 = math.abs(var2 - var3)

		for iter1 = 1, var8 do
			local var9

			if var7 then
				local var10 = table.remove(arg0.dailyList, 1)

				table.insert(arg0.dailyList, var10)
			else
				local var11 = table.remove(arg0.dailyList, #arg0.dailyList)

				table.insert(arg0.dailyList, 1, var11)
			end
		end
	end
end

function var0.displayDailyLevels(arg0)
	for iter0, iter1 in pairs(arg0.dailyLevelTFs) do
		arg0:initDailyLevel(iter0)
	end

	arg0.content:GetComponent(typeof(EnhancelScrollView)).onCenterClick = function(arg0)
		arg0:tryOpenDesc(tonumber(arg0.name))
	end
	arg0.centerAniItem = nil
	arg0.centerCardId = nil
	arg0.checkAniTimer = Timer.New(function()
		if not arg0.descMode then
			local var0
			local var1

			for iter0, iter1 in pairs(arg0.dailyLevelTFs) do
				GetComponent(iter1, typeof(CanvasGroup)).alpha = 1

				if not var0 and not var1 then
					var0 = iter1
					var1 = iter1
				elseif iter1.anchoredPosition.x < var0.anchoredPosition.x then
					var0 = iter1
				elseif iter1.anchoredPosition.x > var1.anchoredPosition.x then
					var1 = iter1
				end
			end

			GetComponent(var0, typeof(CanvasGroup)).alpha = 0.5
			GetComponent(var1, typeof(CanvasGroup)).alpha = 0.5
		end

		for iter2, iter3 in pairs(arg0.dailyLevelTFs) do
			local var2 = iter3.localScale.x >= 0.98

			if arg0.centerAniItem == iter3 and var2 then
				return
			else
				if var2 then
					arg0.centerAniItem = iter3
					arg0.centerCardId = iter2
				end

				local var3 = arg0:findTF("icon/card", iter3)

				if var3 then
					local var4 = arg0:findTF("mask/char", var3):GetComponent(typeof(Animator))
					local var5 = arg0:findTF("effect", var3)

					setActive(var5, var2)

					if var4 then
						var4.speed = var2 and 1 or 0
					end
				end
			end
		end
	end, 0.1, -1)

	arg0.checkAniTimer:Start()
end

function var0.tryOpenDesc(arg0, arg1)
	local var0 = arg0.dailyLevelTFs[arg1]
	local var1 = pg.expedition_daily_template[arg1]

	if table.contains(var1.weekday, tonumber(arg0:getWeek())) then
		arg0:openDailyDesc(arg1)
	else
		pg.TipsMgr.GetInstance():ShowTips(var1.tips)
	end
end

function var0.CanOpenDailyLevel(arg0)
	local var0 = pg.expedition_daily_template[arg0]
	local var1 = false

	if table.contains(var0.weekday, tonumber(var0.getWeek())) then
		var1 = true
	end

	return var1, var0.tips
end

function var0.getNextCardId(arg0, arg1)
	local var0 = table.indexof(arg0.dailyList, arg0.centerCardId)

	if arg1 then
		var0 = var0 - 1

		if var0 <= 0 then
			var0 = #arg0.dailyList or var0
		end
	else
		var0 = var0 + 1
		var0 = var0 > #arg0.dailyList and 1 or var0
	end

	return arg0.dailyList[var0]
end

function var0.initDailyLevel(arg0, arg1)
	local var0 = pg.expedition_daily_template[arg1]
	local var1 = arg0.dailyLevelTFs[arg1]
	local var2 = table.contains(var0.weekday, tonumber(arg0:getWeek()))

	if var2 then
		arg0.index = arg1
	end

	setActive(findTF(var1, "lock"), not var2 and not table.isEmpty(var0.weekday))
	setText(findTF(var1, "name"), var0.title)
	setActive(findTF(var1, "time"), false)

	local var3 = findTF(var1, "icon")

	PoolMgr.GetInstance():GetPrefab("dailyui/" .. var0.pic, "", true, function(arg0)
		arg0 = tf(arg0)

		arg0:SetParent(var3, false)

		arg0.localPosition = Vector3.zero
		arg0.name = "card"
	end)
	setText(findTF(var1, "Text"), "")
	setActive(findTF(var1, "lastTime"), false)

	local var4 = Clone(var0.limit_period)
	local var5

	if var4 and type(var4) == "table" and pg.TimeMgr:GetInstance():inTime(var4) then
		local var6 = pg.TimeMgr:GetInstance():GetServerTime()

		var5 = pg.TimeMgr:GetInstance():Table2ServerTime({
			year = var4[2][1][1],
			month = var4[2][1][2],
			day = var4[2][1][3],
			hour = var4[2][2][1],
			min = var4[2][2][2],
			sec = var4[2][2][3]
		}) - var6
	end

	if var5 then
		local var7 = ""
		local var8 = ""

		if var5 > 86400 then
			var7 = math.floor(tonumber(var5) / 86400)
			var8 = i18n("word_date")
		elseif var5 >= 3600 then
			var7 = math.floor(tonumber(var5) / 3600)
			var8 = i18n("word_hour")
		elseif var5 > 0 then
			var7 = math.floor(tonumber(var5) / 60)
			var8 = i18n("word_minute")
		end

		setText(findTF(var1, "lastTime/content/text"), tostring(var7) .. " ")
		setText(findTF(var1, "lastTime/content/word"), tostring(var8))
		setActive(findTF(var1, "lastTime"), true)
	end

	arg0:UpdateDailyLevelCnt(arg1)
end

function var0.UpdateDailyLevelCnt(arg0, arg1)
	local var0 = pg.expedition_daily_template[arg1]
	local var1 = arg0.dailyLevelTFs[arg1]
	local var2 = findTF(var1, "count")
	local var3 = arg0.dailyCounts[arg1] or 0

	if var0.limit_time == 0 then
		setText(var2, "N/A")
	else
		setText(var2, string.format("%d/%d", var0.limit_time - var3, var0.limit_time))
	end

	setActive(var2, var0.limit_time > 0)
end

function var0.openDailyDesc(arg0, arg1)
	arg0.curId = arg1

	arg0:enableDescMode(true)
	arg0:displayStageList(arg1)
end

function var0.UpdateDailyLevelCntForDescPanel(arg0, arg1)
	local var0 = pg.expedition_daily_template[arg1]
	local var1 = arg0.dailyCounts[arg1] or 0

	if var0.limit_time == 0 then
		setText(arg0.descChallengeText, i18n("challenge_count_unlimit"))
	else
		setText(arg0.descChallengeText, string.format("%d/%d", var0.limit_time - var1, var0.limit_time))
	end
end

function var0.displayStageList(arg0, arg1)
	arg0.dailyLevelId = arg1
	arg0.contextData.dailyLevelId = arg0.dailyLevelId

	local var0 = pg.expedition_daily_template[arg1]

	arg0:UpdateDailyLevelCntForDescPanel(arg1)
	setActive(arg0.challengeQuotaDaily, var0.limit_type == 1)
	setActive(arg0.challengeQuotaWeekly, var0.limit_type == 2)
	removeAllChildren(arg0.stageContain)

	arg0.stageTFs = {}

	local var1 = _.sort(var0.expedition_and_lv_limit_list, function(arg0, arg1)
		local var0 = arg0[2] <= arg0.player.level and 1 or 0
		local var1 = arg1[2] <= arg0.player.level and 1 or 0

		if arg0[2] == arg1[2] then
			return arg0[1] < arg1[1]
		end

		if var0 == var1 then
			if var0 == 1 then
				return arg0[2] > arg1[2]
			else
				return arg0[2] < arg1[2]
			end
		else
			return var1 < var0
		end
	end)

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1[1]
		local var3 = iter1[2]

		arg0.stageTFs[var2] = cloneTplTo(arg0.stageTpl, arg0.stageContain)

		local var4 = {
			id = var2,
			level = var3
		}

		arg0:updateStage(var4)
	end
end

function var0.updateStageTF(arg0, arg1, arg2)
	local var0 = pg.expedition_data_template[arg2.id]

	setText(findTF(arg1, "left_panel/name"), var0.name)
	setText(findTF(arg1, "left_panel/lv/Text"), "Lv." .. arg2.level)

	local var1 = arg0:findTF("mask", arg1)

	setActive(var1, arg2.level > arg0.player.level)

	if arg2.level > arg0.player.level then
		setText(arg0:findTF("msg/msg_contain/Text", var1), "Lv." .. arg2.level .. " ")

		if PLATFORM_CODE == PLATFORM_US then
			arg0:findTF("msg/msg_contain/Text", var1):SetAsLastSibling()
		end
	end

	local var2 = UIItemList.New(arg0:findTF("scrollView/right_panel", arg1), arg0.itemTpl)

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0.award_display[arg1 + 1]

			updateDrop(arg2, {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			})
			setActive(arg2, arg1 <= 3)
		end
	end)
	var2:align(#var0.award_display)
	setImageSprite(arg1, getImageSprite(findTF(arg0.resource, "normal_bg")))
	setActive(findTF(arg1, "score"), false)
	onButton(arg0, var1, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_unopened"))
	end, SFX_PANEL)
end

function var0.updateStage(arg0, arg1)
	local var0 = arg0.stageTFs[arg1.id]:Find("info")

	arg0:updateStageTF(var0, arg1)
	onButton(arg0, var0, function()
		if getProxy(DailyLevelProxy):CanQuickBattle(arg1.id) then
			local var0 = pg.expedition_daily_template[arg0.dailyLevelId]

			if (arg0.dailyCounts[arg0.dailyLevelId] or 0) >= var0.limit_time then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

				return
			end

			if LeanTween.isTweening(go(arg0.descMain)) or LeanTween.isTweening(go(arg0.listPanel)) then
				return
			end

			arg0:OnSelectStage(arg1)
		else
			arg0:OnOpenPreCombat(arg1)
		end
	end, SFX_PANEL)
end

function var0.OnOpenPreCombat(arg0, arg1)
	local var0 = pg.expedition_daily_template[arg0.dailyLevelId]

	if (arg0.dailyCounts[arg0.dailyLevelId] or 0) >= var0.limit_time then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	setActive(arg0.blurPanel, false)
	arg0:emit(DailyLevelMediator.ON_STAGE, arg1)
end

function var0.OnSelectStage(arg0, arg1)
	local var0 = arg0.selectedPanel:Find("stagetpl/info")

	onButton(arg0, var0, function()
		arg0:EnableOrDisable(arg1, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.selectedPanel, function()
		arg0:EnableOrDisable(arg1, false)
	end, SFX_PANEL)
	arg0:EnableOrDisable(arg1, true)
end

function var0.EnableOrDisable(arg0, arg1, arg2)
	local var0 = arg0.stageTFs[arg1.id]:Find("quickly")

	if LeanTween.isTweening(go(arg0.stageContain)) or LeanTween.isTweening(go(arg0.selQuicklyTF)) then
		return
	end

	local var1 = arg0.stageContain:GetComponent(typeof(VerticalLayoutGroup)).padding.top
	local var2 = arg0.stageContain.parent:InverseTransformPoint(var0.parent.position)
	local var3 = -1 * var1 - var2.y

	if arg2 then
		arg0:updateStageTF(arg0.selStageTF, arg1)
		arg0:UpdateBattleBtn(arg1)
		arg0:DoSelectedAnimation(var0, var3, function()
			arg0.selectedStage = arg1
		end)
	else
		arg0:DoUnselectAnimtion(var0, function()
			arg0.selectedStage = nil
		end)
	end
end

function var0.DoSelectedAnimation(arg0, arg1, arg2, arg3)
	local var0 = math.abs(arg2) / 2000

	seriesAsync({
		function(arg0)
			arg0.stageScrollRect.enabled = false

			pg.UIMgr.GetInstance():BlurPanel(arg0.selectedPanel, true, {
				groupName = LayerWeightConst.GROUP_DAILY,
				weight = LayerWeightConst.BASE_LAYER - 1
			})

			arg1.sizeDelta = Vector2(arg1.sizeDelta.x, 0)

			setActive(arg1, true)

			local var0 = arg0.stageContain.anchoredPosition

			arg0.stageContainLposY = var0.y
			arg0.offsetY = arg2

			LeanTween.value(go(arg0.stageContain), var0.y, var0.y + arg2, var0):setOnUpdate(System.Action_float(function(arg0)
				arg0.stageContain.anchoredPosition = Vector3(var0.x, arg0, 0)

				local var0 = arg0.selectedPanel:InverseTransformPoint(arg1.parent.position)

				arg0.selStageTF.parent.localPosition = Vector3(var0.x, var0.y, 0)
				arg0.selQuicklyTF.sizeDelta = Vector2(arg0.selQuicklyTF.sizeDelta.x, 0)

				setActive(arg0.selectedPanel, true)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			local var0 = arg1:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0.selQuicklyTF), 0, arg0.selQuicklyTFSizeDeltaY, 0.1):setOnUpdate(System.Action_float(function(arg0)
				var0.preferredHeight = arg0
				arg0.selQuicklyTF.sizeDelta = Vector2(arg0.selQuicklyTF.sizeDelta.x, arg0)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0))
		end
	}, arg3)
end

function var0.DoUnselectAnimtion(arg0, arg1, arg2)
	local var0 = arg0.stageContain.anchoredPosition

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.selectedPanel, arg0._tf)
			setActive(arg0.selectedPanel, false)

			local var0 = arg1:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(arg0.selQuicklyTF), arg0.selQuicklyTFSizeDeltaY, 0, 0.1):setOnUpdate(System.Action_float(function(arg0)
				var0.preferredHeight = arg0
				arg0.selQuicklyTF.sizeDelta = Vector2(arg0.selQuicklyTF.sizeDelta.x, arg0)
			end)):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			local var0 = var0.y - arg0.offsetY
			local var1 = var0 / 2000

			LeanTween.value(go(arg0.stageContain), var0.y, var0, 0.15):setOnUpdate(System.Action_float(function(arg0)
				arg0.stageContain.anchoredPosition = Vector3(var0.x, arg0, 0)
			end)):setDelay(0.1):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(arg0))
		end
	}, function()
		arg0.stageScrollRect.enabled = true

		arg2()
	end)
end

function var0.UpdateBattleBtn(arg0, arg1)
	local var0 = arg0.selectedPanel:Find("stagetpl/info").parent:Find("quickly/bg")
	local var1 = pg.expedition_daily_template[arg0.dailyLevelId].limit_time - (arg0.dailyCounts[arg0.dailyLevelId] or 0)
	local var2 = var0:Find("challenge")

	onButton(arg0, var2, function()
		arg0:OnOpenPreCombat(arg1)
	end, SFX_PANEL)
	setText(var2:Find("Text"), i18n("daily_level_quick_battle_label2"))

	local var3 = var0:Find("mult")

	onButton(arg0, var3, function()
		arg0:OnQuickBattle(arg1, var1)
	end, SFX_PANEL)

	local var4 = var0:Find("once")

	onButton(arg0, var4, function()
		arg0:OnQuickBattle(arg1, 1)
	end, SFX_PANEL)
	setText(var3:Find("label"), i18n("daily_level_quick_battle_label1", "   ", COLOR_WHITE))
	setText(var3:Find("Text"), "<color=" .. COLOR_GREEN .. ">" .. math.max(1, var1) .. "</color>")
	setText(var4:Find("label"), i18n("daily_level_quick_battle_label3"))
	setText(var4:Find("Text"), "")

	if var1 == 0 then
		arg0:EnableOrDisable(arg1, false)
	end
end

function var0.OnQuickBattle(arg0, arg1, arg2)
	if arg2 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	if PlayerPrefs.GetInt("daily_level_quick_battle_tip", 0) == 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dailyLevel_quickfinish"),
			onYes = function()
				arg0:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0.dailyLevelId, arg1.id, arg2)
			end
		})
		PlayerPrefs.SetInt("daily_level_quick_battle_tip", 1)
		PlayerPrefs.Save()
	else
		arg0:emit(DailyLevelMediator.ON_QUICK_BATTLE, arg0.dailyLevelId, arg1.id, arg2)
	end
end

function var0.enableDescMode(arg0, arg1, arg2)
	arg0.descMode = arg1

	setActive(arg0:findTF("help_btn"), not arg1)

	local function var0(arg0, arg1, arg2)
		if LeanTween.isTweening(go(arg0)) then
			LeanTween.cancel(go(arg0))
		end

		LeanTween.moveX(rtf(arg0), arg1, 0.3):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
			if arg2 then
				arg2()
			end
		end))
	end

	local function var1()
		for iter0, iter1 in pairs(arg0.dailyLevelTFs) do
			setButtonEnabled(iter1, not arg1)

			if iter0 ~= arg0.curId then
				if LeanTween.isTweening(go(iter1)) then
					LeanTween.cancel(go(iter1))
				end

				local var0 = GetComponent(iter1, typeof(CanvasGroup))

				if arg1 then
					LeanTween.value(go(iter1), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0)
						var0.alpha = arg0
					end))
				else
					LeanTween.value(go(iter1), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
						var0.alpha = arg0
					end))
				end
			end
		end
	end

	local function var2()
		setActive(arg0.listPanel, true)
		setActive(arg0.content, true)
		setActive(arg0.descPanel, arg1)
		setActive(arg0.arrows, not arg1)
	end

	if arg1 then
		var2()
		var1()
		var0(arg0.listPanel, -622, function()
			var0(arg0.descMain, 0, arg2)
		end)
	else
		if arg0.selectedStage then
			arg0:EnableOrDisable(arg0.selectedStage, false)
		end

		var2()
		var1()
		var0(arg0.listPanel, 0)
		var0(arg0.descMain, -1342, arg2)
	end
end

function var0.flipToSpecificCard(arg0, arg1)
	local var0 = arg0.content:GetComponent(typeof(EnhancelScrollView))

	for iter0, iter1 in pairs(arg0.dailyLevelTFs) do
		if arg1 == iter0 then
			local var1 = iter1:GetComponent(typeof(EnhanceItem))

			var0:SetHorizontalTargetItemIndex(var1.scrollViewItemIndex)
		end
	end
end

function var0.tryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayDailyLevel(function()
		triggerButton(arg0:findTF("help_btn"))
	end)
end

function var0.ShowGuildTaskTip(arg0)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForDailyBattle()
end

function var0.clearTween(arg0)
	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	local function var0(arg0)
		if LeanTween.isTweening(go(arg0)) then
			LeanTween.cancel(go(arg0))
		end
	end

	for iter0, iter1 in pairs(arg0.dailyLevelTFs) do
		var0(iter1)
	end

	var0(arg0.listPanel)
	var0(arg0.descMain)
end

function var0.onBackPressed(arg0)
	if arg0.descMode then
		if LeanTween.isTweening(go(arg0.stageContain)) or LeanTween.isTweening(go(arg0.selQuicklyTF)) then
			return
		end

		arg0:enableDescMode(false)

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.selectedStage then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.selectedPanel, arg0._tf)
	end

	arg0:clearTween()

	if arg0.checkAniTimer then
		arg0.checkAniTimer:Stop()

		arg0.checkAniTimer = nil
	end
end

return var0
