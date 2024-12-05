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
	arg0_8.topStage = arg0_8:findTF("top_stage", arg0_8._tf)

	setActive(arg0_8.topStage, true)

	arg0_8.bottomStage = arg0_8:findTF("bottom_stage", arg0_8._tf)
	arg0_8.normalRole = findTF(arg0_8.bottomStage, "Normal")
	arg0_8.funcBtn = arg0_8:findTF("func_button", arg0_8.normalRole)
	arg0_8.retreatBtn = arg0_8:findTF("retreat_button", arg0_8.normalRole)
	arg0_8.switchBtn = arg0_8:findTF("switch_button", arg0_8.normalRole)
	arg0_8.helpBtn = arg0_8:findTF("help_button", arg0_8.normalRole)
	arg0_8.shengfuBtn = arg0_8:findTF("shengfu/shengfu_button", arg0_8.normalRole)
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

	arg0_8.leftStage = arg0_8:findTF("left_stage", arg0_8._tf)

	setActive(arg0_8.leftStage, true)

	arg0_8.rightStage = arg0_8:findTF("right_stage", arg0_8._tf)
	arg0_8.bombPanel = arg0_8.rightStage:Find("bomb_panel")
	arg0_8.panelBarrier = arg0_8:findTF("panel_barrier", arg0_8.rightStage)
	arg0_8.strategyPanelAnimator = arg0_8:findTF("event", arg0_8.rightStage):GetComponent(typeof(Animator))
	arg0_8.autoBattleBtn = arg0_8:findTF("event/collapse/lock_fleet", arg0_8.rightStage)
	arg0_8.showDetailBtn = arg0_8:findTF("event/detail/show_detail", arg0_8.rightStage)

	setActive(arg0_8.panelBarrier, false)
	setActive(arg0_8.rightStage, true)

	arg0_8.airSupremacy = arg0_8:findTF("msg_panel/air_supremacy", arg0_8.topStage)

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
	onButton(arg0_10, arg0_10:findTF("option", arg0_10.topStage), function()
		arg0_10:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10:findTF("back_button", arg0_10.topStage), function()
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

						if var2_24.story == var12_20 then
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
			elseif pg.map_event_list[var0_25.id] and pg.map_event_list[var0_25.id].help_pictures and next(pg.map_event_list[var0_25.id].help_pictures) ~= nil then
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

	if var0_46:getChapterSupportFleet() then
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

	local var6_46 = var0_46:GetWeather()
	local var7_46 = 0

	if var0_46:ExistDivingChampion() then
		var7_46 = 1
	end

	local var8_46 = _.map(_.values(var1_46:getCommanders()), function(arg0_49)
		return arg0_49:getSkills()[1]
	end)
	local var9_46 = findTF(arg0_46.topStage, "icon_list/fleet_buffs")
	local var10_46 = UIItemList.New(var9_46, var9_46:GetChild(0))

	var10_46:make(function(arg0_50, arg1_50, arg2_50)
		setActive(findTF(arg2_50, "frame"), false)
		setActive(findTF(arg2_50, "Text"), false)
		setActive(findTF(arg2_50, "times"), false)

		if arg0_50 == UIItemList.EventUpdate then
			local var0_50 = GetComponent(arg2_50, typeof(LayoutElement))

			var0_50.preferredWidth = 64
			var0_50.preferredHeight = 64

			if arg1_50 + 1 <= #var2_46 then
				local var1_50 = var2_46[arg1_50 + 1]
				local var2_50 = pg.strategy_data_template[var1_50]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_50.icon, "", arg2_50)

				local var3_50

				if var2_50.type == ChapterConst.StgTypeBindFleetPassive then
					var3_50 = var1_46:GetStrategyCount(var1_50)

					setActive(findTF(arg2_50, "times"), true)
					setText(findTF(arg2_50, "times"), var3_50)
				end

				local var4_50 = var2_50.iconSize

				if var4_50 ~= "" then
					var0_50.preferredWidth = var4_50[1]
					var0_50.preferredHeight = var4_50[2]
				end

				onButton(arg0_46, arg2_50, function()
					arg0_46:HandleShowMsgBox({
						iconPreservedAspect = true,
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var2_50.id,
							cfg = var2_50,
							count = var3_50
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1_50 = arg1_50 - #var2_46

			if arg1_50 + 1 <= #var6_46 then
				local var5_50 = pg.weather_data_template[var6_46[arg1_50 + 1]]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var5_50.buff_icon, "", arg2_50)
				onButton(arg0_46, arg2_50, function()
					arg0_46:HandleShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var5_50.name,
						content = var5_50.buff_desc,
						iconPath = {
							"strategyicon/" .. var5_50.buff_icon
						},
						yesText = pg.MsgboxMgr.TEXT_CONFIRM
					})
				end, SFX_PANEL)

				return
			end

			arg1_50 = arg1_50 - #var6_46

			if arg1_50 + 1 <= #var3_46 then
				local var6_50 = var3_46[arg1_50 + 1]
				local var7_50 = pg.strategy_data_template[var6_50.id]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var7_50.icon, "", arg2_50)
				setActive(findTF(arg2_50, "times"), true)
				setText(findTF(arg2_50, "times"), var6_50.count)
				onButton(arg0_46, arg2_50, function()
					arg0_46:HandleShowMsgBox({
						iconPreservedAspect = true,
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var7_50.id,
							cfg = var7_50
						},
						extendDesc = string.format(i18n("word_rest_times"), var6_50.count)
					})
				end, SFX_PANEL)

				return
			end

			arg1_50 = arg1_50 - #var3_46

			if arg1_50 + 1 <= var7_46 then
				GetImageSpriteFromAtlasAsync("strategyicon/submarine_approach", "", arg2_50)
				onButton(arg0_46, arg2_50, function()
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

			arg1_50 = arg1_50 - var7_46

			local var8_50 = var8_46[arg1_50 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var8_50:getConfig("icon"), "", arg2_50)
			setText(findTF(arg2_50, "Text"), "Lv." .. var8_50:getConfig("lv"))
			setActive(findTF(arg2_50, "Text"), true)
			setActive(findTF(arg2_50, "frame"), true)
			onButton(arg0_46, arg2_50, function()
				arg0_46:emit(LevelMediator2.ON_COMMANDER_SKILL, var8_50)
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

function var0_0.updateEnemyCount(arg0_56)
	local var0_56 = arg0_56.contextData.chapterVO
	local var1_56 = findTF(arg0_56.topStage, "icon_list/enemy_count")
	local var2_56 = tobool(underscore.detect(var0_56.achieves, function(arg0_57)
		return (arg0_57.type == ChapterConst.AchieveType3 or arg0_57.type == ChapterConst.AchieveType6) and not ChapterConst.IsAchieved(arg0_57)
	end))

	setActive(var1_56, var2_56)

	if var2_56 then
		local var3_56 = var0_56:getDisplayEnemyCount()

		setText(var1_56:Find("Text"), var3_56)
		GetImageSpriteFromAtlasAsync("enemycount", var3_56 > 0 and "danger" or "safe", var1_56)
		onButton(arg0_56, var1_56, function()
			if var3_56 > 0 then
				arg0_56:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_56),
					iconPath = {
						"enemycount",
						"danger"
					},
					yesText = i18n("star_require_enemy_check"),
					onYes = function()
						local var0_59 = var0_56:getNearestEnemyCell()

						arg0_56.grid:focusOnCell(var0_59)

						local var1_59 = arg0_56.grid:GetEnemyCellView(var0_59)

						if var1_59 and var1_59.TweenShining then
							var1_59:TweenShining(2)
						end
					end
				})
			else
				arg0_56:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_56),
					iconPath = {
						"enemycount",
						"safe"
					}
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateChapterBuff(arg0_60)
	local var0_60 = arg0_60.contextData.chapterVO
	local var1_60 = findTF(arg0_60.topStage, "icon_list/chapter_buff")
	local var2_60 = var0_60:hasMitigation()

	SetActive(var1_60, var2_60)

	if var2_60 then
		local var3_60 = var0_60:getRiskLevel()

		GetImageSpriteFromAtlasAsync("passstate", var3_60 .. "_icon", var1_60)
		onButton(arg0_60, var1_60, function()
			if not var0_60:hasMitigation() then
				return
			end

			arg0_60:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = var0_60:getChapterState(),
				iconPath = {
					"passstate",
					var3_60 .. "_icon"
				},
				content = i18n("level_risk_level_mitigation_rate", var0_60:getRemainPassCount(), var0_60:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateAirDominance(arg0_62)
	local var0_62, var1_62, var2_62 = arg0_62.contextData.chapterVO:getAirDominanceValue()

	if not var2_62 or var2_62 ~= var1_62 then
		arg0_62.contextData.chapterVO:setAirDominanceStatus(var1_62)
		getProxy(ChapterProxy):updateChapter(arg0_62.contextData.chapterVO)
	end

	arg0_62.isChange = var2_62 and (var1_62 == 0 and 3 or var1_62) - (var2_62 == 0 and 3 or var2_62)

	arg0_62:updateAirDominanceTitle(var0_62, var1_62, arg0_62.isChange or 0)
end

function var0_0.updateAirDominanceTitle(arg0_63, arg1_63, arg2_63, arg3_63)
	local var0_63 = findTF(arg0_63.airSupremacy, "label1")
	local var1_63 = findTF(arg0_63.airSupremacy, "label2")
	local var2_63 = findTF(arg0_63.airSupremacy, "value1")
	local var3_63 = findTF(arg0_63.airSupremacy, "value2")
	local var4_63 = findTF(arg0_63.airSupremacy, "up")
	local var5_63 = findTF(arg0_63.airSupremacy, "down")

	setText(var0_63, i18n("level_scene_title_word_3"))
	setText(var1_63, i18n("level_scene_title_word_4"))
	setText(var2_63, math.floor(arg1_63))
	setActive(var4_63, false)
	setActive(var5_63, false)

	if arg3_63 ~= 0 then
		if LeanTween.isTweening(go(var3_63)) then
			LeanTween.cancel(go(var3_63))
		end

		LeanTween.value(go(var3_63), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_64)
			setTextAlpha(var3_63, arg0_64)
		end)):setOnComplete(System.Action(function()
			setText(var3_63, ChapterConst.AirDominance[arg2_63].name)
			setTextColor(var3_63, ChapterConst.AirDominance[arg2_63].color)
			LeanTween.value(go(var3_63), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_66)
				setTextAlpha(var3_63, arg0_66)
			end))
		end))

		local function var6_63(arg0_67)
			setActive(arg0_67, false)
		end

		var4_63:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_63)
		var5_63:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_63)
		setActive(var4_63, arg3_63 > 0)
		setActive(var5_63, arg3_63 < 0)
	else
		setText(var3_63, ChapterConst.AirDominance[arg2_63].name)
		setTextColor(var3_63, ChapterConst.AirDominance[arg2_63].color)
	end
