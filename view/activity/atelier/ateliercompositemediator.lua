local var0 = class("AtelierCompositeMediator", import("view.base.ContextMediator"))

var0.OPEN_FORMULA = "OPEN_FORMULA"

function var0.register(arg0)
	arg0:bind(GAME.COMPOSITE_ATELIER_RECIPE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMPOSITE_ATELIER_RECIPE, {
			formulaId = arg0.contextData.formulaId,
			items = arg1,
			repeats = arg2
		})
	end)
	arg0:bind(AtelierMaterialDetailMediator.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = AtelierMaterialDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)

	local var0 = getProxy(ChapterProxy):getChapterById(1690005, true):isClear()

	arg0.viewComponent:SetEnabled(var0)

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var1 and not var1:isEnd())
	arg0.viewComponent:SetActivity(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.COMPOSITE_ATELIER_RECIPE_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		var0.OPEN_FORMULA
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COMPOSITE_ATELIER_RECIPE_DONE then
		arg0.viewComponent:OnCompositeResult(var1)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ATELIER_LINK then
			arg0.viewComponent:SetActivity(var1)
		end
	elseif var0 == var0.OPEN_FORMULA then
		arg0.viewComponent:OnReceiveFormualRequest(var1)
	end
end

function var0.remove(arg0)
	return
end

return var0
