local var0 = class("ChargeBirthdayLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeBirthdayUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	return
end

function var0.initUIText(arg0)
	arg0.inputSC.text = ""
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.window = arg0:findTF("window")
	arg0.inputField = arg0:findTF("birthday_input_panel/InputField", arg0.window)
	arg0.inputSC = GetComponent(arg0.inputField, typeof(InputField))
	arg0.cancelBtn = arg0:findTF("birthday_input_panel/btns/cancel_btn", arg0.window)
	arg0.confirmBtn = arg0:findTF("birthday_input_panel/btns/confirm_btn", arg0.window)
	arg0.closeBtn = arg0:findTF("top/btnBack", arg0.window)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeView()
	end)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeView()
	end)
	onButton(arg0, arg0.confirmBtn, function()
		if not checkBirthFormat(arg0.inputSC.text) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("set_birth_empty_tip"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				title = i18n("set_birth_title"),
				content = i18n("set_birth_confirm_tip", arg0.inputSC.text),
				onYes = function()
					pg.SdkMgr.GetInstance():SetBirth(arg0.inputSC.text)
					arg0:closeView()
				end
			})
		end
	end)
end

return var0
