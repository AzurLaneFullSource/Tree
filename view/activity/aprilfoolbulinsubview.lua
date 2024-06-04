local var0 = class("AprilFoolBulinSubView", import("view.base.BaseSubPanel"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.pieceId = arg2
end

function var0.getUIName(arg0)
	return "AprilFoolBulinSubView"
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
				local var0 = var1.awards[table.indexof(var1.pickup_picturepuzzle, var0)]

				assert(var0, "Cant Find Award of PieceID " .. var0)
				arg0:emit(BaseUI.ON_ACHIEVE, {
					{
						type = var0[1],
						id = var0[2],
						count = var0[3]
					}
				})
				arg0:Destroy()
			end
		})
	end)
end

function var0.SetPosition(arg0, arg1)
	setAnchoredPosition(arg0._tf, arg1)
end

function var0.SetParent(arg0, arg1)
	setParent(arg0._tf, arg1)
end

function var0.ShowAprilFoolBulin(arg0, arg1, arg2)
	local var0
	local var1
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	if not var2 or var2:isEnd() then
		return
	end

	local var3 = pg.activity_event_picturepuzzle[var2.id]

	if not var3 then
		return
	end

	local var4 = table.indexof(var3.pickup_views, arg0.__cname)
	local var5 = var3.pickup_picturepuzzle[var4]

	if not var5 or table.contains(var2.data2_list, var5) then
		return
	end

	local var6 = _G[var2:getConfig("config_client").subView]

	if not var6 then
		return
	end

	local var7 = var6.New(arg0, var5)

	var7:Load()

	if arg1 then
		var7.buffer:SetParent(arg1)
	end

	if arg2 then
		var7.buffer:SetPosition(arg2)
	end

	return var7
end

return var0
