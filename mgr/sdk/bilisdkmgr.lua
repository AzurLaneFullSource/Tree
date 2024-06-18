local var0_0 = {}
local var1_0 = BilibiliSdkMgr.inst
local var2_0 = "BLHX24V20210713"
local var3_0 = "FTBLHX20190524WW"

PACKAGE_TYPE_BILI = 1
PACKAGE_TYPE_SHAJOY = 2
PACKAGE_TYPE_UNION = 3
PACKAGE_TYPE_YYX = 4

function var0_0.CheckPretest()
	return NetConst.GATEWAY_HOST == "line1-test-login-ios-blhx.bilibiligame.net" and (NetConst.GATEWAY_PORT == 80 or NetConst.GATEWAY_PORT == 10080) or NetConst.GATEWAY_HOST == "line1-test-login-bili-blhx.bilibiligame.net" and (NetConst.GATEWAY_PORT == 80 or NetConst.GATEWAY_PORT == 10080) or IsUnityEditor
end

function var0_0.CheckWorldTest()
	return NetConst.GATEWAY_PORT == 10080 and NetConst.GATEWAY_HOST == "blhx-test-world-ios-game.bilibiligame.net"
end

function var0_0.InitSDK()
	if PLATFORM_CHT == PLATFORM_CODE then
		var1_0.sandboxKey = var3_0
	end

	var1_0:Init()
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
end

function var0_0.LoginQQ()
	var1_0:Login(1)
end

function var0_0.LoginWX()
	var1_0:Login(2)
end

function var0_0.LoginSdk(arg0_7)
	if arg0_7 == 1 then
		var0_0.LoginQQ()
	elseif arg0_7 == 2 then
		var0_0.LoginWX()
	else
		var1_0:Login(0)
	end
end

function var0_0.TryLoginSdk()
	var1_0:TryLogin()
end

function var0_0.CreateRole(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	var1_0:CreateRole(arg0_9, arg1_9, arg2_9, 1000 * arg3_9, "vip0", arg4_9)
end

function var0_0.EnterServer(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
	var1_0:EnterServer(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10 * 1000, arg5_10, "vip0", arg6_10)
end

function var0_0.ChooseServer(arg0_11, arg1_11)
	var1_0:ChooseServer(arg0_11, arg1_11)
end

function var0_0.SdkGateWayLogined()
	var1_0:OnGatewayLogined()
end

function var0_0.SdkLoginGetaWayFailed()
	var1_0:OnLoginGatewayFailed()
end

function var0_0.SdkLevelUp()
	var1_0:LevelUp()
end

function var0_0.SdkPay(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15, arg7_15, arg8_15, arg9_15)
	var1_0:Pay(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15, arg7_15, arg8_15, arg9_15)
end

function var0_0.LogoutSDK(arg0_16)
	if arg0_16 ~= 0 and CSharpVersion >= 44 then
		var1_0:ClearLoginData()
	else
		var1_0:LocalLogout()
	end
end

function var0_0.BindCPU()
	return
end

function var0_0.DeleteAccount()
	if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_UNION then
		local var0_18 = getProxy(UserProxy):getRawData()
		local var1_18 = getProxy(ServerProxy):getRawData()[var0_18 and var0_18.server or 0]
		local var2_18 = var1_18 and var1_18.name or ""
		local var3_18 = getProxy(PlayerProxy):getRawData()
		local var4_18 = var3_18 and var3_18:GetName() or ""
		local var5_18 = var3_18 and tostring(var3_18.level) or "0"
		local var6_18 = var3_18 and var3_18:GetRegisterTime() or 0
		local var7_18 = pg.TimeMgr.GetInstance():STimeDescS(var6_18, "%Y/%m/%d")

		var1_0:DeleteAccountForUO(var4_18, var2_18, var5_18, var7_18)
	else
		var1_0:DeleteAccount()
	end
end

function var0_0.OnAndoridBackPress()
	local var0_19 = LuaHelper.GetCHPackageType()

	if var0_19 == PACKAGE_TYPE_BILI or var0_19 == PACKAGE_TYPE_SHAJOY then
		if not IsNil(pg.MsgboxMgr.GetInstance()._go) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("confirm_app_exit"),
				onYes = function()
					var1_0:onBackPressed()
				end
			})
		else
			var1_0:onBackPressed()
		end
	else
		var1_0:onBackPressed()
	end
end

