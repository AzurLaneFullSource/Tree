local var0_0 = class("MainChatRoomView4Mellow", import("...theme_classic.view.MainChatRoomView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.bgTr = arg1_1:Find("bg")

	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.MAX_COUNT = 1
end

function var0_0.GoChatView(arg0_2, arg1_2)
	if arg0_2.exited then
		return
	end

	arg0_2:emit(NewMainMediator.OPEN_CHATVIEW)
end

function var0_0.UpdateBtnState(arg0_3)
	var0_0.super.UpdateBtnState(arg0_3)

	local var0_3 = arg0_3.hideChatFlag and arg0_3.hideChatFlag == 1

	setActive(arg0_3.bgTr, not var0_3)
end

function var0_0.GetDirection(arg0_4)
	return Vector2.zero
end

return var0_0
