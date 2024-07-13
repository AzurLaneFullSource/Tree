local var0_0 = class("MainBottomPanel", import("...base.MainBasePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainMallBtn.New(findTF(arg0_1._tf, "mallBtn"), findTF(arg0_1._tf, "tags"), arg0_1.event),
		MainDockBtn.New(findTF(arg0_1._tf, "dockBtn"), arg0_1.event),
		MainEquipBtn.New(findTF(arg0_1._tf, "equipButton"), arg0_1.event),
		MainLiveBtn.New(findTF(arg0_1._tf, "liveButton"), arg0_1.event),
		MainTechBtn.New(findTF(arg0_1._tf, "technologyButton"), arg0_1.event),
		MainTaskBtn.New(findTF(arg0_1._tf, "taskButton"), arg0_1.event),
		MainBuildBtn.New(findTF(arg0_1._tf, "buildButton"), arg0_1.event),
		MainGuildBtn.New(findTF(arg0_1._tf, "guildButton"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(0, -1)
end

return var0_0
