local var0_0 = {}
local var1_0 = TxwyKrSdkMgr.inst

function var0_0.CheckPretest()
	return NetConst.GATEWAY_HOST == "bl-kr-test.xdg.com" and NetConst.GATEWAY_PORT == 30001 or IsUnityEditor
end

function var0_0.GetPNInfo()
	local var0_2 = "null"
	local var1_2 = "null"
	local var2_2 = "not logged in"
	local var3_2 = getProxy(PlayerProxy)

	if var3_2 then
		var0_2 = var3_2:getData().id
		var1_2 = var3_2:getData().level
		var2_2 = var3_2:getData().name
	end

	local var4_2 = "none"
	local var5_2 = getProxy(UserProxy):getData()

	if var5_2 then
		var4_2 = getProxy(ServerProxy):getLastServer(var5_2.uid).id
	end

	local var6_2 = PNInfo.New(var0_2, var1_2)

	return {
		info = PNInfo.New(var0_2, var1_2),
		playerID = var0_2,
		playerName = var2_2,
		playerLevel = var1_2,
		serverID = var4_2
	}
end

function var0_0.GetClientVer()
	return (BundleWizard.Inst:GetGroupMgr(GroupMainHelper.DefaultGroupName).CurrentVersion:ToString())
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
end

function var0_0.LoginSdk(arg0_5)
	var1_0:Login()
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

function var0_0.EnterServer(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
	return
end

function var0_0.SdkLevelUp(arg0_10, arg1_10)
	return
end

function var0_0.UserCenter()
	local var0_11 = var0_0.GetPNInfo()
	local var1_11 = var0_0.GetClientVer()

	var1_0:UserCenter(var0_11.playerName, var1_11, var0_11.serverID, var0_11.info)
end

function var0_0.BugReport()
	local var0_12 = var0_0.GetPNInfo()
	local var1_12 = var0_0.GetClientVer()

	var1_0:BugReport(var0_12.playerName, var1_12, var0_12.serverID, var0_12.info)
end

function var0_0.StoreReview()
	if var0_0.GetIsPlatform() then
		local var0_13 = var0_0.GetPNInfo()
		local var1_13 = var0_0.GetClientVer()

		var1_0:StoreReview(var0_13.playerName, var1_13, var0_13.serverID, var0_13.info)
	end
end

function var0_0.ShareImg(arg0_14)
	var1_0:ShareImg(arg0_14, "")
end

function var0_0.CompletedTutorial()
	return
end

function var0_0.UnlockAchievement()
	return
end

function var0_0.OnAndoridBackPress()
	PressBack()
end

function var0_0.QueryWithProduct()
	return
end

function var0_0.SdkPay(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19, arg7_19, arg8_19, arg9_19)
	local var0_19 = var0_0.GetPNInfo()
	local var1_19 = var0_19.serverID .. "-" .. var0_19.playerID .. "-" .. arg4_19

	originalPrint("SdkPay nonce", tostring(var1_19))
	var1_0:Pay(arg0_19, var1_19, var0_19.info)
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

function var0_0.Survey(arg0_33)
	Application.OpenURL(arg0_33)
end

function OnQueryProductsSucess(arg0_34)
	local function var0_34(arg0_35, arg1_35)
		for iter0_35, iter1_35 in ipairs(pg.pay_data_display.all) do
			local var0_35 = pg.pay_data_display[iter1_35]

			if var0_35.id_str == arg0_35 and var0_35.money ~= arg1_35 then
				-- block empty
			end
		end
	end

	local var1_34 = arg0_34.Count

	for iter0_34 = 0, var1_34 - 1 do
		local var2_34 = arg0_34[iter0_34]
		local var3_34 = var2_34.ProductID
		local var4_34 = var2_34.Price

		var0_34(var3_34, var4_34)
	end
end

function OnAdRewards(arg0_36)
	return
end

function OnQuerySubscriptionSuccess(arg0_37)
	return
end

function OnRequestPayment(arg0_38)
	return
end

function OnQuerySuccess(arg0_39, arg1_39)
	return
end

return var0_0
