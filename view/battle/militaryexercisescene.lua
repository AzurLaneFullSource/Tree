local var0 = class("MilitaryExerciseScene", import("..base.BaseUI"))

var0.TYPE_SHOP = 1

function var0.getUIName(arg0)
	return "MilitaryExerciseUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.setShips(arg0, arg1)
	arg0.ships = arg1
end

function var0.setFleet(arg0, arg1)
	arg0.fleet = arg1
end

function var0.setRivals(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		return arg0.rank < arg1.rank
	end)

	arg0.rivalVOs = arg1
end

function var0.setExerciseCount(arg0, arg1)
	arg0.exerciseCount = arg1
end

function var0.setSeasonTime(arg0, arg1)
	arg0.seasonTime = arg1
end

function var0.setRecoverTime(arg0, arg1)
	arg0.recoverTime = arg1
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1

	arg0:setSeasonTime(arg1.stopTime)
end

function var0.updateSeaInfoVO(arg0, arg1)
	arg0.seasonInfo = arg1

	arg0:setFleet(arg1.fleet)
	arg0:setRivals(arg1.rivals)
	arg0:setExerciseCount(arg1.fightCount)
	arg0:setRecoverTime(arg1.resetTime)
end

function var0.setSeasonInfo(arg0, arg1)
	arg0:updateSeaInfoVO(arg1)
	arg0:setFleet(arg1.fleet)
	arg0:setRivals(arg1.rivals)
	arg0:setExerciseCount(arg1.fightCount)
	arg0:setRecoverTime(arg1.resetTime)
	arg0:updateSeasonTime()
	arg0:initPlayerFleet()
	arg0:initPlayerInfo()
	arg0:updateRivals()
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/backBtn")
	arg0._normalUIMain = pg.UIMgr.GetInstance().UIMain
	arg0._overlayUIMain = pg.UIMgr.GetInstance().OverlayMain
	arg0.top = findTF(arg0._tf, "blur_panel/adapt/top")
	arg0.awardPanel = arg0:findTF("award_info_panel")

	setActive(arg0.awardPanel, false)

	arg0.rivalList = arg0:findTF("center/rival_list")
	arg0.bottomPanel = arg0:findTF("bottom")
	arg0.shipTpl = arg0:getTpl("fleet_info/shiptpl", arg0.bottomPanel)
	arg0.emptyTpl = arg0:getTpl("fleet_info/emptytpl", arg0.bottomPanel)
	arg0.mainContainer = arg0:findTF("fleet_info/main", arg0.bottomPanel)
	arg0.vanguardContainer = arg0:findTF("fleet_info/vanguard", arg0.bottomPanel)
	arg0.rankCfg = pg.arena_data_rank

	arg0:uiStartAnimating()
end

function var0.updatePlayer(arg0, arg1)
	arg0.player = arg1

	setText(findTF(arg0:findTF("bottom/player_info"), "statistics_panel/exploit_bg/score"), arg1.exploit)
end

function var0.uiStartAnimating(arg0)
	local var0 = 0
	local var1 = arg0.bottomPanel.localPosition.y

	setAnchoredPosition(arg0.bottomPanel, {
		y = var1 - 308
	})
	shiftPanel(arg0.bottomPanel, nil, var1, 0.3, var0, true, true)
end

function var0.uiExitAnimating(arg0)
	local var0 = 0
	local var1 = arg0.bottomPanel.localPosition.y

	shiftPanel(arg0.bottomPanel, nil, var1 - 308, 0.3, var0, true, true)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.isOpenRivalInfoPanel then
			arg0:closeRivalInfoPanel()
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	setActive(arg0:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0:findTF("stamp"), false)
	end

	onButton(arg0, arg0:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(10)
	end, SFX_CONFIRM)
	onButton(arg0, arg0:findTF("bottom/buttons/rank_btn"), function()
		arg0:emit(MilitaryExerciseMediator.OPEN_RANK)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("bottom/buttons/shop_btn"), function()
		arg0:emit(MilitaryExerciseMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("bottom/buttons/award_btn"), function()
		arg0.isOpenAwards = true

		pg.UIMgr.GetInstance():BlurPanel(arg0.awardPanel, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})

		if not arg0.isInitAward then
			arg0:initAwards()

			arg0.isInitAward = true
		else
			setActive(arg0.awardPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._tf, "center/replace_rival_btn"), function()
		arg0:emit(MilitaryExerciseMediator.REPLACE_RIVALS)
	end, SFX_PANEL)

	if arg0.contextData.mode == var0.TYPE_SHOP then
		triggerToggle(arg0.shopBtn, true)
	end
end

function var0.updateSeasonTime(arg0)
	arg0.seasonInfoPanel = arg0:findTF("center/season_info")

	arg0:updateSeasonLeftTime(arg0.seasonTime)
	arg0:updateRecoverTime(arg0.recoverTime)
	arg0:updateExerciseCount()
end

function var0.updateExerciseCount(arg0)
	setText(findTF(arg0.seasonInfoPanel, "count"), math.max(arg0.exerciseCount or 0, 0) .. "/" .. SeasonInfo.MAX_FIGHTCOUNT)
