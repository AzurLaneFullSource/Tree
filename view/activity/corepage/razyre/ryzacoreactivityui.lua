local var0_0 = class("RyzaCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "RyzaCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_3, arg1_3)
		arg0_2:UpdateAdapt()
	end)

	arg0_2:UpdateAdapt()
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
end

function var0_0.UpdateAdapt(arg0_5)
	local var0_5 = 1.33333333333333
	local var1_5 = 2.16666666666667
	local var2_5 = pg.CameraFixMgr.GetInstance()
	local var3_5 = var2_5.currentWidth / var2_5.currentHeight
	local var4_5 = math.clamp(var3_5, var0_5, var1_5)

	arg0_5._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_5
end

function var0_0.willExit(arg0_6)
	var0_0.super.willExit(arg0_6)

	if arg0_6.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_6.camEventId)

		arg0_6.camEventId = nil
	end
end

return var0_0
