local var0 = class("CommanderLockFlagSettingPage", import("view.base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 3

function var0.getUIName(arg0)
	return "CommanderLockFlagSettingui"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close_btn")
	arg0.cancelBtn = arg0:findTF("frame/cancel")
	arg0.confirmBtn = arg0:findTF("frame/confirm")
	arg0.allBtn = arg0:findTF("frame/title/all_btn")
	arg0.allSel = arg0.allBtn:Find("Image")
	arg0.ssrToggle = arg0:findTF("frame/toggles/rarity/ssr")
	arg0.srToggle = arg0:findTF("frame/toggles/rarity/sr")
	arg0.rToggle = arg0:findTF("frame/toggles/rarity/r")
	arg0.talentUIlist = UIItemList.New(arg0:findTF("frame/toggles/scrollrect/content/talent"), arg0:findTF("frame/toggles/scrollrect/content/talent/tpl"))
	arg0.descTxt = arg0:findTF("frame/desc/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/title/rarity"), i18n("word_rarity") .. ": ")
	setText(arg0:findTF("frame/title/talent"), i18n("word_talent") .. ": ")
	setText(arg0:findTF("frame/desc/Text"), i18n("commander_lock_setting_title"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0:UnselAnyTalent() or arg0:UnselAnyRarity() then
			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_unsel_lock_flag_tip"),
				onYes = function()
					arg0:Conform()
				end
			})
		else
			arg0:Conform()
		end
	end, SFX_PANEL)
end

function var0.UnselAnyTalent(arg0)
	for iter0, iter1 in pairs(arg0.talentList) do
		if iter1 == true then
			return false
		end
	end

	return true
end

function var0.UnselAnyRarity(arg0)
	for iter0, iter1 in pairs(arg0.rarityList) do
		if iter1 == true then
			return false
		end
	end

	return true
end

function var0.Conform(arg0)
	arg0:SaveRarityConfig(arg0.rarityList)
	arg0:SaveTalentConfig(arg0.talentList)
	arg0:Hide()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:InitRarity()
	arg0:InitTalent()
end

function var0.InitRarity(arg0)
	local var0 = arg0:GetRarityConfig()

	arg0.rarityList = {}

	onToggle(arg0, arg0.ssrToggle, function(arg0)
		arg0.rarityList[var1] = arg0
	end, SFX_PANEL)
	onToggle(arg0, arg0.srToggle, function(arg0)
		arg0.rarityList[var2] = arg0
	end, SFX_PANEL)
	onToggle(arg0, arg0.rToggle, function(arg0)
		arg0.rarityList[var3] = arg0
	end, SFX_PANEL)
	triggerToggle(arg0.ssrToggle, var0[var1])
	triggerToggle(arg0.srToggle, var0[var2])
	triggerToggle(arg0.rToggle, var0[var3])
end

function var0.InitTalent(arg0)
	local var0 = arg0:GetTalentConfig()

	arg0.talentList = {}
	arg0.talentCards = {}

	local var1 = CommanderCatUtil.GetAllTalentNames()

	arg0.talentUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1].id
			local var1 = var1[arg1 + 1].name

			onToggle(arg0, arg2, function(arg0)
				arg0.talentList[var0] = arg0

				arg0:UpdateAllBtnStyle()
			end, SFX_PANEL)
			setText(arg2:Find("Text"), var1)

			arg2.gameObject.name = var0
			arg0.talentCards[var0] = arg2
		end
	end)
	arg0.talentUIlist:align(#var1)

	for iter0, iter1 in pairs(var0) do
		if arg0.talentCards[iter0] then
			triggerToggle(arg0.talentCards[iter0], iter1)
		end
	end

	onButton(arg0, arg0.allBtn, function()
		if arg0:AnyCardUnSelected() then
			arg0:TriggerAllCardTrue()
		else
			arg0:TriggerAllCardFalse()
		end

		arg0:UpdateAllBtnStyle()
	end, SFX_PANEL)
	arg0:UpdateAllBtnStyle()
end

function var0.UpdateAllBtnStyle(arg0)
	setActive(arg0.allSel, not arg0:AnyCardUnSelected())
end

function var0.AnyCardUnSelected(arg0)
	for iter0, iter1 in pairs(arg0.talentCards) do
		if not iter1:GetComponent(typeof(Toggle)).isOn then
			return true
		end
	end

	return false
end

function var0.TriggerAllCardTrue(arg0)
	for iter0, iter1 in pairs(arg0.talentCards) do
		triggerToggle(iter1, true)
	end
end

function var0.TriggerAllCardFalse(arg0)
	for iter0, iter1 in pairs(arg0.talentCards) do
		triggerToggle(iter1, false)
	end
end

function var0.GetRarityConfig(arg0)
	return (getProxy(SettingsProxy):GetCommanderLockFlagRarityConfig())
end

function var0.SaveRarityConfig(arg0, arg1)
	getProxy(SettingsProxy):SaveCommanderLockFlagRarityConfig(arg1)
end

function var0.GetTalentConfig(arg0)
	return (getProxy(SettingsProxy):GetCommanderLockFlagTalentConfig())
end

function var0.SaveTalentConfig(arg0, arg1)
	getProxy(SettingsProxy):SaveCommanderLockFlagTalentConfig(arg1)
end

function var0.OnDestroy(arg0)
	return
end

return var0
