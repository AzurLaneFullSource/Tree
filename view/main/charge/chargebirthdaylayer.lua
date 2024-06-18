local var0_0 = class("ChargeBirthdayLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeBirthdayUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	return
end

function var0_0.initUIText(arg0_6)
	arg0_6.inputSC.text = ""
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("bg")
	arg0_7.window = arg0_7:findTF("window")
	arg0_7.inputField = arg0_7:findTF("birthday_input_panel/InputField", arg0_7.window)
	arg0_7.inputSC = GetComponent(arg0_7.inputField, typeof(InputField))
	arg0_7.cancelBtn = arg0_7:findTF("birthday_input_panel/btns/cancel_btn", arg0_7.window)
	arg0_7.confirmBtn = arg0_7:findTF("birthday_input_panel/btns/confirm_btn", arg0_7.window)
	arg0_7.closeBtn = arg0_7:findTF("top/btnBack", arg0_7.window)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:closeView()
	end)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:closeView()
	end)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if not checkBirthFormat(arg0_8.inputSC.text) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("set_birth_empty_tip"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				title = i18n("set_birth_title"),
				content = i18n("set_birth_confirm_tip", arg0_8.inputSC.text),
				onYes = function()
					pg.SdkMgr.GetInstance():SetBirth(arg0_8.inputSC.text)
					arg0_8:closeView()
				end
			})
		end
	end)
end

return var0_0
