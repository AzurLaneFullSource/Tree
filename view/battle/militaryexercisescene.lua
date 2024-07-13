local var0_0 = class("MilitaryExerciseScene", import("..base.BaseUI"))

var0_0.TYPE_SHOP = 1

function var0_0.getUIName(arg0_1)
	return "MilitaryExerciseUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.setShips(arg0_3, arg1_3)
	arg0_3.ships = arg1_3
end

function var0_0.setFleet(arg0_4, arg1_4)
	arg0_4.fleet = arg1_4
end

function var0_0.setRivals(arg0_5, arg1_5)
	table.sort(arg1_5, function(arg0_6, arg1_6)
		return arg0_6.rank < arg1_6.rank
	end)

	arg0_5.rivalVOs = arg1_5
end

function var0_0.setExerciseCount(arg0_7, arg1_7)
	arg0_7.exerciseCount = arg1_7
end

function var0_0.setSeasonTime(arg0_8, arg1_8)
	arg0_8.seasonTime = arg1_8
end

function var0_0.setRecoverTime(arg0_9, arg1_9)
	arg0_9.recoverTime = arg1_9
end

function var0_0.setActivity(arg0_10, arg1_10)
	arg0_10.activity = arg1_10

	arg0_10:setSeasonTime(arg1_10.stopTime)
end

function var0_0.updateSeaInfoVO(arg0_11, arg1_11)
	arg0_11.seasonInfo = arg1_11

	arg0_11:setFleet(arg1_11.fleet)
	arg0_11:setRivals(arg1_11.rivals)
	arg0_11:setExerciseCount(arg1_11.fightCount)
	arg0_11:setRecoverTime(arg1_11.resetTime)
end

function var0_0.setSeasonInfo(arg0_12, arg1_12)
	arg0_12:updateSeaInfoVO(arg1_12)
	arg0_12:setFleet(arg1_12.fleet)
	arg0_12:setRivals(arg1_12.rivals)
	arg0_12:setExerciseCount(arg1_12.fightCount)
	arg0_12:setRecoverTime(arg1_12.resetTime)
	arg0_12:updateSeasonTime()
	arg0_12:initPlayerFleet()
	arg0_12:initPlayerInfo()
	arg0_12:updateRivals()
end

function var0_0.init(arg0_13)
	arg0_13.backBtn = arg0_13:findTF("blur_panel/adapt/top/backBtn")
	arg0_13._normalUIMain = pg.UIMgr.GetInstance().UIMain
	arg0_13._overlayUIMain = pg.UIMgr.GetInstance().OverlayMain
	arg0_13.top = findTF(arg0_13._tf, "blur_panel/adapt/top")
	arg0_13.awardPanel = arg0_13:findTF("award_info_panel")

	setActive(arg0_13.awardPanel, false)

	arg0_13.rivalList = arg0_13:findTF("center/rival_list")
	arg0_13.bottomPanel = arg0_13:findTF("bottom")
	arg0_13.shipTpl = arg0_13:getTpl("fleet_info/shiptpl", arg0_13.bottomPanel)
	arg0_13.emptyTpl = arg0_13:getTpl("fleet_info/emptytpl", arg0_13.bottomPanel)
	arg0_13.mainContainer = arg0_13:findTF("fleet_info/main", arg0_13.bottomPanel)
	arg0_13.vanguardContainer = arg0_13:findTF("fleet_info/vanguard", arg0_13.bottomPanel)
	arg0_13.rankCfg = pg.arena_data_rank

	arg0_13:uiStartAnimating()
end

function var0_0.updatePlayer(arg0_14, arg1_14)
	arg0_14.player = arg1_14

	setText(findTF(arg0_14:findTF("bottom/player_info"), "statistics_panel/exploit_bg/score"), arg1_14.exploit)
end

function var0_0.uiStartAnimating(arg0_15)
	local var0_15 = 0
	local var1_15 = arg0_15.bottomPanel.localPosition.y

	setAnchoredPosition(arg0_15.bottomPanel, {
		y = var1_15 - 308
	})
	shiftPanel(arg0_15.bottomPanel, nil, var1_15, 0.3, var0_15, true, true)
end

function var0_0.uiExitAnimating(arg0_16)
	local var0_16 = 0
	local var1_16 = arg0_16.bottomPanel.localPosition.y

	shiftPanel(arg0_16.bottomPanel, nil, var1_16 - 308, 0.3, var0_16, true, true)
end

