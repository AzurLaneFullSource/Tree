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
