local var0_0 = class("Dorm3dFurnitureSelectMediator", import("view.base.ContextMediator"))

var0_0.SHOW_CONFIRM_WINDOW = "SHOW_CONFIRM_WINDOW"
var0_0.SHOW_FURNITURE_ACESSES = "SHOW_FURNITURE_ACESSES"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.APARTMENT_REPLACE_FURNITURE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE, arg1_2)
	end)
	arg0_1:bind(var0_0.SHOW_CONFIRM_WINDOW, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureConfirmWindowMediator,
			viewComponent = Dorm3dFurnitureConfirmWindow,
			data = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.SHOW_FURNITURE_ACESSES, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureAcessesWindowMediator,
			viewComponent = Dorm3dFurnitureAcessesWindow,
			data = arg1_4
		}))
	end)

	local var0_1 = pg.m02:retrieveMediator(Dorm3dSceneMediator.__cname):getViewComponent()

	arg0_1.viewComponent:SetSceneRoot(var0_1)

	local var1_1 = var0_1:GetApartment()

	arg0_1.viewComponent:SetApartment(var1_1)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT,
		GAME.APARTMENT_REPLACE_FURNITURE_DONE,
		GAME.APARTMENT_REPLACE_FURNITURE_ERROR
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	elseif var0_6 == Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT then
		arg0_6.viewComponent:OnClickFurnitureSlot(var1_6)
	elseif var0_6 == GAME.APARTMENT_REPLACE_FURNITURE_DONE then
		arg0_6.viewComponent:OnReplaceFurnitureDone()
	elseif var0_6 == GAME.APARTMENT_REPLACE_FURNITURE_ERROR then
		arg0_6.viewComponent:OnReplaceFurnitureError()
	end
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