end

function var0.updateSeasonLeftTime(arg0, arg1)
	if arg0.leftTimeTimer then
		arg0.leftTimeTimer:Stop()

		arg0.leftTimeTimer = nil
	end

	local var0 = findTF(arg0.seasonInfoPanel, "left_time_container/day")
	local var1 = findTF(arg0.seasonInfoPanel, "left_time_container/time")

	arg0.leftTimeTimer = Timer.New(function()
		local var0 = arg1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 > 0 then
			local var1, var2, var3, var4 = pg.TimeMgr.GetInstance():parseTimeFrom(var0)

			setText(var0, var1)
			setText(var1, string.format("%02d:%02d:%02d", var2, var3, var4))
		else
			setText(var0, 0)
			setText(var1, string.format("%02d:%02d:%02d", 0, 0, 0))
			arg0.leftTimeTimer:Stop()

			arg0.leftTimeTimer = nil
		end
	end, 1, -1)

	arg0.leftTimeTimer:Start()
	arg0.leftTimeTimer.func()
end

function var0.updateRecoverTime(arg0, arg1)
	if arg0.recoverTimer then
		arg0.recoverTimer:Stop()

		arg0.recoverTimer = nil
	end

	local var0 = findTF(arg0.seasonInfoPanel, "recover_container/time")

	if arg1 == 0 then
		setText(var0, "")

		return
	end

	arg0.recoverTimer = Timer.New(function()
		local var0 = arg1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 > 0 then
			setText(var0, i18n("exercise_count_recover_tip", pg.TimeMgr.GetInstance():DescCDTime(var0)))
		else
			arg0.recoverTimer:Stop()

			arg0.recoverTimer = nil
		end
	end, 1, -1)

	arg0.recoverTimer:Start()
	arg0.recoverTimer.func()
end

function var0.initPlayerFleet(arg0)
	local function var0(arg0, arg1, arg2)
		local var0 = cloneTplTo(arg0.shipTpl, arg1)
		local var1 = arg0.configId
		local var2 = arg0.skinId

		updateShip(var0, arg0, {
			initStar = true
		})
		setText(findTF(var0, "icon_bg/lv/Text"), arg0.level)
		onButton(arg0, var0, function()
			arg0:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, arg2, arg0.id)
		end, SFX_PANEL)
	end

	removeAllChildren(arg0.mainContainer)
	removeAllChildren(arg0.vanguardContainer)

	for iter0 = 1, 3 do
		local var1 = arg0.fleet.mainShips[iter0]

		if var1 then
			local var2 = arg0.ships[var1]

			if var2 then
				var0(var2, arg0.mainContainer, TeamType.Main)
			end
		else
			local var3 = cloneTplTo(arg0.emptyTpl, arg0.mainContainer)

			onButton(arg0, findTF(var3, "icon_bg"), function()
				arg0:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Main, 0)
			end, SFX_PANEL)
		end
	end

	for iter1 = 1, 3 do
		local var4 = arg0.fleet.vanguardShips[iter1]

		if var4 then
			local var5 = arg0.ships[var4]

			if var5 then
				var0(var5, arg0.vanguardContainer, TeamType.Vanguard)
			end
		else
			local var6 = cloneTplTo(arg0.emptyTpl, arg0.vanguardContainer)

			onButton(arg0, findTF(var6, "icon_bg"), function()
				arg0:emit(MilitaryExerciseMediator.OPEN_DOCKYARD, TeamType.Vanguard, 0)
			end, SFX_PANEL)
		end
	end
end

