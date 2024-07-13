ys = ys or {}

local var0_0 = ys
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = singletonClass("BattleArrowManager")

var0_0.Battle.BattleArrowManager = var2_0
var2_0.__name = "BattleArrowManager"
var2_0.ROOT_NAME = "EnemyArrowContainer"
var2_0.ARROW_NAME = "EnemyArrow"

function var2_0.Ctor(arg0_1)
	return
end

local var3_0 = Vector3(0, 10000, 0)

function var2_0.HideBullet(arg0_2)
	arg0_2.transform.position = var3_0
end

function var2_0.Init(arg0_3, arg1_3)
	local var0_3 = arg1_3:Find(var2_0.ARROW_NAME).gameObject

	var0_3.transform.position = var3_0

	var0_3:SetActive(true)

	local var1_3 = pg.Pool.New(arg1_3, var0_3, 5, 10, true, true)

	var1_3:SetRecycleFuncs(var2_0.HideBullet)
	var1_3:InitSize()

	arg0_3._arrowPool = var1_3
end

function var2_0.Clear(arg0_4)
	arg0_4._arrowPool:Dispose()
end

function var2_0.GetArrow(arg0_5)
	return (arg0_5._arrowPool:GetObject())
end

function var2_0.DestroyObj(arg0_6, arg1_6)
	if arg1_6 == nil then
		return
	end

	arg0_6._arrowPool:Recycle(arg1_6)
end
