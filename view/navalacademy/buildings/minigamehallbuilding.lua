local var0_0 = class("MinigameHallBuilding", import(".NavalAcademyBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "minigamehall"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_xiaoyouxiting")
end

function var0_0.OnInit(arg0_3)
	setActive(arg0_3._tf, not LOCK_MINIGAME_HALL)
end

function var0_0.OnClick(arg0_4)
	arg0_4:emit(NavalAcademyMediator.ON_OPEN_MINIGAMEHALL)
end

function var0_0.IsTip(arg0_5)
	return false
end

return var0_0
