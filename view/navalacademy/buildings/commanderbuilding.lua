local var0 = class("CommanderBuilding", import(".NavalAcademyBuilding"))

function var0.GetGameObjectName(arg0)
	return "commander"
end

function var0.GetTitle(arg0)
	return i18n("school_title_zhihuimiao")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_COMMANDER)
end

function var0.IsTip(arg0)
	if getProxy(PlayerProxy):getRawData().level < 40 then
		return false
	end

	local var0 = getProxy(CommanderProxy):haveFinishedBox()

	if not LOCK_CATTERY then
		return var0 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse()
	else
		return var0
	end
end

return var0
