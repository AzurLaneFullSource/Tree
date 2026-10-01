local var0_0 = class("MilitaryExerciseScene", import("..base.BaseUI"))

var0_0.TYPE_SHOP = 1

function var0_0.getUIName(arg0_1)
	return "MilitaryExerciseUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"bg/star_level_card_1",
		"bg/star_level_card_2",
		"bg/star_level_card_3",
		"bg/star_level_card_3_1",
		"bg/star_level_card_4",
		"bg/star_level_card_4_0",
		"bg/star_level_card_4_1",
		"bg/star_level_card_5",
		"bg/star_level_card_5_0",
		"bg/star_level_card_5_1"
	}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local function var2_2(arg0_4, arg1_4)
		local var0_4 = SeasonInfo.getEmblem(arg0_4, arg1_4)

		if noEmptyStr(var0_4) then
			var1_2("emblem/" .. var0_4)
			var1_2("emblem/n_" .. var0_4)
		end
	end

	local var3_2 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()

	if var3_2 then
		var2_2(var3_2.score, var3_2.rank)

		local var4_2 = getProxy(BayProxy)

		local function var5_2(arg0_5)
			for iter0_5, iter1_5 in ipairs(arg0_5 or {}) do
				local var0_5 = var4_2:RawGetShipById(iter1_5)

				if var0_5 then
					var1_2("SquareIcon/" .. var0_5:getPainting())
				end
			end
		end

		var5_2(checkExist(var3_2, {
			"fleet",
			"mainShips"
		}))
		var5_2(checkExist(var3_2, {
			"fleet",
			"vanguardShips"
		}))

		for iter0_2, iter1_2 in ipairs(var3_2.rivals or {}) do
			var2_2(iter1_2.score, iter1_2.rank)

			local var6_2 = checkExist(pg.ship_skin_template, {
				iter1_2.skinId,
				"painting"
			})

			if var6_2 then
				var1_2("SquareIcon/" .. var6_2.painting)
			end
		end
	end

	for iter2_2, iter3_2 in ipairs(pg.arena_data_rank.all or {}) do
		for iter4_2, iter5_2 in ipairs(pg.arena_data_rank[iter3_2].award_list or {}) do
			if iter5_2[1] ~= nil then
				local var7_2 = Drop.Create(iter5_2)

				var1_2(var7_2:getIcon())
			end
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.ResUISettings(arg0_6)
	return true
end

function var0_0.setShips(arg0_7, arg1_7)
	arg0_7.ships = arg1_7
end

function var0_0.setFleet(arg0_8, arg1_8)
	arg0_8.fleet = arg1_8
end

function var0_0.setRivals(arg0_9, arg1_9)
	table.sort(arg1_9, function(arg0_10, arg1_10)
		return arg0_10.rank < arg1_10.rank
	end)

	arg0_9.rivalVOs = arg1_9
end

function var0_0.setExerciseCount(arg0_11, arg1_11)
	arg0_11.exerciseCount = arg1_11
end

function var0_0.setSeasonTime(arg0_12, arg1_12)
	arg0_12.seasonTime = arg1_12
end

function var0_0.setRecoverTime(arg0_13, arg1_13)
	arg0_13.recoverTime = arg1_13
end

function var0_0.setActivity(arg0_14, arg1_14)
	arg0_14.activity = arg1_14

	arg0_14:setSeasonTime(arg1_14.stopTime)
end

function var0_0.updateSeaInfoVO(arg0_15, arg1_15)
	arg0_15.seasonInfo = arg1_15

	arg0_15:setFleet(arg1_15.fleet)
	arg0_15:setRivals(arg1_15.rivals)
	arg0_15:setExerciseCount(arg1_15.fightCount)
	arg0_15:setRecoverTime(arg1_15.resetTime)
end

