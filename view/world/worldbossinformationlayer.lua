local var0_0 = class("WorldBossInformationLayer", import("view.base.BaseUI"))
local var1_0 = 25
local var2_0 = 7.2

function var0_0.getUIName(arg0_1)
	return "WorldBossInformationUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.layer = arg0_2:findTF("fixed")
	arg0_2.top = arg0_2:findTF("top", arg0_2.layer)
	arg0_2.backBtn = arg0_2.top:Find("back_btn")
	arg0_2.homeBtn = arg0_2.top:Find("option")
	arg0_2.playerResOb = arg0_2.top:Find("playerRes")
	arg0_2.resPanel = WorldResource.New()

	tf(arg0_2.resPanel._go):SetParent(tf(arg0_2.playerResOb), false)

	arg0_2.startBtn = arg0_2.layer:Find("battle")
	arg0_2.retreatBtn = arg0_2.layer:Find("retreat")
	arg0_2.hpbar = arg0_2.layer:Find("hp")

	local var0_2 = arg0_2.layer:Find("drop")

	arg0_2.dropitems = CustomIndexLayer.Clone2Full(var0_2:Find("items"), 5)
	arg0_2.dropright = var0_2:Find("right")
	arg0_2.dropleft = var0_2:Find("left")
	arg0_2.awardBtn = arg0_2.layer:Find("showAward")
	arg0_2.weaknesstext = arg0_2.layer:Find("text")
	arg0_2.weaknessbg = arg0_2.layer:Find("boss_ruodian")
	arg0_2.downBG = arg0_2.layer:Find("BlurBG")
	arg0_2.buffListTF = arg0_2.layer:Find("BuffList")
	arg0_2.buffListAnimator = arg0_2.buffListTF:GetComponent(typeof(Animator))
	arg0_2.AdditionBuffTF = arg0_2.layer:Find("BuffList/tezhuangmokuai")
	arg0_2.AdditionBuffContainer = arg0_2.AdditionBuffTF:Find("buff")
	arg0_2.EquipmentBuffTF = arg0_2.layer:Find("BuffList/wuzhuangjiexi")
	arg0_2.EquipmentBuffContainer = arg0_2.EquipmentBuffTF:Find("buff")
	arg0_2.switchBuffBtn = arg0_2.layer:Find("BuffList/Switcher")
	arg0_2.ShowBuffIndex = 0
	arg0_2.attributeRoot = arg0_2.layer:Find("attributes")
	arg0_2.attributeRootAnchorY = arg0_2.attributeRoot.anchoredPosition.y
	arg0_2.attributes = CustomIndexLayer.Clone2Full(arg0_2.layer:Find("attributes"), 3)

	for iter0_2 = 1, #arg0_2.attributes do
		arg0_2.attributes[iter0_2]:Find("extra").gameObject:SetActive(false)
		setText(arg0_2.attributes[iter0_2]:Find("extra/desc"), i18n("world_mapbuff_compare_txt") .. "：")
	end

	local var1_2 = arg0_2.layer:Find("bossname")

	arg0_2.bossnameText = var1_2:Find("name"):GetComponent(typeof(Text))
	arg0_2.bossNameBanner = var1_2:Find("name/banner")
	arg0_2.bosslevel = arg0_2.bossNameBanner:Find("level")
	arg0_2.bosslogos = {
		var1_2:Find("name/bosslogo_01"),
		(var1_2:Find("name/bosslogo_02"))
	}
	arg0_2.bossTypeIcon = arg0_2.bossNameBanner:Find("Type/Icon")
	arg0_2.bossArmorText = arg0_2.bossNameBanner:Find("Type/Armor")
	arg0_2.saomiaoxian = arg0_2.layer:Find("saomiao")
	arg0_2.bosssprite = arg0_2.saomiaoxian:Find("qimage")
	arg0_2.dangerMark = arg0_2.layer:Find("danger_mark")
	arg0_2.loader = AutoLoader.New()
	arg0_2.dungeonDict = {}
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		arg0_3:emit(WorldBossInformationMediator.OnOpenSublayer, Context.New({
			mediator = WorldPreCombatMediator,
			viewComponent = WorldPreCombatLayer
		}), true, function()
			arg0_3:closeView()
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_3, arg0_3.retreatBtn, function()
		arg0_3:emit(WorldBossInformationMediator.RETREAT_FLEET)
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.switchBuffBtn, function()
		arg0_3.ShowBuffIndex = 1 - arg0_3.ShowBuffIndex

		local var0_9 = arg0_3.ShowBuffIndex == 1 and "switchOn" or "switchOff"

		arg0_3.buffListAnimator:Play(var0_9, -1, 0)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.awardBtn, function()
		arg0_3:GetAwardPanel().buffer:UpdateView(arg0_3:GetCurrentAttachment())
	end, SFX_PANEL)
	arg0_3:updateStageView()
	arg0_3.loader:LoadPrefab("ui/xuetiao01", "", nil, function(arg0_11)
		setParent(arg0_11, arg0_3.layer)

		local var0_11 = tf(arg0_11):Find("qipao")

		setParent(var0_11, arg0_3.hpbar:Find("hp"), false)
		setLocalPosition(var0_11, {
			x = 0,
			y = 0
		})

		local var1_11 = tf(arg0_11):Find("xuetiao01")

		arg0_3.hpeffectmat = var1_11:GetComponent(typeof(Renderer)).material

		setParent(var1_11, arg0_3.hpbar, false)
		setLocalPosition(var1_11, {
			x = 0,
			y = 0
		})
		arg0_3:UpdateHpbar()
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf, {
		interactableAlways = true
	})
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3.layer, {
		pbList = {
			arg0_3.downBG,
			arg0_3.attributes[1],
			arg0_3.attributes[2],
			arg0_3.attributes[3],
			arg0_3.top,
			arg0_3.AdditionBuffTF,
			arg0_3.EquipmentBuffTF
		},
		groupName = LayerWeightConst.GROUP_BOSSINFORMATION
	})