function var0_0.didEnter(arg0_17)
	onButton(arg0_17, arg0_17.backBtn, function()
		if arg0_17.isOpenRivalInfoPanel then
			arg0_17:closeRivalInfoPanel()
		else
			arg0_17:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0_17:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_17:findTF("stamp"), false)
	end

	onButton(arg0_17, arg0_17:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(10)
	end, SFX_CONFIRM)
	onButton(arg0_17, arg0_17:findTF("bottom/buttons/rank_btn"), function()
		arg0_17:emit(MilitaryExerciseMediator.OPEN_RANK)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17:findTF("bottom/buttons/shop_btn"), function()
		arg0_17:emit(MilitaryExerciseMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17:findTF("bottom/buttons/award_btn"), function()
		arg0_17.isOpenAwards = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_17.awardPanel, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		if not arg0_17.isInitAward then
			arg0_17:initAwards()

			arg0_17.isInitAward = true
		else
			setActive(arg0_17.awardPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_17, findTF(arg0_17._tf, "center/replace_rival_btn"), function()
		arg0_17:emit(MilitaryExerciseMediator.REPLACE_RIVALS)
	end, SFX_PANEL)

	if arg0_17.contextData.mode == var0_0.TYPE_SHOP then
		triggerToggle(arg0_17.shopBtn, true)
	end
end

function var0_0.updateSeasonTime(arg0_24)
	arg0_24.seasonInfoPanel = arg0_24:findTF("center/season_info")

	arg0_24:updateSeasonLeftTime(arg0_24.seasonTime)
	arg0_24:updateRecoverTime(arg0_24.recoverTime)
	arg0_24:updateExerciseCount()
end

function var0_0.updateExerciseCount(arg0_25)
	setText(findTF(arg0_25.seasonInfoPanel, "count"), math.max(arg0_25.exerciseCount or 0, 0) .. "/" .. SeasonInfo.MAX_FIGHTCOUNT)
end

function var0_0.updateSeasonLeftTime(arg0_26, arg1_26)
	if arg0_26.leftTimeTimer then
		arg0_26.leftTimeTimer:Stop()

		arg0_26.leftTimeTimer = nil
	end

	local var0_26 = findTF(arg0_26.seasonInfoPanel, "left_time_container/day")
	local var1_26 = findTF(arg0_26.seasonInfoPanel, "left_time_container/time")

	arg0_26.leftTimeTimer = Timer.New(function()
		local var0_27 = arg1_26 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_27 > 0 then
			local var1_27, var2_27, var3_27, var4_27 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_27)

			setText(var0_26, var1_27)
			setText(var1_26, string.format("%02d:%02d:%02d", var2_27, var3_27, var4_27))
		else
			setText(var0_26, 0)
			setText(var1_26, string.format("%02d:%02d:%02d", 0, 0, 0))
			arg0_26.leftTimeTimer:Stop()

			arg0_26.leftTimeTimer = nil
		end
	end, 1, -1)

	arg0_26.leftTimeTimer:Start()
	arg0_26.leftTimeTimer.func()
end

function var0_0.updateRecoverTime(arg0_28, arg1_28)
	if arg0_28.recoverTimer then
		arg0_28.recoverTimer:Stop()

		arg0_28.recoverTimer = nil
	end

	local var0_28 = findTF(arg0_28.seasonInfoPanel, "recover_container/time")

	if arg1_28 == 0 then
		setText(var0_28, "")

		return
	end

	arg0_28.recoverTimer = Timer.New(function()
		local var0_29 = arg1_28 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_29 > 0 then
			setText(var0_28, i18n("exercise_count_recover_tip", pg.TimeMgr.GetInstance():DescCDTime(var0_29)))
		else
			arg0_28.recoverTimer:Stop()

			arg0_28.recoverTimer = nil
		end
	end, 1, -1)

	arg0_28.recoverTimer:Start()
	arg0_28.recoverTimer.func()
end

function var0_0.initPlayerFleet(arg0_30)
	local function var0_30(arg0_31, arg1_31, arg2_31)
		local var0_31 = cloneTplTo(arg0_30.shipTpl, arg1_31)
		local var1_31 = arg0_31.configId
		local var2_31 = arg0_31.skinId

		updateShip(var0_31, arg0_31, {
			initStar = true
		})
		setText(findTF(var0_31, "icon_bg/lv/Text"), arg0_31.level)
		onButton(arg0_30, var0_31, function()
			arg0_30:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, arg2_31, arg0_31.id)
		end, SFX_PANEL)
	end

	removeAllChildren(arg0_30.mainContainer)
	removeAllChildren(arg0_30.vanguardContainer)

	for iter0_30 = 1, 3 do
		local var1_30 = arg0_30.fleet.mainShips[iter0_30]

		if var1_30 then
			local var2_30 = arg0_30.ships[var1_30]

			if var2_30 then
				var0_30(var2_30, arg0_30.mainContainer, TeamType.Main)
			end
		else
			local var3_30 = cloneTplTo(arg0_30.emptyTpl, arg0_30.mainContainer)

			onButton(arg0_30, findTF(var3_30, "icon_bg"), function()
				arg0_30:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Main, 0)
			end, SFX_PANEL)
		end
	end

	for iter1_30 = 1, 3 do
		local var4_30 = arg0_30.fleet.vanguardShips[iter1_30]

		if var4_30 then
			local var5_30 = arg0_30.ships[var4_30]

			if var5_30 then
				var0_30(var5_30, arg0_30.vanguardContainer, TeamType.Vanguard)
			end
		else
			local var6_30 = cloneTplTo(arg0_30.emptyTpl, arg0_30.vanguardContainer)

			onButton(arg0_30, findTF(var6_30, "icon_bg"), function()
				arg0_30:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Vanguard, 0)
			end, SFX_PANEL)
		end
	end
