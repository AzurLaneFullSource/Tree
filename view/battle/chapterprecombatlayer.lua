local var0_0 = class("ChapterPreCombatLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")
local var2_0 = {
	[99] = true
}

function var0_0.getUIName(arg0_1)
	return "ChapterPreCombatUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3._startBtn = arg0_3:findTF("right/start")
	arg0_3._popup = arg0_3:findTF("right/popup")
	arg0_3._costText = arg0_3:findTF("right/popup/Text")
	arg0_3._costTip = arg0_3:findTF("right/popup/tip")
	arg0_3._extraCostBuffIcon = arg0_3:findTF("right/operation_buff_icon")
	arg0_3._backBtn = arg0_3:findTF("top/back_btn")
	arg0_3._moveLayer = arg0_3:findTF("moveLayer")

	local var0_3 = arg0_3:findTF("middle")

	arg0_3._mainGS = var0_3:Find("gear_score/main/Text")
	arg0_3._vanguardGS = var0_3:Find("gear_score/vanguard/Text")

	setText(arg0_3._mainGS, 0)
	setText(arg0_3._vanguardGS, 0)

	arg0_3._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0_3._gridFrame = var0_3:Find("mask/GridFrame")

	for iter0_3 = 1, 3 do
		arg0_3._gridTFs[TeamType.Vanguard][iter0_3] = arg0_3._gridFrame:Find("vanguard_" .. iter0_3)
		arg0_3._gridTFs[TeamType.Main][iter0_3] = arg0_3._gridFrame:Find("main_" .. iter0_3)
	end

	arg0_3._heroContainer = var0_3:Find("HeroContainer")
	arg0_3._strategy = var0_3:Find("strategy")

	setActive(arg0_3._strategy, true)

	arg0_3._spoilsContainer = arg0_3:findTF("right/infomation/spoils/items/items_container")
	arg0_3._goals = arg0_3:findTF("right/infomation/goal")
	arg0_3._item = arg0_3:getTpl("right/infomation/spoils/items/item_tpl")
	arg0_3._heroInfo = arg0_3:getTpl("heroInfo")
	arg0_3._starTpl = arg0_3:getTpl("star_tpl")
	arg0_3._middle = arg0_3:findTF("middle")
	arg0_3._right = arg0_3:findTF("right")
	arg0_3._formationLogic = BaseFormation.New(arg0_3._tf, arg0_3._heroContainer, arg0_3._heroInfo, arg0_3._gridTFs)

	local var1_3 = {
		Shift = function(arg0_4, arg1_4, arg2_4)
			return
		end
	}

	setmetatable(var1_3, arg0_3._formationLogic)
	setText(findTF(arg0_3._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_3._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))

	arg0_3._fleet = arg0_3:findTF("middle/fleet")

	setText(findTF(arg0_3._fleet, "title_bg/Text"), i18n("pre_combat_team"))

	arg0_3._ship_tpl = findTF(arg0_3._fleet, "shiptpl")
	arg0_3._empty_tpl = findTF(arg0_3._fleet, "emptytpl")

	setActive(arg0_3._ship_tpl, false)
	setActive(arg0_3._empty_tpl, false)

	arg0_3._autoToggle = arg0_3:findTF("middle/auto_toggle")
	arg0_3._autoSubToggle = arg0_3:findTF("middle/sub_toggle_container/sub_toggle")
	arg0_3.topPanel = arg0_3:findTF("top")
	arg0_3.strategyInfo = arg0_3:findTF("strategy_info")

	setActive(arg0_3.strategyInfo, false)

	arg0_3._operaionBuffTips = arg0_3._extraCostBuffIcon:Find("popup")

	setAnchoredPosition(arg0_3._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_3._right, {
		x = 470
	})
	arg0_3:Register()
end

function var0_0.uiStartAnimating(arg0_5)
	setAnchoredPosition(arg0_5.topPanel, {
		y = 100
	})

	local var0_5 = 0
	local var1_5 = 0.3

	shiftPanel(arg0_5._middle, 0, nil, var1_5, var0_5, true, true)
	shiftPanel(arg0_5._right, 0, nil, var1_5, var0_5, true, true, nil)
	shiftPanel(arg0_5.topPanel, nil, 0, var1_5, var0_5, true, true, nil, nil)
end

