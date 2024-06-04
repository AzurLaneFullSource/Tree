local var0 = class("BattleGateCardPuzzle")

ys.Battle.BattleGateCardPuzzle = var0
var0.__name = "BattleGateCardPuzzle"

function var0.Entrance(arg0, arg1)
	local var0 = arg0.combatID
	local var1 = ys.Battle.BattleDataFunction.GetPuzzleDungeonTemplate(var0)
	local var2 = var1.dungeon_id
	local var3 = {
		CardPuzzleShip.New({
			configId = var1.scout_id
		}),
		CardPuzzleShip.New({
			configId = var1.main_id
		})
	}
	local var4 = var1.deck
	local var5 = {}

	for iter0, iter1 in ipairs(var1.relic) do
		table.insert(var5, CardPuzzleGift.New({
			configId = iter1
		}))
	end

	;(function(arg0)
		local var0 = {
			hp = 1,
			cardPuzzleFleet = var3,
			prefabFleet = {},
			cards = var4,
			relics = var5,
			stageId = var2,
			system = SYSTEM_CARDPUZZLE,
			puzzleCombatID = var0
		}

		arg1:sendNotification(GAME.BEGIN_STAGE_DONE, var0)
	end)()
end

function var0.Exit(arg0, arg1)
	local var0 = arg0.statistics._battleScore

	print(var0)

	if var0 >= ys.Battle.BattleConst.BattleScore.S then
		local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CARD_PUZZLE)

		arg1:sendNotification(GAME.ACT_CARD_PUZZLE, {
			cmd = 1,
			activity_id = var1 and var1.id,
			arg1 = arg0.puzzleCombatID
		})
	end

	local var2 = {
		system = SYSTEM_CARDPUZZLE,
		score = var0
	}

	arg1:sendNotification(GAME.FINISH_STAGE_DONE, var2)
end

return var0
