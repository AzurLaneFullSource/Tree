local var0 = class("CanteenBuiding", import(".NavalAcademyUpgradableBuilding"))

function var0.GetGameObjectName(arg0)
	return "canteen"
end

function var0.GetTitle(arg0)
	return i18n("school_title_shitang")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_OILRESFIELD)
end

function var0.GetResField(arg0)
	return arg0.parent.oilResField
end

return var0
