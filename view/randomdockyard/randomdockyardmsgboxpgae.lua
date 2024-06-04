local var0 = class("RandomDockYardMsgBoxPgae", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "RandomDockYardMsgBoxUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/top/btnBack")
	arg0.cancelBtn = arg0:findTF("frame/cancel_button")
	arg0.confirmBtn = arg0:findTF("frame/confirm_button")
	arg0.scrollrect = arg0:findTF("frame/sliders"):GetComponent("LScrollRect")
	arg0.titleTxt = arg0:findTF("frame/top/title_list/infomation/title"):GetComponent(typeof(Text))
	arg0.titleEnTxt = arg0:findTF("frame/top/title_list/infomation/title_en"):GetComponent(typeof(Text))
	arg0.subTitleTxt = arg0:findTF("frame/label/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/confirm_button/pic"), i18n("text_confirm"))
	setText(arg0:findTF("frame/cancel_button/pic"), i18n("text_cancel"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.callback then
			arg0.callback()
		end

		arg0:Hide()
	end, SFX_PANEL)

	arg0.cards = {}

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = RandomDockYardCard.New(arg1)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = getProxy(BayProxy):RawGetShipById(arg0.shipIds[arg1 + 1])

	var0:Update(var1, false)
end

function var0.Flush(arg0, arg1, arg2, arg3, arg4)
	arg0:Show()
	arg0:UpdateTitle(arg1)
	arg0:UpdateSubTitle(arg2)
	arg0:UpdateList(arg3)

	arg0.callback = arg4
end

function var0.UpdateTitle(arg0, arg1)
	arg0.titleTxt.text = arg1.cn
	arg0.titleEnTxt.text = arg1.en
end

function var0.UpdateSubTitle(arg0, arg1)
	arg0.subTitleTxt.text = arg1
end

function var0.UpdateList(arg0, arg1)
	arg0.shipIds = arg1

	arg0.scrollrect:SetTotalCount(#arg0.shipIds)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	arg0.callback = nil
	arg0.shipIds = nil

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = {}

	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
