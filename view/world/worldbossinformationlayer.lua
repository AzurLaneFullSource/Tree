local var0 = class("WorldBossInformationLayer", import("view.base.BaseUI"))
local var1 = 25
local var2 = 7.2

function var0.getUIName(arg0)
	return "WorldBossInformationUI"
end

function var0.init(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.layer = arg0:findTF("fixed")
	arg0.top = arg0:findTF("top", arg0.layer)
	arg0.backBtn = arg0.top:Find("back_btn")
	arg0.homeBtn = arg0.top:Find("option")
	arg0.playerResOb = arg0.top:Find("playerRes")
	arg0.resPanel = WorldResource.New()

	tf(arg0.resPanel._go):SetParent(tf(arg0.playerResOb), false)

	arg0.startBtn = arg0.layer:Find("battle")
	arg0.retreatBtn = arg0.layer:Find("retreat")
	arg0.hpbar = arg0.layer:Find("hp")

	local var0 = arg0.layer:Find("drop")

	arg0.dropitems = CustomIndexLayer.Clone2Full(var0:Find("items"), 5)
	arg0.dropright = var0:Find("right")
	arg0.dropleft = var0:Find("left")
	arg0.awardBtn = arg0.layer:Find("showAward")
	arg0.weaknesstext = arg0.layer:Find("text")
	arg0.weaknessbg = arg0.layer:Find("boss_ruodian")
	arg0.downBG = arg0.layer:Find("BlurBG")
	arg0.buffListTF = arg0.layer:Find("BuffList")
	arg0.buffListAnimator = arg0.buffListTF:GetComponent(typeof(Animator))
	arg0.AdditionBuffTF = arg0.layer:Find("BuffList/tezhuangmokuai")
	arg0.AdditionBuffContainer = arg0.AdditionBuffTF:Find("buff")
	arg0.EquipmentBuffTF = arg0.layer:Find("BuffList/wuzhuangjiexi")
	arg0.EquipmentBuffContainer = arg0.EquipmentBuffTF:Find("buff")
	arg0.switchBuffBtn = arg0.layer:Find("BuffList/Switcher")
	arg0.ShowBuffIndex = 0
	arg0.attributeRoot = arg0.layer:Find("attributes")
	arg0.attributeRootAnchorY = arg0.attributeRoot.anchoredPosition.y
	arg0.attributes = CustomIndexLayer.Clone2Full(arg0.layer:Find("attributes"), 3)

	for iter0 = 1, #arg0.attributes do
		arg0.attributes[iter0]:Find("extra").gameObject:SetActive(false)
		setText(arg0.attributes[iter0]:Find("extra/desc"), i18n("world_mapbuff_compare_txt") .. "：")
	end

	local var1 = arg0.layer:Find("bossname")

	arg0.bossnameText = var1:Find("name"):GetComponent(typeof(Text))
	arg0.bossNameBanner = var1:Find("name/banner")
	arg0.bosslevel = arg0.bossNameBanner:Find("level")
	arg0.bosslogos = {
		var1:Find("name/bosslogo_01"),
		(var1:Find("name/bosslogo_02"))
	}
	arg0.bossTypeIcon = arg0.bossNameBanner:Find("Type/Icon")
	arg0.bossArmorText = arg0.bossNameBanner:Find("Type/Armor")
	arg0.saomiaoxian = arg0.layer:Find("saomiao")
	arg0.bosssprite = arg0.saomiaoxian:Find("qimage")
	arg0.dangerMark = arg0.layer:Find("danger_mark")
	arg0.loader = AutoLoader.New()
	arg0.dungeonDict = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0.startBtn, function()
		arg0:emit(WorldBossInformationMediator.OnOpenSublayer, Context.New({
			mediator = WorldPreCombatMediator,
			viewComponent = WorldPreCombatLayer
		}), true, function()
			arg0:closeView()
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0.retreatBtn, function()
		arg0:emit(WorldBossInformationMediator.RETREAT_FLEET)
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.switchBuffBtn, function()
		arg0.ShowBuffIndex = 1 - arg0.ShowBuffIndex

		local var0 = arg0.ShowBuffIndex == 1 and "switchOn" or "switchOff"

		arg0.buffListAnimator:Play(var0, -1, 0)
	end, SFX_PANEL)
	onButton(arg0, arg0.awardBtn, function()
		arg0:GetAwardPanel().buffer:UpdateView(arg0:GetCurrentAttachment())
	end, SFX_PANEL)
	arg0:updateStageView()
	arg0.loader:LoadPrefab("ui/xuetiao01", "", nil, function(arg0)
		setParent(arg0, arg0.layer)

		local var0 = tf(arg0):Find("qipao")

		setParent(var0, arg0.hpbar:Find("hp"), false)
		setLocalPosition(var0, {
			x = 0,
			y = 0
		})

		local var1 = tf(arg0):Find("xuetiao01")

		arg0.hpeffectmat = var1:GetComponent(typeof(Renderer)).material

		setParent(var1, arg0.hpbar, false)
		setLocalPosition(var1, {
			x = 0,
			y = 0
		})
		arg0:UpdateHpbar()
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		interactableAlways = true
	})
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.layer, {
		pbList = {
			arg0.downBG,
			arg0.attributes[1],
			arg0.attributes[2],
			arg0.attributes[3],
			arg0.top,
			arg0.AdditionBuffTF,
			arg0.EquipmentBuffTF
		},
		groupName = LayerWeightConst.GROUP_BOSSINFORMATION
	})
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

