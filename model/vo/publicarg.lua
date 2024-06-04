local var0 = class("PublicArg")

var0.TypePlayerName = 1
var0.TypeShipId = 2
var0.TypeEquipId = 3
var0.TypeItemId = 4
var0.TypeNums = 5
var0.TypeWorldBoss = 6

function var0.Ctor(arg0, arg1)
	arg0.type = arg1.type
	arg0.string = arg1.string
	arg0.int = arg1.int
end

return var0
