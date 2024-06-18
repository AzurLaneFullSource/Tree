local var0_0 = class("BattleGateCardPuzzle")

ys.Battle.BattleGateCardPuzzle = var0_0
var0_0.__name = "BattleGateCardPuzzle"

function var0_0.Entrance(arg0_1, arg1_1)
	local var0_1 = arg0_1.combatID
	local var1_1 = ys.Battle.BattleDataFunction.GetPuzzleDungeonTemplate(var0_1)
	local var2_1 = var1_1.dungeon_id
	local var3_1 = {
		CardPuzzleShip.New({
			configId = var1_1.scout_id
		}),
		CardPuzzleShip.New({
			configId = var1_1.main_id
		})
	}
	local var4_1 = var1_1.deck
	local var5_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1.relic) do
		table.insert(var5_1, CardPuzzleGift.New({
			configId = iter1_1
		}))
	end

	;(function(arg0_2)
		local var0_2 = {
			hp = 1,
			cardPuzzleFleet = var3_1,
			prefabFleet = {},
			cards = var4_1,
			relics = var5_1,
			stageId = var2_1,
			system = SYSTEM_CARDPUZZLE,
			puzzleCombatID = var0_1
		}

		arg1_1:sendNotification(GAME.BEGIN_STAGE_DONE, var0_2)
	end)()
end

function var0_0.Exit(arg0_3, arg1_3)
	local var0_3 = arg0_3.statistics._battleScore

	print(var0_3)

	if var0_3 >= ys.Battle.BattleConst.BattleScore.S then
		local var1_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE)

		arg1_3:sendNotification(GAME.ACT_CARD_PUZZLE, {
			cmd = 1,
			activity_id = var1_3 and var1_3.id,
			arg1 = arg0_3.puzzleCombatID
		})
	end

	local var2_3 = {
		system = SYSTEM_CARDPUZZLE,
		score = var0_3
	}

	arg1_3:sendNotification(GAME.FINISH_STAGE_DONE, var2_3)
end

return var0_0
