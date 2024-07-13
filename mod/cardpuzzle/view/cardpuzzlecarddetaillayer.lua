local var0_0 = class("CardPuzzleCardDetailLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "CardTowerCardDetailUI"
end

function var0_0.init(arg0_2)
	arg0_2.cardView = CardPuzzleCardView.New(arg0_2:findTF("CardTowerCard"))
	arg0_2.keywordList = arg0_2:findTF("KeywordList")
end

local var1_0 = {
	168,
	220
}

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("BG"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3.cardView:SetData(arg0_3.contextData.cardData)
	arg0_3.cardView:UpdateView()
	setAnchoredPosition(arg0_3.keywordList, {
		x = var1_0[showPreview and 2 or 1]
	})

	local var0_3 = _.filter(arg0_3.contextData.cardData:GetKeywords(), function(arg0_5)
		return arg0_5.affix_type == CardPuzzleCardView.AFFIX_TYPE.SCHOOL or arg0_5.affix_type == CardPuzzleCardView.AFFIX_TYPE.AFFIX and arg0_5.show == 0
	end)

	UIItemList.StaticAlign(arg0_3.keywordList, arg0_3.keywordList:GetChild(0), #var0_3, function(arg0_6, arg1_6, arg2_6)
		if arg0_6 ~= UIItemList.EventUpdate then
			return
		end

		local var0_6 = var0_3[arg1_6 + 1]
		local var1_6 = arg2_6

		setText(var1_6:Find("Title"), var0_6.name)
		setText(var1_6:Find("Text"), var0_6.discript)
		setText(var1_6:Find("Title/EN"), var0_6.name_EN)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {})
end

function var0_0.willExit(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
end

return var0_0
