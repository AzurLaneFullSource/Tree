local var0_0 = class("IslandShipInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.energyTipTr = arg0_2:findTF("adapt/name_panel/tip")
	arg0_2.energyTipTxt = arg0_2:findTF("adapt/name_panel/tip/Text"):GetComponent(typeof(Text))
	arg0_2.energyTr = arg0_2:findTF("adapt/name_panel/energy")
	arg0_2.energyTxt = arg0_2:findTF("adapt/name_panel/energy"):GetComponent(typeof(Text))
	arg0_2.energyLabel = arg0_2:findTF("adapt/name_panel/energy/label")
	arg0_2.nameTxt = arg0_2:findTF("adapt/name_panel/name"):GetComponent(typeof(Text))
	arg0_2.nameEnTxt = arg0_2:findTF("adapt/name_panel/en"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2:findTF("adapt/main_panel/level/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("adapt/main_panel/level/exp"):GetComponent(typeof(Text))
	arg0_2.expProgress = arg0_2:findTF("adapt/main_panel/level/progress")
	arg0_2.upgradeBtn = arg0_2:findTF("adapt/main_panel/level/add")
	arg0_2.breakoutBtn = arg0_2:findTF("adapt/main_panel/level/breakout")
	arg0_2.uiAttrList = UIItemList.New(arg0_2:findTF("adapt/main_panel/attr/list"), arg0_2:findTF("adapt/main_panel/attr/list/tpl"))
	arg0_2.attrUpgradeBtn = arg0_2:findTF("adapt/main_panel/attr/upgrade")
	arg0_2.skillTr = arg0_2:findTF("adapt/main_panel/skill")
	arg0_2.skillIconImg = arg0_2:findTF("adapt/main_panel/skill/icon")
	arg0_2.skillName = arg0_2:findTF("adapt/main_panel/skill/info/name"):GetComponent(typeof(Text))
	arg0_2.skillLevel = arg0_2:findTF("adapt/main_panel/skill/info/level"):GetComponent(typeof(Text))
	arg0_2.skillDesc = arg0_2:findTF("adapt/main_panel/skill/info/desc/Text"):GetComponent(typeof(Text))
	arg0_2.skillMask = arg0_2:findTF("adapt/main_panel/skill_mask")
	arg0_2.skillMaskLabel = arg0_2:findTF("adapt/main_panel/skill_mask/content/Text")
	arg0_2.skillUpgradeBtn = arg0_2:findTF("adapt/main_panel/skill/upgrade")
	arg0_2.skillInfoBtn = arg0_2:findTF("adapt/main_panel/skill/click")
	arg0_2.breakOutList = UIItemList.New(arg0_2:findTF("adapt/main_panel/level/starts"), arg0_2:findTF("adapt/main_panel/level/starts/tpl"))
	arg0_2.statusPanel = IslandShipStatusPanel.New(arg0_2:findTF("adapt/main_panel/status"), arg0_2:findTF("adapt/main_panel/status_empty"))

	setText(arg0_2.energyLabel, i18n("island_ship_energy"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.energyTr, function()
		arg0_3:DisplayEnergyTip()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.skillUpgradeBtn, function()
		if arg0_3.ship:GetSkill():IsMaxLevel() then
			return
		end

		arg0_3:OpenPage(IslandShipSkillUpgradePage, arg0_3.ship)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		if arg0_3.ship:IsMaxLevel() then
			if arg0_3.ship:IsMaxBreakLevel() then
				return
			end

			arg0_3:OpenPage(IslandShipBreakoutPage, arg0_3.ship)
		else
			arg0_3:OpenPage(IslandShipUpgradePage, arg0_3.ship)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.breakoutBtn, function()
		triggerButton(arg0_3.upgradeBtn)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.attrUpgradeBtn, function()
		arg0_3:OpenPage(IslandShipAttrUpgradePage, arg0_3.ship)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.skillInfoBtn, function()
		arg0_3:ShowMsgBox({
			type = IslandMsgBox.TYPE_SHIP_SKILL,
			skill = arg0_3.ship:GetSkill()
		})
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_10, arg1_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_10)

	if var0_10 == nil then
		return
	end

	arg0_10:UpdateMainView(var0_10)

	arg0_10.ship = var0_10
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE, arg0_11.OnUseExpBook)
	arg0_11:AddListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_11.OnBreakOut)
	arg0_11:AddListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_11.OnAttrUpgrade)
	arg0_11:AddListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_11.OnSkillUpgrade)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE, arg0_12.OnUseExpBook)
	arg0_12:RemoveListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_12.OnBreakOut)
	arg0_12:RemoveListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_12.OnAttrUpgrade)
	arg0_12:RemoveListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_12.OnSkillUpgrade)
end

function var0_0.OnAttrUpgrade(arg0_13)
	arg0_13:UpdateAttrs(arg0_13.ship)
end

function var0_0.OnUseExpBook(arg0_14)
	arg0_14:UpdateLevelAndExp(arg0_14.ship)
	arg0_14:UpdateAttrs(arg0_14.ship)
end

function var0_0.OnBreakOut(arg0_15)
	local var0_15 = arg0_15.ship

	arg0_15:UpdateEnergy(var0_15)
	arg0_15:UpdateLevelAndExp(var0_15)
	arg0_15:UpdateAttrs(var0_15)
	arg0_15:UpdateSkill(var0_15)
	arg0_15:UpdateBreakOutLevel(var0_15)
end

function var0_0.OnSkillUpgrade(arg0_16)
	local var0_16 = arg0_16.ship

	arg0_16:UpdateSkill(var0_16)
end

