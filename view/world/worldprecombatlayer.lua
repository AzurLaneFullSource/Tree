local var0 = class("WorldPreCombatLayer", import("..base.BaseUI"))
local var1 = import("..ship.FormationUI")
local var2 = {
	[99] = true
}

function var0.getUIName(arg0)
	return "WorldPreCombatUI"
end

function var0.init(arg0)
	arg0.eventTriggers = {}
	arg0.middle = arg0:findTF("middle")
	arg0.right = arg0:findTF("right")
	arg0.top = arg0:findTF("top")
	arg0.moveLayer = arg0:findTF("moveLayer")
	arg0.backBtn = arg0.top:Find("back_btn")
	arg0.playerResOb = arg0.top:Find("playerRes")
	arg0.resPanel = WorldResource.New()

	tf(arg0.resPanel._go):SetParent(tf(arg0.playerResOb), false)

	arg0.strategyInfo = arg0:findTF("strategy_info", arg0.top)

	setActive(arg0.strategyInfo, false)

	arg0.mainGS = arg0.middle:Find("gear_score/main/Text")
	arg0.vanguardGS = arg0.middle:Find("gear_score/vanguard/Text")

	setText(arg0.mainGS, 0)
	setText(arg0.vanguardGS, 0)

	arg0.gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0.gridFrame = arg0.middle:Find("mask/GridFrame")

	for iter0 = 1, 3 do
		arg0.gridTFs[TeamType.Vanguard][iter0] = arg0.gridFrame:Find("vanguard_" .. iter0)
		arg0.gridTFs[TeamType.Main][iter0] = arg0.gridFrame:Find("main_" .. iter0)
	end

	arg0.heroContainer = arg0.middle:Find("HeroContainer")
	arg0.strategy = arg0.middle:Find("strategy")

	setActive(arg0.strategy, false)

	arg0.fleet = arg0:findTF("middle/fleet")
	arg0.ship_tpl = findTF(arg0.fleet, "shiptpl")
	arg0.empty_tpl = findTF(arg0.fleet, "emptytpl")

	setActive(arg0.ship_tpl, false)
	setActive(arg0.empty_tpl, false)

	arg0.autoToggle = arg0.right:Find("auto_toggle")
	arg0.autoSubToggle = arg0.right:Find("sub_toggle_container/sub_toggle")
	arg0.startBtn = arg0.right:Find("start")
	arg0.infoBtn = arg0.right:Find("information")
	arg0.heroInfo = arg0:getTpl("heroInfo")
	arg0.starTpl = arg0:getTpl("star_tpl")
	arg0.energyDescTF = arg0:findTF("energy_desc")
	arg0.energyDescTextTF = arg0:findTF("energy_desc/Text")
	arg0.normaltab = arg0.right:Find("normal")
	arg0.informationtab = arg0.right:Find("infomation")
	arg0.buffInfo = arg0.normaltab:Find("buff")
	arg0.bossInfo = arg0.normaltab:Find("boss")
	arg0.spoilsContainer = arg0.normaltab:Find("spoils/items/items_container")
	arg0.spoilsItem = arg0.normaltab:Find("spoils/items/item_tpl")
	arg0.digits = arg0.Clone2Full(arg0.informationtab:Find("target/simple/digits"), 3)
	arg0.digitExtras = arg0.Clone2Full(arg0.informationtab:Find("target/detail"), 3)
	arg0.dropright = arg0.informationtab:Find("spoils/right")
	arg0.dropleft = arg0.informationtab:Find("spoils/left")
	arg0.dropitems = arg0.Clone2Full(arg0.informationtab:Find("spoils/items_container"), 3)

	setActive(arg0.informationtab:Find("target/simple"), true)
	setActive(arg0.informationtab:Find("target/detail"), false)

	for iter1 = 1, #arg0.digitExtras do
		local var0 = arg0.digitExtras[iter1]

		setText(var0:Find("desc"), i18n("world_mapbuff_compare_txt") .. "：")
	end
end

function var0.uiStartAnimating(arg0)
	setAnchoredPosition(arg0.middle, {
		x = -840
	})
	setAnchoredPosition(arg0.right, {
		x = 470
	})
	setAnchoredPosition(arg0.top, {
		y = arg0.top.rect.height
	})

	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0.middle, 0, nil, var1, var0, true, true)
	shiftPanel(arg0.right, 0, nil, var1, var0, true, true, nil)
	shiftPanel(arg0.top, nil, 0, var1, var0, true, true, nil, nil)
