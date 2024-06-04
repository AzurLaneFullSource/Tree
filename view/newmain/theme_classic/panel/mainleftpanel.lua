local var0 = class("MainLeftPanel", import("...base.MainConcealablePanel"))

function var0.GetBtns(arg0)
	return {
		MainCommissionBtn.New(findTF(arg0._tf, "commissionButton"), arg0.event),
		MainHideBtn.New(findTF(arg0._tf, "hideButton"), arg0.event),
		MainCameraBtn.New(findTF(arg0._tf, "cameraButton"), arg0.event),
		MainWordBtn.New(findTF(arg0._tf, "wordBtn"), arg0.event),
		MainChangeSkinBtn.New(findTF(arg0._tf, "changeBtn"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(-1, 0)
end

return var0
