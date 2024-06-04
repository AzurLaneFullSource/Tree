local var0 = {}
local var1 = TxwyKrSdkMgr.inst

function var0.CheckPretest()
	return NetConst.GATEWAY_HOST == "bl-kr-test.xdg.com" and NetConst.GATEWAY_PORT == 30001 or IsUnityEditor
end

function var0.GoSDkLoginScene()
	var1:GoLoginScene()
end

function var0.LoginSdk(arg0)
	var1:Login(0)
end

function var0.SdkGateWayLogined()
	var1:OnGatewayLogined()
end

function var0.SdkLoginGetaWayFailed()
	var1:OnLoginGatewayFailed()
end

function var0.LogoutSDK()
	var1:LocalLogout()
end

function var0.EnterServer(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	var1:EnterServer(arg0, arg1, arg2, arg3, arg4 * 1000, arg5, "vip0", arg6)
end

function var0.SdkLevelUp(arg0, arg1)
	var1:LevelUp(arg1, arg0)
end

function var0.UserCenter()
	local var0 = getProxy(PlayerProxy)
	local var1 = "未登入"

	if var0 then
		var1 = var0:getData().name
	end

	local var2 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES").CurrentVersion:ToString()

	var1:UserCenter(var1, var2, "1")
end

function var0.BugReport()
	local var0 = getProxy(UserProxy):getData()
	local var1 = getProxy(ServerProxy):getLastServer(var0.uid)
	local var2 = getProxy(PlayerProxy)
	local var3 = ""

	if var2 then
		var3 = var2:getData().name
	end

	local var4 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES").CurrentVersion:ToString()

	var1:BugReport(var3, var4, var1.id)
end

function var0.StoreReview()
	var1:StoreReview()
end

function var0.ShareImg(arg0, arg1)
	var1:ShareImg(arg0, arg1)
end

function var0.CompletedTutorial()
	var1:CompletedTutorial()
end

function var0.UnlockAchievement()
	var1:UnlockAchievement()
end

function var0.QueryWithProduct()
	local function var0()
		local var0 = ""

		for iter0, iter1 in ipairs(pg.pay_data_display.all) do
			local var1 = pg.pay_data_display[iter1]

			var0 = var0 .. var1.id_str .. ";"
		end

		return var0
	end

	local function var1(arg0, arg1)
		for iter0, iter1 in ipairs(pg.pay_data_display.all) do
			local var0 = pg.pay_data_display[iter1]

			if var0.id_str == arg0 and var0.money ~= arg1 then
				originalPrint(string.format("<color=#ff0000>%s的商品价格和本地的价格不同</color> 本地价格：%s, 服务器价格：%s", var0.name, var0.money, arg1))
			end
		end
	end

	var1:QueryWithProduct(var0(), function(arg0)
		local var0 = string.split(arg0, ";")

		for iter0, iter1 in ipairs(var0) do
			local var1 = string.split(iter1, "|")
			local var2 = var1[1]
			local var3 = var1[2]

			var1(var2, var3)
		end
	end)
end

function var0.SdkPay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local var0 = getProxy(PlayerProxy):getRawData().level

	var1:Pay(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, var0)
end

function var0.BindCPU()
	var1:callSdkApi("bindCpu", nil)
end

function var0.SwitchAccount()
	var1:SwitchAccount()
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

function var0.GetDeviceModel()
	return var1:GetDeviceModel()
end

function var0.OnAndoridBackPress()
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
end

function PayFailed(arg0, arg1)
	getProxy(ShopsProxy):removeWaitTimer()

	arg1 = tonumber(arg1)

	if not arg1 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0,
		code = arg1
	})

	if arg1 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pay_cancel") .. arg1)
	end
end

return var0
