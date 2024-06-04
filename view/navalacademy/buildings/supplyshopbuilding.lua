local var0 = class("SupplyShopBuilding", import(".NavalAcademyBuilding"))

function var0.GetGameObjectName(arg0)
	return "supplyShop"
end

function var0.GetTitle(arg0)
	return i18n("school_title_shangdian")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_SUPPLYSHOP)
end

function var0.IsTip(arg0)
	local var0 = getProxy(ShopsProxy):getShopStreet()

	return var0 and var0:isUpdateGoods()
end

return var0
