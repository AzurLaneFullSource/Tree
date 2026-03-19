local var0_0 = class("NewEducateGetRankCommand", pm.SimpleCommand)
local var1_0 = 100
local var2_0 = 5

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.tbId
	local var3_1 = getProxy(PlayerProxy):getData().id
	local var4_1
	local var5_1 = {}

	local function var6_1(arg0_2, arg1_2)
		if #var5_1 < (arg0_2 - 1) * (var1_0 / var2_0) then
			arg1_2()

			return
		end

		pg.ConnectionMgr.GetInstance():Send(18201, {
			page = arg0_2,
			type = var1_1,
			act_id = var2_1
		}, 18202, function(arg0_3)
			for iter0_3, iter1_3 in ipairs(arg0_3.list) do
				local var0_3 = PowerRank.New(iter1_3, var1_1)

				var0_3:setArenaRank(iter1_3.arena_rank)
				table.insert(var5_1, var0_3)

				if var0_3.id == var3_1 then
					var4_1 = var0_3
				end
			end

			arg1_2()
		end)
	end

	local function var7_1(arg0_4)
		pg.ConnectionMgr.GetInstance():Send(18203, {
			type = var1_1,
			act_id = var2_1
		}, 18204, function(arg0_5)
			local var0_5 = getProxy(PlayerProxy):getData()
			local var1_5 = getProxy(NewEducateProxy):GetCurChar():GetCallName()
			local var2_5 = getProxy(BayProxy):getShipById(var0_5.character)
			local var3_5 = {
				user_id = var0_5.id,
				point = arg0_5.point,
				name = var0_5.name .. "|" .. var1_5,
				lv = var0_5.level,
				arena_rank = var0_5.maxRank,
				icon = var2_5:getConfig("id"),
				skin_id = var2_5.skinId,
				propose = var2_5.propose and 1 or 0,
				remoulded = var2_5:isRemoulded() and 1 or 0
			}

			var4_1 = PowerRank.New(var3_5, var1_1)

			var4_1:setRank(arg0_5.rank)
			arg0_4()
		end)
	end

	local var8_1 = {}

	for iter0_1 = 1, var2_0 do
		table.insert(var8_1, function(arg0_6)
			var6_1(iter0_1, arg0_6)
		end)
	end

	table.insert(var8_1, function(arg0_7)
		if not var4_1 then
			var7_1(arg0_7)
		else
			arg0_7()
		end
	end)
	seriesAsync(var8_1, function()
		if #var5_1 > 0 then
			arg0_1:HandleSamePoint(var2_1, var5_1)
		end

		local var0_8 = getProxy(BillboardProxy)

		var0_8:setRankList(var1_1, var2_1, var5_1)
		var0_8:setPlayerRankData(var1_1, var2_1, var4_1)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_RANK_DONE, {
			type = var1_1,
			tbId = var2_1,
			list = var5_1,
			playerInfo = var4_1
		})
	end)
end

function var0_0.HandleSamePoint(arg0_9, arg1_9, arg2_9)
	local var0_9 = {}
	local var1_9 = {}

	local function var2_9(arg0_10)
		local var0_10 = table.indexof(var0_9, arg0_10)
		local var1_10 = 0

		for iter0_10 = 1, var0_10 - 1 do
			local var2_10 = var0_9[iter0_10]

			var1_10 = var1_10 + var1_9[var2_10]
		end

		return var1_10 + 1
	end

	for iter0_9, iter1_9 in ipairs(arg2_9) do
		local var3_9 = iter1_9.power

		if not table.contains(var0_9, var3_9) then
			table.insert(var0_9, var3_9)

			var1_9[var3_9] = 1
		else
			var1_9[var3_9] = var1_9[var3_9] + 1
		end
	end

	table.sort(var0_9, function(arg0_11, arg1_11)
		return arg1_11 < arg0_11
	end)

	for iter2_9, iter3_9 in ipairs(arg2_9) do
		local var4_9 = iter3_9.power
		local var5_9 = var2_9(var4_9)

		iter3_9:setRank(var5_9)
	end
end

return var0_0
