local var0_0 = class("LevelStageView", import("..base.BaseSubView"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.isFrozen = nil

	arg0_1:bind(LevelUIConst.ON_FROZEN, function()
		arg0_1.isFrozen = true

		if arg0_1.cgComp then
			arg0_1.cgComp.blocksRaycasts = false
		end
	end)
	arg0_1:bind(LevelUIConst.ON_UNFROZEN, function()
		arg0_1.isFrozen = nil

		if arg0_1.cgComp then
			arg0_1.cgComp.blocksRaycasts = true
		end
	end)

	arg0_1.toastQueue = {}

	arg0_1:bind(LevelUIConst.ADD_TOAST_QUEUE, function(arg0_4, arg1_4)
		table.insert(arg0_1.toastQueue, arg1_4)

		if #arg0_1.toastQueue > 1 then
			return
		end

		arg0_1:Toast()
	end)
end

function var0_0.getUIName(arg0_5)
	return "LevelStageView"
end

function var0_0.getResource(arg0_6, arg1_6)
	local var0_6 = {
		"ui/levelstageview_atlas",
		"enemycount",
		"passstate",
		"strategyicon/submarine_approach",
		"strategyicon/range_invisible",
		"strategyicon/range_visible",
		"strategyicon/sub_dont_auto_attack",
		"strategyicon/sub_auto_attack",
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	table.insertto(var0_6, ResList.LevelStageView.GetResource(arg1_6))

	return table.insertto(var0_6, var0_0.super.getResource(arg0_6, arg1_6))
end

function var0_0.OnInit(arg0_7)
	arg0_7:InitUI()
	arg0_7:AddListener()

	arg0_7.loader = AutoLoader.New()
	arg0_7.cgComp = GetOrAddComponent(arg0_7._go, typeof(CanvasGroup))
	arg0_7.cgComp.blocksRaycasts = not arg0_7.isFrozen

	arg0_7:Show()
end

function var0_0.OnDestroy(arg0_8)
	if arg0_8.stageTimer then
		arg0_8.stageTimer:Stop()

		arg0_8.stageTimer = nil
	end

	arg0_8:ClearSubViews()
	arg0_8:DestroyAutoFightPanel()
	arg0_8:DestroyWinConditionPanel()
	arg0_8:DestroyToast()
	arg0_8.loader:Clear()
	arg0_8:Hide()
end

local var1_0 = -300

function var0_0.InitUI(arg0_9)
	arg0_9.topStage = arg0_9._tf:Find("top_stage")

	setActive(arg0_9.topStage, true)

	arg0_9.bottomStage = arg0_9._tf:Find("bottom_stage")
	arg0_9.normalRole = findTF(arg0_9.bottomStage, "Normal")
	arg0_9.funcBtn = arg0_9.normalRole:Find("func_button")
	arg0_9.retreatBtn = arg0_9.normalRole:Find("retreat_button")
	arg0_9.switchBtn = arg0_9.normalRole:Find("switch_button")
	arg0_9.helpBtn = arg0_9.normalRole:Find("help_button")
	arg0_9.shengfuBtn = arg0_9.normalRole:Find("shengfu/shengfu_button")
	arg0_9.actionRole = findTF(arg0_9.bottomStage, "Action")
	arg0_9.missileStrikeRole = findTF(arg0_9.actionRole, "MissileStrike")
	arg0_9.airExpelRole = findTF(arg0_9.actionRole, "AirExpel")

	setActive(arg0_9.bottomStage, true)
	setAnchoredPosition(arg0_9.normalRole, {
		x = 0,
		y = 0
	})
	setActive(arg0_9.normalRole, true)
	setAnchoredPosition(arg0_9.actionRole, {
		x = 0,
		y = var1_0
	})
	setActive(arg0_9.actionRole, false)
	eachChild(arg0_9.actionRole, function(arg0_10)
		setActive(arg0_10, false)
	end)

	arg0_9.leftStage = arg0_9._tf:Find("left_stage")

	setActive(arg0_9.leftStage, true)

	arg0_9.rightStage = arg0_9._tf:Find("right_stage")
	arg0_9.bombPanel = arg0_9.rightStage:Find("bomb_panel")
	arg0_9.panelBarrier = arg0_9.rightStage:Find("panel_barrier")
	arg0_9.strategyPanelAnimator = arg0_9.rightStage:Find("event"):GetComponent(typeof(Animator))
	arg0_9.autoBattleBtn = arg0_9.rightStage:Find("event/collapse/lock_fleet")
	arg0_9.showDetailBtn = arg0_9.rightStage:Find("event/detail/show_detail")

	setActive(arg0_9.panelBarrier, false)
	setActive(arg0_9.rightStage, true)

	arg0_9.airSupremacy = arg0_9.topStage:Find("msg_panel/air_supremacy")

	setAnchoredPosition(arg0_9.topStage, {
		y = arg0_9.topStage.rect.height
	})
	setAnchoredPosition(arg0_9.leftStage, {
		x = -arg0_9.leftStage.rect.width - 200
	})
	setAnchoredPosition(arg0_9.rightStage, {
		x = arg0_9.rightStage.rect.width + 300
	})
	setAnchoredPosition(arg0_9.bottomStage, {
		y = -arg0_9.bottomStage.rect.height
	})

	arg0_9.attachSubViews = {}
end

function var0_0.AddListener(arg0_11)
	arg0_11:bind(LevelUIConst.TRIGGER_ACTION, function()
		arg0_11:tryAutoTrigger()
	end)
	arg0_11:bind(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, function(arg0_13, arg1_13)
		arg0_11.strategyPanelAnimator:SetBool("IsActive", arg1_13)

		arg0_11.bottomStageInactive = arg1_13

		arg0_11:ShiftBottomStage(not arg1_13)
	end)
	arg0_11:bind(LevelUIConst.ON_CLICK_GRID_QUAD, function(arg0_14, arg1_14)
		arg0_11:ClickGridCellNormal(arg1_14)
	end)
	onButton(arg0_11, arg0_11.topStage:Find("option"), function()
		arg0_11:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.topStage:Find("back_button"), function()
		arg0_11:emit(LevelUIConst.SWITCH_TO_MAP)
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.retreatBtn, function()
		local var0_17 = arg0_11.contextData.chapterVO
		local var1_17 = arg0_11.contextData.map
		local var2_17 = "levelScene_whether_to_retreat"

		if var0_17:existOni() then
			var2_17 = "levelScene_oni_retreat"
		elseif var0_17:isPlayingWithBombEnemy() then
			var2_17 = "levelScene_bomb_retreat"
		elseif var0_17:getPlayType() == ChapterConst.TypeTransport and not var1_17:isSkirmish() then
			var2_17 = "levelScene_escort_retreat"
		elseif var1_17:isRemaster() then
			var2_17 = "archives_whether_to_retreat"
		end

		arg0_11:HandleShowMsgBox({
			content = i18n(var2_17),
			onYes = ChapterOpCommand.PrepareChapterRetreat
		})
	end, SFX_UI_WEIGHANCHOR_WITHDRAW)
	onButton(arg0_11, arg0_11.switchBtn, function()
		local var0_18 = arg0_11.contextData.chapterVO
		local var1_18 = var0_18:getNextValidIndex()

		if var1_18 > 0 then
			arg0_11:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpSwitch,
				id = var0_18.fleets[var1_18].id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_failed"))
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.autoBattleBtn, function()
		local var0_19 = getProxy(ChapterProxy)
		local var1_19 = var0_19:GetSkipPrecombat()

		var0_19:UpdateSkipPrecombat(not var1_19)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.showDetailBtn, function()
		arg0_11._showStrategyDetail = not arg0_11._showStrategyDetail and true

		arg0_11:updateStageStrategy()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.funcBtn, function()
		local var0_21 = arg0_11.contextData.chapterVO

		if not var0_21:inWartime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_time_out"))

			return
		end

		local var1_21 = var0_21.fleet
		local var2_21 = var1_21.line
		local var3_21 = var0_21:getChapterCell(var2_21.row, var2_21.column)
		local var4_21 = false

		local function var5_21(arg0_22)
			local var0_22 = arg0_22.attachmentId

			return pg.expedition_data_template[var0_22].dungeon_id > 0
		end

		if var0_21:existVisibleChampion(var2_21.row, var2_21.column) then
			var4_21 = true

			local var6_21 = var0_21:getChampion(var2_21.row, var2_21.column)

			if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
				arg0_11:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSkipBattle,
					id = var1_21.id
				})
			elseif not var5_21(var6_21) then
				arg0_11:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpPreClear,
					id = var1_21.id
				})
			elseif var0_21:IsSkipPrecombat() then
				arg0_11:emit(LevelMediator2.ON_START)
			else
				arg0_11:emit(LevelMediator2.ON_STAGE)
			end
		elseif var3_21.attachment == ChapterConst.AttachAmbush and var3_21.flag == ChapterConst.CellFlagAmbush then
			local var7_21

			var7_21 = coroutine.wrap(function()
				arg0_11:emit(LevelUIConst.DO_AMBUSH_WARNING, var7_21)
				coroutine.yield()
				arg0_11:emit(LevelUIConst.DISPLAY_AMBUSH_INFO, var7_21)
				coroutine.yield()
			end)

			var7_21()

			var4_21 = true
		elseif ChapterConst.IsEnemyAttach(var3_21.attachment) then
			if var3_21.flag == ChapterConst.CellFlagActive then
				var4_21 = true

				if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
					arg0_11:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSkipBattle,
						id = var1_21.id
					})
				elseif not var5_21(var3_21) then
					arg0_11:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpPreClear,
						id = var1_21.id
					})
				elseif var0_21:IsSkipPrecombat() then
					arg0_11:emit(LevelMediator2.ON_START)
				else
					arg0_11:emit(LevelMediator2.ON_STAGE)
				end
			end
		elseif var3_21.attachment == ChapterConst.AttachBox then
			if var3_21.flag == ChapterConst.CellFlagActive then
				var4_21 = true

				arg0_11:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBox,
					id = var1_21.id
				})
			end
		elseif var3_21.attachment == ChapterConst.AttachSupply and var3_21.attachmentId > 0 then
			var4_21 = true

			local var8_21, var9_21 = var0_21:getFleetAmmo(var0_21.fleet)

			if var9_21 < var8_21 then
				arg0_11:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSupply,
					id = var1_21.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_enough"))
			end
		elseif var3_21.attachment == ChapterConst.AttachStory then
			var4_21 = true

			local var10_21 = pg.map_event_template[var3_21.attachmentId].memory
			local var11_21 = pg.map_event_template[var3_21.attachmentId].gametip

			if var10_21 == 0 then
				return
			end

			local var12_21 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var10_21)

			pg.ConnectionMgr.GetInstance():Send(11017, {
				story_id = var10_21
			}, 11018, function(arg0_24)
				return
			end)
			pg.NewStoryMgr.GetInstance():Play(var12_21, function(arg0_25, arg1_25)
				local var0_25 = arg1_25 or 1

				if var3_21.flag == ChapterConst.CellFlagActive then
					arg0_11:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpStory,
						id = var1_21.id,
						arg1 = var0_25
					})
				end

				if var11_21 ~= "" then
					local var1_25

					for iter0_25, iter1_25 in ipairs(pg.memory_template.all) do
						local var2_25 = pg.memory_template[iter1_25]

						if table.contains(var2_25.unlock_pre, var12_21) then
							var1_25 = var2_25.title
						end
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n(var11_21, var1_25))
				end
			end)
		end

		if not var4_21 then
			if var0_21:getRound() == ChapterConst.RoundEnemy then
				arg0_11:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpEnemyRound
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_click_to_move"))
			end
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		local var0_26 = arg0_11.contextData.chapterVO

		if var0_26 then
			if var0_26:existOni() then
				arg0_11:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_sphunt_help_tip")
				})
			elseif var0_26:isTypeDefence() then
				arg0_11:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("help_battle_defense")
				})
			elseif var0_26:isPlayingWithBombEnemy() then
				arg0_11:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_bomb_help_tip")
				})
			elseif pg.map_event_list[var0_26.id] and next(noEmptyStr(pg.map_event_list[var0_26.id].help_pictures) or {}) then
				local var1_26 = {
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

				for iter0_26, iter1_26 in pairs(pg.map_event_list[var0_26.id].help_pictures) do
					table.insert(var1_26, {
						icon = {
							path = "",
							atlas = iter1_26
						}
					})
				end

				arg0_11:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var1_26
				})
			else
				arg0_11:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = pg.gametip.help_level_ui.tip
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.airSupremacy, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_11, arg0_11.shengfuBtn, function()
		arg0_11:DisplayWinConditionPanel()
	end)
