local var0_0 = class("WorldPreCombatLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")
local var2_0 = {
	[99] = true
}

function var0_0.getUIName(arg0_1)
	return "WorldPreCombatUI"
end

function var0_0.init(arg0_2)
	arg0_2.eventTriggers = {}
	arg0_2.middle = arg0_2:findTF("middle")
	arg0_2.right = arg0_2:findTF("right")
	arg0_2.top = arg0_2:findTF("top")
	arg0_2.moveLayer = arg0_2:findTF("moveLayer")
	arg0_2.backBtn = arg0_2.top:Find("back_btn")
	arg0_2.playerResOb = arg0_2.top:Find("playerRes")
	arg0_2.resPanel = WorldResource.New()

	tf(arg0_2.resPanel._go):SetParent(tf(arg0_2.playerResOb), false)

	arg0_2.strategyInfo = arg0_2:findTF("strategy_info", arg0_2.top)

	setActive(arg0_2.strategyInfo, false)

	arg0_2.mainGS = arg0_2.middle:Find("gear_score/main/Text")
	arg0_2.vanguardGS = arg0_2.middle:Find("gear_score/vanguard/Text")

	setText(arg0_2.mainGS, 0)
	setText(arg0_2.vanguardGS, 0)

	arg0_2.gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0_2.gridFrame = arg0_2.middle:Find("mask/GridFrame")

	for iter0_2 = 1, 3 do
		arg0_2.gridTFs[TeamType.Vanguard][iter0_2] = arg0_2.gridFrame:Find("vanguard_" .. iter0_2)
		arg0_2.gridTFs[TeamType.Main][iter0_2] = arg0_2.gridFrame:Find("main_" .. iter0_2)
	end

	arg0_2.heroContainer = arg0_2.middle:Find("HeroContainer")
	arg0_2.strategy = arg0_2.middle:Find("strategy")

	setActive(arg0_2.strategy, false)

	arg0_2.fleet = arg0_2:findTF("middle/fleet")
	arg0_2.ship_tpl = findTF(arg0_2.fleet, "shiptpl")
	arg0_2.empty_tpl = findTF(arg0_2.fleet, "emptytpl")

	setActive(arg0_2.ship_tpl, false)
	setActive(arg0_2.empty_tpl, false)

	arg0_2.autoToggle = arg0_2.right:Find("auto_toggle")
	arg0_2.autoSubToggle = arg0_2.right:Find("sub_toggle_container/sub_toggle")
	arg0_2.startBtn = arg0_2.right:Find("start")
	arg0_2.infoBtn = arg0_2.right:Find("information")
	arg0_2.heroInfo = arg0_2:getTpl("heroInfo")
	arg0_2.starTpl = arg0_2:getTpl("star_tpl")
	arg0_2.energyDescTF = arg0_2:findTF("energy_desc")
	arg0_2.energyDescTextTF = arg0_2:findTF("energy_desc/Text")
	arg0_2.normaltab = arg0_2.right:Find("normal")
	arg0_2.informationtab = arg0_2.right:Find("infomation")
	arg0_2.buffInfo = arg0_2.normaltab:Find("buff")
	arg0_2.bossInfo = arg0_2.normaltab:Find("boss")
	arg0_2.spoilsContainer = arg0_2.normaltab:Find("spoils/items/items_container")
	arg0_2.spoilsItem = arg0_2.normaltab:Find("spoils/items/item_tpl")
	arg0_2.digits = arg0_2.Clone2Full(arg0_2.informationtab:Find("target/simple/digits"), 3)
	arg0_2.digitExtras = arg0_2.Clone2Full(arg0_2.informationtab:Find("target/detail"), 3)
	arg0_2.dropright = arg0_2.informationtab:Find("spoils/right")
	arg0_2.dropleft = arg0_2.informationtab:Find("spoils/left")
	arg0_2.dropitems = arg0_2.Clone2Full(arg0_2.informationtab:Find("spoils/items_container"), 3)

	setActive(arg0_2.informationtab:Find("target/simple"), true)
	setActive(arg0_2.informationtab:Find("target/detail"), false)

	for iter1_2 = 1, #arg0_2.digitExtras do
		local var0_2 = arg0_2.digitExtras[iter1_2]

		setText(var0_2:Find("desc"), i18n("world_mapbuff_compare_txt") .. "：")
	end
