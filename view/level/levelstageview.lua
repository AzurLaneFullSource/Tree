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

function var0_0.getResource(arg0_6)
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

	table.insertto(var0_6, ResList.LevelStageViewResConst.GetResource(arg0_6.contextData))

	return table.insertto(var0_6, var0_0.super.getResource(arg0_6))
end

function var0_0.downloadStageRes(arg0_7, arg1_7)
	local var0_7 = arg0_7.contextData.chapterVO

	if arg0_7._state == var0_0.STATES.DESTROY or not ResList.ChapterResConst.IsActive(var0_7) then
		return
	end

	local var1_7 = ResList.LevelStageViewResConst.GetResource(arg0_7.contextData)

	SplitPackConst.DownloadByLuaArr(var1_7, function()
		local var0_8 = arg0_7.contextData.chapterVO

		if arg0_7._state == var0_0.STATES.DESTROY or not ResList.ChapterResConst.IsActive(var0_8) or var0_8.id ~= var0_7.id then
			return
		end

		if var0_8 ~= var0_7 then
			arg0_7:downloadStageRes(arg1_7)

			return
		end

		arg1_7()
	end)
end

function var0_0.OnInit(arg0_9)
	arg0_9:InitUI()
	arg0_9:AddListener()

	arg0_9.loader = AutoLoader.New()
	arg0_9.cgComp = GetOrAddComponent(arg0_9._go, typeof(CanvasGroup))
	arg0_9.cgComp.blocksRaycasts = not arg0_9.isFrozen

	arg0_9:Show()
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.stageTimer then
		arg0_10.stageTimer:Stop()

		arg0_10.stageTimer = nil
	end

	arg0_10:ClearSubViews()
	arg0_10:DestroyAutoFightPanel()
	arg0_10:DestroyWinConditionPanel()
	arg0_10:DestroyToast()
	arg0_10.loader:Clear()
	arg0_10:Hide()
end

local var1_0 = -300

function var0_0.InitUI(arg0_11)
	arg0_11.topStage = arg0_11._tf:Find("top_stage")

	setActive(arg0_11.topStage, true)

	arg0_11.bottomStage = arg0_11._tf:Find("bottom_stage")
	arg0_11.normalRole = findTF(arg0_11.bottomStage, "Normal")
	arg0_11.funcBtn = arg0_11.normalRole:Find("func_button")
	arg0_11.retreatBtn = arg0_11.normalRole:Find("retreat_button")
	arg0_11.switchBtn = arg0_11.normalRole:Find("switch_button")
	arg0_11.helpBtn = arg0_11.normalRole:Find("help_button")
	arg0_11.shengfuBtn = arg0_11.normalRole:Find("shengfu/shengfu_button")
	arg0_11.actionRole = findTF(arg0_11.bottomStage, "Action")
	arg0_11.missileStrikeRole = findTF(arg0_11.actionRole, "MissileStrike")
	arg0_11.airExpelRole = findTF(arg0_11.actionRole, "AirExpel")

	setActive(arg0_11.bottomStage, true)
	setAnchoredPosition(arg0_11.normalRole, {
		x = 0,
		y = 0
	})
	setActive(arg0_11.normalRole, true)
	setAnchoredPosition(arg0_11.actionRole, {
		x = 0,
		y = var1_0
	})
	setActive(arg0_11.actionRole, false)
	eachChild(arg0_11.actionRole, function(arg0_12)
		setActive(arg0_12, false)
	end)

	arg0_11.leftStage = arg0_11._tf:Find("left_stage")

	setActive(arg0_11.leftStage, true)

	arg0_11.rightStage = arg0_11._tf:Find("right_stage")
	arg0_11.bombPanel = arg0_11.rightStage:Find("bomb_panel")
	arg0_11.panelBarrier = arg0_11.rightStage:Find("panel_barrier")
	arg0_11.strategyPanelAnimator = arg0_11.rightStage:Find("event"):GetComponent(typeof(Animator))
	arg0_11.autoBattleBtn = arg0_11.rightStage:Find("event/collapse/lock_fleet")
	arg0_11.showDetailBtn = arg0_11.rightStage:Find("event/detail/show_detail")

	setActive(arg0_11.panelBarrier, false)
	setActive(arg0_11.rightStage, true)

	arg0_11.airSupremacy = arg0_11.topStage:Find("msg_panel/air_supremacy")

	setAnchoredPosition(arg0_11.topStage, {
		y = arg0_11.topStage.rect.height
	})
	setAnchoredPosition(arg0_11.leftStage, {
		x = -arg0_11.leftStage.rect.width - 200
	})
	setAnchoredPosition(arg0_11.rightStage, {
		x = arg0_11.rightStage.rect.width + 300
	})
	setAnchoredPosition(arg0_11.bottomStage, {
		y = -arg0_11.bottomStage.rect.height
	})

	arg0_11.attachSubViews = {}
end

function var0_0.AddListener(arg0_13)
	arg0_13:bind(LevelUIConst.TRIGGER_ACTION, function()
		arg0_13:tryAutoTrigger()
	end)
	arg0_13:bind(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, function(arg0_15, arg1_15)
		arg0_13.strategyPanelAnimator:SetBool("IsActive", arg1_15)

		arg0_13.bottomStageInactive = arg1_15

		arg0_13:ShiftBottomStage(not arg1_15)
	end)
	arg0_13:bind(LevelUIConst.ON_CLICK_GRID_QUAD, function(arg0_16, arg1_16)
		arg0_13:ClickGridCellNormal(arg1_16)
	end)
	onButton(arg0_13, arg0_13.topStage:Find("option"), function()
		arg0_13:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.topStage:Find("back_button"), function()
		arg0_13:emit(LevelUIConst.SWITCH_TO_MAP)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.retreatBtn, function()
		local var0_19 = arg0_13.contextData.chapterVO
		local var1_19 = arg0_13.contextData.map
		local var2_19 = "levelScene_whether_to_retreat"

		if var0_19:existOni() then
			var2_19 = "levelScene_oni_retreat"
		elseif var0_19:isPlayingWithBombEnemy() then
			var2_19 = "levelScene_bomb_retreat"
		elseif var0_19:getPlayType() == ChapterConst.TypeTransport and not var1_19:isSkirmish() then
			var2_19 = "levelScene_escort_retreat"
		elseif var1_19:isRemaster() then
			var2_19 = "archives_whether_to_retreat"
		end

		arg0_13:HandleShowMsgBox({
			content = i18n(var2_19),
			onYes = ChapterOpCommand.PrepareChapterRetreat
		})
	end, SFX_UI_WEIGHANCHOR_WITHDRAW)
	onButton(arg0_13, arg0_13.switchBtn, function()
		local var0_20 = arg0_13.contextData.chapterVO
		local var1_20 = var0_20:getNextValidIndex()

		if var1_20 > 0 then
			arg0_13:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpSwitch,
				id = var0_20.fleets[var1_20].id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_failed"))
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.autoBattleBtn, function()
		local var0_21 = getProxy(ChapterProxy)
		local var1_21 = var0_21:GetSkipPrecombat()

		var0_21:UpdateSkipPrecombat(not var1_21)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.showDetailBtn, function()
		arg0_13._showStrategyDetail = not arg0_13._showStrategyDetail and true

		arg0_13:updateStageStrategy()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.funcBtn, function()
		local var0_23 = arg0_13.contextData.chapterVO

		if not var0_23:inWartime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_time_out"))

			return
		end

		local var1_23 = var0_23.fleet
		local var2_23 = var1_23.line
		local var3_23 = var0_23:getChapterCell(var2_23.row, var2_23.column)
		local var4_23 = false

		local function var5_23(arg0_24)
			local var0_24 = arg0_24.attachmentId

			return pg.expedition_data_template[var0_24].dungeon_id > 0
		end

		if var0_23:existVisibleChampion(var2_23.row, var2_23.column) then
			var4_23 = true

			local var6_23 = var0_23:getChampion(var2_23.row, var2_23.column)

			if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
				arg0_13:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSkipBattle,
					id = var1_23.id
				})
			elseif not var5_23(var6_23) then
				arg0_13:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpPreClear,
					id = var1_23.id
				})
			elseif var0_23:IsSkipPrecombat() then
				arg0_13:emit(LevelMediator2.ON_START)
			else
				arg0_13:emit(LevelMediator2.ON_STAGE)
			end
		elseif var3_23.attachment == ChapterConst.AttachAmbush and var3_23.flag == ChapterConst.CellFlagAmbush then
			local var7_23

			var7_23 = coroutine.wrap(function()
				arg0_13:emit(LevelUIConst.DO_AMBUSH_WARNING, var7_23)
				coroutine.yield()
				arg0_13:emit(LevelUIConst.DISPLAY_AMBUSH_INFO, var7_23)
				coroutine.yield()
			end)

			var7_23()

			var4_23 = true
		elseif ChapterConst.IsEnemyAttach(var3_23.attachment) then
			if var3_23.flag == ChapterConst.CellFlagActive then
				var4_23 = true

				if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
					arg0_13:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSkipBattle,
						id = var1_23.id
					})
				elseif not var5_23(var3_23) then
					arg0_13:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpPreClear,
						id = var1_23.id
					})
				elseif var0_23:IsSkipPrecombat() then
					arg0_13:emit(LevelMediator2.ON_START)
				else
					arg0_13:emit(LevelMediator2.ON_STAGE)
				end
			end
		elseif var3_23.attachment == ChapterConst.AttachBox then
			if var3_23.flag == ChapterConst.CellFlagActive then
				var4_23 = true

				arg0_13:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBox,
					id = var1_23.id
				})
			end
		elseif var3_23.attachment == ChapterConst.AttachSupply and var3_23.attachmentId > 0 then
			var4_23 = true

			local var8_23, var9_23 = var0_23:getFleetAmmo(var0_23.fleet)

			if var9_23 < var8_23 then
				arg0_13:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSupply,
					id = var1_23.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_enough"))
			end
		elseif var3_23.attachment == ChapterConst.AttachStory then
			var4_23 = true

			local var10_23 = pg.map_event_template[var3_23.attachmentId].memory
			local var11_23 = pg.map_event_template[var3_23.attachmentId].gametip

			if var10_23 == 0 then
				return
			end

			local var12_23 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(var10_23)

			pg.ConnectionMgr.GetInstance():Send(11017, {
				story_id = var10_23
			}, 11018, function(arg0_26)
				return
			end)
			pg.NewStoryMgr.GetInstance():Play(var12_23, function(arg0_27, arg1_27)
				local var0_27 = arg1_27 or 1

				if var3_23.flag == ChapterConst.CellFlagActive then
					arg0_13:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpStory,
						id = var1_23.id,
						arg1 = var0_27
					})
				end

				if var11_23 ~= "" then
					local var1_27

					for iter0_27, iter1_27 in ipairs(pg.memory_template.all) do
						local var2_27 = pg.memory_template[iter1_27]

						if table.contains(var2_27.unlock_pre, var12_23) then
							var1_27 = var2_27.title
						end
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n(var11_23, var1_27))
				end
			end)
		end

		if not var4_23 then
			if var0_23:getRound() == ChapterConst.RoundEnemy then
				arg0_13:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpEnemyRound
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_click_to_move"))
			end
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.helpBtn, function()
		local var0_28 = arg0_13.contextData.chapterVO

		if var0_28 then
			if var0_28:existOni() then
				arg0_13:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_sphunt_help_tip")
				})
			elseif var0_28:isTypeDefence() then
				arg0_13:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("help_battle_defense")
				})
			elseif var0_28:isPlayingWithBombEnemy() then
				arg0_13:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_bomb_help_tip")
				})
			elseif pg.map_event_list[var0_28.id] and next(noEmptyStr(pg.map_event_list[var0_28.id].help_pictures) or {}) then
				local var1_28 = {
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

				for iter0_28, iter1_28 in pairs(pg.map_event_list[var0_28.id].help_pictures) do
					table.insert(var1_28, {
						icon = {
							path = "",
							atlas = iter1_28
						}
					})
				end

				arg0_13:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var1_28
				})
			else
				arg0_13:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = pg.gametip.help_level_ui.tip
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.airSupremacy, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_13, arg0_13.shengfuBtn, function()
		arg0_13:DisplayWinConditionPanel()
	end)
