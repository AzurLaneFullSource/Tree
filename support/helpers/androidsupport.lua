PERMISSION_GRANTED = "permission_granted"
PERMISSION_NEVER_REMIND = "permission_never_remind"
PERMISSION_REJECT = "permission_reject"
ANDROID_CAMERA_PERMISSION = "android.permission.CAMERA"
ANDROID_RECORD_AUDIO_PERMISSION = "android.permission.RECORD_AUDIO"
ANDROID_WRITE_EXTERNAL_PERMISSION = "android.permission.WRITE_EXTERNAL_STORAGE"

function CheckPermissionGranted(arg0)
	return PermissionMgr.Inst:CheckPermissionGranted(arg0)
end

function ApplyPermission(arg0)
	PermissionMgr.Inst:ApplyPermission(arg0)
end

function OpenDetailSetting()
	PermissionMgr.Inst:OpenDetailSetting()
end

function OnPermissionRequestResult(arg0)
	pg.m02:sendNotification(PERMISSION_GRANTED, arg0)
end

function OnPermissionNeverRemind(arg0)
	pg.m02:sendNotification(PERMISSION_NEVER_REMIND, arg0)
end

function OnPermissionReject(arg0)
	pg.m02:sendNotification(PERMISSION_REJECT, arg0)
end
