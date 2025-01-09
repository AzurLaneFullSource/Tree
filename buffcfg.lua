local var0_0 = {}

pg.buffCfg = setmetatable({}, {
	__index = function(arg0_1, arg1_1)
		if var0_0[arg1_1] then
			return true
		else
			var0_0[arg1_1] = true

			local var0_1 = {
				"GameCfg.buff." .. arg1_1
			}

			if LUA_CONFIG_EXTRA then
				table.insert(var0_1, "GameCfg.battle_lua.buff_extra." .. arg1_1)
			end

			for iter0_1, iter1_1 in ipairs(var0_1) do
				if pcall(function()
					arg0_1[arg1_1] = require(iter1_1)
				end) then
					return arg0_1[arg1_1]
				end
			end

			if IsUnityEditor then
				warning("找不到技能配置: " .. "GameCfg.buff." .. arg1_1)
			end

			return nil
		end
	end
})

ys.Battle.BattleDataFunction.ConvertBuffTemplate()
