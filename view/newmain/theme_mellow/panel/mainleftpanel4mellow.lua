local var0_0 = class("MainLeftPanel4Mellow", import("...base.MainFdConcealablePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainCommissionBtn4Mellow.New(findTF(arg0_1._tf, "extend"), arg0_1.event, 0.5),
		MainHideBtn.New(findTF(arg0_1._tf, "btns/eye"), arg0_1.event),
		MainCameraBtn.New(findTF(arg0_1._tf, "btns/cam"), arg0_1.event),
		MainWordBtn.New(findTF(arg0_1._tf, "btns/word"), arg0_1.event),
		MainChangeSkinBtn.New(findTF(arg0_1._tf, "btns/change"), arg0_1.event),
		MainResetL2dBtn.New(findTF(arg0_1._tf, "btns/l2d"), arg0_1.event),
		MainL2dBoundBtn.New(findTF(arg0_1._tf, "btns/l2d_bound"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(-1, 0)
end

function var0_0.CalcLayout(arg0_3)
	return
end

return var0_0
