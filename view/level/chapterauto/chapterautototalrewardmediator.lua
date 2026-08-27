local var0_0 = class("ChapterAutoTotalRewardMediator", import("view.base.ContextMediator"))

var0_0.GET_NEW_SHIP = "ChapterAutoTotalRewardMediator:GET_NEW_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_NEW_SHIP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1_2,
				canSkipBatch = not arg2_2,
				skipBatchType = NewShipMediator.SKIP_TYPE.CHAPTER_AUTO_AWARD
			},
			onRemoved = arg3_2
		}))
	end)
end

return var0_0