end

function var0_0.initPlayerInfo(arg0_35)
	local var0_35 = arg0_35.seasonInfo.score
	local var1_35 = arg0_35:findTF("bottom/player_info")

	setText(findTF(var1_35, "statistics_panel/score_bg/score"), var0_35)
	setText(findTF(var1_35, "statistics_panel/rank_bg/score"), arg0_35.seasonInfo.rank)

	local var2_35 = findTF(var1_35, "upgrade_tip/level")
	local var3_35 = findTF(var1_35, "upgrade_rank_tip/level")
	local var4_35 = findTF(var1_35, "upgrade_score_tip/level")
	local var5_35 = SeasonInfo.getMilitaryRank(var0_35, arg0_35.seasonInfo.rank)

	assert(var5_35, ">>>" .. var0_35 .. "--" .. arg0_35.seasonInfo.rank)

	local var6_35 = SeasonInfo.getEmblem(var0_35, arg0_35.seasonInfo.rank)

	LoadImageSpriteAsync("emblem/" .. var6_35, findTF(var1_35, "medal_bg/medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var6_35, findTF(var1_35, "medal_bg/Text"), true)

	local var7_35 = findTF(var1_35, "exp_slider"):GetComponent("Slider")
	local var8_35, var9_35, var10_35 = SeasonInfo.getNextMilitaryRank(var0_35, arg0_35.seasonInfo.rank)
	local var11_35 = math.min(var9_35, var0_35)

	setText(var2_35, var8_35)
	setText(var4_35, var9_35)
	setText(var3_35, var10_35 > 0 and var10_35 or "-")

	var7_35.value = var11_35 / var9_35
end

function var0_0.updateRivals(arg0_36)
	arg0_36.rivalTFs = {}

	for iter0_36 = 1, 4 do
		table.insert(arg0_36.rivalTFs, arg0_36.rivalList:GetChild(iter0_36 - 1))
	end

	for iter1_36 = 1, 4 do
		local var0_36 = arg0_36.rivalTFs[iter1_36]

		setActive(var0_36, iter1_36 <= #arg0_36.rivalVOs)

		if iter1_36 <= #arg0_36.rivalVOs then
			arg0_36:updateRival(iter1_36)
		end
	end
end

function var0_0.updateRival(arg0_37, arg1_37)
	local var0_37 = arg0_37.rivalTFs[arg1_37]
	local var1_37 = arg0_37.rivalVOs[arg1_37]
	local var2_37 = SeasonInfo.getMilitaryRank(var1_37.score, var1_37.rank)

	assert(var2_37, ">>>" .. var1_37.score .. "--" .. var1_37.rank)

	local var3_37 = findTF(var0_37, "shiptpl")
	local var4_37 = SeasonInfo.getEmblem(var1_37.score, var1_37.rank)

	LoadImageSpriteAsync("emblem/" .. var4_37, findTF(var0_37, "medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var4_37, findTF(var0_37, "Text"), true)
	updateDrop(var3_37, {
		type = DROP_TYPE_SHIP,
		id = var1_37.icon,
		skinId = var1_37.skinId,
		propose = var1_37.proposeTime,
		remoulded = var1_37.remoulded
	}, {
		initStar = true
	})
	setActive(findTF(var3_37, "icon_bg/lv"), false)
	setText(findTF(var0_37, "rank_bg/rank_container/name"), var1_37.rank)
	setText(findTF(var0_37, "name_container/name"), var1_37.name)
	setText(findTF(var0_37, "name_container/lv"), "Lv." .. var1_37.level)
	setText(findTF(var0_37, "comprehensive_panel/comprehensive/main_fleet/value"), var1_37:GetGearScoreSum(TeamType.Main))
	setText(findTF(var0_37, "comprehensive_panel/comprehensive/vanguard_fleet/value"), var1_37:GetGearScoreSum(TeamType.Vanguard))
	onButton(arg0_37, var0_37, function()
		arg0_37:emit(MilitaryExerciseMediator.OPEN_RIVAL_INFO, var1_37)
	end, SFX_PANEL)
end

function var0_0.initAwards(arg0_39)
	assert(not arg0_39.isInitAward, "已经初始化奖励列表")
	setActive(arg0_39.awardPanel, true)
	onButton(arg0_39, arg0_39:findTF("top/btnBack", arg0_39.awardPanel), function()
		arg0_39:closeAwards()
	end, SFX_CANCEL)

	local var0_39 = arg0_39:findTF("bg/frame/content/time_panel/Text", arg0_39.awardPanel)

	setText(var0_39, i18n("exercise_time_tip", "   " .. os.date("%Y.%m.%d", arg0_39.activity.data1) .. " — " .. os.date("%Y.%m.%d", arg0_39.activity.stopTime)))

	local var1_39 = arg0_39:findTF("bg/frame/content/desc_panel/Text", arg0_39.awardPanel)

	setText(var1_39, i18n("exercise_rule_tip"))

	local var2_39 = arg0_39:findTF("bg/frame/content/award_panel/award_list", arg0_39.awardPanel)
	local var3_39 = arg0_39:getTpl("awardtpl", var2_39)
	local var4_39 = arg0_39:getTpl("awards/equipmenttpl", var3_39)
	local var5_39 = arg0_39:findTF("linetpl", var2_39)
	local var6_39 = arg0_39:findTF("bg/frame/content/award_panel/Text", arg0_39.awardPanel)

	setText(var6_39, i18n("exercise_award_tip"))

	local function var7_39(arg0_41, arg1_41)
		local var0_41 = arg0_39:findTF("awards", arg0_41)
		local var1_41 = arg0_39.rankCfg[arg1_41]

		setText(findTF(arg0_41, "Text"), var1_41.name .. ":")

		for iter0_41, iter1_41 in ipairs(var1_41.award_list) do
			local var2_41 = cloneTplTo(var4_39, var0_41)

			updateDrop(var2_41, {
				type = iter1_41[1],
				id = iter1_41[2],
				count = iter1_41[3]
			})
			onButton(arg0_39, var2_41:Find("icon_bg"), function()
				arg0_39:emit(BaseUI.ON_ITEM, iter1_41[1] == 1 and id2ItemId(iter1_41[2]) or iter1_41[2])
			end, SFX_PANEL)
		end

		setText(findTF(arg0_41, "upgrade_score_tip/level"), var1_41.point)
		setText(findTF(arg0_41, "upgrade_rank_tip/level"), var1_41.order > 0 and var1_41.order or "-")
	end

	for iter0_39 = #arg0_39.rankCfg.all, 1, -1 do
		local var8_39 = arg0_39.rankCfg.all[iter0_39]

		if #arg0_39.rankCfg[var8_39].award_list > 0 then
			var7_39(cloneTplTo(var3_39, var2_39), var8_39)
			cloneTplTo(var5_39, var2_39)
		end
	end
end

function var0_0.closeAwards(arg0_43)
	if arg0_43.isOpenAwards then
		setActive(arg0_43.awardPanel, false)

		arg0_43.isOpenAwards = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_43.awardPanel, arg0_43._tf)
	end
end

function var0_0.onBackPressed(arg0_44)
	if arg0_44.isOpenAwards then
		arg0_44:closeAwards()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_44:emit(var0_0.ON_BACK)
	end
end

function var0_0.willExit(arg0_45)
	if arg0_45.tweens then
		cancelTweens(arg0_45.tweens)
	end

	if arg0_45.leftTimeTimer then
		arg0_45.leftTimeTimer:Stop()

		arg0_45.leftTimeTimer = nil
	end

	if arg0_45.recoverTimer then
		arg0_45.recoverTimer:Stop()

		arg0_45.recoverTimer = nil
	end

	arg0_45:closeAwards()
end

return var0_0
