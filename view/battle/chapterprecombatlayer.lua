local var0 = class("ChapterPreCombatLayer", import("..base.BaseUI"))
local var1 = import("..ship.FormationUI")
local var2 = {
	[99] = true
}

function var0.getUIName(arg0)
	return "ChapterPreCombatUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.init(arg0)
	arg0._startBtn = arg0:findTF("right/start")
	arg0._popup = arg0:findTF("right/popup")
	arg0._costText = arg0:findTF("right/popup/Text")
	arg0._costTip = arg0:findTF("right/popup/tip")
	arg0._extraCostBuffIcon = arg0:findTF("right/operation_buff_icon")
	arg0._backBtn = arg0:findTF("top/back_btn")
	arg0._moveLayer = arg0:findTF("moveLayer")

	local var0 = arg0:findTF("middle")

	arg0._mainGS = var0:Find("gear_score/main/Text")
	arg0._vanguardGS = var0:Find("gear_score/vanguard/Text")

	setText(arg0._mainGS, 0)
	setText(arg0._vanguardGS, 0)

	arg0._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0._gridFrame = var0:Find("mask/GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
	end

	arg0._heroContainer = var0:Find("HeroContainer")
	arg0._strategy = var0:Find("strategy")

	setActive(arg0._strategy, true)

	arg0._spoilsContainer = arg0:findTF("right/infomation/spoils/items/items_container")
	arg0._goals = arg0:findTF("right/infomation/goal")
	arg0._item = arg0:getTpl("right/infomation/spoils/items/item_tpl")
	arg0._heroInfo = arg0:getTpl("heroInfo")
	arg0._starTpl = arg0:getTpl("star_tpl")
	arg0._middle = arg0:findTF("middle")
	arg0._right = arg0:findTF("right")
	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfo, arg0._gridTFs)

	local var1 = {
		Shift = function(arg0, arg1, arg2)
			return
		end
	}

	setmetatable(var1, arg0._formationLogic)
	setText(findTF(arg0._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))

	arg0._fleet = arg0:findTF("middle/fleet")

	setText(findTF(arg0._fleet, "title_bg/Text"), i18n("pre_combat_team"))

	arg0._ship_tpl = findTF(arg0._fleet, "shiptpl")
	arg0._empty_tpl = findTF(arg0._fleet, "emptytpl")

	setActive(arg0._ship_tpl, false)
	setActive(arg0._empty_tpl, false)

	arg0._autoToggle = arg0:findTF("middle/auto_toggle")
	arg0._autoSubToggle = arg0:findTF("middle/sub_toggle_container/sub_toggle")
	arg0.topPanel = arg0:findTF("top")
	arg0.strategyInfo = arg0:findTF("strategy_info")

	setActive(arg0.strategyInfo, false)

	arg0._operaionBuffTips = arg0._extraCostBuffIcon:Find("popup")

	setAnchoredPosition(arg0._middle, {
		x = -840
	})
	setAnchoredPosition(arg0._right, {
		x = 470
	})
	arg0:Register()
end

function var0.uiStartAnimating(arg0)
	setAnchoredPosition(arg0.topPanel, {
		y = 100
	})

	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0._middle, 0, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 0, nil, var1, var0, true, true, nil)
	shiftPanel(arg0.topPanel, nil, 0, var1, var0, true, true, nil, nil)
end

