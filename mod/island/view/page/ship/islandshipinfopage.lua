local var0_0 = class("IslandShipInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.energyTipTr = arg0_2._tf:Find("adapt/name_panel/tip")
	arg0_2.energyTipTxt = arg0_2._tf:Find("adapt/name_panel/tip/Text"):GetComponent(typeof(Text))
	arg0_2.energyTr = arg0_2._tf:Find("adapt/name_panel/energy")
	arg0_2.energyTxt = arg0_2._tf:Find("adapt/name_panel/energy"):GetComponent(typeof(Text))
	arg0_2.energyLabel = arg0_2._tf:Find("adapt/name_panel/energy/label")
	arg0_2.nameTxt = arg0_2._tf:Find("adapt/name_panel/name"):GetComponent(typeof(Text))
	arg0_2.nameEnTxt = arg0_2._tf:Find("adapt/name_panel/en"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2._tf:Find("adapt/main_panel/level/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2._tf:Find("adapt/main_panel/level/exp"):GetComponent(typeof(Text))
	arg0_2.expProgress = arg0_2._tf:Find("adapt/main_panel/level/progress")
	arg0_2.upgradeBtn = arg0_2._tf:Find("adapt/main_panel/level/add")
	arg0_2.breakoutBtn = arg0_2._tf:Find("adapt/main_panel/level/breakout")
	arg0_2.uiAttrList = UIItemList.New(arg0_2._tf:Find("adapt/main_panel/attr/list"), arg0_2._tf:Find("adapt/main_panel/attr/list/tpl"))
	arg0_2.attrUpgradeBtn = arg0_2._tf:Find("adapt/main_panel/attr/upgrade")
	arg0_2.skillTr = arg0_2._tf:Find("adapt/main_panel/skill")
	arg0_2.skillIconImg = arg0_2._tf:Find("adapt/main_panel/skill/icon")
	arg0_2.skillName = arg0_2._tf:Find("adapt/main_panel/skill/info/name"):GetComponent(typeof(Text))
	arg0_2.skillLevel = arg0_2._tf:Find("adapt/main_panel/skill/info/level"):GetComponent(typeof(Text))
	arg0_2.skillDesc = arg0_2._tf:Find("adapt/main_panel/skill/info/desc/Text"):GetComponent(typeof(Text))
	arg0_2.skillMask = arg0_2._tf:Find("adapt/main_panel/skill_mask")
	arg0_2.skillMaskLabel = arg0_2._tf:Find("adapt/main_panel/skill_mask/content/Text")
	arg0_2.skillUpgradeBtn = arg0_2._tf:Find("adapt/main_panel/skill/upgrade")
	arg0_2.skillInfoBtn = arg0_2._tf:Find("adapt/main_panel/skill/click")
	arg0_2.breakOutList = UIItemList.New(arg0_2._tf:Find("adapt/main_panel/level/starts"), arg0_2._tf:Find("adapt/main_panel/level/starts/tpl"))
	arg0_2.statusPanel = IslandShipStatusPanel.New(arg0_2._tf:Find("adapt/main_panel/status"), arg0_2._tf:Find("adapt/main_panel/status_empty"))
	arg0_2.followerBtn = arg0_2._tf:Find("adapt/follower")
	arg0_2.followerBtnInvite = arg0_2._tf:Find("adapt/follower/1")
	arg0_2.followerBtnCancel = arg0_2._tf:Find("adapt/follower/2")
	arg0_2.followerBtnDisable = arg0_2._tf:Find("adapt/follower/3")

	setText(arg0_2.energyLabel, i18n("island_ship_energy"))
	setText(arg0_2.followerBtnInvite:Find("Text"), i18n("island_follow_btn_State_usable"))
	setText(arg0_2.followerBtnCancel:Find("Text"), i18n("island_follow_btn_State_cancel"))
	setText(arg0_2.followerBtnDisable:Find("Text"), i18n("island_follow_btn_State_disable"))
	setActive(arg0_2.followerBtnInvite:Find("Text"), false)
	setActive(arg0_2.followerBtnInvite:Find("Text"), true)
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
	onButton(arg0_3, arg0_3.followerBtn, function()
		if getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(arg0_3.ship.id) then
			arg0_3:ShowMsgBox({
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					arg0_3:emit(IslandMediator.DEL_FOLLOWER, arg0_3.ship.id)
				end
			})
		else
			arg0_3:emit(IslandMediator.ADD_FOLLOWER, arg0_3.ship.id)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.skillInfoBtn, function()
		arg0_3:ShowMsgBox({
			type = IslandMsgBox.TYPE_SHIP_SKILL,
			skill = arg0_3.ship:GetSkill()
		})
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_12)

	if var0_12 == nil then
		return
	end

	arg0_12:UpdateMainView(var0_12)
	arg0_12:UpdateFollowBtn(var0_12)

	arg0_12.ship = var0_12
end

function var0_0.UpdateFollowBtn(arg0_13, arg1_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(arg1_13.id)
	local var1_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():CanFollowPlayer(arg1_13.id)

	setActive(arg0_13.followerBtnInvite, not var0_13 and var1_13)
	setActive(arg0_13.followerBtnCancel, var0_13)

	local var2_13 = not var1_13 and not var0_13

	setActive(arg0_13.followerBtnDisable, var2_13)
	setButtonEnabled(arg0_13.followerBtn, not var2_13)
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE, arg0_14.OnUseExpBook)
	arg0_14:AddListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_14.OnBreakOut)
	arg0_14:AddListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_14.OnAttrUpgrade)
	arg0_14:AddListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_14.OnSkillUpgrade)
	arg0_14:AddListener(GAME.ISLAND_FOLLOWER_OP_DONE, arg0_14.OnFollowOpDone)
