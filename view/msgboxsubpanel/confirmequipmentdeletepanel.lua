local var0_0 = class("ConfirmEquipmentDeletePanel", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "EquipDeleteConfirmBox"
end

function var0_0.UpdateView(arg0_2, arg1_2)
	arg1_2.hideYes = true

	var0_0.super.UpdateView(arg0_2, arg1_2)
end

function var0_0.OnRefresh(arg0_3, arg1_3)
	local var0_3 = arg1_3.data

	arg0_3:SetWindowSize(Vector2(937, 540))

	local var1_3 = arg0_3._tf:Find("intro")
	local var2_3 = arg0_3._tf:Find("InputField")
	local var3_3 = var2_3:Find("Placeholder")

	setText(var3_3, i18n("box_equipment_del_click"))
	setText(var1_3, SwitchSpecialChar(i18n("destory_important_equipment_tip", var0_3.name)))

	local function var4_3()
		local var0_4 = getInputText(var2_3)

		if not var0_4 or var0_4 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_should_input"))

			return
		end

		if var0_4 ~= var0_3.name then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destory_important_equipment_input_erro"))

			return
		end

		existCall(arg1_3.onYes)
		arg0_3:closeView()
	end

	arg0_3.yesBtn = arg0_3.viewParent:createBtn({
		noQuit = true,
		text = arg1_3.yesText or arg0_3.viewParent.TEXT_CONFIRM,
		btnType = arg1_3.yesBtnType or arg0_3.viewParent.BUTTON_BLUE,
		onCallback = var4_3,
		sound = arg1_3.yesSound or SFX_CONFIRM,
		alignment = arg1_3.yesSize and TextAnchor.MiddleCenter
	})

	if arg1_3.yesSize then
		arg0_3.yesBtn.sizeDelta = arg1_3.yesSize
	end

	setGray(arg0_3.yesBtn, arg1_3.yesGray, true)
end

return var0_0
