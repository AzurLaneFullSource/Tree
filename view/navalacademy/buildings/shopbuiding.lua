local var0 = class("ShopBuiding", import(".NavalAcademyUpgradableBuilding"))

function var0.GetGameObjectName(arg0)
	return "shop"
end

function var0.GetTitle(arg0)
	return i18n("school_title_xiaomaibu")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_GOLDRESFIELD)
end

function var0.GetResField(arg0)
	return arg0.parent.goldResField
end

return var0
