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

function var0_0.OnInit(arg0_6)
	arg0_6:InitUI()
	arg0_6:AddListener()

	arg0_6.loader = AutoLoader.New()
	arg0_6.cgComp = GetOrAddComponent(arg0_6._go, typeof(CanvasGroup))
	arg0_6.cgComp.blocksRaycasts = not arg0_6.isFrozen

	arg0_6:Show()
end

function var0_0.OnDestroy(arg0_7)
	if arg0_7.stageTimer then
		arg0_7.stageTimer:Stop()

		arg0_7.stageTimer = nil
	end

	arg0_7:ClearSubViews()
	arg0_7:DestroyAutoFightPanel()
	arg0_7:DestroyWinConditionPanel()
	arg0_7:DestroyToast()
	arg0_7.loader:Clear()
	arg0_7:Hide()
end

local var1_0 = -300

function var0_0.InitUI(arg0_8)
	arg0_8.topStage = arg0_8._tf:Find("top_stage")

	setActive(arg0_8.topStage, true)

	arg0_8.bottomStage = arg0_8._tf:Find("bottom_stage")
	arg0_8.normalRole = findTF(arg0_8.bottomStage, "Normal")
	arg0_8.funcBtn = arg0_8.normalRole:Find("func_button")
	arg0_8.retreatBtn = arg0_8.normalRole:Find("retreat_button")
	arg0_8.switchBtn = arg0_8.normalRole:Find("switch_button")
	arg0_8.helpBtn = arg0_8.normalRole:Find("help_button")
	arg0_8.shengfuBtn = arg0_8.normalRole:Find("shengfu/shengfu_button")
	arg0_8.actionRole = findTF(arg0_8.bottomStage, "Action")
	arg0_8.missileStrikeRole = findTF(arg0_8.actionRole, "MissileStrike")
	arg0_8.airExpelRole = findTF(arg0_8.actionRole, "AirExpel")

	setActive(arg0_8.bottomStage, true)
	setAnchoredPosition(arg0_8.normalRole, {
		x = 0,
		y = 0
	})
	setActive(arg0_8.normalRole, true)
	setAnchoredPosition(arg0_8.actionRole, {
		x = 0,
		y = var1_0
	})
	setActive(arg0_8.actionRole, false)
	eachChild(arg0_8.actionRole, function(arg0_9)
		setActive(arg0_9, false)
	end)

	arg0_8.leftStage = arg0_8._tf:Find("left_stage")

	setActive(arg0_8.leftStage, true)

	arg0_8.rightStage = arg0_8._tf:Find("right_stage")
	arg0_8.bombPanel = arg0_8.rightStage:Find("bomb_panel")
	arg0_8.panelBarrier = arg0_8.rightStage:Find("panel_barrier")
	arg0_8.strategyPanelAnimator = arg0_8.rightStage:Find("event"):GetComponent(typeof(Animator))
	arg0_8.autoBattleBtn = arg0_8.rightStage:Find("event/collapse/lock_fleet")
	arg0_8.showDetailBtn = arg0_8.rightStage:Find("event/detail/show_detail")

	setActive(arg0_8.panelBarrier, false)
	setActive(arg0_8.rightStage, true)

	arg0_8.airSupremacy = arg0_8.topStage:Find("msg_panel/air_supremacy")

	setAnchoredPosition(arg0_8.topStage, {
		y = arg0_8.topStage.rect.height
	})
	setAnchoredPosition(arg0_8.leftStage, {
		x = -arg0_8.leftStage.rect.width - 200
	})
	setAnchoredPosition(arg0_8.rightStage, {
		x = arg0_8.rightStage.rect.width + 300
	})
	setAnchoredPosition(arg0_8.bottomStage, {
		y = -arg0_8.bottomStage.rect.height
	})

	arg0_8.attachSubViews = {}
end

function var0_0.AddListener(arg0_10)
	arg0_10:bind(LevelUIConst.TRIGGER_ACTION, function()
		arg0_10:tryAutoTrigger()
	end)
	arg0_10:bind(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, function(arg0_12, arg1_12)
		arg0_10.strategyPanelAnimator:SetBool("IsActive", arg1_12)

		arg0_10.bottomStageInactive = arg1_12

		arg0_10:ShiftBottomStage(not arg1_12)
	end)
	arg0_10:bind(LevelUIConst.ON_CLICK_GRID_QUAD, function(arg0_13, arg1_13)
		arg0_10:ClickGridCellNormal(arg1_13)
	end)
	onButton(arg0_10, arg0_10.topStage:Find("option"), function()
		arg0_10:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.topStage:Find("back_button"), function()
		arg0_10:emit(LevelUIConst.SWITCH_TO_MAP)
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.retreatBtn, function()
		local var0_16 = arg0_10.contextData.chapterVO
		local var1_16 = arg0_10.contextData.map
		local var2_16 = "levelScene_whether_to_retreat"

		if var0_16:existOni() then
			var2_16 = "levelScene_oni_retreat"
		elseif var0_16:isPlayingWithBombEnemy() then
			var2_16 = "levelScene_bomb_retreat"
		elseif var0_16:getPlayType() == ChapterConst.TypeTransport and not var1_16:isSkirmish() then
			var2_16 = "levelScene_escort_retreat"
		elseif var1_16:isRemaster() then
			var2_16 = "archives_whether_to_retreat"
		end

		arg0_10:HandleShowMsgBox({
			content = i18n(var2_16),
			onYes = ChapterOpCommand.PrepareChapterRetreat
		})
	end, SFX_UI_WEIGHANCHOR_WITHDRAW)
	onButton(arg0_10, arg0_10.switchBtn, function()
		local var0_17 = arg0_10.contextData.chapterVO
		local var1_17 = var0_17:getNextValidIndex()

		if var1_17 > 0 then
			arg0_10:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpSwitch,
				id = var0_17.fleets[var1_17].id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_failed"))
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.autoBattleBtn, function()
		local var0_18 = getProxy(ChapterProxy)
		local var1_18 = var0_18:GetSkipPrecombat()

		var0_18:UpdateSkipPrecombat(not var1_18)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.showDetailBtn, function()
		arg0_10._showStrategyDetail = not arg0_10._showStrategyDetail and true

		arg0_10:updateStageStrategy()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.funcBtn, function()
		local var0_20 = arg0_10.contextData.chapterVO

		if not var0_20:inWartime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_time_out"))

			return
		end

		local var1_20 = var0_20.fleet
		local var2_20 = var1_20.line
		local var3_20 = var0_20:getChapterCell(var2_20.row, var2_20.column)
		local var4_20 = false

		local function var5_20(arg0_21)
			local var0_21 = arg0_21.attachmentId

			return pg.expedition_data_template[var0_21].dungeon_id > 0
		end

		if var0_20:existVisibleChampion(var2_20.row, var2_20.column) then
			var4_20 = true

			local var6_20 = var0_20:getChampion(var2_20.row, var2_20.column)

			if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
				arg0_10:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSkipBattle,
					id = var1_20.id
				})
			elseif not var5_20(var6_20) then
				arg0_10:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpPreClear,
					id = var1_20.id
				})
			elseif var0_20:IsSkipPrecombat() then
				arg0_10:emit(LevelMediator2.ON_START)
			else
				arg0_10:emit(LevelMediator2.ON_STAGE)
			end
		elseif var3_20.attachment == ChapterConst.AttachAmbush and var3_20.flag == ChapterConst.CellFlagAmbush then
			local var7_20

			var7_20 = coroutine.wrap(function()
				arg0_10:emit(LevelUIConst.DO_AMBUSH_WARNING, var7_20)
				coroutine.yield()
				arg0_10:emit(LevelUIConst.DISPLAY_AMBUSH_INFO, var7_20)
				coroutine.yield()
			end)

			var7_20()

			var4_20 = true
		elseif ChapterConst.IsEnemyAttach(var3_20.attachment) then
			if var3_20.flag == ChapterConst.CellFlagActive then
				var4_20 = true

				if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
					arg0_10:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSkipBattle,
						id = var1_20.id
					})
				elseif not var5_20(var3_20) then
					arg0_10:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpPreClear,
						id = var1_20.id
					})
				elseif var0_20:IsSkipPrecombat() then
					arg0_10:emit(LevelMediator2.ON_START)
				else
					arg0_10:emit(LevelMediator2.ON_STAGE)
				end
			end
		elseif var3_20.attachment == ChapterConst.AttachBox then
			if var3_20.flag == ChapterConst.CellFlagActive then
				var4_20 = true

				arg0_10:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBox,
					id = var1_20.id
				})
			end
		elseif var3_20.attachment == ChapterConst.AttachSupply and var3_20.attachmentId > 0 then
			var4_20 = true

			local var8_20, var9_20 = var0_20:getFleetAmmo(var0_20.fleet)

			if var9_20 < var8_20 then
				arg0_10:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSupply,
					id = var1_20.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_enough"))
			end
		elseif var3_20.attachment == ChapterConst.AttachStory then
			var4_20 = true

			local var10_20 = pg.map_event_template[var3_20.attachmentId].memory
			local var11_20 = pg.map_event_template[var3_20.attachmentId].gametip

			if var10_20 == 0 then
				return
			end

			local var12_20 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var10_20)

			pg.ConnectionMgr.GetInstance():Send(11017, {
				story_id = var10_20
			}, 11018, function(arg0_23)
				return
			end)
			pg.NewStoryMgr.GetInstance():Play(var12_20, function(arg0_24, arg1_24)
				local var0_24 = arg1_24 or 1

				if var3_20.flag == ChapterConst.CellFlagActive then
					arg0_10:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpStory,
						id = var1_20.id,
						arg1 = var0_24
					})
				end

				if var11_20 ~= "" then
					local var1_24

					for iter0_24, iter1_24 in ipairs(pg.memory_template.all) do
						local var2_24 = pg.memory_template[iter1_24]

						if table.contains(var2_24.unlock_pre, var12_20) then
							var1_24 = var2_24.title
						end
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n(var11_20, var1_24))
				end
			end)
		end

		if not var4_20 then
			if var0_20:getRound() == ChapterConst.RoundEnemy then
				arg0_10:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpEnemyRound
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_click_to_move"))
			end
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		local var0_25 = arg0_10.contextData.chapterVO

		if var0_25 then
			if var0_25:existOni() then
				arg0_10:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_sphunt_help_tip")
				})
			elseif var0_25:isTypeDefence() then
				arg0_10:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("help_battle_defense")
				})
			elseif var0_25:isPlayingWithBombEnemy() then
				arg0_10:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_bomb_help_tip")
				})
			elseif pg.map_event_list[var0_25.id] and next(noEmptyStr(pg.map_event_list[var0_25.id].help_pictures) or {}) then
				local var1_25 = {
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

				for iter0_25, iter1_25 in pairs(pg.map_event_list[var0_25.id].help_pictures) do
					table.insert(var1_25, {
						icon = {
							path = "",
							atlas = iter1_25
						}
					})
				end

				arg0_10:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var1_25
				})
			else
				arg0_10:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = pg.gametip.help_level_ui.tip
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.airSupremacy, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_10, arg0_10.shengfuBtn, function()
		arg0_10:DisplayWinConditionPanel()
	end)