end

function var0_0.SetSeriesOperation(arg0_29, arg1_29)
	arg0_29.seriesOperation = arg1_29
end

function var0_0.SetGrid(arg0_30, arg1_30)
	arg0_30.grid = arg1_30
end

function var0_0.SetPlayer(arg0_31, arg1_31)
	return
end

function var0_0.SwitchToChapter(arg0_32, arg1_32)
	local var0_32 = findTF(arg0_32.topStage, "msg_panel/ambush")
	local var1_32 = findTF(arg0_32.rightStage, "target")
	local var2_32 = findTF(arg0_32.rightStage, "skip_events")

	setActive(var0_32, arg1_32:existAmbush())
	setActive(arg0_32.airSupremacy, OPEN_AIR_DOMINANCE and arg1_32:getConfig("air_dominance") > 0)

	local var3_32 = arg1_32:isLoop()

	setActive(arg0_32.autoBattleBtn, var3_32)

	if var3_32 then
		arg0_32:UpdateSkipPreCombatMark()
		arg0_32:UpdateAutoFightPanel()
		arg0_32:UpdateAutoFightMark()
	end

	arg0_32.achieveOriginalY = -240

	setText(var2_32:Find("Label"), i18n("map_event_skip"))

	local var4_32 = "skip_events_on_" .. arg1_32.id

	if arg1_32:getConfig("event_skip") == 1 then
		if arg1_32.progress > 0 or arg1_32.defeatCount > 0 or arg1_32.passCount > 0 then
			setActive(var2_32, true)

			var1_32.anchoredPosition = Vector2.New(var1_32.anchoredPosition.x, arg0_32.achieveOriginalY - 40)
			GetComponent(var2_32, typeof(Toggle)).isOn = PlayerPrefs.GetInt(var4_32, 1) == 1

			onToggle(arg0_32, var2_32, function(arg0_33)
				PlayerPrefs.SetInt(var4_32, arg0_33 and 1 or 0)
			end)
		else
			setActive(var2_32, false)

			if not PlayerPrefs.HasKey(var4_32) then
				PlayerPrefs.SetInt(var4_32, 0)
			end
		end
	else
		setActive(var2_32, false)

		var1_32.anchoredPosition = Vector2.New(var1_32.anchoredPosition.x, arg0_32.achieveOriginalY)
	end

	setActive(var1_32, arg1_32:existAchieve())
	setActive(arg0_32.retreatBtn, true)
	arg0_32.seriesOperation()
end

function var0_0.SwitchToMap(arg0_34)
	arg0_34:DestroyAutoFightPanel()
end

function var0_0.UpdateSkipPreCombatMark(arg0_35)
	local var0_35 = getProxy(ChapterProxy):GetSkipPrecombat() and "auto_battle_on" or "auto_battle_off"

	arg0_35.loader:GetOffSpriteRequest(arg0_35.autoBattleBtn)
	arg0_35.loader:GetSprite("ui/levelstageview_atlas", var0_35, arg0_35.autoBattleBtn, true)
end

function var0_0.updateStageInfo(arg0_36)
	local var0_36 = arg0_36.contextData.chapterVO
	local var1_36 = findTF(arg0_36.topStage, "timer")
	local var2_36 = findTF(arg0_36.topStage, "unlimit")

	setWidgetText(var1_36, "--:--:--")

	if arg0_36.stageTimer then
		arg0_36.stageTimer:Stop()
	end

	if var0_36:getRemainTime() > var0_36:getConfig("time") or var0_36:getConfig("time") >= 8640000 then
		setActive(var1_36, false)
		setActive(var2_36, true)
	else
		setActive(var1_36, true)
		setActive(var2_36, false)

		arg0_36.stageTimer = Timer.New(function()
			if IsNil(var1_36) then
				return
			end

			local var0_37 = var0_36:getRemainTime()

			setWidgetText(var1_36, pg.TimeMgr.GetInstance():DescCDTime(var0_37))
		end, 1, -1)

		arg0_36.stageTimer:Start()
		arg0_36.stageTimer.func()
	end
end

