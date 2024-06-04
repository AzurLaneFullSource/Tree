local var0 = class("TechnologyTreeNationMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(TechnologyConst.CLICK_UP_TEC_BTN, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.START_CAMP_TEC, {
			tecID = arg1,
			levelID = arg2
		})
	end)
	arg0:bind(TechnologyConst.FINISH_UP_TEC, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FINISH_CAMP_TEC, {
			tecID = arg1,
			levelID = arg2
		})
	end)
	arg0:bind(TechnologyConst.OPEN_ALL_BUFF_DETAIL, function()
		arg0:addSubLayers(Context.New({
			mediator = AllBuffDetailMediator,
			viewComponent = AllBuffDetailLayer,
			data = {}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		TechnologyConst.START_TEC_BTN_SUCCESS,
		TechnologyConst.FINISH_TEC_SUCCESS,
		TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION,
		TechnologyConst.GOT_TEC_CAMP_AWARD,
		TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TechnologyConst.START_TEC_BTN_SUCCESS then
		arg0.viewComponent:updateTecListData()
		arg0.viewComponent:updateTecItem(var1)
	elseif var0 == TechnologyConst.FINISH_TEC_SUCCESS then
		arg0.viewComponent:updateTecListData()
		arg0.viewComponent:updateTecItem(var1)
	elseif var0 == TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION then
		arg0.viewComponent:closeMyself()
	elseif var0 == TechnologyConst.GOT_TEC_CAMP_AWARD then
		local var2 = var1.awardList
		local var3 = var1.groupID
		local var4 = var1.tecID

		arg0.viewComponent:updateTecItem(var3)
		arg0.viewComponent:updateOneStepBtn()
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var2)
	elseif var0 == TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP then
		local var5 = var1.awardList

		arg0.viewComponent:updateTecItemList()
		arg0.viewComponent:updateOneStepBtn()
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var5)
	end
end

return var0