end

function var0_0.SetSeriesOperation(arg0_28, arg1_28)
	arg0_28.seriesOperation = arg1_28
end

function var0_0.SetGrid(arg0_29, arg1_29)
	arg0_29.grid = arg1_29
end

function var0_0.SetPlayer(arg0_30, arg1_30)
	return
end

function var0_0.SwitchToChapter(arg0_31, arg1_31)
	local var0_31 = findTF(arg0_31.topStage, "msg_panel/ambush")
	local var1_31 = findTF(arg0_31.rightStage, "target")
	local var2_31 = findTF(arg0_31.rightStage, "skip_events")

	setActive(var0_31, arg1_31:existAmbush())
	setActive(arg0_31.airSupremacy, OPEN_AIR_DOMINANCE and arg1_31:getConfig("air_dominance") > 0)

	local var3_31 = arg1_31:isLoop()

	setActive(arg0_31.autoBattleBtn, var3_31)

	if var3_31 then
		arg0_31:UpdateSkipPreCombatMark()
		arg0_31:UpdateAutoFightPanel()
		arg0_31:UpdateAutoFightMark()
	end

	arg0_31.achieveOriginalY = -240

	setText(var2_31:Find("Label"), i18n("map_event_skip"))

	local var4_31 = "skip_events_on_" .. arg1_31.id

	if arg1_31:getConfig("event_skip") == 1 then
		if arg1_31.progress > 0 or arg1_31.defeatCount > 0 or arg1_31.passCount > 0 then
			setActive(var2_31, true)

			var1_31.anchoredPosition = Vector2.New(var1_31.anchoredPosition.x, arg0_31.achieveOriginalY - 40)
			GetComponent(var2_31, typeof(Toggle)).isOn = PlayerPrefs.GetInt(var4_31, 1) == 1

			onToggle(arg0_31, var2_31, function(arg0_32)
				PlayerPrefs.SetInt(var4_31, arg0_32 and 1 or 0)
			end)
		else
			setActive(var2_31, false)

			if not PlayerPrefs.HasKey(var4_31) then
				PlayerPrefs.SetInt(var4_31, 0)
			end
		end
	else
		setActive(var2_31, false)

		var1_31.anchoredPosition = Vector2.New(var1_31.anchoredPosition.x, arg0_31.achieveOriginalY)
	end

	setActive(var1_31, arg1_31:existAchieve())
	setActive(arg0_31.retreatBtn, true)
	arg0_31.seriesOperation()
end

function var0_0.SwitchToMap(arg0_33)
	arg0_33:DestroyAutoFightPanel()
end

function var0_0.UpdateSkipPreCombatMark(arg0_34)
	local var0_34 = getProxy(ChapterProxy):GetSkipPrecombat() and "auto_battle_on" or "auto_battle_off"

	arg0_34.loader:GetOffSpriteRequest(arg0_34.autoBattleBtn)
	arg0_34.loader:GetSprite("ui/levelstageview_atlas", var0_34, arg0_34.autoBattleBtn, true)
end

function var0_0.updateStageInfo(arg0_35)
	local var0_35 = arg0_35.contextData.chapterVO
	local var1_35 = findTF(arg0_35.topStage, "timer")
	local var2_35 = findTF(arg0_35.topStage, "unlimit")

	setWidgetText(var1_35, "--:--:--")

	if arg0_35.stageTimer then
		arg0_35.stageTimer:Stop()
	end

	if var0_35:getRemainTime() > var0_35:getConfig("time") or var0_35:getConfig("time") >= 8640000 then
		setActive(var1_35, false)
		setActive(var2_35, true)
	else
		setActive(var1_35, true)
		setActive(var2_35, false)

		arg0_35.stageTimer = Timer.New(function()
			if IsNil(var1_35) then
				return
			end

			local var0_36 = var0_35:getRemainTime()

			setWidgetText(var1_35, pg.TimeMgr.GetInstance():DescCDTime(var0_36))
		end, 1, -1)

		arg0_35.stageTimer:Start()
		arg0_35.stageTimer.func()
	end
end

