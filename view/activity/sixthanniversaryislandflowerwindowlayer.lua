local var0_0 = class("SixthAnniversaryIslandFlowerWindowLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryIslandFlowerWindow"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	setText(arg0_2._tf:Find("content/title/Text"), i18n("islandnode_tips7", arg0_2.contextData.name))

	local var0_2 = arg0_2._tf:Find("content/main/content")

	arg0_2.itemList = UIItemList.New(var0_2, var0_2:Find("icon"))

	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			updateDrop(arg2_3:Find("IconTpl"), arg0_2.contextData.awards[arg1_3])
		end
	end)
	arg0_2.itemList:align(#arg0_2.contextData.awards)
	onButton(arg0_2, arg0_2._tf:Find("content/bottom/btn"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
end

function var0_0.didEnter(arg0_5)
	return
end

function var0_0.willExit(arg0_6)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_6._tf)
end

return var0_0
