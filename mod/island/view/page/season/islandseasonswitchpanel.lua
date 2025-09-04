local var0_0 = class("IslandSeasonSwitchPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonSwitchPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleToggle = arg0_2._tf:Find("toggle")
	arg0_2.titleTF = arg0_2.titleToggle:Find("Text")
	arg0_2.uiList = UIItemList.New(arg0_2._tf:Find("list"), arg0_2._tf:Find("list/tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)
	arg0_3.uiList:align(arg0_3.contextData.count or 0)
end

function var0_0.Show(arg0_5)
	var0_0.super.Show(arg0_5)

	arg0_5.selectedIdx = arg0_5.contextData.defaultSelId or 1

	triggerToggle(arg0_5.uiList.container:Find(tostring(arg0_5.selectedIdx)), true)
end

function var0_0.UpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6 + 1

	arg2_6.name = var0_6

	setText(arg2_6:Find("content/Text"), var0_6)
	onToggle(arg0_6, arg2_6, function(arg0_7)
		if arg0_7 then
			arg0_6.selectedIdx = var0_6

			arg0_6:UpdateTitle()
			existCall(arg0_6.contextData.onSelected, var0_6)
		end

		triggerToggle(arg0_6.titleToggle, false)
	end, SFX_PANEL)
end

function var0_0.UpdateTitle(arg0_8)
	setText(arg0_8.titleTF, string.format("第%d赛季", arg0_8.selectedIdx))
end

return var0_0