function var0_0.updateAmbushRate(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.contextData.chapterVO

	if not var0_37:existAmbush() then
		return
	end

	local var1_37 = var0_37.fleet
	local var2_37 = var1_37:getInvestSums()
	local var3_37 = findTF(arg0_37.topStage, "msg_panel/ambush/label1")
	local var4_37 = findTF(arg0_37.topStage, "msg_panel/ambush/label2")
	local var5_37 = findTF(arg0_37.topStage, "msg_panel/ambush/value1")
	local var6_37 = findTF(arg0_37.topStage, "msg_panel/ambush/value2")

	setText(var3_37, i18n("level_scene_title_word_1"))
	setText(var5_37, math.floor(var2_37))
	setText(var4_37, i18n("level_scene_title_word_2"))

	if not var0_37.activateAmbush then
		setText(var6_37, i18n("ambush_display_none"))
		setTextColor(var6_37, Color.New(0.4, 0.4, 0.4))
	else
		local var7_37 = var0_37:getAmbushRate(var1_37, arg1_37)
		local var8_37, var9_37 = ChapterConst.GetAmbushDisplay((not arg2_37 or not var0_37:existEnemy(ChapterConst.SubjectPlayer, arg1_37.row, arg1_37.column)) and var7_37)

		setText(var6_37, var8_37)
		setTextColor(var6_37, var9_37)
	end
end

function var0_0.updateStageAchieve(arg0_38)
	local var0_38 = arg0_38.contextData.chapterVO

	if not var0_38:existAchieve() then
		return
	end

	local var1_38 = var0_38.achieves
	local var2_38 = findTF(arg0_38.rightStage, "target")

	setActive(var2_38, true)

	local var3_38 = findTF(var2_38, "detail")
	local var4_38 = findTF(var3_38, "achieve")
	local var5_38 = findTF(var3_38, "achieves")
	local var6_38 = findTF(var3_38, "click")
	local var7_38 = findTF(var2_38, "collapse")
	local var8_38 = findTF(var7_38, "star")
	local var9_38 = findTF(var7_38, "stars")

	setActive(var4_38, false)
	setActive(var8_38, false)
	removeAllChildren(var5_38)
	removeAllChildren(var9_38)

	for iter0_38, iter1_38 in ipairs(var1_38) do
		local var10_38 = cloneTplTo(var4_38, var5_38)
		local var11_38 = ChapterConst.IsAchieved(iter1_38)

		setActive(findTF(var10_38, "star"), var11_38)

		local var12_38 = findTF(var10_38, "desc")

		setText(var12_38, ChapterConst.GetAchieveDesc(iter1_38.type, var0_38))
		setTextColor(var12_38, var11_38 and Color.yellow or Color.white)

		cloneTplTo(var8_38, var9_38):GetComponent(typeof(Image)).enabled = var11_38
	end

	onButton(arg0_38, var6_38, function()
		shiftPanel(var3_38, var3_38.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_38, 0, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_38, var7_38, function()
		shiftPanel(var3_38, 30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_38, var7_38.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)

	if not arg0_38.isAchieveFirstInit then
		arg0_38.isAchieveFirstInit = true

		triggerButton(var6_38)
	end
end

function var0_0.updateStageBarrier(arg0_41)
	local var0_41 = arg0_41.contextData.chapterVO

	setActive(arg0_41.panelBarrier, var0_41:existOni())

	if not var0_41:existOni() then
		return
	end

	local var1_41 = arg0_41.panelBarrier:Find("btn_barrier")

	setText(var1_41:Find("nums"), var0_41.modelCount)
	onButton(arg0_41, var1_41, function()
		if arg0_41.grid.quadState == ChapterConst.QuadStateBarrierSetting then
			arg0_41.grid:updateQuadCells(ChapterConst.QuadStateNormal)

			return
		end

		arg0_41.grid:updateQuadCells(ChapterConst.QuadStateBarrierSetting)
	end, SFX_PANEL)
end

function var0_0.updateBombPanel(arg0_43, arg1_43)
	local var0_43 = arg0_43.contextData.chapterVO

	setActive(arg0_43.bombPanel, var0_43:isPlayingWithBombEnemy())

	if var0_43:isPlayingWithBombEnemy() then
		setText(arg0_43.bombPanel:Find("tx_step"), var0_43:getBombChapterInfo().action_times - math.floor(var0_43.roundIndex / 2))

		local var1_43 = arg0_43.bombPanel:Find("tx_score")
		local var2_43 = tonumber(getText(var1_43))
		local var3_43 = var0_43.modelCount

		LeanTween.cancel(go(var1_43))

		if arg1_43 and var2_43 ~= var3_43 then
			LeanTween.scale(go(var1_43), Vector3(1.5, 1.5, 1), 0.2)

			local var4_43 = (var3_43 - var2_43) * 0.1

			LeanTween.value(go(var1_43), var2_43, var3_43, var4_43):setOnUpdate(System.Action_float(function(arg0_44)
				setText(var1_43, math.floor(arg0_44))
			end)):setOnComplete(System.Action(function()
				setText(var1_43, var3_43)
			end)):setEase(LeanTweenType.easeInOutSine):setDelay(0.2)
			LeanTween.scale(go(var1_43), Vector3.one, 0.3):setDelay(1 + var4_43)
		else
			var1_43.localScale = Vector3.one

			setText(var1_43, var3_43)
		end
	end
end

function var0_0.updateFleetBuff(arg0_46)
	local var0_46 = arg0_46.contextData.chapterVO
	local var1_46 = var0_46.fleet
	local var2_46 = var0_46:GetShowingStrategies()

	if var0_46:getChapterSupportFleet() and not var0_46:IsSupportSubmarineStage() then
		table.insert(var2_46, ChapterConst.StrategyAirSupportFriendly)
	end

	local var3_46 = {}
	local var4_46 = var0_46:GetSubmarineFleet()

	if var4_46 then
		local var5_46 = _.filter(var4_46:getStrategies(), function(arg0_47)
			return pg.strategy_data_template[arg0_47.id].type == ChapterConst.StgTypePassive and arg0_47.count > 0
		end)

		if var5_46 and #var5_46 > 0 then
			_.each(var5_46, function(arg0_48)
				table.insert(var3_46, {
					id = arg0_48.id,
					count = arg0_48.count
				})
			end)
		end
	end

	local var6_46 = underscore.filter(var0_46:GetWeather(), function(arg0_49)
		local var0_49 = pg.weather_data_template[arg0_49]

		return noEmptyStr(var0_49.buff_icon)
	end)
	local var7_46 = 0

	if var0_46:ExistDivingChampion() then
		var7_46 = 1
	end

	local var8_46 = _.map(_.values(var1_46:getCommanders()), function(arg0_50)
		return arg0_50:getSkills()[1]
	end)
	local var9_46 = findTF(arg0_46.topStage, "icon_list/fleet_buffs")
	local var10_46 = UIItemList.New(var9_46, var9_46:GetChild(0))

	var10_46:make(function(arg0_51, arg1_51, arg2_51)
		setActive(findTF(arg2_51, "frame"), false)
		setActive(findTF(arg2_51, "Text"), false)
		setActive(findTF(arg2_51, "times"), false)

		if arg0_51 == UIItemList.EventUpdate then
			local var0_51 = GetComponent(arg2_51, typeof(LayoutElement))

			var0_51.preferredWidth = 64
			var0_51.preferredHeight = 64

			if arg1_51 + 1 <= #var2_46 then
				local var1_51 = var2_46[arg1_51 + 1]
				local var2_51 = pg.strategy_data_template[var1_51]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_51.icon, "", arg2_51)

				local var3_51

				if var2_51.type == ChapterConst.StgTypeBindFleetPassive then
					var3_51 = var1_46:GetStrategyCount(var1_51)

					setActive(findTF(arg2_51, "times"), true)
					setText(findTF(arg2_51, "times"), var3_51)
				end

				local var4_51 = var2_51.iconSize

				if var4_51 ~= "" then
					var0_51.preferredWidth = var4_51[1]
					var0_51.preferredHeight = var4_51[2]
				end

				onButton(arg0_46, arg2_51, function()
					arg0_46:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var2_51.id,
							cfg = var2_51,
							count = var3_51
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1_51 = arg1_51 - #var2_46

			if arg1_51 + 1 <= #var6_46 then
				local var5_51 = pg.weather_data_template[var6_46[arg1_51 + 1]]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var5_51.buff_icon, "", arg2_51)
				onButton(arg0_46, arg2_51, function()
					arg0_46:HandleShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var5_51.name,
						content = var5_51.buff_desc,
						iconPath = {
							"strategyicon/" .. var5_51.buff_icon
						},
						yesText = pg.MsgboxMgr.TEXT_CONFIRM
					})
				end, SFX_PANEL)

				return
			end

			arg1_51 = arg1_51 - #var6_46

			if arg1_51 + 1 <= #var3_46 then
				local var6_51 = var3_46[arg1_51 + 1]
				local var7_51 = pg.strategy_data_template[var6_51.id]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var7_51.icon, "", arg2_51)
				setActive(findTF(arg2_51, "times"), true)
				setText(findTF(arg2_51, "times"), var6_51.count)
				onButton(arg0_46, arg2_51, function()
					arg0_46:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var7_51.id,
							cfg = var7_51
						},
						extendDesc = string.format(i18n("word_rest_times"), var6_51.count)
					})
				end, SFX_PANEL)

				return
			end

			arg1_51 = arg1_51 - #var3_46

			if arg1_51 + 1 <= var7_46 then
				GetImageSpriteFromAtlasAsync("strategyicon/submarine_approach", "", arg2_51)
				onButton(arg0_46, arg2_51, function()
					arg0_46:HandleShowMsgBox({
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

			arg1_51 = arg1_51 - var7_46

			local var8_51 = var8_46[arg1_51 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var8_51:getConfig("icon"), "", arg2_51)
			setText(findTF(arg2_51, "Text"), "Lv." .. var8_51:getConfig("lv"))
			setActive(findTF(arg2_51, "Text"), true)
			setActive(findTF(arg2_51, "frame"), true)
			onButton(arg0_46, arg2_51, function()
				arg0_46:emit(LevelMediator2.ON_COMMANDER_SKILL, var8_51)
			end, SFX_PANEL)
		end
	end)
	var10_46:align(#var2_46 + #var3_46 + #var6_46 + var7_46 + #var8_46)

	if OPEN_AIR_DOMINANCE and var0_46:getConfig("air_dominance") > 0 then
		arg0_46:updateAirDominance()
	end

	arg0_46:updateEnemyCount()
	arg0_46:updateChapterBuff()
end

function var0_0.updateEnemyCount(arg0_57)
	local var0_57 = arg0_57.contextData.chapterVO
	local var1_57 = findTF(arg0_57.topStage, "icon_list/enemy_count")
	local var2_57 = tobool(underscore.detect(var0_57.achieves, function(arg0_58)
		return (arg0_58.type == ChapterConst.AchieveType3 or arg0_58.type == ChapterConst.AchieveType6) and not ChapterConst.IsAchieved(arg0_58)
	end))

	setActive(var1_57, var2_57)

	if var2_57 then
		local var3_57 = var0_57:getDisplayEnemyCount()

		setText(var1_57:Find("Text"), var3_57)
		GetImageSpriteFromAtlasAsync("enemycount", var3_57 > 0 and "danger" or "safe", var1_57)
		onButton(arg0_57, var1_57, function()
			if var3_57 > 0 then
				arg0_57:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_57),
					iconPath = {
						"enemycount",
						"danger"
					},
					yesText = i18n("star_require_enemy_check"),
					onYes = function()
						local var0_60 = var0_57:getNearestEnemyCell()

						arg0_57.grid:focusOnCell(var0_60)

						local var1_60 = arg0_57.grid:GetEnemyCellView(var0_60)

						if var1_60 and var1_60.TweenShining then
							var1_60:TweenShining(2)
						end
					end
				})
			else
				arg0_57:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_57),
					iconPath = {
						"enemycount",
						"safe"
					}
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateChapterBuff(arg0_61)
	local var0_61 = arg0_61.contextData.chapterVO
	local var1_61 = findTF(arg0_61.topStage, "icon_list/chapter_buff")
	local var2_61 = var0_61:hasMitigation()

	SetActive(var1_61, var2_61)

	if var2_61 then
		local var3_61 = var0_61:getRiskLevel()

		GetImageSpriteFromAtlasAsync("passstate", var3_61 .. "_icon", var1_61)
		onButton(arg0_61, var1_61, function()
			if not var0_61:hasMitigation() then
				return
			end

			arg0_61:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = var0_61:getChapterState(),
				iconPath = {
					"passstate",
					var3_61 .. "_icon"
				},
				content = i18n("level_risk_level_mitigation_rate", var0_61:getRemainPassCount(), var0_61:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateAirDominance(arg0_63)
	local var0_63, var1_63, var2_63 = arg0_63.contextData.chapterVO:getAirDominanceValue()

	if not var2_63 or var2_63 ~= var1_63 then
		arg0_63.contextData.chapterVO:setAirDominanceStatus(var1_63)
		getProxy(ChapterProxy):updateChapter(arg0_63.contextData.chapterVO)
	end

	arg0_63.isChange = var2_63 and (var1_63 == 0 and 3 or var1_63) - (var2_63 == 0 and 3 or var2_63)

	arg0_63:updateAirDominanceTitle(var0_63, var1_63, arg0_63.isChange or 0)
end

function var0_0.updateAirDominanceTitle(arg0_64, arg1_64, arg2_64, arg3_64)
	local var0_64 = findTF(arg0_64.airSupremacy, "label1")
	local var1_64 = findTF(arg0_64.airSupremacy, "label2")
	local var2_64 = findTF(arg0_64.airSupremacy, "value1")
	local var3_64 = findTF(arg0_64.airSupremacy, "value2")
	local var4_64 = findTF(arg0_64.airSupremacy, "up")
	local var5_64 = findTF(arg0_64.airSupremacy, "down")

	setText(var0_64, i18n("level_scene_title_word_3"))
	setText(var1_64, i18n("level_scene_title_word_4"))
	setText(var2_64, math.floor(arg1_64))
	setActive(var4_64, false)
	setActive(var5_64, false)

	if arg3_64 ~= 0 then
		if LeanTween.isTweening(go(var3_64)) then
			LeanTween.cancel(go(var3_64))
		end

		LeanTween.value(go(var3_64), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_65)
			setTextAlpha(var3_64, arg0_65)
		end)):setOnComplete(System.Action(function()
			setText(var3_64, ChapterConst.AirDominance[arg2_64].name)
			setTextColor(var3_64, ChapterConst.AirDominance[arg2_64].color)
			LeanTween.value(go(var3_64), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_67)
				setTextAlpha(var3_64, arg0_67)
			end))
		end))

		local function var6_64(arg0_68)
			setActive(arg0_68, false)
		end

		var4_64:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_64)
		var5_64:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_64)
		setActive(var4_64, arg3_64 > 0)
		setActive(var5_64, arg3_64 < 0)
	else
		setText(var3_64, ChapterConst.AirDominance[arg2_64].name)
		setTextColor(var3_64, ChapterConst.AirDominance[arg2_64].color)
	end
