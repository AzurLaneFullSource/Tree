ys.Battle.BattleCardPuzzleConfig = ys.Battle.BattleCardPuzzleConfig or {}

local var0 = ys.Battle.BattleCardPuzzleConfig

var0.baseEnergyGenerateSpeedPerSecond = 1
var0.baseEnergyInitial = 5
var0.BASE_MAX_HAND = 6
var0.moveCardGenerateSpeedPerSecond = 0.5
var0.BASE_MAX_MOVE = 30
var0.BASE_MOVE_ID = 20001
var0.CustomAttrInitList = {
	CardComboMin = 0,
	CardComboMax = 50
}
var0.FleetAttrClamp = {
	CardCombo = {
		max = "CardComboMax",
		min = "CardComboMin"
	}
}
var0.FleetIconRegisterAttr = {
	CardCombo = 202,
	CardAntiaircraft = 202
}
var0.FleetIconRegisterBuff = {
	[530050] = 202
}
