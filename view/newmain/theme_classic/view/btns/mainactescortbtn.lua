local var0_0 = class("MainActEscortBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_escort"
end

function var0_0.GetActivityID(arg0_2)
	return nil
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ChapterProxy)

	arg0_3.maxTimes = var0_3:getMaxEscortChallengeTimes()

	local var1_3 = var0_3.escortChallengeTimes < arg0_3.maxTimes

	setActive(arg0_3._tf:Find("Tip"), var1_3)
end

function var0_0.CustomOnClick(arg0_4)
	local var0_4, var1_4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "Escort")

	if not var0_4 then
		pg.TipsMgr.GetInstance():ShowTips(var1_4)

		return
	end

	if getProxy(ChapterProxy):getMaxEscortChallengeTimes() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	arg0_4:emit(NewMainMediator.SKIP_ESCORT)
end

return var0_0
