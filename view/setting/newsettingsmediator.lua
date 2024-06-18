local var0_0 = class("NewSettingsMediator", import("..base.ContextMediator"))

var0_0.SHOW_DESC = "NewSettingsMediator:SHOW_DESC"
var0_0.ON_LOGOUT = "NewSettingsMediator:ON_LOGOUT"
var0_0.ON_SECON_PWD_STATE_CHANGE = "NewSettingsMediator:ON_SECON_PWD_STATE_CHANGE"
var0_0.OPEN_YOSTAR_ALERT_VIEW = "NewSettingsMediator:OPEN_YOSTAR_ALERT_VIEW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_LOGOUT, function(arg0_2)
		arg0_1:sendNotification(GAME.LOGOUT, {
			code = 0
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		var0_0.SHOW_DESC,
		var0_0.ON_SECON_PWD_STATE_CHANGE,
		var0_0.OPEN_YOSTAR_ALERT_VIEW,
		GAME.EXCHANGECODE_USE_SUCCESS,
		GAME.ON_GET_TRANSCODE,
		GAME.ON_SOCIAL_LINKED,
		GAME.ON_SOCIAL_UNLINKED,
		GAME.CHANGE_RANDOM_SHIP_MODE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == var0_0.SHOW_DESC then
		arg0_4.viewComponent:OnShowDescWindow(var1_4)
	elseif var0_4 == GAME.EXCHANGECODE_USE_SUCCESS then
		arg0_4.viewComponent:OnClearExchangeCode()
	elseif var0_4 == GAME.ON_GET_TRANSCODE then
		arg0_4.viewComponent:OnShowTranscode(var1_4.transcode)
	elseif var0_4 == GAME.ON_SOCIAL_LINKED or var0_4 == GAME.ON_SOCIAL_UNLINKED then
		arg0_4.viewComponent:OnCheckAllAccountState()
		arg0_4.viewComponent:CloseYostarAlertView()
		pg.UIMgr.GetInstance():LoadingOff()
	elseif var0_4 == var0_0.ON_SECON_PWD_STATE_CHANGE then
		arg0_4.viewComponent:OnSecondPwdStateChange()
	elseif var0_4 == var0_0.OPEN_YOSTAR_ALERT_VIEW then
		arg0_4.viewComponent:OpenYostarAlertView()
	elseif var0_4 == GAME.CHANGE_RANDOM_SHIP_MODE_DONE then
		arg0_4.viewComponent:OnRandomFlagShipModeUpdate()
	end
end

return var0_0
