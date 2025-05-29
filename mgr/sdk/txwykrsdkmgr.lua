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
	local var0_13 = var0_0.GetPNInfo()
	local var1_13 = var0_0.GetClientVer()

	var1_0:StoreReview(var0_13.playerName, var1_13, var0_13.serverID, var0_13.info)
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

function var0_0.QueryPendingTransaction()
	if var0_0.GetIsPlatform() then
		var1_0:SDK_QueryPendingTransaction()
	end
end

function var0_0.SdkPay(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20, arg5_20, arg6_20, arg7_20, arg8_20, arg9_20)
	local var0_20 = var0_0.GetPNInfo()
	local var1_20 = var0_20.serverID .. "-" .. var0_20.playerID .. "-" .. arg4_20

	originalPrint("SdkPay nonce", tostring(var1_20))
	var1_0:Pay(arg0_20, var1_20, var0_20.info)
end

function var0_0.BindCPU()
	var1_0:callSdkApi("bindCpu", nil)
end

function var0_0.SwitchAccount()
	var1_0:SwitchAccount()
end

function var0_0.EventTrack(arg0_23)
	var1_0:SDK_EvtTrack(arg0_23)
end

function var0_0.GetBiliServerId()
	local var0_24 = var1_0.serverId

	originalPrint("serverId : " .. var0_24)

	return var0_24
end

function var0_0.GetChannelUID()
	local var0_25 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_25)

	return var0_25
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

function SDKLogined(arg0_31, arg1_31, arg2_31, arg3_31)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0_31 = User.New({
		type = 1,
		arg1 = arg0_31,
		arg2 = arg1_31,
		arg3 = arg2_31,
		arg4 = arg3_31
	})

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = var0_31
	})
end

function SDKLogouted(arg0_32)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0_32
	})
end

function PaySuccess(arg0_33, arg1_33)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
end

function PayFailed(arg0_34, arg1_34)
	getProxy(ShopsProxy):removeWaitTimer()

	arg1_34 = tonumber(arg1_34)

	if not arg1_34 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0_34,
		code = arg1_34
	})

	if arg1_34 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pay_cancel") .. arg1_34)
	end
end

function var0_0.Survey(arg0_35)
	Application.OpenURL(arg0_35)
end

function OnQueryProductsSucess(arg0_36)
	local function var0_36(arg0_37, arg1_37)
		for iter0_37, iter1_37 in ipairs(pg.pay_data_display.all) do
			local var0_37 = pg.pay_data_display[iter1_37]

			if var0_37.id_str == arg0_37 and var0_37.money ~= arg1_37 then
				-- block empty
			end
		end
	end

	local var1_36 = arg0_36.Count

	for iter0_36 = 0, var1_36 - 1 do
		local var2_36 = arg0_36[iter0_36]
		local var3_36 = var2_36.ProductID
		local var4_36 = var2_36.Price

		var0_36(var3_36, var4_36)
	end
end

function OnAdRewards(arg0_38)
	return
end

function OnQuerySubscriptionSuccess(arg0_39)
	return
end

function OnRequestPayment(arg0_40)
	local var0_40 = var0_0.GetPNInfo()
	local var1_40 = ""

	originalPrint("SdkPay OnRequestPayment")
	var1_0:Pay(arg0_40, var1_40, var0_40.info)
end

function OnQuerySuccess(arg0_41, arg1_41)
	return
end

return var0_0
