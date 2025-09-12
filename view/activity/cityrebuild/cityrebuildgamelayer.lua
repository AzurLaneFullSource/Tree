local var0_0 = class("CityRebuildGameLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CityRebuildGameUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg1 = arg0_2._tf:Find("bgs/bg1")
	arg0_2.bg2 = arg0_2._tf:Find("bgs/bg2")
	arg0_2.bg3 = arg0_2._tf:Find("bgs/bg3")
	arg0_2._ship = arg0_2._tf:Find("ship")
	arg0_2._ship2 = arg0_2._tf:Find("ship2")
	arg0_2.effect = arg0_2._tf:Find("effect")
	arg0_2.ui = arg0_2._tf:Find("ui")
	arg0_2.backBtn = arg0_2.ui:Find("top/backBtn")
	arg0_2.homeBtn = arg0_2.ui:Find("top/homeBtn")
	arg0_2.hpSlider = arg0_2.ui:Find("top/hpSlider")
	arg0_2.hp = arg0_2.ui:Find("top/hp")
	arg0_2.firstAwardList = UIItemList.New(arg0_2.ui:Find("top/awardPanel/first/items"), arg0_2.ui:Find("top/awardPanel/first/items/item"))
	arg0_2.ptAwardCount = arg0_2.ui:Find("top/awardPanel/others/count")
	arg0_2.cityLevel = arg0_2.ui:Find("left/cityLevel/Text")
	arg0_2.battleLevel = arg0_2.ui:Find("left/battleLevel/Text")
	arg0_2.summaryPanel = arg0_2.ui:Find("left/panel")
	arg0_2.currentLevel = arg0_2.ui:Find("top/currentLevel/Text")
	arg0_2.enemyName = arg0_2.ui:Find("top/enemyName")
	arg0_2.resultBtn = arg0_2.ui:Find("right/resultBtn")
	arg0_2.bookBtn = arg0_2.ui:Find("right/bookBtn")
	arg0_2.taskBtn = arg0_2.ui:Find("right/taskBtn")
	arg0_2.previousLevelBtn = arg0_2.ui:Find("right/previousLevelBtn")
	arg0_2.nextLevelBtn = arg0_2.ui:Find("right/nextLevelBtn")
	arg0_2.damageAni = arg0_2._tf:Find("damage"):GetComponent(typeof(Animation))
	arg0_2.damageText = arg0_2._tf:Find("damage/Text")
	arg0_2.effect = arg0_2._tf:Find("effect")
	arg0_2.deadEffectList = {
		arg0_2.effect:Find("xinnianyouxi_baozha"),
		arg0_2.effect:Find("xinnianyouxi_baozha2"),
		arg0_2.effect:Find("xinnianyouxi_baozha3")
	}

	setText(arg0_2.ui:Find("left/cityLevel/title"), i18n("ninja_game_citylevel"))
	setText(arg0_2.ui:Find("left/battleLevel/title"), i18n("ninja_game_wave"))
	setText(arg0_2.summaryPanel:Find("buildingDPS"), i18n("ninja_game_citydmg"))
	setText(arg0_2.summaryPanel:Find("charaDPS"), i18n("ninja_game_allydmg"))
	setText(arg0_2.summaryPanel:Find("DPS"), i18n("ninja_game_dps"))
	setText(arg0_2.summaryPanel:Find("time"), i18n("ninja_game_time"))
	setText(arg0_2.summaryPanel:Find("pts"), i18n("ninja_game_income"))
	setText(arg0_2.summaryPanel:Find("pt"), i18n("ninja_game_ptcount"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.bookBtn, function()
		arg0_3:emit(CityRebuildGameMediator.OPEN_BOOK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.taskBtn, function()
		arg0_3:emit(CityRebuildGameMediator.OPEN_TASKS)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.previousLevelBtn, function()
		arg0_3:emit(CityRebuildGameMediator.CHOOSE_LEVEL, arg0_3.activityId, arg0_3.cityRebuildData.curLevel - 1)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.nextLevelBtn, function()
		arg0_3:emit(CityRebuildGameMediator.CHOOSE_LEVEL, arg0_3.activityId, arg0_3.cityRebuildData.curLevel + 1)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.resultBtn, function()
		arg0_3:emit(CityRebuildGameMediator.RESULT, arg0_3.activityId)
	end, SFX_CANCEL)
	arg0_3:BgScroll()
	arg0_3:Refresh()
end

function var0_0.InitData(arg0_11)
	arg0_11.activityId = ActivityConst.NINJA_CITY_ACT_ID
	arg0_11.cityRebuildProxy = getProxy(CityRebuildProxy)
	arg0_11.cityRebuildData = arg0_11.cityRebuildProxy:GetData(arg0_11.activityId)

	if arg0_11.cityRebuildData.startTime == 0 then
		arg0_11:emit(CityRebuildGameMediator.INIT_TIME, arg0_11.activityId)
	end
end

function var0_0.BgScroll(arg0_12)
	local var0_12 = 0.66 * arg0_12._tf.rect.height / 1080

	arg0_12.bg1.localScale = Vector3(var0_12, var0_12, 0)
	arg0_12.bg2.localScale = Vector3(var0_12, var0_12, 0)
	arg0_12.bg3.localScale = Vector3(var0_12, var0_12, 0)

	local var1_12 = arg0_12.bg1.rect.width * var0_12
	local var2_12 = arg0_12.bg2.rect.width * var0_12
	local var3_12 = arg0_12.bg3.rect.width * var0_12

	LeanTween.value(go(arg0_12.bg1), 0, var1_12, 20):setOnUpdate(System.Action_float(function(arg0_13)
		arg0_12.bg1.anchoredPosition = Vector2(arg0_13, 0)
	end)):setEase(LeanTweenType.linear):setLoopClamp()
	LeanTween.value(go(arg0_12.bg2), 0, var2_12, 14):setOnUpdate(System.Action_float(function(arg0_14)
		arg0_12.bg2.anchoredPosition = Vector2(arg0_14, 0)
	end)):setEase(LeanTweenType.linear):setLoopClamp()
	LeanTween.value(go(arg0_12.bg3), 0, var3_12, 10):setOnUpdate(System.Action_float(function(arg0_15)
		arg0_12.bg3.anchoredPosition = Vector2(arg0_15, 0)
	end)):setEase(LeanTweenType.linear):setLoopClamp()
end

function var0_0.Refresh(arg0_16, arg1_16)
	arg0_16.cityRebuildData = arg0_16.cityRebuildProxy:GetData(arg0_16.activityId)

	if not arg1_16 then
		arg0_16:SetSpine()
	end

	setText(arg0_16.cityLevel, "LV." .. arg0_16.cityRebuildData.cityLevel)
	setText(arg0_16.battleLevel, arg0_16.cityRebuildData.maxChooseLevel)
	arg0_16:SetLevelAndAward()
	arg0_16:SetSummaryPanelAndHp()
end

function var0_0.SetSpine(arg0_17)
	arg0_17:ClearSpine()

	arg0_17.prefab = pg.activity_ninja_enemy[arg0_17.cityRebuildData.curLevel].model

	local var0_17 = arg0_17.prefab
	local var1_17 = tonumber(pg.activity_ninja_enemy[arg0_17.cityRebuildData.curLevel].scale)
	local var2_17 = Vector3(-var1_17, var1_17, 1)
	local var3_17 = Vector3(0, -328, 0)
	local var4_17 = Vector3(-600, -328, 0)

	arg0_17.aliveEnemy = 1

	PoolMgr.GetInstance():GetSpineChar(var0_17, true, function(arg0_18)
		if var0_17 ~= arg0_17.prefab or var0_17 == arg0_17.loadedPrefab then
			PoolMgr.GetInstance():ReturnSpineChar(var0_17, arg0_18)

			return
		end

		arg0_17.loadedPrefab = var0_17
		arg0_17.model = arg0_18
		arg0_17.model.transform.localScale = Vector3.one
		arg0_17.model.transform.localPosition = Vector3.zero

		arg0_17.model.transform:SetParent(arg0_17._ship, false)

		arg0_17._ship.localScale = var2_17
		arg0_17.anim = arg0_17.model:GetComponent(typeof(SpineAnimUI))

		arg0_17:WalkSpine(arg0_17.model, arg0_17.anim, arg0_17._ship)
	end)
	PoolMgr.GetInstance():GetSpineChar(var0_17, true, function(arg0_19)
		if var0_17 ~= arg0_17.prefab or var0_17 == arg0_17.loadedPrefab2 then
			PoolMgr.GetInstance():ReturnSpineChar(var0_17, arg0_19)

			return
		end

		arg0_17.loadedPrefab2 = var0_17
		arg0_17.model2 = arg0_19
		arg0_17.model2.transform.localScale = Vector3.one
		arg0_17.model2.transform.localPosition = Vector3.zero

		arg0_17.model2.transform:SetParent(arg0_17._ship2, false)

		arg0_17._ship2.localScale = var2_17
		arg0_17.anim2 = arg0_17.model2:GetComponent(typeof(SpineAnimUI))
	end)
	setActive(arg0_17._ship, true)
	setActive(arg0_17._ship2, false)
end

function var0_0.WalkSpine(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg1_20 and arg2_20 then
		setActive(arg3_20, true)

		local var0_20 = Vector3(0, -4, 0)
		local var1_20 = Vector3(-600, -4, 0)

		arg2_20:SetAction("move", 0)
		LeanTween.value(arg0_20._go, 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_21)
			arg3_20.anchoredPosition3D = Vector3.Lerp(var0_20, var1_20, arg0_21)
		end))
	end
end

function var0_0.DeadSpine(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg1_22 and arg2_22 then
		for iter0_22, iter1_22 in ipairs(arg0_22.deadEffectList) do
			if not isActive(iter1_22) then
				setActive(arg3_22, false)
				setActive(iter1_22, true)
				arg0_22:StartTimers(function()
					setActive(iter1_22, false)
					arg0_22.timerList["effect" .. iter0_22]:Stop()

					arg0_22.timerList["effect" .. iter0_22] = nil
				end, 2, "effect" .. iter0_22)

				break
			end
		end
	end
end

function var0_0.ClearSpine(arg0_24)
	if not IsNil(arg0_24.model) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_24.prefab, arg0_24.model)

		arg0_24.loadedPrefab = nil
	end

	if not IsNil(arg0_24.model2) then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_24.prefab, arg0_24.model2)

		arg0_24.loadedPrefab2 = nil
	end
end

function var0_0.SetLevelAndAward(arg0_25)
	local var0_25 = pg.activity_ninja_enemy[arg0_25.cityRebuildData.curLevel]

	setText(arg0_25.currentLevel, arg0_25.cityRebuildData.curLevel)
	setText(arg0_25.enemyName, var0_25.name)
	arg0_25.firstAwardList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var0_25.first_drop_show[arg1_26 + 1]
			local var1_26 = {
				type = var0_26[1],
				id = var0_26[2],
				count = var0_26[3]
			}

			updateDrop(arg2_26:Find("mask/item"), var1_26)
			onButton(arg0_25, arg2_26, function()
				arg0_25:emit(BaseUI.ON_DROP, var1_26)
			end, SFX_PANEL)
		end
	end)
	arg0_25.firstAwardList:align(#var0_25.first_drop_show)
	setActive(arg0_25.resultBtn:Find("count"), arg0_25.cityRebuildData.summaryPt > 0)
	setText(arg0_25.resultBtn:Find("count"), CityRebuildData.PtToShow(arg0_25.cityRebuildData.summaryPt) .. "+")
end

function var0_0.SetSummaryPanelAndHp(arg0_28)
	local var0_28 = arg0_28.cityRebuildData.buildings
	local var1_28 = arg0_28.cityRebuildData.roles
	local var2_28 = arg0_28.cityRebuildData.buffLevels
	local var3_28 = arg0_28.cityRebuildData.curLevel
	local var4_28 = var3_28 % 5 == 0
	local var5_28 = 0
	local var6_28 = pg.activity_ninja_enemy[var3_28].basic

	if var3_28 < 51 then
		var5_28 = math.ceil(var6_28 * (var3_28 - 1 + arg0_28:GetParam(9)^(var3_28 - 1)) * (var4_28 and arg0_28:GetParam(10) or 1) * arg0_28:GetParam(11)^(var2_28[3] - 1))
	else
		var5_28 = math.ceil(var6_28 * (arg0_28:GetParam(16) + arg0_28:GetParam(9)^arg0_28:GetParam(16) * arg0_28:GetParam(13)^(var3_28 - (arg0_28:GetParam(16) + 1))) * (var4_28 and arg0_28:GetParam(10) or 1) * arg0_28:GetParam(11)^(var2_28[3] - 1))
	end

	local var7_28 = math.ceil(arg0_28:GetParam(14)^var3_28 * arg0_28:GetParam(15)^var2_28[4])
	local var8_28 = math.ceil((#var0_28 + var2_28[10] + (#var0_28 + var2_28[10]) * arg0_28:GetParam(1)^(var2_28[8] - 1) / arg0_28:GetParam(2)) * arg0_28:GetParam(3)^(var2_28[9] - 1) + arg0_28:GetParam(4) * var2_28[7])
	local var9_28 = math.ceil((#var1_28 + var2_28[5]) * arg0_28:GetParam(5)^(var2_28[1] - 1) + arg0_28:GetParam(6) * var2_28[2])
	local var10_28 = var8_28 + var9_28
	local var11_28 = CityRebuildData.PtToShow(arg0_28.cityRebuildData.pt)
	local var12_28 = math.ceil(var5_28 / var10_28)
	local var13_28 = string.format("%.2f", var7_28 / var12_28)

	setText(arg0_28.summaryPanel:Find("buildingDPS/Text"), var8_28)
	setText(arg0_28.summaryPanel:Find("charaDPS/Text"), var9_28)
	setText(arg0_28.summaryPanel:Find("DPS/Text"), var10_28)
	setText(arg0_28.summaryPanel:Find("time/Text"), var12_28 .. "s")
	setText(arg0_28.summaryPanel:Find("pts/Text"), "+" .. var13_28 .. "/s")
	setText(arg0_28.summaryPanel:Find("pt/Text"), var11_28)
	setText(arg0_28.ptAwardCount, CityRebuildData.PtToShow(var7_28))

	local var14_28 = var5_28

	if arg0_28.cityRebuildData.leftHp ~= 0 then
		var14_28 = arg0_28.cityRebuildData.leftHp
	end

	local var15_28 = math.ceil(var14_28 / var10_28)

	setActive(arg0_28.previousLevelBtn, var3_28 > 1)

	local var16_28 = pg.activity_ninja_enemy.all[#pg.activity_ninja_enemy.all] > arg0_28.cityRebuildData.curLevel

	arg0_28.canChangeNextLevel = arg0_28.cityRebuildData.curLevel < arg0_28.cityRebuildData.maxLevel + 1

	if not arg0_28.canChangeNextLevel then
		arg0_28.canChangeNextLevel = var15_28 <= pg.TimeMgr.GetInstance():GetServerTime() - arg0_28.cityRebuildData.startTime
	end

	setActive(arg0_28.nextLevelBtn, arg0_28.canChangeNextLevel and var16_28)
	setText(arg0_28.damageText, "-" .. var10_28)

	local var17_28 = #tostring(var10_28)
	local var18_28 = 70

	if var17_28 > 3 then
		var18_28 = 67 + var17_28
	end

	arg0_28.damageText:GetComponent(typeof(Text)).fontSize = var18_28

	local var19_28 = {}
	local var20_28 = {}
	local var21_28 = arg0_28.cityRebuildData.buffs

	for iter0_28, iter1_28 in ipairs(var21_28) do
		local var22_28 = pg.activity_ninja_buff[iter1_28].battle_effect

		if not table.contains(var19_28, var22_28) then
			table.insert(var19_28, var22_28)
			table.insert(var20_28, arg0_28.effect:Find(var22_28))
		end
	end

	arg0_28.effectWaitingTime = 0
	arg0_28.effectPlayingTime = 2
	arg0_28.isPlayingEffect = false

	arg0_28:RemoveTimer()
	arg0_28:StartTimer(function()
		local var0_29 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_28.cityRebuildData.startTime
		local var1_29 = 0

		if var0_29 >= var15_28 then
			var1_29 = var5_28 - (var0_29 - var15_28) % var12_28 * var10_28
		else
			var1_29 = var14_28 - var0_29 * var10_28
		end

		setSlider(arg0_28.hpSlider, 0, var5_28, var1_29)
		setText(arg0_28.hp, CityRebuildData.PtToShow(var1_29) .. "/<color=#b7b7b7>" .. CityRebuildData.PtToShow(var5_28) .. "</color>")

		if not arg0_28.canChangeNextLevel then
			arg0_28.canChangeNextLevel = var0_29 >= var15_28

			if arg0_28.canChangeNextLevel and var16_28 then
				setActive(arg0_28.nextLevelBtn, true)
			end
		end

		if var1_29 == var5_28 and var0_29 >= var15_28 then
			local var2_29 = arg0_28.model
			local var3_29 = arg0_28.anim
			local var4_29 = arg0_28._ship
			local var5_29 = arg0_28.model2
			local var6_29 = arg0_28.anim2
			local var7_29 = arg0_28._ship2

			if arg0_28.aliveEnemy == 2 then
				var2_29 = arg0_28.model2
				var3_29 = arg0_28.anim2
				var4_29 = arg0_28._ship2
				var5_29 = arg0_28.model
				var6_29 = arg0_28.anim
				var7_29 = arg0_28._ship
			end

			arg0_28.aliveEnemy = arg0_28.aliveEnemy == 1 and 2 or 1

			arg0_28:DeadSpine(var2_29, var3_29, var4_29)
			arg0_28:WalkSpine(var5_29, var6_29, var7_29)
		end

		if arg0_28.effectWaitingTime == 0 then
			arg0_28.isPlayingEffect = true
			arg0_28.effectWaitingTime = math.random(3)

			for iter0_29, iter1_29 in ipairs(var20_28) do
				setActive(iter1_29, true)
			end
		end

		if arg0_28.effectPlayingTime == 0 then
			arg0_28.isPlayingEffect = false
			arg0_28.effectPlayingTime = 2

			for iter2_29, iter3_29 in ipairs(var20_28) do
				setActive(iter3_29, false)
			end
		end

		if arg0_28.isPlayingEffect then
			arg0_28.effectPlayingTime = arg0_28.effectPlayingTime - 1
		else
			arg0_28.effectWaitingTime = arg0_28.effectWaitingTime - 1
		end

		arg0_28.damageAni:Play("Anim_CityRebuildGameUI_damage")
	end)
end

function var0_0.GetParam(arg0_30, arg1_30)
	local var0_30 = pg.gameset["ninja_Param" .. arg1_30]

	return var0_30.key_value ~= 0 and var0_30.key_value or tonumber(var0_30.description)
end

function var0_0.Summary(arg0_31, arg1_31, arg2_31)
	local var0_31 = #tostring(arg2_31)
	local var1_31 = 1
	local var2_31 = 1
	local var3_31

	if var0_31 < 3 then
		var1_31 = 1
		var3_31 = 1
	elseif var0_31 < 5 then
		var1_31 = 1
		var3_31 = 2
	elseif var0_31 < 7 then
		var1_31 = 2
		var3_31 = 3
	elseif var0_31 < 9 then
		var1_31 = 2
		var3_31 = 4
	else
		var1_31 = 3
		var3_31 = 5
	end

	setActive(arg0_31._tf:Find("resultEffect/" .. var1_31), true)
	arg0_31:StartTimers(function()
		setActive(arg0_31._tf:Find("resultEffect/" .. var1_31), false)
		arg1_31()
	end, var3_31, "result")
end

function var0_0.StartTimer(arg0_33, arg1_33)
	arg0_33.timer = Timer.New(arg1_33, 1, -1)

	arg0_33.timer:Start()
end

function var0_0.RemoveTimer(arg0_34)
	if arg0_34.timer then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end
end

function var0_0.StartTimers(arg0_35, arg1_35, arg2_35, arg3_35)
	if not arg0_35.timerList then
		arg0_35.timerList = {}
	end

	local var0_35 = Timer.New(arg1_35, arg2_35, 1)

	var0_35:Start()

	arg0_35.timerList[arg3_35] = var0_35
end

function var0_0.RemoveAllTimers(arg0_36)
	if arg0_36.timerList then
		for iter0_36, iter1_36 in pairs(arg0_36.timerList) do
			iter1_36:Stop()
		end

		arg0_36.timerList = {}
	end
end

function var0_0.willExit(arg0_37)
	arg0_37:ClearSpine()
	arg0_37:RemoveTimer()
	arg0_37:RemoveAllTimers()
	LeanTween.cancel(arg0_37.bg1)
	LeanTween.cancel(arg0_37.bg2)
	LeanTween.cancel(arg0_37.bg3)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_37._tf)
end

return var0_0
