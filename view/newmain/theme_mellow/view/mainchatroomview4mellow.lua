local var0 = class("MainChatRoomView4Mellow", import("...theme_classic.view.MainChatRoomView"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.bgTr = arg1:Find("bg")

	var0.super.Ctor(arg0, arg1, arg2)

	arg0.MAX_COUNT = 1
end

function var0.GoChatView(arg0, arg1)
	if arg0.exited then
		return
	end

	arg0:emit(NewMainMediator.OPEN_CHATVIEW)
end

function var0.UpdateBtnState(arg0)
	var0.super.UpdateBtnState(arg0)

	local var0 = arg0.hideChatFlag and arg0.hideChatFlag == 1

	setActive(arg0.bgTr, not var0)
end

function var0.GetDirection(arg0)
	return Vector2.zero
end

return var0