end

function var0_0.UpdateDefenseStatus(arg0_69)
	local var0_69 = arg0_69.contextData.chapterVO
	local var1_69 = var0_69:getPlayType() == ChapterConst.TypeDefence
	local var2_69 = findTF(arg0_69.bottomStage, "Normal/shengfu")

	setActive(var2_69, var1_69)

	if not var1_69 then
		return
	end

	local var3_69 = findTF(var2_69, "hp"):GetComponent(typeof(Text))
	local var4_69 = var0_69.id
	local var5_69 = pg.chapter_defense[var4_69]

	var3_69.text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(var0_69.BaseHP) .. "</color>", var5_69.port_hp)
end

function var0_0.DisplayWinConditionPanel(arg0_70)
	if not arg0_70.winCondPanel then
		arg0_70.winCondPanel = WinConditionDisplayPanel.New(arg0_70._tf.parent, arg0_70.event, arg0_70.contextData)

		arg0_70.winCondPanel:Load()
	end

	arg0_70.winCondPanel:ActionInvoke("Enter", arg0_70.contextData.chapterVO)
end

function var0_0.DestroyWinConditionPanel(arg0_71)
	if not arg0_71.winCondPanel then
		return
	end

	arg0_71.winCondPanel:Destroy()

	arg0_71.winCondPanel = nil
end

function var0_0.UpdateComboPanel(arg0_72)
	local var0_72 = arg0_72.contextData.chapterVO
	local var1_72 = pg.chapter_pop_template[var0_72.id]

	if var1_72 and var1_72.combo_on then
		local var2_72, var3_72 = arg0_72:GetSubView("LevelStageComboPanel")

		if var3_72 then
			var2_72:Load()
			var2_72.buffer:SetParent(arg0_72.leftStage, false)
		end

		local var4_72 = getProxy(ChapterProxy):GetComboHistory(var0_72.id)

		var2_72.buffer:UpdateView(var4_72 or var0_72)
		var2_72.buffer:UpdateViewAnimated(var0_72)
	end
end

function var0_0.UpdateDOALinkFeverPanel(arg0_73, arg1_73)
	local var0_73 = arg0_73.contextData.chapterVO
	local var1_73 = var0_73:GetBindActID()
	local var2_73 = var0_73:getConfig("levelstage_bar")

	if not var2_73 or var2_73 == "" then
		existCall(arg1_73)

		return
	end

	local var3_73, var4_73 = arg0_73:GetSubView(var2_73)

	if var4_73 then
		var3_73:Load()
		var3_73.buffer:SetParent(arg0_73._tf, false)
	end

	var3_73.buffer:UpdateView(var0_73, arg1_73)
end

local var2_0 = Vector2(396, 128)
local var3_0 = Vector2(128, 128)

