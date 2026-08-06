local var0_0 = class("IslandCommonMsgboxEXWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxEX"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2.rtTitle:GetComponent(typeof(Text))
	arg0_2.contentTxt = arg0_2.rtContext:GetComponent("RichText")
	arg0_2.cancelTxt = arg0_2.rtCancelText:GetComponent(typeof(Text))
	arg0_2.confirmTxt = arg0_2.rtConfirmText:GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		local var0_4 = arg0_3.onNo

		arg0_3:Hide()
		existCall(var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_6 = arg0_3.onYes

		arg0_3:Hide()
		existCall(var0_6)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_7)
	local var0_7 = arg0_7.settings

	if var0_7.rawIconDic then
		for iter0_7, iter1_7 in pairs(var0_7.rawIconDic) do
			arg0_7.contentTxt:AddSprite(iter0_7, iter1_7)
		end
	end

	arg0_7.titleTxt.text = var0_7.title or i18n("island_msg_info")
	arg0_7.contentTxt.text = var0_7.content or ""
	arg0_7.contentTxt.alignment = var0_7.alignment or TextAnchor.MiddleCenter
	arg0_7.onYes = var0_7.onYes
	arg0_7.onNo = var0_7.onNo
	arg0_7.onHide = var0_7.onHide

	arg0_7:FlushBtn(var0_7)
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	setActive(arg0_8.cancelBtn, not arg1_8.hideNo)

	local var0_8 = arg1_8.hideNo and 880 or 420

	arg0_8.confirmBtn.sizeDelta = Vector2(var0_8, arg0_8.confirmBtn.sizeDelta.y)
	arg0_8.cancelTxt.text = arg1_8.noText and arg1_8.noText or i18n("word_cancel")
	arg0_8.confirmTxt.text = arg1_8.yesText and arg1_8.yesText or i18n("word_ok")
end

function var0_0.OnHide(arg0_9)
	arg0_9.onYes = nil
	arg0_9.onNo = nil

	if arg0_9.onHide then
		arg0_9.onHide()

		arg0_9.onHide = nil
	end
end

function var0_0.GetMsgBoxMgr(arg0_10)
	return arg0_10.view
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
