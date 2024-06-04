local var0 = class("MainTopPanel4Mellow", import("...base.MainBasePanel"))

function var0.GetBtns(arg0)
	return {
		MainPlayerInfoBtn4Mellow.New(arg0._tf, arg0.event),
		MainMailBtn.New(findTF(arg0._tf, "btns/mail"), arg0.event),
		MainNoticeBtn.New(findTF(arg0._tf, "btns/noti"), arg0.event),
		MainSettingsBtn.New(findTF(arg0._tf, "btns/settings"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(0, 1)
end

return var0
