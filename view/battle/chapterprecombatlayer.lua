local var0_0 = class("ChapterPreCombatLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")
local var2_0 = {
	[99] = true
}

var0_0.optionsPath = {
	"adapt/top/option"
}

function var0_0.getUIName(arg0_1)
	return "ChapterPreCombatUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = ResList.ChapterPreCombatLayer.GetConstResource()

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3, arg1_3))
end

function var0_0.downloadChapterPreCombatRes(arg0_4, arg1_4, arg2_4)
	local var0_4 = ResList.ChapterPreCombatLayer.GetResource(arg1_4)

	SplitPackConst.DownloadByLuaArr(var0_4, function()
		if arg0_4.exited or arg0_4.chapter ~= arg1_4 then
			return
		end

		arg2_4()
	end)
end

function var0_0.init(arg0_6)
	arg0_6._startBtn = arg0_6.rtAdapt:Find("right/start")
	arg0_6._popup = arg0_6.rtAdapt:Find("right/popup")
	arg0_6._costText = arg0_6.rtAdapt:Find("right/popup/Text")
	arg0_6._costTip = arg0_6.rtAdapt:Find("right/popup/tip")
	arg0_6._extraCostBuffIcon = arg0_6.rtAdapt:Find("right/operation_buff_icon")
	arg0_6._backBtn = arg0_6.rtAdapt:Find("top/back_btn")
	arg0_6._moveLayer = arg0_6._tf:Find("moveLayer")

	local var0_6 = arg0_6.rtAdapt:Find("middle")

	arg0_6._mainGS = var0_6:Find("gear_score/main/Text")
	arg0_6._vanguardGS = var0_6:Find("gear_score/vanguard/Text")

	setText(arg0_6._mainGS, 0)
	setText(arg0_6._vanguardGS, 0)

	arg0_6._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0_6._gridFrame = var0_6:Find("mask/GridFrame")

	for iter0_6 = 1, 3 do
		arg0_6._gridTFs[TeamType.Vanguard][iter0_6] = arg0_6._gridFrame:Find("vanguard_" .. iter0_6)
		arg0_6._gridTFs[TeamType.Main][iter0_6] = arg0_6._gridFrame:Find("main_" .. iter0_6)
	end

	arg0_6._heroContainer = var0_6:Find("HeroContainer")
	arg0_6._strategy = var0_6:Find("strategy")

	setActive(arg0_6._strategy, true)

	arg0_6._spoilsContainer = arg0_6.rtAdapt:Find("right/infomation/spoils/items/items_container")
	arg0_6._goals = arg0_6.rtAdapt:Find("right/infomation/goal")
	arg0_6._item = arg0_6:getTpl("right/infomation/spoils/items/item_tpl", arg0_6.rtAdapt)
	arg0_6._heroInfo = arg0_6:getTpl("heroInfo")
	arg0_6._starTpl = arg0_6:getTpl("star_tpl")
	arg0_6._middle = arg0_6.rtAdapt:Find("middle")
	arg0_6._right = arg0_6.rtAdapt:Find("right")
	arg0_6._formationLogic = BaseFormation.New(arg0_6._tf, arg0_6._heroContainer, arg0_6._heroInfo, arg0_6._gridTFs)

	local var1_6 = {
		Shift = function(arg0_7, arg1_7, arg2_7)
			return
		end
	}

	setmetatable(var1_6, arg0_6._formationLogic)
	setText(arg0_6.rtAdapt:Find("middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(arg0_6.rtAdapt:Find("middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))

	arg0_6._fleet = arg0_6.rtAdapt:Find("middle/fleet")

	setText(arg0_6._fleet:Find("title_bg/Text"), i18n("pre_combat_team"))

	arg0_6._ship_tpl = arg0_6._fleet:Find("shiptpl")
	arg0_6._empty_tpl = arg0_6._fleet:Find("emptytpl")

	setActive(arg0_6._ship_tpl, false)
	setActive(arg0_6._empty_tpl, false)

	arg0_6._autoToggle = arg0_6.rtAdapt:Find("middle/auto_toggle")
	arg0_6._autoSubToggle = arg0_6.rtAdapt:Find("middle/sub_toggle_container/sub_toggle")
	arg0_6.topPanel = arg0_6.rtAdapt:Find("top")
	arg0_6.strategyInfo = arg0_6._tf:Find("strategy_info")

	setActive(arg0_6.strategyInfo, false)

	arg0_6._operaionBuffTips = arg0_6._extraCostBuffIcon:Find("popup")

	setAnchoredPosition(arg0_6._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_6._right, {
		x = 470
	})
	arg0_6:Register()
