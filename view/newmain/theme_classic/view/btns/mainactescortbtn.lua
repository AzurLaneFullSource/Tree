local var0 = class("MainActEscortBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_escort"
end

function var0.GetActivityID(arg0)
	return nil
end

function var0.OnInit(arg0)
	local var0 = getProxy(ChapterProxy)

	arg0.maxTimes = var0:getMaxEscortChallengeTimes()

	local var1 = var0.escortChallengeTimes < arg0.maxTimes

	setActive(arg0._tf:Find("Tip"), var1)
end

function var0.CustomOnClick(arg0)
	local var0, var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "Escort")

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips(var1)

		return
	end

	if getProxy(ChapterProxy):getMaxEscortChallengeTimes() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	arg0:emit(NewMainMediator.SKIP_ESCORT)
end

return var0
