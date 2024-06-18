local var0_0 = class("ShopBuiding", import(".NavalAcademyUpgradableBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "shop"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_xiaomaibu")
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NavalAcademyMediator.ON_OPEN_GOLDRESFIELD)
end

function var0_0.GetResField(arg0_4)
	return arg0_4.parent.goldResField
end

return var0_0
