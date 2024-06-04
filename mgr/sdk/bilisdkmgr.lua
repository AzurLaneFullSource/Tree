local var0 = {}
local var1 = BilibiliSdkMgr.inst
local var2 = "BLHX24V20210713"
local var3 = "FTBLHX20190524WW"

PACKAGE_TYPE_BILI = 1
PACKAGE_TYPE_SHAJOY = 2
PACKAGE_TYPE_UNION = 3
PACKAGE_TYPE_YYX = 4

function var0.CheckPretest()
	return NetConst.GATEWAY_HOST == "line1-test-login-ios-blhx.bilibiligame.net" and (NetConst.GATEWAY_PORT == 80 or NetConst.GATEWAY_PORT == 10080) or NetConst.GATEWAY_HOST == "line1-test-login-bili-blhx.bilibiligame.net" and (NetConst.GATEWAY_PORT == 80 or NetConst.GATEWAY_PORT == 10080) or IsUnityEditor
end

function var0.CheckWorldTest()
	return NetConst.GATEWAY_PORT == 10080 and NetConst.GATEWAY_HOST == "blhx-test-world-ios-game.bilibiligame.net"
end

function var0.InitSDK()
	if PLATFORM_CHT == PLATFORM_CODE then
		var1.sandboxKey = var3
	end

	var1:Init()
end

function var0.GoSDkLoginScene()
	var1:GoLoginScene()
end

function var0.LoginQQ()
	var1:Login(1)
end

function var0.LoginWX()
	var1:Login(2)
end

function var0.LoginSdk(arg0)
	if arg0 == 1 then
		var0.LoginQQ()
	elseif arg0 == 2 then
		var0.LoginWX()
	else
		var1:Login(0)
	end
end

function var0.TryLoginSdk()
	var1:TryLogin()
end

function var0.CreateRole(arg0, arg1, arg2, arg3, arg4)
	var1:CreateRole(arg0, arg1, arg2, 1000 * arg3, "vip0", arg4)
end

function var0.EnterServer(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	var1:EnterServer(arg0, arg1, arg2, arg3, arg4 * 1000, arg5, "vip0", arg6)
end

function var0.ChooseServer(arg0, arg1)
	var1:ChooseServer(arg0, arg1)
end

function var0.SdkGateWayLogined()
	var1:OnGatewayLogined()
end

function var0.SdkLoginGetaWayFailed()
	var1:OnLoginGatewayFailed()
end

function var0.SdkLevelUp()
	var1:LevelUp()
end

function var0.SdkPay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	var1:Pay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function var0.LogoutSDK(arg0)
	if arg0 ~= 0 and CSharpVersion >= 44 then
		var1:ClearLoginData()
	else
		var1:LocalLogout()
	end
end

function var0.BindCPU()
	return
end

function var0.DeleteAccount()
	if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_UNION then
		local var0 = getProxy(UserProxy):getRawData()
		local var1 = getProxy(ServerProxy):getRawData()[var0 and var0.server or 0]
		local var2 = var1 and var1.name or ""
		local var3 = getProxy(PlayerProxy):getRawData()
		local var4 = var3 and var3:GetName() or ""
		local var5 = var3 and tostring(var3.level) or "0"
		local var6 = var3 and var3:GetRegisterTime() or 0
		local var7 = pg.TimeMgr.GetInstance():STimeDescS(var6, "%Y/%m/%d")

		var1:DeleteAccountForUO(var4, var2, var5, var7)
	else
		var1:DeleteAccount()
	end
end

function var0.OnAndoridBackPress()
	local var0 = LuaHelper.GetCHPackageType()

	if var0 == PACKAGE_TYPE_BILI or var0 == PACKAGE_TYPE_SHAJOY then
		if not IsNil(pg.MsgboxMgr.GetInstance()._go) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("confirm_app_exit"),
				onYes = function()
					var1:onBackPressed()
				end
			})
		else
			var1:onBackPressed()
		end
	else
		var1:onBackPressed()
	end
end

function var0.ShowPrivate()
	local var0 = LuaHelper.GetCHPackageType()

	if var0 == PACKAGE_TYPE_UNION or IsUnityEditor then
		pg.UserAgreementMgr.GetInstance():ShowForBiliPrivate()
	elseif var0 == PACKAGE_TYPE_SHAJOY then
		Application.OpenURL("https://game.bilibili.com/uosdk_privacy/h5?game_id=209&privacyProtocol=1")
	elseif var0 == PACKAGE_TYPE_YYX then
		-- block empty
	else
		var1:ShowPrivate()
	end
end

function var0.ShowLicence()
	local var0 = LuaHelper.GetCHPackageType()

	if var0 == PACKAGE_TYPE_UNION or IsUnityEditor then
		pg.UserAgreementMgr.GetInstance():ShowForBiliLicence()
	elseif var0 == PACKAGE_TYPE_SHAJOY then
		Application.OpenURL("https://game.bilibili.com/uosdk_privacy/h5?game_id=209&userProtocol=1")
	elseif var0 == PACKAGE_TYPE_YYX then
		-- block empty
	else
		var1:ShowLicence()
	end
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

function var0.GameShare(arg0, arg1)
	var1:ShareWithImage("Azur Lane", arg0, arg1)
end

function var0.Service()
	local var0 = getProxy(PlayerProxy)

	if not var0 then
		return
	end

	local var1 = var0:getRawData()
	local var2 = var1.id
	local var3 = var1:GetName()
	local var4 = ""
	local var5 = ""
	local var6 = PLATFORM == PLATFORM_IPHONEPLAYER and "portrai" or "portrait"

	var1:Service(var2, var3, var4, var6)
end

function var0.Survey(arg0)
	var1:OpenWeb(arg0)
end

function var0.IsHuaweiPackage()
	return var1:isHuawei()
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

	if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_UNION then
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var0
		})
	else
		pg.m02:sendNotification(GAME.SERVER_INTERCOMMECTION, {
			user = var0
		})
	end
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

	if PLATFORM == PLATFORM_IPHONEPLAYER then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1))
	elseif arg1 == -5 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("订单签名异常" .. arg1))
	elseif arg1 > 0 then
		if arg1 > 1000 and arg1 < 2000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("数据格式验证错误" .. arg1))
		elseif arg1 >= 2000 and arg1 < 3000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("服务器返回异常" .. arg1))
		elseif arg1 >= 3000 and arg1 < 4000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("未登录或者会话已超时" .. arg1))
		elseif arg1 == 4000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("系统错误" .. arg1))
		elseif arg1 == 6001 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("用户中途取消" .. arg1))
		elseif arg1 == 7005 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1))
		elseif arg1 == 7004 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1))
		end
	elseif arg1 == -201 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("生成订单失败" .. arg1))
	elseif arg1 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付取消" .. arg1))
	elseif arg1 == -203 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1))
	end
end

function OnSDKInitFailed(arg0)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = arg0,
		onYes = var0.InitSDK
	})
end

function ShowMsgBox(arg0)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = arg0
	})
end

function OnShowLicenceFailed()
	return
end

function OnShowPrivateFailed()
	return
end

function OnShareSuccess()
	return
end

function OnShareFailed()
	return
end

function CloseAgreementView()
	return
end

function OnDeleteAccountSuccess()
	pg.m02:sendNotification(GAME.LOGOUT, {
		code = 0
	})
end

function OnDeleteAccountDisable()
	pg.TipsMgr.GetInstance():ShowTips("功能未开启")
end

function OnDeleteAccountFailed()
	pg.TipsMgr.GetInstance():ShowTips("注销失败")
end

return var0