end

function var0_0.UpdateDefenseStatus(arg0_68)
	local var0_68 = arg0_68.contextData.chapterVO
	local var1_68 = var0_68:getPlayType() == ChapterConst.TypeDefence
	local var2_68 = findTF(arg0_68.bottomStage, "Normal/shengfu")

	setActive(var2_68, var1_68)

	if not var1_68 then
		return
	end

	local var3_68 = findTF(var2_68, "hp"):GetComponent(typeof(Text))
	local var4_68 = var0_68.id
	local var5_68 = pg.chapter_defense[var4_68]

	var3_68.text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(var0_68.BaseHP) .. "</color>", var5_68.port_hp)
end

function var0_0.DisplayWinConditionPanel(arg0_69)
	if not arg0_69.winCondPanel then
		arg0_69.winCondPanel = WinConditionDisplayPanel.New(arg0_69._tf.parent, arg0_69.event, arg0_69.contextData)

		arg0_69.winCondPanel:Load()
	end

	arg0_69.winCondPanel:ActionInvoke("Enter", arg0_69.contextData.chapterVO)
end

function var0_0.DestroyWinConditionPanel(arg0_70)
	if not arg0_70.winCondPanel then
		return
	end

	arg0_70.winCondPanel:Destroy()

	arg0_70.winCondPanel = nil
