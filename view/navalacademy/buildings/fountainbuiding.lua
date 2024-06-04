local var0 = class("FountainBuiding", import(".NavalAcademyBuilding"))

function var0.GetGameObjectName(arg0)
	return "fountain"
end

function var0.GetTitle(arg0)
	return i18n("school_title_shoucang")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_COLLECTION)
end

function var0.IsTip(arg0)
	return getProxy(CollectionProxy):unclaimTrophyCount() > 0
end

return var0
