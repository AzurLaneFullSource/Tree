local var0_0 = class("MainBottomPanel4Mellow", import("...base.MainBasePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainMallBtn.New(findTF(arg0_1._tf, "frame/shop"), findTF(arg0_1._tf, "tags"), arg0_1.event),
		MainDockBtn.New(findTF(arg0_1._tf, "frame/dock"), arg0_1.event),
		MainEquipBtn.New(findTF(arg0_1._tf, "frame/storage"), arg0_1.event),
		MainLiveBtn.New(findTF(arg0_1._tf, "frame/live"), arg0_1.event),
		MainTechBtn.New(findTF(arg0_1._tf, "frame/tech"), arg0_1.event),
		MainTaskBtn.New(findTF(arg0_1._tf, "frame/task"), arg0_1.event),
		MainBuildBtn.New(findTF(arg0_1._tf, "frame/build"), arg0_1.event),
		MainGuildBtn.New(findTF(arg0_1._tf, "frame/guild"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(0, -1)
end

return var0_0