end

function var0_0.UpdateComboPanel(arg0_71)
	local var0_71 = arg0_71.contextData.chapterVO
	local var1_71 = pg.chapter_pop_template[var0_71.id]

	if var1_71 and var1_71.combo_on then
		local var2_71, var3_71 = arg0_71:GetSubView("LevelStageComboPanel")

		if var3_71 then
			var2_71:Load()
			var2_71.buffer:SetParent(arg0_71.leftStage, false)
		end

		local var4_71 = getProxy(ChapterProxy):GetComboHistory(var0_71.id)

		var2_71.buffer:UpdateView(var4_71 or var0_71)
		var2_71.buffer:UpdateViewAnimated(var0_71)
	end
end

function var0_0.UpdateDOALinkFeverPanel(arg0_72, arg1_72)
	local var0_72 = arg0_72.contextData.chapterVO
	local var1_72 = var0_72:GetBindActID()
	local var2_72 = var0_72:getConfig("levelstage_bar")

	if not var2_72 or var2_72 == "" then
		existCall(arg1_72)

		return
	end

	local var3_72, var4_72 = arg0_72:GetSubView(var2_72)

	if var4_72 then
		var3_72:Load()
		var3_72.buffer:SetParent(arg0_72._tf, false)
	end

	var3_72.buffer:UpdateView(var0_72, arg1_72)
end

local var2_0 = Vector2(396, 128)
local var3_0 = Vector2(128, 128)

