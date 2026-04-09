local var0_0 = class("IslandCheaterTavernStartGameView", import(".IslandCheaterTavernBaseView"))

function var0_0.Show(arg0_1)
	arg0_1.startCardList = pg.gameset.bar_card.description

	arg0_1.cardItemList:align(#arg0_1.startCardList)

	if not arg0_1.cheaterTavernAgency:GetMainPlayer():IsOut() then
		IslandCheaterTavernRecordTools.AddTurnCnt()
	end
end

function var0_0.Init(arg0_2)
	arg0_2.uiParent_ = arg0_2._tf.parent

	arg0_2.super.Init(arg0_2)

	arg0_2.cardItemList = UIItemList.New(arg0_2.uiStartGameItemList, arg0_2.uiStartGameItem)

	arg0_2.cardItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_2:OnUpdateItem(arg1_3, arg2_3)
		end
	end)
end

function var0_0.OnCheaterEveryRoundStart(arg0_4)
	arg0_4:SetActiveState(true)
	arg0_4:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.OnCheaterEveryRoundStartDone(arg0_5)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._tf, arg0_5.uiParent_)
	arg0_5:SetActiveState(false)
end

function var0_0.OnUpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = tf(arg2_6)
	local var1_6 = arg1_6 + 1
	local var2_6 = arg0_6.startCardList[var1_6]
	local var3_6 = var2_6[1]
	local var4_6 = pg.bar_card[var3_6]
	local var5_6 = var2_6[2]

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var4_6.card_res, "", var0_6:Find("cardImage"))
	setText(var0_6:Find("numBg/numText"), "x" .. var5_6)

	local var6_6 = arg0_6.cheaterTavernAgency:GetRealCard()

	setActive(var0_6:Find("selected"), var6_6 == var3_6)
end

function var0_0.OnInit(arg0_7)
	return
end

return var0_0
