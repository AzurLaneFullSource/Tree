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

function var0_0.GetSDKServerID()
	local var0_4 = ({
		[0] = "1",
		"2001",
		"1001",
		"not_define"
	})[NetConst.getwayType]

	originalPrint("SDK ServerID:" .. tostring(var0_4))

	return var0_4
end

function var0_0.GoSDkLoginScene()
	var1_0:GoLoginScene()
end

function var0_0.LoginSdk(arg0_6)
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

function var0_0.EnterServer(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
	return
end

function var0_0.SdkLevelUp(arg0_11, arg1_11)
	return
end

function var0_0.UserCenter()
	local var0_12 = var0_0.GetPNInfo()
	local var1_12 = var0_0.GetClientVer()

	var1_0:UserCenter(var0_12.playerName, var1_12, var0_12.serverID, var0_12.info)
end

function var0_0.BugReport()
	local var0_13 = var0_0.GetPNInfo()
	local var1_13 = var0_0.GetClientVer()

	var1_0:BugReport(var0_13.playerName, var1_13, var0_13.serverID, var0_13.info)
end

function var0_0.StoreReview()
	if var0_0.GetIsPlatform() then
		local var0_14 = var0_0.GetPNInfo()
		local var1_14 = var0_0.GetClientVer()

		var1_0:StoreReview(var0_14.playerName, var1_14, var0_14.serverID, var0_14.info)
	end
end

function var0_0.ShareImg(arg0_15)
	var1_0:ShareImg(arg0_15, "")
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

function var0_0.SdkPay(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21, arg5_21, arg6_21, arg7_21, arg8_21, arg9_21)
	local var0_21 = var0_0.GetPNInfo()
	local var1_21 = var0_21.serverID .. "-" .. var0_21.playerID .. "-" .. arg4_21

	originalPrint("SdkPay nonce", tostring(var1_21))

	local var2_21 = var0_0.GetSDKServerID()

	var1_0:SDK_PayWithProductID(arg0_21, var2_21, var1_21, var0_21.info:GetJson())
end

function var0_0.BindCPU()
	var1_0:callSdkApi("bindCpu", nil)
end

function var0_0.SwitchAccount()
	var1_0:LocalLogout()
	onDelayTick(function()
		var1_0:Login()
	end, 0.1)
end

function var0_0.EventTrack(arg0_25)
	var1_0:SDK_EvtTrack(arg0_25)
end

function var0_0.GetBiliServerId()
	local var0_26 = var1_0.serverId

	originalPrint("serverId : " .. var0_26)

	return var0_26
end

function var0_0.GetChannelUID()
	local var0_27 = var1_0.channelUID

	originalPrint("channelUID : " .. var0_27)

	return var0_27
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

function SDKLogined(arg0_33, arg1_33, arg2_33, arg3_33)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	local var0_33 = User.New({
		type = 1,
		arg1 = arg0_33,
		arg2 = arg1_33,
		arg3 = arg2_33,
		arg4 = arg3_33
	})

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = var0_33
	})
end

function SDKLogouted(arg0_34)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	pg.m02:sendNotification(GAME.LOGOUT, {
		code = arg0_34
	})
end

function PaySuccess(arg0_35, arg1_35)
	if not pg.m02 then
		originalPrint("game is not start")

		return
	end

	getProxy(ShopsProxy):removeWaitTimer()
end

function PayFailed(arg0_36, arg1_36)
	getProxy(ShopsProxy):removeWaitTimer()

	arg1_36 = tonumber(arg1_36)

	if not arg1_36 then
		return
	end

	pg.m02:sendNotification(GAME.CHARGE_FAILED, {
		payId = arg0_36,
		code = arg1_36
	})

	if arg1_36 == -202 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("pay_cancel") .. arg1_36)
	end
end

function var0_0.Survey(arg0_37)
	Application.OpenURL(arg0_37)
end

function OnQueryProductsSucess(arg0_38)
	local function var0_38(arg0_39, arg1_39)
		for iter0_39, iter1_39 in ipairs(pg.pay_data_display.all) do
			local var0_39 = pg.pay_data_display[iter1_39]

			if var0_39.id_str == arg0_39 and var0_39.money ~= arg1_39 then
				-- block empty
			end
		end
	end

	local var1_38 = arg0_38.Count

	for iter0_38 = 0, var1_38 - 1 do
		local var2_38 = arg0_38[iter0_38]
		local var3_38 = var2_38.ProductID
		local var4_38 = var2_38.Price

		var0_38(var3_38, var4_38)
	end
end

function OnAdRewards(arg0_40)
	return
end

function OnQuerySubscriptionSuccess(arg0_41)
	return
end

function OnRequestPayment(arg0_42)
	local var0_42 = var0_0.GetPNInfo()
	local var1_42 = ""

	originalPrint("SdkPay OnRequestPayment")

	local var2_42 = var0_0.GetSDKServerID()

	var1_0:SDK_PayWithProductID(arg0_42, var2_42, var1_42, var0_42.info:GetJson())
end

function OnQuerySuccess(arg0_43, arg1_43)
	return
end

return var0_0
