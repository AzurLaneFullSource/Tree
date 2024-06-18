local var0_0 = class("MainReceiveBossRushAwardsSequence")

function var0_0.Execute(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

			if not var0_2 or var0_2:isEnd() or not var0_2:HasAwards() then
				arg0_2()

				return
			end

			seriesAsync({
				function(arg0_3)
					pg.m02:sendNotification(GAME.BOSSRUSH_SETTLE, {
						actId = var0_2.id,
						callback = arg0_3
					})
				end,
				function(arg0_4, arg1_4)
					local var0_4 = arg1_4.awards

					if #var0_4 > 0 then
						LoadContextCommand.LoadLayerOnTopContext(Context.New({
							mediator = AwardInfoMediator,
							viewComponent = AwardInfoLayer,
							data = {
								items = var0_4,
								removeFunc = arg0_4
							}
						}))

						return
					end

					arg0_4()
				end,
				arg0_2
			})
		end,
		arg1_1
	})
end

return var0_0
