local var0_0 = class("AprilFoolSuperBurinSubView", import(".AprilFoolBulinSubView"))

function var0_0.getUIName(arg0_1)
	return "AprilFoolSuperBurinSubView"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	if not var0_2 or var0_2:isEnd() then
		arg0_2:Destroy()

		return
	end

	local var1_2 = pg.activity_event_picturepuzzle[var0_2.id]

	assert(var1_2, "Can't Find activity_event_picturepuzzle 's ID : " .. var0_2.id)

	arg0_2.bulin = arg0_2:findTF("bulin")

	onButton(arg0_2, arg0_2.bulin, function()
		local var0_3 = arg0_2.pieceId

		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			actId = var0_2.id,
			id = var0_3,
			cmd = PuzzleActivity.CMD_ACTIVATE,
			callback = function()
				seriesAsync({
					function(arg0_5)
						local var0_5 = var1_2.awards[table.indexof(var1_2.pickup_picturepuzzle, var0_3)]

						assert(var0_5, "Cant Find Award of PieceID " .. var0_3)
						arg0_2:emit(BaseUI.ON_ACHIEVE, {
							{
								type = var0_5[1],
								id = var0_5[2],
								count = var0_5[3]
							}
						}, arg0_5)
					end,
					function(arg0_6)
						local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

						if #table.mergeArray(var0_6.data1_list, var0_6.data2_list, true) < #var1_2.pickup_picturepuzzle + #var1_2.drop_picturepuzzle then
							return arg0_6()
						end

						local var1_6 = var0_6:getConfig("config_client").comStory

						pg.NewStoryMgr.GetInstance():Play(var1_6, arg0_6)
					end,
					function()
						arg0_2:Destroy()
					end
				})
			end
		})
	end)
end

return var0_0
