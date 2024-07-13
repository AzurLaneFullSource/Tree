local var0_0 = class("CardPuzzleRelicDetailLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "CardTowerGiftDetailUI"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("BG"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)

	local var0_3 = arg0_3.contextData.giftData

	setImageSprite(arg0_3._tf:Find("Gift/Icon"), LoadSprite(var0_3:GetIconPath(), ""))
	setText(arg0_3._tf:Find("Gift/Name"), var0_3:GetName())
	setText(arg0_3._tf:Find("Gift/Desc"), var0_3:GetDesc())
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {})
end

function var0_0.willExit(arg0_5)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_5._tf)
end

return var0_0
