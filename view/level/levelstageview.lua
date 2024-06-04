local var0 = class("LevelStageView", import("..base.BaseSubView"))

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.isFrozen = nil

	arg0:bind(LevelUIConst.ON_FROZEN, function()
		arg0.isFrozen = true

		if arg0.cgComp then
			arg0.cgComp.blocksRaycasts = false
		end
	end)
	arg0:bind(LevelUIConst.ON_UNFROZEN, function()
		arg0.isFrozen = nil

		if arg0.cgComp then
			arg0.cgComp.blocksRaycasts = true
		end
	end)

	arg0.toastQueue = {}

	arg0:bind(LevelUIConst.ADD_TOAST_QUEUE, function(arg0, arg1)
		table.insert(arg0.toastQueue, arg1)

		if #arg0.toastQueue > 1 then
			return
		end

		arg0:Toast()
	end)
end

function var0.getUIName(arg0)
	return "LevelStageView"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	arg0:AddListener()

	arg0.loader = AutoLoader.New()
	arg0.cgComp = GetOrAddComponent(arg0._go, typeof(CanvasGroup))
	arg0.cgComp.blocksRaycasts = not arg0.isFrozen

	arg0:Show()
end

function var0.OnDestroy(arg0)
	if arg0.stageTimer then
		arg0.stageTimer:Stop()

		arg0.stageTimer = nil
	end

	arg0:ClearSubViews()
	arg0:DestroyAutoFightPanel()
	arg0:DestroyWinConditionPanel()
	arg0:DestroyToast()
	arg0.loader:Clear()
	arg0:Hide()
end

local var1 = -300

function var0.InitUI(arg0)
	arg0.topStage = arg0:findTF("top_stage", arg0._tf)

	setActive(arg0.topStage, true)

	arg0.bottomStage = arg0:findTF("bottom_stage", arg0._tf)
	arg0.normalRole = findTF(arg0.bottomStage, "Normal")
	arg0.funcBtn = arg0:findTF("func_button", arg0.normalRole)
	arg0.retreatBtn = arg0:findTF("retreat_button", arg0.normalRole)
	arg0.switchBtn = arg0:findTF("switch_button", arg0.normalRole)
	arg0.helpBtn = arg0:findTF("help_button", arg0.normalRole)
	arg0.shengfuBtn = arg0:findTF("shengfu/shengfu_button", arg0.normalRole)
	arg0.actionRole = findTF(arg0.bottomStage, "Action")
	arg0.missileStrikeRole = findTF(arg0.actionRole, "MissileStrike")
	arg0.airExpelRole = findTF(arg0.actionRole, "AirExpel")

	setActive(arg0.bottomStage, true)
	setAnchoredPosition(arg0.normalRole, {
		x = 0,
		y = 0
	})
	setActive(arg0.normalRole, true)
	setAnchoredPosition(arg0.actionRole, {
		x = 0,
		y = var1
	})
	setActive(arg0.actionRole, false)
	eachChild(arg0.actionRole, function(arg0)
		setActive(arg0, false)
	end)

	arg0.leftStage = arg0:findTF("left_stage", arg0._tf)

	setActive(arg0.leftStage, true)

	arg0.rightStage = arg0:findTF("right_stage", arg0._tf)
	arg0.bombPanel = arg0.rightStage:Find("bomb_panel")
	arg0.panelBarrier = arg0:findTF("panel_barrier", arg0.rightStage)
	arg0.strategyPanelAnimator = arg0:findTF("event", arg0.rightStage):GetComponent(typeof(Animator))
	arg0.autoBattleBtn = arg0:findTF("event/collapse/lock_fleet", arg0.rightStage)
	arg0.showDetailBtn = arg0:findTF("event/detail/show_detail", arg0.rightStage)

	setActive(arg0.panelBarrier, false)
	setActive(arg0.rightStage, true)

	arg0.airSupremacy = arg0:findTF("msg_panel/air_supremacy", arg0.topStage)

	setAnchoredPosition(arg0.topStage, {
		y = arg0.topStage.rect.height
	})
	setAnchoredPosition(arg0.leftStage, {
		x = -arg0.leftStage.rect.width - 200
	})
	setAnchoredPosition(arg0.rightStage, {
		x = arg0.rightStage.rect.width + 300
	})
	setAnchoredPosition(arg0.bottomStage, {
		y = -arg0.bottomStage.rect.height
	})

	arg0.attachSubViews = {}
end

function var0.AddListener(arg0)
	arg0:bind(LevelUIConst.TRIGGER_ACTION, function()
		arg0:tryAutoTrigger()
	end)
	arg0:bind(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, function(arg0, arg1)
		arg0.strategyPanelAnimator:SetBool("IsActive", arg1)

		arg0.bottomStageInactive = arg1

		arg0:ShiftBottomStage(not arg1)
	end)
	arg0:bind(LevelUIConst.ON_CLICK_GRID_QUAD, function(arg0, arg1)
		arg0:ClickGridCellNormal(arg1)
	end)
	onButton(arg0, arg0:findTF("option", arg0.topStage), function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("back_button", arg0.topStage), function()
		arg0:emit(LevelUIConst.SWITCH_TO_MAP)
	end, SFX_CANCEL)
	onButton(arg0, arg0.retreatBtn, function()
		local var0 = arg0.contextData.chapterVO
		local var1 = arg0.contextData.map
		local var2 = "levelScene_whether_to_retreat"

		if var0:existOni() then
			var2 = "levelScene_oni_retreat"
		elseif var0:isPlayingWithBombEnemy() then
			var2 = "levelScene_bomb_retreat"
		elseif var0:getPlayType() == ChapterConst.TypeTransport and not var1:isSkirmish() then
			var2 = "levelScene_escort_retreat"
		elseif var1:isRemaster() then
			var2 = "archives_whether_to_retreat"
		end

		arg0:HandleShowMsgBox({
			content = i18n(var2),
			onYes = ChapterOpCommand.PrepareChapterRetreat
		})
	end, SFX_UI_WEIGHANCHOR_WITHDRAW)
	onButton(arg0, arg0.switchBtn, function()
		local var0 = arg0.contextData.chapterVO
		local var1 = var0:getNextValidIndex()

		if var1 > 0 then
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpSwitch,
				id = var0.fleets[var1].id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_failed"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.autoBattleBtn, function()
		local var0 = getProxy(ChapterProxy)
		local var1 = var0:GetSkipPrecombat()

		var0:UpdateSkipPrecombat(not var1)
	end, SFX_PANEL)
	onButton(arg0, arg0.showDetailBtn, function()
		arg0._showStrategyDetail = not arg0._showStrategyDetail and true

		arg0:updateStageStrategy()
	end, SFX_PANEL)
	onButton(arg0, arg0.funcBtn, function()
		local var0 = arg0.contextData.chapterVO

		if not var0:inWartime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_time_out"))

			return
		end

		local var1 = var0.fleet
		local var2 = var1.line
		local var3 = var0:getChapterCell(var2.row, var2.column)
		local var4 = false

		local function var5(arg0)
			local var0 = arg0.attachmentId

			return pg.expedition_data_template[var0].dungeon_id > 0
		end

		if var0:existVisibleChampion(var2.row, var2.column) then
			var4 = true

			local var6 = var0:getChampion(var2.row, var2.column)

			if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSkipBattle,
					id = var1.id
				})
			elseif not var5(var6) then
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpPreClear,
					id = var1.id
				})
			elseif var0:IsSkipPrecombat() then
				arg0:emit(LevelMediator2.ON_START)
			else
				arg0:emit(LevelMediator2.ON_STAGE)
			end
		elseif var3.attachment == ChapterConst.AttachAmbush and var3.flag == ChapterConst.CellFlagAmbush then
			local var7

			var7 = coroutine.wrap(function()
				arg0:emit(LevelUIConst.DO_AMBUSH_WARNING, var7)
				coroutine.yield()
				arg0:emit(LevelUIConst.DISPLAY_AMBUSH_INFO, var7)
				coroutine.yield()
			end)

			var7()

			var4 = true
		elseif ChapterConst.IsEnemyAttach(var3.attachment) then
			if var3.flag == ChapterConst.CellFlagActive then
				var4 = true

				if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
					arg0:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSkipBattle,
						id = var1.id
					})
				elseif not var5(var3) then
					arg0:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpPreClear,
						id = var1.id
					})
				elseif var0:IsSkipPrecombat() then
					arg0:emit(LevelMediator2.ON_START)
				else
					arg0:emit(LevelMediator2.ON_STAGE)
				end
			end
		elseif var3.attachment == ChapterConst.AttachBox then
			if var3.flag == ChapterConst.CellFlagActive then
				var4 = true

				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBox,
					id = var1.id
				})
			end
		elseif var3.attachment == ChapterConst.AttachSupply and var3.attachmentId > 0 then
			var4 = true

			local var8, var9 = var0:getFleetAmmo(var0.fleet)

			if var9 < var8 then
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSupply,
					id = var1.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_enough"))
			end
		elseif var3.attachment == ChapterConst.AttachStory then
			var4 = true

			local var10 = pg.map_event_template[var3.attachmentId].memory
			local var11 = pg.map_event_template[var3.attachmentId].gametip

			if var10 == 0 then
				return
			end

			local var12 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var10)

			pg.ConnectionMgr.GetInstance():Send(11017, {
				story_id = var10
			}, 11018, function(arg0)
				return
			end)
			pg.NewStoryMgr.GetInstance():Play(var12, function(arg0, arg1)
				local var0 = arg1 or 1

				if var3.flag == ChapterConst.CellFlagActive then
					arg0:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpStory,
						id = var1.id,
						arg1 = var0
					})
				end

				if var11 ~= "" then
					local var1

					for iter0, iter1 in ipairs(pg.memory_template.all) do
						local var2 = pg.memory_template[iter1]

						if var2.story == var12 then
							var1 = var2.title
						end
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n(var11, var1))
				end
			end)
		end

		if not var4 then
			if var0:getRound() == ChapterConst.RoundEnemy then
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpEnemyRound
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_click_to_move"))
			end
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = arg0.contextData.chapterVO

		if var0 then
			if var0:existOni() then
				arg0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_sphunt_help_tip")
				})
			elseif var0:isTypeDefence() then
				arg0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("help_battle_defense")
				})
			elseif var0:isPlayingWithBombEnemy() then
				arg0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_bomb_help_tip")
				})
			elseif pg.map_event_list[var0.id] and pg.map_event_list[var0.id].help_pictures and next(pg.map_event_list[var0.id].help_pictures) ~= nil then
				local var1 = {
					disableScroll = true,
					pageMode = true,
					ImageMode = true,
					defaultpage = 1,
					windowSize = {
						x = 1263,
						y = 873
					},
					windowPos = {
						y = -70
					},
					helpSize = {
						x = 1176,
						y = 1024
					}
				}

				for iter0, iter1 in pairs(pg.map_event_list[var0.id].help_pictures) do
					table.insert(var1, {
						icon = {
							path = "",
							atlas = iter1
						}
					})
				end

				arg0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var1
				})
			else
				arg0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = pg.gametip.help_level_ui.tip
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.airSupremacy, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.shengfuBtn, function()
		arg0:DisplayWinConditionPanel()
	end)
