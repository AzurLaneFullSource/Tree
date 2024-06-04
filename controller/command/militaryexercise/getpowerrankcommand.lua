local var0 = class("GetPowerRankCommand", pm.SimpleCommand)
local var1 = 100
local var2 = 5

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.activityId

	assert(var1, "type can not be nil")

	local var3 = getProxy(BillboardProxy)

	local function var4(arg0, arg1)
		var3:setRankList(var1, var2, arg0)
		var3:setPlayerRankData(var1, var2, arg1)
		arg0:sendNotification(GAME.GET_POWERRANK_DONE, {
			list = arg0,
			type = var1,
			playerRankinfo = arg1,
			activityId = var2
		})
	end

	if var1 == PowerRank.TYPE_MILITARY_RANK then
		pg.ConnectionMgr.GetInstance():Send(18006, {
			type = 0
		}, 18007, function(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.arena_rank_lsit) do
				local var1 = PowerRank.New(iter1, var1)

				var1:setRank(iter0)
				var1:setArenaRank(SeasonInfo.getEmblem(iter1.score, iter0))
				table.insert(var0, var1)
			end

			local var2 = getProxy(PlayerProxy):getData()
			local var3 = getProxy(BayProxy):getShipById(var2.character)
			local var4 = {
				id = var2.id,
				level = var2.level,
				name = var2.name,
				score = var2.score,
				arena_rank = SeasonInfo.getEmblem(var2.score, var2.rank),
				icon = var3:getConfig("id"),
				skin_id = var3.skinId,
				propose = var3.propose and 1 or 0,
				remoulded = var3:isRemoulded() and 1 or 0
			}
			local var5 = PowerRank.New(var4, var1)

			var5:setRank(var2.rank)
			var4(var0, var5)
		end)
	else
		local var5 = {}

		local function var6(arg0, arg1)
			if #var5 < (arg0 - 1) * (var1 / var2) then
				arg1()

				return
			end

			pg.ConnectionMgr.GetInstance():Send(18201, {
				page = arg0,
				type = var1,
				act_id = var2 or 0
			}, 18202, function(arg0)
				for iter0, iter1 in ipairs(arg0.list) do
					local var0 = PowerRank.New(iter1, var1)

					table.insert(var5, var0)
				end

				arg1()
			end)
		end

		local var7

		local function var8(arg0)
			pg.ConnectionMgr.GetInstance():Send(18203, {
				type = var1,
				act_id = var2 or 0
			}, 18204, function(arg0)
				local var0 = getProxy(PlayerProxy):getData()
				local var1 = getProxy(BayProxy):getShipById(var0.character)
				local var2

				if var1 == PowerRank.TYPE_POWER then
					var2 = getProxy(BayProxy):getBayPower()
				elseif var1 == PowerRank.TYPE_COLLECTION then
					var2 = getProxy(CollectionProxy):getCollectionCount()
				elseif var1 == PowerRank.TYPE_PT or var1 == PowerRank.TYPE_ACT_BOSS_BATTLE then
					assert(var2)

					local var3 = getProxy(ActivityProxy):getActivityById(var2)

					var2 = var3 and var3.data1 or arg0.point
				elseif var1 == PowerRank.TYPE_CHALLENGE then
					local var4 = PowerRank:getActivityByRankType(PowerRank.TYPE_CHALLENGE)

					if getProxy(ChallengeProxy):getChallengeInfo() then
						local var5 = var4 and getProxy(ChallengeProxy):getChallengeInfo():getGradeList().seasonMaxScore

						var2 = var4 and var5 or arg0.point
					else
						var2 = arg0.point
					end
				elseif var1 == PowerRank.TYPE_EXTRA_CHAPTER then
					local var6 = PowerRank:getActivityByRankType(PowerRank.TYPE_EXTRA_CHAPTER)

					var2 = var6 and var6.data1 or arg0.point
				elseif var1 == PowerRank.TYPE_BOSSRUSH then
					local var7 = PowerRank:getActivityByRankType(PowerRank.TYPE_BOSSRUSH)

					var2 = var7 and var7.data1 or arg0.point
				else
					var2 = arg0.point
				end

				local var8 = {
					user_id = var0.id,
					point = var2,
					name = var0.name,
					lv = var0.level,
					arena_rank = var0.maxRank,
					icon = var1:getConfig("id"),
					skin_id = var1.skinId,
					propose = var1.propose and 1 or 0,
					remoulded = var1:isRemoulded() and 1 or 0
				}

				var7 = PowerRank.New(var8, var1)

				var7:setRank(arg0.rank)
				arg0()
			end)
		end

		local var9 = {}

		for iter0 = 1, var2 do
			table.insert(var9, function(arg0)
				var6(iter0, arg0)
			end)
		end

		table.insert(var9, function(arg0)
			var8(arg0)
		end)
		seriesAsync(var9, function()
			if #var5 > 0 and var7 then
				local var0 = {}
				local var1 = {}

				local function var2(arg0)
					local var0 = table.indexof(var0, arg0)
					local var1 = 0

					for iter0 = 1, var0 - 1 do
						local var2 = var0[iter0]

						var1 = var1 + var1[var2]
					end

					return var1 + 1
				end

				for iter0, iter1 in ipairs(var5) do
					local var3 = iter1.power

					if not table.contains(var0, var3) then
						table.insert(var0, var3)

						var1[var3] = 1
					else
						var1[var3] = var1[var3] + 1
					end
				end

				table.sort(var0, function(arg0, arg1)
					return arg1 < arg0
				end)

				for iter2, iter3 in ipairs(var5) do
					local var4 = iter3.power
					local var5 = var2(var4)

					iter3:setRank(var5)
				end
			end

			var4(var5, var7)
		end)
	end
end

return var0