function var0_0.setSeasonInfo(arg0_16, arg1_16)
	arg0_16:updateSeaInfoVO(arg1_16)
	arg0_16:setFleet(arg1_16.fleet)
	arg0_16:setRivals(arg1_16.rivals)
	arg0_16:setExerciseCount(arg1_16.fightCount)
	arg0_16:setRecoverTime(arg1_16.resetTime)
	arg0_16:updateSeasonTime()
	arg0_16:initPlayerFleet()
	arg0_16:initPlayerInfo()
	arg0_16:updateRivals()
end

function var0_0.init(arg0_17)
	arg0_17.backBtn = arg0_17._tf:Find("blur_panel/adapt/top/backBtn")
	arg0_17._normalUIMain = pg.UIMgr.GetInstance().UIMain
	arg0_17._overlayUIMain = pg.UIMgr.GetInstance().OverlayMain
	arg0_17.top = findTF(arg0_17._tf, "blur_panel/adapt/top")
	arg0_17.awardPanel = arg0_17._tf:Find("award_info_panel")

	setActive(arg0_17.awardPanel, false)

	arg0_17.rivalList = arg0_17._tf:Find("center/rival_list")
	arg0_17.bottomPanel = arg0_17._tf:Find("bottom")
	arg0_17.shipTpl = arg0_17:getTpl("fleet_info/shiptpl", arg0_17.bottomPanel)
	arg0_17.emptyTpl = arg0_17:getTpl("fleet_info/emptytpl", arg0_17.bottomPanel)
	arg0_17.mainContainer = arg0_17.bottomPanel:Find("fleet_info/main")
	arg0_17.vanguardContainer = arg0_17.bottomPanel:Find("fleet_info/vanguard")
	arg0_17.rankCfg = pg.arena_data_rank

	arg0_17:uiStartAnimating()
end

function var0_0.updatePlayer(arg0_18, arg1_18)
	arg0_18.player = arg1_18

	setText(findTF(arg0_18._tf:Find("bottom/player_info"), "statistics_panel/exploit_bg/score"), arg1_18.exploit)
end

function var0_0.uiStartAnimating(arg0_19)
	local var0_19 = 0
	local var1_19 = arg0_19.bottomPanel.localPosition.y

	setAnchoredPosition(arg0_19.bottomPanel, {
		y = var1_19 - 308
	})
	shiftPanel(arg0_19.bottomPanel, nil, var1_19, 0.3, var0_19, true, true)
end

function var0_0.uiExitAnimating(arg0_20)
	local var0_20 = 0
	local var1_20 = arg0_20.bottomPanel.localPosition.y

	shiftPanel(arg0_20.bottomPanel, nil, var1_20 - 308, 0.3, var0_20, true, true)
end