end

function var0.SetSeriesOperation(arg0, arg1)
	arg0.seriesOperation = arg1
end

function var0.SetGrid(arg0, arg1)
	arg0.grid = arg1
end

function var0.SetPlayer(arg0, arg1)
	return
end

function var0.SwitchToChapter(arg0, arg1)
	local var0 = findTF(arg0.topStage, "msg_panel/ambush")
	local var1 = findTF(arg0.rightStage, "target")
	local var2 = findTF(arg0.rightStage, "skip_events")

	setActive(var0, arg1:existAmbush())
	setActive(arg0.airSupremacy, OPEN_AIR_DOMINANCE and arg1:getConfig("air_dominance") > 0)

	local var3 = arg1:isLoop()

	setActive(arg0.autoBattleBtn, var3)

	if var3 then
		arg0:UpdateSkipPreCombatMark()
		arg0:UpdateAutoFightPanel()
		arg0:UpdateAutoFightMark()
	end

	arg0.achieveOriginalY = -240

	setText(var2:Find("Label"), i18n("map_event_skip"))

	local var4 = "skip_events_on_" .. arg1.id

	if arg1:getConfig("event_skip") == 1 then
		if arg1.progress > 0 or arg1.defeatCount > 0 or arg1.passCount > 0 then
			setActive(var2, true)

			var1.anchoredPosition = Vector2.New(var1.anchoredPosition.x, arg0.achieveOriginalY - 40)
			GetComponent(var2, typeof(Toggle)).isOn = PlayerPrefs.GetInt(var4, 1) == 1

			onToggle(arg0, var2, function(arg0)
				PlayerPrefs.SetInt(var4, arg0 and 1 or 0)
			end)
		else
			setActive(var2, false)

			if not PlayerPrefs.HasKey(var4) then
				PlayerPrefs.SetInt(var4, 0)
			end
		end
	else
		setActive(var2, false)

		var1.anchoredPosition = Vector2.New(var1.anchoredPosition.x, arg0.achieveOriginalY)
	end

	setActive(var1, arg1:existAchieve())
	setActive(arg0.retreatBtn, true)
	arg0.seriesOperation()
end

function var0.SwitchToMap(arg0)
	arg0:DestroyAutoFightPanel()
end

function var0.UpdateSkipPreCombatMark(arg0)
	local var0 = getProxy(ChapterProxy):GetSkipPrecombat() and "auto_battle_on" or "auto_battle_off"

	arg0.loader:GetOffSpriteRequest(arg0.autoBattleBtn)
	arg0.loader:GetSprite("ui/levelstageview_atlas", var0, arg0.autoBattleBtn, true)
end