end

function var0_0.SetSeriesOperation(arg0_31, arg1_31)
	arg0_31.seriesOperation = arg1_31
end

function var0_0.SetGrid(arg0_32, arg1_32)
	arg0_32.grid = arg1_32
end

function var0_0.SetPlayer(arg0_33, arg1_33)
	return
end

function var0_0.SwitchToChapter(arg0_34, arg1_34)
	local var0_34 = findTF(arg0_34.topStage, "msg_panel/ambush")
	local var1_34 = findTF(arg0_34.rightStage, "target")
	local var2_34 = findTF(arg0_34.rightStage, "skip_events")

	setActive(var0_34, arg1_34:existAmbush())
	setActive(arg0_34.airSupremacy, OPEN_AIR_DOMINANCE and arg1_34:getConfig("air_dominance") > 0)

	local var3_34 = arg1_34:isLoop()

	setActive(arg0_34.autoBattleBtn, var3_34)

	if var3_34 then
		arg0_34:UpdateSkipPreCombatMark()
		arg0_34:UpdateAutoFightPanel()
		arg0_34:UpdateAutoFightMark()
	end

	arg0_34.achieveOriginalY = -240

	setText(var2_34:Find("Label"), i18n("map_event_skip"))

	local var4_34 = "skip_events_on_" .. arg1_34.id

	if arg1_34:getConfig("event_skip") == 1 then
		if arg1_34.progress > 0 or arg1_34.defeatCount > 0 or arg1_34.passCount > 0 then
			setActive(var2_34, true)

			var1_34.anchoredPosition = Vector2.New(var1_34.anchoredPosition.x, arg0_34.achieveOriginalY - 40)
			GetComponent(var2_34, typeof(Toggle)).isOn = PlayerPrefs.GetInt(var4_34, 1) == 1

			onToggle(arg0_34, var2_34, function(arg0_35)
				PlayerPrefs.SetInt(var4_34, arg0_35 and 1 or 0)
			end)
		else
			setActive(var2_34, false)

			if not PlayerPrefs.HasKey(var4_34) then
				PlayerPrefs.SetInt(var4_34, 0)
			end
		end
	else
		setActive(var2_34, false)

		var1_34.anchoredPosition = Vector2.New(var1_34.anchoredPosition.x, arg0_34.achieveOriginalY)
	end

	setActive(var1_34, arg1_34:existAchieve())
	setActive(arg0_34.retreatBtn, true)
	arg0_34.seriesOperation()
end

function var0_0.SwitchToMap(arg0_36)
	arg0_36:DestroyAutoFightPanel()
end

function var0_0.UpdateSkipPreCombatMark(arg0_37)
	local var0_37 = getProxy(ChapterProxy):GetSkipPrecombat() and "auto_battle_on" or "auto_battle_off"

	arg0_37.loader:GetOffSpriteRequest(arg0_37.autoBattleBtn)
	arg0_37.loader:GetSprite("ui/levelstageview_atlas", var0_37, arg0_37.autoBattleBtn, true)
end

function var0_0.updateStageInfo(arg0_38)
	local var0_38 = arg0_38.contextData.chapterVO
	local var1_38 = findTF(arg0_38.topStage, "timer")
	local var2_38 = findTF(arg0_38.topStage, "unlimit")

	setWidgetText(var1_38, "--:--:--")

	if arg0_38.stageTimer then
		arg0_38.stageTimer:Stop()
	end

	if var0_38:getRemainTime() > var0_38:getConfig("time") or var0_38:getConfig("time") >= 8640000 then
		setActive(var1_38, false)
		setActive(var2_38, true)
	else
		setActive(var1_38, true)
		setActive(var2_38, false)

		arg0_38.stageTimer = Timer.New(function()
			if IsNil(var1_38) then
				return
			end

			local var0_39 = var0_38:getRemainTime()

			setWidgetText(var1_38, pg.TimeMgr.GetInstance():DescCDTime(var0_39))
		end, 1, -1)

		arg0_38.stageTimer:Start()
		arg0_38.stageTimer.func()
	end
end