end

function var0_0.uiStartAnimating(arg0_8)
	setAnchoredPosition(arg0_8.topPanel, {
		y = 100
	})

	local var0_8 = 0
	local var1_8 = 0.3

	shiftPanel(arg0_8._middle, 0, nil, var1_8, var0_8, true, true)
	shiftPanel(arg0_8._right, 0, nil, var1_8, var0_8, true, true, nil)
	shiftPanel(arg0_8.topPanel, nil, 0, var1_8, var0_8, true, true, nil, nil)
end

function var0_0.uiExitAnimating(arg0_9)
	local var0_9 = 0
	local var1_9 = 0.3

	shiftPanel(arg0_9._middle, -840, nil, var1_9, var0_9, true, true)
	shiftPanel(arg0_9._right, 470, nil, var1_9, var0_9, true, true)
	shiftPanel(arg0_9.topPanel, nil, arg0_9.topPanel.rect.height, var1_9, var0_9, true, true, nil, nil)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10._backBtn, function()
		GetOrAddComponent(arg0_10._tf, typeof(CanvasGroup)).interactable = false

		arg0_10:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_10:emit(var0_0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10._startBtn, function()
		arg0_10:emit(ChapterPreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onToggle(arg0_10, arg0_10._autoToggle, function(arg0_14)
		arg0_10:emit(ChapterPreCombatMediator.ON_AUTO, {
			isOn = not arg0_14,
			toggle = arg0_10._autoToggle
		})

		if arg0_14 and arg0_10.subUseable == true then
			setActive(arg0_10._autoSubToggle, true)
			onToggle(arg0_10, arg0_10._autoSubToggle, function(arg0_15)
				arg0_10:emit(ChapterPreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_15,
					toggle = arg0_10._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_10._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0_10._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf)
	onNextTick(function()
		if arg0_10.exited then
			return
		end

		triggerToggle(arg0_10._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	end)
	setAnchoredPosition(arg0_10.topPanel, {
		y = arg0_10.topPanel.rect.height
	})
	onNextTick(function()
		arg0_10:uiStartAnimating()
	end)
	onButton(arg0_10, arg0_10.rtAdapt:Find("middle/gear_score/vanguard/SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._costTip, function()
		local var0_19 = arg0_10.chapter.fleet
		local var1_19 = arg0_10.chapter:getStageId(var0_19.line.row, var0_19.line.column)
		local var2_19, var3_19, var4_19 = arg0_10.chapter:isOverFleetCost(var0_19, var1_19)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("use_oil_limit_help", var4_19, var3_19)
		})
	end)
end

function var0_0.Register(arg0_20)
	arg0_20._formationLogic:AddHeroInfoModify(function(arg0_21, arg1_21, arg2_21)
		setAnchoredPosition(arg0_21, {
			x = 0,
			y = 0
		})
		SetActive(arg0_21, true)

		arg0_21.name = "info"

		local var0_21 = arg0_21:Find("info")
		local var1_21 = var0_21:Find("stars")
		local var2_21 = arg1_21:getEnergy() <= Ship.ENERGY_MID
		local var3_21 = var0_21:Find("energy")

		if var2_21 then
			local var4_21, var5_21 = arg1_21:getEnergyPrint()
			local var6_21 = GetSpriteFromAtlas("energy", var4_21)

			if not var6_21 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_21, var6_21)
		end

		setActive(var3_21, var2_21)

		local var7_21 = arg1_21:getStar()

		for iter0_21 = 1, var7_21 do
			cloneTplTo(arg0_20._starTpl, var1_21)
		end

		local var8_21 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_21:getShipType()))

		if not var8_21 then
			warning("找不到船形, shipConfigId: " .. arg1_21.configId)
		end

		setImageSprite(var0_21:Find("type"), var8_21, true)
		setText(var0_21:Find("frame/lv_contain/lv"), arg1_21.level)

		local var9_21 = var0_21:Find("blood")
		local var10_21 = var9_21:Find("fillarea/green")
		local var11_21 = var9_21:Find("fillarea/red")

		setActive(var10_21, arg1_21.hpRant >= ChapterConst.HpGreen)
		setActive(var11_21, arg1_21.hpRant < ChapterConst.HpGreen)

		;(arg1_21.hpRant >= ChapterConst.HpGreen and var10_21 or var11_21):GetComponent("Image").fillAmount = arg1_21.hpRant * 0.0001

		arg2_21:SetVisible(arg1_21.hpRant > 0)
		SetActive(arg0_21, arg1_21.hpRant > 0)

		local var12_21 = getProxy(ActivityProxy):getBuffShipList()[arg1_21:getGroupId()]
		local var13_21 = var0_21:Find("expbuff")

		setActive(var13_21, var12_21 ~= nil)

		if var12_21 then
			local var14_21 = var12_21 / 100
			local var15_21 = var12_21 % 100
			local var16_21 = tostring(var14_21)

			if var15_21 > 0 then
				var16_21 = var16_21 .. "." .. tostring(var15_21)
			end

			setText(var13_21:Find("text"), string.format("EXP +%s%%", var16_21))
		end
	end)
	arg0_20._formationLogic:AddShiftOnly(function(arg0_22)
		arg0_20:updateView(false)
	end)
	arg0_20._formationLogic:AddEndDrag(function()
		arg0_20:emit(ChapterPreCombatMediator.ON_SWITCH_SHIP, arg0_20.chapter.fleet)
	end)
	arg0_20._formationLogic:AddCheckRemove(function(arg0_24, arg1_24)
		arg0_24()
	end)
	arg0_20._formationLogic:AddCheckSwitch(function(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
		local var0_25 = arg3_25:getTeamByName(arg4_25)

		if arg3_25.ships[var0_25[arg2_25]].hpRant == 0 then
			return
		end

		arg0_25()
	end)
	arg0_20._formationLogic:AddCheckBeginDrag(function(arg0_26, arg1_26, arg2_26)
		return arg0_26.hpRant > 0
	end)
end

function var0_0.setPlayerInfo(arg0_27, arg1_27)
	return
end

function var0_0.updateChapter(arg0_28, arg1_28)
	arg0_28.chapter = arg1_28

	arg0_28:downloadChapterPreCombatRes(arg1_28, function()
		arg0_28:updateChapterAfterDownload(arg1_28)
	end)
end

function var0_0.updateChapterAfterDownload(arg0_30, arg1_30)
	if arg0_30.chapter ~= arg1_30 then
		return
	end

	local var0_30 = arg0_30.chapter.fleet

	arg0_30._formationLogic:SetFleetVO(var0_30)

	local var1_30 = var0_30.ships

	arg0_30._formationLogic:SetShipVOs(var1_30)
	arg0_30:updateView(true)
end

function var0_0.setSubFlag(arg0_31, arg1_31)
	arg0_31.subUseable = arg1_31 or false
end

function var0_0.updateView(arg0_32, arg1_32)
	arg0_32._formationLogic:ResetGrid(TeamType.Vanguard, true)
	arg0_32._formationLogic:ResetGrid(TeamType.Main, true)
	SetActive(arg0_32._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if arg1_32 then
		local var0_32 = arg0_32.chapter.fleet
		local var1_32 = arg0_32.chapter:getStageId(var0_32.line.row, var0_32.line.column)

		arg0_32:updateStageView(var1_32)
		arg0_32._formationLogic:LoadAllCharacter()
	else
		arg0_32._formationLogic:SetAllCharacterPos()
	end

	arg0_32:updateBattleFleetView()
	arg0_32:updateStrategyIcon()
	arg0_32:displayFleetInfo()
end

function var0_0.updateStageView(arg0_33, arg1_33)
	local var0_33 = pg.expedition_data_template[arg1_33]

	assert(var0_33, "expedition_data_template not exist: " .. arg1_33)

	local var1_33 = var0_33.limit_type
	local var2_33 = var0_33.time_limit
	local var3_33 = var0_33.sink_limit
	local var4_33 = Clone(var0_33.award_display)
	local var5_33 = checkExist(pg.expedition_activity_template[arg1_33], {
		"pt_drop_display"
	})

	if var5_33 and type(var5_33) == "table" then
		local var6_33 = getProxy(ActivityProxy)

		for iter0_33 = #var5_33, 1, -1 do
			local var7_33 = var6_33:getActivityById(var5_33[iter0_33][1])

			if var7_33 and not var7_33:isEnd() then
				table.insert(var4_33, 1, {
					2,
					id2ItemId(var5_33[iter0_33][2])
				})
			end
		end
	end

	local var8_33 = UIItemList.New(arg0_33._spoilsContainer, arg0_33._item)

	var8_33:make(function(arg0_34, arg1_34, arg2_34)
		local var0_34 = arg2_34
		local var1_34 = var4_33[arg1_34 + 1]
		local var2_34 = {
			type = var1_34[1],
			id = var1_34[2]
		}

		updateDrop(var0_34, var2_34)
		onButton(arg0_33, var0_34, function()
			local var0_35 = Item.getConfigData(var1_34[2])

			if var0_35 and var2_0[var0_35.type] then
				local function var1_35(arg0_36)
					local var0_36 = var0_35.display_icon
					local var1_36 = {}

					for iter0_36, iter1_36 in ipairs(var0_36) do
						local var2_36 = iter1_36[1]
						local var3_36 = iter1_36[2]
						local var4_36 = var2_36 == DROP_TYPE_SHIP and not table.contains(arg0_36, var3_36)

						var1_36[#var1_36 + 1] = {
							type = var2_36,
							id = var3_36,
							anonymous = var4_36
						}
					end

					arg0_33:emit(var0_0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_36,
						content = var0_35.display
					})
				end

				arg0_33:emit(ChapterPreCombatMediator.GET_CHAPTER_DROP_SHIP_LIST, arg0_33.chapter.id, var1_35)
			else
				arg0_33:emit(var0_0.ON_DROP, var2_34)
			end
		end, SFX_PANEL)
	end)
	var8_33:align(math.min(#var4_33, 6))

	local function var9_33(arg0_37, arg1_37)
		if type(arg0_37) == "table" then
			setActive(arg1_37, true)

			local var0_37 = i18n(PreCombatLayer.ObjectiveList[arg0_37[1]], arg0_37[2])

			setWidgetText(arg1_37, var0_37)
		else
			setActive(arg1_37, false)
		end
	end

	local var10_33 = {
		arg0_33._goals:Find("goal_tpl"),
		arg0_33._goals:Find("goal_sink"),
		arg0_33._goals:Find("goal_time")
	}
	local var11_33 = {
		var0_33.objective_1,
		var0_33.objective_2,
		var0_33.objective_3
	}
	local var12_33 = 1

	for iter1_33, iter2_33 in ipairs(var11_33) do
		if type(iter2_33) ~= "string" then
			var9_33(iter2_33, var10_33[var12_33])

			var12_33 = var12_33 + 1
		end
	end

	for iter3_33 = var12_33, #var10_33 do
		var9_33("", var10_33[iter3_33])
	end
end

function var0_0.updateBattleFleetView(arg0_38)
	local function var0_38(arg0_39, arg1_39)
		removeAllChildren(arg0_39)

		for iter0_39 = 1, 3 do
			if arg1_39[iter0_39] then
				local var0_39 = cloneTplTo(arg0_38._ship_tpl, arg0_39)

				updateShip(var0_39, arg1_39[iter0_39])

				local var1_39 = arg1_39[iter0_39].hpRant
				local var2_39 = var0_39:Find("blood")
				local var3_39 = var0_39:Find("blood/fillarea/green")
				local var4_39 = var0_39:Find("blood/fillarea/red")

				setActive(var3_39, var1_39 >= ChapterConst.HpGreen)
				setActive(var4_39, var1_39 < ChapterConst.HpGreen)

				;(var1_39 >= ChapterConst.HpGreen and var3_39 or var4_39):GetComponent("Image").fillAmount = var1_39 * 0.0001

				setActive(var0_39:Find("broken"), var1_39 == 0)
			end
		end
	end

	local var1_38 = arg0_38.chapter.fleet

	var0_38(arg0_38._fleet:Find("main"), var1_38:getShipsByTeam(TeamType.Main, true))
	var0_38(arg0_38._fleet:Find("vanguard"), var1_38:getShipsByTeam(TeamType.Vanguard, true))
end

function var0_0.displayFleetInfo(arg0_40)
	local var0_40 = arg0_40.chapter.fleet
	local var1_40 = arg0_40.chapter:getStageId(var0_40.line.row, var0_40.line.column)
	local var2_40 = var0_40:getCommanders()
	local var3_40 = _.reduce(var0_40:getShipsByTeam(TeamType.Vanguard, false), 0, function(arg0_41, arg1_41)
		return arg0_41 + arg1_41:getShipCombatPower(var2_40)
	end)
	local var4_40 = _.reduce(var0_40:getShipsByTeam(TeamType.Main, false), 0, function(arg0_42, arg1_42)
		return arg0_42 + arg1_42:getShipCombatPower(var2_40)
	end)
	local var5_40 = 0

	for iter0_40, iter1_40 in ipairs({
		arg0_40.chapter:getFleetCost(var0_40, var1_40)
	}) do
		var5_40 = var5_40 + iter1_40.oil
	end

	local var6_40 = arg0_40.chapter:isOverFleetCost(var0_40, var1_40)

	setActive(arg0_40._popup, true)
	setActive(arg0_40._costTip, var6_40)
	setTextColor(arg0_40._costText, var6_40 and Color(0.980392156862745, 0.392156862745098, 0.392156862745098) or Color.white)
	var1_0.tweenNumText(arg0_40._costText, var5_40)
	var1_0.tweenNumText(arg0_40._vanguardGS, var3_40)
	var1_0.tweenNumText(arg0_40._mainGS, var4_40)

	local var7_40, var8_40 = arg0_40.chapter:GetExtraCostRate()

	setActive(arg0_40._extraCostBuffIcon, #var8_40 > 0)

	for iter2_40, iter3_40 in ipairs(var8_40) do
		if iter3_40.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			setText(arg0_40._extraCostBuffIcon:Find("text_cost"), tonumber(iter3_40.benefit_effect) * 0.01 + 1)
		elseif iter3_40.benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setText(arg0_40._extraCostBuffIcon:Find("text_reward"), tonumber(iter3_40.benefit_effect) * 0.01 + 1)
		elseif iter3_40.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			onButton(arg0_40, arg0_40._extraCostBuffIcon, function()
				local var0_43 = ActivityBuff.GetBenefitCondition(iter3_40.benefit_condition)

				assert(var0_43[1] == "item")

				local var1_43 = var0_43[2]
				local var2_43 = pg.strategy_data_template[iter3_40.id]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var1_43
					},
					intro = var2_43.desc
				})
			end)
		end
	end

	local var9_40 = arg0_40.rtAdapt:Find("middle/gear_score/vanguard")
	local var10_40 = ChapterFleet.StaticTransformChapterFleet2Fleet(var0_40):GetFleetSonarRange()

	setActive(var9_40:Find("SonarActive"), var10_40 > 0)
	setActive(var9_40:Find("SonarInactive"), var10_40 <= 0)

	if var10_40 > 0 then
		setText(var9_40:Find("SonarActive/Text"), math.floor(var10_40))
	end
end

function var0_0.updateStrategyIcon(arg0_44)
	local var0_44 = arg0_44.chapter.fleet:getStrategies()
	local var1_44 = _.detect(var0_44, function(arg0_45)
		return arg0_45.id == ChapterConst.StrategyRepair
	end)
	local var2_44 = pg.strategy_data_template[var1_44.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_44.icon, "", arg0_44._strategy:Find("icon"))
	onButton(arg0_44, arg0_44._strategy, function()
		arg0_44:displayStrategyInfo(var1_44)
	end, SFX_PANEL)
	setText(arg0_44._strategy:Find("nums"), var1_44.count)
	setActive(arg0_44._strategy:Find("mask"), var1_44.count == 0)
	setActive(arg0_44._strategy:Find("selected"), false)

	local var3_44 = arg0_44.rtAdapt:Find("middle/formation_list")
	local var4_44 = var3_44:Find("formation")

	setActive(var4_44, false)

	local var5_44 = ChapterConst.StrategyForms
	local var6_44 = {}
	local var7_44 = arg0_44.chapter.fleet:getFormationStg()

	table.insert(var6_44, 1, {
		id = var7_44
	})

	local var8_44 = UIItemList.New(var3_44, var4_44)

	var8_44:make(function(arg0_47, arg1_47, arg2_47)
		if arg0_47 == UIItemList.EventUpdate then
			local var0_47 = var6_44[arg1_47 + 1]
			local var1_47 = pg.strategy_data_template[var0_47.id]

			if var1_47.type ~= ChapterConst.StgTypeForm then
				return
			end

			GetImageSpriteFromAtlasAsync("strategyicon/" .. var1_47.icon, "", arg2_47:Find("icon"))
			onButton(arg0_44, arg2_47, function()
				if var1_47.type == ChapterConst.StgTypeForm then
					local var0_48 = arg0_44.chapter.fleet:getNextStgUser(var0_47.id)
					local var1_48 = table.indexof(var5_44, var0_47.id)

					arg0_44:emit(ChapterPreCombatMediator.ON_OP, {
						type = ChapterConst.OpStrategy,
						id = var0_48,
						arg1 = var5_44[var1_48 % #var5_44 + 1]
					})
				end
			end, SFX_PANEL)
			setText(arg2_47:Find("nums"), "")
			setActive(arg2_47:Find("mask"), false)
			setActive(arg2_47:Find("selected"), false)
		end
	end)
	var8_44:align(#var6_44)
end

function var0_0.displayStrategyInfo(arg0_49, arg1_49)
	arg0_49.strategyPanel = arg0_49.strategyPanel or StrategyPanel.New(arg0_49.strategyInfo)

	arg0_49.strategyPanel:attach(arg0_49)
	arg0_49.strategyPanel:set(arg1_49)
	pg.UIMgr.GetInstance():BlurPanel(arg0_49.strategyPanel._tf)

	function arg0_49.strategyPanel.onConfirm()
		local var0_50 = arg0_49.chapter.fleet
		local var1_50 = pg.strategy_data_template[arg1_49.id]

		if not var0_50:canUseStrategy(arg1_49) then
			return
		end

		local var2_50 = var0_50:getNextStgUser(arg1_49.id)

		arg0_49:emit(ChapterPreCombatMediator.ON_OP, {
			type = ChapterConst.OpStrategy,
			id = var2_50,
			arg1 = arg1_49.id
		})
		arg0_49:hideStrategyInfo()
	end

	function arg0_49.strategyPanel.onCancel()
		arg0_49:hideStrategyInfo()
	end
end

function var0_0.hideStrategyInfo(arg0_52)
	if arg0_52.strategyPanel then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_52.strategyPanel._tf)
		arg0_52.strategyPanel:detach()
	end
end

function var0_0.onBackPressed(arg0_53)
	if arg0_53.strategyPanel and arg0_53.strategyPanel._go and isActive(arg0_53.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_53:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_53._backBtn)
	end
end

function var0_0.willExit(arg0_54)
	if arg0_54.strategyPanel and arg0_54.strategyPanel._go and isActive(arg0_54.strategyPanel._go) then
		arg0_54:hideStrategyInfo()
	end

	arg0_54._formationLogic:Destroy()

	arg0_54._formationLogic = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54._tf)
end

return var0_0