function var0.GetEnemyLevel(arg0, arg1)
	if arg1.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var0 = nowWorld():GetActiveMap()

		return WorldConst.WorldLevelCorrect(var0.config.expedition_level, arg1.type)
	else
		return arg1.level
	end
end

function var0.UpdateHpbar(arg0)
	local var0 = arg0:GetCurrentAttachment()
	local var1 = arg0:GetDungeonBossData(var0).bossData.hpBarNum
	local var2 = var0:GetHP() or 10000
	local var3 = var1 * var2 / 10000
	local var4 = math.ceil(var3)

	setSlider(arg0.hpbar, 0, var1, var4)
	setText(arg0.hpbar:Find("hpcur"), string.format("%d", var4))
	setText(arg0.hpbar:Find("hpamount"), var1)

	local var5 = arg0.hpbar:Find("hp/mask")

	if arg0.hpeffectmat then
		arg0.hpeffectmat:SetFloat("_Mask", var2 / 100)

		local var6 = arg0.hpbar:Find("hp").rect

		var5.localScale = Vector3(var6.width * var1, var6.height * var1, 1)
		var5.localPosition = Vector3.zero

		local var7 = math.clamp(Screen.width / Screen.height, 1.77777777777778, 2) / 1.77777777777778

		setLocalScale(arg0.hpbar:Find("xuetiao01"), {
			x = var7
		})
	end

	local var8 = arg0.hpbar:Find("rewards")
	local var9 = var0:GetBattleStageId()
	local var10 = pg.world_expedition_data[var9]
	local var11 = var10 and var10.phase_drop

	setActive(var8, var11 and #var11 > 0)

	local var12 = var2

	if var0:IsPeriodEnemy() then
		var12 = math.min(var12, nowWorld():GetHistoryLowestHP(var0.id))
	end

	UIItemList.StaticAlign(var8, var8:GetChild(0), var11 and #var11 or 0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var11[arg1 + 1]
		local var1 = var0[1] / 10000

		arg2.anchorMin = Vector2(var1, 0.5)
		arg2.anchorMax = Vector2(var1, 0.5)

		setAnchoredPosition(arg2, {
			x = 0
		})

		local var2 = var12 <= var0[1] and "reward_empty" or "reward"

		arg0.loader:GetSprite("ui/worldbossinformationui_atlas", var2, arg2)
	end)

	local var13 = arg0.hpbar:Find("kedu")

	setLocalScale(var13, {
		x = arg0.hpbar.rect.width / var13.rect.width
	})
end

function var0.GetDungeonBossData(arg0, arg1)
	assert(arg1, "Attachment is null")

	local var0 = arg1.config.dungeon_id
	local var1 = arg0:GetDungeonFile(var0).stages[1].waves
	local var2

	_.any(var1, function(arg0)
		if not arg0.spawn then
			return
		end

		return _.any(arg0.spawn, function(arg0)
			if arg0.bossData then
				var2 = arg0

				return true
			end
		end)
	end)
	assert(var2, "Cant Find Boss Data in Dungeon: " .. (var0 or "NIL"))

	return var2
end

function var0.GetDungeonFile(arg0, arg1)
	if arg0.dungeonDict[arg1] then
		return arg0.dungeonDict[arg1]
	end

	local var0 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg1)

	arg0.dungeonDict[arg1] = var0

	return var0
