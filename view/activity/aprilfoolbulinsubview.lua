local var0_0 = class("AprilFoolBulinSubView", import("view.base.BaseSubPanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.pieceId = arg2_1
end

function var0_0.getUIName(arg0_2)
	return "AprilFoolBulinSubView"
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	if not var0_3 or var0_3:isEnd() then
		arg0_3:Destroy()

		return
	end

	local var1_3 = pg.activity_event_picturepuzzle[var0_3.id]

	assert(var1_3, "Can't Find activity_event_picturepuzzle 's ID : " .. var0_3.id)

	arg0_3.bulin = arg0_3:findTF("bulin")

	onButton(arg0_3, arg0_3.bulin, function()
		local var0_4 = arg0_3.pieceId

		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 2,
			isPickUp = true,
			actId = var0_3.id,
			id = var0_4,
			callback = function()
				local var0_5 = var1_3.awards[table.indexof(var1_3.pickup_picturepuzzle, var0_4)]

				assert(var0_5, "Cant Find Award of PieceID " .. var0_4)
				arg0_3:emit(BaseUI.ON_ACHIEVE, {
					{
						type = var0_5[1],
						id = var0_5[2],
						count = var0_5[3]
					}
				})
				arg0_3:Destroy()
			end
		})
	end)
end

function var0_0.SetPosition(arg0_6, arg1_6)
	setAnchoredPosition(arg0_6._tf, arg1_6)
end

function var0_0.SetParent(arg0_7, arg1_7)
	setParent(arg0_7._tf, arg1_7)
end

function var0_0.ShowAprilFoolBulin(arg0_8, arg1_8, arg2_8)
	local var0_8
	local var1_8
	local var2_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	if not var2_8 or var2_8:isEnd() then
		return
	end

	local var3_8 = pg.activity_event_picturepuzzle[var2_8.id]

	if not var3_8 then
		return
	end

	local var4_8 = table.indexof(var3_8.pickup_views, arg0_8.__cname)
	local var5_8 = var3_8.pickup_picturepuzzle[var4_8]

	if not var5_8 or table.contains(var2_8.data2_list, var5_8) then
		return
	end

	local var6_8 = _G[var2_8:getConfig("config_client").subView]

	if not var6_8 then
		return
	end

	local var7_8 = var6_8.New(arg0_8, var5_8)

	var7_8:Load()

	if arg1_8 then
		var7_8.buffer:SetParent(arg1_8)
	end

	if arg2_8 then
		var7_8.buffer:SetPosition(arg2_8)
	end

	return var7_8
end

return var0_0