function var0_0.updateAmbushRate(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.contextData.chapterVO

	if not var0_40:existAmbush() then
		return
	end

	local var1_40 = var0_40.fleet
	local var2_40 = var1_40:getInvestSums()
	local var3_40 = findTF(arg0_40.topStage, "msg_panel/ambush/label1")
	local var4_40 = findTF(arg0_40.topStage, "msg_panel/ambush/label2")
	local var5_40 = findTF(arg0_40.topStage, "msg_panel/ambush/value1")
	local var6_40 = findTF(arg0_40.topStage, "msg_panel/ambush/value2")

	setText(var3_40, i18n("level_scene_title_word_1"))
	setText(var5_40, math.floor(var2_40))
	setText(var4_40, i18n("level_scene_title_word_2"))

	if not var0_40.activateAmbush then
		setText(var6_40, i18n("ambush_display_none"))
		setTextColor(var6_40, Color.New(0.4, 0.4, 0.4))
	else
		local var7_40 = var0_40:getAmbushRate(var1_40, arg1_40)
		local var8_40, var9_40 = ChapterConst.GetAmbushDisplay((not arg2_40 or not var0_40:existEnemy(ChapterConst.SubjectPlayer, arg1_40.row, arg1_40.column)) and var7_40)

		setText(var6_40, var8_40)
		setTextColor(var6_40, var9_40)
	end
end

function var0_0.updateStageAchieve(arg0_41)
	local var0_41 = arg0_41.contextData.chapterVO

	if not var0_41:existAchieve() then
		return
	end

	local var1_41 = var0_41.achieves
	local var2_41 = findTF(arg0_41.rightStage, "target")

	setActive(var2_41, true)

	local var3_41 = findTF(var2_41, "detail")
	local var4_41 = findTF(var3_41, "achieve")
	local var5_41 = findTF(var3_41, "achieves")
	local var6_41 = findTF(var3_41, "click")
	local var7_41 = findTF(var2_41, "collapse")
	local var8_41 = findTF(var7_41, "star")
	local var9_41 = findTF(var7_41, "stars")

	setActive(var4_41, false)
	setActive(var8_41, false)
	removeAllChildren(var5_41)
	removeAllChildren(var9_41)

	for iter0_41, iter1_41 in ipairs(var1_41) do
		local var10_41 = cloneTplTo(var4_41, var5_41)
		local var11_41 = ChapterConst.IsAchieved(iter1_41)

		setActive(findTF(var10_41, "star"), var11_41)

		local var12_41 = findTF(var10_41, "desc")

		setText(var12_41, ChapterConst.GetAchieveDesc(iter1_41.type, var0_41))
		setTextColor(var12_41, var11_41 and Color.yellow or Color.white)

		cloneTplTo(var8_41, var9_41):GetComponent(typeof(Image)).enabled = var11_41
	end

	onButton(arg0_41, var6_41, function()
		shiftPanel(var3_41, var3_41.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_41, 0, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_41, var7_41, function()
		shiftPanel(var3_41, 30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var7_41, var7_41.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)

	if not arg0_41.isAchieveFirstInit then
		arg0_41.isAchieveFirstInit = true

		triggerButton(var6_41)
	end
end

function var0_0.updateStageBarrier(arg0_44)
	local var0_44 = arg0_44.contextData.chapterVO

	setActive(arg0_44.panelBarrier, var0_44:existOni())

	if not var0_44:existOni() then
		return
	end

	local var1_44 = arg0_44.panelBarrier:Find("btn_barrier")

	setText(var1_44:Find("nums"), var0_44.modelCount)
	onButton(arg0_44, var1_44, function()
		if arg0_44.grid.quadState == ChapterConst.QuadStateBarrierSetting then
			arg0_44.grid:updateQuadCells(ChapterConst.QuadStateNormal)

			return
		end

		arg0_44.grid:updateQuadCells(ChapterConst.QuadStateBarrierSetting)
	end, SFX_PANEL)
end

function var0_0.updateBombPanel(arg0_46, arg1_46)
	local var0_46 = arg0_46.contextData.chapterVO

	setActive(arg0_46.bombPanel, var0_46:isPlayingWithBombEnemy())

	if var0_46:isPlayingWithBombEnemy() then
		setText(arg0_46.bombPanel:Find("tx_step"), var0_46:getBombChapterInfo().action_times - math.floor(var0_46.roundIndex / 2))

		local var1_46 = arg0_46.bombPanel:Find("tx_score")
		local var2_46 = tonumber(getText(var1_46))
		local var3_46 = var0_46.modelCount

		LeanTween.cancel(go(var1_46))

		if arg1_46 and var2_46 ~= var3_46 then
			LeanTween.scale(go(var1_46), Vector3(1.5, 1.5, 1), 0.2)

			local var4_46 = (var3_46 - var2_46) * 0.1

			LeanTween.value(go(var1_46), var2_46, var3_46, var4_46):setOnUpdate(System.Action_float(function(arg0_47)
				setText(var1_46, math.floor(arg0_47))
			end)):setOnComplete(System.Action(function()
				setText(var1_46, var3_46)
			end)):setEase(LeanTweenType.easeInOutSine):setDelay(0.2)
			LeanTween.scale(go(var1_46), Vector3.one, 0.3):setDelay(1 + var4_46)
		else
			var1_46.localScale = Vector3.one

			setText(var1_46, var3_46)
		end
	end
end

function var0_0.updateFleetBuff(arg0_49)
	arg0_49:downloadStageRes(function()
		arg0_49:updateFleetBuffAfterDownload()
	end)
end

function var0_0.updateFleetBuffAfterDownload(arg0_51)
	local var0_51 = arg0_51.contextData.chapterVO
	local var1_51 = var0_51.fleet
	local var2_51 = var0_51:GetShowingStrategies()

	if var0_51:getChapterSupportFleet() and not var0_51:IsSupportSubmarineStage() then
		table.insert(var2_51, ChapterConst.StrategyAirSupportFriendly)
	end

	local var3_51 = {}
	local var4_51 = var0_51:GetSubmarineFleet()

	if var4_51 then
		local var5_51 = _.filter(var4_51:getStrategies(), function(arg0_52)
			return pg.strategy_data_template[arg0_52.id].type == ChapterConst.StgTypePassive and arg0_52.count > 0
		end)

		if var5_51 and #var5_51 > 0 then
			_.each(var5_51, function(arg0_53)
				table.insert(var3_51, {
					id = arg0_53.id,
					count = arg0_53.count
				})
			end)
		end
	end

	local var6_51 = underscore.filter(var0_51:GetWeather(), function(arg0_54)
		local var0_54 = pg.weather_data_template[arg0_54]

		return noEmptyStr(var0_54.buff_icon)
	end)
	local var7_51 = 0

	if var0_51:ExistDivingChampion() then
		var7_51 = 1
	end

	local var8_51 = _.map(_.values(var1_51:getCommanders()), function(arg0_55)
		return arg0_55:getSkills()[1]
	end)
	local var9_51 = findTF(arg0_51.topStage, "icon_list/fleet_buffs")
	local var10_51 = UIItemList.New(var9_51, var9_51:GetChild(0))

	var10_51:make(function(arg0_56, arg1_56, arg2_56)
		setActive(findTF(arg2_56, "frame"), false)
		setActive(findTF(arg2_56, "Text"), false)
		setActive(findTF(arg2_56, "times"), false)

		if arg0_56 == UIItemList.EventUpdate then
			local var0_56 = GetComponent(arg2_56, typeof(LayoutElement))

			var0_56.preferredWidth = 64
			var0_56.preferredHeight = 64

			if arg1_56 + 1 <= #var2_51 then
				local var1_56 = var2_51[arg1_56 + 1]
				local var2_56 = pg.strategy_data_template[var1_56]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_56.icon, "", arg2_56)

				local var3_56

				if var2_56.type == ChapterConst.StgTypeBindFleetPassive then
					var3_56 = var1_51:GetStrategyCount(var1_56)

					setActive(findTF(arg2_56, "times"), true)
					setText(findTF(arg2_56, "times"), var3_56)
				end

				local var4_56 = var2_56.iconSize

				if var4_56 ~= "" then
					var0_56.preferredWidth = var4_56[1]
					var0_56.preferredHeight = var4_56[2]
				end

				onButton(arg0_51, arg2_56, function()
					arg0_51:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var2_56.id,
							cfg = var2_56,
							count = var3_56
						}
					})
				end, SFX_PANEL)

				return
			end

			arg1_56 = arg1_56 - #var2_51

			if arg1_56 + 1 <= #var6_51 then
				local var5_56 = pg.weather_data_template[var6_51[arg1_56 + 1]]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var5_56.buff_icon, "", arg2_56)
				onButton(arg0_51, arg2_56, function()
					arg0_51:HandleShowMsgBox({
						hideNo = true,
						type = MSGBOX_TYPE_DROP_ITEM,
						name = var5_56.name,
						content = var5_56.buff_desc,
						iconPath = {
							"strategyicon/" .. var5_56.buff_icon
						},
						yesText = pg.MsgboxMgr.TEXT_CONFIRM
					})
				end, SFX_PANEL)

				return
			end

			arg1_56 = arg1_56 - #var6_51

			if arg1_56 + 1 <= #var3_51 then
				local var6_56 = var3_51[arg1_56 + 1]
				local var7_56 = pg.strategy_data_template[var6_56.id]

				GetImageSpriteFromAtlasAsync("strategyicon/" .. var7_56.icon, "", arg2_56)
				setActive(findTF(arg2_56, "times"), true)
				setText(findTF(arg2_56, "times"), var6_56.count)
				onButton(arg0_51, arg2_56, function()
					arg0_51:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = var7_56.id,
							cfg = var7_56
						},
						extendDesc = string.format(i18n("word_rest_times"), var6_56.count)
					})
				end, SFX_PANEL)

				return
			end

			arg1_56 = arg1_56 - #var3_51

			if arg1_56 + 1 <= var7_51 then
				GetImageSpriteFromAtlasAsync("strategyicon/submarine_approach", "", arg2_56)
				onButton(arg0_51, arg2_56, function()
					arg0_51:HandleShowMsgBox({
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

			arg1_56 = arg1_56 - var7_51

			local var8_56 = var8_51[arg1_56 + 1]

			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var8_56:getConfig("icon"), "", arg2_56)
			setText(findTF(arg2_56, "Text"), "Lv." .. var8_56:getConfig("lv"))
			setActive(findTF(arg2_56, "Text"), true)
			setActive(findTF(arg2_56, "frame"), true)
			onButton(arg0_51, arg2_56, function()
				arg0_51:emit(LevelMediator2.ON_COMMANDER_SKILL, var8_56)
			end, SFX_PANEL)
		end
	end)
	var10_51:align(#var2_51 + #var3_51 + #var6_51 + var7_51 + #var8_51)

	if OPEN_AIR_DOMINANCE and var0_51:getConfig("air_dominance") > 0 then
		arg0_51:updateAirDominance()
	end

	arg0_51:updateEnemyCount()
	arg0_51:updateChapterBuff()
end

function var0_0.updateEnemyCount(arg0_62)
	local var0_62 = arg0_62.contextData.chapterVO
	local var1_62 = findTF(arg0_62.topStage, "icon_list/enemy_count")
	local var2_62 = tobool(underscore.detect(var0_62.achieves, function(arg0_63)
		return (arg0_63.type == ChapterConst.AchieveType3 or arg0_63.type == ChapterConst.AchieveType6) and not ChapterConst.IsAchieved(arg0_63)
	end))

	setActive(var1_62, var2_62)

	if var2_62 then
		local var3_62 = var0_62:getDisplayEnemyCount()

		setText(var1_62:Find("Text"), var3_62)
		GetImageSpriteFromAtlasAsync("enemycount", var3_62 > 0 and "danger" or "safe", var1_62)
		onButton(arg0_62, var1_62, function()
			if var3_62 > 0 then
				arg0_62:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_62),
					iconPath = {
						"enemycount",
						"danger"
					},
					yesText = i18n("star_require_enemy_check"),
					onYes = function()
						local var0_65 = var0_62:getNearestEnemyCell()

						arg0_62.grid:focusOnCell(var0_65)

						local var1_65 = arg0_62.grid:GetEnemyCellView(var0_65)

						if var1_65 and var1_65.TweenShining then
							var1_65:TweenShining(2)
						end
					end
				})
			else
				arg0_62:HandleShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_DROP_ITEM,
					name = i18n("star_require_enemy_title"),
					content = i18n("star_require_enemy_text", var3_62),
					iconPath = {
						"enemycount",
						"safe"
					}
				})
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateChapterBuff(arg0_66)
	local var0_66 = arg0_66.contextData.chapterVO
	local var1_66 = findTF(arg0_66.topStage, "icon_list/chapter_buff")
	local var2_66 = var0_66:hasMitigation()

	SetActive(var1_66, var2_66)

	if var2_66 then
		local var3_66 = var0_66:getRiskLevel()

		GetImageSpriteFromAtlasAsync("passstate", var3_66 .. "_icon", var1_66)
		onButton(arg0_66, var1_66, function()
			if not var0_66:hasMitigation() then
				return
			end

			arg0_66:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = var0_66:getChapterState(),
				iconPath = {
					"passstate",
					var3_66 .. "_icon"
				},
				content = i18n("level_risk_level_mitigation_rate", var0_66:getRemainPassCount(), var0_66:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateAirDominance(arg0_68)
	local var0_68, var1_68, var2_68 = arg0_68.contextData.chapterVO:getAirDominanceValue()

	if not var2_68 or var2_68 ~= var1_68 then
		arg0_68.contextData.chapterVO:setAirDominanceStatus(var1_68)
		getProxy(ChapterProxy):updateChapter(arg0_68.contextData.chapterVO)
	end

	arg0_68.isChange = var2_68 and (var1_68 == 0 and 3 or var1_68) - (var2_68 == 0 and 3 or var2_68)

	arg0_68:updateAirDominanceTitle(var0_68, var1_68, arg0_68.isChange or 0)
end

function var0_0.updateAirDominanceTitle(arg0_69, arg1_69, arg2_69, arg3_69)
	local var0_69 = findTF(arg0_69.airSupremacy, "label1")
	local var1_69 = findTF(arg0_69.airSupremacy, "label2")
	local var2_69 = findTF(arg0_69.airSupremacy, "value1")
	local var3_69 = findTF(arg0_69.airSupremacy, "value2")
	local var4_69 = findTF(arg0_69.airSupremacy, "up")
	local var5_69 = findTF(arg0_69.airSupremacy, "down")

	setText(var0_69, i18n("level_scene_title_word_3"))
	setText(var1_69, i18n("level_scene_title_word_4"))
	setText(var2_69, math.floor(arg1_69))
	setActive(var4_69, false)
	setActive(var5_69, false)

	if arg3_69 ~= 0 then
		if LeanTween.isTweening(go(var3_69)) then
			LeanTween.cancel(go(var3_69))
		end

		LeanTween.value(go(var3_69), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_70)
			setTextAlpha(var3_69, arg0_70)
		end)):setOnComplete(System.Action(function()
			setText(var3_69, ChapterConst.AirDominance[arg2_69].name)
			setTextColor(var3_69, ChapterConst.AirDominance[arg2_69].color)
			LeanTween.value(go(var3_69), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_72)
				setTextAlpha(var3_69, arg0_72)
			end))
		end))

		local function var6_69(arg0_73)
			setActive(arg0_73, false)
		end

		var4_69:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_69)
		var5_69:GetComponent(typeof(DftAniEvent)):SetEndEvent(var6_69)
		setActive(var4_69, arg3_69 > 0)
		setActive(var5_69, arg3_69 < 0)
	else
		setText(var3_69, ChapterConst.AirDominance[arg2_69].name)
		setTextColor(var3_69, ChapterConst.AirDominance[arg2_69].color)
	end
