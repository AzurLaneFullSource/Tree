local var0_0 = class("MonopolyCar2024TotalRewardPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TotalRewardPanelForMonopoly"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("Window/Layout/Box/ScrollView/Content/ItemGrid2"), arg0_2:findTF("Window/Layout/Box/ScrollView/Content/ItemGrid2/GridItem"))
	arg0_2.confirmBtn = arg0_2:findTF("Window/Fixed/ButtonGO")
	arg0_2.closeBtn = arg0_2:findTF("BG")

	setText(arg0_2:findTF("Window/Fixed/top/bg/obtain/title"), i18n("MonopolyCar2024Game_total_award_title"))
	setText(arg0_2:findTF("Window/Fixed/ButtonGO/pic"), i18n("text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)
	arg0_6.uiItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_6:UpdateItem(arg2_7, arg1_6[arg1_7 + 1])
		end
	end)
	arg0_6.uiItemList:align(#arg1_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8.parentTF)
end

function var0_0.UpdateItem(arg0_9, arg1_9, arg2_9)
	updateDrop(arg1_9:Find("Icon"), arg2_9)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
