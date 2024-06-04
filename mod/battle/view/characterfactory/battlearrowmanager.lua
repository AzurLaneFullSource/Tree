ys = ys or {}

local var0 = ys
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = singletonClass("BattleArrowManager")

var0.Battle.BattleArrowManager = var2
var2.__name = "BattleArrowManager"
var2.ROOT_NAME = "EnemyArrowContainer"
var2.ARROW_NAME = "EnemyArrow"

function var2.Ctor(arg0)
	return
end

local var3 = Vector3(0, 10000, 0)

function var2.HideBullet(arg0)
	arg0.transform.position = var3
end

function var2.Init(arg0, arg1)
	local var0 = arg1:Find(var2.ARROW_NAME).gameObject

	var0.transform.position = var3

	var0:SetActive(true)

	local var1 = pg.Pool.New(arg1, var0, 5, 10, true, true)

	var1:SetRecycleFuncs(var2.HideBullet)
	var1:InitSize()

	arg0._arrowPool = var1
end

function var2.Clear(arg0)
	arg0._arrowPool:Dispose()
end

function var2.GetArrow(arg0)
	return (arg0._arrowPool:GetObject())
end

function var2.DestroyObj(arg0, arg1)
	if arg1 == nil then
		return
	end

	arg0._arrowPool:Recycle(arg1)
end