end

function var0_0.UpdateDefenseStatus(arg0_74)
	local var0_74 = arg0_74.contextData.chapterVO
	local var1_74 = var0_74:getPlayType() == ChapterConst.TypeDefence
	local var2_74 = findTF(arg0_74.bottomStage, "Normal/shengfu")

	setActive(var2_74, var1_74)

	if not var1_74 then
		return
	end

	local var3_74 = findTF(var2_74, "hp"):GetComponent(typeof(Text))
	local var4_74 = var0_74.id
	local var5_74 = pg.chapter_defense[var4_74]

	var3_74.text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(var0_74.BaseHP) .. "</color>", var5_74.port_hp)
end

function var0_0.DisplayWinConditionPanel(arg0_75)
	if not arg0_75.winCondPanel then
		arg0_75.winCondPanel = WinConditionDisplayPanel.New(arg0_75._tf.parent, arg0_75.event, arg0_75.contextData)

		arg0_75.winCondPanel:Load()
	end

	arg0_75.winCondPanel:ActionInvoke("Enter", arg0_75.contextData.chapterVO)
end

function var0_0.DestroyWinConditionPanel(arg0_76)
	if not arg0_76.winCondPanel then
		return
	end

	arg0_76.winCondPanel:Destroy()

	arg0_76.winCondPanel = nil
end

function var0_0.UpdateComboPanel(arg0_77)
	local var0_77 = arg0_77.contextData.chapterVO
	local var1_77 = pg.chapter_pop_template[var0_77.id]

	if var1_77 and var1_77.combo_on then
		local var2_77, var3_77 = arg0_77:GetSubView("LevelStageComboPanel")

		if var3_77 then
			var2_77:Load()
			var2_77.buffer:SetParent(arg0_77.leftStage, false)
		end

		local var4_77 = getProxy(ChapterProxy):GetComboHistory(var0_77.id)

		var2_77.buffer:UpdateView(var4_77 or var0_77)
		var2_77.buffer:UpdateViewAnimated(var0_77)
	end
end

function var0_0.UpdateDOALinkFeverPanel(arg0_78, arg1_78)
	local var0_78 = arg0_78.contextData.chapterVO
	local var1_78 = var0_78:GetBindActID()
	local var2_78 = var0_78:getConfig("levelstage_bar")

	if not var2_78 or var2_78 == "" then
		existCall(arg1_78)

		return
	end

	local var3_78, var4_78 = arg0_78:GetSubView(var2_78)

	if var4_78 then
		var3_78:Load()
		var3_78.buffer:SetParent(arg0_78._tf, false)
	end

	var3_78.buffer:UpdateView(var0_78, arg1_78)
end

local var2_0 = Vector2(396, 128)
local var3_0 = Vector2(128, 128)

function var0_0.updateStageStrategy(arg0_79)
	arg0_79:downloadStageRes(function()
		arg0_79:updateStageStrategyAfterDownload()
	end)
end

