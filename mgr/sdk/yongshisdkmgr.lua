local var0_0 = {}
local var1_0 = YongshiSdkMgr.inst
local var2_0 = "com.hkmanjuu.azurlane.gp.mc"
local var3_0 = "com.hkmanjuu.azurlane.gp"
local var4_0 = "com.hkmanjuu.azurlane.ios1"

function var0_0.CheckPretest()
	return NetConst.GATEWAY_HOST == "ts-all-login.azurlane.tw" and (NetConst.GATEWAY_PORT == 11001 or NetConst.GATEWAY_PORT == 11101) or IsUnityEditor
end

function var0_0.InitSDK()
	var1_0:Init()
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
end

function var0_0.LoginSdk(arg0_4)
	var1_0:Login(0)
end

function var0_0.TryLoginSdk()
	var1_0:TryLogin()
end

function var0_0.SdkGateWayLogined()
	var1_0:OnGatewayLogined()
end

function var0_0.SdkLoginGetaWayFailed()
	var1_0:OnLoginGatewayFailed()
end

function var0_0.IsBindApple()
	return var1_0.bindInfo:IsBindApple()
end

function var0_0.IsBindFaceBook()
	return var1_0.bindInfo:IsBindFaceBook()
end

function var0_0.IsBindGoogle()
	return var1_0.bindInfo:IsBindGoogle()
end

function var0_0.IsBindPhone()
	return var1_0.bindInfo:IsBindPhone()
end

function var0_0.BindApple()
	var1_0:BindApple()
end

function var0_0.BindFaceBook()
	var1_0:BindFaceBook()
end

function var0_0.BindGoogle()
	var1_0:BindGoogle()
end

function var0_0.BindPhone()
	var1_0:BindPhone()
end

function var0_0.UnBindPhone()
	var1_0:UnBindPhone()
end

function var0_0.UnBindApple()
	var1_0:UnBindApple()
end

function var0_0.UnBindFaceBook()
	var1_0:UnBindFaceBook()
end

function var0_0.UnBindGoogle()
	var1_0:UnBindGoogle()
end

function var0_0.CanTriggerDeepLinking()
	return var1_0:CanTriggerDeepLinking()
end

function var0_0.TriggerDeepLinking()
	var1_0:TriggerDeepLinking()
end

function var0_0.SdkPay(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22, arg6_22, arg7_22, arg8_22, arg9_22)
	local var0_22 = getProxy(UserProxy):getData().uid
	local var1_22 = getProxy(ServerProxy):getLastServer(var0_22)
	local var2_22 = var1_22.id
	local var3_22 = var1_22.name
	local var4_22 = getProxy(PlayerProxy):getRawData()
	local var5_22 = var4_22.id
	local var6_22 = var4_22.name
	local var7_22 = var4_22.level

	var1_0:Pay(arg0_22, arg2_22, arg5_22, arg1_22, "1", arg3_22, "1", var2_22, var3_22, var2_22, var5_22, var6_22, var7_22, arg8_22, "1", arg4_22, arg6_22, arg9_22)
end

function var0_0.UserEventUpload(arg0_23)
	var1_0:UserEventUpload(arg0_23)
end

function var0_0.LogoutSDK()
	var1_0:LocalLogout()
end

function var0_0.BindCPU()
	var1_0:callSdkApi("bindCpu", nil)
end

function var0_0.DeleteAccount()
	var1_0:Delete()
end

function var0_0.OnAndoridBackPress()
	PressBack()
end

function var0_0.ShareImg(arg0_28, arg1_28)
	var1_0:Share(arg0_28)
end

function var0_0.GetBiliServerId()
	local var0_29 = var1_0.serverId

	originalPrint("serverId : " .. var0_29)

	return var0_29
end

function var0_0.GetChannelUID()
	local var0_30 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_30)

	return var0_30
end

function var0_0.GetLoginType()
	return var1_0.loginType
end

function var0_0.GetIsPlatform()
	return var1_0.isPlatform
