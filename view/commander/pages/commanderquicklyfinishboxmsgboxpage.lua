local var0 = class("CommanderQuicklyFinishBoxMsgBoxPage", import(".CommanderMsgBoxPage"))

function var0.getUIName(arg0)
	return "CommanderQuicklyFinishBoxUI"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.ssrToggle = arg0:findTF("frame/bg/content/rarity/ssr")
	arg0.srToggle = arg0:findTF("frame/bg/content/rarity/sr")
	arg0.rToggle = arg0:findTF("frame/bg/content/rarity/r")
	arg0.descTxt = arg0:findTF("frame/bg/content/rarity/Text"):GetComponent(typeof(Text))
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0, arg1)

	arg0.descTxt.text = i18n("acceleration_tips_3")

	onButton(arg0, arg0.confirmBtn, function()
		local var0, var1, var2, var3 = getProxy(CommanderProxy):CalcQuickItemUsageCnt(arg0.toggleFlags)

		if var0 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("noacceleration_tips"))

			return
		end

		if arg1.onYes then
			arg1.onYes(var0, var1, var2, arg0.toggleFlags)
		end

		arg0:SaveConfig()
		arg0:Hide()
	end, SFX_PANEL)
	arg0:InitToggle()
	arg0:UpdateContent()
end

function var0.UpdateContent(arg0)
	local var0, var1, var2, var3 = getProxy(CommanderProxy):CalcQuickItemUsageCnt(arg0.toggleFlags)
	local var4 = i18n("acceleration_tips_1", var0, var1)
	local var5 = i18n("acceleration_tips_2", var3[1], var3[2], var3[3])

	setText(arg0.text1, var4)
	setText(arg0.text2, var5)
end

function var0.InitToggle(arg0)
	arg0.toggleFlags = {}

	onToggle(arg0, arg0.ssrToggle, function(arg0)
		arg0.toggleFlags[1] = arg0

		arg0:UpdateContent()
	end, SFX_PANEL)
	onToggle(arg0, arg0.srToggle, function(arg0)
		arg0.toggleFlags[2] = arg0

		arg0:UpdateContent()
	end, SFX_PANEL)
	onToggle(arg0, arg0.rToggle, function(arg0)
		arg0.toggleFlags[3] = arg0

		arg0:UpdateContent()
	end, SFX_PANEL)

	local var0 = arg0:GetConfig()

	triggerToggle(arg0.ssrToggle, var0[1])
	triggerToggle(arg0.srToggle, var0[2])
	triggerToggle(arg0.rToggle, var0[3])
end

function var0.GetConfig(arg0)
	return (getProxy(SettingsProxy):GetCommanderQuicklyToolRarityConfig())
end

function var0.SaveConfig(arg0)
	getProxy(SettingsProxy):SaveCommanderQuicklyToolRarityConfig(arg0.toggleFlags)
end

return var0