function var0_0.updateStageStrategyAfterDownload(arg0_81)
	local var0_81 = arg0_81.contextData.chapterVO
	local var1_81 = findTF(arg0_81.rightStage, "event")
	local var2_81 = findTF(var1_81, "detail")
	local var3_81 = findTF(var2_81, "click")
	local var4_81 = findTF(var2_81, "items")

	var4_81:GetComponent(typeof(GridLayoutGroup)).cellSize = arg0_81._showStrategyDetail and var2_0 or var3_0

	local var5_81 = findTF(var4_81, "item")
	local var6_81 = findTF(var1_81, "collapse")

	setActive(var5_81, false)

	local var7_81 = var0_81:GetInteractableStrategies()
	local var8_81

	local function var9_81(arg0_82, arg1_82, arg2_82)
		if arg0_82 ~= UIItemList.EventUpdate then
			return
		end

		local var0_82 = arg2_82:Find("detail")

		setActive(var0_82, arg0_81._showStrategyDetail)

		local var1_82 = arg2_82:Find("icon")
		local var2_82 = var7_81[arg1_82 + 1]
		local var3_82
		local var4_82

		if var2_82.id == ChapterConst.StrategyHuntingRange then
			var3_82 = ChapterConst.StgTypeConst
			var4_82 = arg0_81.contextData.huntingRangeVisibility % 2 == 1 and "range_invisible" or "range_visible"

			setText(var0_82, i18n("help_sub_limits"))
		elseif var2_82.id == ChapterConst.StrategySubAutoAttack then
			var3_82 = ChapterConst.StgTypeConst
			var4_82 = var0_81.subAutoAttack == 0 and "sub_dont_auto_attack" or "sub_auto_attack"

			setText(var0_82, i18n("help_sub_display"))
		else
			local var5_82 = pg.strategy_data_template[var2_82.id]

			var3_82 = var5_82.type
			var4_82 = var5_82.icon

			setText(var0_82, var5_82.desc)
		end

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_82, "", var1_82:Find("icon"))
		onButton(arg0_81, var1_82, function()
			if var2_82.id == ChapterConst.StrategyHuntingRange then
				arg0_81.grid:toggleHuntingRange()
				var9_81(arg0_82, arg1_82, arg2_82)
			elseif var2_82.id == ChapterConst.StrategySubAutoAttack then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ai_change_" .. 1 - var0_81.subAutoAttack + 1))
				arg0_81:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubState,
					arg1 = 1 - var0_81.subAutoAttack
				})
			elseif var2_82.id == ChapterConst.StrategyExchange then
				local var0_83 = var0_81:getNextValidIndex()

				if var0_83 > 0 and var2_82.count > 0 then
					local var1_83 = var0_81.fleet

					arg0_81:HandleShowMsgBox({
						content = i18n("levelScene_who_to_exchange"),
						onYes = function()
							arg0_81:emit(LevelMediator2.ON_OP, {
								type = ChapterConst.OpStrategy,
								id = var1_83.id,
								arg1 = ChapterConst.StrategyExchange,
								arg2 = var0_81.fleets[var0_83].id
							})
						end
					})
				end
			elseif var2_82.id == ChapterConst.StrategySubTeleport then
				arg0_81:SwitchSubTeleportBottomStage()
				arg0_81:SwitchBottomStagePanel(true)
				arg0_81.grid:ShowStaticHuntingRange()
				arg0_81.grid:PrepareSubTeleport()
				arg0_81.grid:updateQuadCells(ChapterConst.QuadStateTeleportSub)
			elseif var2_82.id == ChapterConst.StrategyMissileStrike then
				if not var0_81.fleet:canUseStrategy(var2_82) then
					return
				end

				arg0_81:SwitchMissileBottomStagePanel()
				arg0_81:SwitchBottomStagePanel(true)
				arg0_81.grid:updateQuadCells(ChapterConst.QuadStateMissileStrike)
			elseif var2_82.id == ChapterConst.StrategyAirSupport then
				if not var0_81:getChapterSupportFleet():canUseStrategy(var2_82) then
					return
				end

				arg0_81:SwitchAirSupportBottomStagePanel()
				arg0_81:SwitchBottomStagePanel(true)
				arg0_81.grid:updateQuadCells(ChapterConst.QuadStateAirSuport)
			elseif var2_82.id == ChapterConst.StrategyExpel then
				if not var0_81:getChapterSupportFleet():canUseStrategy(var2_82) then
					return
				end

				arg0_81:SwitchAirExpelBottomStagePanel()
				arg0_81:SwitchBottomStagePanel(true)
				arg0_81.grid:updateQuadCells(ChapterConst.QuadStateExpel)
			elseif var3_82 == ChapterConst.StgTypeForm then
				local var2_83 = var0_81.fleet
				local var3_83 = table.indexof(ChapterConst.StrategyForms, var2_82.id)

				arg0_81:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpStrategy,
					id = var2_83.id,
					arg1 = ChapterConst.StrategyForms[var3_83 % #ChapterConst.StrategyForms + 1]
				})
			else
				arg0_81:emit(LevelUIConst.DISPLAY_STRATEGY_INFO, var2_82)
			end
		end, SFX_PANEL)

		if var3_82 == ChapterConst.StgTypeForm then
			setText(var1_82:Find("nums"), "")
			setActive(var1_82:Find("mask"), false)
			setActive(var1_82:Find("selected"), true)
		else
			setText(var1_82:Find("nums"), var2_82.count or "")
			setActive(var1_82:Find("mask"), var2_82.count == 0)
			setActive(var1_82:Find("selected"), false)
		end
	end

	UIItemList.StaticAlign(var4_81, var5_81, #var7_81, var9_81)
	onButton(arg0_81, var3_81, function()
		shiftPanel(var2_81, var2_81.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_81, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(arg0_81, var6_81, function()
		shiftPanel(var2_81, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(var6_81, var6_81.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

function var0_0.GetSubView(arg0_87, arg1_87)
	if arg0_87.attachSubViews[arg1_87] then
		return arg0_87.attachSubViews[arg1_87]
	end

	local var0_87 = _G[arg1_87].New(arg0_87)

	assert(var0_87, "cant't find subview " .. (arg1_87 or "nil"))

	arg0_87.attachSubViews[arg1_87] = var0_87

	return var0_87, true
end

function var0_0.RemoveSubView(arg0_88, arg1_88)
	if not arg0_88.attachSubViews[arg1_88] then
		return false
	end

	arg0_88.attachSubViews[arg1_88]:Destroy()

	arg0_88.attachSubViews[arg1_88] = nil

	return true
end

function var0_0.ClearSubViews(arg0_89)
	for iter0_89, iter1_89 in pairs(arg0_89.attachSubViews) do
		iter1_89:Destroy()
	end

	table.clear(arg0_89.attachSubViews)
end

function var0_0.updateStageFleet(arg0_90)
	local var0_90 = arg0_90.contextData.chapterVO
	local var1_90 = findTF(arg0_90.leftStage, "fleet")
	local var2_90 = findTF(var1_90, "shiptpl")
	local var3_90 = arg0_90.topStage:Find("msg_panel/fleet_info/number")

	setActive(var2_90, false)
	setText(var3_90, var0_90.fleet.id)

	local var4_90 = var0_90.fleet:getShips(true)

	local function var5_90(arg0_91, arg1_91)
		local var0_91 = UIItemList.New(arg0_91, var2_90)

		var0_91:make(function(arg0_92, arg1_92, arg2_92)
			if arg0_92 == UIItemList.EventUpdate then
				local var0_92 = arg1_91[arg1_92 + 1]

				updateShip(arg2_92, var0_92)

				local var1_92 = var0_92.hpRant
				local var2_92 = var0_92:getShipProperties()
				local var3_92 = math.floor((var0_92.hpChange or 0) / 10000 * var2_92[AttributeType.Durability])
				local var4_92 = findTF(arg2_92, "HP_POP")

				setActive(var4_92, true)
				setActive(findTF(var4_92, "heal"), false)
				setActive(findTF(var4_92, "normal"), false)

				local function var5_92(arg0_93, arg1_93)
					setActive(arg0_93, true)
					setText(findTF(arg0_93, "text"), arg1_93)
					setTextAlpha(findTF(arg0_93, "text"), 0)
					LeanTween.moveY(arg0_93, 60, 1)
					LeanTween.textAlpha(findTF(arg0_93, "text"), 1, 0.3)
					LeanTween.textAlpha(findTF(arg0_93, "text"), 0, 0.5):setDelay(0.7):setOnComplete(System.Action(function()
						arg0_93.localPosition = Vector3(0, 0, 0)
					end))
				end

				if var3_92 > 0 then
					var5_92(findTF(var4_92, "heal"), var3_92)
				elseif var3_92 < 0 then
					LeanTween.delayedCall(0.6, System.Action(function()
						local var0_95 = arg2_92.transform.localPosition.x

						LeanTween.moveX(arg2_92, var0_95, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
						LeanTween.alpha(findTF(arg2_92, "red"), 0.5, 0.4)
						LeanTween.alpha(findTF(arg2_92, "red"), 0, 0.4):setDelay(0.4)
						var5_92(findTF(var4_92, "normal"), var3_92)
					end))
				end

				local var6_92 = findTF(arg2_92, "blood")
				local var7_92 = findTF(arg2_92, "blood/fillarea/green")
				local var8_92 = findTF(arg2_92, "blood/fillarea/red")
				local var9_92 = var1_92 < ChapterConst.HpGreen
				local var10_92 = var1_92 == 0

				setActive(var7_92, not var9_92)
				setActive(var8_92, var9_92)

				var6_92:GetComponent(typeof(Slider)).fillRect = var9_92 and var8_92 or var7_92

				setSlider(var6_92, 0, 10000, var1_92)
				setActive(findTF(arg2_92, "repairmask"), var9_92)
				setActive(findTF(arg2_92, "repairmask/broken"), var10_92)
				onButton(arg0_90, arg2_92:Find("repairmask"), function()
					arg0_90:emit(LevelUIConst.DISPLAY_REPAIR_WINDOW, var0_92)
				end, SFX_PANEL)

				local var11_92 = findTF(arg2_92, "repairmask/icon").gameObject

				if not var9_92 then
					LeanTween.cancel(var11_92)
					setImageAlpha(var11_92, 1)
				end

				if var9_92 and not LeanTween.isTweening(var11_92) then
					LeanTween.alpha(rtf(var11_92), 0, 2):setLoopPingPong()
				end

				local var12_92 = GetOrAddComponent(arg2_92, "UILongPressTrigger").onLongPressed

				pg.DelegateInfo.Add(arg0_90, var12_92)
				var12_92:RemoveAllListeners()
				var12_92:AddListener(function()
					arg0_90:emit(LevelMediator2.ON_STAGE_SHIPINFO, {
						shipId = var0_92.id,
						shipVOs = var4_90
					})
				end)
			end
		end)
		var0_91:align(#arg1_91)
	end

	var5_90(var1_90:Find("main"), var0_90.fleet:getShipsByTeam(TeamType.Main, true))
	var5_90(var1_90:Find("vanguard"), var0_90.fleet:getShipsByTeam(TeamType.Vanguard, true))
	var0_90.fleet:clearShipHpChange()
end

function var0_0.updateSupportFleet(arg0_98)
	local var0_98 = arg0_98.contextData.chapterVO:getChapterSupportFleet()
	local var1_98 = findTF(arg0_98.leftStage, "support_fleet")

	setActive(var1_98, tobool(var0_98))

	if var0_98 then
		local var2_98 = findTF(var1_98, "show/ship_container")

		removeAllChildren(var2_98)

		local var3_98 = findTF(var1_98, "show/shiptpl")
		local var4_98 = var0_98:getShips()

		for iter0_98, iter1_98 in pairs(var4_98) do
			local var5_98 = cloneTplTo(var3_98, var2_98)

			setActive(var5_98, true)
			updateShip(var5_98, iter1_98)
		end

		local var6_98 = var1_98:Find("hide")
		local var7_98 = var1_98:Find("show")

		local function var8_98(arg0_99)
			setActive(var6_98, true)
			setActive(var7_98, true)
			shiftPanel(var7_98, nil, arg0_99 and -325.1 or -855, 0.3, 0, true, nil, LeanTweenType.easeOutSine, function()
				setActive(var6_98, not arg0_99)
				setActive(var7_98, arg0_99)
			end)
			shiftPanel(var6_98, nil, arg0_99 and -1017 or -563.97, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		end

		onButton(arg0_98, var6_98, function()
			var8_98(true)
		end, SFX_PANEL)
		onButton(arg0_98, var7_98, function()
			var8_98(false)
		end)
	end
end

function var0_0.ShiftStagePanelIn(arg0_103, arg1_103)
	shiftPanel(arg0_103.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_103)
	arg0_103:ShiftBottomStage(true)
	shiftPanel(arg0_103.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_103.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftStagePanelOut(arg0_104, arg1_104)
	shiftPanel(arg0_104.topStage, 0, arg0_104.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, arg1_104)
	arg0_104:ShiftBottomStage(false)
	shiftPanel(arg0_104.leftStage, -arg0_104.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(arg0_104.rightStage, arg0_104.rightStage.rect.width + 300, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.ShiftBottomStage(arg0_105, arg1_105)
	arg1_105 = not arg0_105.bottomStageInactive and arg1_105

	local var0_105 = arg1_105 and 0 or -arg0_105.bottomStage.rect.height

	shiftPanel(arg0_105.bottomStage, 0, var0_105, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

function var0_0.SwitchSubTeleportBottomStage(arg0_106)
	setActive(arg0_106.missileStrikeRole, true)
	setText(findTF(arg0_106.missileStrikeRole, "confirm_button/Text"), i18n("levelscene_deploy_submarine"))
	setText(findTF(arg0_106.missileStrikeRole, "cancel_button/Text"), i18n("levelscene_deploy_submarine_cancel"))
	onButton(arg0_106, arg0_106.missileStrikeRole:Find("confirm_button"), function()
		local var0_107 = arg0_106.contextData.chapterVO
		local var1_107 = var0_107:GetSubmarineFleet()
		local var2_107 = var1_107.startPos
		local var3_107 = arg0_106.grid.subTeleportTargetLine

		if not var3_107 then
			return
		end

		local var4_107 = var0_107:findPath(nil, var2_107, var3_107)
		local var5_107 = arg0_106.grid:TransformLine2PlanePos(var2_107)
		local var6_107 = arg0_106.grid:TransformLine2PlanePos(var3_107)
		local var7_107 = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #var1_107:getShips(false) * var4_107 - 1e-05)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", var5_107, var6_107, var4_107, var7_107),
			onYes = function()
				arg0_106:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = var1_107.id,
					arg1 = var3_107.row,
					arg2 = var3_107.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_106, arg0_106.missileStrikeRole:Find("cancel_button"), function()
		arg0_106:SwitchBottomStagePanel(false)
		arg0_106.grid:TurnOffSubTeleport()
		arg0_106.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchMissileBottomStagePanel(arg0_110)
	setActive(arg0_110.missileStrikeRole, true)
	setText(findTF(arg0_110.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_110.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_110, arg0_110.missileStrikeRole:Find("confirm_button"), function()
		local var0_111 = arg0_110.grid.missileStrikeTargetLine

		if not var0_111 then
			return
		end

		local var1_111 = arg0_110.contextData.chapterVO.fleet

		;(function()
			arg0_110:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_111.id,
				arg1 = ChapterConst.StrategyMissileStrike,
				arg2 = var0_111.row,
				arg3 = var0_111.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_110, arg0_110.missileStrikeRole:Find("cancel_button"), function()
		arg0_110:SwitchBottomStagePanel(false)
		arg0_110.grid:HideMissileAimingMark()
		arg0_110.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirSupportBottomStagePanel(arg0_114)
	setActive(arg0_114.missileStrikeRole, true)
	setText(findTF(arg0_114.missileStrikeRole, "confirm_button/Text"), i18n("missile_attack_area_confirm"))
	setText(findTF(arg0_114.missileStrikeRole, "cancel_button/Text"), i18n("missile_attack_area_cancel"))
	onButton(arg0_114, arg0_114.missileStrikeRole:Find("confirm_button"), function()
		local var0_115 = arg0_114.grid.missileStrikeTargetLine

		if not var0_115 then
			return
		end

		local var1_115 = arg0_114.contextData.chapterVO:getChapterSupportFleet()

		;(function()
			arg0_114:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var1_115.id,
				arg1 = ChapterConst.StrategyAirSupport,
				arg2 = var0_115.row,
				arg3 = var0_115.column
			})
		end)()
	end, SFX_UI_CLICK)
	onButton(arg0_114, arg0_114.missileStrikeRole:Find("cancel_button"), function()
		arg0_114:SwitchBottomStagePanel(false)
		arg0_114.grid:HideAirSupportAimingMark()
		arg0_114.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchAirExpelBottomStagePanel(arg0_118)
	setActive(arg0_118.airExpelRole, true)
	setText(findTF(arg0_118.airExpelRole, "cancel_button/Text"), i18n("levelscene_airexpel_cancel"))
	onButton(arg0_118, arg0_118.airExpelRole:Find("cancel_button"), function()
		arg0_118:SwitchBottomStagePanel(false)
		arg0_118.grid:HideAirExpelAimingMark()
		arg0_118.grid:CleanAirSupport()
		arg0_118.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
end

function var0_0.SwitchBottomStagePanel(arg0_120, arg1_120)
	setActive(arg0_120.actionRole, true)
	setActive(arg0_120.normalRole, true)
	shiftPanel(arg0_120.actionRole, 0, arg1_120 and 0 or var1_0, 0.3, 0, true, true, nil, function()
		setActive(arg0_120.actionRole, arg1_120)
	end)
	shiftPanel(arg0_120.normalRole, 0, arg1_120 and var1_0 or 0, 0.3, 0, true, true, nil, function()
		setActive(arg0_120.normalRole, not arg1_120)

		if not arg1_120 then
			eachChild(arg0_120.actionRole, function(arg0_123)
				setActive(arg0_123, false)
			end)
		end
	end)
	shiftPanel(arg0_120.leftStage, arg1_120 and -arg0_120.leftStage.rect.width - 200 or 0, 0, 0.3, 0, true)
	shiftPanel(arg0_120.rightStage, arg1_120 and arg0_120.rightStage.rect.width + 300 or 0, 0, 0.3, 0, true)
end

function var0_0.ClickGridCellNormal(arg0_124, arg1_124)
	local var0_124 = arg0_124.contextData.chapterVO
	local var1_124 = var0_124.fleet
	local var2_124 = _.detect(var0_124.fleets, function(arg0_125)
		return arg0_125:getFleetType() == FleetType.Normal and arg0_125.line.row == arg1_124.row and arg0_125.line.column == arg1_124.column
	end)

	if var2_124 and var2_124:isValid() and var2_124.id ~= var1_124.id then
		arg0_124:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var2_124.id
		})

		return
	end

	if arg0_124:tryAutoTrigger(nil, true) then
		return
	end

	if arg1_124.row == var1_124.line.row and arg1_124.column == var1_124.line.column then
		return
	end

	local var3_124 = var0_124:getChapterCell(arg1_124.row, arg1_124.column)

	if var3_124.attachment == ChapterConst.AttachStory and var3_124.data == ChapterConst.StoryObstacle and var3_124.flag == ChapterConst.CellFlagTriggerActive then
		local var4_124 = pg.map_event_template[var3_124.attachmentId]

		if var4_124 and var4_124.gametip and #var4_124.gametip > 0 and var0_124:getPlayType() ~= ChapterConst.TypeDefence then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var4_124.gametip))
		end

		return
	elseif not var0_124:considerAsStayPoint(ChapterConst.SubjectPlayer, arg1_124.row, arg1_124.column) then
		return
	elseif var0_124:existMoveLimit() then
		local var5_124 = var0_124:calcWalkableCells(ChapterConst.SubjectPlayer, var1_124.line.row, var1_124.line.column, var1_124:getSpeed())

		if not _.any(var5_124, function(arg0_126)
			return arg0_126.row == arg1_124.row and arg0_126.column == arg1_124.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))

			return
		end
	end

	local var6_124 = var0_124:findPath(ChapterConst.SubjectPlayer, var1_124.line, {
		row = arg1_124.row,
		column = arg1_124.column
	})

	if var6_124 < PathFinding.PrioObstacle then
		arg0_124:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var1_124.id,
			arg1 = arg1_124.row,
			arg2 = arg1_124.column
		})
	elseif var6_124 < PathFinding.PrioForbidden then
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
	end
end

function var0_0.tryAutoAction(arg0_127, arg1_127)
	if arg0_127.doingAutoAction then
		return
	end

	arg0_127.doingAutoAction = true

	local var0_127 = arg0_127.contextData.chapterVO

	if not var0_127 then
		existCall(arg1_127)

		return
	end

	if arg0_127:SafeCheck() then
		existCall(arg1_127)

		return
	end

	local var1_127 = {}
	local var2_127 = false

	for iter0_127, iter1_127 in pairs(var0_127.cells) do
		if iter1_127.trait == ChapterConst.TraitLurk then
			var2_127 = true

			break
		end
	end

	if not var2_127 then
		for iter2_127, iter3_127 in ipairs(var0_127.champions) do
			if iter3_127.trait == ChapterConst.TraitLurk then
				var2_127 = true

				break
			end
		end
	end

	if var2_127 then
		local var3_127 = var0_127:existOni()
		local var4_127 = var0_127:isPlayingWithBombEnemy()

		if not var3_127 and not var4_127 then
			table.insert(var1_127, function(arg0_128)
				arg0_127:emit(LevelUIConst.DO_TRACKING, arg0_128)
			end)
		else
			table.insertto(var1_127, {
				function(arg0_129)
					local var0_129

					if var3_127 then
						var0_129 = "SpUnit"
					elseif var4_127 then
						var0_129 = "SpBomb"
					end

					assert(var0_129)
					arg0_127:emit(LevelUIConst.DO_PLAY_ANIM, {
						name = var0_129,
						callback = function(arg0_130)
							setActive(arg0_130, false)
							arg0_129()
						end
					})
				end,
				function(arg0_131)
					local var0_131 = var0_127:getSpAppearStory()

					if var0_131 and #var0_131 > 0 then
						pg.NewStoryMgr.GetInstance():Play(var0_131, arg0_131)

						return
					end

					arg0_131()
				end,
				function(arg0_132)
					local var0_132 = var0_127:getSpAppearGuide()

					if var0_132 and #var0_132 > 0 then
						pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_132, nil, arg0_132)

						return
					end

					arg0_132()
				end
			})
		end

		table.insertto(var1_127, {
			function(arg0_133)
				parallelAsync({
					function(arg0_134)
						arg0_127:tryPlayChapterStory(arg0_134)
					end,
					function(arg0_135)
						local var0_135 = var0_127:GetBossCell()

						if var0_135 and var0_135.trait == ChapterConst.TraitLurk then
							arg0_127.grid:focusOnCell(var0_135, arg0_135)

							return
						end

						arg0_135()
					end
				}, arg0_133)
			end,
			function(arg0_136)
				arg0_127:updateTrait(ChapterConst.TraitVirgin)
				arg0_127.grid:updateAttachments()
				arg0_127.grid:updateChampions()
				arg0_127:updateTrait(ChapterConst.TraitNone)
				arg0_127:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
				Timer.New(arg0_136, 0.5, 1):Start()
			end
		})
	end

	seriesAsync({
		function(arg0_137)
			arg0_127:emit(LevelUIConst.FROZEN)

			local var0_137 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_127.id)

			if var0_137 and (var0_137.attachment ~= ChapterConst.AttachAmbush or ChapterConst.IsBossCell(var0_137)) then
				local var1_137 = ChapterConst.GetDestroyFX(var0_137)

				arg0_127.grid:PlayAttachmentEffect(var0_137.line.row, var0_137.line.column, var1_137, Vector2.zero)
			end

			arg0_127:PopBar()
			arg0_127:UpdateComboPanel()
			arg0_137()
		end,
		function(arg0_138)
			if not (function()
				local var0_139 = getProxy(ChapterProxy):GetLastDefeatedEnemy(var0_127.id)

				if not var0_139 then
					return
				end

				local var1_139 = pg.expedition_data_template[var0_139.attachmentId]

				return var1_139 and var1_139.type == ChapterConst.ExpeditionTypeMulBoss
			end)() then
				return arg0_138()
			end

			arg0_127:emit(LevelUIConst.DO_PLAY_ANIM, {
				name = "BossRetreatBar",
				callback = function(arg0_140)
					setActive(arg0_140, false)
					arg0_138()
				end
			})
		end,
		function(arg0_141)
			arg0_127:UpdateDOALinkFeverPanel(arg0_141)
		end,
		function(arg0_142)
			seriesAsync(var1_127, arg0_142)
		end,
		function(arg0_143)
			local var0_143, var1_143 = var0_127:GetAttachmentStories()

			if var0_143 then
				table.SerialIpairsAsync(var0_143, function(arg0_144, arg1_144, arg2_144)
					if arg0_144 <= var1_143 and arg1_144 and type(arg1_144) == "number" and arg1_144 > 0 then
						local var0_144 = pg.NewStoryMgr:StoryId2StoryName(arg1_144)

						ChapterOpCommand.PlayChapterStory(var0_144, arg2_144, var0_127:IsAutoFight())

						return
					end

					arg2_144()
				end, arg0_143)

				return
			end

			arg0_143()
		end,
		function(arg0_145)
			local var0_145 = arg0_127.contextData.chapterVO.id
			local var1_145 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_145)

			if not var1_145 or #var1_145 < 1 then
				arg0_145()

				return
			end

			for iter0_145, iter1_145 in ipairs(var1_145) do
				local var2_145 = pg.chapter_status_effect[iter1_145]
				local var3_145 = var2_145 and var2_145.camera_focus or ""

				if type(var3_145) == "table" then
					arg0_127.grid:focusOnCell({
						row = var3_145[1],
						column = var3_145[2]
					}, arg0_145)

					return
				end
			end

			arg0_145()
		end,
		function(arg0_146)
			if arg0_127.exited then
				return
			end

			arg0_127:emit(LevelUIConst.UN_FROZEN)
			;(function()
				local var0_147 = getProxy(ChapterProxy)
				local var1_147 = var0_147:getActiveChapter(true)

				if not var1_147 then
					return
				end

				local var2_147 = var1_147.id

				var0_147:RecordComboHistory(var2_147, nil)
				var0_147:RecordLastDefeatedEnemy(var2_147, nil)
				var0_147:extraFlagUpdated(var2_147)
				var0_147:RemoveExtendChapterData(var2_147, "FleetMoveDistance")
			end)()
			arg0_146()
		end
	}, function()
		if arg0_127.exited then
			return
		end

		arg0_127.doingAutoAction = nil

		if var2_127 and arg0_127:TryEnterChapterStoryStage() then
			-- block empty
		else
			existCall(arg1_127)
		end
	end)
end

function var0_0.tryPlayChapterStory(arg0_149, arg1_149)
	local var0_149 = arg0_149.contextData.chapterVO
	local var1_149 = var0_149:getWaveCount()

	seriesAsync({
		function(arg0_150)
			pg.SystemGuideMgr.GetInstance():PlayChapter(var0_149, arg0_150)
		end,
		function(arg0_151)
			local var0_151 = var0_149:getConfig("story_refresh")
			local var1_151 = var0_151 and var0_151[var1_149]

			if var1_151 and type(var1_151) == "string" and var1_151 ~= "" and not var0_149:IsRemaster() then
				ChapterOpCommand.PlayChapterStory(var1_151, arg0_151, var0_149:IsAutoFight())

				return
			end

			arg0_151()
		end,
		function(arg0_152)
			local var0_152 = var0_149:getConfig("story_refresh_boss")

			if var0_152 and type(var0_152) == "string" and var0_152 ~= "" and not var0_149:IsRemaster() and var0_149:IsFinalBossRefreshed() then
				ChapterOpCommand.PlayChapterStory(var0_152, arg0_152, var0_149:IsAutoFight())

				return
			end

			arg0_152()
		end,
		function(arg0_153)
			if var1_149 == 1 and pg.map_event_list[var0_149.id] and pg.map_event_list[var0_149.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. var0_149.id, 0) == 0 then
				triggerButton(arg0_149.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. var0_149.id, 1)
			end

			arg0_153()
		end,
		function()
			existCall(arg1_149)
		end
	})
end

function var0_0.TryEnterChapterStoryStage(arg0_155, arg1_155)
	local var0_155 = arg0_155.contextData.chapterVO
	local var1_155 = var0_155:getWaveCount()
	local var2_155 = var0_155:getConfig("story_refresh")
	local var3_155 = var2_155 and var2_155[var1_155]

	if var3_155 and type(var3_155) == "number" and not var0_155:IsRemaster() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var3_155)) then
		arg0_155:emit(LevelMediator2.ON_PERFORM_COMBAT, var3_155)

		return true
	end

	local var4_155 = var0_155:getConfig("story_refresh_boss")

	if var4_155 and type(var4_155) == "number" and not var0_155:IsRemaster() and var0_155:IsFinalBossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var4_155)) then
		arg0_155:emit(LevelMediator2.ON_PERFORM_COMBAT, var4_155)

		return true
	end
end

function var0_0.TryEnterChapterSupportSubmarineStage(arg0_156, arg1_156)
	local var0_156 = arg0_156.contextData.chapterVO
	local var1_156 = var0_156:getChapterSupportFleet()
	local var2_156 = {}

	if var0_156:getChapterSupportFleet() then
		arg0_156:emit(LevelMediator2.ON_SUPPORT_SUBMARINE)
	else
		arg0_156:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OPSubStrike,
			arg1 = ys.Battle.BattleConst.BattleScore.C,
			callback = arg1_156
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

function var0_0.PopBar(arg0_157)
	local var0_157 = arg0_157.contextData.chapterVO.id
	local var1_157 = getProxy(ChapterProxy):getUpdatedExtraFlags(var0_157)

	if not var1_157 or #var1_157 < 1 then
		return
	end

	local var2_157 = var1_157[1]
	local var3_157 = var4_0[var2_157]

	if not var3_157 then
		return
	end

	local var4_157, var5_157 = arg0_157:GetSubView(var3_157)

	if var5_157 then
		var4_157:Load()
	end

	var4_157.buffer:PlayAnim()
end

function var0_0.updateTrait(arg0_158, arg1_158)
	local var0_158 = arg0_158.contextData.chapterVO

	for iter0_158, iter1_158 in pairs(var0_158.cells) do
		if iter1_158.trait ~= ChapterConst.TraitNone then
			iter1_158.trait = arg1_158
		end
	end

	for iter2_158, iter3_158 in ipairs(var0_158.champions) do
		if iter3_158.trait ~= ChapterConst.TraitNone then
			iter3_158.trait = arg1_158
		end
	end
end

function var0_0.CheckFleetChange(arg0_159)
	local var0_159 = arg0_159.contextData.chapterVO
	local var1_159 = var0_159:GetActiveFleet()
	local var2_159 = _.detect(var0_159.fleets, function(arg0_160)
		return not arg0_160:isValid()
	end)

	if var2_159 then
		arg0_159:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRetreat,
			id = var2_159.id
		})

		if var2_159:getFleetType() == TeamType.Normal then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
		end
	end

	if not var1_159:isValid() then
		local var3_159 = var0_159:getNextValidIndex()

		if var3_159 > 0 then
			local var4_159 = var0_159.fleets[var3_159]

			local function var5_159()
				arg0_159:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSwitch,
					id = var4_159.id
				})
			end

			arg0_159:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("formation_switch_tip", var4_159.name),
				onYes = var5_159,
				onNo = var5_159
			})
		end

		return true
	end

	return false
