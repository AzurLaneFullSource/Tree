local var0_0 = class("IslandShipSkillUpgradePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipSkillUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.upgradeBtn = arg0_2._tf:Find("btn_confirm")
	arg0_2.closeBtn = arg0_2._tf:Find("frame_1/close")
	arg0_2.titleTxt = arg0_2._tf:Find("frame_1/title"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2._tf:Find("frame_1/level"):GetComponent(typeof(Text))
	arg0_2.nextLevelTxt = arg0_2._tf:Find("frame_1/next_level"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2._tf:Find("frame_2/desc_bg/Text"):GetComponent(typeof(Text))
	arg0_2.nextDescTxt = arg0_2._tf:Find("frame_2/desc_bg_1/Text"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("frame_2/item_bg/items"), arg0_2._tf:Find("frame_2/item_bg/items/tpl"))

	setText(arg0_2._tf:Find("frame_2/sub_title/Text"), i18n("island_skill_consume_title"))
	setText(arg0_2.upgradeBtn:Find("Text"), i18n("island_chara_up_button"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		if not arg0_3.ship:CanUpgradeSkill() then
			return
		end

		arg0_3:emit(IslandMediator.SHIP_SKILL_UPGRADE, arg0_3.ship.id)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_7.OnSkillUpgrade)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE, arg0_8.OnSkillUpgrade)
end

function var0_0.OnSkillUpgrade(arg0_9)
	arg0_9:Hide()
end

function var0_0.OnShow(arg0_10, arg1_10)
	arg0_10.ship = arg1_10

	local var0_10 = arg1_10:GetSkill()
	local var1_10 = Clone(var0_10)

	var1_10:Upgrade()
	arg0_10:UpdateMain(var0_10, var1_10)
	arg0_10:BlurPanel(arg0_10._tf)
end

function var0_0.UpdateMain(arg0_11, arg1_11, arg2_11)
	arg0_11.titleTxt.text = arg1_11:GetName()
	arg0_11.levelTxt.text = "Lv." .. arg1_11:GetLevel()
	arg0_11.nextLevelTxt.text = "Lv." .. arg2_11:GetLevel()
	arg0_11.descTxt.text = arg1_11:GetEffectDesc()
	arg0_11.nextDescTxt.text = arg2_11:GetEffectDesc()

	arg0_11:UpdateConsume(arg1_11)
	setGray(arg0_11.upgradeBtn, not arg0_11.ship:CanUpgradeSkill(), true)
end

function var0_0.UpdateConsume(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetUpgradeMaterial()
	local var1_12 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_12[arg1_13 + 1]

			updateCustomDrop(arg2_13, var0_13)

			local var1_13 = var1_12:GetOwnCount(var0_13.id)
			local var2_13 = setColorStr(var1_13, var1_13 >= var0_13.count and COLOR_GREEN or COLOR_RED)

			setText(arg2_13:Find("icon_bg/count_bg/count"), var2_13 .. "/" .. var0_13.count)
		end
	end)
	arg0_12.uiItemList:align(#var0_12)
end

function var0_0.OnHide(arg0_14)
	arg0_14:UnBlurPanel()

	arg0_14.selected = {}
end

return var0_0
