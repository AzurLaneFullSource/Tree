local var0_0 = class("MainLeftPanel", import("...base.MainConcealablePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainCommissionBtn.New(findTF(arg0_1._tf, "commissionButton"), arg0_1.event),
		MainHideBtn.New(findTF(arg0_1._tf, "hideButton"), arg0_1.event),
		MainCameraBtn.New(findTF(arg0_1._tf, "cameraButton"), arg0_1.event),
		MainWordBtn.New(findTF(arg0_1._tf, "wordBtn"), arg0_1.event),
		MainChangeSkinBtn.New(findTF(arg0_1._tf, "changeBtn"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(-1, 0)
end

return var0_0