function var0_0.updateStageStrategy(arg0_74)
	local var0_74 = arg0_74.contextData.chapterVO
	local var1_74 = findTF(arg0_74.rightStage, "event")
	local var2_74 = findTF(var1_74, "detail")
	local var3_74 = findTF(var2_74, "click")
	local var4_74 = findTF(var2_74, "items")

	var4_74:GetComponent(typeof(GridLayoutGroup)).cellSize = arg0_74._showStrategyDetail and var2_0 or var3_0

	local var5_74 = findTF(var4_74, "item")
	local var6_74 = findTF(var1_74, "collapse")

	setActive(var5_74, false)

	local var7_74 = var0_74:GetInteractableStrategies()
	local var8_74

	local function var9_74(arg0_75, arg1_75, arg2_75)
		if arg0_75 ~= UIItemList.EventUpdate then
			return
		end

		local var0_75 = arg2_75:Find("detail")

		setActive(var0_75, arg0_74._showStrategyDetail)

		local var1_75 = arg2_75:Find("icon")
		local var2_75 = var7_74[arg1_75 + 1]
		local var3_75
		local var4_75

		if var2_75.id == ChapterConst.StrategyHuntingRange then
			var3_75 = ChapterConst.StgTypeConst
			var4_75 = arg0_74.contextData.huntingRangeVisibility % 2 == 1 and "range_invisible" or "range_visible"

			setText(var0_75, i18n("help_sub_limits"))
		elseif var2_75.id == ChapterConst.StrategySubAutoAttack then
			var3_75 = ChapterConst.StgTypeConst
			var4_75 = var0_74.subAutoAttack == 0 and "sub_dont_auto_attack" or "sub_auto_attack"

			setText(var0_75, i18n("help_sub_display"))
		else
			local var5_75 = pg.strategy_data_template[var2_75.id]

			var3_75 = var5_75.type
			var4_75 = var5_75.icon

			setText(var0_75, var5_75.desc)
		end

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_75, "", var1_75:Find("icon"))
		onButton(arg0_74, var1_75, function()
			if var2_75.id == ChapterConst.StrategyHuntingRange then
				arg0_74.grid:toggleHuntingRange()
				var9_74(arg0_75, arg1_75, arg2_75)
			elseif var2_75.id == ChapterConst.StrategySubAutoAttack then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ai_change_" .. 1 - var0_74.subAutoAttack + 1))
				arg0_74:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubState,
					arg1 = 1 - var0_74.subAutoAttack
				})
			elseif var2_75.id == ChapterConst.StrategyExchange then
				local var0_76 = var0_74:getNextValidIndex()

				if var0_76 > 0 and var2_75.count > 0 then
					local var1_76 = var0_74.fleet

					arg0_74:HandleShowMsgBox({
						content = i18n("levelScene_who_to_exchange"),
						onYes = function()
							arg0_74:emit(LevelMediator2.ON_OP, {
								type = ChapterConst.OpStrategy,
								id = var1_76.id,
								arg1 = ChapterConst.StrategyExchange,
								arg2 = var0_74.fleets[var0_76].id
							})
						end
					})
				end
			elseif var2_75.id == ChapterConst.StrategySubTeleport then
				arg0_74:SwitchSubTeleportBottomStage()
				arg0_74:SwitchBottomStagePanel(true)
				arg0_74.grid:ShowStaticHuntingRange()
				arg0_74.grid:PrepareSubTeleport()
				arg0_74.grid:updateQuadCells(ChapterConst.QuadStateTeleportSub)
			elseif var2_75.id == ChapterConst.StrategyMissileStrike then
				if not var0_74.fleet:canUseStrategy(var2_75) then
					return
				end

				arg0_74:SwitchMissileBottomStagePanel()
				arg0_74:SwitchBottomStagePanel(true)
				arg0_74.grid:updateQuadCells(ChapterConst.QuadStateMissileStrike)
			elseif var2_75.id == ChapterConst.StrategyAirSupport then
				if not var0_74:getChapterSupportFleet():canUseStrategy(var2_75) then
					return
				end

				arg0_74:SwitchAirSupportBottomStagePanel()
				arg0_74:SwitchBottomStagePanel(true)
				arg0_74.grid:updateQuadCells(ChapterConst.QuadStateAirSuport)
			elseif var2_75.id == ChapterConst.StrategyExpel then
				if not var0_74:getChapterSupportFleet():canUseStrategy(var2_75) then
					return
				end

				arg0_74:SwitchAirExpelBottomStagePanel()
				arg0_74:SwitchBottomStagePanel(true)
				arg0_74.grid:updateQuadCells(ChapterConst.QuadStateExpel)
			elseif var3_75 == ChapterConst.StgTypeForm then
				local var2_76 = var0_74.fleet
				local var3_76 = table.indexof(ChapterConst.StrategyForms, var2_75.id)

				arg0_74:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpStrategy,
					id = var2_76.id,
					arg1 = ChapterConst.StrategyForms[var3_76 % #ChapterConst.StrategyForms + 1]
				})
			else
				arg0_74:emit(LevelUIConst.DISPLAY_STRATEGY_INFO, var2_75)
			end
		end, SFX_PANEL)

		if var3_75 == ChapterConst.StgTypeForm then
			setText(var1_75:Find("nums"), "")
			setActive(var1_75:Find("mask"), false)
			setActive(var1_75:Find("selected"), true)
		else
			setText(var1_75:Find("nums"), var2_75.count or "")
			setActive(var1_75:Find("mask"), var2_75.count == 0)
			setActive(var1_75:Find("selected"), false)
		end
	end

	UIItemList.StaticAlign(var4_74, var5_74, #var7_74, var9_74)
	onButton(arg0_74, var3_74, function()
		shiftPanel(var2_74, var2_74.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_74, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_74, var6_74, function()
		shiftPanel(var2_74, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_74, var6_74.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

function var0_0.GetSubView(arg0_80, arg1_80)
	if arg0_80.attachSubViews[arg1_80] then
		return arg0_80.attachSubViews[arg1_80]
	end

	local var0_80 = _G[arg1_80].New(arg0_80)

	assert(var0_80, "cant't find subview " .. (arg1_80 or "nil"))

	arg0_80.attachSubViews[arg1_80] = var0_80

	return var0_80, true
end

function var0_0.RemoveSubView(arg0_81, arg1_81)
	if not arg0_81.attachSubViews[arg1_81] then
		return false
	end

	arg0_81.attachSubViews[arg1_81]:Destroy()

	arg0_81.attachSubViews[arg1_81] = nil

	return true
end

function var0_0.ClearSubViews(arg0_82)
	for iter0_82, iter1_82 in pairs(arg0_82.attachSubViews) do
		iter1_82:Destroy()
	end

	table.clear(arg0_82.attachSubViews)
end

function var0_0.updateStageFleet(arg0_83)
	local var0_83 = arg0_83.contextData.chapterVO
	local var1_83 = findTF(arg0_83.leftStage, "fleet")
	local var2_83 = findTF(var1_83, "shiptpl")
	local var3_83 = arg0_83.topStage:Find("msg_panel/fleet_info/number")

	setActive(var2_83, false)
	setText(var3_83, var0_83.fleet.id)

	local var4_83 = var0_83.fleet:getShips(true)

	local function var5_83(arg0_84, arg1_84)
		local var0_84 = UIItemList.New(arg0_84, var2_83)

		var0_84:make(function(arg0_85, arg1_85, arg2_85)
			if arg0_85 == UIItemList.EventUpdate then
				local var0_85 = arg1_84[arg1_85 + 1]

				updateShip(arg2_85, var0_85)

				local var1_85 = var0_85.hpRant
				local var2_85 = var0_85:getShipProperties()
				local var3_85 = math.floor((var0_85.hpChange or 0) / 10000 * var2_85[AttributeType.Durability])
				local var4_85 = findTF(arg2_85, "HP_POP")

				setActive(var4_85, true)
				setActive(findTF(var4_85, "heal"), false)
				setActive(findTF(var4_85, "normal"), false)

				local function var5_85(arg0_86, arg1_86)
					setActive(arg0_86, true)
					setText(findTF(arg0_86, "text"), arg1_86)
					setTextAlpha(findTF(arg0_86, "text"), 0)
					LeanTween.moveY(arg0_86, 60, 1)
					LeanTween.textAlpha(findTF(arg0_86, "text"), 1, 0.3)
					LeanTween.textAlpha(findTF(arg0_86, "text"), 0, 0.5):setDelay(0.7):setOnComplete(System.Action(function()
						arg0_86.localPosition = Vector3(0, 0, 0)
					end))
				end

				if var3_85 > 0 then
					var5_85(findTF(var4_85, "heal"), var3_85)
				elseif var3_85 < 0 then
					LeanTween.delayedCall(0.6, System.Action(function()
						local var0_88 = arg2_85.transform.localPosition.x

						LeanTween.moveX(arg2_85, var0_88, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
						LeanTween.alpha(findTF(arg2_85, "red"), 0.5, 0.4)
						LeanTween.alpha(findTF(arg2_85, "red"), 0, 0.4):setDelay(0.4)
						var5_85(findTF(var4_85, "normal"), var3_85)
					end))
				end

				local var6_85 = findTF(arg2_85, "blood")
				local var7_85 = findTF(arg2_85, "blood/fillarea/green")
				local var8_85 = findTF(arg2_85, "blood/fillarea/red")
				local var9_85 = var1_85 < ChapterConst.HpGreen
				local var10_85 = var1_85 == 0

				setActive(var7_85, not var9_85)
				setActive(var8_85, var9_85)

				var6_85:GetComponent(typeof(Slider)).fillRect = var9_85 and var8_85 or var7_85

				setSlider(var6_85, 0, 10000, var1_85)
				setActive(findTF(arg2_85, "repairmask"), var9_85)
				setActive(findTF(arg2_85, "repairmask/broken"), var10_85)
				onButton(arg0_83, arg2_85:Find("repairmask"), function()
					arg0_83:emit(LevelUIConst.DISPLAY_REPAIR_WINDOW, var0_85)
				end, SFX_PANEL)

				local var11_85 = findTF(arg2_85, "repairmask/icon").gameObject

				if not var9_85 then
					LeanTween.cancel(var11_85)
					setImageAlpha(var11_85, 1)
				end

				if var9_85 and not LeanTween.isTweening(var11_85) then
					LeanTween.alpha(rtf(var11_85), 0, 2):setLoopPingPong()
				end

				local var12_85 = GetOrAddComponent(arg2_85, "UILongPressTrigger").onLongPressed

				pg.DelegateInfo.Add(arg0_83, var12_85)
				var12_85:RemoveAllListeners()
				var12_85:AddListener(function()
					arg0_83:emit(LevelMediator2.ON_STAGE_SHIPINFO, {
						shipId = var0_85.id,
						shipVOs = var4_83
					})
				end)
			end
		end)
		var0_84:align(#arg1_84)
	end

	var5_83(var1_83:Find("main"), var0_83.fleet:getShipsByTeam(TeamType.Main, true))
	var5_83(var1_83:Find("vanguard"), var0_83.fleet:getShipsByTeam(TeamType.Vanguard, true))
	var0_83.fleet:clearShipHpChange()
end

function var0_0.updateSupportFleet(arg0_91)
	local var0_91 = arg0_91.contextData.chapterVO:getChapterSupportFleet()
	local var1_91 = findTF(arg0_91.leftStage, "support_fleet")

	setActive(var1_91, tobool(var0_91))

	if var0_91 then
		local var2_91 = findTF(var1_91, "show/ship_container")

		removeAllChildren(var2_91)

		local var3_91 = findTF(var1_91, "show/shiptpl")
		local var4_91 = var0_91:getShips()

		for iter0_91, iter1_91 in pairs(var4_91) do
			local var5_91 = cloneTplTo(var3_91, var2_91)

			setActive(var5_91, true)
			updateShip(var5_91, iter1_91)
		end

		local var6_91 = var1_91:Find("hide")
		local var7_91 = var1_91:Find("show")

		local function var8_91(arg0_92)
			setActive(var6_91, true)
			setActive(var7_91, true)
			shiftPanel(var7_91, nil, arg0_92 and -325.1 or -855, 0.3, 0, true, nil, LeanTweenType.easeOutSine, function()
				setActive(var6_91, not arg0_92)
				setActive(var7_91, arg0_92)
			end)
			shiftPanel(var6_91, nil, arg0_92 and -1017 or -563.97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		end

		onButton(arg0_91, var6_91, function()
			var8_91(true)
		end, SFX_PANEL)
		onButton(arg0_91, var7_91, function()
			var8_91(false)
		end)
	end
end

function var0_0.ShiftStagePanelIn(arg0_96, arg1_96)
	shiftPanel(arg0_96.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_96)
	arg0_96:ShiftBottomStage(true)
	shiftPanel(arg0_96.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_96.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftStagePanelOut(arg0_97, arg1_97)
	shiftPanel(arg0_97.topStage, 0, arg0_97.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_97)
	arg0_97:ShiftBottomStage(false)
	shiftPanel(arg0_97.leftStage, -arg0_97.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_97.rightStage, arg0_97.rightStage.rect.width + 300, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftBottomStage(arg0_98, arg1_98)
	arg1_98 = not arg0_98.bottomStageInactive and arg1_98

	local var0_98 = arg1_98 and 0 or -arg0_98.bottomStage.rect.height

	shiftPanel(arg0_98.bottomStage, 0, var0_98, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.SwitchSubTeleportBottomStage(arg0_99)
	setActive(arg0_99.missileStrikeRole, true)
	setText(findTF(arg0_99.missileStrikeRole, "confirm_button/Text"), i18n("levelscene_deploy_submarine"))
	setText(findTF(arg0_99.missileStrikeRole, "cancel_button/Text"), i18n("levelscene_deploy_submarine_cancel"))
	onButton(arg0_99, arg0_99.missileStrikeRole:Find("confirm_button"), function()
		local var0_100 = arg0_99.contextData.chapterVO
		local var1_100 = var0_100:GetSubmarineFleet()
		local var2_100 = var1_100.startPos
		local var3_100 = arg0_99.grid.subTeleportTargetLine

		if not var3_100 then
			return
		end

		local var4_100 = var0_100:findPath(nil, var2_100, var3_100)
		local var5_100 = arg0_99.grid:TransformLine2PlanePos(var2_100)
		local var6_100 = arg0_99.grid:TransformLine2PlanePos(var3_100)
		local var7_100 = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #var1_100:getShips(false) * var4_100 - 1e-05)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", var5_100, var6_100, var4_100, var7_100),
			onYes = function()
				arg0_99:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = var1_100.id,
					arg1 = var3_100.row,
					arg2 = var3_100.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_99, arg0_99.missileStrikeRole:Find("cancel_button"), function()
		arg0_99:SwitchBottomStagePanel(false)
		arg0_99.grid:TurnOffSubTeleport()
		arg0_99.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchMissileBottomStagePanel(arg0_103)
	setActive(arg0_103.missileStrikeRole, true)
	setText(findTF(arg0_103.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_103.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_103, arg0_103.missileStrikeRole:Find("confirm_button"), function()
		local var0_104 = arg0_103.grid.missileStrikeTargetLine

		if not var0_104 then
			return
		end

		local var1_104 = arg0_103.contextData.chapterVO.fleet

		;(function()
			arg0_103:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_104.id,
				arg1 = ChapterConst.StrategyMissileStrike,
				arg2 = var0_104.row,
				arg3 = var0_104.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_103, arg0_103.missileStrikeRole:Find("cancel_button"), function()
		arg0_103:SwitchBottomStagePanel(false)
		arg0_103.grid:HideMissileAimingMark()
		arg0_103.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirSupportBottomStagePanel(arg0_107)
	setActive(arg0_107.missileStrikeRole, true)
	setText(findTF(arg0_107.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_107.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_107, arg0_107.missileStrikeRole:Find("confirm_button"), function()
		local var0_108 = arg0_107.grid.missileStrikeTargetLine

		if not var0_108 then
			return
		end

		local var1_108 = arg0_107.contextData.chapterVO:getChapterSupportFleet()

		;(function()
			arg0_107:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_108.id,
				arg1 = ChapterConst.StrategyAirSupport,
				arg2 = var0_108.row,
				arg3 = var0_108.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_107, arg0_107.missileStrikeRole:Find("cancel_button"), function()
		arg0_107:SwitchBottomStagePanel(false)
		arg0_107.grid:HideAirSupportAimingMark()
		arg0_107.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirExpelBottomStagePanel(arg0_111)
	setActive(arg0_111.airExpelRole, true)
	setText(findTF(arg0_111.airExpelRole, "cancel_button/Text"), i18n("levelscene_airexpel_cancel"))
	onButton(arg0_111, arg0_111.airExpelRole:Find("cancel_button"), function()
		arg0_111:SwitchBottomStagePanel(false)
		arg0_111.grid:HideAirExpelAimingMark()
		arg0_111.grid:CleanAirSupport()
		arg0_111.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchBottomStagePanel(arg0_113, arg1_113)
	setActive(arg0_113.actionRole, true)
	setActive(arg0_113.normalRole, true)
	shiftPanel(arg0_113.actionRole, 0, arg1_113 and 0 or var1_0, 0.3, 0, true, true, nil, function()
		setActive(arg0_113.actionRole, arg1_113)
	end)
	shiftPanel(arg0_113.normalRole, 0, arg1_113 and var1_0 or 0, 0.3, 0, true, true, nil, function()
		setActive(arg0_113.normalRole, not arg1_113)

		if not arg1_113 then
			eachChild(arg0_113.actionRole, function(arg0_116)
				setActive(arg0_116, false)
			end)
		end
	end)
	shiftPanel(arg0_113.leftStage, arg1_113 and -arg0_113.leftStage.rect.width - 200 or 0, 0, 0.3, 0, true)
	shiftPanel(arg0_113.rightStage, arg1_113 and arg0_113.rightStage.rect.width + 300 or 0, 0, 0.3, 0, true)
end

function var0_0.ClickGridCellNormal(arg0_117, arg1_117)
	local var0_117 = arg0_117.contextData.chapterVO
	local var1_117 = var0_117.fleet
	local var2_117 = _.detect(var0_117.fleets, function(arg0_118)
		return arg0_118:getFleetType() == FleetType.Normal and arg0_118.line.row == arg1_117.row and arg0_118.line.column == arg1_117.column
	end)

	if var2_117 and var2_117:isValid() and var2_117.id ~= var1_117.id then
		arg0_117:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var2_117.id
		})

		return
	end

	if arg0_117:tryAutoTrigger(nil, true) then
		return
	end

	if arg1_117.row == var1_117.line.row and arg1_117.column == var1_117.line.column then
		return
	end

	local var3_117 = var0_117:getChapterCell(arg1_117.row, arg1_117.column)

	if var3_117.attachment == ChapterConst.AttachStory and var3_117.data == ChapterConst.StoryObstacle and var3_117.flag == ChapterConst.CellFlagTriggerActive then
		local var4_117 = pg.map_event_template[var3_117.attachmentId]

		if var4_117 and var4_117.gametip and #var4_117.gametip > 0 and var0_117:getPlayType() ~= ChapterConst.TypeDefence then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var4_117.gametip))
		end

		return
	elseif not var0_117:considerAsStayPoint(ChapterConst.SubjectPlayer, arg1_117.row, arg1_117.column) then
		return
	elseif var0_117:existMoveLimit() then
		local var5_117 = var0_117:calcWalkableCells(ChapterConst.SubjectPlayer, var1_117.line.row, var1_117.line.column, var1_117:getSpeed())

		if not _.any(var5_117, function(arg0_119)
			return arg0_119.row == arg1_117.row and arg0_119.column == arg1_117.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))

			return
		end
	end

	local var6_117 = var0_117:findPath(ChapterConst.SubjectPlayer, var1_117.line, {
		row = arg1_117.row,
		column = arg1_117.column
	})

	if var6_117 < PathFinding.PrioObstacle then
		arg0_117:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var1_117.id,
			arg1 = arg1_117.row,
			arg2 = arg1_117.column
		})
	elseif var6_117 < PathFinding.PrioForbidden then
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	end
end

function var0_0.tryAutoAction(arg0_120, arg1_120)
	if arg0_120.doingAutoAction then
		return
	end

	arg0_120.doingAutoAction = true

	local var0_120 = arg0_120.contextData.chapterVO

	if not var0_120 then
		existCall(arg1_120)

		return
	end

	if arg0_120:SafeCheck() then
		existCall(arg1_120)

		return
	end

	local var1_120 = {}
	local var2_120 = false

	for iter0_120, iter1_120 in pairs(var0_120.cells) do
		if iter1_120.trait == ChapterConst.TraitLurk then
			var2_120 = true

			break
		end
	end

	if not var2_120 then
		for iter2_120, iter3_120 in ipairs(var0_120.champions) do
			if iter3_120.trait == ChapterConst.TraitLurk then
				var2_120 = true

				break
			end
		end
	end

	if var2_120 then
		local var3_120 = var0_120:existOni()
		local var4_120 = var0_120:isPlayingWithBombEnemy()

		if not var3_120 and not var4_120 then
			table.insert(var1_120, function(arg0_121)
				arg0_120:emit(LevelUIConst.DO_TRACKING, arg0_121)
			end)
		else
			table.insertto(var1_120, {
				function(arg0_122)
					local var0_122

					if var3_120 then
						var0_122 = "SpUnit"
					elseif var4_120 then
						var0_122 = "SpBomb"
					end

					assert(var0_122)
					arg0_120:emit(LevelUIConst.DO_PLAY_ANIM, {
						name = var0_122,
						callback = function(arg0_123)
							setActive(arg0_123, false)
							arg0_122()
						end
					})
				end,
				function(arg0_124)
					local var0_124 = var0_120:getSpAppearStory()

					if var0_124 and #var0_124 > 0 then
						pg.NewStoryMgr.GetInstance():Play(var0_124, arg0_124)

						return
					end

					arg0_124()
				end,
				function(arg0_125)
					local var0_125 = var0_120:getSpAppearGuide()

					if var0_125 and #var0_125 > 0 then
						pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_125, nil, arg0_125)

						return
					end

					arg0_125()
				end
			})
		end

		table.insertto(var1_120, {
			function(arg0_126)
				parallelAsync({
					function(arg0_127)
						arg0_120:tryPlayChapterStory(arg0_127)
					end,
					function(arg0_128)
						local var0_128 = var0_120:GetBossCell()

						if var0_128 and var0_128.trait == ChapterConst.TraitLurk then
							arg0_120.grid:focusOnCell(var0_128, arg0_128)

							return
						end

						arg0_128()
					end
				}, arg0_126)
			end,
			function(arg0_129)
				arg0_120:updateTrait(ChapterConst.TraitVirgin)
				arg0_120.grid:updateAttachments()
				arg0_120.grid:updateChampions()
				arg0_120:updateTrait(ChapterConst.TraitNone)
				arg0_120:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
				Timer.New(arg0_129, 0.5, 1):Start()
			end
		})
	end

	seriesAsync({
		function(arg0_130)
			arg0_120:emit(LevelUIConst.FROZEN)

			local var0_130 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_120.id)

			if var0_130 and (var0_130.attachment ~= ChapterConst.AttachAmbush or ChapterConst.IsBossCell(var0_130)) then
				local var1_130 = ChapterConst.GetDestroyFX(var0_130)

				arg0_120.grid:PlayAttachmentEffect(var0_130.line.row, var0_130.line.column, var1_130, Vector2.zero)
			end

			arg0_120:PopBar()
			arg0_120:UpdateComboPanel()
			arg0_130()
		end,
		function(arg0_131)
			if not (function()
				local var0_132 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_120.id)

				if not var0_132 then
					return
				end

				local var1_132 = pg.expedition_data_template[var0_132.attachmentId]

				return var1_132 and var1_132.type == ChapterConst.ExpeditionTypeMulBoss
			end)() then
				return arg0_131()
			end

			arg0_120:emit(LevelUIConst.DO_PLAY_ANIM, {
				name = "BossRetreatBar",
				callback = function(arg0_133)
					setActive(arg0_133, false)
					arg0_131()
				end
			})
		end,
		function(arg0_134)
			arg0_120:UpdateDOALinkFeverPanel(arg0_134)
		end,
		function(arg0_135)
			seriesAsync(var1_120, arg0_135)
		end,
		function(arg0_136)
			local var0_136, var1_136 = var0_120:GetAttachmentStories()

			if var0_136 then
				table.SerialIpairsAsync(var0_136, function(arg0_137, arg1_137, arg2_137)
					if arg0_137 <= var1_136 and arg1_137 and type(arg1_137) == "number" and arg1_137 > 0 then
						local var0_137 = pg.NewStoryMgr:StoryId2StoryName(arg1_137)

						ChapterOpCommand.PlayChapterStory(var0_137, arg2_137, var0_120:IsAutoFight())

						return
					end

					arg2_137()
				end, arg0_136)

				return
			end

			arg0_136()
		end,
		function(arg0_138)
			local var0_138 = arg0_120.contextData.chapterVO.id
			local var1_138 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_138)

			if not var1_138 or #var1_138 < 1 then
				arg0_138()

				return
			end

			for iter0_138, iter1_138 in ipairs(var1_138) do
				local var2_138 = pg.chapter_status_effect[iter1_138]
				local var3_138 = var2_138 and var2_138.camera_focus or ""

				if type(var3_138) == "table" then
					arg0_120.grid:focusOnCell({
						row = var3_138[1],
						column = var3_138[2]
					}, arg0_138)

					return
				end
			end

			arg0_138()
		end,
		function(arg0_139)
			if arg0_120.exited then
				return
			end

			arg0_120:emit(LevelUIConst.UN_FROZEN)
			;(function()
				local var0_140 = getProxy(ChapterProxy)
				local var1_140 = var0_140:getActiveChapter(true)

				if not var1_140 then
					return
				end

				local var2_140 = var1_140.id

				var0_140:RecordComboHistory(var2_140, nil)
				var0_140:RecordLastDefeatedEnemy(var2_140, nil)
				var0_140:extraFlagUpdated(var2_140)
				var0_140:RemoveExtendChapterData(var2_140, "FleetMoveDistance")
			end)()
			arg0_139()
		end
	}, function()
		if arg0_120.exited then
			return
		end

		arg0_120.doingAutoAction = nil

		if var2_120 and arg0_120:TryEnterChapterStoryStage() then
			-- block empty
		else
			existCall(arg1_120)
		end
	end)
end

function var0_0.tryPlayChapterStory(arg0_142, arg1_142)
	local var0_142 = arg0_142.contextData.chapterVO
	local var1_142 = var0_142:getWaveCount()

	seriesAsync({
		function(arg0_143)
			pg.SystemGuideMgr.GetInstance():PlayChapter(var0_142, arg0_143)
		end,
		function(arg0_144)
			local var0_144 = var0_142:getConfig("story_refresh")
			local var1_144 = var0_144 and var0_144[var1_142]

			if var1_144 and type(var1_144) == "string" and var1_144 ~= "" and not var0_142:IsRemaster() then
				ChapterOpCommand.PlayChapterStory(var1_144, arg0_144, var0_142:IsAutoFight())

				return
			end

			arg0_144()
		end,
		function(arg0_145)
			local var0_145 = var0_142:getConfig("story_refresh_boss")

			if var0_145 and type(var0_145) == "string" and var0_145 ~= "" and not var0_142:IsRemaster() and var0_142:IsFinalBossRefreshed() then
				ChapterOpCommand.PlayChapterStory(var0_145, arg0_145, var0_142:IsAutoFight())

				return
			end

			arg0_145()
		end,
		function(arg0_146)
			if var1_142 == 1 and pg.map_event_list[var0_142.id] and pg.map_event_list[var0_142.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. var0_142.id, 0) == 0 then
				triggerButton(arg0_142.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. var0_142.id, 1)
			end

			arg0_146()
		end,
		function()
			existCall(arg1_142)
		end
	})
end

function var0_0.TryEnterChapterStoryStage(arg0_148, arg1_148)
	local var0_148 = arg0_148.contextData.chapterVO
	local var1_148 = var0_148:getWaveCount()
	local var2_148 = var0_148:getConfig("story_refresh")
	local var3_148 = var2_148 and var2_148[var1_148]

	if var3_148 and type(var3_148) == "number" and not var0_148:IsRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var3_148)) then
		arg0_148:emit(LevelMediator2.ON_PERFORM_COMBAT, var3_148)

		return true
	end

	local var4_148 = var0_148:getConfig("story_refresh_boss")

	if var4_148 and type(var4_148) == "number" and not var0_148:IsRemaster() and var0_148:IsFinalBossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var4_148)) then
		arg0_148:emit(LevelMediator2.ON_PERFORM_COMBAT, var4_148)

		return true
	end
end

function var0_0.TryEnterChapterSupportSubmarineStage(arg0_149, arg1_149)
	local var0_149 = arg0_149.contextData.chapterVO
	local var1_149 = var0_149:getChapterSupportFleet()
	local var2_149 = {}

	if var0_149:getChapterSupportFleet() then
		arg0_149:emit(LevelMediator2.ON_SUPPORT_SUBMARINE)
	else
		arg0_149:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OPSubStrike,
			arg1 = ys.Battle.BattleConst.BattleScore.C,
			callback = arg1_149
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

function var0_0.PopBar(arg0_150)
	local var0_150 = arg0_150.contextData.chapterVO.id
	local var1_150 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_150)

	if not var1_150 or #var1_150 < 1 then
		return
	end

	local var2_150 = var1_150[1]
	local var3_150 = var4_0[var2_150]

	if not var3_150 then
		return
	end

	local var4_150, var5_150 = arg0_150:GetSubView(var3_150)

	if var5_150 then
		var4_150:Load()
	end

	var4_150.buffer:PlayAnim()
end

function var0_0.updateTrait(arg0_151, arg1_151)
	local var0_151 = arg0_151.contextData.chapterVO

	for iter0_151, iter1_151 in pairs(var0_151.cells) do
		if iter1_151.trait ~= ChapterConst.TraitNone then
			iter1_151.trait = arg1_151
		end
	end

	for iter2_151, iter3_151 in ipairs(var0_151.champions) do
		if iter3_151.trait ~= ChapterConst.TraitNone then
			iter3_151.trait = arg1_151
		end
	end
end

function var0_0.CheckFleetChange(arg0_152)
	local var0_152 = arg0_152.contextData.chapterVO
	local var1_152 = var0_152:GetActiveFleet()
	local var2_152 = _.detect(var0_152.fleets, function(arg0_153)
		return not arg0_153:isValid()
	end)

	if var2_152 then
		arg0_152:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRetreat,
			id = var2_152.id
		})

		if var2_152:getFleetType() == TeamType.Normal then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
		end
	end

	if not var1_152:isValid() then
		local var3_152 = var0_152:getNextValidIndex()

		if var3_152 > 0 then
			local var4_152 = var0_152.fleets[var3_152]

			local function var5_152()
				arg0_152:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSwitch,
					id = var4_152.id
				})
			end

			arg0_152:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("formation_switch_tip", var4_152.name),
				onYes = var5_152,
				onNo = var5_152
			})
		end

		return true
	end

	return false
