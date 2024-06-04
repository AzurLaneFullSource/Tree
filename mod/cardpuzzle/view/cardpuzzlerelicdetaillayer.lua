local var0 = class("CardPuzzleRelicDetailLayer", BaseUI)

function var0.getUIName(arg0)
	return "CardTowerGiftDetailUI"
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("BG"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	local var0 = arg0.contextData.giftData

	setImageSprite(arg0._tf:Find("Gift/Icon"), LoadSprite(var0:GetIconPath(), ""))
	setText(arg0._tf:Find("Gift/Name"), var0:GetName())
	setText(arg0._tf:Find("Gift/Desc"), var0:GetDesc())
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {})
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
