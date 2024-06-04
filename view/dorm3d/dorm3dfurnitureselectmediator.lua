local var0 = class("Dorm3dFurnitureSelectMediator", import("view.base.ContextMediator"))

var0.SHOW_CONFIRM_WINDOW = "SHOW_CONFIRM_WINDOW"
var0.SHOW_FURNITURE_ACESSES = "SHOW_FURNITURE_ACESSES"

function var0.register(arg0)
	arg0:bind(GAME.APARTMENT_REPLACE_FURNITURE, function(arg0, arg1)
		arg0:sendNotification(GAME.APARTMENT_REPLACE_FURNITURE, arg1)
	end)
	arg0:bind(var0.SHOW_CONFIRM_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureConfirmWindowMediator,
			viewComponent = Dorm3dFurnitureConfirmWindow,
			data = arg1
		}))
	end)
	arg0:bind(var0.SHOW_FURNITURE_ACESSES, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureAcessesWindowMediator,
			viewComponent = Dorm3dFurnitureAcessesWindow,
			data = arg1
		}))
	end)

	local var0 = pg.m02:retrieveMediator(Dorm3dSceneMediator.__cname):getViewComponent()

	arg0.viewComponent:SetSceneRoot(var0)

	local var1 = var0:GetApartment()

	arg0.viewComponent:SetApartment(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT,
		GAME.APARTMENT_REPLACE_FURNITURE_DONE,
		GAME.APARTMENT_REPLACE_FURNITURE_ERROR
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	elseif var0 == Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT then
		arg0.viewComponent:OnClickFurnitureSlot(var1)
	elseif var0 == GAME.APARTMENT_REPLACE_FURNITURE_DONE then
		arg0.viewComponent:OnReplaceFurnitureDone()
	elseif var0 == GAME.APARTMENT_REPLACE_FURNITURE_ERROR then
		arg0.viewComponent:OnReplaceFurnitureError()
	end
end

function var0.remove(arg0)
	return
end

return var0
