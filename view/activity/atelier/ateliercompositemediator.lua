local var0_0 = class("AtelierCompositeMediator", import("view.base.ContextMediator"))

var0_0.OPEN_FORMULA = "OPEN_FORMULA"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.COMPOSITE_ATELIER_RECIPE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.COMPOSITE_ATELIER_RECIPE, {
			formulaId = arg0_1.contextData.formulaId,
			items = arg1_2,
			repeats = arg2_2
		})
	end)
	arg0_1:bind(AtelierMaterialDetailMediator.SHOW_DETAIL, function(arg0_3, arg1_3)
		local var0_3 = arg1_3:GetVersion()
		local var1_3

		if var0_3 == 1 then
			var1_3 = AtelierMaterialDetailLayer
		else
			var1_3 = AtelierMaterialDetailYumiaLayer
		end

		arg0_1:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = var1_3,
			data = {
				material = arg1_3
			}
		}))
	end)
	arg0_1.viewComponent:InitView()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)
	local var1_1 = arg0_1.contextData.versionIndex or 1
	local var2_1 = AtelierTools.IsUnlockAtelier(var0_1, var1_1)

	arg0_1.viewComponent:SetEnabled(var2_1)
	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.COMPOSITE_ATELIER_RECIPE_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		var0_0.OPEN_FORMULA
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.COMPOSITE_ATELIER_RECIPE_DONE then
		arg0_5.viewComponent:OnCompositeResult(var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
			arg0_5.viewComponent:SetActivity(var1_5)
		end
	elseif var0_5 == var0_0.OPEN_FORMULA then
		arg0_5.viewComponent:OnReceiveFormualRequest(var1_5)
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