end

function var0_0.tryAutoTrigger(arg0_162, arg1_162, arg2_162)
	local var0_162 = arg0_162.contextData.chapterVO

	if arg0_162:DoBreakAction() then
		return
	end

	if arg0_162:CheckFleetChange() then
		return
	end

	return ((function()
		if var0_162:checkAnyInteractive() then
			if not arg1_162 or var0_162:IsAutoFight() then
				triggerButton(arg0_162.funcBtn)

				return true
			end
		elseif var0_162:getRound() == ChapterConst.RoundEnemy then
			arg0_162:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpEnemyRound
			})

			return true
		elseif var0_162:getRound() == ChapterConst.RoundPlayer then
			if not arg2_162 then
				arg0_162.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			end

			if var0_162:IsAutoFight() then
				arg0_162:TryAutoFight()

				return true
			end
		end
	end)())
end

function var0_0.DoBreakAction(arg0_164)
	local var0_164 = arg0_164.contextData.chapterVO
	local var1_164, var2_164 = arg0_164:SafeCheck()

	if var1_164 then
		local function var3_164(arg0_165)
			local var0_165

			seriesAsync({
				function(arg0_166)
					arg0_164:emit(LevelUIConst.ADD_MSG_QUEUE, arg0_166)
				end,
				function(arg0_167, arg1_167)
					var0_165 = arg1_167

					ChapterOpCommand.PrepareChapterRetreat(arg0_167)
				end,
				function(arg0_168)
					existCall(arg0_165)
					existCall(var0_165)
				end
			})
		end

		if var2_164 == ChapterConst.ReasonVictory then
			seriesAsync({
				function(arg0_169)
					var3_164(arg0_169)
				end,
				function(arg0_170)
					local var0_170 = var0_164:getConfig("win_condition_display") and #var0_170 > 0 and var0_170 .. "_tip"

					if var0_170 and pg.gametip[var0_170] then
						pg.TipsMgr.GetInstance():ShowTips(i18n(var0_170))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_win"))
					end

					arg0_170()
				end
			})
		elseif var2_164 == ChapterConst.ReasonDefeat then
			if var0_164:getPlayType() == ChapterConst.TypeTransport then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_escort_lose"))
				var3_164()
			else
				arg0_164:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("formation_invalide"),
					onYes = var3_164,
					onClose = var3_164
				})
			end
		elseif var2_164 == ChapterConst.ReasonDefeatDefense then
			arg0_164:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("harbour_bomb_tip"),
				onYes = var3_164,
				onClose = var3_164
			})
		elseif var2_164 == ChapterConst.ReasonVictoryOni then
			var3_164()
		elseif var2_164 == ChapterConst.ReasonDefeatOni then
			var3_164()
		elseif var2_164 == ChapterConst.ReasonDefeatBomb then
			var3_164()
		elseif var2_164 == ChapterConst.ReasonOutTime then
			arg0_164:emit(LevelMediator2.ON_TIME_UP)
		elseif var2_164 == ChapterConst.ReasonActivityOutTime then
			arg0_164:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_activity_timeout"),
				onYes = var3_164,
				onClose = var3_164
			})
		end

		return true
	end

	return var1_164
