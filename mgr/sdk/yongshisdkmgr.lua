local var0 = {}
local var1 = YongshiSdkMgr.inst
local var2 = "com.hkmanjuu.azurlane.gp.mc"
local var3 = "com.hkmanjuu.azurlane.gp"
local var4 = "com.hkmanjuu.azurlane.ios1"

function var0.CheckPretest()
	return NetConst.GATEWAY_HOST == "ts-all-login.azurlane.tw" and (NetConst.GATEWAY_PORT == 11001 or NetConst.GATEWAY_PORT == 11101) or IsUnityEditor
end

function var0.InitSDK()
	var1:Init()
end

function var0.GoSDkLoginScene()
	var1:GoLoginScene()
end

function var0.LoginSdk(arg0)
	var1:Login(0)
end

function var0.TryLoginSdk()
	var1:TryLogin()
end

function var0.SdkGateWayLogined()
	var1:OnGatewayLogined()
end

function var0.SdkLoginGetaWayFailed()
	var1:OnLoginGatewayFailed()
end

function var0.IsBindApple()
	return var1.bindInfo:IsBindApple()
end

function var0.IsBindFaceBook()
	return var1.bindInfo:IsBindFaceBook()
end

function var0.IsBindGoogle()
	return var1.bindInfo:IsBindGoogle()
end

function var0.IsBindPhone()
	return var1.bindInfo:IsBindPhone()
end

function var0.BindApple()
	var1:BindApple()
end

function var0.BindFaceBook()
	var1:BindFaceBook()
end

function var0.BindGoogle()
	var1:BindGoogle()
end

function var0.BindPhone()
	var1:BindPhone()
end

function var0.UnBindPhone()
	var1:UnBindPhone()
end

function var0.UnBindApple()
	var1:UnBindApple()
end

function var0.UnBindFaceBook()
	var1:UnBindFaceBook()
end

function var0.UnBindGoogle()
	var1:UnBindGoogle()
end

function var0.CanTriggerDeepLinking()
	return var1:CanTriggerDeepLinking()
end

function var0.TriggerDeepLinking()
	var1:TriggerDeepLinking()
end

function var0.SdkPay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local var0 = getProxy(UserProxy):getData().uid
	local var1 = getProxy(ServerProxy):getLastServer(var0)
	local var2 = var1.id
	local var3 = var1.name
	local var4 = getProxy(PlayerProxy):getRawData()
	local var5 = var4.id
	local var6 = var4.name
	local var7 = var4.level

	var1:Pay(arg0, arg2, arg5, arg1, "1", arg3, "1", var2, var3, var2, var5, var6, var7, arg8, "1", arg4, arg6, arg9)
end

function var0.UserEventUpload(arg0)
	var1:UserEventUpload(arg0)
end

function var0.LogoutSDK()
	var1:LocalLogout()
end

function var0.BindCPU()
	var1:callSdkApi("bindCpu", nil)
end

function var0.DeleteAccount()
	var1:Delete()
end

function var0.OnAndoridBackPress()
	PressBack()
end

function var0.ShareImg(arg0, arg1)
	var1:Share(arg0)
end

function var0.GetBiliServerId()
	local var0 = var1.serverId

	originalPrint("serverId : " .. var0)

	return var0
end

function var0.GetChannelUID()
	local var0 = var1.channelUID

	originalPrint("channelUID : " .. var0)

	return var0
end

function var0.GetLoginType()
	return var1.loginType
end

function var0.GetIsPlatform()
	return var1.isPlatform
end

function var0.GetPackageCode(arg0)
	if arg0 == var2 then
		return "2"
	elseif arg0 == var3 then
		return "1"
	elseif arg0 == var4 then
		return "3"
	end

	return "0"
end

function var0.QueryWithProduct()
	if var2 == Application.identifier then
		return
	end

	local var0 = {}
	local var1 = pg.pay_data_display

	for iter0, iter1 in pairs(var1.all) do
		local var2 = var1[iter1]

		table.insert(var0, var2.id_str)
	end

	var1:Query(var0)
end

function var0.GetProduct(arg0)
	return var1:GetProduct(arg0)
end

function StartSdkLogin()
	Timer.New(function()
		var1:OnLoginTimeOut()
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

function SDKLogined(arg0, arg1, arg2, arg3)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0 = User.New({
		type = 1,
		arg1 = arg0,
		arg2 = arg1,
		arg3 = arg2,
		arg4 = arg3
	})

	pg.SdkMgr.GetInstance().airi_uid = arg1 or "test"

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = var0
	})
end

function SDKLogouted(arg0)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0
	})
end

function PaySuccess(arg0, arg1)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
	originalPrint(arg0 + " - " + arg1)
	pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
		payId = arg0,
		bsId = arg1
	})
end

function PayFailed(arg0, arg1)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()

	arg1 = tonumber(arg1)

	if not arg1 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0,
		code = arg1
	})
end

function GetUserInfoSuccess()
	return
end

function GetUserInfoFailed()
	return
end

local function var5(arg0, arg1, arg2)
	if arg0 == YongshiSdkUserBindInfo.FACEBOOK then
		pg.TipsMgr.GetInstance():ShowTips(arg1 .. "facebook" .. arg2)
	elseif arg0 == YongshiSdkUserBindInfo.APPLE then
		pg.TipsMgr.GetInstance():ShowTips(arg1 .. "Apple Id" .. arg2)
	elseif arg0 == YongshiSdkUserBindInfo.GOOGLE then
		pg.TipsMgr.GetInstance():ShowTips(arg1 .. "google" .. arg2)
	elseif arg0 == YongshiSdkUserBindInfo.PHONE then
		if arg1 == "解綁" then
			arg1 = "换绑"
		end

		pg.TipsMgr.GetInstance():ShowTips(arg1 .. "手機" .. arg2)
	else
		print("this platform is not supported")
	end
end

function BindSuccess(arg0)
	var5(arg0, "綁定", "成功")
	pg.m02:sendNotification(GAME.CHT_SOCIAL_LINK_STATE_CHANGE, arg0)
end

function BindFailed(arg0, arg1)
	if arg1 and arg1 ~= "" then
		pg.TipsMgr.GetInstance():ShowTips(arg1)
	else
		var5(arg0, "綁定", "失敗")
	end
end

function UnBindSuccess(arg0)
	var5(arg0, "解綁", "成功")
	pg.m02:sendNotification(GAME.CHT_SOCIAL_LINK_STATE_CHANGE)
end

function UnBindFailed(arg0, arg1)
	if arg1 and arg1 ~= "" then
		pg.TipsMgr.GetInstance():ShowTips(arg1)
	else
		var5(arg0, "解綁", "失敗")
	end
end

function OnDeepLinking(arg0)
	pg.YongshiDeepLinkingMgr.GetInstance():SetData(arg0)
end

return var0
