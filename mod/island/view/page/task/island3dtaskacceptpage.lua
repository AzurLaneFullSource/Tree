local var0_0 = class("Island3dTaskAcceptPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskAcceptUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.chapterText = arg0_2._tf:Find("frame/chapter")
	arg0_2.nameText = arg0_2._tf:Find("frame/name")
	arg0_2.tipText = arg0_2:findTF("frame/tip/Text")

	setText(arg0_2.tipText, i18n1("已开启"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg1_5)

	setText(arg0_5.chapterText, var0_5:getConfig("series"))
	setText(arg0_5.nameText, var0_5:getConfig("series_name"))

	arg0_5.onExit = arg2_5
end

function var0_0.OnHide(arg0_6)
	if arg0_6.onExit then
		arg0_6.onExit()

		arg0_6.onExit = nil
	end
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
