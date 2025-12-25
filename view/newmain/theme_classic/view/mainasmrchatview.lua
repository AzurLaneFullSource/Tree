local var0_0 = class("MainAsmrChatView", import("...base.MainBaseView"))

var0_0.SET_CONTENT = "MainAsmrChatView:SetContent"
var0_0.START_CHAT = "MainAsmrChatView:Start_Chat"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	setActive(arg0_1._tf, true)

	arg0_1._textTF = findTF(arg0_1._tf, "text")
	arg0_1._chatTimer = nil

	setActive(arg0_1._tf, false)
	arg0_1:bind(MainAsmrChatView.SET_CONTENT, function(arg0_2, arg1_2, arg2_2)
		setText(arg0_1._textTF, arg2_2)
	end)
	arg0_1:bind(MainAsmrChatView.START_CHAT, function(arg0_3, arg1_3, arg2_3)
		if arg0_1._chatTimer then
			arg0_1._chatTimer:Stop()

			arg0_1._chatTimer = nil
		end

		setActive(arg0_1._tf, true)
		print("start Time" .. arg1_3 + arg2_3)

		arg0_1._chatTimer = Timer.New(function()
			if arg0_1._chatTimer then
				arg0_1._chatTimer:Stop()

				arg0_1._chatTimer = nil

				setActive(arg0_1._tf, false)
			end
		end, arg1_3 + arg2_3, 1)

		arg0_1._chatTimer:Start()
	end)
end

function var0_0.Init(arg0_5, arg1_5)
	setActive(arg0_5._tf, false)
	arg0_5:updateUI()
end

function var0_0.Refresh(arg0_6, arg1_6)
	return
end

function var0_0.updateUI(arg0_7)
	return
end

function var0_0.ShowChat(arg0_8, arg1_8, arg2_8)
	return
end

function var0_0.SetVisible(arg0_9, arg1_9)
	if not arg1_9 then
		if arg0_9._chatTimer then
			arg0_9._chatTimer:Stop()

			arg0_9._chatTimer = nil
		end

		setText(arg0_9._textTF, "")
		setActive(arg0_9._tf, arg1_9)
	end
end

return var0_0
