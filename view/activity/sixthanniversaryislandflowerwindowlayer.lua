local var0 = class("SixthAnniversaryIslandFlowerWindowLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SixthAnniversaryIslandFlowerWindow"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setText(arg0._tf:Find("content/title/Text"), i18n("islandnode_tips7", arg0.contextData.name))

	local var0 = arg0._tf:Find("content/main/content")

	arg0.itemList = UIItemList.New(var0, var0:Find("icon"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2:Find("IconTpl"), arg0.contextData.awards[arg1])
		end
	end)
	arg0.itemList:align(#arg0.contextData.awards)
	onButton(arg0, arg0._tf:Find("content/bottom/btn"), function()
		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.didEnter(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
