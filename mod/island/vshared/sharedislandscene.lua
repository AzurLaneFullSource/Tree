local var0_0 = class("SharedIslandScene", import("..View.base.IslandBaseScene"))

function var0_0.getUIName(arg0_1)
	return "SharedIslandUI"
end

function var0_0.GetIsland(arg0_2)
	return getProxy(IslandProxy):GetSharedIsland()
end

function var0_0.init(arg0_3)
	arg0_3.levelTxt = arg0_3:findTF("top/level_panel/level"):GetComponent(typeof(Text))
	arg0_3.expTr = arg0_3:findTF("top/level_panel/exp")
	arg0_3.nameTxt = arg0_3:findTF("top/level_panel/name"):GetComponent(typeof(Text))
	arg0_3.prosperityTxt = arg0_3:findTF("top/level_panel/prosperity/Text"):GetComponent(typeof(Text))
	arg0_3.prosperityLabel = arg0_3:findTF("top/level_panel/prosperity"):GetComponent(typeof(Text))
	arg0_3.mapBtn = arg0_3:findTF("top/map_btn")
	arg0_3.leaveBtn = arg0_3:findTF("top/leave_btn")

	setText(arg0_3.leaveBtn:Find("Text"), i18n("island_leave"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("top/level_panel"), function()
		arg0_4:OpenPage(SharedIslandOtherCardPage, arg0_4:GetIsland().id)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.mapBtn, function()
		arg0_4:OpenPage(SharedIslandMapPage)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.leaveBtn, function()
		arg0_4:emit(SharedIslandMediator.RETURN_SELF_ISLAND)
	end, SFX_PANEL)
	arg0_4:StartCore()
	arg0_4:UpdateIslandInfo()
end

function var0_0.OnOpenAnimatonOpPage(arg0_8)
	setActive(arg0_8.homeBtn, false)
	setActive(arg0_8.mapBtn, false)
	setActive(arg0_8.leaveBtn, false)
end

function var0_0.OnCloseAnimatonOpPage(arg0_9)
	setActive(arg0_9.homeBtn, true)
	setActive(arg0_9.mapBtn, true)
	setActive(arg0_9.leaveBtn, true)
end

function var0_0.UpdateIslandInfo(arg0_10)
	local var0_10 = arg0_10:GetIsland()

	arg0_10.levelTxt.text = var0_10:GetLevel()
	arg0_10.nameTxt.text = var0_10:GetName()

	if var0_10:IsMaxLevel() then
		setFillAmount(arg0_10.expTr, 1)
	else
		setFillAmount(arg0_10.expTr, var0_10:GetExp() / var0_10:GetTargeExp())
	end

	if var0_10:CanAddProsperity() then
		arg0_10.prosperityTxt.text = var0_10:GetProsperity() .. "/" .. var0_10:GetTargetProsperity()
	else
		arg0_10.prosperityTxt.text = "MAX"
	end

	arg0_10.prosperityLabel.text = i18n("island_prosperity_level")
end

function var0_0.willExit(arg0_11)
	return
end

function var0_0.onBackPressed(arg0_12)
	arg0_12:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
