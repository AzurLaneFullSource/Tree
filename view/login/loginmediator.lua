local var0_0 = class("LoginMediator", import("..base.ContextMediator"))

var0_0.ON_LOGIN = "LoginMediator:ON_LOGIN"
var0_0.ON_REGISTER = "LoginMediator:ON_REGISTER"
var0_0.ON_SERVER = "LoginMediator:ON_SERVER"
var0_0.ON_LOGIN_PROCESS = "LoginMediator:ON_LOGIN_PROCESS"
var0_0.ON_SEARCH_ACCOUNT = "LoginMediator:ON_SEARCH_ACCOUNT"
var0_0.CHECK_RES = "LoginMediator:CHECK_RES"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_LOGIN, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.USER_LOGIN, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_REGISTER, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.USER_REGISTER, arg1_3)
	end)
	arg0_1:bind(var0_0.ON_SERVER, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SERVER_LOGIN, arg1_4)
	end)
	arg0_1:bind(var0_0.ON_LOGIN_PROCESS, function(arg0_5)
		if PLATFORM_CODE == PLATFORM_CHT and (CSharpVersion == 31 or CSharpVersion == 32 or CSharpVersion == 33 or CSharpVersion == 34) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = "檢測到版本更新，需要手動下載更新包，是否前往下載？",
				hideClose = true,
				onYes = function()
					local var0_6 = YongshiSdkMgr.inst.channelUID

					if var0_6 == "0" then
						Application.OpenURL("https://play.google.com/store/apps/details?id=com.hkmanjuu.azurlane.gp")
					elseif var0_6 == "1" then
						Application.OpenURL("https://apps.apple.com/app/id1479022429")
					elseif var0_6 == "2" then
						Application.OpenURL("http://www.mygame.com.tw/MyGameAD/Accept.aspx?P=YAS3ZA2RSR&S=QUNRMMN7HY")
					end

					Application.Quit()
				end,
				onClose = function()
					Application.Quit()
				end
			})
		else
			arg0_1:loginProcessHandler()
		end
	end)
	arg0_1:bind(var0_0.ON_SEARCH_ACCOUNT, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.ACCOUNT_SEARCH, arg1_8)
	end)
	arg0_1:bind(var0_0.CHECK_RES, function(arg0_9)
		arg0_1:checkPaintingRes()
	end)
	pg.SdkMgr.GetInstance():EnterLoginScene()
end

function var0_0.remove(arg0_10)
	pg.SdkMgr.GetInstance():ExitLoginScene()
end

function var0_0.loginProcessHandler(arg0_11)
	local var0_11 = getProxy(SettingsProxy)
	local var1_11 = pg.SdkMgr.GetInstance():GetLoginType()

	assert(var1_11)

	arg0_11.process = coroutine.wrap(function()
		arg0_11.viewComponent:switchSubView({})

		if var0_11:CheckNeedUserAgreement() then
			arg0_11.viewComponent:showUserAgreement(arg0_11.process)
			coroutine.yield()
			var0_11:SetUserAgreement()
		end

		local var0_12

		if var1_11 == LoginType.PLATFORM then
			arg0_11.viewComponent:switchToServer()
		elseif var1_11 == LoginType.PLATFORM_TENCENT then
			arg0_11.viewComponent:switchToTencentLogin()
		elseif var1_11 == LoginType.PLATFORM_INNER then
			arg0_11.viewComponent:switchToLogin()

			var0_12 = getProxy(UserProxy):getLastLoginUser()

			arg0_11.viewComponent:setLastLogin(var0_12)
		elseif var1_11 == LoginType.PLATFORM_AIRIJP or var1_11 == LoginType.PLATFORM_AIRIUS then
			arg0_11.viewComponent:switchToAiriLogin()
		end

		arg0_11:CheckMaintain()

		if arg0_11.contextData.code then
			if arg0_11.contextData.code == 0 or arg0_11.contextData.code == SDK_EXIT_CODE then
				-- block empty
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					hideNo = true,
					content = ({
						i18n("login_loginMediator_kickOtherLogin"),
						i18n("login_loginMediator_kickServerClose"),
						i18n("login_loginMediator_kickIntError"),
						i18n("login_loginMediator_kickTimeError"),
						i18n("login_loginMediator_kickLoginOut"),
						i18n("login_loginMediator_serverLoginErro"),
						i18n("login_loginMediator_vertifyFail"),
						[199] = i18n("login_loginMediator_dataExpired")
					})[arg0_11.contextData.code] or i18n("login_loginMediator_kickUndefined", arg0_11.contextData.code),
					onYes = function()
						arg0_11.process()
					end
				})
				coroutine.yield()
			end

			if var0_12 then
				if var0_12.type == 1 then
					var0_12.arg3 = ""
				elseif var0_12.type == 2 then
					var0_12.arg2 = ""
				end

				arg0_11.viewComponent:setLastLogin(var0_12)
			end
		else
			arg0_11.viewComponent:setAutoLogin()
		end

		if var1_11 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var1_11 == LoginType.PLATFORM_TENCENT then
			pg.SdkMgr.GetInstance():TryLoginSdk()
		elseif var1_11 == LoginType.PLATFORM_INNER then
			-- block empty
		end

		arg0_11.viewComponent:autoLogin()
	end)

	arg0_11.process()