end

function var0_0.SafeCheck(arg0_171)
	local var0_171 = arg0_171.contextData.chapterVO

	if var0_171:existOni() then
		local var1_171 = var0_171:checkOniState()

		if var1_171 == 1 then
			return true, ChapterConst.ReasonVictoryOni
		elseif var1_171 == 2 then
			return true, ChapterConst.ReasonDefeatOni
		else
			return false
		end
	elseif var0_171:isPlayingWithBombEnemy() then
		if var0_171:getBombChapterInfo().action_times * 2 <= var0_171.roundIndex then
			return true, ChapterConst.ReasonDefeatBomb
		else
			return false
		end
	end

	local var2_171, var3_171 = var0_171:CheckChapterWin()

	if var2_171 then
		return true, var3_171
	end

	local var4_171, var5_171 = var0_171:CheckChapterLose()

	if var4_171 then
		return true, var5_171
	end

	if not var0_171:inWartime() then
		return true, ChapterConst.ReasonOutTime
	end

	local var6_171 = var0_171:GetBindActID()

	if not arg0_171.contextData.map:isRemaster() and var6_171 ~= 0 then
		local var7_171 = getProxy(ActivityProxy):getActivityById(var6_171)

		if not var7_171 or var7_171:isEnd() then
			return true, ChapterConst.ReasonActivityOutTime
		end
	end

	return false