end

function var0_0.uiStartAnimating(arg0_3)
	setAnchoredPosition(arg0_3.middle, {
		x = -840
	})
	setAnchoredPosition(arg0_3.right, {
		x = 470
	})
	setAnchoredPosition(arg0_3.top, {
		y = arg0_3.top.rect.height
	})

	local var0_3 = 0
	local var1_3 = 0.3

	shiftPanel(arg0_3.middle, 0, nil, var1_3, var0_3, true, true)
	shiftPanel(arg0_3.right, 0, nil, var1_3, var0_3, true, true, nil)
	shiftPanel(arg0_3.top, nil, 0, var1_3, var0_3, true, true, nil, nil)
end

function var0_0.uiExitAnimating(arg0_4)
	local var0_4 = 0
	local var1_4 = 0.3

	shiftPanel(arg0_4.middle, -840, nil, var1_4, var0_4, true, true)
	shiftPanel(arg0_4.right, 470, nil, var1_4, var0_4, true, true)
	shiftPanel(arg0_4.top, nil, arg0_4.top.rect.height, var1_4, var0_4, true, true, nil, nil)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		GetOrAddComponent(arg0_5._tf, typeof(CanvasGroup)).interactable = false

		arg0_5:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_5:emit(var0_0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onToggle(arg0_5, arg0_5.autoToggle, function(arg0_8)
		arg0_5:emit(WorldPreCombatMediator.OnAuto, {
			isOn = not arg0_8,
			toggle = arg0_5.autoToggle
		})

		if arg0_8 and nowWorld():GetSubAidFlag() then
			setActive(arg0_5.autoSubToggle, true)
			onToggle(arg0_5, arg0_5.autoSubToggle, function(arg0_9)
				arg0_5:emit(WorldPreCombatMediator.OnSubAuto, {
					isOn = not arg0_9,
					toggle = arg0_5.autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_5.autoSubToggle, ys.Battle.BattleState.IsAutoSubActive(SYSTEM_WORLD))
		else
			setActive(arg0_5.autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf)
	arg0_5:updateCharacters()
	arg0_5:updateStageView()
	triggerToggle(arg0_5.autoToggle, ys.Battle.BattleState.IsAutoBotActive(SYSTEM_WORLD))

	local var0_5 = arg0_5:GetCurrentAttachment()
	local var1_5 = var0_5:GetBattleStageId()
	local var2_5 = pg.expedition_data_template[var1_5]

	assert(var2_5, "expedition_data_template not exist: " .. var1_5)

	local var3_5 = pg.world_expedition_data[var1_5]
	local var4_5 = var3_5 and var3_5.battle_type and var3_5.battle_type ~= 0

	onNextTick(function()
		arg0_5:uiStartAnimating()
	end)

	arg0_5.contextData.entetagain = true

	setActive(arg0_5.infoBtn, var4_5)
	onButton(arg0_5, arg0_5.infoBtn, function()
		arg0_5:emit(WorldPreCombatMediator.OnOpenSublayer, Context.New({
			mediator = WorldBossInformationMediator,
			viewComponent = WorldBossInformationLayer
		}), true, function()
			arg0_5:closeView()
		end)
	end)
	onButton(arg0_5, arg0_5.startBtn, function()
		arg0_5:emit(WorldPreCombatMediator.OnStartBattle, var0_5:GetBattleStageId(), arg0_5:getCurrentFleet(), var0_5)
	end, SFX_UI_WEIGHANCHOR)
end

function var0_0.onBackPressed(arg0_14)
	if arg0_14.strategyPanel and arg0_14.strategyPanel._go and isActive(arg0_14.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_14:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_14.backBtn)
	end
end

function var0_0.setPlayerInfo(arg0_15, arg1_15)
	arg0_15.resPanel:setPlayer(arg1_15)
	setActive(arg0_15.resPanel._tf, nowWorld():IsSystemOpen(WorldConst.SystemResource))
end

function var0_0.getCurrentFleet(arg0_16)
	return nowWorld():GetFleet()
end

function var0_0.GetCurrentAttachment(arg0_17)
	local var0_17 = nowWorld():GetActiveMap()
	local var1_17 = var0_17:GetFleet()

	return var0_17:GetCell(var1_17.row, var1_17.column):GetAliveAttachment(), var0_17.config.difficulty
end

function var0_0.updateStageView(arg0_18)
	setActive(arg0_18.normaltab, false)
	setActive(arg0_18.informationtab, true)
	arg0_18:UpdateInformationtab()
end

function var0_0.UpdateNormaltab(arg0_19)
	local var0_19, var1_19 = arg0_19:GetCurrentAttachment()
	local var2_19 = var0_19:GetBattleStageId()
	local var3_19 = pg.world_expedition_data[var2_19]
	local var4_19 = {}

	for iter0_19, iter1_19 in ipairs(var3_19.award_display_world) do
		if var1_19 == iter1_19[1] then
			var4_19 = iter1_19[2]
		end
	end

	local var5_19 = UIItemList.New(arg0_19.spoilsContainer, arg0_19.spoilsItem)

	var5_19:make(function(arg0_20, arg1_20, arg2_20)
		local var0_20 = arg2_20
		local var1_20 = var4_19[arg1_20 + 1]
		local var2_20 = {
			type = var1_20[1],
			id = var1_20[2]
		}

		updateDrop(var0_20, var2_20)
		onButton(arg0_19, var0_20, function()
			arg0_19:emit(var0_0.ON_DROP, var2_20)
		end, SFX_PANEL)
	end)
	var5_19:align(#var4_19)
end

local var3_0 = "fe2222"
local var4_0 = "92fc63"

function var0_0.UpdateInformationtab(arg0_22)
	local var0_22, var1_22 = arg0_22:GetCurrentAttachment()
	local var2_22 = var0_22:GetBattleStageId()
	local var3_22 = pg.world_expedition_data[var2_22]

	assert(var3_22, "world_expedition_data not exist: " .. var2_22)

	local var4_22 = {}

	for iter0_22, iter1_22 in ipairs(var3_22.award_display_world) do
		if var1_22 == iter1_22[1] then
			var4_22 = iter1_22[2]
		end
	end

	local var5_22 = 0

	local function var6_22()
		for iter0_23 = 1, #arg0_22.dropitems do
			local var0_23 = arg0_22.dropitems[iter0_23]:Find("item_tpl")
			local var1_23 = var4_22[iter0_23 + var5_22]

			setActive(var0_23, var1_23 ~= nil)

			if var1_23 then
				local var2_23 = {
					type = var1_23[1],
					id = var1_23[2]
				}

				updateDrop(var0_23, var2_23)
				setScrollText(var0_23:Find("ScrollMask/DropName"), var2_23:getConfig("name"))
				onButton(arg0_22, var0_23, function()
					arg0_22:emit(var0_0.ON_DROP, var2_23)
				end, SFX_PANEL)
			end
		end

		setActive(arg0_22.dropleft, var5_22 > 0)
		setActive(arg0_22.dropright, #var4_22 - var5_22 > #arg0_22.dropitems)
	end

	onButton(arg0_22, arg0_22.dropright, function()
		var5_22 = var5_22 + 1

		var6_22()
	end)
	onButton(arg0_22, arg0_22.dropleft, function()
		var5_22 = var5_22 - 1

		var6_22()
	end)
	var6_22()

	local var7_22 = nowWorld()
	local var8_22 = ys.Battle.BattleFormulas
	local var9_22 = var7_22:GetWorldMapDifficultyBuffLevel()
	local var10_22 = {
		var9_22[1] * (1 + var3_22.expedition_sairenvalueA / 10000),
		var9_22[2] * (1 + var3_22.expedition_sairenvalueB / 10000),
		var9_22[3] * (1 + var3_22.expedition_sairenvalueC / 10000)
	}
	local var11_22 = var7_22:GetWorldMapBuffLevel()
	local var12_22, var13_22, var14_22 = var8_22.WorldMapRewardAttrEnhance(var10_22, var11_22)
	local var15_22 = 1 - var8_22.WorldMapRewardHealingRate(var10_22, var11_22)
	local var16_22 = {
		var12_22,
		var13_22,
		var15_22
	}

	for iter2_22 = 1, #arg0_22.digits do
		local var17_22 = arg0_22.digits[iter2_22]

		setText(var17_22:Find("digit"), string.format("%d", var10_22[iter2_22]))

		local var18_22 = iter2_22 == 3 and 1 - var16_22[iter2_22] or var16_22[iter2_22] + 1

		setText(var17_22:Find("desc"), i18n("world_mapbuff_attrtxt_" .. iter2_22) .. string.format("%3d%%", var18_22 * 100))
	end

	for iter3_22 = 1, #arg0_22.digitExtras do
		local var19_22 = arg0_22.digitExtras[iter3_22]

		setText(var19_22:Find("enemy"), string.format("%d", var10_22[iter3_22]))
		setText(var19_22:Find("ally"), string.format("%d", var11_22[iter3_22]))
		setText(var19_22:Find("result"), string.format("%d%%", var16_22[iter3_22] * 100))
		setTextColor(var19_22:Find("result"), var16_22[iter3_22] > 0 and arg0_22.TransformColor(var3_0) or arg0_22.TransformColor(var4_0))
		setText(var19_22:Find("result/arrow"), var16_22[iter3_22] == 0 and "" or var16_22[iter3_22] > 0 and "↑" or "↓")

		if var16_22[iter3_22] ~= 0 then
			setTextColor(var19_22:Find("result/arrow"), var16_22[iter3_22] > 0 and arg0_22.TransformColor(var3_0) or arg0_22.TransformColor(var4_0))
		end
	end

	onButton(arg0_22, arg0_22.informationtab:Find("target/bg"), function()
		local var0_27 = arg0_22.informationtab:Find("target/simple")
		local var1_27 = arg0_22.informationtab:Find("target/detail")
		local var2_27 = go(var0_27).activeSelf

		setActive(var0_27, not var2_27)
		setActive(var1_27, var2_27)
	end, SFX_PANEL)
end

function var0_0.updateCharacters(arg0_28)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0_28:resetGrid(TeamType.Vanguard)
	arg0_28:resetGrid(TeamType.Main)
	arg0_28:loadAllCharacter(function()
		arg0_28:updateFleetView()
		arg0_28:displayFleetInfo()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.flushCharacters(arg0_30)
	arg0_30:resetGrid(TeamType.Vanguard)
	arg0_30:resetGrid(TeamType.Main)
	arg0_30:setAllCharacterPos(true)
	arg0_30:updateFleetView()
end

function var0_0.updateFleetView(arg0_31)
	local function var0_31(arg0_32, arg1_32)
		removeAllChildren(arg0_32)

		for iter0_32 = 1, 3 do
			if arg1_32[iter0_32] then
				local var0_32 = cloneTplTo(arg0_31.ship_tpl, arg0_32)

				updateShip(var0_32, arg1_32[iter0_32])

				local var1_32 = WorldConst.FetchWorldShip(arg1_32[iter0_32].id)
				local var2_32 = var1_32:IsHpSafe()
				local var3_32 = var1_32:IsAlive()
				local var4_32 = findTF(var0_32, "blood/fillarea/green")
				local var5_32 = findTF(var0_32, "blood/fillarea/red")

				setActive(var4_32, var2_32)
				setActive(var5_32, not var2_32)

				;(var2_32 and var4_32 or var5_32):GetComponent("Image").fillAmount = var1_32.hpRant * 0.0001

				setActive(var0_32:Find("broken"), var1_32:IsBroken())
				setActive(var0_32:Find("mask"), not var3_32)
			end
		end
	end

	local var1_31 = arg0_31:getCurrentFleet()

	var0_31(arg0_31.fleet:Find("main"), var1_31:GetTeamShipVOs(TeamType.Main, true))
	var0_31(arg0_31.fleet:Find("vanguard"), var1_31:GetTeamShipVOs(TeamType.Vanguard, true))
end

function var0_0.loadAllCharacter(arg0_33, arg1_33)
	removeAllChildren(arg0_33.heroContainer)

	arg0_33.characterList = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {}
	}

	local function var0_33(arg0_34, arg1_34, arg2_34, arg3_34)
		if arg0_33.exited then
			arg0_34:Dispose()

			return
		end

		local var0_34 = arg0_34.model
		local var1_34 = WorldConst.FetchWorldShip(arg1_34.id)

		arg0_33.characterList[arg2_34][arg3_34] = arg0_34

		tf(var0_34):SetParent(arg0_33.heroContainer, false)

		tf(var0_34).localScale = Vector3(0.65, 0.65, 1)

		pg.ViewUtils.SetLayer(tf(var0_34), Layer.UI)
		arg0_33:enabledCharacter(var0_34, true, arg2_34)
		arg0_33:setCharacterPos(arg2_34, arg3_34, var0_34)
		arg0_33:sortSiblingIndex()

		local var2_34 = cloneTplTo(arg0_33.heroInfo, var0_34)

		setAnchoredPosition(var2_34, {
			x = 0,
			y = 0
		})

		var2_34.localScale = Vector3(2, 2, 1)

		SetActive(var2_34, true)

		var2_34.name = "info"

		local var3_34 = findTF(var2_34, "info")
		local var4_34 = findTF(var3_34, "stars")
		local var5_34 = arg1_34:getEnergy() <= Ship.ENERGY_MID
		local var6_34 = findTF(var3_34, "energy")

		if var5_34 then
			local var7_34, var8_34 = arg1_34:getEnergyPrint()
			local var9_34 = GetSpriteFromAtlas("energy", var7_34)

			if not var9_34 then
				warning("找不到疲劳")
			end

			setImageSprite(var6_34, var9_34)
		end

		setActive(var6_34, var5_34)

		local var10_34 = arg1_34:getStar()

		for iter0_34 = 1, var10_34 do
			cloneTplTo(arg0_33.starTpl, var4_34)
		end

		local var11_34 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_34:getShipType()))

		if not var11_34 then
			warning("找不到船形, shipConfigId: " .. arg1_34.configId)
		end

		setImageSprite(findTF(var3_34, "type"), var11_34, true)
		setText(findTF(var3_34, "frame/lv_contain/lv"), arg1_34.level)

		local var12_34 = var1_34:IsHpSafe()
		local var13_34 = findTF(var3_34, "blood")
		local var14_34 = findTF(var13_34, "fillarea/green")
		local var15_34 = findTF(var13_34, "fillarea/red")

		setActive(var14_34, var12_34)
		setActive(var15_34, not var12_34)

		var13_34:GetComponent(typeof(Slider)).fillRect = var12_34 and var14_34 or var15_34

		setSlider(var13_34, 0, 10000, var1_34.hpRant)
		setActive(var13_34:Find("broken"), var1_34:IsBroken())

		local var16_34 = getProxy(ActivityProxy):getBuffShipList()[arg1_34:getGroupId()]
		local var17_34 = var3_34:Find("expbuff")

		setActive(var17_34, var16_34 ~= nil)

		if var16_34 then
			local var18_34 = var16_34 / 100
			local var19_34 = var16_34 % 100
			local var20_34 = tostring(var18_34)

			if var19_34 > 0 then
				var20_34 = var20_34 .. "." .. tostring(var19_34)
			end

			setText(var17_34:Find("text"), string.format("EXP +%s%%", var20_34))
		end
	end

	local var1_33 = {}

	local function var2_33(arg0_35)
		local var0_35 = arg0_33:getCurrentFleet():GetTeamShipVOs(arg0_35, false)

		for iter0_35, iter1_35 in ipairs(var0_35) do
			table.insert(var1_33, function(arg0_36)
				local var0_36 = SpineRole.New(iter1_35)

				var0_36:Load(function()
					var0_33(var0_36, iter1_35, arg0_35, iter0_35)
					onNextTick(arg0_36)
				end)
			end)
		end
	end

	var2_33(TeamType.Vanguard)
	var2_33(TeamType.Main)
	seriesAsync(var1_33, function(arg0_38)
		if arg0_33.exited then
			return
		end

		if arg1_33 then
			arg1_33()
		end
	end)
end

function var0_0.showEnergyDesc(arg0_39, arg1_39, arg2_39)
	if LeanTween.isTweening(go(arg0_39.energyDescTF)) then
		LeanTween.cancel(go(arg0_39.energyDescTF))

		arg0_39.energyDescTF.localScale = Vector3.one
	end

	setText(arg0_39.energyDescTextTF, arg2_39)

	arg0_39.energyDescTF.position = arg1_39

	setActive(arg0_39.energyDescTF, true)
	LeanTween.scale(arg0_39.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0_39.energyDescTF.localScale = Vector3.one

		setActive(arg0_39.energyDescTF, false)
	end))
end

function var0_0.setAllCharacterPos(arg0_41, arg1_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.characterList[TeamType.Vanguard]) do
		arg0_41:setCharacterPos(TeamType.Vanguard, iter0_41, tf(iter1_41.model), arg1_41)
	end

	for iter2_41, iter3_41 in ipairs(arg0_41.characterList[TeamType.Main]) do
		arg0_41:setCharacterPos(TeamType.Main, iter2_41, tf(iter3_41.model), arg1_41)
	end

	arg0_41:sortSiblingIndex()
end

function var0_0.setCharacterPos(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	SetActive(arg3_42, true)

	local var0_42 = arg0_42.gridTFs[arg1_42][arg2_42]
	local var1_42 = var0_42.localPosition

	LeanTween.cancel(go(arg3_42))

	if arg4_42 then
		tf(arg3_42).localPosition = Vector3(var1_42.x + 2, var1_42.y - 80, var1_42.z)

		LeanTween.moveLocalY(go(arg3_42), var1_42.y - 110, 0.5):setDelay(0.5)
	else
		tf(arg3_42).localPosition = Vector3(var1_42.x + 2, var1_42.y - 110, var1_42.z)
	end

	SetActive(var0_42:Find("shadow"), true)
	arg3_42:GetComponent("SpineAnimUI"):SetAction("stand", 0)
end

function var0_0.resetGrid(arg0_43, arg1_43)
	local var0_43 = arg0_43.gridTFs[arg1_43]

	for iter0_43, iter1_43 in ipairs(var0_43) do
		SetActive(iter1_43:Find("shadow"), false)
	end
end

function var0_0.switchToEditMode(arg0_44)
	local function var0_44(arg0_45)
		for iter0_45, iter1_45 in ipairs(arg0_45) do
			local var0_45 = iter1_45.model
			local var1_45 = tf(var0_45):Find("mouseChild")

			if var1_45 then
				local var2_45 = var1_45:GetComponent("EventTriggerListener")

				arg0_44.eventTriggers[var2_45] = true

				if var2_45 then
					var2_45:RemovePointEnterFunc()
				end

				if iter0_45 == arg0_44._shiftIndex then
					var1_45:GetComponent(typeof(Image)).enabled = true
				end
			end
		end
	end

	var0_44(arg0_44.characterList[TeamType.Vanguard])
	var0_44(arg0_44.characterList[TeamType.Main])

	arg0_44._shiftIndex = nil

	arg0_44:flushCharacters()
end

function var0_0.switchToShiftMode(arg0_46, arg1_46, arg2_46)
	for iter0_46 = 1, 3 do
		local var0_46 = arg0_46.gridTFs[TeamType.Vanguard][iter0_46]
		local var1_46 = arg0_46.gridTFs[TeamType.Main][iter0_46]

		setActive(var0_46:Find("tip"), false)
		setActive(var1_46:Find("tip"), false)
		setActive(arg0_46.gridTFs[arg2_46][iter0_46]:Find("shadow"), false)
	end

	local var2_46 = arg0_46.characterList[arg2_46]

	for iter1_46, iter2_46 in ipairs(var2_46) do
		local var3_46 = iter2_46.model

		if var3_46 ~= arg1_46 then
			local var4_46 = arg0_46.gridTFs[arg2_46][iter1_46]

			LeanTween.moveLocalY(var3_46, var4_46.localPosition.y - 80, 0.5)

			local var5_46 = tf(var3_46):Find("mouseChild"):GetComponent("EventTriggerListener")

			arg0_46.eventTriggers[var5_46] = true

			var5_46:AddPointEnterFunc(function()
				for iter0_47, iter1_47 in ipairs(var2_46) do
					if iter1_47.model == var3_46 then
						arg0_46:shift(arg0_46._shiftIndex, iter0_47, arg2_46)

						break
					end
				end
			end)
		else
			arg0_46._shiftIndex = iter1_46
			tf(var3_46):Find("mouseChild"):GetComponent(typeof(Image)).enabled = false
		end

		var3_46:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end
end

function var0_0.shift(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = arg0_48.characterList[arg3_48]
	local var1_48 = arg0_48.gridTFs[arg3_48]
	local var2_48 = var0_48[arg2_48].model
	local var3_48 = var1_48[arg1_48].localPosition

	tf(var2_48).localPosition = Vector3(var3_48.x + 2, var3_48.y - 80, var3_48.z)

	LeanTween.cancel(var2_48)

	var0_48[arg1_48], var0_48[arg2_48] = var0_48[arg2_48], var0_48[arg1_48]

	local var4_48 = arg0_48:getCurrentFleet()
	local var5_48 = var4_48:GetTeamShips(arg3_48, false)

	var4_48:SwitchShip(var5_48[arg1_48].id, var5_48[arg2_48].id)

	arg0_48._shiftIndex = arg2_48

	arg0_48:sortSiblingIndex()
end

function var0_0.sortSiblingIndex(arg0_49)
	local var0_49 = 3
	local var1_49 = 0

	while var0_49 > 0 do
		local var2_49 = arg0_49.characterList[TeamType.Main][var0_49]
		local var3_49 = arg0_49.characterList[TeamType.Vanguard][var0_49]

		if var2_49 then
			local var4_49 = var2_49.model

			tf(var4_49):SetSiblingIndex(var1_49)

			var1_49 = var1_49 + 1
		end

		if var3_49 then
			local var5_49 = var3_49.model

			tf(var5_49):SetSiblingIndex(var1_49)

			var1_49 = var1_49 + 1
		end

		var0_49 = var0_49 - 1
	end
end

function var0_0.enabledTeamCharacter(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.characterList[arg1_50]

	for iter0_50, iter1_50 in ipairs(var0_50) do
		arg0_50:enabledCharacter(iter1_50.model, arg2_50, arg1_50)
	end
end

function var0_0.enabledCharacter(arg0_51, arg1_51, arg2_51, arg3_51)
	if arg2_51 then
		local var0_51, var1_51, var2_51 = tf(arg1_51):Find("mouseChild")

		if var0_51 then
			SetActive(var0_51, true)
		else
			local var3_51 = GameObject("mouseChild")

			tf(var3_51):SetParent(tf(arg1_51))

			tf(var3_51).localPosition = Vector3.zero

			local var4_51 = GetOrAddComponent(var3_51, "ModelDrag")
			local var5_51 = GetOrAddComponent(var3_51, "EventTriggerListener")

			arg0_51.eventTriggers[var5_51] = true

			var4_51:Init()

			local var6_51 = var3_51:GetComponent(typeof(RectTransform))

			var6_51.sizeDelta = Vector2(2.5, 2.5)
			var6_51.pivot = Vector2(0.5, 0)
			var6_51.anchoredPosition = Vector2(0, 0)

			local var7_51
			local var8_51
			local var9_51
			local var10_51

			var5_51:AddBeginDragFunc(function()
				var7_51 = UnityEngine.Screen.width
				var8_51 = UnityEngine.Screen.height
				var9_51 = rtf(arg0_51._tf).rect.width / var7_51
				var10_51 = rtf(arg0_51._tf).rect.height / var8_51

				LeanTween.cancel(go(arg1_51))
				arg0_51:switchToShiftMode(arg1_51, arg3_51)
				arg1_51:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(arg1_51):SetParent(arg0_51.moveLayer, false)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
			end)
			var5_51:AddDragFunc(function(arg0_53, arg1_53)
				rtf(arg1_51).anchoredPosition = Vector2((arg1_53.position.x - var7_51 / 2) * var9_51 + 20, (arg1_53.position.y - var8_51 / 2) * var10_51 - 20)
			end)
			var5_51:AddDragEndFunc(function(arg0_54, arg1_54)
				arg1_51:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(arg1_51):SetParent(arg0_51.heroContainer, false)
				arg0_51:switchToEditMode()
				arg0_51:sortSiblingIndex()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
			end)
		end
	else
		SetActive(tf(arg1_51):Find("mouseChild"), false)
	end
end

function var0_0.displayFleetInfo(arg0_55)
	local var0_55 = arg0_55:getCurrentFleet()
	local var1_55 = _.reduce(var0_55:GetTeamShipVOs(TeamType.Vanguard, false), 0, function(arg0_56, arg1_56)
		return arg0_56 + arg1_56:getShipCombatPower()
	end)
	local var2_55 = _.reduce(var0_55:GetTeamShipVOs(TeamType.Main, false), 0, function(arg0_57, arg1_57)
		return arg0_57 + arg1_57:getShipCombatPower()
	end)

	var1_0.tweenNumText(arg0_55.vanguardGS, var1_55)
	var1_0.tweenNumText(arg0_55.mainGS, var2_55)
end

function var0_0.hideStrategyInfo(arg0_58)
	if arg0_58.strategyPanel then
		arg0_58.strategyPanel:detach()
	end
end

function var0_0.recycleCharacterList(arg0_59, arg1_59, arg2_59)
	for iter0_59, iter1_59 in ipairs(arg1_59) do
		if arg2_59[iter0_59] then
			arg2_59[iter0_59]:Dispose()

			arg2_59[iter0_59] = nil
		end
	end
end

function var0_0.willExit(arg0_60)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_60._tf)

	if arg0_60.resPanel then
		arg0_60.resPanel:exit()

		arg0_60.resPanel = nil
	end

	if arg0_60.eventTriggers then
		for iter0_60, iter1_60 in pairs(arg0_60.eventTriggers) do
			ClearEventTrigger(iter0_60)
		end

		arg0_60.eventTriggers = nil
	end

	if arg0_60.tweens then
		cancelTweens(arg0_60.tweens)
	end

	local var0_60 = arg0_60:getCurrentFleet()

	arg0_60:recycleCharacterList(var0_60:GetTeamShipVOs(TeamType.Main, false), arg0_60.characterList[TeamType.Main])
	arg0_60:recycleCharacterList(var0_60:GetTeamShipVOs(TeamType.Vanguard, false), arg0_60.characterList[TeamType.Vanguard])
end

function var0_0.Clone2Full(arg0_61, arg1_61)
	local var0_61 = {}
	local var1_61 = arg0_61:GetChild(0)
	local var2_61 = arg0_61.childCount

	for iter0_61 = 0, var2_61 - 1 do
		table.insert(var0_61, arg0_61:GetChild(iter0_61))
	end

	for iter1_61 = var2_61, arg1_61 - 1 do
		local var3_61 = cloneTplTo(var1_61, arg0_61)

		table.insert(var0_61, tf(var3_61))
	end

	return var0_61
end

function var0_0.TransformColor(arg0_62)
	local var0_62 = tonumber(string.sub(arg0_62, 1, 2), 16)
	local var1_62 = tonumber(string.sub(arg0_62, 3, 4), 16)
	local var2_62 = tonumber(string.sub(arg0_62, 5, 6), 16)

	return Color.New(var0_62 / 255, var1_62 / 255, var2_62 / 255)
end

return var0_0