function var0_0.didEnter(arg0_21)
	onButton(arg0_21, arg0_21.backBtn, function()
		if arg0_21.isOpenRivalInfoPanel then
			arg0_21:closeRivalInfoPanel()
		else
			arg0_21:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0_21._tf:Find("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_21._tf:Find("stamp"), false)
	end

	onButton(arg0_21, arg0_21._tf:Find("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(10)
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21._tf:Find("bottom/buttons/rank_btn"), function()
		arg0_21:emit(MilitaryExerciseMediator.OPEN_RANK)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21._tf:Find("bottom/buttons/shop_btn"), function()
		arg0_21:emit(MilitaryExerciseMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21._tf:Find("bottom/buttons/award_btn"), function()
		arg0_21.isOpenAwards = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_21.awardPanel)

		if not arg0_21.isInitAward then
			arg0_21:initAwards()

			arg0_21.isInitAward = true
		else
			setActive(arg0_21.awardPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_21, findTF(arg0_21._tf, "center/replace_rival_btn"), function()
		arg0_21:emit(MilitaryExerciseMediator.REPLACE_RIVALS)
	end, SFX_PANEL)

	if arg0_21.contextData.mode == var0_0.TYPE_SHOP then
		triggerToggle(arg0_21.shopBtn, true)
	end
end

function var0_0.updateSeasonTime(arg0_28)
	arg0_28.seasonInfoPanel = arg0_28._tf:Find("center/season_info")

	arg0_28:updateSeasonLeftTime(arg0_28.seasonTime)
	arg0_28:updateRecoverTime(arg0_28.recoverTime)
	arg0_28:updateExerciseCount()
end

function var0_0.updateExerciseCount(arg0_29)
	setText(findTF(arg0_29.seasonInfoPanel, "count"), math.max(arg0_29.exerciseCount or 0, 0) .. "/" .. SeasonInfo.MAX_FIGHTCOUNT)
end

function var0_0.updateSeasonLeftTime(arg0_30, arg1_30)
	if arg0_30.leftTimeTimer then
		arg0_30.leftTimeTimer:Stop()

		arg0_30.leftTimeTimer = nil
	end

	local var0_30 = findTF(arg0_30.seasonInfoPanel, "left_time_container/day")
	local var1_30 = findTF(arg0_30.seasonInfoPanel, "left_time_container/time")

	arg0_30.leftTimeTimer = Timer.New(function()
		local var0_31 = arg1_30 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_31 > 0 then
			local var1_31, var2_31, var3_31, var4_31 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_31)

			setText(var0_30, var1_31)
			setText(var1_30, string.format("%02d:%02d:%02d", var2_31, var3_31, var4_31))
		else
			setText(var0_30, 0)
			setText(var1_30, string.format("%02d:%02d:%02d", 0, 0, 0))
			arg0_30.leftTimeTimer:Stop()

			arg0_30.leftTimeTimer = nil
		end
	end, 1, -1)

	arg0_30.leftTimeTimer:Start()
	arg0_30.leftTimeTimer.func()
end

function var0_0.updateRecoverTime(arg0_32, arg1_32)
	if arg0_32.recoverTimer then
		arg0_32.recoverTimer:Stop()

		arg0_32.recoverTimer = nil
	end

	local var0_32 = findTF(arg0_32.seasonInfoPanel, "recover_container/time")

	if arg1_32 == 0 then
		setText(var0_32, "")

		return
	end

	arg0_32.recoverTimer = Timer.New(function()
		local var0_33 = arg1_32 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_33 > 0 then
			setText(var0_32, i18n("exercise_count_recover_tip", pg.TimeMgr.GetInstance():DescCDTime(var0_33)))
		else
			arg0_32.recoverTimer:Stop()

			arg0_32.recoverTimer = nil
		end
	end, 1, -1)

	arg0_32.recoverTimer:Start()
	arg0_32.recoverTimer.func()
end

function var0_0.initPlayerFleet(arg0_34)
	local function var0_34(arg0_35, arg1_35, arg2_35)
		local var0_35 = cloneTplTo(arg0_34.shipTpl, arg1_35)
		local var1_35 = arg0_35.configId
		local var2_35 = arg0_35.skinId

		updateShip(var0_35, arg0_35, {
			initStar = true
		})
		setText(findTF(var0_35, "icon_bg/lv/Text"), arg0_35.level)
		onButton(arg0_34, var0_35, function()
			arg0_34:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, arg2_35, arg0_35.id)
		end, SFX_PANEL)
	end

	removeAllChildren(arg0_34.mainContainer)
	removeAllChildren(arg0_34.vanguardContainer)

	for iter0_34 = 1, 3 do
		local var1_34 = arg0_34.fleet.mainShips[iter0_34]

		if var1_34 then
			local var2_34 = arg0_34.ships[var1_34]

			if var2_34 then
				var0_34(var2_34, arg0_34.mainContainer, TeamType.Main)
			end
		else
			local var3_34 = cloneTplTo(arg0_34.emptyTpl, arg0_34.mainContainer)

			onButton(arg0_34, findTF(var3_34, "icon_bg"), function()
				arg0_34:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Main, 0)
			end, SFX_PANEL)
		end
	end

	for iter1_34 = 1, 3 do
		local var4_34 = arg0_34.fleet.vanguardShips[iter1_34]

		if var4_34 then
			local var5_34 = arg0_34.ships[var4_34]

			if var5_34 then
				var0_34(var5_34, arg0_34.vanguardContainer, TeamType.Vanguard)
			end
		else
			local var6_34 = cloneTplTo(arg0_34.emptyTpl, arg0_34.vanguardContainer)

			onButton(arg0_34, findTF(var6_34, "icon_bg"), function()
				arg0_34:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Vanguard, 0)
			end, SFX_PANEL)
		end
	end
