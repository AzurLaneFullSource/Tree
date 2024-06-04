local var0 = class("MainBottomPanel", import("...base.MainBasePanel"))

function var0.GetBtns(arg0)
	return {
		MainMallBtn.New(findTF(arg0._tf, "mallBtn"), findTF(arg0._tf, "tags"), arg0.event),
		MainDockBtn.New(findTF(arg0._tf, "dockBtn"), arg0.event),
		MainEquipBtn.New(findTF(arg0._tf, "equipButton"), arg0.event),
		MainLiveBtn.New(findTF(arg0._tf, "liveButton"), arg0.event),
		MainTechBtn.New(findTF(arg0._tf, "technologyButton"), arg0.event),
		MainTaskBtn.New(findTF(arg0._tf, "taskButton"), arg0.event),
		MainBuildBtn.New(findTF(arg0._tf, "buildButton"), arg0.event),
		MainGuildBtn.New(findTF(arg0._tf, "guildButton"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(0, -1)
end

return var0
