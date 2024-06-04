local var0 = class("ConfirmEquipmentDeletePanel", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "EquipDeleteConfirmBox"
end

function var0.UpdateView(arg0, arg1)
	arg1.hideYes = true

	var0.super.UpdateView(arg0, arg1)
end

function var0.OnRefresh(arg0, arg1)
	local var0 = arg1.data

	arg0:SetWindowSize(Vector2(937, 540))

	local var1 = arg0._tf:Find("intro")
	local var2 = arg0._tf:Find("InputField")
	local var3 = var2:Find("Placeholder")

	setText(var3, i18n("box_equipment_del_click"))
	setText(var1, SwitchSpecialChar(i18n("destory_important_equipment_tip", var0.name)))

	local function var4()
		local var0 = getInputText(var2)

		if not var0 or var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_should_input"))

			return
		end

		if var0 ~= var0.name then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destory_important_equipment_input_erro"))

			return
		end

		existCall(arg1.onYes)
		arg0:closeView()
	end

	arg0.yesBtn = arg0.viewParent:createBtn({
		noQuit = true,
		text = arg1.yesText or arg0.viewParent.TEXT_CONFIRM,
		btnType = arg1.yesBtnType or arg0.viewParent.BUTTON_BLUE,
		onCallback = var4,
		sound = arg1.yesSound or SFX_CONFIRM,
		alignment = arg1.yesSize and TextAnchor.MiddleCenter
	})

	if arg1.yesSize then
		arg0.yesBtn.sizeDelta = arg1.yesSize
	end

	setGray(arg0.yesBtn, arg1.yesGray, true)
end

return var0
