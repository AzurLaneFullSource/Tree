local var0_0 = class("BossRushConst")

function var0_0.GetPassedLayer(arg0_1)
	return switch(arg0_1, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitPassedLayer
		end
	}, function()
		return BossRushPassedLayer
	end)
end

function var0_0.GetEXBattleResultLayer(arg0_4)
	return switch(arg0_4, {
		[ActivityConst.ALVIT_BOSS_RUSH_ID] = function()
			return BossRushAlvitEXBattleResultLayer
		end
	}, function()
		return BossRushEXBattleResultLayer
	end)
end

return var0_0
