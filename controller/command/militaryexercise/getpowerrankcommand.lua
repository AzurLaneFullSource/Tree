local var0_0 = class("GetPowerRankCommand", pm.SimpleCommand)
local var1_0 = 100
local var2_0 = 5

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.activityId

	assert(var1_1, "type can not be nil")

	local var3_1 = getProxy(BillboardProxy)

	local function var4_1(arg0_2, arg1_2)
		var3_1:setRankList(var1_1, var2_1, arg0_2)
		var3_1:setPlayerRankData(var1_1, var2_1, arg1_2)
		arg0_1:sendNotification(GAME.GET_POWERRANK_DONE, {
			list = arg0_2,
			type = var1_1,
			playerRankinfo = arg1_2,
			activityId = var2_1
		})
	end

	if var1_1 == PowerRank.TYPE_MILITARY_RANK then
		pg.ConnectionMgr.GetInstance():Send(18006, {
			type = 0
		}, 18007, function(arg0_3)
			local var0_3 = {}

			for iter0_3, iter1_3 in ipairs(arg0_3.arena_rank_lsit) do
				local var1_3 = PowerRank.New(iter1_3, var1_1)

				var1_3:setRank(iter0_3)
				var1_3:setArenaRank(SeasonInfo.getEmblem(iter1_3.score, iter0_3))
				table.insert(var0_3, var1_3)
			end

			local var2_3 = getProxy(PlayerProxy):getData()
			local var3_3 = getProxy(BayProxy):getShipById(var2_3.character)
			local var4_3 = {
				id = var2_3.id,
				level = var2_3.level,
				name = var2_3.name,
				score = var2_3.score,
				arena_rank = SeasonInfo.getEmblem(var2_3.score, var2_3.rank),
				icon = var3_3:getConfig("id"),
				skin_id = var3_3.skinId,
				propose = var3_3.propose and 1 or 0,
				remoulded = var3_3:isRemoulded() and 1 or 0
			}
			local var5_3 = PowerRank.New(var4_3, var1_1)

			var5_3:setRank(var2_3.rank)
			var4_1(var0_3, var5_3)
		end)
	else
		local var5_1 = {}

		local function var6_1(arg0_4, arg1_4)
			if #var5_1 < (arg0_4 - 1) * (var1_0 / var2_0) then
				arg1_4()

				return
			end

			pg.ConnectionMgr.GetInstance():Send(18201, {
				page = arg0_4,
				type = var1_1,
				act_id = var2_1 or 0
			}, 18202, function(arg0_5)
				for iter0_5, iter1_5 in ipairs(arg0_5.list) do
					local var0_5 = PowerRank.New(iter1_5, var1_1)

					table.insert(var5_1, var0_5)
				end

				arg1_4()
			end)
		end

		local var7_1

		local function var8_1(arg0_6)
			pg.ConnectionMgr.GetInstance():Send(18203, {
				type = var1_1,
				act_id = var2_1 or 0
			}, 18204, function(arg0_7)
				local var0_7 = getProxy(PlayerProxy):getData()
				local var1_7 = getProxy(BayProxy):getShipById(var0_7.character)
				local var2_7

				if var1_1 == PowerRank.TYPE_POWER then
					var2_7 = getProxy(BayProxy):getBayPower()
				elseif var1_1 == PowerRank.TYPE_COLLECTION then
					var2_7 = getProxy(CollectionProxy):getCollectionCount()
				elseif var1_1 == PowerRank.TYPE_PT or var1_1 == PowerRank.TYPE_ACT_BOSS_BATTLE then
					assert(var2_1)

					local var3_7 = getProxy(ActivityProxy):getActivityById(var2_1)

					var2_7 = var3_7 and var3_7.data1 or arg0_7.point
				elseif var1_1 == PowerRank.TYPE_CHALLENGE then
					local var4_7 = PowerRank:getActivityByRankType(PowerRank.TYPE_CHALLENGE)

					if getProxy(ChallengeProxy):getChallengeInfo() then
						local var5_7 = var4_7 and getProxy(ChallengeProxy):getChallengeInfo():getGradeList().seasonMaxScore

						var2_7 = var4_7 and var5_7 or arg0_7.point
					else
						var2_7 = arg0_7.point
					end
				elseif var1_1 == PowerRank.TYPE_EXTRA_CHAPTER then
					local var6_7 = PowerRank:getActivityByRankType(PowerRank.TYPE_EXTRA_CHAPTER)

					var2_7 = var6_7 and var6_7.data1 or arg0_7.point
				elseif var1_1 == PowerRank.TYPE_BOSSRUSH then
					local var7_7 = PowerRank:getActivityByRankType(PowerRank.TYPE_BOSSRUSH)

					var2_7 = var7_7 and var7_7.data1 or arg0_7.point
				else
					var2_7 = arg0_7.point
				end

				local var8_7 = {
					user_id = var0_7.id,
					point = var2_7,
					name = var0_7.name,
					lv = var0_7.level,
					arena_rank = var0_7.maxRank,
					icon = var1_7:getConfig("id"),
					skin_id = var1_7.skinId,
					propose = var1_7.propose and 1 or 0,
					remoulded = var1_7:isRemoulded() and 1 or 0
				}

				var7_1 = PowerRank.New(var8_7, var1_1)

				var7_1:setRank(arg0_7.rank)
				arg0_6()
			end)
		end

		local var9_1 = {}

		for iter0_1 = 1, var2_0 do
			table.insert(var9_1, function(arg0_8)
				var6_1(iter0_1, arg0_8)
			end)
		end

		table.insert(var9_1, function(arg0_9)
			var8_1(arg0_9)
		end)
		seriesAsync(var9_1, function()
			if #var5_1 > 0 and var7_1 then
				local var0_10 = {}
				local var1_10 = {}

				local function var2_10(arg0_11)
					local var0_11 = table.indexof(var0_10, arg0_11)
					local var1_11 = 0

					for iter0_11 = 1, var0_11 - 1 do
						local var2_11 = var0_10[iter0_11]

						var1_11 = var1_11 + var1_10[var2_11]
					end

					return var1_11 + 1
				end

				for iter0_10, iter1_10 in ipairs(var5_1) do
					local var3_10 = iter1_10.power

					if not table.contains(var0_10, var3_10) then
						table.insert(var0_10, var3_10)

						var1_10[var3_10] = 1
					else
						var1_10[var3_10] = var1_10[var3_10] + 1
					end
				end

				table.sort(var0_10, function(arg0_12, arg1_12)
					return arg1_12 < arg0_12
				end)

				for iter2_10, iter3_10 in ipairs(var5_1) do
					local var4_10 = iter3_10.power
					local var5_10 = var2_10(var4_10)

					iter3_10:setRank(var5_10)
				end
			end

			var4_1(var5_1, var7_1)
		end)
	end
end

return var0_0