function var0.initPlayerInfo(arg0)
	local var0 = arg0.seasonInfo.score
	local var1 = arg0:findTF("bottom/player_info")

	setText(findTF(var1, "statistics_panel/score_bg/score"), var0)
	setText(findTF(var1, "statistics_panel/rank_bg/score"), arg0.seasonInfo.rank)

	local var2 = findTF(var1, "upgrade_tip/level")
	local var3 = findTF(var1, "upgrade_rank_tip/level")
	local var4 = findTF(var1, "upgrade_score_tip/level")
	local var5 = SeasonInfo.getMilitaryRank(var0, arg0.seasonInfo.rank)

	assert(var5, ">>>" .. var0 .. "--" .. arg0.seasonInfo.rank)

	local var6 = SeasonInfo.getEmblem(var0, arg0.seasonInfo.rank)

	LoadImageSpriteAsync("emblem/" .. var6, findTF(var1, "medal_bg/medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var6, findTF(var1, "medal_bg/Text"), true)

	local var7 = findTF(var1, "exp_slider"):GetComponent("Slider")
	local var8, var9, var10 = SeasonInfo.getNextMilitaryRank(var0, arg0.seasonInfo.rank)
	local var11 = math.min(var9, var0)

	setText(var2, var8)
	setText(var4, var9)
	setText(var3, var10 > 0 and var10 or "-")

	var7.value = var11 / var9
end

function var0.updateRivals(arg0)
	arg0.rivalTFs = {}

	for iter0 = 1, 4 do
		table.insert(arg0.rivalTFs, arg0.rivalList:GetChild(iter0 - 1))
	end

	for iter1 = 1, 4 do
		local var0 = arg0.rivalTFs[iter1]

		setActive(var0, iter1 <= #arg0.rivalVOs)

		if iter1 <= #arg0.rivalVOs then
			arg0:updateRival(iter1)
		end
	end
end

function var0.updateRival(arg0, arg1)
	local var0 = arg0.rivalTFs[arg1]
	local var1 = arg0.rivalVOs[arg1]
	local var2 = SeasonInfo.getMilitaryRank(var1.score, var1.rank)

	assert(var2, ">>>" .. var1.score .. "--" .. var1.rank)

	local var3 = findTF(var0, "shiptpl")
	local var4 = SeasonInfo.getEmblem(var1.score, var1.rank)

	LoadImageSpriteAsync("emblem/" .. var4, findTF(var0, "medal"), true)
	LoadImageSpriteAsync("emblem/n_" .. var4, findTF(var0, "Text"), true)
	updateDrop(var3, {
		type = DROP_TYPE_SHIP,
		id = var1.icon,
		skinId = var1.skinId,
		propose = var1.proposeTime,
		remoulded = var1.remoulded
	}, {
		initStar = true
	})
	setActive(findTF(var3, "icon_bg/lv"), false)
	setText(findTF(var0, "rank_bg/rank_container/name"), var1.rank)
	setText(findTF(var0, "name_container/name"), var1.name)
	setText(findTF(var0, "name_container/lv"), "Lv." .. var1.level)
	setText(findTF(var0, "comprehensive_panel/comprehensive/main_fleet/value"), var1:GetGearScoreSum(TeamType.Main))
	setText(findTF(var0, "comprehensive_panel/comprehensive/vanguard_fleet/value"), var1:GetGearScoreSum(TeamType.Vanguard))
	onButton(arg0, var0, function()
		arg0:emit(MilitaryExerciseMediator.OPEN_RIVAL_INFO, var1)
	end, SFX_PANEL)
end

function var0.initAwards(arg0)
	assert(not arg0.isInitAward, "已经初始化奖励列表")
	setActive(arg0.awardPanel, true)
	onButton(arg0, arg0:findTF("top/btnBack", arg0.awardPanel), function()
		arg0:closeAwards()
	end, SFX_CANCEL)

	local var0 = arg0:findTF("bg/frame/content/time_panel/Text", arg0.awardPanel)

	setText(var0, i18n("exercise_time_tip", "   " .. os.date("%Y.%m.%d", arg0.activity.data1) .. " — " .. os.date("%Y.%m.%d", arg0.activity.stopTime)))

	local var1 = arg0:findTF("bg/frame/content/desc_panel/Text", arg0.awardPanel)

	setText(var1, i18n("exercise_rule_tip"))

	local var2 = arg0:findTF("bg/frame/content/award_panel/award_list", arg0.awardPanel)
	local var3 = arg0:getTpl("awardtpl", var2)
	local var4 = arg0:getTpl("awards/equipmenttpl", var3)
	local var5 = arg0:findTF("linetpl", var2)
	local var6 = arg0:findTF("bg/frame/content/award_panel/Text", arg0.awardPanel)

	setText(var6, i18n("exercise_award_tip"))

	local function var7(arg0, arg1)
		local var0 = arg0:findTF("awards", arg0)
		local var1 = arg0.rankCfg[arg1]

		setText(findTF(arg0, "Text"), var1.name .. ":")

		for iter0, iter1 in ipairs(var1.award_list) do
			local var2 = cloneTplTo(var4, var0)

			updateDrop(var2, {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			})
			onButton(arg0, var2:Find("icon_bg"), function()
				arg0:emit(BaseUI.ON_ITEM, iter1[1] == 1 and id2ItemId(iter1[2]) or iter1[2])
			end, SFX_PANEL)
		end

		setText(findTF(arg0, "upgrade_score_tip/level"), var1.point)
		setText(findTF(arg0, "upgrade_rank_tip/level"), var1.order > 0 and var1.order or "-")
	end

	for iter0 = #arg0.rankCfg.all, 1, -1 do
		local var8 = arg0.rankCfg.all[iter0]

		if #arg0.rankCfg[var8].award_list > 0 then
			var7(cloneTplTo(var3, var2), var8)
			cloneTplTo(var5, var2)
		end
	end
end

function var0.closeAwards(arg0)
	if arg0.isOpenAwards then
		setActive(arg0.awardPanel, false)

		arg0.isOpenAwards = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0.awardPanel, arg0._tf)
	end
end

function var0.onBackPressed(arg0)
	if arg0.isOpenAwards then
		arg0:closeAwards()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0:emit(var0.ON_BACK)
	end
end

function var0.willExit(arg0)
	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	if arg0.leftTimeTimer then
		arg0.leftTimeTimer:Stop()

		arg0.leftTimeTimer = nil
	end

	if arg0.recoverTimer then
		arg0.recoverTimer:Stop()

		arg0.recoverTimer = nil
	end

	arg0:closeAwards()
end

return var0