end

function var0_0.tryAutoTrigger(arg0_155, arg1_155, arg2_155)
	local var0_155 = arg0_155.contextData.chapterVO

	if arg0_155:DoBreakAction() then
		return
	end

	if arg0_155:CheckFleetChange() then
		return
	end

	return ((function()
		if var0_155:checkAnyInteractive() then
			if not arg1_155 or var0_155:IsAutoFight() then
				triggerButton(arg0_155.funcBtn)

				return true
			end
		elseif var0_155:getRound() == ChapterConst.RoundEnemy then
			arg0_155:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpEnemyRound
			})

			return true
		elseif var0_155:getRound() == ChapterConst.RoundPlayer then
			if not arg2_155 then
				arg0_155.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			end

			if var0_155:IsAutoFight() then
				arg0_155:TryAutoFight()

				return true
			end
		end
	end)())
end

function var0_0.DoBreakAction(arg0_157)
	local var0_157 = arg0_157.contextData.chapterVO
	local var1_157, var2_157 = arg0_157:SafeCheck()

	if var1_157 then
		local function var3_157(arg0_158)
			local var0_158

			seriesAsync({
				function(arg0_159)
					arg0_157:emit(LevelUIConst.ADD_MSG_QUEUE, arg0_159)
				end,
				function(arg0_160, arg1_160)
					var0_158 = arg1_160

					ChapterOpCommand.PrepareChapterRetreat(arg0_160)
				end,
				function(arg0_161)
					existCall(arg0_158)
					existCall(var0_158)
				end
			})
		end

		if var2_157 == ChapterConst.ReasonVictory then
			seriesAsync({
				function(arg0_162)
					var3_157(arg0_162)
				end,
				function(arg0_163)
					local var0_163 = var0_157:getConfig("win_condition_display") and #var0_163 > 0 and var0_163 .. "_tip"

					if var0_163 and pg.gametip[var0_163] then
						pg.TipsMgr.GetInstance():ShowTips(i18n(var0_163))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_win"))
					end

					arg0_163()
				end
			})
		elseif var2_157 == ChapterConst.ReasonDefeat then
			if var0_157:getPlayType() == ChapterConst.TypeTransport then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_escort_lose"))
				var3_157()
			else
				arg0_157:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("formation_invalide"),
					onYes = var3_157,
					onClose = var3_157
				})
			end
		elseif var2_157 == ChapterConst.ReasonDefeatDefense then
			arg0_157:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("harbour_bomb_tip"),
				onYes = var3_157,
				onClose = var3_157
			})
		elseif var2_157 == ChapterConst.ReasonVictoryOni then
			var3_157()
		elseif var2_157 == ChapterConst.ReasonDefeatOni then
			var3_157()
		elseif var2_157 == ChapterConst.ReasonDefeatBomb then
			var3_157()
		elseif var2_157 == ChapterConst.ReasonOutTime then
			arg0_157:emit(LevelMediator2.ON_TIME_UP)
		elseif var2_157 == ChapterConst.ReasonActivityOutTime then
			arg0_157:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_activity_timeout"),
				onYes = var3_157,
				onClose = var3_157
			})
		end

		return true
	end

	return var1_157
