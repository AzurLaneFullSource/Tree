local var0_0 = class("BossSingleTotalRewardPanel", import("view.activity.worldboss.ActivityBossTotalRewardPanel"))

function var0_0.getUIName(arg0_1)
	return "BossSingleTotalRewardPanel"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	setText(arg0_2.window:Find("Fixed/ButtonGO/pic"), i18n("autofight_onceagain"))
end

function var0_0.UpdateView(arg0_3)
	var0_0.super.UpdateView(arg0_3)

	local var0_3 = arg0_3.contextData

	onButton(arg0_3, arg0_3.window:Find("Fixed/ButtonGO"), function()
		existCall(var0_3.onConfirm)
		arg0_3:closeView()
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.window:Find("Fixed/ButtonExit"), function()
		triggerButton(arg0_3._tf:Find("BG"))
	end)
end

return var0_0