end

function var0_0.RemoveListeners(arg0_15)
	arg0_15:RemoveListener(GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE, arg0_15.OnUseExpBook)
	arg0_15:RemoveListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_15.OnBreakOut)
	arg0_15:RemoveListener(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE, arg0_15.OnAttrUpgrade)
	arg0_15:RemoveListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_15.OnSkillUpgrade)
	arg0_15:RemoveListener(GAME.ISLAND_FOLLOWER_OP_DONE, arg0_15.OnFollowOpDone)
end

function var0_0.OnFollowOpDone(arg0_16)
	arg0_16:UpdateFollowBtn(arg0_16.ship)
end

function var0_0.OnAttrUpgrade(arg0_17)
	arg0_17:UpdateAttrs(arg0_17.ship)
end

function var0_0.OnUseExpBook(arg0_18)
	arg0_18:UpdateLevelAndExp(arg0_18.ship)
	arg0_18:UpdateAttrs(arg0_18.ship)
end

function var0_0.OnBreakOut(arg0_19)
	local var0_19 = arg0_19.ship

	arg0_19:UpdateEnergy(var0_19)
	arg0_19:UpdateLevelAndExp(var0_19)
	arg0_19:UpdateAttrs(var0_19)
	arg0_19:UpdateSkill(var0_19)
	arg0_19:UpdateBreakOutLevel(var0_19)
end

function var0_0.OnSkillUpgrade(arg0_20)
	local var0_20 = arg0_20.ship

	arg0_20:UpdateSkill(var0_20)
end

function var0_0.UpdateMainView(arg0_21, arg1_21)
	arg0_21:UpdateEnergy(arg1_21)
	arg0_21:UpdateLevelAndExp(arg1_21)
	arg0_21:UpdateAttrs(arg1_21)
	arg0_21:UpdateSkill(arg1_21)
	arg0_21:UpdateBreakOutLevel(arg1_21)
	arg0_21:UpdateStatus(arg1_21)

	arg0_21.ship = arg1_21
end

function var0_0.DisplayEnergyTip(arg0_22)
	arg0_22:RemoveCloseEnergyTipTimer()
	setActive(arg0_22.energyTipTr, true)

	arg0_22.energyTipTxt.text = i18n("island_ship_energy_full")

	arg0_22:AddCloseEnergyTipTimer()
end

function var0_0.AddCloseEnergyTipTimer(arg0_23)
	arg0_23.timer = Timer.New(function()
		arg0_23:RemoveCloseEnergyTipTimer()
	end, 3)

	arg0_23.timer:Start()
end

function var0_0.RemoveCloseEnergyTipTimer(arg0_25)
	setActive(arg0_25.energyTipTr, false)

	if arg0_25.timer then
		arg0_25.timer:Stop()

		arg0_25.timer = nil
	end
end

function var0_0.UpdateBreakOutLevel(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetBreakLevel()

	arg0_26.breakOutList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = arg1_27 + 1

			setActive(arg2_27:Find("Image"), var0_27 <= var0_26)
		end
	end)
	arg0_26.breakOutList:align(arg1_26:GetBreakMaxLevel())
end

function var0_0.UpdateEnergy(arg0_28, arg1_28)
	local var0_28 = arg1_28:GetCurrentEnergy()
	local var1_28 = arg1_28:GetMaxEnergy()
	local var2_28 = var0_28 <= 20 and "<color=#ab4734>" .. var0_28 .. "</color>" or var0_28

	arg0_28.energyTxt.text = "[" .. var2_28 .. "/" .. var1_28 .. "]"
end

