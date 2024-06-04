local var0 = class("CardPuzzleCardDetailLayer", BaseUI)

function var0.getUIName(arg0)
	return "CardTowerCardDetailUI"
end

function var0.init(arg0)
	arg0.cardView = CardPuzzleCardView.New(arg0:findTF("CardTowerCard"))
	arg0.keywordList = arg0:findTF("KeywordList")
end

local var1 = {
	168,
	220
}

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("BG"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	arg0.cardView:SetData(arg0.contextData.cardData)
	arg0.cardView:UpdateView()
	setAnchoredPosition(arg0.keywordList, {
		x = var1[showPreview and 2 or 1]
	})

	local var0 = _.filter(arg0.contextData.cardData:GetKeywords(), function(arg0)
		return arg0.affix_type == CardPuzzleCardView.AFFIX_TYPE.SCHOOL or arg0.affix_type == CardPuzzleCardView.AFFIX_TYPE.AFFIX and arg0.show == 0
	end)

	UIItemList.StaticAlign(arg0.keywordList, arg0.keywordList:GetChild(0), #var0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var0[arg1 + 1]
		local var1 = arg2

		setText(var1:Find("Title"), var0.name)
		setText(var1:Find("Text"), var0.discript)
		setText(var1:Find("Title/EN"), var0.name_EN)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {})
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