function var0_0.updateAmbushRate(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38.contextData.chapterVO

	if not var0_38:existAmbush() then
		return
	end

	local var1_38 = var0_38.fleet
	local var2_38 = var1_38:getInvestSums()
	local var3_38 = findTF(arg0_38.topStage, "msg_panel/ambush/label1")
	local var4_38 = findTF(arg0_38.topStage, "msg_panel/ambush/label2")
	local var5_38 = findTF(arg0_38.topStage, "msg_panel/ambush/value1")
	local var6_38 = findTF(arg0_38.topStage, "msg_panel/ambush/value2")

	setText(var3_38, i18n("level_scene_title_word_1"))
	setText(var5_38, math.floor(var2_38))
	setText(var4_38, i18n("level_scene_title_word_2"))

	if not var0_38.activateAmbush then
		setText(var6_38, i18n("ambush_display_none"))
		setTextColor(var6_38, Color.New(0.4, 0.4, 0.4))
	else
		local var7_38 = var0_38:getAmbushRate(var1_38, arg1_38)
		local var8_38, var9_38 = ChapterConst.GetAmbushDisplay((not arg2_38 or not var0_38:existEnemy(ChapterConst.SubjectPlayer, arg1_38.row, arg1_38.column)) and var7_38)

		setText(var6_38, var8_38)
		setTextColor(var6_38, var9_38)
	end
end

function var0_0.updateStageAchieve(arg0_39)
	local var0_39 = arg0_39.contextData.chapterVO

	if not var0_39:existAchieve() then
		return
	end

	local var1_39 = var0_39.achieves
	local var2_39 = findTF(arg0_39.rightStage, "target")

	setActive(var2_39, true)

	local var3_39 = findTF(var2_39, "detail")
	local var4_39 = findTF(var3_39, "achieve")
	local var5_39 = findTF(var3_39, "achieves")
	local var6_39 = findTF(var3_39, "click")
	local var7_39 = findTF(var2_39, "collapse")
	local var8_39 = findTF(var7_39, "star")
	local var9_39 = findTF(var7_39, "stars")

	setActive(var4_39, false)
	setActive(var8_39, false)
	removeAllChildren(var5_39)
	removeAllChildren(var9_39)

	for iter0_39, iter1_39 in ipairs(var1_39) do
		local var10_39 = cloneTplTo(var4_39, var5_39)
		local var11_39 = ChapterConst.IsAchieved(iter1_39)

		setActive(findTF(var10_39, "star"), var11_39)

		local var12_39 = findTF(var10_39, "desc")

		setText(var12_39, ChapterConst.GetAchieveDesc(iter1_39.type, var0_39))
		setTextColor(var12_39, var11_39 and Color.yellow or Color.white)

		cloneTplTo(var8_39, var9_39):GetComponent(typeof(Image)).enabled = var11_39
	end

	onButton(arg0_39, var6_39, function()
		shiftPanel(var3_39, var3_39.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_39, 0, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_39, var7_39, function()
		shiftPanel(var3_39, 30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_39, var7_39.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)

	if not arg0_39.isAchieveFirstInit then
		arg0_39.isAchieveFirstInit = true

		triggerButton(var6_39)
	end
end

function var0_0.updateStageBarrier(arg0_42)
	local var0_42 = arg0_42.contextData.chapterVO

	setActive(arg0_42.panelBarrier, var0_42:existOni())

	if not var0_42:existOni() then
		return
	end

	local var1_42 = arg0_42.panelBarrier:Find("btn_barrier")

	setText(var1_42:Find("nums"), var0_42.modelCount)
	onButton(arg0_42, var1_42, function()
		if arg0_42.grid.quadState == ChapterConst.QuadStateBarrierSetting then
			arg0_42.grid:updateQuadCells(ChapterConst.QuadStateNormal)

			return
		end

		arg0_42.grid:updateQuadCells(ChapterConst.QuadStateBarrierSetting)
	end, SFX_PANEL)
end

function var0_0.updateBombPanel(arg0_44, arg1_44)
	local var0_44 = arg0_44.contextData.chapterVO

	setActive(arg0_44.bombPanel, var0_44:isPlayingWithBombEnemy())

	if var0_44:isPlayingWithBombEnemy() then
		setText(arg0_44.bombPanel:Find("tx_step"), var0_44:getBombChapterInfo().action_times - math.floor(var0_44.roundIndex / 2))

		local var1_44 = arg0_44.bombPanel:Find("tx_score")
		local var2_44 = tonumber(getText(var1_44))
		local var3_44 = var0_44.modelCount

		LeanTween.cancel(go(var1_44))

		if arg1_44 and var2_44 ~= var3_44 then
			LeanTween.scale(go(var1_44), Vector3(1.5, 1.5, 1), 0.2)

			local var4_44 = (var3_44 - var2_44) * 0.1

			LeanTween.value(go(var1_44), var2_44, var3_44, var4_44):setOnUpdate(System.Action_float(function(arg0_45)
				setText(var1_44, math.floor(arg0_45))
			end)):setOnComplete(System.Action(function()
				setText(var1_44, var3_44)
			end)):setEase(LeanTweenType.easeInOutSine):setDelay(0.2)
			LeanTween.scale(go(var1_44), Vector3.one, 0.3):setDelay(1 + var4_44)
		else
			var1_44.localScale = Vector3.one

			setText(var1_44, var3_44)
		end
	end
end

function var0_0.updateFleetBuff(arg0_47)
	local var0_47 = arg0_47.contextData.chapterVO
	local var1_47 = var0_47.fleet
	local var2_47 = var0_47:GetShowingStrategies()

	if var0_47:getChapterSupportFleet() and not var0_47:IsSupportSubmarineStage() then
		table.insert(var2_47, ChapterConst.StrategyAirSupportFriendly)
	end

	local var3_47 = {}
	local var4_47 = var0_47:GetSubmarineFleet()

	if var4_47 then
		local var5_47 = _.filter(var4_47:getStrategies(), function(arg0_48)
			return pg.strategy_data_template[arg0_48.id].type == ChapterConst.StgTypePassive and arg0_48.count > 0
		end)

		if var5_47 and #var5_47 > 0 then
			_.each(var5_47, function(arg0_49)
				table.insert(var3_47, {
					id = arg0_49.id,
					count = arg0_49.count
				})
			end)
		end
	end

	local var6_47 = underscore.filter(var0_47:GetWeather(), function(arg0_50)
		local var0_50 = pg.weather_data_template[arg0_50]

		return noEmptyStr(var0_50.buff_icon)
	end)
	local var7_47 = 0

	if var0_47:ExistDivingChampion() then
		var7_47 = 1
	end

	local var8_47 = _.map(_.values(var1_47:getCommanders()), function(arg0_51)
		return arg0_51:getSkills()[1]
	end)
	local var9_47 = findTF(arg0_47.topStage, "icon_list/fleet_buffs")
	local var10_47 = UIItemList.New(var9_47, var9_47:GetChild(0))

	var10_47:make(function(arg0_52, arg1_52, arg2_52)
		setActive(findTF(arg2_52, "frame"), false)
		setActive(findTF(arg2_52, "Text"), false)
		setActive(findTF(arg2_52, "times"), false)

		if arg0_52 == UIItemList.EventUpdate then
			local var0_52 = GetComponent(arg2_52, typeof(LayoutElement))

			var0_52.preferredWidth = 64
			var0_52.preferredHeight = 64

			if arg1_52 + 1 <= #var2_47 then
				local var1_52 = var2_47[arg1_52 + 1]
				local var2_52 = pg.strategy_data_template[var1_52]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_52.icon, "", arg2_52)

				local var3_52

				if var2_52.type == ChapterConst.StgTypeBindFleetPassive then
					var3_52 = var1_47:GetStrategyCount(var1_52)

					setActive(findTF(arg2_52, "times"), true)
					setText(findTF(arg2_52, "times"), var3_52)
				end

				local var4_52 = var2_52.iconSize

				if var4_52 ~= "" then
					var0_52.preferredWidth = var4_52[1]
					var0_52.preferredHeight = var4_52[2]
				end

				onButton(arg0_47, arg2_52, function()
					arg0_47:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var2_52.id,
							cfg = var2_52,
							count = var3_52
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1_52 = arg1_52 - #var2_47

			if arg1_52 + 1 <= #var6_47 then
				local var5_52 = pg.weather_data_template[var6_47[arg1_52 + 1]]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var5_52.buff_icon, "", arg2_52)
				onButton(arg0_47, arg2_52, function()
					arg0_47:HandleShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var5_52.name,
						content = var5_52.buff_desc,
						iconPath = {
							"strategyicon/" .. var5_52.buff_icon
						},
						yesText = pg.MsgboxMgr.TEXT_CONFIRM
					})
				end, SFX_PANEL)

				return
			end

			arg1_52 = arg1_52 - #var6_47

			if arg1_52 + 1 <= #var3_47 then
				local var6_52 = var3_47[arg1_52 + 1]
				local var7_52 = pg.strategy_data_template[var6_52.id]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var7_52.icon, "", arg2_52)
				setActive(findTF(arg2_52, "times"), true)
				setText(findTF(arg2_52, "times"), var6_52.count)
				onButton(arg0_47, arg2_52, function()
					arg0_47:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var7_52.id,
							cfg = var7_52
						},
						extendDesc = string.format(i18n("word_rest_times"), var6_52.count)
					})
				end, SFX_PANEL)

				return
			end

			arg1_52 = arg1_52 - #var3_47

			if arg1_52 + 1 <= var7_47 then
				GetImageSpriteFromAtlasAsync("strategyicon/submarine_approach", "", arg2_52)
				onButton(arg0_47, arg2_52, function()
					arg0_47:HandleShowMsgBox({
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

			arg1_52 = arg1_52 - var7_47

			local var8_52 = var8_47[arg1_52 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var8_52:getConfig("icon"), "", arg2_52)
			setText(findTF(arg2_52, "Text"), "Lv." .. var8_52:getConfig("lv"))
			setActive(findTF(arg2_52, "Text"), true)
			setActive(findTF(arg2_52, "frame"), true)
			onButton(arg0_47, arg2_52, function()
				arg0_47:emit(LevelMediator2.ON_COMMANDER_SKILL, var8_52)
			end, SFX_PANEL)
		end
	end)
	var10_47:align(#var2_47 + #var3_47 + #var6_47 + var7_47 + #var8_47)

	if OPEN_AIR_DOMINANCE and var0_47:getConfig("air_dominance") > 0 then
		arg0_47:updateAirDominance()
	end

	arg0_47:updateEnemyCount()
	arg0_47:updateChapterBuff()
end

function var0_0.updateEnemyCount(arg0_58)
	local var0_58 = arg0_58.contextData.chapterVO
	local var1_58 = findTF(arg0_58.topStage, "icon_list/enemy_count")
	local var2_58 = tobool(underscore.detect(var0_58.achieves, function(arg0_59)
		return (arg0_59.type == ChapterConst.AchieveType3 or arg0_59.type == ChapterConst.AchieveType6) and not ChapterConst.IsAchieved(arg0_59)
	end))

	setActive(var1_58, var2_58)

	if var2_58 then
		local var3_58 = var0_58:getDisplayEnemyCount()

		setText(var1_58:Find("Text"), var3_58)
		GetImageSpriteFromAtlasAsync("enemycount", var3_58 > 0 and "danger" or "safe", var1_58)
		onButton(arg0_58, var1_58, function()
			if var3_58 > 0 then
				arg0_58:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_58),
					iconPath = {
						"enemycount",
						"danger"
					},
					yesText = i18n("star_require_enemy_check"),
					onYes = function()
						local var0_61 = var0_58:getNearestEnemyCell()

						arg0_58.grid:focusOnCell(var0_61)

						local var1_61 = arg0_58.grid:GetEnemyCellView(var0_61)

						if var1_61 and var1_61.TweenShining then
							var1_61:TweenShining(2)
						end
					end
				})
			else
				arg0_58:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_58),
					iconPath = {
						"enemycount",
						"safe"
					}
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateChapterBuff(arg0_62)
	local var0_62 = arg0_62.contextData.chapterVO
	local var1_62 = findTF(arg0_62.topStage, "icon_list/chapter_buff")
	local var2_62 = var0_62:hasMitigation()

	SetActive(var1_62, var2_62)

	if var2_62 then
		local var3_62 = var0_62:getRiskLevel()

		GetImageSpriteFromAtlasAsync("passstate", var3_62 .. "_icon", var1_62)
		onButton(arg0_62, var1_62, function()
			if not var0_62:hasMitigation() then
				return
			end

			arg0_62:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = var0_62:getChapterState(),
				iconPath = {
					"passstate",
					var3_62 .. "_icon"
				},
				content = i18n("level_risk_level_mitigation_rate", var0_62:getRemainPassCount(), var0_62:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateAirDominance(arg0_64)
	local var0_64, var1_64, var2_64 = arg0_64.contextData.chapterVO:getAirDominanceValue()

	if not var2_64 or var2_64 ~= var1_64 then
		arg0_64.contextData.chapterVO:setAirDominanceStatus(var1_64)
		getProxy(ChapterProxy):updateChapter(arg0_64.contextData.chapterVO)
	end

	arg0_64.isChange = var2_64 and (var1_64 == 0 and 3 or var1_64) - (var2_64 == 0 and 3 or var2_64)

	arg0_64:updateAirDominanceTitle(var0_64, var1_64, arg0_64.isChange or 0)
end

function var0_0.updateAirDominanceTitle(arg0_65, arg1_65, arg2_65, arg3_65)
	local var0_65 = findTF(arg0_65.airSupremacy, "label1")
	local var1_65 = findTF(arg0_65.airSupremacy, "label2")
	local var2_65 = findTF(arg0_65.airSupremacy, "value1")
	local var3_65 = findTF(arg0_65.airSupremacy, "value2")
	local var4_65 = findTF(arg0_65.airSupremacy, "up")
	local var5_65 = findTF(arg0_65.airSupremacy, "down")

	setText(var0_65, i18n("level_scene_title_word_3"))
	setText(var1_65, i18n("level_scene_title_word_4"))
	setText(var2_65, math.floor(arg1_65))
	setActive(var4_65, false)
	setActive(var5_65, false)

	if arg3_65 ~= 0 then
		if LeanTween.isTweening(go(var3_65)) then
			LeanTween.cancel(go(var3_65))
		end

		LeanTween.value(go(var3_65), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_66)
			setTextAlpha(var3_65, arg0_66)
		end)):setOnComplete(System.Action(function()
			setText(var3_65, ChapterConst.AirDominance[arg2_65].name)
			setTextColor(var3_65, ChapterConst.AirDominance[arg2_65].color)
			LeanTween.value(go(var3_65), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_68)
				setTextAlpha(var3_65, arg0_68)
			end))
		end))

		local function var6_65(arg0_69)
			setActive(arg0_69, false)
		end

		var4_65:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_65)
		var5_65:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_65)
		setActive(var4_65, arg3_65 > 0)
		setActive(var5_65, arg3_65 < 0)
	else
		setText(var3_65, ChapterConst.AirDominance[arg2_65].name)
		setTextColor(var3_65, ChapterConst.AirDominance[arg2_65].color)
	end