function var0_0.ShowPrivate()
	local var0_21 = LuaHelper.GetCHPackageType()

	if var0_21 == PACKAGE_TYPE_UNION or IsUnityEditor then
		pg.UserAgreementMgr.GetInstance():ShowForBiliPrivate()
	elseif var0_21 == PACKAGE_TYPE_SHAJOY then
		Application.OpenURL("https://game.bilibili.com/uosdk_privacy/h5?game_id=209&privacyProtocol=1")
	elseif var0_21 == PACKAGE_TYPE_YYX then
		-- block empty
	else
		var1_0:ShowPrivate()
	end
end

function var0_0.ShowLicence()
	local var0_22 = LuaHelper.GetCHPackageType()

	if var0_22 == PACKAGE_TYPE_UNION or IsUnityEditor then
		pg.UserAgreementMgr.GetInstance():ShowForBiliLicence()
	elseif var0_22 == PACKAGE_TYPE_SHAJOY then
		Application.OpenURL("https://game.bilibili.com/uosdk_privacy/h5?game_id=209&userProtocol=1")
	elseif var0_22 == PACKAGE_TYPE_YYX then
		-- block empty
	else
		var1_0:ShowLicence()
	end
end

function var0_0.GetBiliServerId()
	local var0_23 = var1_0.serverId

	originalPrint("serverId : " .. var0_23)

	return var0_23
end

function var0_0.GetChannelUID()
	local var0_24 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_24)

	return var0_24
end

function var0_0.GetLoginType()
	return var1_0.loginType
end

function var0_0.GetIsPlatform()
	return var1_0.isPlatform
end

function var0_0.GameShare(arg0_27, arg1_27)
	var1_0:ShareWithImage("Azur Lane", arg0_27, arg1_27)
end

function var0_0.Service()
	local var0_28 = getProxy(PlayerProxy)

	if not var0_28 then
		return
	end

	local var1_28 = var0_28:getRawData()
	local var2_28 = var1_28.id
	local var3_28 = var1_28:GetName()
	local var4_28 = ""
	local var5_28 = ""
	local var6_28 = PLATFORM == PLATFORM_IPHONEPLAYER and "portrai" or "portrait"

	var1_0:Service(var2_28, var3_28, var4_28, var6_28)
end

function var0_0.Survey(arg0_29)
	var1_0:OpenWeb(arg0_29)
end

function var0_0.IsHuaweiPackage()
	return var1_0:isHuawei()
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

function SDKLogined(arg0_34, arg1_34, arg2_34, arg3_34)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0_34 = User.New({
		type = 1,
		arg1 = arg0_34,
		arg2 = arg1_34,
		arg3 = arg2_34,
		arg4 = arg3_34
	})

	if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_UNION then
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var0_34
		})
	else
		pg.m02:sendNotification(GAME.SERVER_INTERCOMMECTION, {
			user = var0_34
		})
	end
end

function SDKLogouted(arg0_35)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0_35
	})
end

function PaySuccess(arg0_36, arg1_36)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
	pg.m02:sendNotification(GAME.CHARGE_CONFIRM, {
		payId = arg0_36,
		bsId = arg1_36
	})
end

function PayFailed(arg0_37, arg1_37)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()

	arg1_37 = tonumber(arg1_37)

	if not arg1_37 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0_37,
		code = arg1_37
	})

	if PLATFORM == PLATFORM_IPHONEPLAYER then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1_37))
	elseif arg1_37 == -5 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("订单签名异常" .. arg1_37))
	elseif arg1_37 > 0 then
		if arg1_37 > 1000 and arg1_37 < 2000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("数据格式验证错误" .. arg1_37))
		elseif arg1_37 >= 2000 and arg1_37 < 3000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("服务器返回异常" .. arg1_37))
		elseif arg1_37 >= 3000 and arg1_37 < 4000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("未登录或者会话已超时" .. arg1_37))
		elseif arg1_37 == 4000 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("系统错误" .. arg1_37))
		elseif arg1_37 == 6001 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("用户中途取消" .. arg1_37))
		elseif arg1_37 == 7005 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1_37))
		elseif arg1_37 == 7004 then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1_37))
		end
	elseif arg1_37 == -201 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("生成订单失败" .. arg1_37))
	elseif arg1_37 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付取消" .. arg1_37))
	elseif arg1_37 == -203 then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("支付失败" .. arg1_37))
	end
end

function OnSDKInitFailed(arg0_38)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = arg0_38,
		onYes = var0_0.InitSDK
	})
end

function ShowMsgBox(arg0_39)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		content = arg0_39
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

return var0_0
