local var0_0 = class("IslandBaseMapPage", import("...base.IslandBasePage"))

var0_0.HIDE_DESC = "IslandBaseMapPage:HIDE_DESC"
var0_0.CLOSE = "IslandBaseMapPage:CLOSE"

function var0_0.getUIName(arg0_1)
	return "IslandMapUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.maps = {}
	arg0_2.bg = arg0_2._tf:Find("bg")

	arg0_2:InitMaps()
	setText(arg0_2._tf:Find("adapt/title/Text"), i18n("island_map_title"))
end

function var0_0.InitMaps(arg0_3)
	eachChild(arg0_3.bg, function(arg0_4)
		if arg0_4.name:sub(-1) ~= "$" then
			local var0_4 = tonumber(arg0_4.name)

			arg0_3.maps[var0_4] = arg0_4
		end
	end)
end

function var0_0.OnInit(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.maps) do
		onButton(arg0_5, iter1_5, function()
			if not arg0_5:CheckUnlock(iter0_5) then
				return
			end

			arg0_5:ShowDesc(iter0_5)
		end, SFX_PANEL)
	end

	onButton(arg0_5, arg0_5._tf:Find("bg"), function()
		if arg0_5.selectedId then
			arg0_5:HideSelected()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("adapt/back"), function()
		arg0_5:ClosePage(arg0_5.class)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("adapt/home"), function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_5:bind(var0_0.HIDE_DESC, function()
		arg0_5:HideSelected()
	end)
	arg0_5:bind(var0_0.CLOSE, function()
		arg0_5:ClosePage(arg0_5.class)
	end)
end

function var0_0.OnShow(arg0_12)
	arg0_12:Flush()
end

function var0_0.Flush(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.maps) do
		setActive(iter1_13:Find("selcted"), false)

		local var0_13 = arg0_13:CheckUnlock(iter0_13)

		setActive(iter1_13:Find("lock"), not var0_13)
		setActive(iter1_13:Find("full"), false)
		setActive(iter1_13:Find("finish"), false)
		setActive(iter1_13:Find("fetch"), false)
		setActive(iter1_13:Find("icon"), var0_13)
	end
end

function var0_0.CheckUnlock(arg0_14, arg1_14)
	return (arg0_14:GetIsland():GetAblityAgency():IsUnlockMap(arg1_14))
end

function var0_0.ShowDesc(arg0_15, arg1_15)
	if arg0_15.selectedId then
		arg0_15:HideSelected(arg0_15.selectedId)
	end

	local var0_15 = arg0_15.maps[arg1_15]

	setActive(var0_15:Find("selcted"), true)
	arg0_15:GoDesc(arg1_15)

	arg0_15.selectedId = arg1_15
end

function var0_0.HideSelected(arg0_16)
	local var0_16 = arg0_16.selectedId
	local var1_16 = arg0_16.maps[var0_16]

	if var1_16 == nil then
		return
	end

	local var2_16 = var1_16:Find("selcted")

	dftAniEvent = var2_16:GetComponent(typeof(DftAniEvent))

	dftAniEvent:SetEndEvent(function()
		dftAniEvent:SetEndEvent(nil)
		setActive(var2_16, false)
	end)
	var2_16:GetComponent(typeof(Animation)):Play("IslandMapUI_selectedout")

	arg0_16.selectedId = nil
end

function var0_0.GoDesc(arg0_18, arg1_18)
	arg0_18:OpenPage(IslandBaseMapDescPage, arg1_18)
end

return var0_0
