local var0_0 = class("TechnologyTreeNationMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(TechnologyConst.CLICK_UP_TEC_BTN, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.START_CAMP_TEC, {
			tecID = arg1_2,
			levelID = arg2_2
		})
	end)
	arg0_1:bind(TechnologyConst.FINISH_UP_TEC, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.FINISH_CAMP_TEC, {
			tecID = arg1_3,
			levelID = arg2_3
		})
	end)
	arg0_1:bind(TechnologyConst.OPEN_ALL_BUFF_DETAIL, function()
		arg0_1:addSubLayers(Context.New({
			mediator = AllBuffDetailMediator,
			viewComponent = AllBuffDetailLayer,
			data = {}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		TechnologyConst.START_TEC_BTN_SUCCESS,
		TechnologyConst.FINISH_TEC_SUCCESS,
		TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION,
		TechnologyConst.GOT_TEC_CAMP_AWARD,
		TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == TechnologyConst.START_TEC_BTN_SUCCESS then
		arg0_6.viewComponent:updateTecListData()
		arg0_6.viewComponent:updateTecItem(var1_6)
	elseif var0_6 == TechnologyConst.FINISH_TEC_SUCCESS then
		arg0_6.viewComponent:updateTecListData()
		arg0_6.viewComponent:updateTecItem(var1_6)
	elseif var0_6 == TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION then
		arg0_6.viewComponent:closeMyself()
	elseif var0_6 == TechnologyConst.GOT_TEC_CAMP_AWARD then
		local var2_6 = var1_6.awardList
		local var3_6 = var1_6.groupID
		local var4_6 = var1_6.tecID

		arg0_6.viewComponent:updateTecItem(var3_6)
		arg0_6.viewComponent:updateOneStepBtn()
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var2_6)
	elseif var0_6 == TechnologyConst.GOT_TEC_CAMP_AWARD_ONESTEP then
		local var5_6 = var1_6.awardList

		arg0_6.viewComponent:updateTecItemList()
		arg0_6.viewComponent:updateOneStepBtn()
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var5_6)
	end
end

return var0_0
