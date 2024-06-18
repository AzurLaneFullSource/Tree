local var0_0 = class("MainNoticeBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	if #getProxy(ServerNoticeProxy):getServerNotices(false) > 0 then
		arg0_1:emit(NewMainMediator.OPEN_NOTICE)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("no_notice_tip"))
	end
end

return var0_0