end

function var0_0.UpdateDefenseStatus(arg0_70)
	local var0_70 = arg0_70.contextData.chapterVO
	local var1_70 = var0_70:getPlayType() == ChapterConst.TypeDefence
	local var2_70 = findTF(arg0_70.bottomStage, "Normal/shengfu")

	setActive(var2_70, var1_70)

	if not var1_70 then
		return
	end

	local var3_70 = findTF(var2_70, "hp"):GetComponent(typeof(Text))
	local var4_70 = var0_70.id
	local var5_70 = pg.chapter_defense[var4_70]

	var3_70.text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(var0_70.BaseHP) .. "</color>", var5_70.port_hp)
end

function var0_0.DisplayWinConditionPanel(arg0_71)
	if not arg0_71.winCondPanel then
		arg0_71.winCondPanel = WinConditionDisplayPanel.New(arg0_71._tf.parent, arg0_71.event, arg0_71.contextData)

		arg0_71.winCondPanel:Load()
	end

	arg0_71.winCondPanel:ActionInvoke("Enter", arg0_71.contextData.chapterVO)
end

function var0_0.DestroyWinConditionPanel(arg0_72)
	if not arg0_72.winCondPanel then
		return
	end

	arg0_72.winCondPanel:Destroy()

	arg0_72.winCondPanel = nil
end

function var0_0.UpdateComboPanel(arg0_73)
	local var0_73 = arg0_73.contextData.chapterVO
	local var1_73 = pg.chapter_pop_template[var0_73.id]

	if var1_73 and var1_73.combo_on then
		local var2_73, var3_73 = arg0_73:GetSubView("LevelStageComboPanel")

		if var3_73 then
			var2_73:Load()
			var2_73.buffer:SetParent(arg0_73.leftStage, false)
		end

		local var4_73 = getProxy(ChapterProxy):GetComboHistory(var0_73.id)

		var2_73.buffer:UpdateView(var4_73 or var0_73)
		var2_73.buffer:UpdateViewAnimated(var0_73)
	end
end

function var0_0.UpdateDOALinkFeverPanel(arg0_74, arg1_74)
	local var0_74 = arg0_74.contextData.chapterVO
	local var1_74 = var0_74:GetBindActID()
	local var2_74 = var0_74:getConfig("levelstage_bar")

	if not var2_74 or var2_74 == "" then
		existCall(arg1_74)

		return
	end

	local var3_74, var4_74 = arg0_74:GetSubView(var2_74)

	if var4_74 then
		var3_74:Load()
		var3_74.buffer:SetParent(arg0_74._tf, false)
	end

	var3_74.buffer:UpdateView(var0_74, arg1_74)
end

local var2_0 = Vector2(396, 128)
local var3_0 = Vector2(128, 128)

