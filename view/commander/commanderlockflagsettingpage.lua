local var0_0 = class("CommanderLockFlagSettingPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "CommanderLockFlagSettingui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close_btn")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.allBtn = arg0_2:findTF("frame/title/all_btn")
	arg0_2.allSel = arg0_2.allBtn:Find("Image")
	arg0_2.ssrToggle = arg0_2:findTF("frame/toggles/rarity/ssr")
	arg0_2.srToggle = arg0_2:findTF("frame/toggles/rarity/sr")
	arg0_2.rToggle = arg0_2:findTF("frame/toggles/rarity/r")
	arg0_2.talentUIlist = UIItemList.New(arg0_2:findTF("frame/toggles/scrollrect/content/talent"), arg0_2:findTF("frame/toggles/scrollrect/content/talent/tpl"))
	arg0_2.descTxt = arg0_2:findTF("frame/desc/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/title/rarity"), i18n("word_rarity") .. ": ")
	setText(arg0_2:findTF("frame/title/talent"), i18n("word_talent") .. ": ")
	setText(arg0_2:findTF("frame/desc/Text"), i18n("commander_lock_setting_title"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3:UnselAnyTalent() or arg0_3:UnselAnyRarity() then
			arg0_3.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_unsel_lock_flag_tip"),
				onYes = function()
					arg0_3:Conform()
				end
			})
		else
			arg0_3:Conform()
		end
	end, SFX_PANEL)
end

function var0_0.UnselAnyTalent(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.talentList) do
		if iter1_9 == true then
			return false
		end
	end

	return true
end

function var0_0.UnselAnyRarity(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.rarityList) do
		if iter1_10 == true then
			return false
		end
	end

	return true
end

function var0_0.Conform(arg0_11)
	arg0_11:SaveRarityConfig(arg0_11.rarityList)
	arg0_11:SaveTalentConfig(arg0_11.talentList)
	arg0_11:Hide()
end

function var0_0.Show(arg0_12)
	var0_0.super.Show(arg0_12)
	arg0_12:InitRarity()
	arg0_12:InitTalent()
end

function var0_0.InitRarity(arg0_13)
	local var0_13 = arg0_13:GetRarityConfig()

	arg0_13.rarityList = {}

	onToggle(arg0_13, arg0_13.ssrToggle, function(arg0_14)
		arg0_13.rarityList[var1_0] = arg0_14
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13.srToggle, function(arg0_15)
		arg0_13.rarityList[var2_0] = arg0_15
	end, SFX_PANEL)
	onToggle(arg0_13, arg0_13.rToggle, function(arg0_16)
		arg0_13.rarityList[var3_0] = arg0_16
	end, SFX_PANEL)
	triggerToggle(arg0_13.ssrToggle, var0_13[var1_0])
	triggerToggle(arg0_13.srToggle, var0_13[var2_0])
	triggerToggle(arg0_13.rToggle, var0_13[var3_0])
end

function var0_0.InitTalent(arg0_17)
	local var0_17 = arg0_17:GetTalentConfig()

	arg0_17.talentList = {}
	arg0_17.talentCards = {}

	local var1_17 = CommanderCatUtil.GetAllTalentNames()

	arg0_17.talentUIlist:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var1_17[arg1_18 + 1].id
			local var1_18 = var1_17[arg1_18 + 1].name

			onToggle(arg0_17, arg2_18, function(arg0_19)
				arg0_17.talentList[var0_18] = arg0_19

				arg0_17:UpdateAllBtnStyle()
			end, SFX_PANEL)
			setText(arg2_18:Find("Text"), var1_18)

			arg2_18.gameObject.name = var0_18
			arg0_17.talentCards[var0_18] = arg2_18
		end
	end)
	arg0_17.talentUIlist:align(#var1_17)

	for iter0_17, iter1_17 in pairs(var0_17) do
		if arg0_17.talentCards[iter0_17] then
			triggerToggle(arg0_17.talentCards[iter0_17], iter1_17)
		end
	end

	onButton(arg0_17, arg0_17.allBtn, function()
		if arg0_17:AnyCardUnSelected() then
			arg0_17:TriggerAllCardTrue()
		else
			arg0_17:TriggerAllCardFalse()
		end

		arg0_17:UpdateAllBtnStyle()
	end, SFX_PANEL)
	arg0_17:UpdateAllBtnStyle()
end

function var0_0.UpdateAllBtnStyle(arg0_21)
	setActive(arg0_21.allSel, not arg0_21:AnyCardUnSelected())
end

function var0_0.AnyCardUnSelected(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.talentCards) do
		if not iter1_22:GetComponent(typeof(Toggle)).isOn then
			return true
		end
	end

	return false
end

function var0_0.TriggerAllCardTrue(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.talentCards) do
		triggerToggle(iter1_23, true)
	end
end

function var0_0.TriggerAllCardFalse(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.talentCards) do
		triggerToggle(iter1_24, false)
	end
end

function var0_0.GetRarityConfig(arg0_25)
	return (getProxy(SettingsProxy):GetCommanderLockFlagRarityConfig())
end

function var0_0.SaveRarityConfig(arg0_26, arg1_26)
	getProxy(SettingsProxy):SaveCommanderLockFlagRarityConfig(arg1_26)
end

function var0_0.GetTalentConfig(arg0_27)
	return (getProxy(SettingsProxy):GetCommanderLockFlagTalentConfig())
end

function var0_0.SaveTalentConfig(arg0_28, arg1_28)
	getProxy(SettingsProxy):SaveCommanderLockFlagTalentConfig(arg1_28)
end

function var0_0.OnDestroy(arg0_29)
	return
end

return var0_0
