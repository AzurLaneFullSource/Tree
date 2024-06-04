local var0 = class("SettingsRedeemPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsRedeem"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_Redeem")
end

function var0.GetTitleEn(arg0)
	return "  / KEY"
end

function var0.OnInit(arg0)
	arg0.codeInput = findTF(arg0._tf, "voucher")
	arg0.placeholder = findTF(arg0.codeInput, "Placeholder")
	arg0.placeholder:GetComponent(typeof(Text)).text = i18n("exchangecode_use_placeholder")
	arg0.achieveBtn = findTF(arg0.codeInput, "submit")

	onButton(arg0, arg0.achieveBtn, function()
		pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
			key = arg0.codeInput:GetComponent(typeof(InputField)).text
		})
	end, SFX_CONFIRM)
	setGray(arg0.achieveBtn, getInputText(arg0.codeInput) == "")
	onInputChanged(arg0, arg0.codeInput, function()
		setGray(arg0.achieveBtn, getInputText(arg0.codeInput) == "")
	end)
	setText(findTF(arg0._tf, "voucher/prompt"), i18n("Settings_title_Redeem_input_label"))
	setText(findTF(arg0._tf, "voucher/Placeholder"), i18n("Settings_title_Redeem_input_placeholder"))
	setText(findTF(arg0._tf, "voucher/submit/Image"), i18n("Settings_title_Redeem_input_submit"))
end

function var0.ClearExchangeCode(arg0)
	arg0.codeInput:GetComponent(typeof(InputField)).text = ""
end

return var0
