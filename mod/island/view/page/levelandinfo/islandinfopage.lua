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

	setText(arg0_2:findTF("frame/left/preview/Text"), i18n("island_upgrade_preview"))
	setText(arg0_2:findTF("frame/left/objective/label_exp"), i18n("island_upgrade_exp"))
	setText(arg0_2:findTF("frame/left/objective/label_gold"), i18n("island_upgrade_res"))
	setText(arg0_2:findTF("frame/left/upgrade_preview/content/awards/label"), i18n("island_word_award"))
	setText(arg0_2:findTF("frame/left/upgrade_preview/content/unlock/label"), i18n("island_word_unlock"))
	setText(arg0_2:findTF("frame/right/prosperity/objective/get_btn/Text"), i18n("island_word_get"))
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
end

function var0_0.AddListeners(arg0_8)
	arg0_8:AddListener(GAME.ISLAND_UPGRADE_DONE, arg0_8.OnUpgrade)
	arg0_8:AddListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_8.OnGetAward)
	arg0_8:AddListener(GAME.ISLAND_SET_NAME_DONE, arg0_8.OnModifyName)
end

function var0_0.RemoveListeners(arg0_9)
	arg0_9:RemoveListener(GAME.ISLAND_UPGRADE_DONE, arg0_9.OnUpgrade)
	arg0_9:RemoveListener(GAME.ISLAND_PROSPERITY_AWARD_DONE, arg0_9.OnGetAward)
	arg0_9:RemoveListener(GAME.ISLAND_SET_NAME_DONE, arg0_9.OnModifyName)
end

function var0_0.OnUpgrade(arg0_10)
	local var0_10 = getProxy(IslandProxy):GetIsland()

	arg0_10:UpdateLevel(var0_10)
end

function var0_0.OnGetAward(arg0_11)
	local var0_11 = getProxy(IslandProxy):GetIsland()

	arg0_11:UpdateProsperity(var0_11)
end

function var0_0.OnModifyName(arg0_12)
	local var0_12 = getProxy(IslandProxy):GetIsland()

	arg0_12:UpdateName(var0_12)
end

function var0_0.Show(arg0_13)
	var0_0.super.Show(arg0_13)

	local var0_13 = getProxy(IslandProxy):GetIsland()

	arg0_13:UpdateLevel(var0_13)
	arg0_13:UpdateProsperity(var0_13)
	arg0_13:UpdateName(var0_13)
	arg0_13:UpdateShips(var0_13)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_13._tf, {
		pbList = {
			arg0_13:findTF("frame/right")
		}
	})
end

function var0_0.Hide(arg0_14)
	var0_0.super.Hide(arg0_14)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf, arg0_14._parentTf)
end

function var0_0.InitUpgradeAwards(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetUpgradeAwards()

	arg0_15.upgradeAwardList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]
			local var1_16 = Drop.Create(var0_16)

			updateCustomDrop(arg2_16, var1_16)
		end
	end)
	arg0_15.upgradeAwardList:align(#var0_15)

	local var1_15 = arg1_15:GetUnlockBuildingList()

	arg0_15.upgradeUnlockList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var1_15[arg1_17 + 1]
			local var1_17 = Drop.Create(var0_17)

			updateCustomDrop(arg2_17, var1_17)
		end
	end)
	arg0_15.upgradeUnlockList:align(#var1_15)
end

function var0_0.UpdateLevel(arg0_18, arg1_18)
	arg0_18.levelTxt.text = arg1_18:GetLevel()

	local var0_18 = arg1_18:GetExp()
	local var1_18 = arg1_18:GetTargeExp()
	local var2_18 = "#39bfff"
	local var3_18 = "#f36c6e"

	customColorCount(arg0_18.expTxt, var0_18, var1_18, var2_18, var3_18)
	setFillAmount(arg0_18.expProgress, Mathf.Clamp01(var0_18 / var1_18))
end

function var0_0.UpdateProsperity(arg0_19, arg1_19)
	local var0_19 = {}

	arg0_19.prosperityLevelList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = pg.island_prosperity.all[arg1_20 + 1]

			arg0_19:UpdateProsperityCard(arg2_20, var0_20, arg1_19)

			var0_19[var0_20] = arg2_20
		end
	end)
	arg0_19.prosperityLevelList:align(#pg.island_prosperity.all)

	local var1_19 = var0_19[arg1_19:GetProsperityLevel()] or var0_19[1]

	if var1_19 then
		triggerToggle(var1_19, true)
	end
end

function var0_0.UpdateProsperityCard(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg3_21:CanGetProsperityAwards(arg2_21)
	local var1_21 = arg3_21:IsReceiveProsperityAwards(arg2_21)
	local var2_21 = arg3_21:GetProsperityLevel() == arg2_21
	local var3_21 = arg3_21:GetMaxProsperityLevel()

	setActive(arg1_21:Find("line"), var3_21 ~= arg2_21)
	setActive(arg1_21:Find("got"), var1_21)
	setActive(arg1_21:Find("get"), var0_21)
	setActive(arg1_21:Find("lock"), not var0_21 and not var1_21 and not var2_21)
	setActive(arg1_21:Find("curr"), var2_21 and not var1_21)
	onToggle(arg0_21, arg1_21, function()
		arg0_21:FlushProsperity(arg3_21, arg2_21, var0_21, var1_21)
	end, SFX_PANEL)
end

function var0_0.FlushProsperity(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23 = ArabicToRoman(arg2_23)

	arg0_23.prosperityLevel.text = var0_23

	local var1_23 = arg1_23:GetProsperity()
	local var2_23 = arg1_23:GetTargetProsperityByLevel(arg2_23)

	arg0_23.prosperityExp.text = i18n("island_prosperity_level_display", var1_23 .. "/" .. var2_23)

	local var3_23 = arg1_23:GetProsperityAward(arg2_23)

	arg0_23.prosperityAwardList:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var3_23[arg1_24 + 1]
			local var1_24 = Drop.Create(var0_24)

			updateCustomDrop(arg2_24, var1_24)
		end
	end)
	arg0_23.prosperityAwardList:align(#var3_23)
	setActive(arg0_23.getProsperityBtn, arg3_23)
	setActive(arg0_23.goProsperityBtn, not arg4_23 and not arg3_23)

	arg0_23.goProsperityBtnTxt.text = i18n("island_prosperity_value_display", var2_23)

	onButton(arg0_23, arg0_23.getProsperityBtn, function()
		arg0_23:emit(IslandMediator.GET_PROSPERITY_AWARD, arg2_23)
	end, SFX_PANEL)
	GetImageSpriteFromAtlasAsync("island/IslandProsperityIcon/" .. arg2_23, "", arg0_23.prosperityIcon)
end

function var0_0.UpdateName(arg0_26, arg1_26)
	arg0_26.nameTxt.text = arg1_26:GetName()
end

function var0_0.UpdateShips(arg0_27, arg1_27)
	local var0_27 = arg1_27:GetCharacterAgency():GetShips()

	arg0_27.uiShipList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var0_27[arg1_28 + 1]

			arg0_27:UpdateShipCard(arg2_28, var0_28)
		end
	end)
	arg0_27.uiShipList:align(5)
end

function var0_0.UpdateShipCard(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29 == nil

	setActive(arg1_29:Find("add"), var0_29)
	setActive(arg1_29:Find("ship"), not var0_29)

	if not var0_29 then
		local var1_29 = arg2_29:GetPrefab()

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_29, "", arg1_29:Find("ship/mask/icon"))
	end

	onButton(arg0_29, arg1_29, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_31)
	return
end

return var0_0
