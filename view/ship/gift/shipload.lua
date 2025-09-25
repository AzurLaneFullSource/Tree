local var0_0 = class("ShipLoad")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.meshImageList = {}
	arg0_1.meshCallback = arg1_1
	arg0_1.l2dCallback = arg2_1
	arg0_1.spineCallback = arg3_1
end

function var0_0.LoadShip(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2, var1_2, var2_2 = arg0_2:GetShipPaintingName(arg1_2)

	if arg0_2.spineCallback and MainPaintingView.Live2dIsDownload(var1_2) and checkABExist(var1_2) then
		if arg0_2.live2dClass then
			arg0_2.live2dClass:Dispose()

			arg0_2.live2dClass = nil
		end

		local var3_2 = Live2D.GenerateData(arg2_2)

		arg0_2.live2dClass = Live2D.New(var3_2, function(arg0_3)
			if arg0_2.exit == true then
				return
			end

			arg0_2.l2dCallback(arg0_3)
		end)
	elseif arg0_2.l2dCallback and checkABExist(var2_2) then
		if arg0_2.spinePaintingClass then
			arg0_2.spinePaintingClass:Dispose()

			arg0_2.spinePaintingClass = nil
		end

		local var4_2 = SpinePainting.GenerateData(arg3_2)

		arg0_2.spinePaintingClass = SpinePainting.New(var4_2, function(arg0_4)
			if arg0_2.exit == ture then
				return
			end

			arg0_2.spineCallback(arg0_4)
		end)
	else
		arg0_2:LoadMeshShip(arg1_2, arg0_2.meshCallback)
	end
end

function var0_0.LoadMeshShip(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetShipPaintingName(arg1_5)

	PoolMgr:GetInstance():GetPainting(var0_5, true, function(arg0_6)
		if arg0_5.exit then
			arg0_5:ReturnPainting(arg1_5)

			return
		end

		arg0_5.meshImageList[var0_5] = arg0_6

		arg2_5(arg0_6)
	end)
end

function var0_0.ReturnPainting(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetShipPaintingName(arg1_7)

	PoolMgr.GetInstance():ReturnPainting(arg0_7.paintingName, arg0_7.actorPainting)
end

function var0_0.GetLive2dClass(arg0_8)
	return arg0_8.live2dClass
end

function var0_0.GetSpinePaintingClass(arg0_9)
	return arg0_9.spinePaintingClass
end

function var0_0.GetShipPaintingName(arg0_10, arg1_10)
	local var0_10 = getProxy(BayProxy):getShipById(arg1_10):getPainting()
	local var1_10 = var0_10

	if arg0_10:IsHideMeshBg(var1_10) then
		var1_10 = string.format("%s_n", var0_10)
	end

	local var2_10 = HXSet.autoHxShiftPath(var1_10)
	local var3_10 = HXSet.autoHxShiftPath(string.format("spinepainting/%s", var2_10))
	local var4_10 = HXSet.autoHxShiftPath(string.format("live2d/%s", var2_10))

	return var2_10, var4_10, var3_10
end

function var0_0.IsHideMeshBg(arg0_11, arg1_11)
	return checkABExist(string.format("painting/%s_n", arg1_11)) and PlayerPrefs.GetInt(string.format("paint_hide_other_obj_%s", arg1_11), 0) ~= 0
end

function var0_0.ClearShip(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.meshImageList) do
		PoolMgr.GetInstance():ReturnPainting(iter0_12, iter1_12)
	end

	arg0_12.meshImageList = {}

	if arg0_12.live2dClass then
		arg0_12.live2dClass:Dispose()

		arg0_12.live2dClass = nil
	end

	if arg0_12.spinePaintingClass then
		arg0_12.spinePaintingClass:Dispose()

		arg0_12.spinePaintingClass = nil
	end
end

function var0_0.Dispose(arg0_13)
	arg0_13.exit = true

	arg0_13:ClearShip()
end

return var0_0
