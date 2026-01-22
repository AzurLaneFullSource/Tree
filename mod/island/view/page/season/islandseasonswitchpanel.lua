local var0_0 = class("IslandSeasonSwitchPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonSwitchPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frame = arg0_2._tf:Find("frame")
	arg0_2.uiList = UIItemList.New(arg0_2._tf:Find("frame/filter_panel/list/content"), arg0_2._tf:Find("frame/filter_panel/list/content/tpl"))
	arg0_2.selectorPanel = arg0_2._tf:Find("frame/filter_panel")
	arg0_2.fliterBtn = arg0_2._tf:Find("frame/filter")
	arg0_2.filterTxt = arg0_2.fliterBtn:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.fliterBtn, function()
		arg0_3.isOpen = not arg0_3.isOpen

		arg0_3:UpdateSelector()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_3:UpdateItem(arg1_5, arg2_5)
		end
	end)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	var0_0.super.Show(arg0_6)

	arg0_6.callback = arg2_6
	arg0_6.isOpen = false

	arg0_6:UpdateSelector()

	local var0_6 = pg.island_season[arg1_6].name_short

	arg0_6.filterTxt.text = var0_6
end

function var0_0.UpdateSelector(arg0_7)
	if arg0_7.isOpen then
		local var0_7 = IslandSeasonAgency.GetCurrentSeason() - 1

		arg0_7.uiList:align(var0_7 or 0)
	end

	setActive(arg0_7.selectorPanel, arg0_7.isOpen)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)

	if arg0_8.isOpen then
		arg0_8.isOpen = false

		arg0_8:UpdateSelector()
	end
end

function var0_0.UpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9 + 1
	local var1_9 = pg.island_season[var0_9].name_short

	setText(arg2_9, var1_9)
	onButton(arg0_9, arg2_9, function()
		arg0_9.filterTxt.text = var1_9

		if arg0_9.callback then
			arg0_9.callback(var0_9)
		end
	end, SFX_PANEL)
end

return var0_0
