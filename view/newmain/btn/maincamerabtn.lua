local var0 = class("MainCameraBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:OpenCamera()
end

function var0.Flush(arg0, arg1)
	local var0 = pg.SdkMgr.GetInstance():IsAUPackage()

	setActive(arg0._tf, not var0)
end

function var0.OpenCamera(arg0)
	if pg.SdkMgr.GetInstance():IsYunPackage() then
		pg.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持该功能哦")

		return
	end

	local var0
	local var1

	local function var2()
		arg0:emit(NewMainMediator.GO_SNAPSHOT)
	end

	local function var3()
		if CameraHelper.IsAndroid() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_camera_tip3"),
				onYes = function()
					CameraHelper.RequestCamera(var2, var3)
				end
			})
		elseif CameraHelper.IsIOS() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_camera_tip2")
			})
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("apply_permission_camera_tip1"),
		onYes = function()
			CameraHelper.RequestCamera(var2, var3)
		end
	})
end

return var0
