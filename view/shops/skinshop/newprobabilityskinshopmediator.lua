local var0_0 = class("NewProbabilitySkinShopMediator", import(".NewSkinShopMediator"))

var0_0.OPEN_CHARGE_BIRTHDAY = "NewProbabilitySkinShopMediator:OPEN_CHARGE_BIRTHDAY"
var0_0.CHARGE = "NewProbabilitySkinShopMediator:CHARGE"
var0_0.OPEN_CHARGE_ITEM_PANEL = "NewProbabilitySkinShopMediator:OPEN_CHARGE_ITEM_PANEL"

function var0_0.register(arg0_1)
	var0_0.super.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_4
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	local var0_5 = var0_0.super.listNotificationInterests(arg0_5)

	table.insert(var0_5, GAME.CHARGE_SUCCESS)

	return var0_5
end

function var0_0.handleNotification(arg0_6, arg1_6)
	var0_0.super.handleNotification(arg0_6, arg1_6)

	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.CHARGE_SUCCESS then
		arg0_6.viewComponent:OnChargeSuccess(var1_6.shopId)
	end
end

return var0_0