end

function var0_0.SafeCheck(arg0_164)
	local var0_164 = arg0_164.contextData.chapterVO

	if var0_164:existOni() then
		local var1_164 = var0_164:checkOniState()

		if var1_164 == 1 then
			return true, ChapterConst.ReasonVictoryOni
		elseif var1_164 == 2 then
			return true, ChapterConst.ReasonDefeatOni
		else
			return false
		end
	elseif var0_164:isPlayingWithBombEnemy() then
		if var0_164:getBombChapterInfo().action_times * 2 <= var0_164.roundIndex then
			return true, ChapterConst.ReasonDefeatBomb
		else
			return false
		end
	end

	local var2_164, var3_164 = var0_164:CheckChapterWin()

	if var2_164 then
		return true, var3_164
	end

	local var4_164, var5_164 = var0_164:CheckChapterLose()

	if var4_164 then
		return true, var5_164
	end

	if not var0_164:inWartime() then
		return true, ChapterConst.ReasonOutTime
	end

	local var6_164 = var0_164:GetBindActID()

	if not arg0_164.contextData.map:isRemaster() and var6_164 ~= 0 then
		local var7_164 = getProxy(ActivityProxy):getActivityById(var6_164)

		if not var7_164 or var7_164:isEnd() then
			return true, ChapterConst.ReasonActivityOutTime
		end
	end

	return false
