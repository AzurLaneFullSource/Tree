local var0 = class("NewProbabilitySkinShopMediator", import(".NewSkinShopMediator"))

var0.OPEN_CHARGE_BIRTHDAY = "NewProbabilitySkinShopMediator:OPEN_CHARGE_BIRTHDAY"
var0.CHARGE = "NewProbabilitySkinShopMediator:CHARGE"
var0.OPEN_CHARGE_ITEM_PANEL = "NewProbabilitySkinShopMediator:OPEN_CHARGE_ITEM_PANEL"

function var0.register(arg0)
	var0.super.register(arg0)
	arg0:bind(var0.OPEN_CHARGE_BIRTHDAY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0:bind(var0.CHARGE, function(arg0, arg1)
		arg0:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1
		})
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_PANEL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	local var0 = var0.super.listNotificationInterests(arg0)

	table.insert(var0, GAME.CHARGE_SUCCESS)

	return var0
end

function var0.handleNotification(arg0, arg1)
	var0.super.handleNotification(arg0, arg1)

	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CHARGE_SUCCESS then
		arg0.viewComponent:OnChargeSuccess(var1.shopId)
	end
end

return var0