end

function var0_0.GetPackageCode(arg0_33)
	if arg0_33 == var2_0 then
		return "2"
	elseif arg0_33 == var3_0 then
		return "1"
	elseif arg0_33 == var4_0 then
		return "3"
	end

	return "0"
end

function var0_0.QueryWithProduct()
	if var2_0 == Application.identifier then
		return
	end

	local var0_34 = {}
	local var1_34 = pg.pay_data_display

	for iter0_34, iter1_34 in pairs(var1_34.all) do
		local var2_34 = var1_34[iter1_34]

		table.insert(var0_34, var2_34.id_str)
	end

	var1_0:Query(var0_34)
end

function var0_0.GetProduct(arg0_35)
	return var1_0:GetProduct(arg0_35)
end

function StartSdkLogin()
	Timer.New(function()
		var1_0:OnLoginTimeOut()
	end, 30, 1):Start()
end

function GoLoginScene()
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN)
	gcAll()
end

function SDKLogined(arg0_39, arg1_39, arg2_39, arg3_39)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0_39 = User.New({
		type = 1,
		arg1 = arg0_39,
		arg2 = arg1_39,
		arg3 = arg2_39,
		arg4 = arg3_39
	})

	pg.SdkMgr.GetInstance().airi_uid = arg1_39 or "test"

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = var0_39
	})
end

function SDKLogouted(arg0_40)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0_40
	})
end

function PaySuccess(arg0_41, arg1_41)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
	originalPrint(arg0_41 + " - " + arg1_41)
	pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
		payId = arg0_41,
		bsId = arg1_41
	})
end

function PayFailed(arg0_42, arg1_42)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()

	arg1_42 = tonumber(arg1_42)

	if not arg1_42 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0_42,
		code = arg1_42
	})
end

function GetUserInfoSuccess()
	return
end

function GetUserInfoFailed()
	return
end

local function var5_0(arg0_45, arg1_45, arg2_45)
	if arg0_45 == YongshiSdkUserBindInfo.FACEBOOK then
		pg.TipsMgr.GetInstance():ShowTips(arg1_45 .. "facebook" .. arg2_45)
	elseif arg0_45 == YongshiSdkUserBindInfo.APPLE then
		pg.TipsMgr.GetInstance():ShowTips(arg1_45 .. "Apple Id" .. arg2_45)
	elseif arg0_45 == YongshiSdkUserBindInfo.GOOGLE then
		pg.TipsMgr.GetInstance():ShowTips(arg1_45 .. "google" .. arg2_45)
	elseif arg0_45 == YongshiSdkUserBindInfo.PHONE then
		if arg1_45 == "解綁" then
			arg1_45 = "换绑"
		end

		pg.TipsMgr.GetInstance():ShowTips(arg1_45 .. "手機" .. arg2_45)
	else
		print("this platform is not supported")
	end
end

function BindSuccess(arg0_46)
	var5_0(arg0_46, "綁定", "成功")
	pg.m02:sendNotification(GAME.CHT_SOCIAL_LINK_STATE_CHANGE, arg0_46)
end

function BindFailed(arg0_47, arg1_47)
	if arg1_47 and arg1_47 ~= "" then
		pg.TipsMgr.GetInstance():ShowTips(arg1_47)
	else
		var5_0(arg0_47, "綁定", "失敗")
	end
end

function UnBindSuccess(arg0_48)
	var5_0(arg0_48, "解綁", "成功")
	pg.m02:sendNotification(GAME.CHT_SOCIAL_LINK_STATE_CHANGE)
end

function UnBindFailed(arg0_49, arg1_49)
	if arg1_49 and arg1_49 ~= "" then
		pg.TipsMgr.GetInstance():ShowTips(arg1_49)
	else
		var5_0(arg0_49, "解綁", "失敗")
	end
end

function OnDeepLinking(arg0_50)
	pg.YongshiDeepLinkingMgr.GetInstance():SetData(arg0_50)
end

return var0_0