function var0_0.updateStageStrategy(arg0_73)
	local var0_73 = arg0_73.contextData.chapterVO
	local var1_73 = findTF(arg0_73.rightStage, "event")
	local var2_73 = findTF(var1_73, "detail")
	local var3_73 = findTF(var2_73, "click")
	local var4_73 = findTF(var2_73, "items")

	var4_73:GetComponent(typeof(GridLayoutGroup)).cellSize = arg0_73._showStrategyDetail and var2_0 or var3_0

	local var5_73 = findTF(var4_73, "item")
	local var6_73 = findTF(var1_73, "collapse")

	setActive(var5_73, false)

	local var7_73 = var0_73:GetInteractableStrategies()
	local var8_73

	local function var9_73(arg0_74, arg1_74, arg2_74)
		if arg0_74 ~= UIItemList.EventUpdate then
			return
		end

		local var0_74 = arg2_74:Find("detail")

		setActive(var0_74, arg0_73._showStrategyDetail)

		local var1_74 = arg2_74:Find("icon")
		local var2_74 = var7_73[arg1_74 + 1]
		local var3_74
		local var4_74

		if var2_74.id == ChapterConst.StrategyHuntingRange then
			var3_74 = ChapterConst.StgTypeConst
			var4_74 = arg0_73.contextData.huntingRangeVisibility % 2 == 1 and "range_invisible" or "range_visible"

			setText(var0_74, i18n("help_sub_limits"))
		elseif var2_74.id == ChapterConst.StrategySubAutoAttack then
			var3_74 = ChapterConst.StgTypeConst
			var4_74 = var0_73.subAutoAttack == 0 and "sub_dont_auto_attack" or "sub_auto_attack"

			setText(var0_74, i18n("help_sub_display"))
		else
			local var5_74 = pg.strategy_data_template[var2_74.id]

			var3_74 = var5_74.type
			var4_74 = var5_74.icon

			setText(var0_74, var5_74.desc)
		end

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_74, "", var1_74:Find("icon"))
		onButton(arg0_73, var1_74, function()
			if var2_74.id == ChapterConst.StrategyHuntingRange then
				arg0_73.grid:toggleHuntingRange()
				var9_73(arg0_74, arg1_74, arg2_74)
			elseif var2_74.id == ChapterConst.StrategySubAutoAttack then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ai_change_" .. 1 - var0_73.subAutoAttack + 1))
				arg0_73:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubState,
					arg1 = 1 - var0_73.subAutoAttack
				})
			elseif var2_74.id == ChapterConst.StrategyExchange then
				local var0_75 = var0_73:getNextValidIndex()

				if var0_75 > 0 and var2_74.count > 0 then
					local var1_75 = var0_73.fleet

					arg0_73:HandleShowMsgBox({
						content = i18n("levelScene_who_to_exchange"),
						onYes = function()
							arg0_73:emit(LevelMediator2.ON_OP, {
								type = ChapterConst.OpStrategy,
								id = var1_75.id,
								arg1 = ChapterConst.StrategyExchange,
								arg2 = var0_73.fleets[var0_75].id
							})
						end
					})
				end
			elseif var2_74.id == ChapterConst.StrategySubTeleport then
				arg0_73:SwitchSubTeleportBottomStage()
				arg0_73:SwitchBottomStagePanel(true)
				arg0_73.grid:ShowStaticHuntingRange()
				arg0_73.grid:PrepareSubTeleport()
				arg0_73.grid:updateQuadCells(ChapterConst.QuadStateTeleportSub)
			elseif var2_74.id == ChapterConst.StrategyMissileStrike then
				if not var0_73.fleet:canUseStrategy(var2_74) then
					return
				end

				arg0_73:SwitchMissileBottomStagePanel()
				arg0_73:SwitchBottomStagePanel(true)
				arg0_73.grid:updateQuadCells(ChapterConst.QuadStateMissileStrike)
			elseif var2_74.id == ChapterConst.StrategyAirSupport then
				if not var0_73:getChapterSupportFleet():canUseStrategy(var2_74) then
					return
				end

				arg0_73:SwitchAirSupportBottomStagePanel()
				arg0_73:SwitchBottomStagePanel(true)
				arg0_73.grid:updateQuadCells(ChapterConst.QuadStateAirSuport)
			elseif var2_74.id == ChapterConst.StrategyExpel then
				if not var0_73:getChapterSupportFleet():canUseStrategy(var2_74) then
					return
				end

				arg0_73:SwitchAirExpelBottomStagePanel()
				arg0_73:SwitchBottomStagePanel(true)
				arg0_73.grid:updateQuadCells(ChapterConst.QuadStateExpel)
			elseif var3_74 == ChapterConst.StgTypeForm then
				local var2_75 = var0_73.fleet
				local var3_75 = table.indexof(ChapterConst.StrategyForms, var2_74.id)

				arg0_73:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpStrategy,
					id = var2_75.id,
					arg1 = ChapterConst.StrategyForms[var3_75 % #ChapterConst.StrategyForms + 1]
				})
			else
				arg0_73:emit(LevelUIConst.DISPLAY_STRATEGY_INFO, var2_74)
			end
		end, SFX_PANEL)

		if var3_74 == ChapterConst.StgTypeForm then
			setText(var1_74:Find("nums"), "")
			setActive(var1_74:Find("mask"), false)
			setActive(var1_74:Find("selected"), true)
		else
			setText(var1_74:Find("nums"), var2_74.count or "")
			setActive(var1_74:Find("mask"), var2_74.count == 0)
			setActive(var1_74:Find("selected"), false)
		end
	end

	UIItemList.StaticAlign(var4_73, var5_73, #var7_73, var9_73)
	onButton(arg0_73, var3_73, function()
		shiftPanel(var2_73, var2_73.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_73, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_73, var6_73, function()
		shiftPanel(var2_73, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_73, var6_73.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

function var0_0.GetSubView(arg0_79, arg1_79)
	if arg0_79.attachSubViews[arg1_79] then
		return arg0_79.attachSubViews[arg1_79]
	end

	local var0_79 = _G[arg1_79].New(arg0_79)

	assert(var0_79, "cant't find subview " .. (arg1_79 or "nil"))

	arg0_79.attachSubViews[arg1_79] = var0_79

	return var0_79, true
end

function var0_0.RemoveSubView(arg0_80, arg1_80)
	if not arg0_80.attachSubViews[arg1_80] then
		return false
	end

	arg0_80.attachSubViews[arg1_80]:Destroy()

	arg0_80.attachSubViews[arg1_80] = nil

	return true
end

function var0_0.ClearSubViews(arg0_81)
	for iter0_81, iter1_81 in pairs(arg0_81.attachSubViews) do
		iter1_81:Destroy()
	end

	table.clear(arg0_81.attachSubViews)
end

function var0_0.updateStageFleet(arg0_82)
	local var0_82 = arg0_82.contextData.chapterVO
	local var1_82 = findTF(arg0_82.leftStage, "fleet")
	local var2_82 = findTF(var1_82, "shiptpl")
	local var3_82 = arg0_82:findTF("msg_panel/fleet_info/number", arg0_82.topStage)

	setActive(var2_82, false)
	setText(var3_82, var0_82.fleet.id)

	local var4_82 = var0_82.fleet:getShips(true)

	local function var5_82(arg0_83, arg1_83)
		local var0_83 = UIItemList.New(arg0_83, var2_82)

		var0_83:make(function(arg0_84, arg1_84, arg2_84)
			if arg0_84 == UIItemList.EventUpdate then
				local var0_84 = arg1_83[arg1_84 + 1]

				updateShip(arg2_84, var0_84)

				local var1_84 = var0_84.hpRant
				local var2_84 = var0_84:getShipProperties()
				local var3_84 = math.floor((var0_84.hpChange or 0) / 10000 * var2_84[AttributeType.Durability])
				local var4_84 = findTF(arg2_84, "HP_POP")

				setActive(var4_84, true)
				setActive(findTF(var4_84, "heal"), false)
				setActive(findTF(var4_84, "normal"), false)

				local function var5_84(arg0_85, arg1_85)
					setActive(arg0_85, true)
					setText(findTF(arg0_85, "text"), arg1_85)
					setTextAlpha(findTF(arg0_85, "text"), 0)
					LeanTween.moveY(arg0_85, 60, 1)
					LeanTween.textAlpha(findTF(arg0_85, "text"), 1, 0.3)
					LeanTween.textAlpha(findTF(arg0_85, "text"), 0, 0.5):setDelay(0.7):setOnComplete(System.Action(function()
						arg0_85.localPosition = Vector3(0, 0, 0)
					end))
				end

				if var3_84 > 0 then
					var5_84(findTF(var4_84, "heal"), var3_84)
				elseif var3_84 < 0 then
					LeanTween.delayedCall(0.6, System.Action(function()
						local var0_87 = arg2_84.transform.localPosition.x

						LeanTween.moveX(arg2_84, var0_87, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
						LeanTween.alpha(findTF(arg2_84, "red"), 0.5, 0.4)
						LeanTween.alpha(findTF(arg2_84, "red"), 0, 0.4):setDelay(0.4)
						var5_84(findTF(var4_84, "normal"), var3_84)
					end))
				end

				local var6_84 = findTF(arg2_84, "blood")
				local var7_84 = findTF(arg2_84, "blood/fillarea/green")
				local var8_84 = findTF(arg2_84, "blood/fillarea/red")
				local var9_84 = var1_84 < ChapterConst.HpGreen
				local var10_84 = var1_84 == 0

				setActive(var7_84, not var9_84)
				setActive(var8_84, var9_84)

				var6_84:GetComponent(typeof(Slider)).fillRect = var9_84 and var8_84 or var7_84

				setSlider(var6_84, 0, 10000, var1_84)
				setActive(findTF(arg2_84, "repairmask"), var9_84)
				setActive(findTF(arg2_84, "repairmask/broken"), var10_84)
				onButton(arg0_82, arg2_84:Find("repairmask"), function()
					arg0_82:emit(LevelUIConst.DISPLAY_REPAIR_WINDOW, var0_84)
				end, SFX_PANEL)

				local var11_84 = findTF(arg2_84, "repairmask/icon").gameObject

				if not var9_84 then
					LeanTween.cancel(var11_84)
					setImageAlpha(var11_84, 1)
				end

				if var9_84 and not LeanTween.isTweening(var11_84) then
					LeanTween.alpha(rtf(var11_84), 0, 2):setLoopPingPong()
				end

				local var12_84 = GetOrAddComponent(arg2_84, "UILongPressTrigger").onLongPressed

				pg.DelegateInfo.Add(arg0_82, var12_84)
				var12_84:RemoveAllListeners()
				var12_84:AddListener(function()
					arg0_82:emit(LevelMediator2.ON_STAGE_SHIPINFO, {
						shipId = var0_84.id,
						shipVOs = var4_82
					})
				end)
			end
		end)
		var0_83:align(#arg1_83)
	end

	var5_82(var1_82:Find("main"), var0_82.fleet:getShipsByTeam(TeamType.Main, true))
	var5_82(var1_82:Find("vanguard"), var0_82.fleet:getShipsByTeam(TeamType.Vanguard, true))
	var0_82.fleet:clearShipHpChange()
end

function var0_0.updateSupportFleet(arg0_90)
	local var0_90 = arg0_90.contextData.chapterVO:getChapterSupportFleet()
	local var1_90 = findTF(arg0_90.leftStage, "support_fleet")

	if var0_90 then
		setActive(var1_90, true)

		local var2_90 = findTF(var1_90, "show/ship_container")

		removeAllChildren(var2_90)

		local var3_90 = findTF(var1_90, "show/shiptpl")
		local var4_90 = var0_90:getShips()

		for iter0_90, iter1_90 in pairs(var4_90) do
			local var5_90 = cloneTplTo(var3_90, var2_90)

			setActive(var5_90, true)
			updateShip(var5_90, iter1_90)
		end

		local var6_90 = var1_90:Find("hide")
		local var7_90 = var1_90:Find("show")

		local function var8_90(arg0_91)
			setActive(var6_90, true)
			setActive(var7_90, true)
			shiftPanel(var7_90, nil, arg0_91 and -325.1 or -855, 0.3, 0, true, nil, LeanTweenType.easeOutSine, function()
				setActive(var6_90, not arg0_91)
				setActive(var7_90, arg0_91)
			end)
			shiftPanel(var6_90, nil, arg0_91 and -1017 or -563.97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		end

		onButton(arg0_90, var6_90, function()
			var8_90(true)
		end, SFX_PANEL)
		onButton(arg0_90, var7_90, function()
			var8_90(false)
		end)
	else
		setActive(var1_90, false)
	end
end

function var0_0.ShiftStagePanelIn(arg0_95, arg1_95)
	shiftPanel(arg0_95.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_95)
	arg0_95:ShiftBottomStage(true)
	shiftPanel(arg0_95.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_95.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftStagePanelOut(arg0_96, arg1_96)
	shiftPanel(arg0_96.topStage, 0, arg0_96.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_96)
	arg0_96:ShiftBottomStage(false)
	shiftPanel(arg0_96.leftStage, -arg0_96.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_96.rightStage, arg0_96.rightStage.rect.width + 300, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftBottomStage(arg0_97, arg1_97)
	arg1_97 = not arg0_97.bottomStageInactive and arg1_97

	local var0_97 = arg1_97 and 0 or -arg0_97.bottomStage.rect.height

	shiftPanel(arg0_97.bottomStage, 0, var0_97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.SwitchSubTeleportBottomStage(arg0_98)
	setActive(arg0_98.missileStrikeRole, true)
	setText(findTF(arg0_98.missileStrikeRole, "confirm_button/Text"), i18n("levelscene_deploy_submarine"))
	setText(findTF(arg0_98.missileStrikeRole, "cancel_button/Text"), i18n("levelscene_deploy_submarine_cancel"))
	onButton(arg0_98, arg0_98:findTF("confirm_button", arg0_98.missileStrikeRole), function()
		local var0_99 = arg0_98.contextData.chapterVO
		local var1_99 = var0_99:GetSubmarineFleet()
		local var2_99 = var1_99.startPos
		local var3_99 = arg0_98.grid.subTeleportTargetLine

		if not var3_99 then
			return
		end

		local var4_99 = var0_99:findPath(nil, var2_99, var3_99)
		local var5_99 = arg0_98.grid:TransformLine2PlanePos(var2_99)
		local var6_99 = arg0_98.grid:TransformLine2PlanePos(var3_99)
		local var7_99 = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #var1_99:getShips(false) * var4_99 - 1e-05)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", var5_99, var6_99, var4_99, var7_99),
			onYes = function()
				arg0_98:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = var1_99.id,
					arg1 = var3_99.row,
					arg2 = var3_99.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_98, arg0_98:findTF("cancel_button", arg0_98.missileStrikeRole), function()
		arg0_98:SwitchBottomStagePanel(false)
		arg0_98.grid:TurnOffSubTeleport()
		arg0_98.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchMissileBottomStagePanel(arg0_102)
	setActive(arg0_102.missileStrikeRole, true)
	setText(findTF(arg0_102.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_102.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_102, arg0_102:findTF("confirm_button", arg0_102.missileStrikeRole), function()
		local var0_103 = arg0_102.grid.missileStrikeTargetLine

		if not var0_103 then
			return
		end

		local var1_103 = arg0_102.contextData.chapterVO.fleet

		;(function()
			arg0_102:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_103.id,
				arg1 = ChapterConst.StrategyMissileStrike,
				arg2 = var0_103.row,
				arg3 = var0_103.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_102, arg0_102:findTF("cancel_button", arg0_102.missileStrikeRole), function()
		arg0_102:SwitchBottomStagePanel(false)
		arg0_102.grid:HideMissileAimingMark()
		arg0_102.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirSupportBottomStagePanel(arg0_106)
	setActive(arg0_106.missileStrikeRole, true)
	setText(findTF(arg0_106.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_106.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_106, arg0_106:findTF("confirm_button", arg0_106.missileStrikeRole), function()
		local var0_107 = arg0_106.grid.missileStrikeTargetLine

		if not var0_107 then
			return
		end

		local var1_107 = arg0_106.contextData.chapterVO:getChapterSupportFleet()

		;(function()
			arg0_106:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_107.id,
				arg1 = ChapterConst.StrategyAirSupport,
				arg2 = var0_107.row,
				arg3 = var0_107.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_106, arg0_106:findTF("cancel_button", arg0_106.missileStrikeRole), function()
		arg0_106:SwitchBottomStagePanel(false)
		arg0_106.grid:HideAirSupportAimingMark()
		arg0_106.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirExpelBottomStagePanel(arg0_110)
	setActive(arg0_110.airExpelRole, true)
	setText(findTF(arg0_110.airExpelRole, "cancel_button/Text"), i18n("levelscene_airexpel_cancel"))
	onButton(arg0_110, arg0_110:findTF("cancel_button", arg0_110.airExpelRole), function()
		arg0_110:SwitchBottomStagePanel(false)
		arg0_110.grid:HideAirExpelAimingMark()
		arg0_110.grid:CleanAirSupport()
		arg0_110.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchBottomStagePanel(arg0_112, arg1_112)
	setActive(arg0_112.actionRole, true)
	setActive(arg0_112.normalRole, true)
	shiftPanel(arg0_112.actionRole, 0, arg1_112 and 0 or var1_0, 0.3, 0, true, true, nil, function()
		setActive(arg0_112.actionRole, arg1_112)
	end)
	shiftPanel(arg0_112.normalRole, 0, arg1_112 and var1_0 or 0, 0.3, 0, true, true, nil, function()
		setActive(arg0_112.normalRole, not arg1_112)

		if not arg1_112 then
			eachChild(arg0_112.actionRole, function(arg0_115)
				setActive(arg0_115, false)
			end)
		end
	end)
	shiftPanel(arg0_112.leftStage, arg1_112 and -arg0_112.leftStage.rect.width - 200 or 0, 0, 0.3, 0, true)
	shiftPanel(arg0_112.rightStage, arg1_112 and arg0_112.rightStage.rect.width + 300 or 0, 0, 0.3, 0, true)
end

function var0_0.ClickGridCellNormal(arg0_116, arg1_116)
	local var0_116 = arg0_116.contextData.chapterVO
	local var1_116 = var0_116.fleet
	local var2_116 = _.detect(var0_116.fleets, function(arg0_117)
		return arg0_117:getFleetType() == FleetType.Normal and arg0_117.line.row == arg1_116.row and arg0_117.line.column == arg1_116.column
	end)

	if var2_116 and var2_116:isValid() and var2_116.id ~= var1_116.id then
		arg0_116:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var2_116.id
		})

		return
	end

	if arg0_116:tryAutoTrigger(nil, true) then
		return
	end

	if arg1_116.row == var1_116.line.row and arg1_116.column == var1_116.line.column then
		return
	end

	local var3_116 = var0_116:getChapterCell(arg1_116.row, arg1_116.column)

	if var3_116.attachment == ChapterConst.AttachStory and var3_116.data == ChapterConst.StoryObstacle and var3_116.flag == ChapterConst.CellFlagTriggerActive then
		local var4_116 = pg.map_event_template[var3_116.attachmentId]

		if var4_116 and var4_116.gametip and #var4_116.gametip > 0 and var0_116:getPlayType() ~= ChapterConst.TypeDefence then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var4_116.gametip))
		end

		return
	elseif not var0_116:considerAsStayPoint(ChapterConst.SubjectPlayer, arg1_116.row, arg1_116.column) then
		return
	elseif var0_116:existMoveLimit() then
		local var5_116 = var0_116:calcWalkableCells(ChapterConst.SubjectPlayer, var1_116.line.row, var1_116.line.column, var1_116:getSpeed())

		if not _.any(var5_116, function(arg0_118)
			return arg0_118.row == arg1_116.row and arg0_118.column == arg1_116.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))

			return
		end
	end

	local var6_116 = var0_116:findPath(ChapterConst.SubjectPlayer, var1_116.line, {
		row = arg1_116.row,
		column = arg1_116.column
	})

	if var6_116 < PathFinding.PrioObstacle then
		arg0_116:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var1_116.id,
			arg1 = arg1_116.row,
			arg2 = arg1_116.column
		})
	elseif var6_116 < PathFinding.PrioForbidden then
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	end
end

function var0_0.tryAutoAction(arg0_119, arg1_119)
	if arg0_119.doingAutoAction then
		return
	end

	arg0_119.doingAutoAction = true

	local var0_119 = arg0_119.contextData.chapterVO

	if not var0_119 then
		existCall(arg1_119)

		return
	end

	if arg0_119:SafeCheck() then
		existCall(arg1_119)

		return
	end

	local var1_119 = {}
	local var2_119 = false

	for iter0_119, iter1_119 in pairs(var0_119.cells) do
		if iter1_119.trait == ChapterConst.TraitLurk then
			var2_119 = true

			break
		end
	end

	if not var2_119 then
		for iter2_119, iter3_119 in ipairs(var0_119.champions) do
			if iter3_119.trait == ChapterConst.TraitLurk then
				var2_119 = true

				break
			end
		end
	end

	if var2_119 then
		local var3_119 = var0_119:existOni()
		local var4_119 = var0_119:isPlayingWithBombEnemy()

		if not var3_119 and not var4_119 then
			table.insert(var1_119, function(arg0_120)
				arg0_119:emit(LevelUIConst.DO_TRACKING, arg0_120)
			end)
		else
			table.insertto(var1_119, {
				function(arg0_121)
					local var0_121

					if var3_119 then
						var0_121 = "SpUnit"
					elseif var4_119 then
						var0_121 = "SpBomb"
					end

					assert(var0_121)
					arg0_119:emit(LevelUIConst.DO_PLAY_ANIM, {
						name = var0_121,
						callback = function(arg0_122)
							setActive(arg0_122, false)
							arg0_121()
						end
					})
				end,
				function(arg0_123)
					local var0_123 = var0_119:getSpAppearStory()

					if var0_123 and #var0_123 > 0 then
						pg.NewStoryMgr.GetInstance():Play(var0_123, arg0_123)

						return
					end

					arg0_123()
				end,
				function(arg0_124)
					local var0_124 = var0_119:getSpAppearGuide()

					if var0_124 and #var0_124 > 0 then
						pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_124, nil, arg0_124)

						return
					end

					arg0_124()
				end
			})
		end

		table.insertto(var1_119, {
			function(arg0_125)
				parallelAsync({
					function(arg0_126)
						arg0_119:tryPlayChapterStory(arg0_126)
					end,
					function(arg0_127)
						local var0_127 = var0_119:GetBossCell()

						if var0_127 and var0_127.trait == ChapterConst.TraitLurk then
							arg0_119.grid:focusOnCell(var0_127, arg0_127)

							return
						end

						arg0_127()
					end
				}, arg0_125)
			end,
			function(arg0_128)
				arg0_119:updateTrait(ChapterConst.TraitVirgin)
				arg0_119.grid:updateAttachments()
				arg0_119.grid:updateChampions()
				arg0_119:updateTrait(ChapterConst.TraitNone)
				arg0_119:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
				Timer.New(arg0_128, 0.5, 1):Start()
			end
		})
	end

	seriesAsync({
		function(arg0_129)
			arg0_119:emit(LevelUIConst.FROZEN)

			local var0_129 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_119.id)

			if var0_129 and (var0_129.attachment ~= ChapterConst.AttachAmbush or ChapterConst.IsBossCell(var0_129)) then
				local var1_129 = ChapterConst.GetDestroyFX(var0_129)

				arg0_119.grid:PlayAttachmentEffect(var0_129.line.row, var0_129.line.column, var1_129, Vector2.zero)
			end

			arg0_119:PopBar()
			arg0_119:UpdateComboPanel()
			arg0_129()
		end,
		function(arg0_130)
			if not (function()
				local var0_131 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_119.id)

				if not var0_131 then
					return
				end

				local var1_131 = pg.expedition_data_template[var0_131.attachmentId]

				return var1_131 and var1_131.type == ChapterConst.ExpeditionTypeMulBoss
			end)() then
				return arg0_130()
			end

			arg0_119:emit(LevelUIConst.DO_PLAY_ANIM, {
				name = "BossRetreatBar",
				callback = function(arg0_132)
					setActive(arg0_132, false)
					arg0_130()
				end
			})
		end,
		function(arg0_133)
			arg0_119:UpdateDOALinkFeverPanel(arg0_133)
		end,
		function(arg0_134)
			seriesAsync(var1_119, arg0_134)
		end,
		function(arg0_135)
			local var0_135, var1_135 = var0_119:GetAttachmentStories()

			if var0_135 then
				table.SerialIpairsAsync(var0_135, function(arg0_136, arg1_136, arg2_136)
					if arg0_136 <= var1_135 and arg1_136 and type(arg1_136) == "number" and arg1_136 > 0 then
						local var0_136 = pg.NewStoryMgr:StoryId2StoryName(arg1_136)

						ChapterOpCommand.PlayChapterStory(var0_136, arg2_136, var0_119:IsAutoFight())

						return
					end

					arg2_136()
				end, arg0_135)

				return
			end

			arg0_135()
		end,
		function(arg0_137)
			local var0_137 = arg0_119.contextData.chapterVO.id
			local var1_137 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_137)

			if not var1_137 or #var1_137 < 1 then
				arg0_137()

				return
			end

			for iter0_137, iter1_137 in ipairs(var1_137) do
				local var2_137 = pg.chapter_status_effect[iter1_137]
				local var3_137 = var2_137 and var2_137.camera_focus or ""

				if type(var3_137) == "table" then
					arg0_119.grid:focusOnCell({
						row = var3_137[1],
						column = var3_137[2]
					}, arg0_137)

					return
				end
			end

			arg0_137()
		end,
		function(arg0_138)
			if arg0_119.exited then
				return
			end

			arg0_119:emit(LevelUIConst.UN_FROZEN)
			;(function()
				local var0_139 = getProxy(ChapterProxy)
				local var1_139 = var0_139:getActiveChapter(true)

				if not var1_139 then
					return
				end

				local var2_139 = var1_139.id

				var0_139:RecordComboHistory(var2_139, nil)
				var0_139:RecordLastDefeatedEnemy(var2_139, nil)
				var0_139:extraFlagUpdated(var2_139)
				var0_139:RemoveExtendChapterData(var2_139, "FleetMoveDistance")
			end)()
			arg0_138()
		end,
		function(arg0_140)
			if arg0_119.exited then
				return
			end

			existCall(arg1_119)

			arg0_119.doingAutoAction = nil

			if var2_119 then
				arg0_119:TryEnterChapterStoryStage()
			end
		end
	})
end

function var0_0.tryPlayChapterStory(arg0_141, arg1_141)
	local var0_141 = arg0_141.contextData.chapterVO
	local var1_141 = var0_141:getWaveCount()

	seriesAsync({
		function(arg0_142)
			pg.SystemGuideMgr.GetInstance():PlayChapter(var0_141, arg0_142)
		end,
		function(arg0_143)
			local var0_143 = var0_141:getConfig("story_refresh")
			local var1_143 = var0_143 and var0_143[var1_141]

			if var1_143 and type(var1_143) == "string" and var1_143 ~= "" and not var0_141:IsRemaster() then
				ChapterOpCommand.PlayChapterStory(var1_143, arg0_143, var0_141:IsAutoFight())

				return
			end

			arg0_143()
		end,
		function(arg0_144)
			local var0_144 = var0_141:getConfig("story_refresh_boss")

			if var0_144 and type(var0_144) == "string" and var0_144 ~= "" and not var0_141:IsRemaster() and var0_141:IsFinalBossRefreshed() then
				ChapterOpCommand.PlayChapterStory(var0_144, arg0_144, var0_141:IsAutoFight())

				return
			end

			arg0_144()
		end,
		function(arg0_145)
			if var1_141 == 1 and pg.map_event_list[var0_141.id] and pg.map_event_list[var0_141.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. var0_141.id, 0) == 0 then
				triggerButton(arg0_141.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. var0_141.id, 1)
			end

			arg0_145()
		end,
		function()
			existCall(arg1_141)
		end
	})
end

function var0_0.TryEnterChapterStoryStage(arg0_147)
	local var0_147 = arg0_147.contextData.chapterVO
	local var1_147 = var0_147:getWaveCount()

	seriesAsync({
		function(arg0_148)
			local var0_148 = var0_147:getConfig("story_refresh")
			local var1_148 = var0_148 and var0_148[var1_147]
			local var2_148 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var1_148)

			if var1_148 and type(var1_148) == "number" and not var0_147:IsRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_148) then
				arg0_147:emit(LevelMediator2.ON_PERFORM_COMBAT, var1_148, arg0_148)
			else
				arg0_148()
			end
		end,
		function(arg0_149)
			local var0_149 = var0_147:getConfig("story_refresh_boss")
			local var1_149 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0_149)

			if var0_149 and type(var0_149) == "number" and not var0_147:IsRemaster() and var0_147:IsFinalBossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_149) then
				arg0_147:emit(LevelMediator2.ON_PERFORM_COMBAT, var0_149, arg0_149)
			else
				arg0_149()
			end
		end
	})
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
	local var4_165

	if ChapterConst.IsAtelierMap(var1_165) then
		var4_165 = _.filter(var0_165:findChapterCells(ChapterConst.AttachBox), function(arg0_167)
			return arg0_167.flag ~= ChapterConst.CellFlagDisabled
		end)
	end

	local var5_165 = var0_165:GetFleetofDuty(tobool(var3_165))

	if var5_165 and var5_165.id ~= var0_165.fleet.id then
		arg0_165:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var5_165.id
		})
		arg0_165:tryAutoTrigger()

		return
	end

	if var0_165:checkAnyInteractive() then
		arg0_165:tryAutoTrigger()

		return
	end

	if var4_165 and #var4_165 > 0 then
		var2_165 = _.map(var4_165, function(arg0_168)
			local var0_168, var1_168 = var0_165:findPath(ChapterConst.SubjectPlayer, var5_165.line, arg0_168)

			return {
				target = arg0_168,
				priority = var0_168,
				path = var1_168
			}
		end)
	elseif var3_165 then
		local var6_165, var7_165 = var0_165:FindBossPath(var5_165.line, var3_165)
		local var8_165 = {}
		local var9_165

		for iter0_165, iter1_165 in ipairs(var7_165) do
			table.insert(var8_165, iter1_165)

			if var0_165:existEnemy(ChapterConst.SubjectPlayer, iter1_165.row, iter1_165.column) then
				var6_165 = iter0_165
				var9_165 = iter1_165

				break
			end
		end

		var2_165 = {
			{
				target = var9_165 or var3_165,
				priority = var6_165 or 0,
				path = var8_165
			}
		}
	else
		var2_165 = _.map(var2_165, function(arg0_169)
			local var0_169, var1_169 = var0_165:findPath(ChapterConst.SubjectPlayer, var5_165.line, arg0_169)

			return {
				target = arg0_169,
				priority = var0_169,
				path = var1_169
			}
		end)

		local function var10_165(arg0_170)
			local var0_170 = arg0_170.target
			local var1_170 = pg.expedition_data_template[var0_170.attachmentId]

			assert(var1_170, "expedition_data_template not exist: " .. var0_170.attachmentId)

			if var0_170.flag == ChapterConst.CellFlagDisabled then
				return 0
			end

			return ChapterConst.EnemyPreference[var1_170.type]
		end

		table.sort(var2_165, function(arg0_171, arg1_171)
			local var0_171 = arg0_171.priority >= PathFinding.PrioObstacle

			if var0_171 ~= (arg1_171.priority >= PathFinding.PrioObstacle) then
				return not var0_171
			end

			local var1_171 = var10_165(arg0_171)
			local var2_171 = var10_165(arg1_171)

			if var1_171 ~= var2_171 then
				return var2_171 < var1_171
			end

			return arg0_171.priority < arg1_171.priority
		end)
	end

	local var11_165 = var2_165[1]

	if var11_165 and var11_165.priority < PathFinding.PrioObstacle then
		local var12_165 = var11_165.target

		arg0_165:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var5_165.id,
			arg1 = var12_165.row,
			arg2 = var12_165.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(var0_165.id, false)
	end
end

function var0_0.popStageStrategy(arg0_172)
	local var0_172 = arg0_172:findTF("event/collapse", arg0_172.rightStage)

	if var0_172.anchoredPosition.x <= 1 then
		triggerButton(var0_172)
	end
end

function var0_0.UpdateAutoFightPanel(arg0_173)
	if arg0_173.contextData.chapterVO:CanActivateAutoFight() then
		if not arg0_173.autoFightPanel then
			arg0_173.autoFightPanel = LevelStageAutoFightPanel.New(arg0_173.rightStage:Find("event/collapse"), arg0_173.event, arg0_173.contextData)

			arg0_173.autoFightPanel:Load()

			arg0_173.autoFightPanel.isFrozen = arg0_173.isFrozen
		end

		arg0_173.autoFightPanel.buffer:Show()
	elseif arg0_173.autoFightPanel then
		arg0_173.autoFightPanel.buffer:Hide()
	end
end

function var0_0.UpdateAutoFightMark(arg0_174)
	if not arg0_174.autoFightPanel then
		return
	end

	arg0_174.autoFightPanel.buffer:UpdateAutoFightMark()
end

function var0_0.DestroyAutoFightPanel(arg0_175)
	if not arg0_175.autoFightPanel then
		return
	end

	arg0_175.autoFightPanel:Destroy()

	arg0_175.autoFightPanel = nil
end

function var0_0.DestroyToast(arg0_176)
	if not arg0_176.toastPanel then
		return
	end

	arg0_176.toastPanel:Destroy()

	arg0_176.toastPanel = nil
end

function var0_0.Toast(arg0_177)
	arg0_177:DestroyToast()

	local var0_177 = table.remove(arg0_177.toastQueue, 1)

	if not var0_177 then
		return
	end

	arg0_177.toastPanel = var0_177.Class.New(arg0_177)

	arg0_177.toastPanel:Load()

	arg0_177.toastPanel.contextData.settings = var0_177

	arg0_177.toastPanel.buffer:Play(function()
		arg0_177:Toast()
	end)
end

function var0_0.HandleShowMsgBox(arg0_179, arg1_179)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_179)
end

return var0_0
