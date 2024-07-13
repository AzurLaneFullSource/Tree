local var0_0 = class("SupplyShopBuilding", import(".NavalAcademyBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "supplyShop"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_shangdian")
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NavalAcademyMediator.ON_OPEN_SUPPLYSHOP)
end

function var0_0.IsTip(arg0_4)
	local var0_4 = getProxy(ShopsProxy):getShopStreet()

	return var0_4 and var0_4:isUpdateGoods()
end

return var0_0
