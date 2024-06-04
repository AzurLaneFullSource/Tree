local var0 = class("MainBottomPanel4Mellow", import("...base.MainBasePanel"))

function var0.GetBtns(arg0)
	return {
		MainMallBtn.New(findTF(arg0._tf, "frame/shop"), findTF(arg0._tf, "tags"), arg0.event),
		MainDockBtn.New(findTF(arg0._tf, "frame/dock"), arg0.event),
		MainEquipBtn.New(findTF(arg0._tf, "frame/storage"), arg0.event),
		MainLiveBtn.New(findTF(arg0._tf, "frame/live"), arg0.event),
		MainTechBtn.New(findTF(arg0._tf, "frame/tech"), arg0.event),
		MainTaskBtn.New(findTF(arg0._tf, "frame/task"), arg0.event),
		MainBuildBtn.New(findTF(arg0._tf, "frame/build"), arg0.event),
		MainGuildBtn.New(findTF(arg0._tf, "frame/guild"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(0, -1)
end

return var0
