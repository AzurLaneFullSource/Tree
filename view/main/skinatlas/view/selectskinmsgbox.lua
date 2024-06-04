local var0 = class("SelectSkinMsgbox", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SelectSkinMsgboxUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.cancelBtn = arg0:findTF("window/button_container/cancel")
	arg0.confirmBtn = arg0:findTF("window/button_container/confirm")
	arg0.contentTxt = arg0:findTF("window/frame/content"):GetComponent(typeof(Text))
	arg0.leftItemTr = arg0:findTF("window/frame/left")
	arg0.rightItemTr = arg0:findTF("window/frame/right")
	arg0.leftNameTxt = arg0.leftItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))
	arg0.rightNameTxt = arg0.rightItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0.cancelBtn:Find("pic"), i18n("msgbox_text_cancel"))
	setText(arg0.confirmBtn:Find("pic"), i18n("msgbox_text_confirm"))
	setText(arg0._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))
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
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0.contentTxt.text = arg1.content

	updateDrop(arg0.leftItemTr, arg1.leftDrop)
	updateDrop(arg0.rightItemTr, arg1.rightDrop)

	arg0.leftNameTxt.text = arg1.leftDrop:getConfig("name")
	arg0.rightNameTxt.text = arg1.rightDrop:getConfig("name")

	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()

		if arg1.onYes then
			arg1.onYes()
		end
	end, SFX_PANEL)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
