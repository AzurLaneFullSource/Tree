local var0_0 = class("Dorm3dGameTemplate", import("view.base.BaseUI"))

function var0_0.forceGC(arg0_1)
	return true
end

function var0_0.loadingQueue(arg0_2)
	return function(arg0_3)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_4)
			return arg0_3(arg0_4)
		end)
	end
end

function var0_0.getUIName(arg0_5)
	return nil
end

function var0_0.SetApartment(arg0_6, arg1_6)
	arg0_6.apartment = arg1_6
end

function var0_0.ShowResultUI(arg0_7, arg1_7)
	return nil
end

return var0_0
