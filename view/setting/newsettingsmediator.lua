local var0 = class("NewSettingsMediator", import("..base.ContextMediator"))

var0.SHOW_DESC = "NewSettingsMediator:SHOW_DESC"
var0.ON_LOGOUT = "NewSettingsMediator:ON_LOGOUT"
var0.ON_SECON_PWD_STATE_CHANGE = "NewSettingsMediator:ON_SECON_PWD_STATE_CHANGE"
var0.OPEN_YOSTAR_ALERT_VIEW = "NewSettingsMediator:OPEN_YOSTAR_ALERT_VIEW"

function var0.register(arg0)
	arg0:bind(var0.ON_LOGOUT, function(arg0)
		arg0:sendNotification(GAME.LOGOUT, {
			code = 0
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		var0.SHOW_DESC,
		var0.ON_SECON_PWD_STATE_CHANGE,
		var0.OPEN_YOSTAR_ALERT_VIEW,
		GAME.EXCHANGECODE_USE_SUCCESS,
		GAME.ON_GET_TRANSCODE,
		GAME.ON_SOCIAL_LINKED,
		GAME.ON_SOCIAL_UNLINKED,
		GAME.CHANGE_RANDOM_SHIP_MODE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == var0.SHOW_DESC then
		arg0.viewComponent:OnShowDescWindow(var1)
	elseif var0 == GAME.EXCHANGECODE_USE_SUCCESS then
		arg0.viewComponent:OnClearExchangeCode()
	elseif var0 == GAME.ON_GET_TRANSCODE then
		arg0.viewComponent:OnShowTranscode(var1.transcode)
	elseif var0 == GAME.ON_SOCIAL_LINKED or var0 == GAME.ON_SOCIAL_UNLINKED then
		arg0.viewComponent:OnCheckAllAccountState()
		arg0.viewComponent:CloseYostarAlertView()
		pg.UIMgr.GetInstance():LoadingOff()
	elseif var0 == var0.ON_SECON_PWD_STATE_CHANGE then
		arg0.viewComponent:OnSecondPwdStateChange()
	elseif var0 == var0.OPEN_YOSTAR_ALERT_VIEW then
		arg0.viewComponent:OpenYostarAlertView()
	elseif var0 == GAME.CHANGE_RANDOM_SHIP_MODE_DONE then
		arg0.viewComponent:OnRandomFlagShipModeUpdate()
	end
end

return var0
