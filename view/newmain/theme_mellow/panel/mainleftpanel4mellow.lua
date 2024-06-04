local var0 = class("MainLeftPanel4Mellow", import("...base.MainFdConcealablePanel"))

function var0.GetBtns(arg0)
	return {
		MainCommissionBtn4Mellow.New(findTF(arg0._tf, "extend"), arg0.event, 0.5),
		MainHideBtn.New(findTF(arg0._tf, "eye"), arg0.event),
		MainCameraBtn.New(findTF(arg0._tf, "cam"), arg0.event),
		MainWordBtn.New(findTF(arg0._tf, "word"), arg0.event),
		MainChangeSkinBtn.New(findTF(arg0._tf, "change"), arg0.event),
		MainResetL2dBtn.New(findTF(arg0._tf, "l2d"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(-1, 0)
end

return var0
