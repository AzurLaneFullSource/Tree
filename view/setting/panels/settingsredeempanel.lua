local var0_0 = class("SettingsRedeemPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsRedeem"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Redeem")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / KEY"
end

function var0_0.OnInit(arg0_4)
	arg0_4.codeInput = findTF(arg0_4._tf, "voucher")
	arg0_4.placeholder = findTF(arg0_4.codeInput, "Placeholder")
	arg0_4.placeholder:GetComponent(typeof(Text)).text = i18n("exchangecode_use_placeholder")
	arg0_4.achieveBtn = findTF(arg0_4.codeInput, "submit")

	onButton(arg0_4, arg0_4.achieveBtn, function()
		pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
			key = arg0_4.codeInput:GetComponent(typeof(InputField)).text
		})
	end, SFX_CONFIRM)
	setGray(arg0_4.achieveBtn, getInputText(arg0_4.codeInput) == "")
	onInputChanged(arg0_4, arg0_4.codeInput, function()
		setGray(arg0_4.achieveBtn, getInputText(arg0_4.codeInput) == "")
	end)
	setText(findTF(arg0_4._tf, "voucher/prompt"), i18n("Settings_title_Redeem_input_label"))
	setText(findTF(arg0_4._tf, "voucher/Placeholder"), i18n("Settings_title_Redeem_input_placeholder"))
	setText(findTF(arg0_4._tf, "voucher/submit/Image"), i18n("Settings_title_Redeem_input_submit"))
end

function var0_0.ClearExchangeCode(arg0_7)
	arg0_7.codeInput:GetComponent(typeof(InputField)).text = ""
end

return var0_0
