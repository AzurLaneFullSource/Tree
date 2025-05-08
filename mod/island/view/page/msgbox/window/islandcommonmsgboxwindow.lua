local var0_0 = class("IslandCommonMsgboxWindow", import(".IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2:findTF("title"):GetComponent(typeof(Text))
	arg0_2.contentTxt = arg0_2:findTF("content/Text"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("close")
	arg0_2.cancelBtn = arg0_2:findTF("cancel")
	arg0_2.confirmBtn = arg0_2:findTF("confirm")

	setText(arg0_2:findTF("cancel/Text"), i18n1("取消"))
	setText(arg0_2:findTF("confirm/Text"), i18n1("确定"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.onNo then
			arg0_3.onNo()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onYes then
			arg0_3.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_7)
	local var0_7 = arg0_7.settings

	arg0_7.titleTxt.text = var0_7.title or i18n1("信息")
	arg0_7.contentTxt.text = var0_7.content or ""
	arg0_7.onYes = var0_7.onYes
	arg0_7.onNo = var0_7.onNo

	arg0_7:FlushBtn(var0_7)
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	setActive(arg0_8.cancelBtn, not arg1_8.hideNo)

	local var0_8 = arg1_8.hideNo and 880 or 420

	arg0_8.confirmBtn.sizeDelta = Vector2(var0_8, arg0_8.confirmBtn.sizeDelta.y)
end

function var0_0.OnHide(arg0_9)
	arg0_9.onYes = nil
	arg0_9.onNo = nil
end

function var0_0.GetMsgBoxMgr(arg0_10)
	return arg0_10.view
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
