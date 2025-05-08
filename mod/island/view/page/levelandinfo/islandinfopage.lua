local var0_0 = class("IslandInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("frame/back")
	arg0_2.levelTxt = arg0_2:findTF("frame/left/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("frame/left/objective/exp"):GetComponent(typeof(Text))
	arg0_2.goldTxt = arg0_2:findTF("frame/left/objective/gold"):GetComponent(typeof(Text))
	arg0_2.expProgress = arg0_2:findTF("frame/left/exp/bar")
	arg0_2.preViewBtn = arg0_2:findTF("frame/left/preview")
	arg0_2.upgradeBtn = arg0_2:findTF("frame/left/upgrade_btn")
	arg0_2.prosperityLevel = arg0_2:findTF("frame/right/prosperity/level"):GetComponent(typeof(Text))
	arg0_2.prosperityExp = arg0_2:findTF("frame/right/prosperity/exp"):GetComponent(typeof(Text))
	arg0_2.prosperityIcon = arg0_2:findTF("frame/right/prosperity/icon")
	arg0_2.nameTxt = arg0_2:findTF("frame/left/name/Text"):GetComponent(typeof(Text))
	arg0_2.editNameBtn = arg0_2:findTF("frame/left/name")
	arg0_2.uiShipList = UIItemList.New(arg0_2:findTF("frame/right/ships/list"), arg0_2:findTF("frame/right/ships/list/tpl"))
	arg0_2.upgradePreviewPanel = arg0_2:findTF("frame/left/upgrade_preview")
	arg0_2.upgradeAwardList = UIItemList.New(arg0_2:findTF("frame/left/upgrade_preview/content/awards/list/content"), arg0_2:findTF("frame/left/upgrade_preview/content/awards/list/content/tpl"))
	arg0_2.upgradeUnlockList = UIItemList.New(arg0_2:findTF("frame/left/upgrade_preview/content/unlock/list/content"), arg0_2:findTF("frame/left/upgrade_preview/content/awards/list/content/tpl"))
	arg0_2.prosperityLevelList = UIItemList.New(arg0_2:findTF("frame/right/prosperity/objective/content"), arg0_2:findTF("frame/right/prosperity/objective/content/tpl"))
	arg0_2.prosperityAwardList = UIItemList.New(arg0_2:findTF("frame/right/prosperity/objective/awards"), arg0_2:findTF("frame/right/prosperity/objective/awards/tpl"))
	arg0_2.getProsperityBtn = arg0_2:findTF("frame/right/prosperity/objective/get_btn")
	arg0_2.goProsperityBtn = arg0_2:findTF("frame/right/prosperity/objective/go_btn")
	arg0_2.goProsperityBtnTxt = arg0_2:findTF("frame/right/prosperity/objective/go_btn/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/left/preview/Text"), i18n1("升级预览"))
	setText(arg0_2:findTF("frame/left/objective/label_exp"), i18n1("岛屿经验"))
	setText(arg0_2:findTF("frame/left/objective/label_gold"), i18n1("需求物资"))
	setText(arg0_2:findTF("frame/left/upgrade_preview/content/awards/label"), i18n1("奖励"))
	setText(arg0_2:findTF("frame/left/upgrade_preview/content/unlock/label"), i18n1("解锁"))
	setText(arg0_2:findTF("frame/right/prosperity/objective/get_btn/Text"), i18n1("领取"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.editNameBtn, function()
		arg0_3:OpenPage(IslandEditNamePage)
	end, SFX_PANEL)

	arg0_3.showPreviewPanel = false
	arg0_3.displayPreviewLevel = -1

	onButton(arg0_3, arg0_3.preViewBtn, function()
		local var0_7 = getProxy(IslandProxy):GetIsland()

		if var0_7:IsMaxLevel() then
			return
		end

		arg0_3.showPreviewPanel = not arg0_3.showPreviewPanel

		setActive(arg0_3.upgradePreviewPanel, arg0_3.showPreviewPanel)

		local var1_7 = var0_7:GetLevel()

		if arg0_3.showPreviewPanel and arg0_3.displayPreviewLevel ~= var1_7 then
			arg0_3.displayPreviewLevel = var1_7

			arg0_3:InitUpgradeAwards(var0_7)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		local var0_8 = getProxy(IslandProxy):GetIsland()

		if not var0_8:CanLevelUp() then
			return
		end

		local var1_8 = "#39bfff"
		local var2_8 = "#f36c6e"
		local var3_8 = var0_8:GetUpgradeConsume()[1]
		local var4_8 = Drop.New({
			type = var3_8[1],
			id = var3_8[2],
			count = var3_8[3]
		})
		local var5_8 = var4_8:getOwnedCount()
		local var6_8 = _customColorCount(var5_8, var4_8.count, var1_8, var2_8)

		arg0_3:ShowMsgBox({
			title = i18n1("确认升级"),
			content = i18n1("<color=#393a3c>是否确认消耗以下资源并升级岛屿</color>\n 物资：" .. var6_8),
			onYes = function()
				arg0_3:emit(IslandMediator.ON_UPGRADE)
			end
		})
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_10.OnUpgrade)
	arg0_10:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_10.OnGetAward)
	arg0_10:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_10.OnModifyName)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_11.OnUpgrade)
	arg0_11:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_11.OnGetAward)
	arg0_11:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_11.OnModifyName)