function var0.updateStageInfo(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = findTF(arg0.topStage, "timer")
	local var2 = findTF(arg0.topStage, "unlimit")

	setWidgetText(var1, "--:--:--")

	if arg0.stageTimer then
		arg0.stageTimer:Stop()
	end

	if var0:getRemainTime() > var0:getConfig("time") or var0:getConfig("time") >= 8640000 then
		setActive(var1, false)
		setActive(var2, true)
	else
		setActive(var1, true)
		setActive(var2, false)

		arg0.stageTimer = Timer.New(function()
			if IsNil(var1) then
				return
			end

			local var0 = var0:getRemainTime()

			setWidgetText(var1, pg.TimeMgr.GetInstance():DescCDTime(var0))
		end, 1, -1)

		arg0.stageTimer:Start()
		arg0.stageTimer.func()
	end
end

function var0.updateAmbushRate(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO

	if not var0:existAmbush() then
		return
	end

	local var1 = var0.fleet
	local var2 = var1:getInvestSums()
	local var3 = findTF(arg0.topStage, "msg_panel/ambush/label1")
	local var4 = findTF(arg0.topStage, "msg_panel/ambush/label2")
	local var5 = findTF(arg0.topStage, "msg_panel/ambush/value1")
	local var6 = findTF(arg0.topStage, "msg_panel/ambush/value2")

	setText(var3, i18n("level_scene_title_word_1"))
	setText(var5, math.floor(var2))
	setText(var4, i18n("level_scene_title_word_2"))

	if not var0.activateAmbush then
		setText(var6, i18n("ambush_display_none"))
		setTextColor(var6, Color.New(0.4, 0.4, 0.4))
	else
		local var7 = var0:getAmbushRate(var1, arg1)
		local var8, var9 = ChapterConst.GetAmbushDisplay((not arg2 or not var0:existEnemy(ChapterConst.SubjectPlayer, arg1.row, arg1.column)) and var7)

		setText(var6, var8)
		setTextColor(var6, var9)
	end
end

function var0.updateStageAchieve(arg0)
	local var0 = arg0.contextData.chapterVO

	if not var0:existAchieve() then
		return
	end

	local var1 = var0.achieves
	local var2 = findTF(arg0.rightStage, "target")

	setActive(var2, true)

	local var3 = findTF(var2, "detail")
	local var4 = findTF(var3, "achieve")
	local var5 = findTF(var3, "achieves")
	local var6 = findTF(var3, "click")
	local var7 = findTF(var2, "collapse")
	local var8 = findTF(var7, "star")
	local var9 = findTF(var7, "stars")

	setActive(var4, false)
	setActive(var8, false)
	removeAllChildren(var5)
	removeAllChildren(var9)

	for iter0, iter1 in ipairs(var1) do
		local var10 = cloneTplTo(var4, var5)
		local var11 = ChapterConst.IsAchieved(iter1)

		setActive(findTF(var10, "star"), var11)

		local var12 = findTF(var10, "desc")

		setText(var12, ChapterConst.GetAchieveDesc(iter1.type, var0))
		setTextColor(var12, var11 and Color.yellow or Color.white)

		cloneTplTo(var8, var9):GetComponent(typeof(Image)).enabled = var11
	end

	onButton(arg0, var6, function()
		shiftPanel(var3, var3.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7, 0, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0, var7, function()
		shiftPanel(var3, 30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7, var7.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)

	if not arg0.isAchieveFirstInit then
		arg0.isAchieveFirstInit = true

		triggerButton(var6)
	end
end

function var0.updateStageBarrier(arg0)
	local var0 = arg0.contextData.chapterVO

	setActive(arg0.panelBarrier, var0:existOni())

	if not var0:existOni() then
		return
	end

	local var1 = arg0.panelBarrier:Find("btn_barrier")

	setText(var1:Find("nums"), var0.modelCount)
	onButton(arg0, var1, function()
		if arg0.grid.quadState == ChapterConst.QuadStateBarrierSetting then
			arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)

			return
		end

		arg0.grid:updateQuadCells(ChapterConst.QuadStateBarrierSetting)
	end, SFX_PANEL)
end

function var0.updateBombPanel(arg0, arg1)
	local var0 = arg0.contextData.chapterVO

	setActive(arg0.bombPanel, var0:isPlayingWithBombEnemy())

	if var0:isPlayingWithBombEnemy() then
		setText(arg0.bombPanel:Find("tx_step"), var0:getBombChapterInfo().action_times - math.floor(var0.roundIndex / 2))

		local var1 = arg0.bombPanel:Find("tx_score")
		local var2 = tonumber(getText(var1))
		local var3 = var0.modelCount

		LeanTween.cancel(go(var1))

		if arg1 and var2 ~= var3 then
			LeanTween.scale(go(var1), Vector3(1.5, 1.5, 1), 0.2)

			local var4 = (var3 - var2) * 0.1

			LeanTween.value(go(var1), var2, var3, var4):setOnUpdate(System.Action_float(function(arg0)
				setText(var1, math.floor(arg0))
			end)):setOnComplete(System.Action(function()
				setText(var1, var3)
			end)):setEase(LeanTweenType.easeInOutSine):setDelay(0.2)
			LeanTween.scale(go(var1), Vector3.one, 0.3):setDelay(1 + var4)
		else
			var1.localScale = Vector3.one

			setText(var1, var3)
		end
	end
end

function var0.updateFleetBuff(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleet
	local var2 = var0:GetShowingStrategies()

	if var0:getChapterSupportFleet() then
		table.insert(var2, ChapterConst.StrategyAirSupportFriendly)
	end

	local var3 = {}
	local var4 = var0:GetSubmarineFleet()

	if var4 then
		local var5 = _.filter(var4:getStrategies(), function(arg0)
			return pg.strategy_data_template[arg0.id].type == ChapterConst.StgTypePassive and arg0.count > 0
		end)

		if var5 and #var5 > 0 then
			_.each(var5, function(arg0)
				table.insert(var3, {
					id = arg0.id,
					count = arg0.count
				})
			end)
		end
	end

	local var6 = var0:GetWeather()
	local var7 = 0

	if var0:ExistDivingChampion() then
		var7 = 1
	end

	local var8 = _.map(_.values(var1:getCommanders()), function(arg0)
		return arg0:getSkills()[1]
	end)
	local var9 = findTF(arg0.topStage, "icon_list/fleet_buffs")
	local var10 = UIItemList.New(var9, var9:GetChild(0))

	var10:make(function(arg0, arg1, arg2)
		setActive(findTF(arg2, "frame"), false)
		setActive(findTF(arg2, "Text"), false)
		setActive(findTF(arg2, "times"), false)

		if arg0 == UIItemList.EventUpdate then
			local var0 = GetComponent(arg2, typeof(LayoutElement))

			var0.preferredWidth = 64
			var0.preferredHeight = 64

			if arg1 + 1 <= #var2 then
				local var1 = var2[arg1 + 1]
				local var2 = pg.strategy_data_template[var1]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var2.icon, "", arg2)

				local var3

				if var2.type == ChapterConst.StgTypeBindFleetPassive then
					var3 = var1:GetStrategyCount(var1)

					setActive(findTF(arg2, "times"), true)
					setText(findTF(arg2, "times"), var3)
				end

				local var4 = var2.iconSize

				if var4 ~= "" then
					var0.preferredWidth = var4[1]
					var0.preferredHeight = var4[2]
				end

				onButton(arg0, arg2, function()
					arg0:HandleShowMsgBox({
						iconPreservedAspect = true,
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var2.id,
							cfg = var2,
							count = var3
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1 = arg1 - #var2

			if arg1 + 1 <= #var6 then
				local var5 = pg.weather_data_template[var6[arg1 + 1]]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var5.buff_icon, "", arg2)
				onButton(arg0, arg2, function()
					arg0:HandleShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var5.name,
						content = var5.buff_desc,
						iconPath = {
							"strategyicon/" .. var5.buff_icon
						},
						yesText = pg.MsgboxMgr.TEXT_CONFIRM
					})
				end, SFX_PANEL)

				return
			end

			arg1 = arg1 - #var6

			if arg1 + 1 <= #var3 then
				local var6 = var3[arg1 + 1]
				local var7 = pg.strategy_data_template[var6.id]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var7.icon, "", arg2)
				setActive(findTF(arg2, "times"), true)
				setText(findTF(arg2, "times"), var6.count)
				onButton(arg0, arg2, function()
					arg0:HandleShowMsgBox({
						iconPreservedAspect = true,
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var7.id,
							cfg = var7
						},
						extendDesc = string.format(i18n("word_rest_times"), var6.count)
					})
				end, SFX_PANEL)

				return
			end

			arg1 = arg1 - #var3

			if arg1 + 1 <= var7 then
				GetImageSpriteFromAtlasAsync("strategyicon/submarine_approach", "", arg2)
				onButton(arg0, arg2, function()
					arg0:HandleShowMsgBox({
						hideNo = true,
						yesText = "text_confirm",
						type = MSGBOX_TYPE_DROP_ITEM,
						name = i18n("submarine_approach"),
						content = i18n("submarine_approach_desc"),
						iconPath = {
							"strategyicon/submarine_approach"
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1 = arg1 - var7

			local var8 = var8[arg1 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var8:getConfig("icon"), "", arg2)
			setText(findTF(arg2, "Text"), "Lv." .. var8:getConfig("lv"))
			setActive(findTF(arg2, "Text"), true)
			setActive(findTF(arg2, "frame"), true)
			onButton(arg0, arg2, function()
				arg0:emit(LevelMediator2.ON_COMMANDER_SKILL, var8)
			end, SFX_PANEL)
		end
	end)
	var10:align(#var2 + #var3 + #var6 + var7 + #var8)

	if OPEN_AIR_DOMINANCE and var0:getConfig("air_dominance") > 0 then
		arg0:updateAirDominance()
	end

	arg0:updateEnemyCount()
	arg0:updateChapterBuff()
end

function var0.updateEnemyCount(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = findTF(arg0.topStage, "icon_list/enemy_count")
	local var2 = tobool(underscore.detect(var0.achieves, function(arg0)
		return (arg0.type == ChapterConst.AchieveType3 or arg0.type == ChapterConst.AchieveType6) and not ChapterConst.IsAchieved(arg0)
	end))

	setActive(var1, var2)

	if var2 then
		local var3 = var0:getDisplayEnemyCount()

		setText(var1:Find("Text"), var3)
		GetImageSpriteFromAtlasAsync("enemycount", var3 > 0 and "danger" or "safe", var1)
		onButton(arg0, var1, function()
			if var3 > 0 then
				arg0:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3),
					iconPath = {
						"enemycount",
						"danger"
					},
					yesText = i18n("star_require_enemy_check"),
					onYes = function()
						local var0 = var0:getNearestEnemyCell()

						arg0.grid:focusOnCell(var0)

						local var1 = arg0.grid:GetEnemyCellView(var0)

						if var1 and var1.TweenShining then
							var1:TweenShining(2)
						end
					end
				})
			else
				arg0:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3),
					iconPath = {
						"enemycount",
						"safe"
					}
				})
			end
		end, SFX_PANEL)
	end
end

function var0.updateChapterBuff(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = findTF(arg0.topStage, "icon_list/chapter_buff")
	local var2 = var0:hasMitigation()

	SetActive(var1, var2)

	if var2 then
		local var3 = var0:getRiskLevel()

		GetImageSpriteFromAtlasAsync("passstate", var3 .. "_icon", var1)
		onButton(arg0, var1, function()
			if not var0:hasMitigation() then
				return
			end

			arg0:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = var0:getChapterState(),
				iconPath = {
					"passstate",
					var3 .. "_icon"
				},
				content = i18n("level_risk_level_mitigation_rate", var0:getRemainPassCount(), var0:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

function var0.updateAirDominance(arg0)
	local var0, var1, var2 = arg0.contextData.chapterVO:getAirDominanceValue()

	if not var2 or var2 ~= var1 then
		arg0.contextData.chapterVO:setAirDominanceStatus(var1)
		getProxy(ChapterProxy):updateChapter(arg0.contextData.chapterVO)
	end

	arg0.isChange = var2 and (var1 == 0 and 3 or var1) - (var2 == 0 and 3 or var2)

	arg0:updateAirDominanceTitle(var0, var1, arg0.isChange or 0)
end

function var0.updateAirDominanceTitle(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg0.airSupremacy, "label1")
	local var1 = findTF(arg0.airSupremacy, "label2")
	local var2 = findTF(arg0.airSupremacy, "value1")
	local var3 = findTF(arg0.airSupremacy, "value2")
	local var4 = findTF(arg0.airSupremacy, "up")
	local var5 = findTF(arg0.airSupremacy, "down")

	setText(var0, i18n("level_scene_title_word_3"))
	setText(var1, i18n("level_scene_title_word_4"))
	setText(var2, math.floor(arg1))
	setActive(var4, false)
	setActive(var5, false)

	if arg3 ~= 0 then
		if LeanTween.isTweening(go(var3)) then
			LeanTween.cancel(go(var3))
		end

		LeanTween.value(go(var3), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
			setTextAlpha(var3, arg0)
		end)):setOnComplete(System.Action(function()
			setText(var3, ChapterConst.AirDominance[arg2].name)
			setTextColor(var3, ChapterConst.AirDominance[arg2].color)
			LeanTween.value(go(var3), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
				setTextAlpha(var3, arg0)
			end))
		end))

		local function var6(arg0)
			setActive(arg0, false)
		end

		var4:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6)
		var5:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6)
		setActive(var4, arg3 > 0)
		setActive(var5, arg3 < 0)
	else
		setText(var3, ChapterConst.AirDominance[arg2].name)
		setTextColor(var3, ChapterConst.AirDominance[arg2].color)
	end