end

function var0_0.TryAutoFight(arg0_172)
	local var0_172 = arg0_172.contextData.chapterVO
	local var1_172 = arg0_172.contextData.map

	if not var0_172:IsAutoFight() then
		return
	end

	local var2_172 = var0_172:GetAllEnemies()
	local var3_172 = _.detect(var2_172, function(arg0_173)
		return ChapterConst.IsBossCell(arg0_173)
	end)
	local var4_172 = var0_172:GetFleetOfDuty(tobool(var3_172))

	if var4_172 and var4_172.id ~= var0_172.fleet.id then
		arg0_172:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = var4_172.id
		})
		arg0_172:tryAutoTrigger()

		return
	end

	if var0_172:checkAnyInteractive() then
		arg0_172:tryAutoTrigger()

		return
	end

	local var5_172

	for iter0_172, iter1_172 in ipairs(var0_172:getConfig("box_auto_pick")) do
		local var6_172 = underscore.filter(switch(iter1_172, {
			[ChapterConst.AttachBox] = function()
				return var0_172:findChapterCells(iter1_172)
			end,
			[ChapterConst.AttachSupply] = function()
				local var0_175, var1_175 = var0_172:getFleetAmmo(var4_172)

				if var0_175 - var1_175 < 3 then
					return {}
				else
					return underscore.filter(var0_172:findChapterCells(iter1_172), function(arg0_176)
						return arg0_176.attachmentId > 0
					end)
				end
			end
		}), function(arg0_177)
			return arg0_177.flag ~= ChapterConst.CellFlagDisabled
		end)

		for iter2_172, iter3_172 in ipairs(var6_172) do
			local var7_172, var8_172 = var0_172:findPath(ChapterConst.SubjectPlayer, var4_172.line, iter3_172)

			if var7_172 < PathFinding.PrioObstacle then
				var5_172 = var5_172 or {}

				table.insert(var5_172, {
					target = iter3_172,
					priority = var7_172,
					path = var8_172
				})
			end
		end

		if var5_172 then
			table.sort(var5_172, CompareFuncs({
				function(arg0_178)
					return arg0_178.priority
				end
			}))

			break
		end
	end

	if not var5_172 then
		if var3_172 then
			local var9_172, var10_172 = var0_172:FindBossPath(var4_172.line, var3_172)
			local var11_172 = {}
			local var12_172

			for iter4_172, iter5_172 in ipairs(var10_172) do
				table.insert(var11_172, iter5_172)

				if var0_172:existEnemy(ChapterConst.SubjectPlayer, iter5_172.row, iter5_172.column) then
					var9_172 = iter4_172
					var12_172 = iter5_172

					break
				end
			end

			var5_172 = {
				{
					target = var12_172 or var3_172,
					priority = var9_172 or 0,
					path = var11_172
				}
			}
		else
			var5_172 = underscore.map(var2_172, function(arg0_179)
				local var0_179, var1_179 = var0_172:findPath(ChapterConst.SubjectPlayer, var4_172.line, arg0_179)

				return {
					target = arg0_179,
					priority = var0_179,
					path = var1_179
				}
			end)

			local function var13_172(arg0_180)
				local var0_180 = arg0_180.target
				local var1_180 = pg.expedition_data_template[var0_180.attachmentId]

				assert(var1_180, "expedition_data_template not exist: " .. var0_180.attachmentId)

				if var0_180.flag == ChapterConst.CellFlagDisabled then
					return 0
				end

				return ChapterConst.EnemyPreference[var1_180.type]
			end

			if var0_172.id == 1604 then
				table.sort(var5_172, CompareFuncs({
					function(arg0_181)
						return arg0_181.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_182)
						return -var13_172(arg0_182)
					end,
					function(arg0_183)
						return arg0_183.priority
					end,
					function(arg0_184)
						return arg0_184.target.row
					end,
					function(arg0_185)
						return -arg0_185.target.column
					end
				}))
			else
				table.sort(var5_172, CompareFuncs({
					function(arg0_186)
						return arg0_186.priority < PathFinding.PrioObstacle and 0 or 1
					end,
					function(arg0_187)
						return -var13_172(arg0_187)
					end,
					function(arg0_188)
						return arg0_188.priority
					end
				}))
			end
		end
	end

	if var5_172 and #var5_172 > 0 and var5_172[1].priority < PathFinding.PrioObstacle then
		local var14_172 = var5_172[1].target

		arg0_172:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = var4_172.id,
			arg1 = var14_172.row,
			arg2 = var14_172.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(var0_172.id, false)
	end
end

function var0_0.popStageStrategy(arg0_189)
	local var0_189 = arg0_189.rightStage:Find("event/collapse")

	if var0_189.anchoredPosition.x <= 1 then
		triggerButton(var0_189)
	end
end

function var0_0.UpdateAutoFightPanel(arg0_190)
	if arg0_190.contextData.chapterVO:CanActivateAutoFight() then
		if not arg0_190.autoFightPanel then
			arg0_190.autoFightPanel = LevelStageAutoFightPanel.New(arg0_190.rightStage:Find("event/collapse"), arg0_190.event, arg0_190.contextData)

			arg0_190.autoFightPanel:Load()

			arg0_190.autoFightPanel.isFrozen = arg0_190.isFrozen
		end

		arg0_190.autoFightPanel.buffer:Show()
	elseif arg0_190.autoFightPanel then
		arg0_190.autoFightPanel.buffer:Hide()
	end
end

function var0_0.UpdateAutoFightMark(arg0_191)
	if not arg0_191.autoFightPanel then
		return
	end

	arg0_191.autoFightPanel.buffer:UpdateAutoFightMark()
end

function var0_0.DestroyAutoFightPanel(arg0_192)
	if not arg0_192.autoFightPanel then
		return
	end

	arg0_192.autoFightPanel:Destroy()

	arg0_192.autoFightPanel = nil
end

function var0_0.DestroyToast(arg0_193)
	if not arg0_193.toastPanel then
		return
	end

	arg0_193.toastPanel:Destroy()

	arg0_193.toastPanel = nil
end

function var0_0.Toast(arg0_194)
	arg0_194:DestroyToast()

	local var0_194 = table.remove(arg0_194.toastQueue, 1)

	if not var0_194 then
		return
	end

	arg0_194.toastPanel = var0_194.Class.New(arg0_194)

	arg0_194.toastPanel:Load()

	arg0_194.toastPanel.contextData.settings = var0_194

	arg0_194.toastPanel.buffer:Play(function()
		arg0_194:Toast()
	end)
end

function var0_0.HandleShowMsgBox(arg0_196, arg1_196)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_196)
end

return var0_0
