PERMISSION_GRANTED = "permission_granted"
PERMISSION_NEVER_REMIND = "permission_never_remind"
PERMISSION_REJECT = "permission_reject"
ANDROID_CAMERA_PERMISSION = "android.permission.CAMERA"
ANDROID_RECORD_AUDIO_PERMISSION = "android.permission.RECORD_AUDIO"
ANDROID_WRITE_EXTERNAL_PERMISSION = "android.permission.WRITE_EXTERNAL_STORAGE"

function CheckPermissionGranted(arg0_1)
	return PermissionMgr.Inst:CheckPermissionGranted(arg0_1)
end

function ApplyPermission(arg0_2)
	PermissionMgr.Inst:ApplyPermission(arg0_2)
end

function OpenDetailSetting()
	PermissionMgr.Inst:OpenDetailSetting()
end

function OnPermissionRequestResult(arg0_4)
	pg.m02:sendNotification(PERMISSION_GRANTED, arg0_4)
end

function OnPermissionNeverRemind(arg0_5)
	pg.m02:sendNotification(PERMISSION_NEVER_REMIND, arg0_5)
end

function OnPermissionReject(arg0_6)
	pg.m02:sendNotification(PERMISSION_REJECT, arg0_6)
end

IOS_AV_AUTH_GRANTED = "IOS_AV_AUTH_GRANTED"
IOS_AV_AUTH_REJECTED = "IOS_AV_AUTH_REJECTED"

function OnReceiveIOSAVAuth(arg0_7)
	if arg0_7 == "true" then
		pg.m02:sendNotification(IOS_AV_AUTH_GRANTED)
	elseif arg0_7 == "false" then
		pg.m02:sendNotification(IOS_AV_AUTH_REJECTED)
	end
end

function CheckCameraPermissionGranted()
	local var0_8 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

	if var0_8 == PLATFORM_ANDROID then
		return CheckPermissionGranted(ANDROID_CAMERA_PERMISSION)
	elseif var0_8 == PLATFORM_IPHONEPLAYER then
		return PermissionMgr.Inst:GetIOSAVAuthStatus() == 3
	end
end

function ApplyCameraPermission()
	local var0_9 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

	if var0_9 == PLATFORM_ANDROID then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("apply_permission_camera_tip1"),
			onYes = function()
				ApplyPermission({
					ANDROID_CAMERA_PERMISSION
				})
			end
		})
	elseif var0_9 == PLATFORM_IPHONEPLAYER then
		PermissionMgr.Inst:ApplyIOSAVAuth()
	end
end
