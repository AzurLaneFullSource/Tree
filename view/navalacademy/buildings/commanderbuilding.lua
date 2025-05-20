local var0_0 = class("CommanderBuilding", import(".NavalAcademyBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "commander"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_zhihuimiao")
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NavalAcademyMediator.ON_OPEN_COMMANDER)
end

function var0_0.IsTip(arg0_4)
	if getProxy(PlayerProxy):getRawData().level < 40 then
		return false
	end

	local var0_4 = getProxy(CommanderProxy):haveFinishedBox()

	if not LOCK_CATTERY then
		return var0_4 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
	else
		return var0_4
	end
end

function var0_0.OnInit(arg0_5)
	local var0_5 = arg0_5:IsUnlock()

	setActive(arg0_5._tf:Find("name/lock"), not var0_5)
end

function var0_0.IsUnlock(arg0_6)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator")
end

return var0_0
