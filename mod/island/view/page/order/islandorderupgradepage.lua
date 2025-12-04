local var0_0 = class("IslandOrderUpgradePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandOrderUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.levelTxt = arg0_2._tf:Find("level"):GetComponent(typeof(Text))
	arg0_2.nextLevelTxt = arg0_2._tf:Find("next_level"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	var0_0.super.Show(arg0_5)

	arg0_5.levelTxt.text = arg1_5
	arg0_5.nextLevelTxt.text = arg1_5 + 1
	arg0_5.callback = arg2_5
end

function var0_0.Hide(arg0_6)
	var0_0.super.Hide(arg0_6)

	if arg0_6.callback then
		arg0_6.callback()

		arg0_6.callback = nil
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
