local var0_0 = class("BaseTotalRewardPanel", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BaseTotalRewardPanel"
end

function var0_0.init(arg0_2)
	arg0_2.window = arg0_2._tf:Find("Window")
	arg0_2.boxView = arg0_2.window:Find("Layout/Box/ScrollView")
	arg0_2.emptyTip = arg0_2.window:Find("Layout/Box/EmptyTip")

	setText(arg0_2.emptyTip, i18n("autofight_rewards_none"))
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title"), arg0_2.contextData.title)
	setText(arg0_2.window:Find("Fixed/top/bg/obtain/title/title_en"), arg0_2.contextData.subTitle)
	setText(arg0_2.window:Find("Fixed/ButtonGO/pic"), i18n("autofight_onceagain"))
	setText(arg0_2.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3:UpdateView()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.UpdateView(arg0_5)
	local var0_5 = arg0_5.contextData

	onButton(arg0_5, arg0_5._tf:Find("BG"), function()
		existCall(var0_5.onClose)
		arg0_5:closeView()
	end)
end

function var0_0.CloneIconTpl(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetComponent(typeof(ItemList))

	assert(var0_7, "Need a Itemlist Component for " .. (arg0_7 and arg0_7.name or "NIL"))

	local var1_7 = Instantiate(var0_7.prefabItem[0])

	if arg1_7 then
		var1_7.name = arg1_7
	end

	setParent(var1_7, arg0_7)

	return var1_7
end

function var0_0.HandleShowMsgBox(arg0_8, arg1_8)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1_8)
end

return var0_0
