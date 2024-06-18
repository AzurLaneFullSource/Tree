local var0_0 = {}
local var1_0 = TxwyKrSdkMgr.inst

function var0_0.CheckPretest()
	return NetConst.GATEWAY_HOST == "bl-kr-test.xdg.com" and NetConst.GATEWAY_PORT == 30001 or IsUnityEditor
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
end

function var0_0.LoginSdk(arg0_3)
	var1_0:Login(0)
end

function var0_0.SdkGateWayLogined()
	var1_0:OnGatewayLogined()
end

function var0_0.SdkLoginGetaWayFailed()
	var1_0:OnLoginGatewayFailed()
end

function var0_0.LogoutSDK()
	var1_0:LocalLogout()
end

function var0_0.EnterServer(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7, arg6_7)
	var1_0:EnterServer(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7 * 1000, arg5_7, "vip0", arg6_7)
end

function var0_0.SdkLevelUp(arg0_8, arg1_8)
	var1_0:LevelUp(arg1_8, arg0_8)
end

function var0_0.UserCenter()
	local var0_9 = getProxy(PlayerProxy)
	local var1_9 = "未登入"

	if var0_9 then
		var1_9 = var0_9:getData().name
	end

	local var2_9 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES").CurrentVersion:ToString()

	var1_0:UserCenter(var1_9, var2_9, "1")
end

function var0_0.BugReport()
	local var0_10 = getProxy(UserProxy):getData()
	local var1_10 = getProxy(ServerProxy):getLastServer(var0_10.uid)
	local var2_10 = getProxy(PlayerProxy)
	local var3_10 = ""

	if var2_10 then
		var3_10 = var2_10:getData().name
	end

	local var4_10 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES").CurrentVersion:ToString()

	var1_0:BugReport(var3_10, var4_10, var1_10.id)
end

function var0_0.StoreReview()
	var1_0:StoreReview()
end

function var0_0.ShareImg(arg0_12, arg1_12)
	var1_0:ShareImg(arg0_12, arg1_12)
end

function var0_0.CompletedTutorial()
	var1_0:CompletedTutorial()
end

function var0_0.UnlockAchievement()
	var1_0:UnlockAchievement()
end

function var0_0.QueryWithProduct()
	local function var0_15()
		local var0_16 = ""

		for iter0_16, iter1_16 in ipairs(pg.pay_data_display.all) do
			local var1_16 = pg.pay_data_display[iter1_16]

			var0_16 = var0_16 .. var1_16.id_str .. ";"
		end

		return var0_16
	end

	local function var1_15(arg0_17, arg1_17)
		for iter0_17, iter1_17 in ipairs(pg.pay_data_display.all) do
			local var0_17 = pg.pay_data_display[iter1_17]

			if var0_17.id_str == arg0_17 and var0_17.money ~= arg1_17 then
				originalPrint(string.format("<color=#ff0000>%s的商品价格和本地的价格不同</color> 本地价格：%s, 服务器价格：%s", var0_17.name, var0_17.money, arg1_17))
			end
		end
	end

	var1_0:QueryWithProduct(var0_15(), function(arg0_18)
		local var0_18 = string.split(arg0_18, ";")

		for iter0_18, iter1_18 in ipairs(var0_18) do
			local var1_18 = string.split(iter1_18, "|")
			local var2_18 = var1_18[1]
			local var3_18 = var1_18[2]

			var1_15(var2_18, var3_18)
		end
	end)
end

function var0_0.SdkPay(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19, arg7_19, arg8_19, arg9_19)
	local var0_19 = getProxy(PlayerProxy):getRawData().level

	var1_0:Pay(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19, arg7_19, var0_19)
end

function var0_0.BindCPU()
	var1_0:callSdkApi("bindCpu", nil)
end

function var0_0.SwitchAccount()
	var1_0:SwitchAccount()
end

function var0_0.GetBiliServerId()
	local var0_22 = var1_0.serverId

	originalPrint("serverId : " .. var0_22)

	return var0_22
end

function var0_0.GetChannelUID()
	local var0_23 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_23)

	return var0_23
end

function var0_0.GetLoginType()
	return var1_0.loginType
end

function var0_0.GetIsPlatform()
	return var1_0.isPlatform
end

function var0_0.GetDeviceModel()
	return var1_0:GetDeviceModel()
end

function var0_0.OnAndoridBackPress()
	PressBack()
end

function GoLoginScene()
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LOGIN)
	gcAll()
end

function SDKLogined(arg0_29, arg1_29, arg2_29, arg3_29)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0_29 = User.New({
		type = 1,
		arg1 = arg0_29,
		arg2 = arg1_29,
		arg3 = arg2_29,
		arg4 = arg3_29
	})

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = var0_29
	})
end

function SDKLogouted(arg0_30)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0_30
	})
end

function PaySuccess(arg0_31, arg1_31)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
end

function PayFailed(arg0_32, arg1_32)
	getProxy(ShopsProxy):removeWaitTimer()

	arg1_32 = tonumber(arg1_32)

	if not arg1_32 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0_32,
		code = arg1_32
	})

	if arg1_32 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pay_cancel") .. arg1_32)
	end
end

return var0_0