end

function var0_0.OnUpgrade(arg0_12)
	local var0_12 = getProxy(IslandProxy):GetIsland()

	arg0_12:UpdateLevel(var0_12)
end

function var0_0.OnGetAward(arg0_13)
	local var0_13 = getProxy(IslandProxy):GetIsland()

	arg0_13:UpdateProsperity(var0_13)
end

function var0_0.OnModifyName(arg0_14)
	local var0_14 = getProxy(IslandProxy):GetIsland()

	arg0_14:UpdateName(var0_14)
end

function var0_0.Show(arg0_15)
	var0_0.super.Show(arg0_15)

	local var0_15 = getProxy(IslandProxy):GetIsland()

	arg0_15:UpdateLevel(var0_15)
	arg0_15:UpdateProsperity(var0_15)
	arg0_15:UpdateName(var0_15)
	arg0_15:UpdateShips(var0_15)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_15._tf, {
		pbList = {
			arg0_15:findTF("frame/right")
		},
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_16)
	var0_0.super.Hide(arg0_16)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16._tf, arg0_16._parentTf)
end

function var0_0.InitUpgradeAwards(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetUpgradeAwards()

	arg0_17.upgradeAwardList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18 + 1]
			local var1_18 = Drop.Create(var0_18)

			updateDrop(arg2_18, var1_18)
		end
	end)
	arg0_17.upgradeAwardList:align(#var0_17)

	local var1_17 = arg1_17:GetUnlockBuildingList()

	arg0_17.upgradeUnlockList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var1_17[arg1_19 + 1]
			local var1_19 = Drop.Create(var0_19)

			updateDrop(arg2_19, var1_19)
		end
	end)
	arg0_17.upgradeUnlockList:align(#var1_17)
end

function var0_0.UpdateLevel(arg0_20, arg1_20)
	arg0_20.levelTxt.text = arg1_20:GetLevel()

	local var0_20 = arg1_20:GetExp()
	local var1_20 = arg1_20:GetTargeExp()
	local var2_20 = "#39bfff"
	local var3_20 = "#f36c6e"

	customColorCount(arg0_20.expTxt, var0_20, var1_20, var2_20, var3_20)
	setFillAmount(arg0_20.expProgress, Mathf.Clamp01(var0_20 / var1_20))

	local var4_20 = arg1_20:GetUpgradeConsume()[1]

	if var4_20 == nil then
		arg0_20.goldTxt.tetx = ""
	else
		local var5_20 = Drop.Create(var4_20)
		local var6_20 = var5_20:getOwnedCount()

		customColorCount(arg0_20.goldTxt, var6_20, var5_20.count, var2_20, var3_20)
	end

	setGray(arg0_20.upgradeBtn, not arg1_20:CanLevelUp(), true)
end

function var0_0.UpdateProsperity(arg0_21, arg1_21)
	local var0_21 = {}

	arg0_21.prosperityLevelList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = pg.island_prosperity.all[arg1_22 + 1]

			arg0_21:UpdateProsperityCard(arg2_22, var0_22, arg1_21)

			var0_21[var0_22] = arg2_22
		end
	end)
	arg0_21.prosperityLevelList:align(#pg.island_prosperity.all)

	local var1_21 = var0_21[arg1_21:GetProsperityLevel()] or var0_21[1]

	if var1_21 then
		triggerToggle(var1_21, true)
	end
end

function var0_0.UpdateProsperityCard(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg3_23:CanGetProsperityAwards(arg2_23)
	local var1_23 = arg3_23:IsReceiveProsperityAwards(arg2_23)
	local var2_23 = arg3_23:GetProsperityLevel() == arg2_23
	local var3_23 = arg3_23:GetMaxProsperityLevel()

	setActive(arg1_23:Find("line"), var3_23 ~= arg2_23)
	setActive(arg1_23:Find("got"), var1_23)
	setActive(arg1_23:Find("get"), var0_23)
	setActive(arg1_23:Find("lock"), not var0_23 and not var1_23 and not var2_23)
	setActive(arg1_23:Find("curr"), var2_23 and not var1_23)
	onToggle(arg0_23, arg1_23, function()
		arg0_23:FlushProsperity(arg3_23, arg2_23, var0_23, var1_23)
	end, SFX_PANEL)
end

function var0_0.FlushProsperity(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = ArabicToRoman(arg2_25)

	arg0_25.prosperityLevel.text = var0_25

	local var1_25 = arg1_25:GetProsperity()
	local var2_25 = arg1_25:GetTargetProsperityByLevel(arg2_25)

	arg0_25.prosperityExp.text = i18n1("小岛当前繁荣度：") .. var1_25 .. "/" .. var2_25

	local var3_25 = arg1_25:GetProsperityAward(arg2_25)

	arg0_25.prosperityAwardList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var3_25[arg1_26 + 1]
			local var1_26 = Drop.Create(var0_26)

			updateDrop(arg2_26, var1_26)
		end
	end)
	arg0_25.prosperityAwardList:align(#var3_25)
	setActive(arg0_25.getProsperityBtn, arg3_25)
	setActive(arg0_25.goProsperityBtn, not arg4_25 and not arg3_25)

	arg0_25.goProsperityBtnTxt.text = i18n1("繁荣度达到：") .. var2_25

	onButton(arg0_25, arg0_25.getProsperityBtn, function()
		arg0_25:emit(IslandMediator.GET_PROSPERITY_AWARD, arg2_25)
	end, SFX_PANEL)
	GetImageSpriteFromAtlasAsync("IslandProsperityIcon/" .. arg2_25, "", arg0_25.prosperityIcon)
end

function var0_0.UpdateName(arg0_28, arg1_28)
	arg0_28.nameTxt.text = arg1_28:GetName()
end

function var0_0.UpdateShips(arg0_29, arg1_29)
	local var0_29 = arg1_29:GetCharacterAgency():GetShips()

	arg0_29.uiShipList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = var0_29[arg1_30 + 1]

			arg0_29:UpdateShipCard(arg2_30, var0_30)
		end
	end)
	arg0_29.uiShipList:align(5)
end

function var0_0.UpdateShipCard(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg2_31 == nil

	setActive(arg1_31:Find("add"), var0_31)
	setActive(arg1_31:Find("ship"), not var0_31)

	if not var0_31 then
		local var1_31 = arg2_31:GetPrefab()

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_31, "", arg1_31:Find("ship/mask/icon"))
	end

	onButton(arg0_31, arg1_31, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_33)
	return
end

return var0_0
