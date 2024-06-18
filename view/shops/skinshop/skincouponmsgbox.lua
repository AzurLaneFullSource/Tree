local var0_0 = class("SkinCouponMsgBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SkinCouponMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.cancelBtn = arg0_2:findTF("window/button_container/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("window/button_container/confirm")
	arg0_2.label1 = arg0_2:findTF("window/frame/Text"):GetComponent(typeof(Text))
	arg0_2.leftItemTr = arg0_2:findTF("window/frame/left")
	arg0_2.nameTxt = arg0_2.leftItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0_2.cancelBtn:Find("pic"), i18n("msgbox_text_cancel"))
	setText(arg0_2.confirmBtn:Find("pic"), i18n("msgbox_text_confirm"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.settings = arg1_7

	arg0_7:UpdateItem(arg1_7)
	arg0_7:RegisterBtn(arg1_7)
	arg0_7:UpdateContent(arg1_7)
end

function var0_0.RegisterBtn(arg0_8, arg1_8)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg1_8.onYes then
			arg1_8.onYes()
		end

		arg0_8:Hide()
	end, SFX_PANEL)
end

function var0_0.UpdateContent(arg0_10, arg1_10)
	local var0_10 = arg1_10.itemConfig
	local var1_10 = arg1_10.skinName
	local var2_10 = arg1_10.price

	arg0_10.label1.text = i18n("skin_purchase_confirm", var0_10.name, var2_10, var1_10)
	arg0_10.nameTxt.text = var0_10.name
end

function var0_0.UpdateItem(arg0_11, arg1_11)
	updateDrop(arg0_11.leftItemTr, {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = arg1_11.itemConfig.id
	})
end

function var0_0.Hide(arg0_12)
	arg0_12.settings = nil

	var0_0.super.Hide(arg0_12)
	arg0_12:Destroy()
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