function var0_0.uiExitAnimating(arg0_6)
	local var0_6 = 0
	local var1_6 = 0.3

	shiftPanel(arg0_6._middle, -840, nil, var1_6, var0_6, true, true)
	shiftPanel(arg0_6._right, 470, nil, var1_6, var0_6, true, true)
	shiftPanel(arg0_6.topPanel, nil, arg0_6.topPanel.rect.height, var1_6, var0_6, true, true, nil, nil)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._backBtn, function()
		GetOrAddComponent(arg0_7._tf, typeof(CanvasGroup)).interactable = false

		arg0_7:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_7:emit(var0_0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7._startBtn, function()
		arg0_7:emit(ChapterPreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onToggle(arg0_7, arg0_7._autoToggle, function(arg0_11)
		arg0_7:emit(ChapterPreCombatMediator.ON_AUTO, {
			isOn = not arg0_11,
			toggle = arg0_7._autoToggle
		})

		if arg0_11 and arg0_7.subUseable == true then
			setActive(arg0_7._autoSubToggle, true)
			onToggle(arg0_7, arg0_7._autoSubToggle, function(arg0_12)
				arg0_7:emit(ChapterPreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_12,
					toggle = arg0_7._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_7._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0_7._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7._tf, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_LEVELUI
	})
	onNextTick(function()
		if arg0_7.exited then
			return
		end

		triggerToggle(arg0_7._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	end)
	setAnchoredPosition(arg0_7.topPanel, {
		y = arg0_7.topPanel.rect.height
	})
	onNextTick(function()
		arg0_7:uiStartAnimating()
	end)
	onButton(arg0_7, arg0_7:findTF("middle/gear_score/vanguard/SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip,
			weight = LayerWeightConst.SECOND_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._costTip, function()
		local var0_16 = arg0_7.chapter.fleet
		local var1_16 = arg0_7.chapter:getStageId(var0_16.line.row, var0_16.line.column)
		local var2_16, var3_16, var4_16 = arg0_7.chapter:isOverFleetCost(var0_16, var1_16)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("use_oil_limit_help", var4_16, var3_16),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end)
end

function var0_0.Register(arg0_17)
	arg0_17._formationLogic:AddHeroInfoModify(function(arg0_18, arg1_18, arg2_18)
		setAnchoredPosition(arg0_18, {
			x = 0,
			y = 0
		})
		SetActive(arg0_18, true)

		arg0_18.name = "info"

		local var0_18 = findTF(arg0_18, "info")
		local var1_18 = findTF(var0_18, "stars")
		local var2_18 = arg1_18:getEnergy() <= Ship.ENERGY_MID
		local var3_18 = findTF(var0_18, "energy")

		if var2_18 then
			local var4_18, var5_18 = arg1_18:getEnergyPrint()
			local var6_18 = GetSpriteFromAtlas("energy", var4_18)

			if not var6_18 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_18, var6_18)
		end

		setActive(var3_18, var2_18)

		local var7_18 = arg1_18:getStar()

		for iter0_18 = 1, var7_18 do
			cloneTplTo(arg0_17._starTpl, var1_18)
		end

		local var8_18 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_18:getShipType()))

		if not var8_18 then
			warning("找不到船形, shipConfigId: " .. arg1_18.configId)
		end

		setImageSprite(findTF(var0_18, "type"), var8_18, true)
		setText(findTF(var0_18, "frame/lv_contain/lv"), arg1_18.level)

		local var9_18 = findTF(var0_18, "blood")
		local var10_18 = findTF(var9_18, "fillarea/green")
		local var11_18 = findTF(var9_18, "fillarea/red")

		setActive(var10_18, arg1_18.hpRant >= ChapterConst.HpGreen)
		setActive(var11_18, arg1_18.hpRant < ChapterConst.HpGreen)

		;(arg1_18.hpRant >= ChapterConst.HpGreen and var10_18 or var11_18):GetComponent("Image").fillAmount = arg1_18.hpRant * 0.0001

		arg2_18:SetVisible(arg1_18.hpRant > 0)
		SetActive(arg0_18, arg1_18.hpRant > 0)

		local var12_18 = getProxy(ActivityProxy):getBuffShipList()[arg1_18:getGroupId()]
		local var13_18 = var0_18:Find("expbuff")

		setActive(var13_18, var12_18 ~= nil)

		if var12_18 then
			local var14_18 = var12_18 / 100
			local var15_18 = var12_18 % 100
			local var16_18 = tostring(var14_18)

			if var15_18 > 0 then
				var16_18 = var16_18 .. "." .. tostring(var15_18)
			end

			setText(var13_18:Find("text"), string.format("EXP +%s%%", var16_18))
		end
	end)
	arg0_17._formationLogic:AddShiftOnly(function(arg0_19)
		arg0_17:updateView(false)
	end)
	arg0_17._formationLogic:AddEndDrag(function()
		arg0_17:emit(ChapterPreCombatMediator.ON_SWITCH_SHIP, arg0_17.chapter.fleet)
	end)
	arg0_17._formationLogic:AddCheckRemove(function(arg0_21, arg1_21)
		arg0_21()
	end)
	arg0_17._formationLogic:AddCheckSwitch(function(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
		local var0_22 = arg3_22:getTeamByName(arg4_22)

		if arg3_22.ships[var0_22[arg2_22]].hpRant == 0 then
			return
		end

		arg0_22()
	end)
	arg0_17._formationLogic:AddCheckBeginDrag(function(arg0_23, arg1_23, arg2_23)
		return arg0_23.hpRant > 0
	end)
end

function var0_0.setPlayerInfo(arg0_24, arg1_24)
	return
end

function var0_0.updateChapter(arg0_25, arg1_25)
	arg0_25.chapter = arg1_25

	local var0_25 = arg0_25.chapter.fleet

	arg0_25._formationLogic:SetFleetVO(var0_25)

	local var1_25 = var0_25.ships

	arg0_25._formationLogic:SetShipVOs(var1_25)
	arg0_25:updateView(true)
end

function var0_0.setSubFlag(arg0_26, arg1_26)
	arg0_26.subUseable = arg1_26 or false
end

function var0_0.updateView(arg0_27, arg1_27)
	arg0_27._formationLogic:ResetGrid(TeamType.Vanguard, true)
	arg0_27._formationLogic:ResetGrid(TeamType.Main, true)
	SetActive(arg0_27._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if arg1_27 then
		local var0_27 = arg0_27.chapter.fleet
		local var1_27 = arg0_27.chapter:getStageId(var0_27.line.row, var0_27.line.column)

		arg0_27:updateStageView(var1_27)
		arg0_27._formationLogic:LoadAllCharacter()
	else
		arg0_27._formationLogic:SetAllCharacterPos()
	end

	arg0_27:updateBattleFleetView()
	arg0_27:updateStrategyIcon()
	arg0_27:displayFleetInfo()
end

function var0_0.updateStageView(arg0_28, arg1_28)
	local var0_28 = pg.expedition_data_template[arg1_28]

	assert(var0_28, "expedition_data_template not exist: " .. arg1_28)

	local var1_28 = var0_28.limit_type
	local var2_28 = var0_28.time_limit
	local var3_28 = var0_28.sink_limit
	local var4_28 = Clone(var0_28.award_display)
	local var5_28 = checkExist(pg.expedition_activity_template[arg1_28], {
		"pt_drop_display"
	})

	if var5_28 and type(var5_28) == "table" then
		local var6_28 = getProxy(ActivityProxy)

		for iter0_28 = #var5_28, 1, -1 do
			local var7_28 = var6_28:getActivityById(var5_28[iter0_28][1])

			if var7_28 and not var7_28:isEnd() then
				table.insert(var4_28, 1, {
					2,
					id2ItemId(var5_28[iter0_28][2])
				})
			end
		end
	end

	local var8_28 = UIItemList.New(arg0_28._spoilsContainer, arg0_28._item)

	var8_28:make(function(arg0_29, arg1_29, arg2_29)
		local var0_29 = arg2_29
		local var1_29 = var4_28[arg1_29 + 1]
		local var2_29 = {
			type = var1_29[1],
			id = var1_29[2]
		}

		updateDrop(var0_29, var2_29)
		onButton(arg0_28, var0_29, function()
			local var0_30 = Item.getConfigData(var1_29[2])

			if var0_30 and var2_0[var0_30.type] then
				local function var1_30(arg0_31)
					local var0_31 = var0_30.display_icon
					local var1_31 = {}

					for iter0_31, iter1_31 in ipairs(var0_31) do
						local var2_31 = iter1_31[1]
						local var3_31 = iter1_31[2]
						local var4_31 = var2_31 == DROP_TYPE_SHIP and not table.contains(arg0_31, var3_31)

						var1_31[#var1_31 + 1] = {
							type = var2_31,
							id = var3_31,
							anonymous = var4_31
						}
					end

					arg0_28:emit(var0_0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1_31,
						content = var0_30.display
					})
				end

				arg0_28:emit(ChapterPreCombatMediator.GET_CHAPTER_DROP_SHIP_LIST, arg0_28.chapter.id, var1_30)
			else
				arg0_28:emit(var0_0.ON_DROP, var2_29)
			end
		end, SFX_PANEL)
	end)
	var8_28:align(math.min(#var4_28, 6))

	local function var9_28(arg0_32, arg1_32)
		if type(arg0_32) == "table" then
			setActive(arg1_32, true)

			local var0_32 = i18n(PreCombatLayer.ObjectiveList[arg0_32[1]], arg0_32[2])

			setWidgetText(arg1_32, var0_32)
		else
			setActive(arg1_32, false)
		end
	end

	local var10_28 = {
		findTF(arg0_28._goals, "goal_tpl"),
		findTF(arg0_28._goals, "goal_sink"),
		findTF(arg0_28._goals, "goal_time")
	}
	local var11_28 = {
		var0_28.objective_1,
		var0_28.objective_2,
		var0_28.objective_3
	}
	local var12_28 = 1

	for iter1_28, iter2_28 in ipairs(var11_28) do
		if type(iter2_28) ~= "string" then
			var9_28(iter2_28, var10_28[var12_28])

			var12_28 = var12_28 + 1
		end
	end

	for iter3_28 = var12_28, #var10_28 do
		var9_28("", var10_28[iter3_28])
	end
end

function var0_0.updateBattleFleetView(arg0_33)
	local function var0_33(arg0_34, arg1_34)
		removeAllChildren(arg0_34)

		for iter0_34 = 1, 3 do
			if arg1_34[iter0_34] then
				local var0_34 = cloneTplTo(arg0_33._ship_tpl, arg0_34)

				updateShip(var0_34, arg1_34[iter0_34])

				local var1_34 = arg1_34[iter0_34].hpRant
				local var2_34 = findTF(var0_34, "blood")
				local var3_34 = findTF(var0_34, "blood/fillarea/green")
				local var4_34 = findTF(var0_34, "blood/fillarea/red")

				setActive(var3_34, var1_34 >= ChapterConst.HpGreen)
				setActive(var4_34, var1_34 < ChapterConst.HpGreen)

				;(var1_34 >= ChapterConst.HpGreen and var3_34 or var4_34):GetComponent("Image").fillAmount = var1_34 * 0.0001

				setActive(findTF(var0_34, "broken"), var1_34 == 0)
			end
		end
	end

	local var1_33 = arg0_33.chapter.fleet

	var0_33(arg0_33._fleet:Find("main"), var1_33:getShipsByTeam(TeamType.Main, true))
	var0_33(arg0_33._fleet:Find("vanguard"), var1_33:getShipsByTeam(TeamType.Vanguard, true))
end

function var0_0.displayFleetInfo(arg0_35)
	local var0_35 = arg0_35.chapter.fleet
	local var1_35 = arg0_35.chapter:getStageId(var0_35.line.row, var0_35.line.column)
	local var2_35 = var0_35:getCommanders()
	local var3_35 = _.reduce(var0_35:getShipsByTeam(TeamType.Vanguard, false), 0, function(arg0_36, arg1_36)
		return arg0_36 + arg1_36:getShipCombatPower(var2_35)
	end)
	local var4_35 = _.reduce(var0_35:getShipsByTeam(TeamType.Main, false), 0, function(arg0_37, arg1_37)
		return arg0_37 + arg1_37:getShipCombatPower(var2_35)
	end)
	local var5_35 = 0

	for iter0_35, iter1_35 in ipairs({
		arg0_35.chapter:getFleetCost(var0_35, var1_35)
	}) do
		var5_35 = var5_35 + iter1_35.oil
	end

	local var6_35 = arg0_35.chapter:isOverFleetCost(var0_35, var1_35)

	setActive(arg0_35._popup, true)
	setActive(arg0_35._costTip, var6_35)
	setTextColor(arg0_35._costText, var6_35 and Color(0.980392156862745, 0.392156862745098, 0.392156862745098) or Color.white)
	var1_0.tweenNumText(arg0_35._costText, var5_35)
	var1_0.tweenNumText(arg0_35._vanguardGS, var3_35)
	var1_0.tweenNumText(arg0_35._mainGS, var4_35)

	local var7_35, var8_35 = arg0_35.chapter:GetExtraCostRate()

	setActive(arg0_35._extraCostBuffIcon, #var8_35 > 0)

	for iter2_35, iter3_35 in ipairs(var8_35) do
		if iter3_35.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			setText(arg0_35._extraCostBuffIcon:Find("text_cost"), tonumber(iter3_35.benefit_effect) * 0.01 + 1)
		elseif iter3_35.benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setText(arg0_35._extraCostBuffIcon:Find("text_reward"), tonumber(iter3_35.benefit_effect) * 0.01 + 1)
		elseif iter3_35.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			onButton(arg0_35, arg0_35._extraCostBuffIcon, function()
				local var0_38 = tonumber(iter3_35.benefit_condition)
				local var1_38 = pg.strategy_data_template[iter3_35.id]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0_38
					},
					intro = var1_38.desc,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end
	end

	local var9_35 = arg0_35:findTF("middle/gear_score/vanguard")
	local var10_35 = ChapterFleet.StaticTransformChapterFleet2Fleet(var0_35):GetFleetSonarRange()

	setActive(var9_35:Find("SonarActive"), var10_35 > 0)
	setActive(var9_35:Find("SonarInactive"), var10_35 <= 0)

	if var10_35 > 0 then
		setText(var9_35:Find("SonarActive/Text"), math.floor(var10_35))
	end
end

function var0_0.updateStrategyIcon(arg0_39)
	local var0_39 = arg0_39.chapter.fleet:getStrategies()
	local var1_39 = _.detect(var0_39, function(arg0_40)
		return arg0_40.id == ChapterConst.StrategyRepair
	end)
	local var2_39 = pg.strategy_data_template[var1_39.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var2_39.icon, "", arg0_39._strategy:Find("icon"))
	onButton(arg0_39, arg0_39._strategy, function()
		arg0_39:displayStrategyInfo(var1_39)
	end, SFX_PANEL)
	setText(arg0_39._strategy:Find("nums"), var1_39.count)
	setActive(arg0_39._strategy:Find("mask"), var1_39.count == 0)
	setActive(arg0_39._strategy:Find("selected"), false)

	local var3_39 = arg0_39:findTF("middle/formation_list")
	local var4_39 = findTF(var3_39, "formation")

	setActive(var4_39, false)

	local var5_39 = ChapterConst.StrategyForms
	local var6_39 = {}
	local var7_39 = arg0_39.chapter.fleet:getFormationStg()

	table.insert(var6_39, 1, {
		id = var7_39
	})

	local var8_39 = UIItemList.New(var3_39, var4_39)

	var8_39:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = var6_39[arg1_42 + 1]
			local var1_42 = pg.strategy_data_template[var0_42.id]

			if var1_42.type ~= ChapterConst.StgTypeForm then
				return
			end

			GetImageSpriteFromAtlasAsync("strategyicon/" .. var1_42.icon, "", arg2_42:Find("icon"))
			onButton(arg0_39, arg2_42, function()
				if var1_42.type == ChapterConst.StgTypeForm then
					local var0_43 = arg0_39.chapter.fleet:getNextStgUser(var0_42.id)
					local var1_43 = table.indexof(var5_39, var0_42.id)

					arg0_39:emit(ChapterPreCombatMediator.ON_OP, {
						type = ChapterConst.OpStrategy,
						id = var0_43,
						arg1 = var5_39[var1_43 % #var5_39 + 1]
					})
				end
			end, SFX_PANEL)
			setText(arg2_42:Find("nums"), "")
			setActive(arg2_42:Find("mask"), false)
			setActive(arg2_42:Find("selected"), false)
		end
	end)
	var8_39:align(#var6_39)
end

function var0_0.displayStrategyInfo(arg0_44, arg1_44)
	arg0_44.strategyPanel = arg0_44.strategyPanel or StrategyPanel.New(arg0_44.strategyInfo)

	arg0_44.strategyPanel:attach(arg0_44)
	arg0_44.strategyPanel:set(arg1_44)
	pg.UIMgr.GetInstance():BlurPanel(arg0_44.strategyPanel._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	function arg0_44.strategyPanel.onConfirm()
		local var0_45 = arg0_44.chapter.fleet
		local var1_45 = pg.strategy_data_template[arg1_44.id]

		if not var0_45:canUseStrategy(arg1_44) then
			return
		end

		local var2_45 = var0_45:getNextStgUser(arg1_44.id)

		arg0_44:emit(ChapterPreCombatMediator.ON_OP, {
			type = ChapterConst.OpStrategy,
			id = var2_45,
			arg1 = arg1_44.id
		})
		arg0_44:hideStrategyInfo()
	end

	function arg0_44.strategyPanel.onCancel()
		arg0_44:hideStrategyInfo()
	end
end

function var0_0.hideStrategyInfo(arg0_47)
	if arg0_47.strategyPanel then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_47.strategyPanel._tf)
		arg0_47.strategyPanel:detach()
	end
end

function var0_0.onBackPressed(arg0_48)
	if arg0_48.strategyPanel and arg0_48.strategyPanel._go and isActive(arg0_48.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_48:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_48._backBtn)
	end
end

function var0_0.willExit(arg0_49)
	if arg0_49.strategyPanel and arg0_49.strategyPanel._go and isActive(arg0_49.strategyPanel._go) then
		arg0_49:hideStrategyInfo()
	end

	arg0_49._formationLogic:Destroy()

	arg0_49._formationLogic = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49._tf)
end

return var0_0
