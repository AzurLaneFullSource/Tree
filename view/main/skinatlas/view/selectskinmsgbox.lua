local var0_0 = class("SelectSkinMsgbox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SelectSkinMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.cancelBtn = arg0_2:findTF("window/button_container/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("window/button_container/confirm")
	arg0_2.contentTxt = arg0_2:findTF("window/frame/content"):GetComponent(typeof(Text))
	arg0_2.leftItemTr = arg0_2:findTF("window/frame/left")
	arg0_2.rightItemTr = arg0_2:findTF("window/frame/right")
	arg0_2.leftNameTxt = arg0_2.leftItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))
	arg0_2.rightNameTxt = arg0_2.rightItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0_2.cancelBtn:Find("pic"), i18n("msgbox_text_cancel"))
	setText(arg0_2.confirmBtn:Find("pic"), i18n("msgbox_text_confirm"))
	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))
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
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_7.contentTxt.text = arg1_7.content

	updateDrop(arg0_7.leftItemTr, arg1_7.leftDrop)
	updateDrop(arg0_7.rightItemTr, arg1_7.rightDrop)

	arg0_7.leftNameTxt.text = arg1_7.leftDrop:getConfig("name")
	arg0_7.rightNameTxt.text = arg1_7.rightDrop:getConfig("name")

	onButton(arg0_7, arg0_7.confirmBtn, function()
		arg0_7:Hide()

		if arg1_7.onYes then
			arg1_7.onYes()
		end
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	var0_0.super.Hide(arg0_9)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
