local var0 = class("MinigameHallBuilding", import(".NavalAcademyBuilding"))

function var0.GetGameObjectName(arg0)
	return "minigamehall"
end

function var0.GetTitle(arg0)
	return i18n("school_title_xiaoyouxiting")
end

function var0.OnInit(arg0)
	setActive(arg0._tf, not LOCK_MINIGAME_HALL)
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_MINIGAMEHALL)
end

function var0.IsTip(arg0)
	return false
end

return var0
