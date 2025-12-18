local var0_0 = class("HelenaUrExchangePage", import("view.activity.CorePage.CoreURExchangeTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1._btnExchange = arg0_1._tf:Find("AD/btn_exchange_on")
	arg0_1._btnExchange_off = arg0_1._tf:Find("AD/btn_exchange_off")
	arg0_1._msgBoxBtnCancel = arg0_1._msgBox:Find("msg_box/btn_cancel")
	arg0_1._msgBoxBtnConfirm = arg0_1._msgBox:Find("msg_box/btn_confirm")
	arg0_1._msgBoxLabel = arg0_1._msgBox:Find("msg_box/label/text_cn")
	arg0_1._msgBoxItem = arg0_1._msgBox:Find("msg_box/item/IconTpl")
	arg0_1._msgBoxItemName = arg0_1._msgBox:Find("msg_box/item/name")
	arg0_1._msgBoxItemDesc = arg0_1._msgBox:Find("msg_box/item/desc")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2._btnExchange, function()
		local var0_3 = Drop.Create({
			arg0_2.curGoods.commodity_type,
			arg0_2.curGoods.commodity_id,
			1
		})

		updateDrop(arg0_2._msgBoxItem, var0_3)
		setText(arg0_2._msgBoxItemName, var0_3:getName())
		setText(arg0_2._msgBoxItemDesc, var0_3.desc)
		pg.UIMgr.GetInstance():BlurPanel(arg0_2._msgBox)
		setActive(arg0_2._msgBox, true)

		arg0_2.isMsgBoxShow = true
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._btnExchange_off, function()
		setActive(arg0_2._ptTip, true)

		arg0_2.leantween = LeanTween.delayedCall(1, System.Action(function()
			setActive(arg0_2._ptTip, false)
		end)).uniqueId
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:UpdateExchangeStatus()
	arg0_6.uilist:align(#arg0_6.taskConfig)
	arg0_6:UpdatePtCount()
	setActive(arg0_6._btnExchange:Find("red"), arg0_6.canExchange)
	setActive(arg0_6._btnExchange, arg0_6.canExchange)
	setActive(arg0_6._btnExchange_off, not arg0_6.canExchange)
end

return var0_0