end

function var0_0.CheckMaintain(arg0_14)
	ServerStateChecker.New():Execute(function(arg0_15)
		if arg0_15 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("login_loginMediator_kickServerClose"),
				onNo = function()
					arg0_14.process()
				end,
				onYes = function()
					arg0_14.process()
				end
			})
		else
			arg0_14.process()
		end
	end)
	coroutine.yield()
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		GAME.USER_LOGIN_SUCCESS,
		GAME.USER_LOGIN_FAILED,
		GAME.USER_REGISTER_SUCCESS,
		GAME.USER_REGISTER_FAILED,
		GAME.SERVER_LOGIN_SUCCESS,
		GAME.SERVER_LOGIN_FAILED,
		GAME.LOAD_PLAYER_DATA_DONE,
		ServerProxy.SERVERS_UPDATED,
		GAME.PLATFORM_LOGIN_DONE,
		GAME.SERVER_LOGIN_WAIT,
		GAME.BEGIN_STAGE_DONE,
		GAME.SERVER_LOGIN_FAILED_USER_BANNED,
		GAME.ON_SOCIAL_LINKED
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()

	if var0_19 == ServerProxy.SERVERS_UPDATED then
		arg0_19.viewComponent:updateServerList(var1_19)
	elseif var0_19 == GAME.USER_LOGIN_SUCCESS then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginMediator_loginSuccess"))

		local var2_19 = getProxy(ServerProxy):getLastServer(var1_19.id)

		arg0_19.viewComponent:setLastLoginServer(var2_19)
		arg0_19.viewComponent:switchToServer()

		local var3_19 = getProxy(UserProxy)

		if PLATFORM_CODE == PLATFORM_JP then
			arg0_19.viewComponent:setUserData(var3_19.getLastLoginUser())
		end

		if #getProxy(GatewayNoticeProxy):getGatewayNotices(false) > 0 then
			arg0_19:addSubLayers(Context.New({
				mediator = GatewayNoticeMediator,
				viewComponent = GatewayNoticeLayer
			}))
		end

		local var4_19 = getProxy(UserProxy)

		if var4_19.data.limitServerIds and #var4_19.data.limitServerIds > 0 then
			arg0_19.viewComponent:fillterRefundServer()
			arg0_19.viewComponent:setLastLoginServer(nil)
		end

		arg0_19.viewComponent.switchGatewayBtn:Flush()
	elseif var0_19 == GAME.USER_REGISTER_SUCCESS then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("login_loginMediator_quest_RegisterSuccess"),
			onYes = function()
				arg0_19:sendNotification(GAME.USER_LOGIN, var1_19)
			end
		})
	elseif var0_19 == GAME.SERVER_LOGIN_SUCCESS then
		if var1_19.uid == 0 then
			if EPILOGUE_SKIPPABLE then
				arg0_19:sendNotification(GAME.GO_SCENE, SCENE.CREATE_PLAYER)
			else
				arg0_19:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_PROLOGUE
				})
			end
		else
			arg0_19.facade:sendNotification(GAME.LOAD_PLAYER_DATA, {
				id = var1_19.uid
			})
		end
	elseif var0_19 == GAME.USER_REGISTER_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_registerFail", var1_19)
		})
	elseif var0_19 == GAME.USER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_userLoginFail_error", var1_19),
			onYes = function()
				local var0_21 = pg.SdkMgr.GetInstance():GetLoginType()

				if var1_19 == 20 then
					arg0_19.viewComponent:switchToRegister()
				elseif var1_19 == 3 or var1_19 == 6 then
					arg0_19.viewComponent:switchToServer()
				elseif var1_19 == 1 or var1_19 == 9 or var1_19 == 11 or var1_19 == 12 then
					if var0_21 == LoginType.PLATFORM_AIRIJP or var0_21 == LoginType.PLATFORM_AIRIUS then
						arg0_19.viewComponent:switchToAiriLogin()
					else
						arg0_19.viewComponent:switchToLogin()
					end
				elseif var0_21 == LoginType.PLATFORM or var0_21 == LoginType.PLATFORM_TENCENT then
					arg0_19.viewComponent:switchToServer()
				elseif var0_21 == LoginType.PLATFORM_AIRIJP or var0_21 == LoginType.PLATFORM_AIRIUS then
					arg0_19.viewComponent:switchToAiriLogin()
				else
					arg0_19.viewComponent:switchToLogin()
				end
			end
		})
	elseif var0_19 == GAME.SERVER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_serverLoginFail", var1_19),
			onYes = function()
				local var0_22 = pg.SdkMgr.GetInstance():GetLoginType()

				if var0_22 == LoginType.PLATFORM or LoginType.PLATFORM_TENCENT then
					arg0_19.viewComponent:switchToServer()
				elseif var0_22 == LoginType.PLATFORM_AIRIJP or var0_22 == LoginType.PLATFORM_AIRIUS then
					arg0_19.viewComponent:switchToAiriLogin()
				else
					arg0_19.viewComponent:switchToLogin()
				end
			end
		})
	elseif var0_19 == GAME.LOAD_PLAYER_DATA_DONE then
		arg0_19:checkPaintingRes()
	elseif var0_19 == GAME.BEGIN_STAGE_DONE then
		arg0_19.viewComponent:unloadExtraVoice()
		arg0_19:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_19)
	elseif var0_19 == GAME.PLATFORM_LOGIN_DONE then
		arg0_19:sendNotification(GAME.USER_LOGIN, var1_19.user)
	elseif var0_19 == GAME.SERVER_LOGIN_WAIT then
		arg0_19.viewComponent:SwitchToWaitPanel(var1_19)
	elseif var0_19 == GAME.SERVER_LOGIN_FAILED_USER_BANNED then
		if var1_19 == 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_forever_banned")
			})
		else
			local var5_19 = pg.TimeMgr.GetInstance():STimeDescS(var1_19, "%Y-%m-%d %H:%M")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_banned", var5_19)
			})
		end
	elseif var0_19 == GAME.ON_SOCIAL_LINKED then
		arg0_19.viewComponent:closeYostarAlertView()
	end
end

function var0_0.checkPaintingRes(arg0_23)
	local function var0_23()
		arg0_23.viewComponent:onLoadDataDone()
	end

	local function var1_23()
		arg0_23.viewComponent.isNeedResCheck = true
	end

	pg.FileDownloadMgr.GetInstance():SetRemind(false)

	local var2_23 = PaintingGroupConst.GetPaintingNameListInLogin()
	local var3_23 = {
		isShowBox = true,
		paintingNameList = var2_23,
		finishFunc = var0_23,
		onNo = var1_23,
		onClose = var1_23
	}

	PaintingGroupConst.PaintingDownload(var3_23)
end

return var0_0
