local var0_0 = class("MonthSignPageTool")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._event = arg1_1
end

function var0_0.onAcheve(arg0_2, arg1_2, arg2_2)
	local var0_2

	local function var1_2()
		if var0_2 and coroutine.status(var0_2) == "suspended" then
			local var0_3, var1_3 = coroutine.resume(var0_2)

			assert(var0_3, var1_3)
		end
	end

	var0_2 = coroutine.create(function()
		if table.getCount(arg1_2) > 0 then
			local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.MONTH_SIGN_ACTIVITY_ID)
			local var1_4 = pg.activity_month_sign[var0_4.data2].resign_count
			local var2_4 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_4 = pg.TimeMgr.GetInstance():STimeDescS(var2_4, "*t")

			if var0_4:getSpecialData("reMonthSignDay") ~= nil then
				arg0_2.reMonthSignItems = arg0_2.reMonthSignItems and arg0_2.reMonthSignItems or {}

				for iter0_4, iter1_4 in pairs(arg1_2) do
					table.insert(arg0_2.reMonthSignItems, iter1_4)
				end

				if var3_4.day > #var0_4.data1_list and var1_4 > var0_4.data3 then
					Timer.New(function()
						arg2_2()
					end, 0.3, 1):Start()

					return
				else
					arg0_2._event:emit(MonthSignPage.SHOW_RE_MONTH_SIGN, arg0_2.reMonthSignItems, var1_2)

					arg1_2 = arg0_2.reMonthSignItems
				end
			else
				arg0_2.reMonthSignItems = nil

				arg0_2._event:emit(BaseUI.ON_AWARD, {
					items = arg1_2,
					removeFunc = var1_2
				})
			end

			coroutine.yield()

			local var4_4 = #_.filter(arg1_2, function(arg0_6)
				return arg0_6.type == DROP_TYPE_SHIP
			end)
			local var5_4 = _.filter(arg1_2, function(arg0_7)
				return arg0_7.type == DROP_TYPE_OPERATION
			end)
			local var6_4 = var4_4 + #var5_4
			local var7_4 = getProxy(BayProxy)
			local var8_4 = var7_4:getNewShip(true)

			_.each(var5_4, function(arg0_8)
				table.insert(var8_4, var7_4:getShipById(arg0_8.id))
			end)

			if var6_4 <= (pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value or 20) then
				for iter2_4 = math.max(1, #var8_4 - var6_4 + 1), #var8_4 do
					arg0_2._event:emit(ActivityMediator.OPEN_LAYER, Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = var8_4[iter2_4]
						},
						onRemoved = var1_2
					}))
					coroutine.yield()
				end
			end

			for iter3_4, iter4_4 in pairs(arg1_2) do
				if iter4_4.type == DROP_TYPE_SKIN then
					if pg.ship_skin_template[iter4_4.id].skin_type == ShipSkin.SKIN_TYPE_REMAKE then
						-- block empty
					elseif not getProxy(ShipSkinProxy):hasOldNonLimitSkin(iter4_4.id) then
						arg0_2._event:emit(ActivityMediator.OPEN_LAYER, Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								skinId = iter4_4.id
							},
							onRemoved = var1_2
						}))
					end

					coroutine.yield()
				end
			end
		end

		if arg2_2 then
			arg2_2()
		end
	end)

	var1_2()
end

return var0_0