end

function var0.uiExitAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0.middle, -840, nil, var1, var0, true, true)
	shiftPanel(arg0.right, 470, nil, var1, var0, true, true)
	shiftPanel(arg0.top, nil, arg0.top.rect.height, var1, var0, true, true, nil, nil)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0:emit(var0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onToggle(arg0, arg0.autoToggle, function(arg0)
		arg0:emit(WorldPreCombatMediator.OnAuto, {
			isOn = not arg0,
			toggle = arg0.autoToggle
		})

		if arg0 and nowWorld():GetSubAidFlag() then
			setActive(arg0.autoSubToggle, true)
			onToggle(arg0, arg0.autoSubToggle, function(arg0)
				arg0:emit(WorldPreCombatMediator.OnSubAuto, {
					isOn = not arg0,
					toggle = arg0.autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0.autoSubToggle, ys.Battle.BattleState.IsAutoSubActive(SYSTEM_WORLD))
		else
			setActive(arg0.autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	arg0:updateCharacters()
	arg0:updateStageView()
	triggerToggle(arg0.autoToggle, ys.Battle.BattleState.IsAutoBotActive(SYSTEM_WORLD))

	local var0 = arg0:GetCurrentAttachment()
	local var1 = var0:GetBattleStageId()
	local var2 = pg.expedition_data_template[var1]

	assert(var2, "expedition_data_template not exist: " .. var1)

	local var3 = pg.world_expedition_data[var1]
	local var4 = var3 and var3.battle_type and var3.battle_type ~= 0

	onNextTick(function()
		arg0:uiStartAnimating()
	end)

	arg0.contextData.entetagain = true

	setActive(arg0.infoBtn, var4)
	onButton(arg0, arg0.infoBtn, function()
		arg0:emit(WorldPreCombatMediator.OnOpenSublayer, Context.New({
			mediator = WorldBossInformationMediator,
			viewComponent = WorldBossInformationLayer
		}), true, function()
			arg0:closeView()
		end)
	end)
	onButton(arg0, arg0.startBtn, function()
		arg0:emit(WorldPreCombatMediator.OnStartBattle, var0:GetBattleStageId(), arg0:getCurrentFleet(), var0)
	end, SFX_UI_WEIGHANCHOR)
end

function var0.onBackPressed(arg0)
	if arg0.strategyPanel and arg0.strategyPanel._go and isActive(arg0.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0.backBtn)
	end
end

function var0.setPlayerInfo(arg0, arg1)
	arg0.resPanel:setPlayer(arg1)
	setActive(arg0.resPanel._tf, nowWorld():IsSystemOpen(WorldConst.SystemResource))
end

function var0.getCurrentFleet(arg0)
	return nowWorld():GetFleet()
end

function var0.GetCurrentAttachment(arg0)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:GetFleet()

	return var0:GetCell(var1.row, var1.column):GetAliveAttachment(), var0.config.difficulty
end

function var0.updateStageView(arg0)
	setActive(arg0.normaltab, false)
	setActive(arg0.informationtab, true)
	arg0:UpdateInformationtab()
end

function var0.UpdateNormaltab(arg0)
	local var0, var1 = arg0:GetCurrentAttachment()
	local var2 = var0:GetBattleStageId()
	local var3 = pg.world_expedition_data[var2]
	local var4 = {}

	for iter0, iter1 in ipairs(var3.award_display_world) do
		if var1 == iter1[1] then
			var4 = iter1[2]
		end
	end

	local var5 = UIItemList.New(arg0.spoilsContainer, arg0.spoilsItem)

	var5:make(function(arg0, arg1, arg2)
		local var0 = arg2
		local var1 = var4[arg1 + 1]
		local var2 = {
			type = var1[1],
			id = var1[2]
		}

		updateDrop(var0, var2)
		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var2)
		end, SFX_PANEL)
	end)
	var5:align(#var4)
end

local var3 = "fe2222"
local var4 = "92fc63"

function var0.UpdateInformationtab(arg0)
	local var0, var1 = arg0:GetCurrentAttachment()
	local var2 = var0:GetBattleStageId()
	local var3 = pg.world_expedition_data[var2]

	assert(var3, "world_expedition_data not exist: " .. var2)

	local var4 = {}

	for iter0, iter1 in ipairs(var3.award_display_world) do
		if var1 == iter1[1] then
			var4 = iter1[2]
		end
	end

	local var5 = 0

	local function var6()
		for iter0 = 1, #arg0.dropitems do
			local var0 = arg0.dropitems[iter0]:Find("item_tpl")
			local var1 = var4[iter0 + var5]

			setActive(var0, var1 ~= nil)

			if var1 then
				local var2 = {
					type = var1[1],
					id = var1[2]
				}

				updateDrop(var0, var2)
				setScrollText(var0:Find("ScrollMask/DropName"), var2:getConfig("name"))
				onButton(arg0, var0, function()
					arg0:emit(var0.ON_DROP, var2)
				end, SFX_PANEL)
			end
		end

		setActive(arg0.dropleft, var5 > 0)
		setActive(arg0.dropright, #var4 - var5 > #arg0.dropitems)
	end

	onButton(arg0, arg0.dropright, function()
		var5 = var5 + 1

		var6()
	end)
	onButton(arg0, arg0.dropleft, function()
		var5 = var5 - 1

		var6()
	end)
	var6()

	local var7 = nowWorld()
	local var8 = ys.Battle.BattleFormulas
	local var9 = var7:GetWorldMapDifficultyBuffLevel()
	local var10 = {
		var9[1] * (1 + var3.expedition_sairenvalueA / 10000),
		var9[2] * (1 + var3.expedition_sairenvalueB / 10000),
		var9[3] * (1 + var3.expedition_sairenvalueC / 10000)
	}
	local var11 = var7:GetWorldMapBuffLevel()
	local var12, var13, var14 = var8.WorldMapRewardAttrEnhance(var10, var11)
	local var15 = 1 - var8.WorldMapRewardHealingRate(var10, var11)
	local var16 = {
		var12,
		var13,
		var15
	}

	for iter2 = 1, #arg0.digits do
		local var17 = arg0.digits[iter2]

		setText(var17:Find("digit"), string.format("%d", var10[iter2]))

		local var18 = iter2 == 3 and 1 - var16[iter2] or var16[iter2] + 1

		setText(var17:Find("desc"), i18n("world_mapbuff_attrtxt_" .. iter2) .. string.format("%3d%%", var18 * 100))
	end

	for iter3 = 1, #arg0.digitExtras do
		local var19 = arg0.digitExtras[iter3]

		setText(var19:Find("enemy"), string.format("%d", var10[iter3]))
		setText(var19:Find("ally"), string.format("%d", var11[iter3]))
		setText(var19:Find("result"), string.format("%d%%", var16[iter3] * 100))
		setTextColor(var19:Find("result"), var16[iter3] > 0 and arg0.TransformColor(var3) or arg0.TransformColor(var4))
		setText(var19:Find("result/arrow"), var16[iter3] == 0 and "" or var16[iter3] > 0 and "↑" or "↓")

		if var16[iter3] ~= 0 then
			setTextColor(var19:Find("result/arrow"), var16[iter3] > 0 and arg0.TransformColor(var3) or arg0.TransformColor(var4))
		end
	end

	onButton(arg0, arg0.informationtab:Find("target/bg"), function()
		local var0 = arg0.informationtab:Find("target/simple")
		local var1 = arg0.informationtab:Find("target/detail")
		local var2 = go(var0).activeSelf

		setActive(var0, not var2)
		setActive(var1, var2)
	end, SFX_PANEL)
end

function var0.updateCharacters(arg0)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0:resetGrid(TeamType.Vanguard)
	arg0:resetGrid(TeamType.Main)
	arg0:loadAllCharacter(function()
		arg0:updateFleetView()
		arg0:displayFleetInfo()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.flushCharacters(arg0)
	arg0:resetGrid(TeamType.Vanguard)
	arg0:resetGrid(TeamType.Main)
	arg0:setAllCharacterPos(true)
	arg0:updateFleetView()
end

function var0.updateFleetView(arg0)
	local function var0(arg0, arg1)
		removeAllChildren(arg0)

		for iter0 = 1, 3 do
			if arg1[iter0] then
				local var0 = cloneTplTo(arg0.ship_tpl, arg0)

				updateShip(var0, arg1[iter0])

				local var1 = WorldConst.FetchWorldShip(arg1[iter0].id)
				local var2 = var1:IsHpSafe()
				local var3 = var1:IsAlive()
				local var4 = findTF(var0, "blood/fillarea/green")
				local var5 = findTF(var0, "blood/fillarea/red")

				setActive(var4, var2)
				setActive(var5, not var2)

				;(var2 and var4 or var5):GetComponent("Image").fillAmount = var1.hpRant * 0.0001

				setActive(var0:Find("broken"), var1:IsBroken())
				setActive(var0:Find("mask"), not var3)
			end
		end
	end

	local var1 = arg0:getCurrentFleet()

	var0(arg0.fleet:Find("main"), var1:GetTeamShipVOs(TeamType.Main, true))
	var0(arg0.fleet:Find("vanguard"), var1:GetTeamShipVOs(TeamType.Vanguard, true))
end

function var0.loadAllCharacter(arg0, arg1)
	removeAllChildren(arg0.heroContainer)

	arg0.characterList = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {}
	}

	local function var0(arg0, arg1, arg2, arg3)
		if arg0.exited then
			arg0:Dispose()

			return
		end

		local var0 = arg0.model
		local var1 = WorldConst.FetchWorldShip(arg1.id)

		arg0.characterList[arg2][arg3] = arg0

		tf(var0):SetParent(arg0.heroContainer, false)

		tf(var0).localScale = Vector3(0.65, 0.65, 1)

		pg.ViewUtils.SetLayer(tf(var0), Layer.UI)
		arg0:enabledCharacter(var0, true, arg2)
		arg0:setCharacterPos(arg2, arg3, var0)
		arg0:sortSiblingIndex()

		local var2 = cloneTplTo(arg0.heroInfo, var0)

		setAnchoredPosition(var2, {
			x = 0,
			y = 0
		})

		var2.localScale = Vector3(2, 2, 1)

		SetActive(var2, true)

		var2.name = "info"

		local var3 = findTF(var2, "info")
		local var4 = findTF(var3, "stars")
		local var5 = arg1:getEnergy() <= Ship.ENERGY_MID
		local var6 = findTF(var3, "energy")

		if var5 then
			local var7, var8 = arg1:getEnergyPrint()
			local var9 = GetSpriteFromAtlas("energy", var7)

			if not var9 then
				warning("找不到疲劳")
			end

			setImageSprite(var6, var9)
		end

		setActive(var6, var5)

		local var10 = arg1:getStar()

		for iter0 = 1, var10 do
			cloneTplTo(arg0.starTpl, var4)
		end

		local var11 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var11 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var3, "type"), var11, true)
		setText(findTF(var3, "frame/lv_contain/lv"), arg1.level)

		local var12 = var1:IsHpSafe()
		local var13 = findTF(var3, "blood")
		local var14 = findTF(var13, "fillarea/green")
		local var15 = findTF(var13, "fillarea/red")

		setActive(var14, var12)
		setActive(var15, not var12)

		var13:GetComponent(typeof(Slider)).fillRect = var12 and var14 or var15

		setSlider(var13, 0, 10000, var1.hpRant)
		setActive(var13:Find("broken"), var1:IsBroken())

		local var16 = getProxy(ActivityProxy):getBuffShipList()[arg1:getGroupId()]
		local var17 = var3:Find("expbuff")

		setActive(var17, var16 ~= nil)

		if var16 then
			local var18 = var16 / 100
			local var19 = var16 % 100
			local var20 = tostring(var18)

			if var19 > 0 then
				var20 = var20 .. "." .. tostring(var19)
			end

			setText(var17:Find("text"), string.format("EXP +%s%%", var20))
		end
	end

	local var1 = {}

	local function var2(arg0)
		local var0 = arg0:getCurrentFleet():GetTeamShipVOs(arg0, false)

		for iter0, iter1 in ipairs(var0) do
			table.insert(var1, function(arg0)
				local var0 = SpineRole.New(iter1)

				var0:Load(function()
					var0(var0, iter1, arg0, iter0)
					onNextTick(arg0)
				end)
			end)
		end
	end

	var2(TeamType.Vanguard)
	var2(TeamType.Main)
	seriesAsync(var1, function(arg0)
		if arg0.exited then
			return
		end

		if arg1 then
			arg1()
		end
	end)
end

function var0.showEnergyDesc(arg0, arg1, arg2)
	if LeanTween.isTweening(go(arg0.energyDescTF)) then
		LeanTween.cancel(go(arg0.energyDescTF))

		arg0.energyDescTF.localScale = Vector3.one
	end

	setText(arg0.energyDescTextTF, arg2)

	arg0.energyDescTF.position = arg1

	setActive(arg0.energyDescTF, true)
	LeanTween.scale(arg0.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0.energyDescTF.localScale = Vector3.one

		setActive(arg0.energyDescTF, false)
	end))
end

function var0.setAllCharacterPos(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.characterList[TeamType.Vanguard]) do
		arg0:setCharacterPos(TeamType.Vanguard, iter0, tf(iter1.model), arg1)
	end

	for iter2, iter3 in ipairs(arg0.characterList[TeamType.Main]) do
		arg0:setCharacterPos(TeamType.Main, iter2, tf(iter3.model), arg1)
	end

	arg0:sortSiblingIndex()
end

function var0.setCharacterPos(arg0, arg1, arg2, arg3, arg4)
	SetActive(arg3, true)

	local var0 = arg0.gridTFs[arg1][arg2]
	local var1 = var0.localPosition

	LeanTween.cancel(go(arg3))

	if arg4 then
		tf(arg3).localPosition = Vector3(var1.x + 2, var1.y - 80, var1.z)

		LeanTween.moveLocalY(go(arg3), var1.y - 110, 0.5):setDelay(0.5)
	else
		tf(arg3).localPosition = Vector3(var1.x + 2, var1.y - 110, var1.z)
	end

	SetActive(var0:Find("shadow"), true)
	arg3:GetComponent("SpineAnimUI"):SetAction("stand", 0)
end

function var0.resetGrid(arg0, arg1)
	local var0 = arg0.gridTFs[arg1]

	for iter0, iter1 in ipairs(var0) do
		SetActive(iter1:Find("shadow"), false)
	end
end

function var0.switchToEditMode(arg0)
	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0 = iter1.model
			local var1 = tf(var0):Find("mouseChild")

			if var1 then
				local var2 = var1:GetComponent("EventTriggerListener")

				arg0.eventTriggers[var2] = true

				if var2 then
					var2:RemovePointEnterFunc()
				end

				if iter0 == arg0._shiftIndex then
					var1:GetComponent(typeof(Image)).enabled = true
				end
			end
		end
	end

	var0(arg0.characterList[TeamType.Vanguard])
	var0(arg0.characterList[TeamType.Main])

	arg0._shiftIndex = nil

	arg0:flushCharacters()
end

function var0.switchToShiftMode(arg0, arg1, arg2)
	for iter0 = 1, 3 do
		local var0 = arg0.gridTFs[TeamType.Vanguard][iter0]
		local var1 = arg0.gridTFs[TeamType.Main][iter0]

		setActive(var0:Find("tip"), false)
		setActive(var1:Find("tip"), false)
		setActive(arg0.gridTFs[arg2][iter0]:Find("shadow"), false)
	end

	local var2 = arg0.characterList[arg2]

	for iter1, iter2 in ipairs(var2) do
		local var3 = iter2.model

		if var3 ~= arg1 then
			local var4 = arg0.gridTFs[arg2][iter1]

			LeanTween.moveLocalY(var3, var4.localPosition.y - 80, 0.5)

			local var5 = tf(var3):Find("mouseChild"):GetComponent("EventTriggerListener")

			arg0.eventTriggers[var5] = true

			var5:AddPointEnterFunc(function()
				for iter0, iter1 in ipairs(var2) do
					if iter1.model == var3 then
						arg0:shift(arg0._shiftIndex, iter0, arg2)

						break
					end
				end
			end)
		else
			arg0._shiftIndex = iter1
			tf(var3):Find("mouseChild"):GetComponent(typeof(Image)).enabled = false
		end

		var3:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end
end

function var0.shift(arg0, arg1, arg2, arg3)
	local var0 = arg0.characterList[arg3]
	local var1 = arg0.gridTFs[arg3]
	local var2 = var0[arg2].model
	local var3 = var1[arg1].localPosition

	tf(var2).localPosition = Vector3(var3.x + 2, var3.y - 80, var3.z)

	LeanTween.cancel(var2)

	var0[arg1], var0[arg2] = var0[arg2], var0[arg1]

	local var4 = arg0:getCurrentFleet()
	local var5 = var4:GetTeamShips(arg3, false)

	var4:SwitchShip(var5[arg1].id, var5[arg2].id)

	arg0._shiftIndex = arg2

	arg0:sortSiblingIndex()
end

function var0.sortSiblingIndex(arg0)
	local var0 = 3
	local var1 = 0

	while var0 > 0 do
		local var2 = arg0.characterList[TeamType.Main][var0]
		local var3 = arg0.characterList[TeamType.Vanguard][var0]

		if var2 then
			local var4 = var2.model

			tf(var4):SetSiblingIndex(var1)

			var1 = var1 + 1
		end

		if var3 then
			local var5 = var3.model

			tf(var5):SetSiblingIndex(var1)

			var1 = var1 + 1
		end

		var0 = var0 - 1
	end
end

function var0.enabledTeamCharacter(arg0, arg1, arg2)
	local var0 = arg0.characterList[arg1]

	for iter0, iter1 in ipairs(var0) do
		arg0:enabledCharacter(iter1.model, arg2, arg1)
	end
end

function var0.enabledCharacter(arg0, arg1, arg2, arg3)
	if arg2 then
		local var0, var1, var2 = tf(arg1):Find("mouseChild")

		if var0 then
			SetActive(var0, true)
		else
			local var3 = GameObject("mouseChild")

			tf(var3):SetParent(tf(arg1))

			tf(var3).localPosition = Vector3.zero

			local var4 = GetOrAddComponent(var3, "ModelDrag")
			local var5 = GetOrAddComponent(var3, "EventTriggerListener")

			arg0.eventTriggers[var5] = true

			var4:Init()

			local var6 = var3:GetComponent(typeof(RectTransform))

			var6.sizeDelta = Vector2(2.5, 2.5)
			var6.pivot = Vector2(0.5, 0)
			var6.anchoredPosition = Vector2(0, 0)

			local var7
			local var8
			local var9
			local var10

			var5:AddBeginDragFunc(function()
				var7 = UnityEngine.Screen.width
				var8 = UnityEngine.Screen.height
				var9 = rtf(arg0._tf).rect.width / var7
				var10 = rtf(arg0._tf).rect.height / var8

				LeanTween.cancel(go(arg1))
				arg0:switchToShiftMode(arg1, arg3)
				arg1:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(arg1):SetParent(arg0.moveLayer, false)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
			end)
			var5:AddDragFunc(function(arg0, arg1)
				rtf(arg1).anchoredPosition = Vector2((arg1.position.x - var7 / 2) * var9 + 20, (arg1.position.y - var8 / 2) * var10 - 20)
			end)
			var5:AddDragEndFunc(function(arg0, arg1)
				arg1:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(arg1):SetParent(arg0.heroContainer, false)
				arg0:switchToEditMode()
				arg0:sortSiblingIndex()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
			end)
		end
	else
		SetActive(tf(arg1):Find("mouseChild"), false)
	end
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0:getCurrentFleet()
	local var1 = _.reduce(var0:GetTeamShipVOs(TeamType.Vanguard, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower()
	end)
	local var2 = _.reduce(var0:GetTeamShipVOs(TeamType.Main, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower()
	end)

	var1.tweenNumText(arg0.vanguardGS, var1)
	var1.tweenNumText(arg0.mainGS, var2)
end

function var0.hideStrategyInfo(arg0)
	if arg0.strategyPanel then
		arg0.strategyPanel:detach()
	end
end

function var0.recycleCharacterList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg1) do
		if arg2[iter0] then
			arg2[iter0]:Dispose()

			arg2[iter0] = nil
		end
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.resPanel then
		arg0.resPanel:exit()

		arg0.resPanel = nil
	end

	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	local var0 = arg0:getCurrentFleet()

	arg0:recycleCharacterList(var0:GetTeamShipVOs(TeamType.Main, false), arg0.characterList[TeamType.Main])
	arg0:recycleCharacterList(var0:GetTeamShipVOs(TeamType.Vanguard, false), arg0.characterList[TeamType.Vanguard])
end

function var0.Clone2Full(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetChild(0)
	local var2 = arg0.childCount

	for iter0 = 0, var2 - 1 do
		table.insert(var0, arg0:GetChild(iter0))
	end

	for iter1 = var2, arg1 - 1 do
		local var3 = cloneTplTo(var1, arg0)

		table.insert(var0, tf(var3))
	end

	return var0
end

function var0.TransformColor(arg0)
	local var0 = tonumber(string.sub(arg0, 1, 2), 16)
	local var1 = tonumber(string.sub(arg0, 3, 4), 16)
	local var2 = tonumber(string.sub(arg0, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

return var0
