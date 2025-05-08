local var0_0 = class("SharedIslandScene", import("..View.base.IslandBaseScene"))

function var0_0.getUIName(arg0_1)
	return "SharedIslandUI"
end

function var0_0.GetIsland(arg0_2)
	return getProxy(IslandProxy):GetSharedIsland()
end

function var0_0.init(arg0_3)
	arg0_3.homeBtn = arg0_3:findTF("top/home")
	arg0_3.levelTxt = arg0_3:findTF("top/level_panel/level"):GetComponent(typeof(Text))
	arg0_3.expTr = arg0_3:findTF("top/level_panel/exp")
	arg0_3.nameTxt = arg0_3:findTF("top/level_panel/name"):GetComponent(typeof(Text))
	arg0_3.prosperityTxt = arg0_3:findTF("top/level_panel/prosperity/Text"):GetComponent(typeof(Text))
	arg0_3.prosperityLabel = arg0_3:findTF("top/level_panel/prosperity"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.homeBtn, function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_4:StartCore()
	arg0_4:UpdateIslandInfo()
end

function var0_0.UpdateIslandInfo(arg0_6)
	local var0_6 = arg0_6:GetIsland()

	arg0_6.levelTxt.text = var0_6:GetLevel()
	arg0_6.nameTxt.text = var0_6:GetName()

	if var0_6:IsMaxLevel() then
		setFillAmount(arg0_6.expTr, 1)
	else
		setFillAmount(arg0_6.expTr, var0_6:GetExp() / var0_6:GetTargeExp())
	end

	if var0_6:CanAddProsperity() then
		arg0_6.prosperityTxt.text = var0_6:GetProsperity() .. "/" .. var0_6:GetTargetProsperity()
	else
		arg0_6.prosperityTxt.text = "MAX"
	end

	arg0_6.prosperityLabel.text = i18n1("繁荣度")
end

function var0_0.willExit(arg0_7)
	return
end

function var0_0.onBackPressed(arg0_8)
	arg0_8:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