function var0_0.updateStageStrategy(arg0_75)
	local var0_75 = arg0_75.contextData.chapterVO
	local var1_75 = findTF(arg0_75.rightStage, "event")
	local var2_75 = findTF(var1_75, "detail")
	local var3_75 = findTF(var2_75, "click")
	local var4_75 = findTF(var2_75, "items")

	var4_75:GetComponent(typeof(GridLayoutGroup)).cellSize = arg0_75._showStrategyDetail and var2_0 or var3_0

	local var5_75 = findTF(var4_75, "item")
	local var6_75 = findTF(var1_75, "collapse")

	setActive(var5_75, false)

	local var7_75 = var0_75:GetInteractableStrategies()
	local var8_75

	local function var9_75(arg0_76, arg1_76, arg2_76)
		if arg0_76 ~= UIItemList.EventUpdate then
			return
		end

		local var0_76 = arg2_76:Find("detail")

		setActive(var0_76, arg0_75._showStrategyDetail)

		local var1_76 = arg2_76:Find("icon")
		local var2_76 = var7_75[arg1_76 + 1]
		local var3_76
		local var4_76

		if var2_76.id == ChapterConst.StrategyHuntingRange then
			var3_76 = ChapterConst.StgTypeConst
			var4_76 = arg0_75.contextData.huntingRangeVisibility % 2 == 1 and "range_invisible" or "range_visible"

			setText(var0_76, i18n("help_sub_limits"))
		elseif var2_76.id == ChapterConst.StrategySubAutoAttack then
			var3_76 = ChapterConst.StgTypeConst
			var4_76 = var0_75.subAutoAttack == 0 and "sub_dont_auto_attack" or "sub_auto_attack"

			setText(var0_76, i18n("help_sub_display"))
		else
			local var5_76 = pg.strategy_data_template[var2_76.id]

			var3_76 = var5_76.type
			var4_76 = var5_76.icon

			setText(var0_76, var5_76.desc)
		end

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_76, "", var1_76:Find("icon"))
		onButton(arg0_75, var1_76, function()
			if var2_76.id == ChapterConst.StrategyHuntingRange then
				arg0_75.grid:toggleHuntingRange()
				var9_75(arg0_76, arg1_76, arg2_76)
			elseif var2_76.id == ChapterConst.StrategySubAutoAttack then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ai_change_" .. 1 - var0_75.subAutoAttack + 1))
				arg0_75:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubState,
					arg1 = 1 - var0_75.subAutoAttack
				})
			elseif var2_76.id == ChapterConst.StrategyExchange then
				local var0_77 = var0_75:getNextValidIndex()

				if var0_77 > 0 and var2_76.count > 0 then
					local var1_77 = var0_75.fleet

					arg0_75:HandleShowMsgBox({
						content = i18n("levelScene_who_to_exchange"),
						onYes = function()
							arg0_75:emit(LevelMediator2.ON_OP, {
								type = ChapterConst.OpStrategy,
								id = var1_77.id,
								arg1 = ChapterConst.StrategyExchange,
								arg2 = var0_75.fleets[var0_77].id
							})
						end
					})
				end
			elseif var2_76.id == ChapterConst.StrategySubTeleport then
				arg0_75:SwitchSubTeleportBottomStage()
				arg0_75:SwitchBottomStagePanel(true)
				arg0_75.grid:ShowStaticHuntingRange()
				arg0_75.grid:PrepareSubTeleport()
				arg0_75.grid:updateQuadCells(ChapterConst.QuadStateTeleportSub)
			elseif var2_76.id == ChapterConst.StrategyMissileStrike then
				if not var0_75.fleet:canUseStrategy(var2_76) then
					return
				end

				arg0_75:SwitchMissileBottomStagePanel()
				arg0_75:SwitchBottomStagePanel(true)
				arg0_75.grid:updateQuadCells(ChapterConst.QuadStateMissileStrike)
			elseif var2_76.id == ChapterConst.StrategyAirSupport then
				if not var0_75:getChapterSupportFleet():canUseStrategy(var2_76) then
					return
				end

				arg0_75:SwitchAirSupportBottomStagePanel()
				arg0_75:SwitchBottomStagePanel(true)
				arg0_75.grid:updateQuadCells(ChapterConst.QuadStateAirSuport)
			elseif var2_76.id == ChapterConst.StrategyExpel then
				if not var0_75:getChapterSupportFleet():canUseStrategy(var2_76) then
					return
				end

				arg0_75:SwitchAirExpelBottomStagePanel()
				arg0_75:SwitchBottomStagePanel(true)
				arg0_75.grid:updateQuadCells(ChapterConst.QuadStateExpel)
			elseif var3_76 == ChapterConst.StgTypeForm then
				local var2_77 = var0_75.fleet
				local var3_77 = table.indexof(ChapterConst.StrategyForms, var2_76.id)

				arg0_75:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpStrategy,
					id = var2_77.id,
					arg1 = ChapterConst.StrategyForms[var3_77 % #ChapterConst.StrategyForms + 1]
				})
			else
				arg0_75:emit(LevelUIConst.DISPLAY_STRATEGY_INFO, var2_76)
			end
		end, SFX_PANEL)

		if var3_76 == ChapterConst.StgTypeForm then
			setText(var1_76:Find("nums"), "")
			setActive(var1_76:Find("mask"), false)
			setActive(var1_76:Find("selected"), true)
		else
			setText(var1_76:Find("nums"), var2_76.count or "")
			setActive(var1_76:Find("mask"), var2_76.count == 0)
			setActive(var1_76:Find("selected"), false)
		end
	end

	UIItemList.StaticAlign(var4_75, var5_75, #var7_75, var9_75)
	onButton(arg0_75, var3_75, function()
		shiftPanel(var2_75, var2_75.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_75, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_75, var6_75, function()
		shiftPanel(var2_75, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_75, var6_75.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

function var0_0.GetSubView(arg0_81, arg1_81)
	if arg0_81.attachSubViews[arg1_81] then
		return arg0_81.attachSubViews[arg1_81]
	end

	local var0_81 = _G[arg1_81].New(arg0_81)

	assert(var0_81, "cant't find subview " .. (arg1_81 or "nil"))

	arg0_81.attachSubViews[arg1_81] = var0_81

	return var0_81, true
end

function var0_0.RemoveSubView(arg0_82, arg1_82)
	if not arg0_82.attachSubViews[arg1_82] then
		return false
	end

	arg0_82.attachSubViews[arg1_82]:Destroy()

	arg0_82.attachSubViews[arg1_82] = nil

	return true
end

function var0_0.ClearSubViews(arg0_83)
	for iter0_83, iter1_83 in pairs(arg0_83.attachSubViews) do
		iter1_83:Destroy()
	end

	table.clear(arg0_83.attachSubViews)
end

function var0_0.updateStageFleet(arg0_84)
	local var0_84 = arg0_84.contextData.chapterVO
	local var1_84 = findTF(arg0_84.leftStage, "fleet")
	local var2_84 = findTF(var1_84, "shiptpl")
	local var3_84 = arg0_84.topStage:Find("msg_panel/fleet_info/number")

	setActive(var2_84, false)
	setText(var3_84, var0_84.fleet.id)

	local var4_84 = var0_84.fleet:getShips(true)

	local function var5_84(arg0_85, arg1_85)
		local var0_85 = UIItemList.New(arg0_85, var2_84)

		var0_85:make(function(arg0_86, arg1_86, arg2_86)
			if arg0_86 == UIItemList.EventUpdate then
				local var0_86 = arg1_85[arg1_86 + 1]

				updateShip(arg2_86, var0_86)

				local var1_86 = var0_86.hpRant
				local var2_86 = var0_86:getShipProperties()
				local var3_86 = math.floor((var0_86.hpChange or 0) / 10000 * var2_86[AttributeType.Durability])
				local var4_86 = findTF(arg2_86, "HP_POP")

				setActive(var4_86, true)
				setActive(findTF(var4_86, "heal"), false)
				setActive(findTF(var4_86, "normal"), false)

				local function var5_86(arg0_87, arg1_87)
					setActive(arg0_87, true)
					setText(findTF(arg0_87, "text"), arg1_87)
					setTextAlpha(findTF(arg0_87, "text"), 0)
					LeanTween.moveY(arg0_87, 60, 1)
					LeanTween.textAlpha(findTF(arg0_87, "text"), 1, 0.3)
					LeanTween.textAlpha(findTF(arg0_87, "text"), 0, 0.5):setDelay(0.7):setOnComplete(System.Action(function()
						arg0_87.localPosition = Vector3(0, 0, 0)
					end))
				end

				if var3_86 > 0 then
					var5_86(findTF(var4_86, "heal"), var3_86)
				elseif var3_86 < 0 then
					LeanTween.delayedCall(0.6, System.Action(function()
						local var0_89 = arg2_86.transform.localPosition.x

						LeanTween.moveX(arg2_86, var0_89, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
						LeanTween.alpha(findTF(arg2_86, "red"), 0.5, 0.4)
						LeanTween.alpha(findTF(arg2_86, "red"), 0, 0.4):setDelay(0.4)
						var5_86(findTF(var4_86, "normal"), var3_86)
					end))
				end

				local var6_86 = findTF(arg2_86, "blood")
				local var7_86 = findTF(arg2_86, "blood/fillarea/green")
				local var8_86 = findTF(arg2_86, "blood/fillarea/red")
				local var9_86 = var1_86 < ChapterConst.HpGreen
				local var10_86 = var1_86 == 0

				setActive(var7_86, not var9_86)
				setActive(var8_86, var9_86)

				var6_86:GetComponent(typeof(Slider)).fillRect = var9_86 and var8_86 or var7_86

				setSlider(var6_86, 0, 10000, var1_86)
				setActive(findTF(arg2_86, "repairmask"), var9_86)
				setActive(findTF(arg2_86, "repairmask/broken"), var10_86)
				onButton(arg0_84, arg2_86:Find("repairmask"), function()
					arg0_84:emit(LevelUIConst.DISPLAY_REPAIR_WINDOW, var0_86)
				end, SFX_PANEL)

				local var11_86 = findTF(arg2_86, "repairmask/icon").gameObject

				if not var9_86 then
					LeanTween.cancel(var11_86)
					setImageAlpha(var11_86, 1)
				end

				if var9_86 and not LeanTween.isTweening(var11_86) then
					LeanTween.alpha(rtf(var11_86), 0, 2):setLoopPingPong()
				end

				local var12_86 = GetOrAddComponent(arg2_86, "UILongPressTrigger").onLongPressed

				pg.DelegateInfo.Add(arg0_84, var12_86)
				var12_86:RemoveAllListeners()
				var12_86:AddListener(function()
					arg0_84:emit(LevelMediator2.ON_STAGE_SHIPINFO, {
						shipId = var0_86.id,
						shipVOs = var4_84
					})
				end)
			end
		end)
		var0_85:align(#arg1_85)
	end

	var5_84(var1_84:Find("main"), var0_84.fleet:getShipsByTeam(TeamType.Main, true))
	var5_84(var1_84:Find("vanguard"), var0_84.fleet:getShipsByTeam(TeamType.Vanguard, true))
	var0_84.fleet:clearShipHpChange()
end

function var0_0.updateSupportFleet(arg0_92)
	local var0_92 = arg0_92.contextData.chapterVO:getChapterSupportFleet()
	local var1_92 = findTF(arg0_92.leftStage, "support_fleet")

	setActive(var1_92, tobool(var0_92))

	if var0_92 then
		local var2_92 = findTF(var1_92, "show/ship_container")

		removeAllChildren(var2_92)

		local var3_92 = findTF(var1_92, "show/shiptpl")
		local var4_92 = var0_92:getShips()

		for iter0_92, iter1_92 in pairs(var4_92) do
			local var5_92 = cloneTplTo(var3_92, var2_92)

			setActive(var5_92, true)
			updateShip(var5_92, iter1_92)
		end

		local var6_92 = var1_92:Find("hide")
		local var7_92 = var1_92:Find("show")

		local function var8_92(arg0_93)
			setActive(var6_92, true)
			setActive(var7_92, true)
			shiftPanel(var7_92, nil, arg0_93 and -325.1 or -855, 0.3, 0, true, nil, LeanTweenType.easeOutSine, function()
				setActive(var6_92, not arg0_93)
				setActive(var7_92, arg0_93)
			end)
			shiftPanel(var6_92, nil, arg0_93 and -1017 or -563.97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		end

		onButton(arg0_92, var6_92, function()
			var8_92(true)
		end, SFX_PANEL)
		onButton(arg0_92, var7_92, function()
			var8_92(false)
		end)
	end
end

function var0_0.ShiftStagePanelIn(arg0_97, arg1_97)
	shiftPanel(arg0_97.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_97)
	arg0_97:ShiftBottomStage(true)
	shiftPanel(arg0_97.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_97.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftStagePanelOut(arg0_98, arg1_98)
	shiftPanel(arg0_98.topStage, 0, arg0_98.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_98)
	arg0_98:ShiftBottomStage(false)
	shiftPanel(arg0_98.leftStage, -arg0_98.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_98.rightStage, arg0_98.rightStage.rect.width + 300, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftBottomStage(arg0_99, arg1_99)
	arg1_99 = not arg0_99.bottomStageInactive and arg1_99

	local var0_99 = arg1_99 and 0 or -arg0_99.bottomStage.rect.height

	shiftPanel(arg0_99.bottomStage, 0, var0_99, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.SwitchSubTeleportBottomStage(arg0_100)
	setActive(arg0_100.missileStrikeRole, true)
	setText(findTF(arg0_100.missileStrikeRole, "confirm_button/Text"), i18n("levelscene_deploy_submarine"))
	setText(findTF(arg0_100.missileStrikeRole, "cancel_button/Text"), i18n("levelscene_deploy_submarine_cancel"))
	onButton(arg0_100, arg0_100.missileStrikeRole:Find("confirm_button"), function()
		local var0_101 = arg0_100.contextData.chapterVO
		local var1_101 = var0_101:GetSubmarineFleet()
		local var2_101 = var1_101.startPos
		local var3_101 = arg0_100.grid.subTeleportTargetLine

		if not var3_101 then
			return
		end

		local var4_101 = var0_101:findPath(nil, var2_101, var3_101)
		local var5_101 = arg0_100.grid:TransformLine2PlanePos(var2_101)
		local var6_101 = arg0_100.grid:TransformLine2PlanePos(var3_101)
		local var7_101 = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #var1_101:getShips(false) * var4_101 - 1e-05)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", var5_101, var6_101, var4_101, var7_101),
			onYes = function()
				arg0_100:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = var1_101.id,
					arg1 = var3_101.row,
					arg2 = var3_101.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_100, arg0_100.missileStrikeRole:Find("cancel_button"), function()
		arg0_100:SwitchBottomStagePanel(false)
		arg0_100.grid:TurnOffSubTeleport()
		arg0_100.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchMissileBottomStagePanel(arg0_104)
	setActive(arg0_104.missileStrikeRole, true)
	setText(findTF(arg0_104.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_104.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_104, arg0_104.missileStrikeRole:Find("confirm_button"), function()
		local var0_105 = arg0_104.grid.missileStrikeTargetLine

		if not var0_105 then
			return
		end

		local var1_105 = arg0_104.contextData.chapterVO.fleet

		;(function()
			arg0_104:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_105.id,
				arg1 = ChapterConst.StrategyMissileStrike,
				arg2 = var0_105.row,
				arg3 = var0_105.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_104, arg0_104.missileStrikeRole:Find("cancel_button"), function()
		arg0_104:SwitchBottomStagePanel(false)
		arg0_104.grid:HideMissileAimingMark()
		arg0_104.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirSupportBottomStagePanel(arg0_108)
	setActive(arg0_108.missileStrikeRole, true)
	setText(findTF(arg0_108.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_108.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_108, arg0_108.missileStrikeRole:Find("confirm_button"), function()
		local var0_109 = arg0_108.grid.missileStrikeTargetLine

		if not var0_109 then
			return
		end

		local var1_109 = arg0_108.contextData.chapterVO:getChapterSupportFleet()

		;(function()
			arg0_108:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_109.id,
				arg1 = ChapterConst.StrategyAirSupport,
				arg2 = var0_109.row,
				arg3 = var0_109.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_108, arg0_108.missileStrikeRole:Find("cancel_button"), function()
		arg0_108:SwitchBottomStagePanel(false)
		arg0_108.grid:HideAirSupportAimingMark()
		arg0_108.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirExpelBottomStagePanel(arg0_112)
	setActive(arg0_112.airExpelRole, true)
	setText(findTF(arg0_112.airExpelRole, "cancel_button/Text"), i18n("levelscene_airexpel_cancel"))
	onButton(arg0_112, arg0_112.airExpelRole:Find("cancel_button"), function()
		arg0_112:SwitchBottomStagePanel(false)
		arg0_112.grid:HideAirExpelAimingMark()
		arg0_112.grid:CleanAirSupport()
		arg0_112.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchBottomStagePanel(arg0_114, arg1_114)
	setActive(arg0_114.actionRole, true)
	setActive(arg0_114.normalRole, true)
	shiftPanel(arg0_114.actionRole, 0, arg1_114 and 0 or var1_0, 0.3, 0, true, true, nil, function()
		setActive(arg0_114.actionRole, arg1_114)
	end)
	shiftPanel(arg0_114.normalRole, 0, arg1_114 and var1_0 or 0, 0.3, 0, true, true, nil, function()
		setActive(arg0_114.normalRole, not arg1_114)

		if not arg1_114 then
			eachChild(arg0_114.actionRole, function(arg0_117)
				setActive(arg0_117, false)
			end)
		end
	end)
	shiftPanel(arg0_114.leftStage, arg1_114 and -arg0_114.leftStage.rect.width - 200 or 0, 0, 0.3, 0, true)
	shiftPanel(arg0_114.rightStage, arg1_114 and arg0_114.rightStage.rect.width + 300 or 0, 0, 0.3, 0, true)
end

function var0_0.ClickGridCellNormal(arg0_118, arg1_118)
	local var0_118 = arg0_118.contextData.chapterVO
	local var1_118 = var0_118.fleet
	local var2_118 = _.detect(var0_118.fleets, function(arg0_119)
		return arg0_119:getFleetType() == FleetType.Normal and arg0_119.line.row == arg1_118.row and arg0_119.line.column == arg1_118.column
	end)

	if var2_118 and var2_118:isValid() and var2_118.id ~= var1_118.id then
		arg0_118:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var2_118.id
		})

		return
	end

	if arg0_118:tryAutoTrigger(nil, true) then
		return
	end

	if arg1_118.row == var1_118.line.row and arg1_118.column == var1_118.line.column then
		return
	end

	local var3_118 = var0_118:getChapterCell(arg1_118.row, arg1_118.column)

	if var3_118.attachment == ChapterConst.AttachStory and var3_118.data == ChapterConst.StoryObstacle and var3_118.flag == ChapterConst.CellFlagTriggerActive then
		local var4_118 = pg.map_event_template[var3_118.attachmentId]

		if var4_118 and var4_118.gametip and #var4_118.gametip > 0 and var0_118:getPlayType() ~= ChapterConst.TypeDefence then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var4_118.gametip))
		end

		return
	elseif not var0_118:considerAsStayPoint(ChapterConst.SubjectPlayer, arg1_118.row, arg1_118.column) then
		return
	elseif var0_118:existMoveLimit() then
		local var5_118 = var0_118:calcWalkableCells(ChapterConst.SubjectPlayer, var1_118.line.row, var1_118.line.column, var1_118:getSpeed())

		if not _.any(var5_118, function(arg0_120)
			return arg0_120.row == arg1_118.row and arg0_120.column == arg1_118.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))

			return
		end
	end

	local var6_118 = var0_118:findPath(ChapterConst.SubjectPlayer, var1_118.line, {
		row = arg1_118.row,
		column = arg1_118.column
	})

	if var6_118 < PathFinding.PrioObstacle then
		arg0_118:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var1_118.id,
			arg1 = arg1_118.row,
			arg2 = arg1_118.column
		})
	elseif var6_118 < PathFinding.PrioForbidden then
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	end
end

function var0_0.tryAutoAction(arg0_121, arg1_121)
	if arg0_121.doingAutoAction then
		return
	end

	arg0_121.doingAutoAction = true

	local var0_121 = arg0_121.contextData.chapterVO

	if not var0_121 then
		existCall(arg1_121)

		return
	end

	if arg0_121:SafeCheck() then
		existCall(arg1_121)

		return
	end

	local var1_121 = {}
	local var2_121 = false

	for iter0_121, iter1_121 in pairs(var0_121.cells) do
		if iter1_121.trait == ChapterConst.TraitLurk then
			var2_121 = true

			break
		end
	end

	if not var2_121 then
		for iter2_121, iter3_121 in ipairs(var0_121.champions) do
			if iter3_121.trait == ChapterConst.TraitLurk then
				var2_121 = true

				break
			end
		end
	end

	if var2_121 then
		local var3_121 = var0_121:existOni()
		local var4_121 = var0_121:isPlayingWithBombEnemy()

		if not var3_121 and not var4_121 then
			table.insert(var1_121, function(arg0_122)
				arg0_121:emit(LevelUIConst.DO_TRACKING, arg0_122)
			end)
		else
			table.insertto(var1_121, {
				function(arg0_123)
					local var0_123

					if var3_121 then
						var0_123 = "SpUnit"
					elseif var4_121 then
						var0_123 = "SpBomb"
					end

					assert(var0_123)
					arg0_121:emit(LevelUIConst.DO_PLAY_ANIM, {
						name = var0_123,
						callback = function(arg0_124)
							setActive(arg0_124, false)
							arg0_123()
						end
					})
				end,
				function(arg0_125)
					local var0_125 = var0_121:getSpAppearStory()

					if var0_125 and #var0_125 > 0 then
						pg.NewStoryMgr.GetInstance():Play(var0_125, arg0_125)

						return
					end

					arg0_125()
				end,
				function(arg0_126)
					local var0_126 = var0_121:getSpAppearGuide()

					if var0_126 and #var0_126 > 0 then
						pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_126, nil, arg0_126)

						return
					end

					arg0_126()
				end
			})
		end

		table.insertto(var1_121, {
			function(arg0_127)
				parallelAsync({
					function(arg0_128)
						arg0_121:tryPlayChapterStory(arg0_128)
					end,
					function(arg0_129)
						local var0_129 = var0_121:GetBossCell()

						if var0_129 and var0_129.trait == ChapterConst.TraitLurk then
							arg0_121.grid:focusOnCell(var0_129, arg0_129)

							return
						end

						arg0_129()
					end
				}, arg0_127)
			end,
			function(arg0_130)
				arg0_121:updateTrait(ChapterConst.TraitVirgin)
				arg0_121.grid:updateAttachments()
				arg0_121.grid:updateChampions()
				arg0_121:updateTrait(ChapterConst.TraitNone)
				arg0_121:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
				Timer.New(arg0_130, 0.5, 1):Start()
			end
		})
	end

	seriesAsync({
		function(arg0_131)
			arg0_121:emit(LevelUIConst.FROZEN)

			local var0_131 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_121.id)

			if var0_131 and (var0_131.attachment ~= ChapterConst.AttachAmbush or ChapterConst.IsBossCell(var0_131)) then
				local var1_131 = ChapterConst.GetDestroyFX(var0_131)

				arg0_121.grid:PlayAttachmentEffect(var0_131.line.row, var0_131.line.column, var1_131, Vector2.zero)
			end

			arg0_121:PopBar()
			arg0_121:UpdateComboPanel()
			arg0_131()
		end,
		function(arg0_132)
			if not (function()
				local var0_133 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_121.id)

				if not var0_133 then
					return
				end

				local var1_133 = pg.expedition_data_template[var0_133.attachmentId]

				return var1_133 and var1_133.type == ChapterConst.ExpeditionTypeMulBoss
			end)() then
				return arg0_132()
			end

			arg0_121:emit(LevelUIConst.DO_PLAY_ANIM, {
				name = "BossRetreatBar",
				callback = function(arg0_134)
					setActive(arg0_134, false)
					arg0_132()
				end
			})
		end,
		function(arg0_135)
			arg0_121:UpdateDOALinkFeverPanel(arg0_135)
		end,
		function(arg0_136)
			seriesAsync(var1_121, arg0_136)
		end,
		function(arg0_137)
			local var0_137, var1_137 = var0_121:GetAttachmentStories()

			if var0_137 then
				table.SerialIpairsAsync(var0_137, function(arg0_138, arg1_138, arg2_138)
					if arg0_138 <= var1_137 and arg1_138 and type(arg1_138) == "number" and arg1_138 > 0 then
						local var0_138 = pg.NewStoryMgr:StoryId2StoryName(arg1_138)

						ChapterOpCommand.PlayChapterStory(var0_138, arg2_138, var0_121:IsAutoFight())

						return
					end

					arg2_138()
				end, arg0_137)

				return
			end

			arg0_137()
		end,
		function(arg0_139)
			local var0_139 = arg0_121.contextData.chapterVO.id
			local var1_139 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_139)

			if not var1_139 or #var1_139 < 1 then
				arg0_139()

				return
			end

			for iter0_139, iter1_139 in ipairs(var1_139) do
				local var2_139 = pg.chapter_status_effect[iter1_139]
				local var3_139 = var2_139 and var2_139.camera_focus or ""

				if type(var3_139) == "table" then
					arg0_121.grid:focusOnCell({
						row = var3_139[1],
						column = var3_139[2]
					}, arg0_139)

					return
				end
			end

			arg0_139()
		end,
		function(arg0_140)
			if arg0_121.exited then
				return
			end

			arg0_121:emit(LevelUIConst.UN_FROZEN)
			;(function()
				local var0_141 = getProxy(ChapterProxy)
				local var1_141 = var0_141:getActiveChapter(true)

				if not var1_141 then
					return
				end

				local var2_141 = var1_141.id

				var0_141:RecordComboHistory(var2_141, nil)
				var0_141:RecordLastDefeatedEnemy(var2_141, nil)
				var0_141:extraFlagUpdated(var2_141)
				var0_141:RemoveExtendChapterData(var2_141, "FleetMoveDistance")
			end)()
			arg0_140()
		end
	}, function()
		if arg0_121.exited then
			return
		end

		arg0_121.doingAutoAction = nil

		if var2_121 and arg0_121:TryEnterChapterStoryStage() then
			-- block empty
		else
			existCall(arg1_121)
		end
	end)
end

function var0_0.tryPlayChapterStory(arg0_143, arg1_143)
	local var0_143 = arg0_143.contextData.chapterVO
	local var1_143 = var0_143:getWaveCount()

	seriesAsync({
		function(arg0_144)
			pg.SystemGuideMgr.GetInstance():PlayChapter(var0_143, arg0_144)
		end,
		function(arg0_145)
			local var0_145 = var0_143:getConfig("story_refresh")
			local var1_145 = var0_145 and var0_145[var1_143]

			if var1_145 and type(var1_145) == "string" and var1_145 ~= "" and not var0_143:IsRemaster() then
				ChapterOpCommand.PlayChapterStory(var1_145, arg0_145, var0_143:IsAutoFight())

				return
			end

			arg0_145()
		end,
		function(arg0_146)
			local var0_146 = var0_143:getConfig("story_refresh_boss")

			if var0_146 and type(var0_146) == "string" and var0_146 ~= "" and not var0_143:IsRemaster() and var0_143:IsFinalBossRefreshed() then
				ChapterOpCommand.PlayChapterStory(var0_146, arg0_146, var0_143:IsAutoFight())

				return
			end

			arg0_146()
		end,
		function(arg0_147)
			if var1_143 == 1 and pg.map_event_list[var0_143.id] and pg.map_event_list[var0_143.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. var0_143.id, 0) == 0 then
				triggerButton(arg0_143.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. var0_143.id, 1)
			end

			arg0_147()
		end,
		function()
			existCall(arg1_143)
		end
	})
end

function var0_0.TryEnterChapterStoryStage(arg0_149, arg1_149)
	local var0_149 = arg0_149.contextData.chapterVO
	local var1_149 = var0_149:getWaveCount()
	local var2_149 = var0_149:getConfig("story_refresh")
	local var3_149 = var2_149 and var2_149[var1_149]

	if var3_149 and type(var3_149) == "number" and not var0_149:IsRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var3_149)) then
		arg0_149:emit(LevelMediator2.ON_PERFORM_COMBAT, var3_149)

		return true
	end

	local var4_149 = var0_149:getConfig("story_refresh_boss")

	if var4_149 and type(var4_149) == "number" and not var0_149:IsRemaster() and var0_149:IsFinalBossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var4_149)) then
		arg0_149:emit(LevelMediator2.ON_PERFORM_COMBAT, var4_149)

		return true
	end
end

function var0_0.TryEnterChapterSupportSubmarineStage(arg0_150, arg1_150)
	local var0_150 = arg0_150.contextData.chapterVO
	local var1_150 = var0_150:getChapterSupportFleet()
	local var2_150 = {}

	if var0_150:getChapterSupportFleet() then
		arg0_150:emit(LevelMediator2.ON_SUPPORT_SUBMARINE)
	else
		arg0_150:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OPSubStrike,
			arg1 = ys.Battle.BattleConst.BattleScore.C,
			callback = arg1_150
		})
	end
end

local var4_0 = {
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

function var0_0.PopBar(arg0_151)
	local var0_151 = arg0_151.contextData.chapterVO.id
	local var1_151 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_151)

	if not var1_151 or #var1_151 < 1 then
		return
	end

	local var2_151 = var1_151[1]
	local var3_151 = var4_0[var2_151]

	if not var3_151 then
		return
	end

	local var4_151, var5_151 = arg0_151:GetSubView(var3_151)

	if var5_151 then
		var4_151:Load()
	end

	var4_151.buffer:PlayAnim()
end

function var0_0.updateTrait(arg0_152, arg1_152)
	local var0_152 = arg0_152.contextData.chapterVO

	for iter0_152, iter1_152 in pairs(var0_152.cells) do
		if iter1_152.trait ~= ChapterConst.TraitNone then
			iter1_152.trait = arg1_152
		end
	end

	for iter2_152, iter3_152 in ipairs(var0_152.champions) do
		if iter3_152.trait ~= ChapterConst.TraitNone then
			iter3_152.trait = arg1_152
		end
	end
end

function var0_0.CheckFleetChange(arg0_153)
	local var0_153 = arg0_153.contextData.chapterVO
	local var1_153 = var0_153:GetActiveFleet()
	local var2_153 = _.detect(var0_153.fleets, function(arg0_154)
		return not arg0_154:isValid()
	end)

	if var2_153 then
		arg0_153:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRetreat,
			id = var2_153.id
		})

		if var2_153:getFleetType() == TeamType.Normal then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
		end
	end

	if not var1_153:isValid() then
		local var3_153 = var0_153:getNextValidIndex()

		if var3_153 > 0 then
			local var4_153 = var0_153.fleets[var3_153]

			local function var5_153()
				arg0_153:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSwitch,
					id = var4_153.id
				})
			end

			arg0_153:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("formation_switch_tip", var4_153.name),
				onYes = var5_153,
				onNo = var5_153
			})
		end

		return true
	end

	return false
