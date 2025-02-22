local var0_0 = class("MainActToLoveBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_tolove"
end

function var0_0.GetActivityID(arg0_2)
	local var0_2 = checkExist(arg0_2.config, {
		"time"
	})

	if not var0_2 then
		return nil
	end

	return var0_2[1] == "default" and var0_2[2] or nil
end

function var0_0.OnClick(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_MINIGAME_TASK_ID)

	if var0_3 == nil or var0_3:isEnd() then
		pg.m02:sendNotification(GAME.LOAD_LAYERS, {
			parentContext = getProxy(ContextProxy):getCurrentContext(),
			context = Context.New({
				mediator = MedalCollectionTemplateMediator,
				viewComponent = ToLoveCollabMedalView,
				weight = LayerWeightConst.TOP_LAYER
			})
		})
	else
		var0_0.super.OnClick(arg0_3)
	end
end

function var0_0.OnInit(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_MINIGAME_TASK_ID)

	if var0_4 ~= nil and not var0_4:isEnd() then
		local var1_4 = ToLoveCollabBackHillScene.IsShowMainTip()

		setActive(arg0_4.tipTr.gameObject, var1_4)
	else
		setActive(arg0_4.tipTr.gameObject, false)
	end
end

return var0_0
