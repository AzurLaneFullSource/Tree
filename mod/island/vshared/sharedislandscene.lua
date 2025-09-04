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
	arg0_3.mapBtn = arg0_3:findTF("top/map_btn")
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.homeBtn, function()
		if ISLAND_PLAYER_TESTING then
			arg0_4:emit(SharedIslandMediator.RETURN_SELF_ISLAND)

			return
		end

		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mapBtn, function()
		arg0_4:OpenPage(SharedIslandMapPage)
	end, SFX_PANEL)
	arg0_4:StartCore()
	arg0_4:UpdateIslandInfo()
end

function var0_0.UpdateIslandInfo(arg0_7)
	local var0_7 = arg0_7:GetIsland()

	arg0_7.levelTxt.text = var0_7:GetLevel()
	arg0_7.nameTxt.text = var0_7:GetName()

	if var0_7:IsMaxLevel() then
		setFillAmount(arg0_7.expTr, 1)
	else
		setFillAmount(arg0_7.expTr, var0_7:GetExp() / var0_7:GetTargeExp())
	end

	if var0_7:CanAddProsperity() then
		arg0_7.prosperityTxt.text = var0_7:GetProsperity() .. "/" .. var0_7:GetTargetProsperity()
	else
		arg0_7.prosperityTxt.text = "MAX"
	end

	arg0_7.prosperityLabel.text = i18n("island_prosperity_level")
end

function var0_0.willExit(arg0_8)
	return
end

function var0_0.onBackPressed(arg0_9)
	arg0_9:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