end

function var0.UpdateDefenseStatus(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getPlayType() == ChapterConst.TypeDefence
	local var2 = findTF(arg0.bottomStage, "Normal/shengfu")

	setActive(var2, var1)

	if not var1 then
		return
	end

	local var3 = findTF(var2, "hp"):GetComponent(typeof(Text))
	local var4 = var0.id
	local var5 = pg.chapter_defense[var4]

	var3.text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(var0.BaseHP) .. "</color>", var5.port_hp)
end

function var0.DisplayWinConditionPanel(arg0)
	if not arg0.winCondPanel then
		arg0.winCondPanel = WinConditionDisplayPanel.New(arg0._tf.parent, arg0.event, arg0.contextData)

		arg0.winCondPanel:Load()
	end

	arg0.winCondPanel:ActionInvoke("Enter", arg0.contextData.chapterVO)
end

function var0.DestroyWinConditionPanel(arg0)
	if not arg0.winCondPanel then
		return
	end

	arg0.winCondPanel:Destroy()

	arg0.winCondPanel = nil
end

function var0.UpdateComboPanel(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = pg.chapter_pop_template[var0.id]

	if var1 and var1.combo_on then
		local var2, var3 = arg0:GetSubView("LevelStageComboPanel")

		if var3 then
			var2:Load()
			var2.buffer:SetParent(arg0.leftStage, false)
		end

		local var4 = getProxy(ChapterProxy):GetComboHistory(var0.id)

		var2.buffer:UpdateView(var4 or var0)
		var2.buffer:UpdateViewAnimated(var0)
	end
end

function var0.UpdateDOALinkFeverPanel(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetBindActID()
	local var2 = var0:getConfig("levelstage_bar")

	if not var2 or var2 == "" then
		existCall(arg1)

		return
	end

	local var3, var4 = arg0:GetSubView(var2)

	if var4 then
		var3:Load()
		var3.buffer:SetParent(arg0._tf, false)
	end

	var3.buffer:UpdateView(var0, arg1)
end

local var2 = Vector2(396, 128)
local var3 = Vector2(128, 128)

function var0.updateStageStrategy(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = findTF(arg0.rightStage, "event")
	local var2 = findTF(var1, "detail")
	local var3 = findTF(var2, "click")
	local var4 = findTF(var2, "items")

	var4:GetComponent(typeof(GridLayoutGroup)).cellSize = arg0._showStrategyDetail and var2 or var3

	local var5 = findTF(var4, "item")
	local var6 = findTF(var1, "collapse")

	setActive(var5, false)

	local var7 = var0:GetInteractableStrategies()
	local var8

	local function var9(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = arg2:Find("detail")

		setActive(var0, arg0._showStrategyDetail)

		local var1 = arg2:Find("icon")
		local var2 = var7[arg1 + 1]
		local var3
		local var4

		if var2.id == ChapterConst.StrategyHuntingRange then
			var3 = ChapterConst.StgTypeConst
			var4 = arg0.contextData.huntingRangeVisibility % 2 == 1 and "range_invisible" or "range_visible"

			setText(var0, i18n("help_sub_limits"))
		elseif var2.id == ChapterConst.StrategySubAutoAttack then
			var3 = ChapterConst.StgTypeConst
			var4 = var0.subAutoAttack == 0 and "sub_dont_auto_attack" or "sub_auto_attack"

			setText(var0, i18n("help_sub_display"))
		else
			local var5 = pg.strategy_data_template[var2.id]

			var3 = var5.type
			var4 = var5.icon

			setText(var0, var5.desc)
		end

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4, "", var1:Find("icon"))
		onButton(arg0, var1, function()
			if var2.id == ChapterConst.StrategyHuntingRange then
				arg0.grid:toggleHuntingRange()
				var9(arg0, arg1, arg2)
			elseif var2.id == ChapterConst.StrategySubAutoAttack then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ai_change_" .. 1 - var0.subAutoAttack + 1))
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubState,
					arg1 = 1 - var0.subAutoAttack
				})
			elseif var2.id == ChapterConst.StrategyExchange then
				local var0 = var0:getNextValidIndex()

				if var0 > 0 and var2.count > 0 then
					local var1 = var0.fleet

					arg0:HandleShowMsgBox({
						content = i18n("levelScene_who_to_exchange"),
						onYes = function()
							arg0:emit(LevelMediator2.ON_OP, {
								type = ChapterConst.OpStrategy,
								id = var1.id,
								arg1 = ChapterConst.StrategyExchange,
								arg2 = var0.fleets[var0].id
							})
						end
					})
				end
			elseif var2.id == ChapterConst.StrategySubTeleport then
				arg0:SwitchSubTeleportBottomStage()
				arg0:SwitchBottomStagePanel(true)
				arg0.grid:ShowStaticHuntingRange()
				arg0.grid:PrepareSubTeleport()
				arg0.grid:updateQuadCells(ChapterConst.QuadStateTeleportSub)
			elseif var2.id == ChapterConst.StrategyMissileStrike then
				if not var0.fleet:canUseStrategy(var2) then
					return
				end

				arg0:SwitchMissileBottomStagePanel()
				arg0:SwitchBottomStagePanel(true)
				arg0.grid:updateQuadCells(ChapterConst.QuadStateMissileStrike)
			elseif var2.id == ChapterConst.StrategyAirSupport then
				if not var0:getChapterSupportFleet():canUseStrategy(var2) then
					return
				end

				arg0:SwitchAirSupportBottomStagePanel()
				arg0:SwitchBottomStagePanel(true)
				arg0.grid:updateQuadCells(ChapterConst.QuadStateAirSuport)
			elseif var2.id == ChapterConst.StrategyExpel then
				if not var0:getChapterSupportFleet():canUseStrategy(var2) then
					return
				end

				arg0:SwitchAirExpelBottomStagePanel()
				arg0:SwitchBottomStagePanel(true)
				arg0.grid:updateQuadCells(ChapterConst.QuadStateExpel)
			elseif var3 == ChapterConst.StgTypeForm then
				local var2 = var0.fleet
				local var3 = table.indexof(ChapterConst.StrategyForms, var2.id)

				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpStrategy,
					id = var2.id,
					arg1 = ChapterConst.StrategyForms[var3 % #ChapterConst.StrategyForms + 1]
				})
			else
				arg0:emit(LevelUIConst.DISPLAY_STRATEGY_INFO, var2)
			end
		end, SFX_PANEL)

		if var3 == ChapterConst.StgTypeForm then
			setText(var1:Find("nums"), "")
			setActive(var1:Find("mask"), false)
			setActive(var1:Find("selected"), true)
		else
			setText(var1:Find("nums"), var2.count or "")
			setActive(var1:Find("mask"), var2.count == 0)
			setActive(var1:Find("selected"), false)
		end
	end

	UIItemList.StaticAlign(var4, var5, #var7, var9)
	onButton(arg0, var3, function()
		shiftPanel(var2, var2.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0, var6, function()
		shiftPanel(var2, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6, var6.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

function var0.GetSubView(arg0, arg1)
	if arg0.attachSubViews[arg1] then
		return arg0.attachSubViews[arg1]
	end

	local var0 = _G[arg1].New(arg0)

	assert(var0, "cant't find subview " .. (arg1 or "nil"))

	arg0.attachSubViews[arg1] = var0

	return var0, true
end

function var0.RemoveSubView(arg0, arg1)
	if not arg0.attachSubViews[arg1] then
		return false
	end

	arg0.attachSubViews[arg1]:Destroy()

	arg0.attachSubViews[arg1] = nil

	return true
end

function var0.ClearSubViews(arg0)
	for iter0, iter1 in pairs(arg0.attachSubViews) do
		iter1:Destroy()
	end

	table.clear(arg0.attachSubViews)
end

function var0.updateStageFleet(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = findTF(arg0.leftStage, "fleet")
	local var2 = findTF(var1, "shiptpl")
	local var3 = arg0:findTF("msg_panel/fleet_info/number", arg0.topStage)

	setActive(var2, false)
	setText(var3, var0.fleet.id)

	local var4 = var0.fleet:getShips(true)

	local function var5(arg0, arg1)
		local var0 = UIItemList.New(arg0, var2)

		var0:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = arg1[arg1 + 1]

				updateShip(arg2, var0)

				local var1 = var0.hpRant
				local var2 = var0:getShipProperties()
				local var3 = math.floor((var0.hpChange or 0) / 10000 * var2[AttributeType.Durability])
				local var4 = findTF(arg2, "HP_POP")

				setActive(var4, true)
				setActive(findTF(var4, "heal"), false)
				setActive(findTF(var4, "normal"), false)

				local function var5(arg0, arg1)
					setActive(arg0, true)
					setText(findTF(arg0, "text"), arg1)
					setTextAlpha(findTF(arg0, "text"), 0)
					LeanTween.moveY(arg0, 60, 1)
					LeanTween.textAlpha(findTF(arg0, "text"), 1, 0.3)
					LeanTween.textAlpha(findTF(arg0, "text"), 0, 0.5):setDelay(0.7):setOnComplete(System.Action(function()
						arg0.localPosition = Vector3(0, 0, 0)
					end))
				end

				if var3 > 0 then
					var5(findTF(var4, "heal"), var3)
				elseif var3 < 0 then
					LeanTween.delayedCall(0.6, System.Action(function()
						local var0 = arg2.transform.localPosition.x

						LeanTween.moveX(arg2, var0, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
						LeanTween.alpha(findTF(arg2, "red"), 0.5, 0.4)
						LeanTween.alpha(findTF(arg2, "red"), 0, 0.4):setDelay(0.4)
						var5(findTF(var4, "normal"), var3)
					end))
				end

				local var6 = findTF(arg2, "blood")
				local var7 = findTF(arg2, "blood/fillarea/green")
				local var8 = findTF(arg2, "blood/fillarea/red")
				local var9 = var1 < ChapterConst.HpGreen
				local var10 = var1 == 0

				setActive(var7, not var9)
				setActive(var8, var9)

				var6:GetComponent(typeof(Slider)).fillRect = var9 and var8 or var7

				setSlider(var6, 0, 10000, var1)
				setActive(findTF(arg2, "repairmask"), var9)
				setActive(findTF(arg2, "repairmask/broken"), var10)
				onButton(arg0, arg2:Find("repairmask"), function()
					arg0:emit(LevelUIConst.DISPLAY_REPAIR_WINDOW, var0)
				end, SFX_PANEL)

				local var11 = findTF(arg2, "repairmask/icon").gameObject

				if not var9 then
					LeanTween.cancel(var11)
					setImageAlpha(var11, 1)
				end

				if var9 and not LeanTween.isTweening(var11) then
					LeanTween.alpha(rtf(var11), 0, 2):setLoopPingPong()
				end

				local var12 = GetOrAddComponent(arg2, "UILongPressTrigger").onLongPressed

				pg.DelegateInfo.Add(arg0, var12)
				var12:RemoveAllListeners()
				var12:AddListener(function()
					arg0:emit(LevelMediator2.ON_STAGE_SHIPINFO, {
						shipId = var0.id,
						shipVOs = var4
					})
				end)
			end
		end)
		var0:align(#arg1)
	end

	var5(var1:Find("main"), var0.fleet:getShipsByTeam(TeamType.Main, true))
	var5(var1:Find("vanguard"), var0.fleet:getShipsByTeam(TeamType.Vanguard, true))
	var0.fleet:clearShipHpChange()
end

function var0.updateSupportFleet(arg0)
	local var0 = arg0.contextData.chapterVO:getChapterSupportFleet()
	local var1 = findTF(arg0.leftStage, "support_fleet")

	if var0 then
		setActive(var1, true)

		local var2 = findTF(var1, "show/ship_container")

		removeAllChildren(var2)

		local var3 = findTF(var1, "show/shiptpl")
		local var4 = var0:getShips()

		for iter0, iter1 in pairs(var4) do
			local var5 = cloneTplTo(var3, var2)

			setActive(var5, true)
			updateShip(var5, iter1)
		end

		local var6 = var1:Find("hide")
		local var7 = var1:Find("show")

		local function var8(arg0)
			setActive(var6, true)
			setActive(var7, true)
			shiftPanel(var7, nil, arg0 and -325.1 or -855, 0.3, 0, true, nil, LeanTweenType.easeOutSine, function()
				setActive(var6, not arg0)
				setActive(var7, arg0)
			end)
			shiftPanel(var6, nil, arg0 and -1017 or -563.97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		end

		onButton(arg0, var6, function()
			var8(true)
		end, SFX_PANEL)
		onButton(arg0, var7, function()
			var8(false)
		end)
	else
		setActive(var1, false)
	end
end

function var0.ShiftStagePanelIn(arg0, arg1)
	shiftPanel(arg0.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1)
	arg0:ShiftBottomStage(true)
	shiftPanel(arg0.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0.ShiftStagePanelOut(arg0, arg1)
	shiftPanel(arg0.topStage, 0, arg0.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1)
	arg0:ShiftBottomStage(false)
	shiftPanel(arg0.leftStage, -arg0.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0.rightStage, arg0.rightStage.rect.width + 300, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0.ShiftBottomStage(arg0, arg1)
	arg1 = not arg0.bottomStageInactive and arg1

	local var0 = arg1 and 0 or -arg0.bottomStage.rect.height

	shiftPanel(arg0.bottomStage, 0, var0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0.SwitchSubTeleportBottomStage(arg0)
	setActive(arg0.missileStrikeRole, true)
	setText(findTF(arg0.missileStrikeRole, "confirm_button/Text"), i18n("levelscene_deploy_submarine"))
	setText(findTF(arg0.missileStrikeRole, "cancel_button/Text"), i18n("levelscene_deploy_submarine_cancel"))
	onButton(arg0, arg0:findTF("confirm_button", arg0.missileStrikeRole), function()
		local var0 = arg0.contextData.chapterVO
		local var1 = var0:GetSubmarineFleet()
		local var2 = var1.startPos
		local var3 = arg0.grid.subTeleportTargetLine

		if not var3 then
			return
		end

		local var4 = var0:findPath(nil, var2, var3)
		local var5 = arg0.grid:TransformLine2PlanePos(var2)
		local var6 = arg0.grid:TransformLine2PlanePos(var3)
		local var7 = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #var1:getShips(false) * var4 - 1e-05)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", var5, var6, var4, var7),
			onYes = function()
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = var1.id,
					arg1 = var3.row,
					arg2 = var3.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0:findTF("cancel_button", arg0.missileStrikeRole), function()
		arg0:SwitchBottomStagePanel(false)
		arg0.grid:TurnOffSubTeleport()
		arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0.SwitchMissileBottomStagePanel(arg0)
	setActive(arg0.missileStrikeRole, true)
	setText(findTF(arg0.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0, arg0:findTF("confirm_button", arg0.missileStrikeRole), function()
		local var0 = arg0.grid.missileStrikeTargetLine

		if not var0 then
			return
		end

		local var1 = arg0.contextData.chapterVO.fleet

		;(function()
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1.id,
				arg1 = ChapterConst.StrategyMissileStrike,
				arg2 = var0.row,
				arg3 = var0.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0, arg0:findTF("cancel_button", arg0.missileStrikeRole), function()
		arg0:SwitchBottomStagePanel(false)
		arg0.grid:HideMissileAimingMark()
		arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0.SwitchAirSupportBottomStagePanel(arg0)
	setActive(arg0.missileStrikeRole, true)
	setText(findTF(arg0.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0, arg0:findTF("confirm_button", arg0.missileStrikeRole), function()
		local var0 = arg0.grid.missileStrikeTargetLine

		if not var0 then
			return
		end

		local var1 = arg0.contextData.chapterVO:getChapterSupportFleet()

		;(function()
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1.id,
				arg1 = ChapterConst.StrategyAirSupport,
				arg2 = var0.row,
				arg3 = var0.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0, arg0:findTF("cancel_button", arg0.missileStrikeRole), function()
		arg0:SwitchBottomStagePanel(false)
		arg0.grid:HideAirSupportAimingMark()
		arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0.SwitchAirExpelBottomStagePanel(arg0)
	setActive(arg0.airExpelRole, true)
	setText(findTF(arg0.airExpelRole, "cancel_button/Text"), i18n("levelscene_airexpel_cancel"))
	onButton(arg0, arg0:findTF("cancel_button", arg0.airExpelRole), function()
		arg0:SwitchBottomStagePanel(false)
		arg0.grid:HideAirExpelAimingMark()
		arg0.grid:CleanAirSupport()
		arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0.SwitchBottomStagePanel(arg0, arg1)
	setActive(arg0.actionRole, true)
	setActive(arg0.normalRole, true)
	shiftPanel(arg0.actionRole, 0, arg1 and 0 or var1, 0.3, 0, true, true, nil, function()
		setActive(arg0.actionRole, arg1)
	end)
	shiftPanel(arg0.normalRole, 0, arg1 and var1 or 0, 0.3, 0, true, true, nil, function()
		setActive(arg0.normalRole, not arg1)

		if not arg1 then
			eachChild(arg0.actionRole, function(arg0)
				setActive(arg0, false)
			end)
		end
	end)
	shiftPanel(arg0.leftStage, arg1 and -arg0.leftStage.rect.width - 200 or 0, 0, 0.3, 0, true)
	shiftPanel(arg0.rightStage, arg1 and arg0.rightStage.rect.width + 300 or 0, 0, 0.3, 0, true)
end

function var0.ClickGridCellNormal(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleet
	local var2 = _.detect(var0.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Normal and arg0.line.row == arg1.row and arg0.line.column == arg1.column
	end)

	if var2 and var2:isValid() and var2.id ~= var1.id then
		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var2.id
		})

		return
	end

	if arg0:tryAutoTrigger(nil, true) then
		return
	end

	if arg1.row == var1.line.row and arg1.column == var1.line.column then
		return
	end

	local var3 = var0:getChapterCell(arg1.row, arg1.column)

	if var3.attachment == ChapterConst.AttachStory and var3.data == ChapterConst.StoryObstacle and var3.flag == ChapterConst.CellFlagTriggerActive then
		local var4 = pg.map_event_template[var3.attachmentId]

		if var4 and var4.gametip and #var4.gametip > 0 and var0:getPlayType() ~= ChapterConst.TypeDefence then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var4.gametip))
		end

		return
	elseif not var0:considerAsStayPoint(ChapterConst.SubjectPlayer, arg1.row, arg1.column) then
		return
	elseif var0:existMoveLimit() then
		local var5 = var0:calcWalkableCells(ChapterConst.SubjectPlayer, var1.line.row, var1.line.column, var1:getSpeed())

		if not _.any(var5, function(arg0)
			return arg0.row == arg1.row and arg0.column == arg1.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))

			return
		end
	end

	local var6 = var0:findPath(ChapterConst.SubjectPlayer, var1.line, {
		row = arg1.row,
		column = arg1.column
	})

	if var6 < PathFinding.PrioObstacle then
		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var1.id,
			arg1 = arg1.row,
			arg2 = arg1.column
		})
	elseif var6 < PathFinding.PrioForbidden then
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	end
end

function var0.tryAutoAction(arg0, arg1)
	if arg0.doingAutoAction then
		return
	end

	arg0.doingAutoAction = true

	local var0 = arg0.contextData.chapterVO

	if not var0 then
		existCall(arg1)

		return
	end

	if arg0:SafeCheck() then
		existCall(arg1)

		return
	end

	local var1 = {}
	local var2 = false

	for iter0, iter1 in pairs(var0.cells) do
		if iter1.trait == ChapterConst.TraitLurk then
			var2 = true

			break
		end
	end

	if not var2 then
		for iter2, iter3 in ipairs(var0.champions) do
			if iter3.trait == ChapterConst.TraitLurk then
				var2 = true

				break
			end
		end
	end

	if var2 then
		local var3 = var0:existOni()
		local var4 = var0:isPlayingWithBombEnemy()

		if not var3 and not var4 then
			table.insert(var1, function(arg0)
				arg0:emit(LevelUIConst.DO_TRACKING, arg0)
			end)
		else
			table.insertto(var1, {
				function(arg0)
					local var0

					if var3 then
						var0 = "SpUnit"
					elseif var4 then
						var0 = "SpBomb"
					end

					assert(var0)
					arg0:emit(LevelUIConst.DO_PLAY_ANIM, {
						name = var0,
						callback = function(arg0)
							setActive(arg0, false)
							arg0()
						end
					})
				end,
				function(arg0)
					local var0 = var0:getSpAppearStory()

					if var0 and #var0 > 0 then
						pg.NewStoryMgr.GetInstance():Play(var0, arg0)

						return
					end

					arg0()
				end,
				function(arg0)
					local var0 = var0:getSpAppearGuide()

					if var0 and #var0 > 0 then
						pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0, nil, arg0)

						return
					end

					arg0()
				end
			})
		end

		table.insertto(var1, {
			function(arg0)
				parallelAsync({
					function(arg0)
						arg0:tryPlayChapterStory(arg0)
					end,
					function(arg0)
						local var0 = var0:GetBossCell()

						if var0 and var0.trait == ChapterConst.TraitLurk then
							arg0.grid:focusOnCell(var0, arg0)

							return
						end

						arg0()
					end
				}, arg0)
			end,
			function(arg0)
				arg0:updateTrait(ChapterConst.TraitVirgin)
				arg0.grid:updateAttachments()
				arg0.grid:updateChampions()
				arg0:updateTrait(ChapterConst.TraitNone)
				arg0:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
				Timer.New(arg0, 0.5, 1):Start()
			end
		})
	end

	seriesAsync({
		function(arg0)
			arg0:emit(LevelUIConst.FROZEN)

			local var0 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0.id)

			if var0 and (var0.attachment ~= ChapterConst.AttachAmbush or ChapterConst.IsBossCell(var0)) then
				local var1 = ChapterConst.GetDestroyFX(var0)

				arg0.grid:PlayAttachmentEffect(var0.line.row, var0.line.column, var1, Vector2.zero)
			end

			arg0:PopBar()
			arg0:UpdateComboPanel()
			arg0()
		end,
		function(arg0)
			if not (function()
				local var0 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0.id)

				if not var0 then
					return
				end

				local var1 = pg.expedition_data_template[var0.attachmentId]

				return var1 and var1.type == ChapterConst.ExpeditionTypeMulBoss
			end)() then
				return arg0()
			end

			arg0:emit(LevelUIConst.DO_PLAY_ANIM, {
				name = "BossRetreatBar",
				callback = function(arg0)
					setActive(arg0, false)
					arg0()
				end
			})
		end,
		function(arg0)
			arg0:UpdateDOALinkFeverPanel(arg0)
		end,
		function(arg0)
			seriesAsync(var1, arg0)
		end,
		function(arg0)
			local var0, var1 = var0:GetAttachmentStories()

			if var0 then
				table.SerialIpairsAsync(var0, function(arg0, arg1, arg2)
					if arg0 <= var1 and arg1 and type(arg1) == "number" and arg1 > 0 then
						local var0 = pg.NewStoryMgr:StoryId2StoryName(arg1)

						ChapterOpCommand.PlayChapterStory(var0, arg2, var0:IsAutoFight())

						return
					end

					arg2()
				end, arg0)

				return
			end

			arg0()
		end,
		function(arg0)
			local var0 = arg0.contextData.chapterVO.id
			local var1 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0)

			if not var1 or #var1 < 1 then
				arg0()

				return
			end

			for iter0, iter1 in ipairs(var1) do
				local var2 = pg.chapter_status_effect[iter1]
				local var3 = var2 and var2.camera_focus or ""

				if type(var3) == "table" then
					arg0.grid:focusOnCell({
						row = var3[1],
						column = var3[2]
					}, arg0)

					return
				end
			end

			arg0()
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			arg0:emit(LevelUIConst.UN_FROZEN)
			;(function()
				local var0 = getProxy(ChapterProxy)
				local var1 = var0:getActiveChapter(true)

				if not var1 then
					return
				end

				local var2 = var1.id

				var0:RecordComboHistory(var2, nil)
				var0:RecordLastDefeatedEnemy(var2, nil)
				var0:extraFlagUpdated(var2)
				var0:RemoveExtendChapterData(var2, "FleetMoveDistance")
			end)()
			arg0()
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			existCall(arg1)

			arg0.doingAutoAction = nil

			if var2 then
				arg0:TryEnterChapterStoryStage()
			end
		end
	})
end

function var0.tryPlayChapterStory(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getWaveCount()

	seriesAsync({
		function(arg0)
			pg.SystemGuideMgr.GetInstance():PlayChapter(var0, arg0)
		end,
		function(arg0)
			local var0 = var0:getConfig("story_refresh")
			local var1 = var0 and var0[var1]

			if var1 and type(var1) == "string" and var1 ~= "" and not var0:IsRemaster() then
				ChapterOpCommand.PlayChapterStory(var1, arg0, var0:IsAutoFight())

				return
			end

			arg0()
		end,
		function(arg0)
			local var0 = var0:getConfig("story_refresh_boss")

			if var0 and type(var0) == "string" and var0 ~= "" and not var0:IsRemaster() and var0:IsFinalBossRefreshed() then
				ChapterOpCommand.PlayChapterStory(var0, arg0, var0:IsAutoFight())

				return
			end

			arg0()
		end,
		function(arg0)
			if var1 == 1 and pg.map_event_list[var0.id] and pg.map_event_list[var0.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. var0.id, 0) == 0 then
				triggerButton(arg0.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. var0.id, 1)
			end

			arg0()
		end,
		function()
			existCall(arg1)
		end
	})
end

function var0.TryEnterChapterStoryStage(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getWaveCount()

	seriesAsync({
		function(arg0)
			local var0 = var0:getConfig("story_refresh")
			local var1 = var0 and var0[var1]
			local var2 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var1)

			if var1 and type(var1) == "number" and not var0:IsRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(var2) then
				arg0:emit(LevelMediator2.ON_PERFORM_COMBAT, var1, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = var0:getConfig("story_refresh_boss")
			local var1 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0)

			if var0 and type(var0) == "number" and not var0:IsRemaster() and var0:IsFinalBossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(var1) then
				arg0:emit(LevelMediator2.ON_PERFORM_COMBAT, var0, arg0)
			else
				arg0()
			end
		end
	})
end

local var4 = {
	[ChapterConst.KizunaJammingDodge] = "kizunaOperationSafe",
	[ChapterConst.KizunaJammingEngage] = "kizunaOperationDanger",
	[ChapterConst.StatusDay] = "HololiveDayBar",
	[ChapterConst.StatusNight] = "HololiveNightBar",
	[ChapterConst.StatusAirportUnderControl] = "AirportCaptureBar",
	[ChapterConst.StatusSunset] = "SunsetBar",
	[ChapterConst.StatusMaze1] = "MazeBar",
	[ChapterConst.StatusMaze2] = "MazeBar",
	[ChapterConst.StatusMaze3] = "MazeBar",
	[ChapterConst.StatusMissile1] = "MissileBar",
	[ChapterConst.StatusMissileInit] = "MissileWarningBar",
	[ChapterConst.StatusMissile1B] = "MissileBar",
	[ChapterConst.StatusMissileInitB] = "MissileWarningBar",
	[ChapterConst.StatusMusashiGame1] = "MusashiGameBar_1",
	[ChapterConst.StatusMusashiGame2] = "MusashiGameBar_2",
	[ChapterConst.StatusMusashiGame3] = "MusashiGameBar_3",
	[ChapterConst.StatusMusashiGame4] = "MusashiGameBar_4",
	[ChapterConst.StatusMusashiGame5] = "MusashiGameBar_5",
	[ChapterConst.StatusMusashiGame6] = "MusashiGameBar_6",
	[ChapterConst.StatusMusashiGame7] = "MusashiGameBar_7",
	[ChapterConst.StatusMusashiGame8] = "MusashiGameBar_8"
}

function var0.PopBar(arg0)
	local var0 = arg0.contextData.chapterVO.id
	local var1 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0)

	if not var1 or #var1 < 1 then
		return
	end

	local var2 = var1[1]
	local var3 = var4[var2]

	if not var3 then
		return
	end

	local var4, var5 = arg0:GetSubView(var3)

	if var5 then
		var4:Load()
	end

	var4.buffer:PlayAnim()
end

function var0.updateTrait(arg0, arg1)
	local var0 = arg0.contextData.chapterVO

	for iter0, iter1 in pairs(var0.cells) do
		if iter1.trait ~= ChapterConst.TraitNone then
			iter1.trait = arg1
		end
	end

	for iter2, iter3 in ipairs(var0.champions) do
		if iter3.trait ~= ChapterConst.TraitNone then
			iter3.trait = arg1
		end
	end
end

function var0.CheckFleetChange(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleet
	local var2 = _.detect(var0.fleets, function(arg0)
		return not arg0:isValid()
	end)

	if var2 then
		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRetreat,
			id = var2.id
		})
	end

	if not var1:isValid() then
		local var3 = var0:getNextValidIndex()

		if var3 > 0 then
			local var4 = var0.fleets[var3]

			local function var5()
				arg0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSwitch,
					id = var4.id
				})
			end

			arg0:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("formation_switch_tip", var4.name),
				onYes = var5,
				onNo = var5
			})
		end

		return true
	end

	return false
end

function var0.tryAutoTrigger(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO

	if arg0:DoBreakAction() then
		return
	end

	if arg0:CheckFleetChange() then
		return
	end

	return ((function()
		if var0:checkAnyInteractive() then
			if not arg1 or var0:IsAutoFight() then
				triggerButton(arg0.funcBtn)

				return true
			end
		elseif var0:getRound() == ChapterConst.RoundEnemy then
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpEnemyRound
			})

			return true
		elseif var0:getRound() == ChapterConst.RoundPlayer then
			if not arg2 then
				arg0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			end

			if var0:IsAutoFight() then
				arg0:TryAutoFight()

				return true
			end
		end
	end)())
end

function var0.DoBreakAction(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1, var2 = arg0:SafeCheck()

	if var1 then
		local function var3(arg0)
			local var0

			seriesAsync({
				function(arg0)
					arg0:emit(LevelUIConst.ADD_MSG_QUEUE, arg0)
				end,
				function(arg0, arg1)
					var0 = arg1

					ChapterOpCommand.PrepareChapterRetreat(arg0)
				end,
				function(arg0)
					existCall(arg0)
					existCall(var0)
				end
			})
		end

		if var2 == ChapterConst.ReasonVictory then
			seriesAsync({
				function(arg0)
					var3(arg0)
				end,
				function(arg0)
					local var0 = var0:getConfig("win_condition_display") and #var0 > 0 and var0 .. "_tip"

					if var0 and pg.gametip[var0] then
						pg.TipsMgr.GetInstance():ShowTips(i18n(var0))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_win"))
					end

					arg0()
				end
			})
		elseif var2 == ChapterConst.ReasonDefeat then
			if var0:getPlayType() == ChapterConst.TypeTransport then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_escort_lose"))
				var3()
			else
				arg0:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("formation_invalide"),
					onYes = var3,
					onClose = var3
				})
			end
		elseif var2 == ChapterConst.ReasonDefeatDefense then
			arg0:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("harbour_bomb_tip"),
				onYes = var3,
				onClose = var3
			})
		elseif var2 == ChapterConst.ReasonVictoryOni then
			var3()
		elseif var2 == ChapterConst.ReasonDefeatOni then
			var3()
		elseif var2 == ChapterConst.ReasonDefeatBomb then
			var3()
		elseif var2 == ChapterConst.ReasonOutTime then
			arg0:emit(LevelMediator2.ON_TIME_UP)
		elseif var2 == ChapterConst.ReasonActivityOutTime then
			arg0:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_activity_timeout"),
				onYes = var3,
				onClose = var3
			})
		end

		return true
	end

	return var1
