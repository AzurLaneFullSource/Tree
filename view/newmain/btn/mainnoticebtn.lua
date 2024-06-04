local var0 = class("MainNoticeBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	if #getProxy(ServerNoticeProxy):getServerNotices(false) > 0 then
		arg0:emit(NewMainMediator.OPEN_NOTICE)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("no_notice_tip"))
	end
end

return var0
