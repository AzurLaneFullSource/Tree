local var0_0 = class("RandomDockYardMsgBoxPgae", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RandomDockYardMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/top/btnBack")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel_button")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm_button")
	arg0_2.scrollrect = arg0_2:findTF("frame/sliders"):GetComponent("LScrollRect")
	arg0_2.titleTxt = arg0_2:findTF("frame/top/title_list/infomation/title"):GetComponent(typeof(Text))
	arg0_2.titleEnTxt = arg0_2:findTF("frame/top/title_list/infomation/title_en"):GetComponent(typeof(Text))
	arg0_2.subTitleTxt = arg0_2:findTF("frame/label/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/confirm_button/pic"), i18n("text_confirm"))
	setText(arg0_2:findTF("frame/cancel_button/pic"), i18n("text_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.callback then
			arg0_3.callback()
		end

		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.cards = {}

	function arg0_3.scrollrect.onUpdateItem(arg0_8, arg1_8)
		arg0_3:OnUpdateItem(arg0_8, arg1_8)
	end

	function arg0_3.scrollrect.onInitItem(arg0_9)
		arg0_3:OnInitItem(arg0_9)
	end
end

function var0_0.OnInitItem(arg0_10, arg1_10)
	local var0_10 = RandomDockYardCard.New(arg1_10)

	arg0_10.cards[arg1_10] = var0_10
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]

	if not var0_11 then
		arg0_11:OnInitItem(arg2_11)

		var0_11 = arg0_11.cards[arg2_11]
	end

	local var1_11 = getProxy(BayProxy):RawGetShipById(arg0_11.shipIds[arg1_11 + 1])

	var0_11:Update(var1_11, false)
end

function var0_0.Flush(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	arg0_12:Show()
	arg0_12:UpdateTitle(arg1_12)
	arg0_12:UpdateSubTitle(arg2_12)
	arg0_12:UpdateList(arg3_12)

	arg0_12.callback = arg4_12
end

function var0_0.UpdateTitle(arg0_13, arg1_13)
	arg0_13.titleTxt.text = arg1_13.cn
	arg0_13.titleEnTxt.text = arg1_13.en
end

function var0_0.UpdateSubTitle(arg0_14, arg1_14)
	arg0_14.subTitleTxt.text = arg1_14
end

function var0_0.UpdateList(arg0_15, arg1_15)
	arg0_15.shipIds = arg1_15

	arg0_15.scrollrect:SetTotalCount(#arg0_15.shipIds)
end

function var0_0.Show(arg0_16)
	var0_0.super.Show(arg0_16)
	pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf)
end

function var0_0.Hide(arg0_17)
	arg0_17.callback = nil
	arg0_17.shipIds = nil

	for iter0_17, iter1_17 in pairs(arg0_17.cards) do
		iter1_17:Dispose()
	end

	arg0_17.cards = {}

	var0_0.super.Hide(arg0_17)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf, arg0_17._parentTf)
end

function var0_0.OnDestroy(arg0_18)
	arg0_18:Hide()
end

return var0_0
