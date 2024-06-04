local var0 = class("BaseTotalRewardPanel", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BaseTotalRewardPanel"
end

function var0.init(arg0)
	arg0.window = arg0._tf:Find("Window")
	arg0.boxView = arg0.window:Find("Layout/Box/ScrollView")
	arg0.emptyTip = arg0.window:Find("Layout/Box/EmptyTip")

	setText(arg0.emptyTip, i18n("autofight_rewards_none"))
	setText(arg0.window:Find("Fixed/top/bg/obtain/title"), arg0.contextData.title)
	setText(arg0.window:Find("Fixed/top/bg/obtain/title/title_en"), arg0.contextData.subTitle)
	setText(arg0.window:Find("Fixed/ButtonGO/pic"), i18n("autofight_onceagain"))
	setText(arg0.window:Find("Fixed/ButtonExit/pic"), i18n("autofight_leave"))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:UpdateView()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.UpdateView(arg0)
	local var0 = arg0.contextData

	onButton(arg0, arg0._tf:Find("BG"), function()
		existCall(var0.onClose)
		arg0:closeView()
	end)
end

function var0.CloneIconTpl(arg0, arg1)
	local var0 = arg0:GetComponent(typeof(ItemList))

	assert(var0, "Need a Itemlist Component for " .. (arg0 and arg0.name or "NIL"))

	local var1 = Instantiate(var0.prefabItem[0])

	if arg1 then
		var1.name = arg1
	end

	setParent(var1, arg0)

	return var1
end

function var0.HandleShowMsgBox(arg0, arg1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox(arg1)
end

return var0
