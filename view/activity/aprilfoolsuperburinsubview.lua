local var0 = class("AprilFoolSuperBurinSubView", import(".AprilFoolBulinSubView"))

function var0.getUIName(arg0)
	return "AprilFoolSuperBurinSubView"
end

function var0.OnInit(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	if not var0 or var0:isEnd() then
		arg0:Destroy()

		return
	end

	local var1 = pg.activity_event_picturepuzzle[var0.id]

	assert(var1, "Can't Find activity_event_picturepuzzle 's ID : " .. var0.id)

	arg0.bulin = arg0:findTF("bulin")

	onButton(arg0, arg0.bulin, function()
		local var0 = arg0.pieceId

		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 2,
			isPickUp = true,
			actId = var0.id,
			id = var0,
			callback = function()
				seriesAsync({
					function(arg0)
						local var0 = var1.awards[table.indexof(var1.pickup_picturepuzzle, var0)]

						assert(var0, "Cant Find Award of PieceID " .. var0)
						arg0:emit(BaseUI.ON_ACHIEVE, {
							{
								type = var0[1],
								id = var0[2],
								count = var0[3]
							}
						}, arg0)
					end,
					function(arg0)
						local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

						if #table.mergeArray(var0.data1_list, var0.data2_list, true) < #var1.pickup_picturepuzzle + #var1.drop_picturepuzzle then
							return arg0()
						end

						local var1 = var0:getConfig("config_client").comStory

						pg.NewStoryMgr.GetInstance():Play(var1, arg0)
					end,
					function()
						arg0:Destroy()
					end
				})
			end
		})
	end)
end

return var0
