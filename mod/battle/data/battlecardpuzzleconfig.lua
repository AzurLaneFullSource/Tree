ys.Battle.BattleCardPuzzleConfig = ys.Battle.BattleCardPuzzleConfig or {}

local var0_0 = ys.Battle.BattleCardPuzzleConfig

var0_0.baseEnergyGenerateSpeedPerSecond = 1
var0_0.baseEnergyInitial = 5
var0_0.BASE_MAX_HAND = 6
var0_0.moveCardGenerateSpeedPerSecond = 0.5
var0_0.BASE_MAX_MOVE = 30
var0_0.BASE_MOVE_ID = 20001
var0_0.CustomAttrInitList = {
	CardComboMin = 0,
	CardComboMax = 50
}
var0_0.FleetAttrClamp = {
	CardCombo = {
		max = "CardComboMax",
		min = "CardComboMin"
	}
}
var0_0.FleetIconRegisterAttr = {
	CardCombo = 202,
	CardAntiaircraft = 202
}
var0_0.FleetIconRegisterBuff = {
	[530050] = 202
}
