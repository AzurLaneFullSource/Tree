local var0 = class("MonthSignPageTool")

function var0.Ctor(arg0, arg1)
	arg0._event = arg1
end

function var0.onAcheve(arg0, arg1, arg2)
	local var0

	local function var1()
		if var0 and coroutine.status(var0) == "suspended" then
			local var0, var1 = coroutine.resume(var0)

			assert(var0, var1)
		end
	end

	var0 = coroutine.create(function()
		if table.getCount(arg1) > 0 then
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MONTH_SIGN_ACTIVITY_ID)
			local var1 = pg.activity_month_sign[var0.data2].resign_count
			local var2 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3 = pg.TimeMgr.GetInstance():STimeDescS(var2, "*t")

			if var0:getSpecialData("reMonthSignDay") ~= nil then
				arg0.reMonthSignItems = arg0.reMonthSignItems and arg0.reMonthSignItems or {}

				for iter0, iter1 in pairs(arg1) do
					table.insert(arg0.reMonthSignItems, iter1)
				end

				if var3.day > #var0.data1_list and var1 > var0.data3 then
					Timer.New(function()
						arg2()
					end, 0.3, 1):Start()

					return
				else
					arg0._event:emit(MonthSignPage.SHOW_RE_MONTH_SIGN, arg0.reMonthSignItems, var1)

					arg1 = arg0.reMonthSignItems
				end
			else
				arg0.reMonthSignItems = nil

				arg0._event:emit(BaseUI.ON_AWARD, {
					items = arg1,
					removeFunc = var1
				})
			end

			coroutine.yield()

			local var4 = #_.filter(arg1, function(arg0)
				return arg0.type == DROP_TYPE_SHIP
			end)
			local var5 = _.filter(arg1, function(arg0)
				return arg0.type == DROP_TYPE_OPERATION
			end)
			local var6 = var4 + #var5
			local var7 = getProxy(BayProxy)
			local var8 = var7:getNewShip(true)

			_.each(var5, function(arg0)
				table.insert(var8, var7:getShipById(arg0.id))
			end)

			if var6 <= (pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value or 20) then
				for iter2 = math.max(1, #var8 - var6 + 1), #var8 do
					arg0._event:emit(ActivityMediator.OPEN_LAYER, Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = var8[iter2]
						},
						onRemoved = var1
					}))
					coroutine.yield()
				end
			end

			for iter3, iter4 in pairs(arg1) do
				if iter4.type == DROP_TYPE_SKIN then
					if pg.ship_skin_template[iter4.id].skin_type == ShipSkin.SKIN_TYPE_REMAKE then
						-- block empty
					elseif not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter4.id) then
						arg0._event:emit(ActivityMediator.OPEN_LAYER, Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								skinId = iter4.id
							},
							onRemoved = var1
						}))
					end

					coroutine.yield()
				end
			end
		end

		if arg2 then
			arg2()
		end
	end)

	var1()
end

return var0
