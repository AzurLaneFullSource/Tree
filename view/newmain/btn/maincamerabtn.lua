local var0_0 = class("MainCameraBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:OpenCamera()
end

function var0_0.Flush(arg0_2, arg1_2)
	setActive(arg0_2._tf, true)
end

function var0_0.OpenCamera(arg0_3)
	if pg.SdkMgr.GetInstance():IsYunPackage() then
		pg.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持该功能哦")

		return
	end

	local var0_3
	local var1_3

	local function var2_3()
		arg0_3:emit(NewMainMediator.GO_SNAPSHOT)
	end

	local function var3_3()
		if PermissionHelper.IsAndroid() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_camera_tip3"),
				onYes = function()
					PermissionHelper.RequestCamera(var2_3, var3_3)
				end
			})
		elseif PermissionHelper.IsIOS() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_camera_tip2")
			})
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("apply_permission_camera_tip1"),
		onYes = function()
			PermissionHelper.RequestCamera(var2_3, var3_3)
		end
	})
end

return var0_0
