local var0_0 = class("IslandProductConst")

var0_0.FarmlandPlaceId = 101
var0_0.PasturePlaceId = 102
var0_0.MilkTeaPlaceId = 601
var0_0.MealPlaceId = 602
var0_0.SimpeleMealPlaceId = 603
var0_0.kebabPlaceId = 604
var0_0.MinePlaceId = 401
var0_0.FellingPlaceId = 402
var0_0.TechnologyPlaceId = 702
var0_0.CoffeePlaceId = 901
var0_0.OrchardPlaceId = 501
var0_0.GardenPlaceId = 502
var0_0.FisheryPlaceId = 201
var0_0.WoodProcessingPlaceId = 703
var0_0.MachinePlaceId = 704
var0_0.ElectronicPlaceId = 705
var0_0.HandworkWorkbench = 706
var0_0.FactorytPlaces = {
	var0_0.WoodProcessingPlaceId,
	var0_0.MachinePlaceId,
	var0_0.ElectronicPlaceId,
	var0_0.HandworkWorkbench
}
var0_0.haveModelPlaces = {
	var0_0.WoodProcessingPlaceId,
	var0_0.MachinePlaceId,
	var0_0.ElectronicPlaceId,
	var0_0.HandworkWorkbench,
	var0_0.MilkTeaPlaceId,
	var0_0.MealPlaceId,
	var0_0.SimpeleMealPlaceId,
	var0_0.kebabPlaceId
}
var0_0.havePerformPlace = {
	var0_0.FisheryPlaceId
}
var0_0.PlantPlaceIdLists = {
	var0_0.FarmlandPlaceId,
	var0_0.OrchardPlaceId,
	var0_0.GardenPlaceId
}
var0_0.ProductSlotType = {
	HandPlant = 1,
	RoleDelegation = 2
}

return var0_0
