local var0 = class("SkinCouponMsgBox", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SkinCouponMsgBoxUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.cancelBtn = arg0:findTF("window/button_container/cancel")
	arg0.confirmBtn = arg0:findTF("window/button_container/confirm")
	arg0.label1 = arg0:findTF("window/frame/Text"):GetComponent(typeof(Text))
	arg0.leftItemTr = arg0:findTF("window/frame/left")
	arg0.nameTxt = arg0.leftItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0.cancelBtn:Find("pic"), i18n("msgbox_text_cancel"))
	setText(arg0.confirmBtn:Find("pic"), i18n("msgbox_text_confirm"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.settings = arg1

	arg0:UpdateItem(arg1)
	arg0:RegisterBtn(arg1)
	arg0:UpdateContent(arg1)
end

function var0.RegisterBtn(arg0, arg1)
	onButton(arg0, arg0.confirmBtn, function()
		if arg1.onYes then
			arg1.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.UpdateContent(arg0, arg1)
	local var0 = arg1.itemConfig
	local var1 = arg1.skinName
	local var2 = arg1.price

	arg0.label1.text = i18n("skin_purchase_confirm", var0.name, var2, var1)
	arg0.nameTxt.text = var0.name
end

function var0.UpdateItem(arg0, arg1)
	updateDrop(arg0.leftItemTr, {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = arg1.itemConfig.id
	})
end

function var0.Hide(arg0)
	arg0.settings = nil

	var0.super.Hide(arg0)
	arg0:Destroy()
end

function var0.OnDestroy(arg0)
	return
end

return var0