function var0_0.UpdateLevelAndExp(arg0_29, arg1_29)
	arg0_29.nameTxt.text = arg1_29:GetName()
	arg0_29.nameEnTxt.text = arg1_29:GetEnName()
	arg0_29.levelTxt.text = "Level:" .. arg1_29:GetLevel()

	if not arg1_29:IsMaxLevel() then
		local var0_29 = arg1_29:GetExp()
		local var1_29 = arg1_29:GetTargetExp()

		arg0_29.expTxt.text = var0_29 .. "/" .. var1_29

		setSlider(arg0_29.expProgress, 0, 1, var0_29 / var1_29)
	else
		arg0_29.expTxt.text = "[MAX]"

		setSlider(arg0_29.expProgress, 0, 1, 1)
	end

	setActive(arg0_29.upgradeBtn, not arg1_29:IsMaxLevel())
	setActive(arg0_29.breakoutBtn, arg1_29:IsMaxLevel() and not arg1_29:IsMaxBreakLevel())
end

function var0_0.RemoveAttrTimer(arg0_30)
	if arg0_30.attrTimer then
		arg0_30.attrTimer:Stop()

		arg0_30.attrTimer = nil
	end
end

function var0_0.UpdateAttrs(arg0_31, arg1_31)
	local var0_31 = IslandShipAttr.ATTRS

	arg0_31.uiAttrList:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = arg1_32 + 1

			arg0_31:UpdateAttr(arg2_32, var0_31, var0_32, arg1_31)
		end
	end)
	arg0_31.uiAttrList:align(#var0_31)
end

function var0_0.UpdateAttr(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = arg2_33[arg3_33]
	local var1_33 = arg4_33:GetAttr(var0_33)

	setText(arg1_33:Find("name"), IslandShipAttr.ToChinese(var0_33))

	local var2_33 = IslandProductTimeHelper.GetAttributeAddPercentByAttribute(arg4_33.id, arg3_33)
	local var3_33
	local var4_33 = var2_33 > 0 and "#00B91E" or var2_33 < 0 and "#FF6767" or "#393A3C"

	setTextColor(arg1_33:Find("value"), Color.NewHex(var4_33))

	local var5_33 = var2_33 ~= 0 and math.floor(var1_33 * (1 + 0.01 * var2_33)) or var1_33

	setText(arg1_33:Find("value"), var5_33)

	if var2_33 ~= 0 then
		local var6_33 = arg4_33:GetDisplayStatus()
		local var7_33 = _.select(var6_33, function(arg0_34)
			return arg0_34:GetBuffType() == IslandBuffType.SHIP_ATTR
		end)

		onButton(arg0_33, arg1_33, function()
			arg0_33:ShowMsgBox({
				hideNo = true,
				type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
				title = i18n("island_word_ship_buff_desc"),
				statusList = var7_33
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg1_33)
	end

	local var8_33 = arg4_33:GetAttrGradeByValue(var5_33)
	local var9_33 = IslandShipAttr.Grade2Img(var8_33)

	GetImageSpriteFromAtlasAsync("ui/IslandShipUI_atlas", var9_33[1], arg1_33:Find("grade"))
	GetImageSpriteFromAtlasAsync("ui/IslandShipUI_atlas", var9_33[2], arg1_33:Find("grade_bg"))
end

function var0_0.UpdateSkill(arg0_36, arg1_36)
	local var0_36 = arg1_36:GetSkill()

	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_36:GetIcon(), "", arg0_36.skillIconImg)

	arg0_36.skillName.text = var0_36:GetName()
	arg0_36.skillLevel.text = "[Lv." .. var0_36:GetLevel() .. "]"
	arg0_36.skillDesc.text = var0_36:GetEffectDesc()

	local var1_36 = var0_36:IsUnlock()

	setActive(arg0_36.skillTr, var1_36)
	setActive(arg0_36.skillMask, not var1_36)
	setText(arg0_36.skillMaskLabel, i18n("island_need_star", arg1_36:GetSkillUnlockLevel()))
	setActive(arg0_36.skillUpgradeBtn, not var0_36:IsMaxLevel())
end

function var0_0.UpdateStatus(arg0_37, arg1_37)
	arg0_37.statusPanel:Flush(arg1_37)

	local var0_37 = arg1_37:GetDisplayStatus()

	onButton(arg0_37, arg0_37.statusPanel.viewBtn, function()
		arg0_37:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
			title = i18n("island_word_ship_buff_desc"),
			statusList = var0_37
		})
	end, SFX_PANEL)
end

function var0_0.OnHide(arg0_39)
	arg0_39:RemoveCloseEnergyTipTimer()
end

function var0_0.OnDestroy(arg0_40)
	arg0_40.statusPanel:Dispose()

	arg0_40.statusPanel = nil

	arg0_40:RemoveCloseEnergyTipTimer()
end

return var0_0