end

function var0.SafeCheck(arg0)
	local var0 = arg0.contextData.chapterVO

	if var0:existOni() then
		local var1 = var0:checkOniState()

		if var1 == 1 then
			return true, ChapterConst.ReasonVictoryOni
		elseif var1 == 2 then
			return true, ChapterConst.ReasonDefeatOni
		else
			return false
		end
	elseif var0:isPlayingWithBombEnemy() then
		if var0:getBombChapterInfo().action_times * 2 <= var0.roundIndex then
			return true, ChapterConst.ReasonDefeatBomb
		else
			return false
		end
	end

	local var2, var3 = var0:CheckChapterWin()

	if var2 then
		return true, var3
	end

	local var4, var5 = var0:CheckChapterLose()

	if var4 then
		return true, var5
	end

	if not var0:inWartime() then
		return true, ChapterConst.ReasonOutTime
	end

	local var6 = var0:GetBindActID()

	if not arg0.contextData.map:isRemaster() and var6 ~= 0 then
		local var7 = getProxy(ActivityProxy):getActivityById(var6)

		if not var7 or var7:isEnd() then
			return true, ChapterConst.ReasonActivityOutTime
		end
	end

	return false
end

function var0.TryAutoFight(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg0.contextData.map

	if not var0:IsAutoFight() then
		return
	end

	local var2 = var0:GetAllEnemies()
	local var3 = _.detect(var2, function(arg0)
		return ChapterConst.IsBossCell(arg0)
	end)
	local var4

	if ChapterConst.IsAtelierMap(var1) then
		var4 = _.filter(var0:findChapterCells(ChapterConst.AttachBox), function(arg0)
			return arg0.flag ~= ChapterConst.CellFlagDisabled
		end)
	end

	local var5 = var0:GetFleetofDuty(tobool(var3))

	if var5 and var5.id ~= var0.fleet.id then
		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var5.id
		})
		arg0:tryAutoTrigger()

		return
	end

	if var0:checkAnyInteractive() then
		arg0:tryAutoTrigger()

		return
	end

	if var4 and #var4 > 0 then
		var2 = _.map(var4, function(arg0)
			local var0, var1 = var0:findPath(ChapterConst.SubjectPlayer, var5.line, arg0)

			return {
				target = arg0,
				priority = var0,
				path = var1
			}
		end)
	elseif var3 then
		local var6, var7 = var0:FindBossPath(var5.line, var3)
		local var8 = {}
		local var9

		for iter0, iter1 in ipairs(var7) do
			table.insert(var8, iter1)

			if var0:existEnemy(ChapterConst.SubjectPlayer, iter1.row, iter1.column) then
				var6 = iter0
				var9 = iter1

				break
			end
		end

		var2 = {
			{
				target = var9 or var3,
				priority = var6 or 0,
				path = var8
			}
		}
	else
		var2 = _.map(var2, function(arg0)
			local var0, var1 = var0:findPath(ChapterConst.SubjectPlayer, var5.line, arg0)

			return {
				target = arg0,
				priority = var0,
				path = var1
			}
		end)

		local function var10(arg0)
			local var0 = arg0.target
			local var1 = pg.expedition_data_template[var0.attachmentId]

			assert(var1, "expedition_data_template not exist: " .. var0.attachmentId)

			if var0.flag == ChapterConst.CellFlagDisabled then
				return 0
			end

			return ChapterConst.EnemyPreference[var1.type]
		end

		table.sort(var2, function(arg0, arg1)
			local var0 = arg0.priority >= PathFinding.PrioObstacle

			if var0 ~= (arg1.priority >= PathFinding.PrioObstacle) then
				return not var0
			end

			local var1 = var10(arg0)
			local var2 = var10(arg1)

			if var1 ~= var2 then
				return var2 < var1
			end

			return arg0.priority < arg1.priority
		end)
	end

	local var11 = var2[1]

	if var11 and var11.priority < PathFinding.PrioObstacle then
		local var12 = var11.target

		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var5.id,
			arg1 = var12.row,
			arg2 = var12.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(var0.id, false)
	end