function var0.uiExitAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0._middle, -840, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 470, nil, var1, var0, true, true)
	shiftPanel(arg0.topPanel, nil, arg0.topPanel.rect.height, var1, var0, true, true, nil, nil)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0:emit(var0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onButton(arg0, arg0._startBtn, function()
		arg0:emit(ChapterPreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onToggle(arg0, arg0._autoToggle, function(arg0)
		arg0:emit(ChapterPreCombatMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoToggle
		})

		if arg0 and arg0.subUseable == true then
			setActive(arg0._autoSubToggle, true)
			onToggle(arg0, arg0._autoSubToggle, function(arg0)
				arg0:emit(ChapterPreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0,
					toggle = arg0._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_LEVELUI
	})
	onNextTick(function()
		if arg0.exited then
			return
		end

		triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	end)
	setAnchoredPosition(arg0.topPanel, {
		y = arg0.topPanel.rect.height
	})
	onNextTick(function()
		arg0:uiStartAnimating()
	end)
	onButton(arg0, arg0:findTF("middle/gear_score/vanguard/SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip,
			weight = LayerWeightConst.SECOND_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._costTip, function()
		local var0 = arg0.chapter.fleet
		local var1 = arg0.chapter:getStageId(var0.line.row, var0.line.column)
		local var2, var3, var4 = arg0.chapter:isOverFleetCost(var0, var1)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("use_oil_limit_help", var4, var3),
			weight = LayerWeightConst.SECOND_LAYER
		})
	end)
end

function var0.Register(arg0)
	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1, arg2)
		setAnchoredPosition(arg0, {
			x = 0,
			y = 0
		})
		SetActive(arg0, true)

		arg0.name = "info"

		local var0 = findTF(arg0, "info")
		local var1 = findTF(var0, "stars")
		local var2 = arg1:getEnergy() <= Ship.ENERGY_MID
		local var3 = findTF(var0, "energy")

		if var2 then
			local var4, var5 = arg1:getEnergyPrint()
			local var6 = GetSpriteFromAtlas("energy", var4)

			if not var6 then
				warning("找不到疲劳")
			end

			setImageSprite(var3, var6)
		end

		setActive(var3, var2)

		local var7 = arg1:getStar()

		for iter0 = 1, var7 do
			cloneTplTo(arg0._starTpl, var1)
		end

		local var8 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var8 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var0, "type"), var8, true)
		setText(findTF(var0, "frame/lv_contain/lv"), arg1.level)

		local var9 = findTF(var0, "blood")
		local var10 = findTF(var9, "fillarea/green")
		local var11 = findTF(var9, "fillarea/red")

		setActive(var10, arg1.hpRant >= ChapterConst.HpGreen)
		setActive(var11, arg1.hpRant < ChapterConst.HpGreen)

		;(arg1.hpRant >= ChapterConst.HpGreen and var10 or var11):GetComponent("Image").fillAmount = arg1.hpRant * 0.0001

		arg2:SetVisible(arg1.hpRant > 0)
		SetActive(arg0, arg1.hpRant > 0)

		local var12 = getProxy(ActivityProxy):getBuffShipList()[arg1:getGroupId()]
		local var13 = var0:Find("expbuff")

		setActive(var13, var12 ~= nil)

		if var12 then
			local var14 = var12 / 100
			local var15 = var12 % 100
			local var16 = tostring(var14)

			if var15 > 0 then
				var16 = var16 .. "." .. tostring(var15)
			end

			setText(var13:Find("text"), string.format("EXP +%s%%", var16))
		end
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:updateView(false)
	end)
	arg0._formationLogic:AddEndDrag(function()
		arg0:emit(ChapterPreCombatMediator.ON_SWITCH_SHIP, arg0.chapter.fleet)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1)
		arg0()
	end)
	arg0._formationLogic:AddCheckSwitch(function(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg3:getTeamByName(arg4)

		if arg3.ships[var0[arg2]].hpRant == 0 then
			return
		end

		arg0()
	end)
	arg0._formationLogic:AddCheckBeginDrag(function(arg0, arg1, arg2)
		return arg0.hpRant > 0
	end)
end

function var0.setPlayerInfo(arg0, arg1)
	return
end

function var0.updateChapter(arg0, arg1)
	arg0.chapter = arg1

	local var0 = arg0.chapter.fleet

	arg0._formationLogic:SetFleetVO(var0)

	local var1 = var0.ships

	arg0._formationLogic:SetShipVOs(var1)
	arg0:updateView(true)
end

function var0.setSubFlag(arg0, arg1)
	arg0.subUseable = arg1 or false
end

function var0.updateView(arg0, arg1)
	arg0._formationLogic:ResetGrid(TeamType.Vanguard, true)
	arg0._formationLogic:ResetGrid(TeamType.Main, true)
	SetActive(arg0._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if arg1 then
		local var0 = arg0.chapter.fleet
		local var1 = arg0.chapter:getStageId(var0.line.row, var0.line.column)

		arg0:updateStageView(var1)
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end

	arg0:updateBattleFleetView()
	arg0:updateStrategyIcon()
	arg0:displayFleetInfo()
end

function var0.updateStageView(arg0, arg1)
	local var0 = pg.expedition_data_template[arg1]

	assert(var0, "expedition_data_template not exist: " .. arg1)

	local var1 = var0.limit_type
	local var2 = var0.time_limit
	local var3 = var0.sink_limit
	local var4 = Clone(var0.award_display)
	local var5 = checkExist(pg.expedition_activity_template[arg1], {
		"pt_drop_display"
	})

	if var5 and type(var5) == "table" then
		local var6 = getProxy(ActivityProxy)

		for iter0 = #var5, 1, -1 do
			local var7 = var6:getActivityById(var5[iter0][1])

			if var7 and not var7:isEnd() then
				table.insert(var4, 1, {
					2,
					id2ItemId(var5[iter0][2])
				})
			end
		end
	end

	local var8 = UIItemList.New(arg0._spoilsContainer, arg0._item)

	var8:make(function(arg0, arg1, arg2)
		local var0 = arg2
		local var1 = var4[arg1 + 1]
		local var2 = {
			type = var1[1],
			id = var1[2]
		}

		updateDrop(var0, var2)
		onButton(arg0, var0, function()
			local var0 = Item.getConfigData(var1[2])

			if var0 and var2[var0.type] then
				local function var1(arg0)
					local var0 = var0.display_icon
					local var1 = {}

					for iter0, iter1 in ipairs(var0) do
						local var2 = iter1[1]
						local var3 = iter1[2]
						local var4 = var2 == DROP_TYPE_SHIP and not table.contains(arg0, var3)

						var1[#var1 + 1] = {
							type = var2,
							id = var3,
							anonymous = var4
						}
					end

					arg0:emit(var0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var1,
						content = var0.display
					})
				end

				arg0:emit(ChapterPreCombatMediator.GET_CHAPTER_DROP_SHIP_LIST, arg0.chapter.id, var1)
			else
				arg0:emit(var0.ON_DROP, var2)
			end
		end, SFX_PANEL)
	end)
	var8:align(math.min(#var4, 6))

	local function var9(arg0, arg1)
		if type(arg0) == "table" then
			setActive(arg1, true)

			local var0 = i18n(PreCombatLayer.ObjectiveList[arg0[1]], arg0[2])

			setWidgetText(arg1, var0)
		else
			setActive(arg1, false)
		end
	end

	local var10 = {
		findTF(arg0._goals, "goal_tpl"),
		findTF(arg0._goals, "goal_sink"),
		findTF(arg0._goals, "goal_time")
	}
	local var11 = {
		var0.objective_1,
		var0.objective_2,
		var0.objective_3
	}
	local var12 = 1

	for iter1, iter2 in ipairs(var11) do
		if type(iter2) ~= "string" then
			var9(iter2, var10[var12])

			var12 = var12 + 1
		end
	end

	for iter3 = var12, #var10 do
		var9("", var10[iter3])
	end
end

function var0.updateBattleFleetView(arg0)
	local function var0(arg0, arg1)
		removeAllChildren(arg0)

		for iter0 = 1, 3 do
			if arg1[iter0] then
				local var0 = cloneTplTo(arg0._ship_tpl, arg0)

				updateShip(var0, arg1[iter0])

				local var1 = arg1[iter0].hpRant
				local var2 = findTF(var0, "blood")
				local var3 = findTF(var0, "blood/fillarea/green")
				local var4 = findTF(var0, "blood/fillarea/red")

				setActive(var3, var1 >= ChapterConst.HpGreen)
				setActive(var4, var1 < ChapterConst.HpGreen)

				;(var1 >= ChapterConst.HpGreen and var3 or var4):GetComponent("Image").fillAmount = var1 * 0.0001

				setActive(findTF(var0, "broken"), var1 == 0)
			end
		end
	end

	local var1 = arg0.chapter.fleet

	var0(arg0._fleet:Find("main"), var1:getShipsByTeam(TeamType.Main, true))
	var0(arg0._fleet:Find("vanguard"), var1:getShipsByTeam(TeamType.Vanguard, true))
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0.chapter.fleet
	local var1 = arg0.chapter:getStageId(var0.line.row, var0.line.column)
	local var2 = var0:getCommanders()
	local var3 = _.reduce(var0:getShipsByTeam(TeamType.Vanguard, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower(var2)
	end)
	local var4 = _.reduce(var0:getShipsByTeam(TeamType.Main, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower(var2)
	end)
	local var5 = 0

	for iter0, iter1 in ipairs({
		arg0.chapter:getFleetCost(var0, var1)
	}) do
		var5 = var5 + iter1.oil
	end

	local var6 = arg0.chapter:isOverFleetCost(var0, var1)

	setActive(arg0._popup, true)
	setActive(arg0._costTip, var6)
	setTextColor(arg0._costText, var6 and Color(0.980392156862745, 0.392156862745098, 0.392156862745098) or Color.white)
	var1.tweenNumText(arg0._costText, var5)
	var1.tweenNumText(arg0._vanguardGS, var3)
	var1.tweenNumText(arg0._mainGS, var4)

	local var7, var8 = arg0.chapter:GetExtraCostRate()

	setActive(arg0._extraCostBuffIcon, #var8 > 0)

	for iter2, iter3 in ipairs(var8) do
		if iter3.benefit_type == Chapter.OPERATION_BUFF_TYPE_COST then
			setText(arg0._extraCostBuffIcon:Find("text_cost"), tonumber(iter3.benefit_effect) * 0.01 + 1)
		elseif iter3.benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setText(arg0._extraCostBuffIcon:Find("text_reward"), tonumber(iter3.benefit_effect) * 0.01 + 1)
		elseif iter3.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			onButton(arg0, arg0._extraCostBuffIcon, function()
				local var0 = tonumber(iter3.benefit_condition)
				local var1 = pg.strategy_data_template[iter3.id]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					type = MSGBOX_TYPE_SINGLE_ITEM,
					drop = {
						count = 1,
						type = DROP_TYPE_ITEM,
						id = var0
					},
					intro = var1.desc,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end
	end

	local var9 = arg0:findTF("middle/gear_score/vanguard")
	local var10 = ChapterFleet.StaticTransformChapterFleet2Fleet(var0):GetFleetSonarRange()

	setActive(var9:Find("SonarActive"), var10 > 0)
	setActive(var9:Find("SonarInactive"), var10 <= 0)

	if var10 > 0 then
		setText(var9:Find("SonarActive/Text"), math.floor(var10))
	end
end

function var0.updateStrategyIcon(arg0)
	local var0 = arg0.chapter.fleet:getStrategies()
	local var1 = _.detect(var0, function(arg0)
		return arg0.id == ChapterConst.StrategyRepair
	end)
	local var2 = pg.strategy_data_template[var1.id]

	GetImageSpriteFromAtlasAsync("strategyicon/" .. var2.icon, "", arg0._strategy:Find("icon"))
	onButton(arg0, arg0._strategy, function()
		arg0:displayStrategyInfo(var1)
	end, SFX_PANEL)
	setText(arg0._strategy:Find("nums"), var1.count)
	setActive(arg0._strategy:Find("mask"), var1.count == 0)
	setActive(arg0._strategy:Find("selected"), false)

	local var3 = arg0:findTF("middle/formation_list")
	local var4 = findTF(var3, "formation")

	setActive(var4, false)

	local var5 = ChapterConst.StrategyForms
	local var6 = {}
	local var7 = arg0.chapter.fleet:getFormationStg()

	table.insert(var6, 1, {
		id = var7
	})

	local var8 = UIItemList.New(var3, var4)

	var8:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var6[arg1 + 1]
			local var1 = pg.strategy_data_template[var0.id]

			if var1.type ~= ChapterConst.StgTypeForm then
				return
			end

			GetImageSpriteFromAtlasAsync("strategyicon/" .. var1.icon, "", arg2:Find("icon"))
			onButton(arg0, arg2, function()
				if var1.type == ChapterConst.StgTypeForm then
					local var0 = arg0.chapter.fleet:getNextStgUser(var0.id)
					local var1 = table.indexof(var5, var0.id)

					arg0:emit(ChapterPreCombatMediator.ON_OP, {
						type = ChapterConst.OpStrategy,
						id = var0,
						arg1 = var5[var1 % #var5 + 1]
					})
				end
			end, SFX_PANEL)
			setText(arg2:Find("nums"), "")
			setActive(arg2:Find("mask"), false)
			setActive(arg2:Find("selected"), false)
		end
	end)
	var8:align(#var6)
end

function var0.displayStrategyInfo(arg0, arg1)
	arg0.strategyPanel = arg0.strategyPanel or StrategyPanel.New(arg0.strategyInfo)

	arg0.strategyPanel:attach(arg0)
	arg0.strategyPanel:set(arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0.strategyPanel._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	function arg0.strategyPanel.onConfirm()
		local var0 = arg0.chapter.fleet
		local var1 = pg.strategy_data_template[arg1.id]

		if not var0:canUseStrategy(arg1) then
			return
		end

		local var2 = var0:getNextStgUser(arg1.id)

		arg0:emit(ChapterPreCombatMediator.ON_OP, {
			type = ChapterConst.OpStrategy,
			id = var2,
			arg1 = arg1.id
		})
		arg0:hideStrategyInfo()
	end

	function arg0.strategyPanel.onCancel()
		arg0:hideStrategyInfo()
	end
end

function var0.hideStrategyInfo(arg0)
	if arg0.strategyPanel then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.strategyPanel._tf)
		arg0.strategyPanel:detach()
	end
end

function var0.onBackPressed(arg0)
	if arg0.strategyPanel and arg0.strategyPanel._go and isActive(arg0.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0._backBtn)
	end
end

function var0.willExit(arg0)
	if arg0.strategyPanel and arg0.strategyPanel._go and isActive(arg0.strategyPanel._go) then
		arg0:hideStrategyInfo()
	end

	arg0._formationLogic:Destroy()

	arg0._formationLogic = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