end

function var0_0.tryAutoTrigger(arg0_156, arg1_156, arg2_156)
	local var0_156 = arg0_156.contextData.chapterVO

	if arg0_156:DoBreakAction() then
		return
	end

	if arg0_156:CheckFleetChange() then
		return
	end

	return ((function()
		if var0_156:checkAnyInteractive() then
			if not arg1_156 or var0_156:IsAutoFight() then
				triggerButton(arg0_156.funcBtn)

				return true
			end
		elseif var0_156:getRound() == ChapterConst.RoundEnemy then
			arg0_156:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpEnemyRound
			})

			return true
		elseif var0_156:getRound() == ChapterConst.RoundPlayer then
			if not arg2_156 then
				arg0_156.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			end

			if var0_156:IsAutoFight() then
				arg0_156:TryAutoFight()

				return true
			end
		end
	end)())
end

function var0_0.DoBreakAction(arg0_158)
	local var0_158 = arg0_158.contextData.chapterVO
	local var1_158, var2_158 = arg0_158:SafeCheck()

	if var1_158 then
		local function var3_158(arg0_159)
			local var0_159

			seriesAsync({
				function(arg0_160)
					arg0_158:emit(LevelUIConst.ADD_MSG_QUEUE, arg0_160)
				end,
				function(arg0_161, arg1_161)
					var0_159 = arg1_161

					ChapterOpCommand.PrepareChapterRetreat(arg0_161)
				end,
				function(arg0_162)
					existCall(arg0_159)
					existCall(var0_159)
				end
			})
		end

		if var2_158 == ChapterConst.ReasonVictory then
			seriesAsync({
				function(arg0_163)
					var3_158(arg0_163)
				end,
				function(arg0_164)
					local var0_164 = var0_158:getConfig("win_condition_display") and #var0_164 > 0 and var0_164 .. "_tip"

					if var0_164 and pg.gametip[var0_164] then
						pg.TipsMgr.GetInstance():ShowTips(i18n(var0_164))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_win"))
					end

					arg0_164()
				end
			})
		elseif var2_158 == ChapterConst.ReasonDefeat then
			if var0_158:getPlayType() == ChapterConst.TypeTransport then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_escort_lose"))
				var3_158()
			else
				arg0_158:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("formation_invalide"),
					onYes = var3_158,
					onClose = var3_158
				})
			end
		elseif var2_158 == ChapterConst.ReasonDefeatDefense then
			arg0_158:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("harbour_bomb_tip"),
				onYes = var3_158,
				onClose = var3_158
			})
		elseif var2_158 == ChapterConst.ReasonVictoryOni then
			var3_158()
		elseif var2_158 == ChapterConst.ReasonDefeatOni then
			var3_158()
		elseif var2_158 == ChapterConst.ReasonDefeatBomb then
			var3_158()
		elseif var2_158 == ChapterConst.ReasonOutTime then
			arg0_158:emit(LevelMediator2.ON_TIME_UP)
		elseif var2_158 == ChapterConst.ReasonActivityOutTime then
			arg0_158:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_activity_timeout"),
				onYes = var3_158,
				onClose = var3_158
			})
		end

		return true
	end

	return var1_158
