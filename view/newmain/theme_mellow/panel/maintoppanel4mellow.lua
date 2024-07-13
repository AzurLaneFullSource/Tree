local var0_0 = class("MainTopPanel4Mellow", import("...base.MainBasePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainPlayerInfoBtn4Mellow.New(arg0_1._tf, arg0_1.event),
		MainMailBtn.New(findTF(arg0_1._tf, "btns/mail"), arg0_1.event),
		MainNoticeBtn.New(findTF(arg0_1._tf, "btns/noti"), arg0_1.event),
		MainSettingsBtn.New(findTF(arg0_1._tf, "btns/settings"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(0, 1)
end

return var0_0