end

function var0_0.TryAutoFight(arg0_165)
	local var0_165 = arg0_165.contextData.chapterVO
	local var1_165 = arg0_165.contextData.map

	if not var0_165:IsAutoFight() then
		return
	end

	local var2_165 = var0_165:GetAllEnemies()
	local var3_165 = _.detect(var2_165, function(arg0_166)
		return ChapterConst.IsBossCell(arg0_166)
	end)
	local var4_165 = var0_165:GetFleetOfDuty(tobool(var3_165))

	if var4_165 and var4_165.id ~= var0_165.fleet.id then
		arg0_165:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var4_165.id
		})
		arg0_165:tryAutoTrigger()

		return
	end

	if var0_165:checkAnyInteractive() then
		arg0_165:tryAutoTrigger()

		return
	end

	local var5_165

	for iter0_165, iter1_165 in ipairs(var0_165:getConfig("box_auto_pick")) do
		local var6_165 = underscore.filter(switch(iter1_165, {
			[ChapterConst.AttachBox] = function()
				return var0_165:findChapterCells(iter1_165)
			end,
			[ChapterConst.AttachSupply] = function()
				local var0_168, var1_168 = var0_165:getFleetAmmo(var4_165)

				if var0_168 - var1_168 < 3 then
					return {}
				else
					return underscore.filter(var0_165:findChapterCells(iter1_165), function(arg0_169)
						return arg0_169.attachmentId > 0
					end)
				end
			end
		}), function(arg0_170)
			return arg0_170.flag ~= ChapterConst.CellFlagDisabled
		end)

		for iter2_165, iter3_165 in ipairs(var6_165) do
			local var7_165, var8_165 = var0_165:findPath(ChapterConst.SubjectPlayer, var4_165.line, iter3_165)

			if var7_165 < PathFinding.PrioObstacle then
				var5_165 = var5_165 or {}

				table.insert(var5_165, {
					target = iter3_165,
					priority = var7_165,
					path = var8_165
				})
			end
		end

		if var5_165 then
			table.sort(var5_165, CompareFuncs({
				function(arg0_171)
					return arg0_171.priority
				end
			}))

			break
		end
	end

	if not var5_165 then
		if var3_165 then
			local var9_165, var10_165 = var0_165:FindBossPath(var4_165.line, var3_165)
			local var11_165 = {}
			local var12_165

			for iter4_165, iter5_165 in ipairs(var10_165) do
				table.insert(var11_165, iter5_165)

				if var0_165:existEnemy(ChapterConst.SubjectPlayer, iter5_165.row, iter5_165.column) then
					var9_165 = iter4_165
					var12_165 = iter5_165

					break
				end
			end

			var5_165 = {
				{
					target = var12_165 or var3_165,
					priority = var9_165 or 0,
					path = var11_165
				}
			}
		else
			var5_165 = underscore.map(var2_165, function(arg0_172)
				local var0_172, var1_172 = var0_165:findPath(ChapterConst.SubjectPlayer, var4_165.line, arg0_172)

				return {
					target = arg0_172,
					priority = var0_172,
					path = var1_172
				}
			end)

			local function var13_165(arg0_173)
				local var0_173 = arg0_173.target
				local var1_173 = pg.expedition_data_template[var0_173.attachmentId]

				assert(var1_173, "expedition_data_template not exist: " .. var0_173.attachmentId)

				if var0_173.flag == ChapterConst.CellFlagDisabled then
					return 0
				end

				return ChapterConst.EnemyPreference[var1_173.type]
			end

			if var0_165.id == 1604 then
				table.sort(var5_165, CompareFuncs({
					function(arg0_174)
						return arg0_174.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_175)
						return -var13_165(arg0_175)
					end,
					function(arg0_176)
						return arg0_176.priority
					end,
					function(arg0_177)
						return arg0_177.target.row
					end,
					function(arg0_178)
						return -arg0_178.target.column
					end
				}))
			else
				table.sort(var5_165, CompareFuncs({
					function(arg0_179)
						return arg0_179.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_180)
						return -var13_165(arg0_180)
					end,
					function(arg0_181)
						return arg0_181.priority
					end
				}))
			end
		end
	end

	if var5_165 and #var5_165 > 0 and var5_165[1].priority < PathFinding.PrioObstacle then
		local var14_165 = var5_165[1].target

		arg0_165:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var4_165.id,
			arg1 = var14_165.row,
			arg2 = var14_165.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(var0_165.id, false)
	end
end

function var0_0.popStageStrategy(arg0_182)
	local var0_182 = arg0_182.rightStage:Find("event/collapse")

	if var0_182.anchoredPosition.x <= 1 then
		triggerButton(var0_182)
	end
end

function var0_0.UpdateAutoFightPanel(arg0_183)
	if arg0_183.contextData.chapterVO:CanActivateAutoFight() then
		if not arg0_183.autoFightPanel then
			arg0_183.autoFightPanel = LevelStageAutoFightPanel.New(arg0_183.rightStage:Find("event/collapse"), arg0_183.event, arg0_183.contextData)

			arg0_183.autoFightPanel:Load()

			arg0_183.autoFightPanel.isFrozen = arg0_183.isFrozen
		end

		arg0_183.autoFightPanel.buffer:Show()
	elseif arg0_183.autoFightPanel then
		arg0_183.autoFightPanel.buffer:Hide()
	end
end

function var0_0.UpdateAutoFightMark(arg0_184)
	if not arg0_184.autoFightPanel then
		return
	end

	arg0_184.autoFightPanel.buffer:UpdateAutoFightMark()
end

function var0_0.DestroyAutoFightPanel(arg0_185)
	if not arg0_185.autoFightPanel then
		return
	end

	arg0_185.autoFightPanel:Destroy()

	arg0_185.autoFightPanel = nil
end

function var0_0.DestroyToast(arg0_186)
	if not arg0_186.toastPanel then
		return
	end

	arg0_186.toastPanel:Destroy()

	arg0_186.toastPanel = nil
end

function var0_0.Toast(arg0_187)
	arg0_187:DestroyToast()

	local var0_187 = table.remove(arg0_187.toastQueue, 1)

	if not var0_187 then
		return
	end

	arg0_187.toastPanel = var0_187.Class.New(arg0_187)

	arg0_187.toastPanel:Load()

	arg0_187.toastPanel.contextData.settings = var0_187

	arg0_187.toastPanel.buffer:Play(function()
		arg0_187:Toast()
	end)
end

function var0_0.HandleShowMsgBox(arg0_189, arg1_189)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_189)
end

return var0_0