end

function var0.popStageStrategy(arg0)
	local var0 = arg0:findTF("event/collapse", arg0.rightStage)

	if var0.anchoredPosition.x <= 1 then
		triggerButton(var0)
	end
end

function var0.UpdateAutoFightPanel(arg0)
	if arg0.contextData.chapterVO:CanActivateAutoFight() then
		if not arg0.autoFightPanel then
			arg0.autoFightPanel = LevelStageAutoFightPanel.New(arg0.rightStage:Find("event/collapse"), arg0.event, arg0.contextData)

			arg0.autoFightPanel:Load()

			arg0.autoFightPanel.isFrozen = arg0.isFrozen
		end

		arg0.autoFightPanel.buffer:Show()
	elseif arg0.autoFightPanel then
		arg0.autoFightPanel.buffer:Hide()
	end
end

function var0.UpdateAutoFightMark(arg0)
	if not arg0.autoFightPanel then
		return
	end

	arg0.autoFightPanel.buffer:UpdateAutoFightMark()
end

function var0.DestroyAutoFightPanel(arg0)
	if not arg0.autoFightPanel then
		return
	end

	arg0.autoFightPanel:Destroy()

	arg0.autoFightPanel = nil
end

function var0.DestroyToast(arg0)
	if not arg0.toastPanel then
		return
	end

	arg0.toastPanel:Destroy()

	arg0.toastPanel = nil
end

function var0.Toast(arg0)
	arg0:DestroyToast()

	local var0 = table.remove(arg0.toastQueue, 1)

	if not var0 then
		return
	end

	arg0.toastPanel = var0.Class.New(arg0)

	arg0.toastPanel:Load()

	arg0.toastPanel.contextData.settings = var0

	arg0.toastPanel.buffer:Play(function()
		arg0:Toast()
	end)
end

function var0.HandleShowMsgBox(arg0, arg1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1)
end

return var0