end

local var3 = 212
local var4 = 40
local var5 = "fe2222"
local var6 = "92fc63"
local var7 = 70

function var0.updateStageView(arg0)
	local var0, var1 = arg0:GetCurrentAttachment()
	local var2 = var0:GetBattleStageId()
	local var3 = pg.expedition_data_template[var2]
	local var4 = pg.world_expedition_data[var2]

	assert(var3, "expedition_data_template not exist: " .. var2)

	local var5 = {}

	for iter0, iter1 in ipairs(var4.award_display_world) do
		if var1 == iter1[1] then
			var5 = iter1[2]
		end
	end

	local var6 = 0

	local function var7()
		for iter0 = 1, #arg0.dropitems do
			local var0 = arg0.dropitems[iter0]:Find("item_tpl")
			local var1 = var5[iter0 + var6]

			setActive(var0, var1 ~= nil)

			if var1 then
				local var2 = {
					type = var1[1],
					id = var1[2]
				}

				updateDrop(var0, var2)
				onButton(arg0, var0, function()
					arg0:emit(var0.ON_DROP, var2)
				end, SFX_PANEL)
			end
		end

		setActive(arg0.dropleft, var6 > 0)
		setActive(arg0.dropright, #var5 - var6 > #arg0.dropitems)
	end

	onButton(arg0, arg0.dropright, function()
		var6 = var6 + 1

		var7()
	end)
	onButton(arg0, arg0.dropleft, function()
		var6 = var6 - 1

		var7()
	end)
	var7()
	setActive(arg0.awardBtn, var4.phase_drop_display and #var4.phase_drop_display > 0)

	local var8 = var0:GetWeaknessBuffId()
	local var9 = pg.world_SLGbuff_data[var8]

	setActive(arg0.weaknesstext, var9 ~= nil)
	setActive(arg0.weaknessbg, var9 ~= nil)

	if var9 then
		setText(arg0.weaknesstext, i18n("word_weakness") .. ": " .. var9.desc)
	end

	local var10 = var9 == nil and var7 or 0

	setAnchoredPosition(arg0.attributeRoot, {
		y = arg0.attributeRootAnchorY - var10
	})
	;(function()
		local var0 = nowWorld():GetActiveMap()
		local var1 = table.mergeArray(var0:GetBuffList(), var0:GetBuffList(WorldMap.FactionEnemy, var0))
		local var2 = _.filter(var1, function(arg0)
			return arg0.id ~= var8
		end)

		UIItemList.StaticAlign(arg0.AdditionBuffContainer, arg0.AdditionBuffContainer:GetChild(0), #var2, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var2[arg1 + 1]

			setActive(arg2, var0)

			if var0 then
				arg0.loader:GetSprite("world/buff/" .. var0.config.icon, "", arg2:Find("icon"))
				setText(arg2:Find("desc"), var0.config.desc)
			end
		end)
	end)()
	;(function()
		local var0 = var4.special_buff_display

		if not var0 or #var0 == 0 then
			var0 = nil
		end

		setActive(arg0.EquipmentBuffTF, var0)
		setActive(arg0.switchBuffBtn, var0)

		if not var0 then
			return
		end

		local var1 = _.map(var0, function(arg0)
			assert("world_SLGbuff_data Missing ID: " .. (arg0 or "NIL"))

			return pg.world_SLGbuff_data[arg0]
		end)

		UIItemList.StaticAlign(arg0.EquipmentBuffContainer, arg0.EquipmentBuffContainer:GetChild(0), #var1, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var1[arg1 + 1]

			setActive(arg2, var0)

			if var0 then
				arg0.loader:GetSprite("world/buff/" .. var0.icon, "", arg2:Find("icon"))
				setText(arg2:Find("desc"), var0.desc)
			end
		end)
	end)()
	Canvas.ForceUpdateCanvases()

	local var11 = arg0.AdditionBuffTF.rect.height
	local var12 = arg0.EquipmentBuffTF.rect.height
	local var13

	var13.y, var13 = math.max(var11, var12) + 50, arg0.buffListTF.sizeDelta
	arg0.buffListTF.sizeDelta = var13

	arg0:UpdateHpbar()

	local var14 = ys.Battle.BattleFormulas
	local var15 = nowWorld()
	local var16 = var15:GetWorldMapDifficultyBuffLevel()
	local var17 = {
		var16[1] * (1 + var4.expedition_sairenvalueA / 10000),
		var16[2] * (1 + var4.expedition_sairenvalueB / 10000),
		var16[3] * (1 + var4.expedition_sairenvalueC / 10000)
	}
	local var18 = var15:GetWorldMapBuffLevel()
	local var19, var20, var21 = var14.WorldMapRewardAttrEnhance(var17, var18)
	local var22 = 1 - var14.WorldMapRewardHealingRate(var17, var18)
	local var23 = {
		var19,
		var20,
		var22
	}

	for iter2 = 1, #arg0.attributes do
		local var24 = arg0.attributes[iter2]

		setText(var24:Find("digit"), string.format("%d", var17[iter2]))

		local var25 = iter2 == 3 and 1 - var23[iter2] or var23[iter2] + 1

		setText(var24:Find("desc"), i18n("world_mapbuff_attrtxt_" .. iter2) .. string.format(" %d%%", var25 * 100))

		local var26 = GetOrAddComponent(var24, typeof(UILongPressTrigger))

		var26.onPressed:RemoveAllListeners()
		var26.onReleased:RemoveAllListeners()

		local var27
		local var28

		var26.onPressed:AddListener(function()
			var27 = go(var24:Find("extra")).activeSelf

			setActive(var24:Find("extra"), true)

			var28 = Time.realtimeSinceStartup
		end)
		var26.onReleased:AddListener(function()
			if not var28 or Time.realtimeSinceStartup - var28 < 0.3 then
				setActive(var24:Find("extra"), not var27)
			else
				setActive(var24:Find("extra"), false)
			end
		end)
		setText(var24:Find("extra/enemy"), var17[iter2])
		setText(var24:Find("extra/ally"), var18[iter2])
		setText(var24:Find("extra/result"), string.format("%d%%", var23[iter2] * 100))
		setTextColor(var24:Find("extra/result"), var23[iter2] > 0 and arg0.TransformColor(var5) or arg0.TransformColor(var6))
		setText(var24:Find("extra/result/arrow"), var23[iter2] == 0 and "" or var23[iter2] > 0 and "↑" or "↓")

		if var23[iter2] ~= 0 then
			setTextColor(var24:Find("extra/result/arrow"), var23[iter2] > 0 and arg0.TransformColor(var5) or arg0.TransformColor(var6))
		end

		local var29 = var24:Find("extra/allybar")
		local var30 = var24:Find("extra/enemybar")
		local var31 = math.clamp(1 + var23[iter2], 0.75, 3)
		local var32 = var24:Find("extra").rect.width

		var30.sizeDelta = Vector2(var31 * var32 / (var31 + 1) + var2 * 0.5, var30.sizeDelta.y)
		var29.sizeDelta = Vector2(1 * var32 / (var31 + 1) + var2 * 0.5, var29.sizeDelta.y)
	end

	local var33 = var4.battle_character
	local var34 = var33 and #var33 > 0

	var33 = var34 and var33 or "world_boss_0"
	arg0.bg:GetComponent(typeof(Image)).enabled = true

	setImageSprite(arg0.bg, GetSpriteFromAtlas("commonbg/" .. var33, var33))
	;(function()
		local var0 = var3.name

		arg0.bossnameText.text = var0

		local var1 = false

		if arg0.bossnameText.preferredWidth > arg0.bossnameText.transform.rect.width then
			local var2 = string.gsub(var0, "「.-」", "\n%1")

			arg0.bossnameText.text = var2
			var1 = true
		end

		setAnchoredPosition(arg0.bossNameBanner, {
			y = var1 and -18 or 0
		})
		setText(arg0.bosslevel, i18n("world_level_prefix", arg0:GetEnemyLevel(var3) or 1))
		setActive(arg0.bosslogos[1], var34)
		setActive(arg0.bosslogos[2], not var34)
		setActive(arg0.saomiaoxian, not var34)

		local var3 = arg0:GetDungeonBossData(var0).monsterTemplateID
		local var4 = ys.Battle.BattleDataFunction.GetMonsterTmpDataFromID(var3)

		arg0.loader:GetSprite("shiptype", ShipType.Type2BattlePrint(var4.type), arg0.bossTypeIcon, true)
		setText(arg0.bossArmorText, ArmorType.Type2Name(var4.armor_type))
	end)()

	local var35 = ys.Battle.BattleAttr.IsWorldMapRewardAttrWarning(var17, var18)

	setActive(arg0.dangerMark, var35)

	if var35 then
		setAnchoredPosition(arg0.dangerMark, {
			x = var34 and var4 or var3
		})
	end

	if not var34 then
		local var36 = var3.icon_type

		if var36 == 1 then
			arg0.loader:GetSprite("enemies/" .. var3.icon, nil, arg0.bosssprite)
		elseif var36 == 2 then
			arg0.bosssprite:GetComponent(typeof(Image)).enabled = false

			arg0.loader:GetSpine(var3.icon, function(arg0)
				local var0 = var4.battle_spine_size * 0.01

				arg0.transform.localScale = Vector3(var0, var0, 1)
				arg0.transform.anchoredPosition = Vector3.New(0, -150, 0)

				arg0.transform:GetComponent("SpineAnimUI"):SetAction(ChapterConst.ShipIdleAction, 0)

				arg0.transform:GetComponent("SkeletonGraphic").raycastTarget = false

				setParent(arg0, arg0.bosssprite, false)
			end, arg0.bosssprite)
		end
	end
end

function var0.onBackPressed(arg0)
	if arg0.awardPanel and arg0.awardPanel:isShowing() then
		arg0.awardPanel:Hide()

		return
	end

	triggerButton(arg0.backBtn)
end

function var0.willExit(arg0)
	arg0:DestroyAwardPanel()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.layer, arg0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.resPanel then
		arg0.resPanel:exit()

		arg0.resPanel = nil
	end

	for iter0, iter1 in pairs(arg0.dungeonDict) do
		ys.Battle.BattleDataFunction.ClearDungeonCfg(iter0)
	end

	table.clear(arg0.dungeonDict)
	arg0.loader:Clear()
end

function var0.GetAwardPanel(arg0)
	arg0.awardPanel = arg0.awardPanel or WorldBossHPAwardPanel.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.awardPanel:Load()

	return arg0.awardPanel
end

function var0.DestroyAwardPanel(arg0)
	if not arg0.awardPanel then
		return
	end

	arg0.awardPanel:Destroy()

	arg0.awardPanel = nil
end

function var0.TransformColor(arg0)
	local var0 = tonumber(string.sub(arg0, 1, 2), 16)
	local var1 = tonumber(string.sub(arg0, 3, 4), 16)
	local var2 = tonumber(string.sub(arg0, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

return var0