function var0_0.UpdateMainView(arg0_17, arg1_17)
	arg0_17:UpdateEnergy(arg1_17)
	arg0_17:UpdateLevelAndExp(arg1_17)
	arg0_17:UpdateAttrs(arg1_17)
	arg0_17:UpdateSkill(arg1_17)
	arg0_17:UpdateBreakOutLevel(arg1_17)
	arg0_17:UpdateStatus(arg1_17)

	arg0_17.ship = arg1_17
end

function var0_0.DisplayEnergyTip(arg0_18)
	arg0_18:RemoveCloseEnergyTipTimer()
	setActive(arg0_18.energyTipTr, true)

	arg0_18.energyTipTxt.text = i18n("island_ship_energy_full")

	arg0_18:AddCloseEnergyTipTimer()
end

function var0_0.AddCloseEnergyTipTimer(arg0_19)
	arg0_19.timer = Timer.New(function()
		arg0_19:RemoveCloseEnergyTipTimer()
	end, 3)

	arg0_19.timer:Start()
end

function var0_0.RemoveCloseEnergyTipTimer(arg0_21)
	setActive(arg0_21.energyTipTr, false)

	if arg0_21.timer then
		arg0_21.timer:Stop()

		arg0_21.timer = nil
	end
end

function var0_0.UpdateBreakOutLevel(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetBreakLevel()

	arg0_22.breakOutList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = arg1_23 + 1

			setActive(arg2_23:Find("Image"), var0_23 <= var0_22)
		end
	end)
	arg0_22.breakOutList:align(arg1_22:GetBreakMaxLevel())
end

function var0_0.UpdateEnergy(arg0_24, arg1_24)
	local var0_24 = arg1_24:GetEnergy()
	local var1_24 = arg1_24:GetMaxEnergy()
	local var2_24 = var0_24 <= 20 and "<color=#ab4734>" .. var0_24 .. "</color>" or var0_24

	arg0_24.energyTxt.text = "[" .. var2_24 .. "/" .. var1_24 .. "]"
end

function var0_0.UpdateLevelAndExp(arg0_25, arg1_25)
	arg0_25.nameTxt.text = arg1_25:GetName()
	arg0_25.nameEnTxt.text = arg1_25:GetEnName()
	arg0_25.levelTxt.text = "Level:" .. arg1_25:GetLevel()

	if not arg1_25:IsMaxLevel() then
		local var0_25 = arg1_25:GetExp()
		local var1_25 = arg1_25:GetTargetExp()

		arg0_25.expTxt.text = var0_25 .. "/" .. var1_25

		setSlider(arg0_25.expProgress, 0, 1, var0_25 / var1_25)
	else
		arg0_25.expTxt.text = "[MAX]"

		setSlider(arg0_25.expProgress, 0, 1, 1)
	end

	setActive(arg0_25.upgradeBtn, not arg1_25:IsMaxLevel())
	setActive(arg0_25.breakoutBtn, arg1_25:IsMaxLevel() and not arg1_25:IsMaxBreakLevel())
end

function var0_0.UpdateAttrs(arg0_26, arg1_26)
	local var0_26 = IslandShipAttr.ATTRS

	arg0_26.uiAttrList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = arg1_27 + 1

			arg0_26:UpdateAttr(arg2_27, var0_26, var0_27, arg1_26)
		end
	end)
	arg0_26.uiAttrList:align(#var0_26)
end

function var0_0.UpdateAttr(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28)
	local var0_28 = arg2_28[arg3_28]
	local var1_28 = arg4_28:GetAttr(var0_28)

	setText(arg1_28:Find("name"), IslandShipAttr.ToChinese(var0_28))
	setText(arg1_28:Find("value"), var1_28)

	local var2_28 = arg4_28:GetAttrGrade(var0_28)
	local var3_28 = IslandShipAttr.Grade2Img(var2_28)

	GetImageSpriteFromAtlasAsync("ui/IslandShipUI_atlas", var3_28[1], arg1_28:Find("grade"))
	GetImageSpriteFromAtlasAsync("ui/IslandShipUI_atlas", var3_28[2], arg1_28:Find("grade_bg"))
end

function var0_0.UpdateSkill(arg0_29, arg1_29)
	local var0_29 = arg1_29:GetSkill()

	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_29:GetIcon(), "", arg0_29.skillIconImg)

	arg0_29.skillName.text = var0_29:GetName()
	arg0_29.skillLevel.text = "[Lv." .. var0_29:GetLevel() .. "]"
	arg0_29.skillDesc.text = var0_29:GetEffectDesc()

	local var1_29 = var0_29:IsUnlock()

	setActive(arg0_29.skillTr, var1_29)
	setActive(arg0_29.skillMask, not var1_29)
	setText(arg0_29.skillMaskLabel, i18n("island_need_star", arg1_29:GetSkillUnlockLevel()))
	setActive(arg0_29.skillUpgradeBtn, not var0_29:IsMaxLevel())
end

function var0_0.UpdateStatus(arg0_30, arg1_30)
	arg0_30.statusPanel:Flush(arg1_30)

	local var0_30 = arg1_30:GetDisplayStatus()

	onButton(arg0_30, arg0_30.statusPanel.viewBtn, function()
		arg0_30:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
			title = i18n("island_word_ship_buff_desc"),
			statusList = var0_30
		})
	end, SFX_PANEL)
end

function var0_0.OnHide(arg0_32)
	arg0_32:RemoveCloseEnergyTipTimer()
end

function var0_0.OnDestroy(arg0_33)
	arg0_33.statusPanel:Dispose()

	arg0_33.statusPanel = nil

	arg0_33:RemoveCloseEnergyTipTimer()
end

return var0_0