end

function var0_0.SafeCheck(arg0_165)
	local var0_165 = arg0_165.contextData.chapterVO

	if var0_165:existOni() then
		local var1_165 = var0_165:checkOniState()

		if var1_165 == 1 then
			return true, ChapterConst.ReasonVictoryOni
		elseif var1_165 == 2 then
			return true, ChapterConst.ReasonDefeatOni
		else
			return false
		end
	elseif var0_165:isPlayingWithBombEnemy() then
		if var0_165:getBombChapterInfo().action_times * 2 <= var0_165.roundIndex then
			return true, ChapterConst.ReasonDefeatBomb
		else
			return false
		end
	end

	local var2_165, var3_165 = var0_165:CheckChapterWin()

	if var2_165 then
		return true, var3_165
	end

	local var4_165, var5_165 = var0_165:CheckChapterLose()

	if var4_165 then
		return true, var5_165
	end

	if not var0_165:inWartime() then
		return true, ChapterConst.ReasonOutTime
	end

	local var6_165 = var0_165:GetBindActID()

	if not arg0_165.contextData.map:isRemaster() and var6_165 ~= 0 then
		local var7_165 = getProxy(ActivityProxy):getActivityById(var6_165)

		if not var7_165 or var7_165:isEnd() then
			return true, ChapterConst.ReasonActivityOutTime
		end
	end

	return false
