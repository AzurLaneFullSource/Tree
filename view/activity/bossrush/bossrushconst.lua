local var0_0 = class("BossRushConst")

function var0_0.GetPassedLayer(arg0_1)
	return switch(arg0_1, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitPassedLayer
		end,
		[ActivityConst.ZENGKEHAIJUNSHANGJIANG_BOSS_RUSH_ID] = function()
			return BossRushSardiniaPassedLayer
		end,
		[ActivityConst.ESCAPE_BOSS_RUSH_ID] = function()
			return BossRushEscapeManorPassedLayer
		end
	}, function()
		local var0_5 = checkExist(pg.activity_template[arg0_1], {
			"config_client"
		}, {
			"passed"
		})

		return var0_5 and _G[var0_5] or BossRushPassedCombatLoadLayer
	end)
end

function var0_0.GetEXBattleResultLayer(arg0_6)
	return switch(arg0_6, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitEXBattleResultLayer
		end,
		[ActivityConst.ZENGKEHAIJUNSHANGJIANG_BOSS_RUSH_ID] = function()
			return BossRushVerZenkerEXBattleResultLayer
		end,
		[ActivityConst.ESCAPE_BOSS_RUSH_ID] = function()
			return BossRushEscapeManorBattleResultLayer
		end
	}, function()
		local var0_10 = checkExist(pg.activity_template[arg0_6], {
			"config_client"
		}, {
			"result"
		})

		return var0_10 and _G[var0_10] or BossRushEXBattleResultLayer
	end)
end

return var0_0
