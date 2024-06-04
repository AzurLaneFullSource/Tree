local var0 = class("LoginMediator", import("..base.ContextMediator"))

var0.ON_LOGIN = "LoginMediator:ON_LOGIN"
var0.ON_REGISTER = "LoginMediator:ON_REGISTER"
var0.ON_SERVER = "LoginMediator:ON_SERVER"
var0.ON_LOGIN_PROCESS = "LoginMediator:ON_LOGIN_PROCESS"
var0.ON_SEARCH_ACCOUNT = "LoginMediator:ON_SEARCH_ACCOUNT"
var0.CHECK_RES = "LoginMediator:CHECK_RES"

function var0.register(arg0)
	arg0:bind(var0.ON_LOGIN, function(arg0, arg1)
		arg0:sendNotification(GAME.USER_LOGIN, arg1)
	end)
	arg0:bind(var0.ON_REGISTER, function(arg0, arg1)
		arg0:sendNotification(GAME.USER_REGISTER, arg1)
	end)
	arg0:bind(var0.ON_SERVER, function(arg0, arg1)
		arg0:sendNotification(GAME.SERVER_LOGIN, arg1)
	end)
	arg0:bind(var0.ON_LOGIN_PROCESS, function(arg0)
		if PLATFORM_CODE == PLATFORM_CHT and (CSharpVersion == 31 or CSharpVersion == 32 or CSharpVersion == 33 or CSharpVersion == 34) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				content = "檢測到版本更新，需要手動下載更新包，是否前往下載？",
				hideClose = true,
				onYes = function()
					local var0 = YongshiSdkMgr.inst.channelUID

					if var0 == "0" then
						Application.OpenURL("https://play.google.com/store/apps/details?id=com.hkmanjuu.azurlane.gp")
					elseif var0 == "1" then
						Application.OpenURL("https://apps.apple.com/app/id1479022429")
					elseif var0 == "2" then
						Application.OpenURL("http://www.mygame.com.tw/MyGameAD/Accept.aspx?P=YAS3ZA2RSR&S=QUNRMMN7HY")
					end

					Application.Quit()
				end,
				onClose = function()
					Application.Quit()
				end
			})
		else
			arg0:loginProcessHandler()
		end
	end)
	arg0:bind(var0.ON_SEARCH_ACCOUNT, function(arg0, arg1)
		arg0:sendNotification(GAME.ACCOUNT_SEARCH, arg1)
	end)
	arg0:bind(var0.CHECK_RES, function(arg0)
		arg0:checkPaintingRes()
	end)
	pg.SdkMgr.GetInstance():EnterLoginScene()
end

function var0.remove(arg0)
	pg.SdkMgr.GetInstance():ExitLoginScene()
end

function var0.loginProcessHandler(arg0)
	local var0 = getProxy(SettingsProxy)
	local var1 = pg.SdkMgr.GetInstance():GetLoginType()

	assert(var1)

	arg0.process = coroutine.wrap(function()
		arg0.viewComponent:switchSubView({})

		if var0:CheckNeedUserAgreement() then
			arg0.viewComponent:showUserAgreement(arg0.process)
			coroutine.yield()
			var0:SetUserAgreement()
		end

		local var0

		if var1 == LoginType.PLATFORM then
			arg0.viewComponent:switchToServer()
		elseif var1 == LoginType.PLATFORM_TENCENT then
			arg0.viewComponent:switchToTencentLogin()
		elseif var1 == LoginType.PLATFORM_INNER then
			arg0.viewComponent:switchToLogin()

			var0 = getProxy(UserProxy):getLastLoginUser()

			arg0.viewComponent:setLastLogin(var0)
		elseif var1 == LoginType.PLATFORM_AIRIJP or var1 == LoginType.PLATFORM_AIRIUS then
			arg0.viewComponent:switchToAiriLogin()
		end

		arg0:CheckMaintain()

		if arg0.contextData.code then
			if arg0.contextData.code == 0 or arg0.contextData.code == SDK_EXIT_CODE then
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
					})[arg0.contextData.code] or i18n("login_loginMediator_kickUndefined", arg0.contextData.code),
					onYes = function()
						arg0.process()
					end
				})
				coroutine.yield()
			end

			if var0 then
				if var0.type == 1 then
					var0.arg3 = ""
				elseif var0.type == 2 then
					var0.arg2 = ""
				end

				arg0.viewComponent:setLastLogin(var0)
			end
		else
			arg0.viewComponent:setAutoLogin()
		end

		if var1 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var1 == LoginType.PLATFORM_TENCENT then
			pg.SdkMgr.GetInstance():TryLoginSdk()
		elseif var1 == LoginType.PLATFORM_INNER then
			-- block empty
		end

		arg0.viewComponent:autoLogin()
	end)

	arg0.process()
end