end

function var0_0.initPlayerInfo(arg0_39)
	local var0_39 = arg0_39.seasonInfo.score
	local var1_39 = arg0_39._tf:Find("bottom/player_info")

	setText(findTF(var1_39, "statistics_panel/score_bg/score"), var0_39)
	setText(findTF(var1_39, "statistics_panel/rank_bg/score"), arg0_39.seasonInfo.rank)

	local var2_39 = findTF(var1_39, "upgrade_tip/level")
	local var3_39 = findTF(var1_39, "upgrade_rank_tip/level")
	local var4_39 = findTF(var1_39, "upgrade_score_tip/level")
	local var5_39 = SeasonInfo.getMilitaryRank(var0_39, arg0_39.seasonInfo.rank)

	assert(var5_39, ">>>" .. var0_39 .. "--" .. arg0_39.seasonInfo.rank)

	local var6_39 = SeasonInfo.getEmblem(var0_39, arg0_39.seasonInfo.rank)

	LoadImageSpriteAsync("emblem/" .. var6_39, findTF(var1_39, "medal_bg/medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var6_39, findTF(var1_39, "medal_bg/Text"), true)

	local var7_39 = findTF(var1_39, "exp_slider"):GetComponent("Slider")
	local var8_39, var9_39, var10_39 = SeasonInfo.getNextMilitaryRank(var0_39, arg0_39.seasonInfo.rank)
	local var11_39 = math.min(var9_39, var0_39)

	setText(var2_39, var8_39)
	setText(var4_39, var9_39)
	setText(var3_39, var10_39 > 0 and var10_39 or "-")

	var7_39.value = var11_39 / var9_39
end

function var0_0.updateRivals(arg0_40)
	arg0_40.rivalTFs = {}

	for iter0_40 = 1, 4 do
		table.insert(arg0_40.rivalTFs, arg0_40.rivalList:GetChild(iter0_40 - 1))
	end

	for iter1_40 = 1, 4 do
		local var0_40 = arg0_40.rivalTFs[iter1_40]

		setActive(var0_40, iter1_40 <= #arg0_40.rivalVOs)

		if iter1_40 <= #arg0_40.rivalVOs then
			arg0_40:updateRival(iter1_40)
		end
	end
end

function var0_0.updateRival(arg0_41, arg1_41)
	local var0_41 = arg0_41.rivalTFs[arg1_41]
	local var1_41 = arg0_41.rivalVOs[arg1_41]
	local var2_41 = SeasonInfo.getMilitaryRank(var1_41.score, var1_41.rank)

	assert(var2_41, ">>>" .. var1_41.score .. "--" .. var1_41.rank)

	local var3_41 = findTF(var0_41, "shiptpl")
	local var4_41 = SeasonInfo.getEmblem(var1_41.score, var1_41.rank)

	LoadImageSpriteAsync("emblem/" .. var4_41, findTF(var0_41, "medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var4_41, findTF(var0_41, "Text"), true)
	updateDrop(var3_41, {
		type = DROP_TYPE_SHIP,
		id = var1_41.icon,
		skinId = var1_41.skinId,
		propose = var1_41.proposeTime,
		remoulded = var1_41.remoulded
	}, {
		initStar = true
	})
	setActive(findTF(var3_41, "icon_bg/lv"), false)
	setText(findTF(var0_41, "rank_bg/rank_container/name"), var1_41.rank)
	setText(findTF(var0_41, "name_container/name"), var1_41.name)
	setText(findTF(var0_41, "name_container/lv"), "Lv." .. var1_41.level)
	setText(findTF(var0_41, "comprehensive_panel/comprehensive/main_fleet/value"), var1_41:GetGearScoreSum(TeamType.Main))
	setText(findTF(var0_41, "comprehensive_panel/comprehensive/vanguard_fleet/value"), var1_41:GetGearScoreSum(TeamType.Vanguard))
	onButton(arg0_41, var0_41, function()
		arg0_41:emit(MilitaryExerciseMediator.OPEN_RIVAL_INFO, var1_41)
	end, SFX_PANEL)
end

function var0_0.initAwards(arg0_43)
	assert(not arg0_43.isInitAward, "已经初始化奖励列表")
	setActive(arg0_43.awardPanel, true)
	onButton(arg0_43, arg0_43.awardPanel:Find("top/btnBack"), function()
		arg0_43:closeAwards()
	end, SFX_CANCEL)

	local var0_43 = arg0_43.awardPanel:Find("bg/frame/content/time_panel/Text")

	setText(var0_43, i18n("exercise_time_tip", "   " .. os.date("%Y.%m.%d", arg0_43.activity.data1) .. " — " .. os.date("%Y.%m.%d", arg0_43.activity.stopTime)))

	local var1_43 = arg0_43.awardPanel:Find("bg/frame/content/desc_panel/Text")

	setText(var1_43, i18n("exercise_rule_tip"))

	local var2_43 = arg0_43.awardPanel:Find("bg/frame/content/award_panel/award_list")
	local var3_43 = arg0_43:getTpl("awardtpl", var2_43)
	local var4_43 = arg0_43:getTpl("awards/equipmenttpl", var3_43)
	local var5_43 = var2_43:Find("linetpl")
	local var6_43 = arg0_43.awardPanel:Find("bg/frame/content/award_panel/Text")

	setText(var6_43, i18n("exercise_award_tip"))

	local function var7_43(arg0_45, arg1_45)
		local var0_45 = arg0_45:Find("awards")
		local var1_45 = arg0_43.rankCfg[arg1_45]

		setText(findTF(arg0_45, "Text"), var1_45.name .. ":")

		for iter0_45, iter1_45 in ipairs(var1_45.award_list) do
			local var2_45 = cloneTplTo(var4_43, var0_45)

			updateDrop(var2_45, {
				type = iter1_45[1],
				id = iter1_45[2],
				count = iter1_45[3]
			})
			onButton(arg0_43, var2_45:Find("icon_bg"), function()
				arg0_43:emit(BaseUI.ON_ITEM, iter1_45[1] == 1 and id2ItemId(iter1_45[2]) or iter1_45[2])
			end, SFX_PANEL)
		end

		setText(findTF(arg0_45, "upgrade_score_tip/level"), var1_45.point)
		setText(findTF(arg0_45, "upgrade_rank_tip/level"), var1_45.order > 0 and var1_45.order or "-")
	end

	for iter0_43 = #arg0_43.rankCfg.all, 1, -1 do
		local var8_43 = arg0_43.rankCfg.all[iter0_43]

		if #arg0_43.rankCfg[var8_43].award_list > 0 then
			var7_43(cloneTplTo(var3_43, var2_43), var8_43)
			cloneTplTo(var5_43, var2_43)
		end
	end
end

function var0_0.closeAwards(arg0_47)
	if arg0_47.isOpenAwards then
		setActive(arg0_47.awardPanel, false)

		arg0_47.isOpenAwards = false

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_47.awardPanel, arg0_47._tf)
	end
end

function var0_0.onBackPressed(arg0_48)
	if arg0_48.isOpenAwards then
		arg0_48:closeAwards()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_48:emit(var0_0.ON_BACK)
	end
end

function var0_0.willExit(arg0_49)
	if arg0_49.tweens then
		cancelTweens(arg0_49.tweens)
	end

	if arg0_49.leftTimeTimer then
		arg0_49.leftTimeTimer:Stop()

		arg0_49.leftTimeTimer = nil
	end

	if arg0_49.recoverTimer then
		arg0_49.recoverTimer:Stop()

		arg0_49.recoverTimer = nil
	end

	arg0_49:closeAwards()
end

return var0_0
