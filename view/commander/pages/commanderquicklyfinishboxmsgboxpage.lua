local var0_0 = class("CommanderQuicklyFinishBoxMsgBoxPage", import(".CommanderMsgBoxPage"))

function var0_0.getUIName(arg0_1)
	return "CommanderQuicklyFinishBoxUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)

	arg0_2.ssrToggle = arg0_2:findTF("frame/bg/content/rarity/ssr")
	arg0_2.srToggle = arg0_2:findTF("frame/bg/content/rarity/sr")
	arg0_2.rToggle = arg0_2:findTF("frame/bg/content/rarity/r")
	arg0_2.descTxt = arg0_2:findTF("frame/bg/content/rarity/Text"):GetComponent(typeof(Text))
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.Show(arg0_3, arg1_3)

	arg0_3.descTxt.text = i18n("acceleration_tips_3")

	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4, var1_4, var2_4, var3_4 = getProxy(CommanderProxy):CalcQuickItemUsageCnt(arg0_3.toggleFlags)

		if var0_4 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("noacceleration_tips"))

			return
		end

		if arg1_3.onYes then
			arg1_3.onYes(var0_4, var1_4, var2_4, arg0_3.toggleFlags)
		end

		arg0_3:SaveConfig()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:InitToggle()
	arg0_3:UpdateContent()
end

function var0_0.UpdateContent(arg0_5)
	local var0_5, var1_5, var2_5, var3_5 = getProxy(CommanderProxy):CalcQuickItemUsageCnt(arg0_5.toggleFlags)
	local var4_5 = i18n("acceleration_tips_1", var0_5, var1_5)
	local var5_5 = i18n("acceleration_tips_2", var3_5[1], var3_5[2], var3_5[3])

	setText(arg0_5.text1, var4_5)
	setText(arg0_5.text2, var5_5)
end

function var0_0.InitToggle(arg0_6)
	arg0_6.toggleFlags = {}

	onToggle(arg0_6, arg0_6.ssrToggle, function(arg0_7)
		arg0_6.toggleFlags[1] = arg0_7

		arg0_6:UpdateContent()
	end, SFX_PANEL)
	onToggle(arg0_6, arg0_6.srToggle, function(arg0_8)
		arg0_6.toggleFlags[2] = arg0_8

		arg0_6:UpdateContent()
	end, SFX_PANEL)
	onToggle(arg0_6, arg0_6.rToggle, function(arg0_9)
		arg0_6.toggleFlags[3] = arg0_9

		arg0_6:UpdateContent()
	end, SFX_PANEL)

	local var0_6 = arg0_6:GetConfig()

	triggerToggle(arg0_6.ssrToggle, var0_6[1])
	triggerToggle(arg0_6.srToggle, var0_6[2])
	triggerToggle(arg0_6.rToggle, var0_6[3])
end

function var0_0.GetConfig(arg0_10)
	return (getProxy(SettingsProxy):GetCommanderQuicklyToolRarityConfig())
end

function var0_0.SaveConfig(arg0_11)
	getProxy(SettingsProxy):SaveCommanderQuicklyToolRarityConfig(arg0_11.toggleFlags)
end

return var0_0
