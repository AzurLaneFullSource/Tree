local var0_0 = class("MainLeftPanel4Mellow", import("...base.MainFdConcealablePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainCommissionBtn4Mellow.New(findTF(arg0_1._tf, "extend"), arg0_1.event, 0.5),
		MainHideBtn.New(findTF(arg0_1._tf, "eye"), arg0_1.event),
		MainCameraBtn.New(findTF(arg0_1._tf, "cam"), arg0_1.event),
		MainWordBtn.New(findTF(arg0_1._tf, "word"), arg0_1.event),
		MainChangeSkinBtn.New(findTF(arg0_1._tf, "change"), arg0_1.event),
		MainResetL2dBtn.New(findTF(arg0_1._tf, "l2d"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(-1, 0)
end

return var0_0