end

function var0_0.setPlayerInfo(arg0_12, arg1_12)
	arg0_12.resPanel:setPlayer(arg1_12)
	setActive(arg0_12.resPanel._tf, nowWorld():IsSystemOpen(WorldConst.SystemResource))
end

function var0_0.getCurrentFleet(arg0_13)
	return nowWorld():GetFleet()
end

function var0_0.GetCurrentAttachment(arg0_14)
	local var0_14 = nowWorld():GetActiveMap()
	local var1_14 = var0_14:GetFleet()

	return var0_14:GetCell(var1_14.row, var1_14.column):GetAliveAttachment(), var0_14.config.difficulty
end

function var0_0.GetEnemyLevel(arg0_15, arg1_15)
	if arg1_15.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
		local var0_15 = nowWorld():GetActiveMap()

		return WorldConst.WorldLevelCorrect(var0_15.config.expedition_level, arg1_15.type)
	else
		return arg1_15.level
	end
end

function var0_0.UpdateHpbar(arg0_16)
	local var0_16 = arg0_16:GetCurrentAttachment()
	local var1_16 = arg0_16:GetDungeonBossData(var0_16).bossData.hpBarNum
	local var2_16 = var0_16:GetHP() or 10000
	local var3_16 = var1_16 * var2_16 / 10000
	local var4_16 = math.ceil(var3_16)

	setSlider(arg0_16.hpbar, 0, var1_16, var4_16)
	setText(arg0_16.hpbar:Find("hpcur"), string.format("%d", var4_16))
	setText(arg0_16.hpbar:Find("hpamount"), var1_16)

	local var5_16 = arg0_16.hpbar:Find("hp/mask")

	if arg0_16.hpeffectmat then
		arg0_16.hpeffectmat:SetFloat("_Mask", var2_16 / 100)

		local var6_16 = arg0_16.hpbar:Find("hp").rect

		var5_16.localScale = Vector3(var6_16.width * var1_0, var6_16.height * var1_0, 1)
		var5_16.localPosition = Vector3.zero

		local var7_16 = math.clamp(Screen.width / Screen.height, 1.77777777777778, 2) / 1.77777777777778

		setLocalScale(arg0_16.hpbar:Find("xuetiao01"), {
			x = var7_16
		})
	end

	local var8_16 = arg0_16.hpbar:Find("rewards")
	local var9_16 = var0_16:GetBattleStageId()
	local var10_16 = pg.world_expedition_data[var9_16]
	local var11_16 = var10_16 and var10_16.phase_drop

	setActive(var8_16, var11_16 and #var11_16 > 0)

	local var12_16 = var2_16

	if var0_16:IsPeriodEnemy() then
		var12_16 = math.min(var12_16, nowWorld():GetHistoryLowestHP(var0_16.id))
	end

	UIItemList.StaticAlign(var8_16, var8_16:GetChild(0), var11_16 and #var11_16 or 0, function(arg0_17, arg1_17, arg2_17)
		if arg0_17 ~= UIItemList.EventUpdate then
			return
		end

		local var0_17 = var11_16[arg1_17 + 1]
		local var1_17 = var0_17[1] / 10000

		arg2_17.anchorMin = Vector2(var1_17, 0.5)
		arg2_17.anchorMax = Vector2(var1_17, 0.5)

		setAnchoredPosition(arg2_17, {
			x = 0
		})

		local var2_17 = var12_16 <= var0_17[1] and "reward_empty" or "reward"

		arg0_16.loader:GetSprite("ui/worldbossinformationui_atlas", var2_17, arg2_17)
	end)

	local var13_16 = arg0_16.hpbar:Find("kedu")

	setLocalScale(var13_16, {
		x = arg0_16.hpbar.rect.width / var13_16.rect.width
	})
end

function var0_0.GetDungeonBossData(arg0_18, arg1_18)
	assert(arg1_18, "Attachment is null")

	local var0_18 = arg1_18.config.dungeon_id
	local var1_18 = arg0_18:GetDungeonFile(var0_18).stages[1].waves
	local var2_18

	_.any(var1_18, function(arg0_19)
		if not arg0_19.spawn then
			return
		end

		return _.any(arg0_19.spawn, function(arg0_20)
			if arg0_20.bossData then
				var2_18 = arg0_20

				return true
			end
		end)
	end)
	assert(var2_18, "Cant Find Boss Data in Dungeon: " .. (var0_18 or "NIL"))

	return var2_18
end

function var0_0.GetDungeonFile(arg0_21, arg1_21)
	if arg0_21.dungeonDict[arg1_21] then
		return arg0_21.dungeonDict[arg1_21]
	end

	local var0_21 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(arg1_21)

	arg0_21.dungeonDict[arg1_21] = var0_21

	return var0_21
end

local var3_0 = 212
local var4_0 = 40
local var5_0 = "fe2222"
local var6_0 = "92fc63"
local var7_0 = 70

function var0_0.updateStageView(arg0_22)
	local var0_22, var1_22 = arg0_22:GetCurrentAttachment()
	local var2_22 = var0_22:GetBattleStageId()
	local var3_22 = pg.expedition_data_template[var2_22]
	local var4_22 = pg.world_expedition_data[var2_22]

	assert(var3_22, "expedition_data_template not exist: " .. var2_22)

	local var5_22 = {}

	for iter0_22, iter1_22 in ipairs(var4_22.award_display_world) do
		if var1_22 == iter1_22[1] then
			var5_22 = iter1_22[2]
		end
	end

	local var6_22 = 0

	local function var7_22()
		for iter0_23 = 1, #arg0_22.dropitems do
			local var0_23 = arg0_22.dropitems[iter0_23]:Find("item_tpl")
			local var1_23 = var5_22[iter0_23 + var6_22]

			setActive(var0_23, var1_23 ~= nil)

			if var1_23 then
				local var2_23 = {
					type = var1_23[1],
					id = var1_23[2]
				}

				updateDrop(var0_23, var2_23)
				onButton(arg0_22, var0_23, function()
					arg0_22:emit(var0_0.ON_DROP, var2_23)
				end, SFX_PANEL)
			end
		end

		setActive(arg0_22.dropleft, var6_22 > 0)
		setActive(arg0_22.dropright, #var5_22 - var6_22 > #arg0_22.dropitems)
	end

	onButton(arg0_22, arg0_22.dropright, function()
		var6_22 = var6_22 + 1

		var7_22()
	end)
	onButton(arg0_22, arg0_22.dropleft, function()
		var6_22 = var6_22 - 1

		var7_22()
	end)
	var7_22()
	setActive(arg0_22.awardBtn, var4_22.phase_drop_display and #var4_22.phase_drop_display > 0)

	local var8_22 = var0_22:GetWeaknessBuffId()
	local var9_22 = pg.world_SLGbuff_data[var8_22]

	setActive(arg0_22.weaknesstext, var9_22 ~= nil)
	setActive(arg0_22.weaknessbg, var9_22 ~= nil)

	if var9_22 then
		setText(arg0_22.weaknesstext, i18n("word_weakness") .. ": " .. var9_22.desc)
	end

	local var10_22 = var9_22 == nil and var7_0 or 0

	setAnchoredPosition(arg0_22.attributeRoot, {
		y = arg0_22.attributeRootAnchorY - var10_22
	})
	;(function()
		local var0_27 = nowWorld():GetActiveMap()
		local var1_27 = table.mergeArray(var0_22:GetBuffList(), var0_27:GetBuffList(WorldMap.FactionEnemy, var0_22))
		local var2_27 = _.filter(var1_27, function(arg0_28)
			return arg0_28.id ~= var8_22
		end)

		UIItemList.StaticAlign(arg0_22.AdditionBuffContainer, arg0_22.AdditionBuffContainer:GetChild(0), #var2_27, function(arg0_29, arg1_29, arg2_29)
			if arg0_29 ~= UIItemList.EventUpdate then
				return
			end

			local var0_29 = var2_27[arg1_29 + 1]

			setActive(arg2_29, var0_29)

			if var0_29 then
				arg0_22.loader:GetSprite("world/buff/" .. var0_29.config.icon, "", arg2_29:Find("icon"))
				setText(arg2_29:Find("desc"), var0_29.config.desc)
			end
		end)
	end)()
	;(function()
		local var0_30 = var4_22.special_buff_display

		if not var0_30 or #var0_30 == 0 then
			var0_30 = nil
		end

		setActive(arg0_22.EquipmentBuffTF, var0_30)
		setActive(arg0_22.switchBuffBtn, var0_30)

		if not var0_30 then
			return
		end

		local var1_30 = _.map(var0_30, function(arg0_31)
			assert("world_SLGbuff_data Missing ID: " .. (arg0_31 or "NIL"))

			return pg.world_SLGbuff_data[arg0_31]
		end)

		UIItemList.StaticAlign(arg0_22.EquipmentBuffContainer, arg0_22.EquipmentBuffContainer:GetChild(0), #var1_30, function(arg0_32, arg1_32, arg2_32)
			if arg0_32 ~= UIItemList.EventUpdate then
				return
			end

			local var0_32 = var1_30[arg1_32 + 1]

			setActive(arg2_32, var0_32)

			if var0_32 then
				arg0_22.loader:GetSprite("world/buff/" .. var0_32.icon, "", arg2_32:Find("icon"))
				setText(arg2_32:Find("desc"), var0_32.desc)
			end
		end)
	end)()
	Canvas.ForceUpdateCanvases()

	local var11_22 = arg0_22.AdditionBuffTF.rect.height
	local var12_22 = arg0_22.EquipmentBuffTF.rect.height
	local var13_22

	var13_22.y, var13_22 = math.max(var11_22, var12_22) + 50, arg0_22.buffListTF.sizeDelta
	arg0_22.buffListTF.sizeDelta = var13_22

	arg0_22:UpdateHpbar()

	local var14_22 = ys.Battle.BattleFormulas
	local var15_22 = nowWorld()
	local var16_22 = var15_22:GetWorldMapDifficultyBuffLevel()
	local var17_22 = {
		var16_22[1] * (1 + var4_22.expedition_sairenvalueA / 10000),
		var16_22[2] * (1 + var4_22.expedition_sairenvalueB / 10000),
		var16_22[3] * (1 + var4_22.expedition_sairenvalueC / 10000)
	}
	local var18_22 = var15_22:GetWorldMapBuffLevel()
	local var19_22, var20_22, var21_22 = var14_22.WorldMapRewardAttrEnhance(var17_22, var18_22)
	local var22_22 = 1 - var14_22.WorldMapRewardHealingRate(var17_22, var18_22)
	local var23_22 = {
		var19_22,
		var20_22,
		var22_22
	}

	for iter2_22 = 1, #arg0_22.attributes do
		local var24_22 = arg0_22.attributes[iter2_22]

		setText(var24_22:Find("digit"), string.format("%d", var17_22[iter2_22]))

		local var25_22 = iter2_22 == 3 and 1 - var23_22[iter2_22] or var23_22[iter2_22] + 1

		setText(var24_22:Find("desc"), i18n("world_mapbuff_attrtxt_" .. iter2_22) .. string.format(" %d%%", var25_22 * 100))

		local var26_22 = GetOrAddComponent(var24_22, typeof(UILongPressTrigger))

		var26_22.onPressed:RemoveAllListeners()
		var26_22.onReleased:RemoveAllListeners()

		local var27_22
		local var28_22

		var26_22.onPressed:AddListener(function()
			var27_22 = go(var24_22:Find("extra")).activeSelf

			setActive(var24_22:Find("extra"), true)

			var28_22 = Time.realtimeSinceStartup
		end)
		var26_22.onReleased:AddListener(function()
			if not var28_22 or Time.realtimeSinceStartup - var28_22 < 0.3 then
				setActive(var24_22:Find("extra"), not var27_22)
			else
				setActive(var24_22:Find("extra"), false)
			end
		end)
		setText(var24_22:Find("extra/enemy"), var17_22[iter2_22])
		setText(var24_22:Find("extra/ally"), var18_22[iter2_22])
		setText(var24_22:Find("extra/result"), string.format("%d%%", var23_22[iter2_22] * 100))
		setTextColor(var24_22:Find("extra/result"), var23_22[iter2_22] > 0 and arg0_22.TransformColor(var5_0) or arg0_22.TransformColor(var6_0))
		setText(var24_22:Find("extra/result/arrow"), var23_22[iter2_22] == 0 and "" or var23_22[iter2_22] > 0 and "↑" or "↓")

		if var23_22[iter2_22] ~= 0 then
			setTextColor(var24_22:Find("extra/result/arrow"), var23_22[iter2_22] > 0 and arg0_22.TransformColor(var5_0) or arg0_22.TransformColor(var6_0))
		end

		local var29_22 = var24_22:Find("extra/allybar")
		local var30_22 = var24_22:Find("extra/enemybar")
		local var31_22 = math.clamp(1 + var23_22[iter2_22], 0.75, 3)
		local var32_22 = var24_22:Find("extra").rect.width

		var30_22.sizeDelta = Vector2(var31_22 * var32_22 / (var31_22 + 1) + var2_0 * 0.5, var30_22.sizeDelta.y)
		var29_22.sizeDelta = Vector2(1 * var32_22 / (var31_22 + 1) + var2_0 * 0.5, var29_22.sizeDelta.y)
	end

	local var33_22 = var4_22.battle_character
	local var34_22 = var33_22 and #var33_22 > 0

	var33_22 = var34_22 and var33_22 or "world_boss_0"
	arg0_22.bg:GetComponent(typeof(Image)).enabled = true

	setImageSprite(arg0_22.bg, GetSpriteFromAtlas("commonbg/" .. var33_22, var33_22))
	;(function()
		local var0_35 = var3_22.name

		arg0_22.bossnameText.text = var0_35

		local var1_35 = false

		if arg0_22.bossnameText.preferredWidth > arg0_22.bossnameText.transform.rect.width then
			local var2_35 = string.gsub(var0_35, "「.-」", "\n%1")

			arg0_22.bossnameText.text = var2_35
			var1_35 = true
		end

		setAnchoredPosition(arg0_22.bossNameBanner, {
			y = var1_35 and -18 or 0
		})
		setText(arg0_22.bosslevel, i18n("world_level_prefix", arg0_22:GetEnemyLevel(var3_22) or 1))
		setActive(arg0_22.bosslogos[1], var34_22)
		setActive(arg0_22.bosslogos[2], not var34_22)
		setActive(arg0_22.saomiaoxian, not var34_22)

		local var3_35 = arg0_22:GetDungeonBossData(var0_22).monsterTemplateID
		local var4_35 = ys.Battle.BattleDataFunction.GetMonsterTmpDataFromID(var3_35)

		arg0_22.loader:GetSprite("shiptype", ShipType.Type2BattlePrint(var4_35.type), arg0_22.bossTypeIcon, true)
		setText(arg0_22.bossArmorText, ArmorType.Type2Name(var4_35.armor_type))
	end)()

	local var35_22 = ys.Battle.BattleAttr.IsWorldMapRewardAttrWarning(var17_22, var18_22)

	setActive(arg0_22.dangerMark, var35_22)

	if var35_22 then
		setAnchoredPosition(arg0_22.dangerMark, {
			x = var34_22 and var4_0 or var3_0
		})
	end

	if not var34_22 then
		local var36_22 = var3_22.icon_type

		if var36_22 == 1 then
			arg0_22.loader:GetSprite("enemies/" .. var3_22.icon, nil, arg0_22.bosssprite)
		elseif var36_22 == 2 then
			arg0_22.bosssprite:GetComponent(typeof(Image)).enabled = false

			arg0_22.loader:GetSpine(var3_22.icon, function(arg0_36)
				local var0_36 = var4_22.battle_spine_size * 0.01

				arg0_36.transform.localScale = Vector3(var0_36, var0_36, 1)
				arg0_36.transform.anchoredPosition = Vector3.New(0, -150, 0)

				arg0_36.transform:GetComponent("SpineAnimUI"):SetAction(ChapterConst.ShipIdleAction, 0)

				arg0_36.transform:GetComponent("SkeletonGraphic").raycastTarget = false

				setParent(arg0_36, arg0_22.bosssprite, false)
			end, arg0_22.bosssprite)
		end
	end
end

function var0_0.onBackPressed(arg0_37)
	if arg0_37.awardPanel and arg0_37.awardPanel:isShowing() then
		arg0_37.awardPanel:Hide()

		return
	end

	triggerButton(arg0_37.backBtn)
end

function var0_0.willExit(arg0_38)
	arg0_38:DestroyAwardPanel()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_38.layer, arg0_38._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38._tf)

	if arg0_38.resPanel then
		arg0_38.resPanel:exit()

		arg0_38.resPanel = nil
	end

	for iter0_38, iter1_38 in pairs(arg0_38.dungeonDict) do
		ys.Battle.BattleDataFunction.ClearDungeonCfg(iter0_38)
	end

	table.clear(arg0_38.dungeonDict)
	arg0_38.loader:Clear()
end

function var0_0.GetAwardPanel(arg0_39)
	arg0_39.awardPanel = arg0_39.awardPanel or WorldBossHPAwardPanel.New(arg0_39._tf, arg0_39.event, arg0_39.contextData)

	arg0_39.awardPanel:Load()

	return arg0_39.awardPanel
end

function var0_0.DestroyAwardPanel(arg0_40)
	if not arg0_40.awardPanel then
		return
	end

	arg0_40.awardPanel:Destroy()

	arg0_40.awardPanel = nil
end

function var0_0.TransformColor(arg0_41)
	local var0_41 = tonumber(string.sub(arg0_41, 1, 2), 16)
	local var1_41 = tonumber(string.sub(arg0_41, 3, 4), 16)
	local var2_41 = tonumber(string.sub(arg0_41, 5, 6), 16)

	return Color.New(var0_41 / 255, var1_41 / 255, var2_41 / 255)
end

return var0_0
