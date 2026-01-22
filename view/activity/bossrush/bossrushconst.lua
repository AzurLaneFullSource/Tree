local var0_0 = class("BossRushConst")

function var0_0.GetPassedLayer(arg0_1)
	return switch(arg0_1, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitPassedLayer
		end,
		[ActivityConst.ZENGKEHAIJUNSHANGJIANG_BOSS_RUSH_ID] = function()
			return BossRushVerZenkerPassedLayer
		end
	}, function()
		local var0_4 = checkExist(pg.activity_template[arg0_1], {
			"config_client"
		}, {
			"passed"
		})

		return var0_4 and _G[var0_4] or BossRushPassedLayer
	end)
end

function var0_0.GetEXBattleResultLayer(arg0_5)
	return switch(arg0_5, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitEXBattleResultLayer
		end,
		[ActivityConst.ZENGKEHAIJUNSHANGJIANG_BOSS_RUSH_ID] = function()
			return BossRushVerZenkerEXBattleResultLayer
		end
	}, function()
		local var0_8 = checkExist(pg.activity_template[arg0_5], {
			"config_client"
		}, {
			"result"
		})

		return var0_8 and _G[var0_8] or BossRushEXBattleResultLayer
	end)
end

return var0_0
