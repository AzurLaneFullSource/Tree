local var0_0 = class("FountainBuiding", import(".NavalAcademyBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "fountain"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_shoucang")
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NavalAcademyMediator.ON_OPEN_COLLECTION)
end

function var0_0.IsTip(arg0_4)
	return getProxy(CollectionProxy):unclaimTrophyCount() > 0
end

return var0_0
