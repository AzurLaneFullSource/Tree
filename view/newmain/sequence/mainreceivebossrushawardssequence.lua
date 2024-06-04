local var0 = class("MainReceiveBossRushAwardsSequence")

function var0.Execute(arg0, arg1)
	seriesAsync({
		function(arg0)
			local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

			if not var0 or var0:isEnd() or not var0:HasAwards() then
				arg0()

				return
			end

			seriesAsync({
				function(arg0)
					pg.m02:sendNotification(GAME.BOSSRUSH_SETTLE, {
						actId = var0.id,
						callback = arg0
					})
				end,
				function(arg0, arg1)
					local var0 = arg1.awards

					if #var0 > 0 then
						LoadContextCommand.LoadLayerOnTopContext(Context.New({
							mediator = AwardInfoMediator,
							viewComponent = AwardInfoLayer,
							data = {
								items = var0,
								removeFunc = arg0
							}
						}))

						return
					end

					arg0()
				end,
				arg0
			})
		end,
		arg1
	})
end

return var0