function var0.CheckMaintain(arg0)
	ServerStateChecker.New():Execute(function(arg0)
		if arg0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("login_loginMediator_kickServerClose"),
				onNo = function()
					arg0.process()
				end,
				onYes = function()
					arg0.process()
				end
			})
		else
			arg0.process()
		end
	end)
	coroutine.yield()
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ServerProxy.SERVERS_UPDATED then
		arg0.viewComponent:updateServerList(var1)
	elseif var0 == GAME.USER_LOGIN_SUCCESS then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginMediator_loginSuccess"))

		local var2 = getProxy(ServerProxy):getLastServer(var1.id)

		arg0.viewComponent:setLastLoginServer(var2)
		arg0.viewComponent:switchToServer()

		local var3 = getProxy(UserProxy)

		if PLATFORM_CODE == PLATFORM_JP then
			arg0.viewComponent:setUserData(var3.getLastLoginUser())
		end

		if #getProxy(GatewayNoticeProxy):getGatewayNotices(false) > 0 then
			arg0:addSubLayers(Context.New({
				mediator = GatewayNoticeMediator,
				viewComponent = GatewayNoticeLayer
			}))
		end

		local var4 = getProxy(UserProxy)

		if var4.data.limitServerIds and #var4.data.limitServerIds > 0 then
			arg0.viewComponent:fillterRefundServer()
			arg0.viewComponent:setLastLoginServer(nil)
		end

		arg0.viewComponent.switchGatewayBtn:Flush()
	elseif var0 == GAME.USER_REGISTER_SUCCESS then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("login_loginMediator_quest_RegisterSuccess"),
			onYes = function()
				arg0:sendNotification(GAME.USER_LOGIN, var1)
			end
		})
	elseif var0 == GAME.SERVER_LOGIN_SUCCESS then
		if var1.uid == 0 then
			if EPILOGUE_SKIPPABLE then
				arg0:sendNotification(GAME.GO_SCENE, SCENE.CREATE_PLAYER)
			else
				arg0:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_PROLOGUE
				})
			end
		else
			arg0.facade:sendNotification(GAME.LOAD_PLAYER_DATA, {
				id = var1.uid
			})
		end
	elseif var0 == GAME.USER_REGISTER_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_registerFail", var1)
		})
	elseif var0 == GAME.USER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_userLoginFail_error", var1),
			onYes = function()
				local var0 = pg.SdkMgr.GetInstance():GetLoginType()

				if var1 == 20 then
					arg0.viewComponent:switchToRegister()
				elseif var1 == 3 or var1 == 6 then
					arg0.viewComponent:switchToServer()
				elseif var1 == 1 or var1 == 9 or var1 == 11 or var1 == 12 then
					if var0 == LoginType.PLATFORM_AIRIJP or var0 == LoginType.PLATFORM_AIRIUS then
						arg0.viewComponent:switchToAiriLogin()
					else
						arg0.viewComponent:switchToLogin()
					end
				elseif var0 == LoginType.PLATFORM or var0 == LoginType.PLATFORM_TENCENT then
					arg0.viewComponent:switchToServer()
				elseif var0 == LoginType.PLATFORM_AIRIJP or var0 == LoginType.PLATFORM_AIRIUS then
					arg0.viewComponent:switchToAiriLogin()
				else
					arg0.viewComponent:switchToLogin()
				end
			end
		})
	elseif var0 == GAME.SERVER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_serverLoginFail", var1),
			onYes = function()
				local var0 = pg.SdkMgr.GetInstance():GetLoginType()

				if var0 == LoginType.PLATFORM or LoginType.PLATFORM_TENCENT then
					arg0.viewComponent:switchToServer()
				elseif var0 == LoginType.PLATFORM_AIRIJP or var0 == LoginType.PLATFORM_AIRIUS then
					arg0.viewComponent:switchToAiriLogin()
				else
					arg0.viewComponent:switchToLogin()
				end
			end
		})
	elseif var0 == GAME.LOAD_PLAYER_DATA_DONE then
		arg0:checkPaintingRes()
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0.viewComponent:unloadExtraVoice()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GAME.PLATFORM_LOGIN_DONE then
		arg0:sendNotification(GAME.USER_LOGIN, var1.user)
	elseif var0 == GAME.SERVER_LOGIN_WAIT then
		arg0.viewComponent:SwitchToWaitPanel(var1)
	elseif var0 == GAME.SERVER_LOGIN_FAILED_USER_BANNED then
		if var1 == 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_forever_banned")
			})
		else
			local var5 = pg.TimeMgr.GetInstance():STimeDescS(var1, "%Y-%m-%d %H:%M")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_banned", var5)
			})
		end
	elseif var0 == GAME.ON_SOCIAL_LINKED then
		arg0.viewComponent:closeYostarAlertView()
	end
end

function var0.checkPaintingRes(arg0)
	local function var0()
		arg0.viewComponent:onLoadDataDone()
	end

	local function var1()
		arg0.viewComponent.isNeedResCheck = true
	end

	pg.FileDownloadMgr.GetInstance():SetRemind(false)

	local var2 = PaintingGroupConst.GetPaintingNameListInLogin()
	local var3 = {
		isShowBox = true,
		paintingNameList = var2,
		finishFunc = var0,
		onNo = var1,
		onClose = var1
	}

	PaintingGroupConst.PaintingDownload(var3)
end

return var0