end

function var0_0.TryAutoFight(arg0_166)
	local var0_166 = arg0_166.contextData.chapterVO
	local var1_166 = arg0_166.contextData.map

	if not var0_166:IsAutoFight() then
		return
	end

	local var2_166 = var0_166:GetAllEnemies()
	local var3_166 = _.detect(var2_166, function(arg0_167)
		return ChapterConst.IsBossCell(arg0_167)
	end)
	local var4_166 = var0_166:GetFleetOfDuty(tobool(var3_166))

	if var4_166 and var4_166.id ~= var0_166.fleet.id then
		arg0_166:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var4_166.id
		})
		arg0_166:tryAutoTrigger()

		return
	end

	if var0_166:checkAnyInteractive() then
		arg0_166:tryAutoTrigger()

		return
	end

	local var5_166

	for iter0_166, iter1_166 in ipairs(var0_166:getConfig("box_auto_pick")) do
		local var6_166 = underscore.filter(switch(iter1_166, {
			[ChapterConst.AttachBox] = function()
				return var0_166:findChapterCells(iter1_166)
			end,
			[ChapterConst.AttachSupply] = function()
				local var0_169, var1_169 = var0_166:getFleetAmmo(var4_166)

				if var0_169 - var1_169 < 3 then
					return {}
				else
					return underscore.filter(var0_166:findChapterCells(iter1_166), function(arg0_170)
						return arg0_170.attachmentId > 0
					end)
				end
			end
		}), function(arg0_171)
			return arg0_171.flag ~= ChapterConst.CellFlagDisabled
		end)

		for iter2_166, iter3_166 in ipairs(var6_166) do
			local var7_166, var8_166 = var0_166:findPath(ChapterConst.SubjectPlayer, var4_166.line, iter3_166)

			if var7_166 < PathFinding.PrioObstacle then
				var5_166 = var5_166 or {}

				table.insert(var5_166, {
					target = iter3_166,
					priority = var7_166,
					path = var8_166
				})
			end
		end

		if var5_166 then
			table.sort(var5_166, CompareFuncs({
				function(arg0_172)
					return arg0_172.priority
				end
			}))

			break
		end
	end

	if not var5_166 then
		if var3_166 then
			local var9_166, var10_166 = var0_166:FindBossPath(var4_166.line, var3_166)
			local var11_166 = {}
			local var12_166

			for iter4_166, iter5_166 in ipairs(var10_166) do
				table.insert(var11_166, iter5_166)

				if var0_166:existEnemy(ChapterConst.SubjectPlayer, iter5_166.row, iter5_166.column) then
					var9_166 = iter4_166
					var12_166 = iter5_166

					break
				end
			end

			var5_166 = {
				{
					target = var12_166 or var3_166,
					priority = var9_166 or 0,
					path = var11_166
				}
			}
		else
			var5_166 = underscore.map(var2_166, function(arg0_173)
				local var0_173, var1_173 = var0_166:findPath(ChapterConst.SubjectPlayer, var4_166.line, arg0_173)

				return {
					target = arg0_173,
					priority = var0_173,
					path = var1_173
				}
			end)

			local function var13_166(arg0_174)
				local var0_174 = arg0_174.target
				local var1_174 = pg.expedition_data_template[var0_174.attachmentId]

				assert(var1_174, "expedition_data_template not exist: " .. var0_174.attachmentId)

				if var0_174.flag == ChapterConst.CellFlagDisabled then
					return 0
				end

				return ChapterConst.EnemyPreference[var1_174.type]
			end

			if var0_166.id == 1604 then
				table.sort(var5_166, CompareFuncs({
					function(arg0_175)
						return arg0_175.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_176)
						return -var13_166(arg0_176)
					end,
					function(arg0_177)
						return arg0_177.priority
					end,
					function(arg0_178)
						return arg0_178.target.row
					end,
					function(arg0_179)
						return -arg0_179.target.column
					end
				}))
			else
				table.sort(var5_166, CompareFuncs({
					function(arg0_180)
						return arg0_180.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_181)
						return -var13_166(arg0_181)
					end,
					function(arg0_182)
						return arg0_182.priority
					end
				}))
			end
		end
	end

	if var5_166 and #var5_166 > 0 and var5_166[1].priority < PathFinding.PrioObstacle then
		local var14_166 = var5_166[1].target

		arg0_166:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var4_166.id,
			arg1 = var14_166.row,
			arg2 = var14_166.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(var0_166.id, false)
	end
end

function var0_0.popStageStrategy(arg0_183)
	local var0_183 = arg0_183.rightStage:Find("event/collapse")

	if var0_183.anchoredPosition.x <= 1 then
		triggerButton(var0_183)
	end
end

function var0_0.UpdateAutoFightPanel(arg0_184)
	if arg0_184.contextData.chapterVO:CanActivateAutoFight() then
		if not arg0_184.autoFightPanel then
			arg0_184.autoFightPanel = LevelStageAutoFightPanel.New(arg0_184.rightStage:Find("event/collapse"), arg0_184.event, arg0_184.contextData)

			arg0_184.autoFightPanel:Load()

			arg0_184.autoFightPanel.isFrozen = arg0_184.isFrozen
		end

		arg0_184.autoFightPanel.buffer:Show()
	elseif arg0_184.autoFightPanel then
		arg0_184.autoFightPanel.buffer:Hide()
	end
end

function var0_0.UpdateAutoFightMark(arg0_185)
	if not arg0_185.autoFightPanel then
		return
	end

	arg0_185.autoFightPanel.buffer:UpdateAutoFightMark()
end

function var0_0.DestroyAutoFightPanel(arg0_186)
	if not arg0_186.autoFightPanel then
		return
	end

	arg0_186.autoFightPanel:Destroy()

	arg0_186.autoFightPanel = nil
end

function var0_0.DestroyToast(arg0_187)
	if not arg0_187.toastPanel then
		return
	end

	arg0_187.toastPanel:Destroy()

	arg0_187.toastPanel = nil
end

function var0_0.Toast(arg0_188)
	arg0_188:DestroyToast()

	local var0_188 = table.remove(arg0_188.toastQueue, 1)

	if not var0_188 then
		return
	end

	arg0_188.toastPanel = var0_188.Class.New(arg0_188)

	arg0_188.toastPanel:Load()

	arg0_188.toastPanel.contextData.settings = var0_188

	arg0_188.toastPanel.buffer:Play(function()
		arg0_188:Toast()
	end)
end

function var0_0.HandleShowMsgBox(arg0_190, arg1_190)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_190)
end

return var0_0
