ys = ys or {}

local var0 = ys
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = singletonClass("BattleHPBarManager")

var0.Battle.BattleHPBarManager = var2
var2.__name = "BattleHPBarManager"
var2.ROOT_NAME = "HPBarContainer"
var2.HP_BAR_FRIENDLY = "heroBlood"
var2.HP_BAR_FOE = "enemyBlood"
var2.ORIGIN_BAR_WIDTH = {
	heroBlood = 70,
	enemyBlood = 154
}
var2.ORIGIN_PROGRESS_WIDTH = {
	heroBlood = 66,
	enemyBlood = 153
}

function var2.Ctor(arg0)
	return
end

function var2.Init(arg0, arg1, arg2)
	arg0._allPool = {}
	arg0._ob2Pool = {}
	arg0._allPool[var2.HP_BAR_FRIENDLY] = var2.generateTempPool(var2.HP_BAR_FRIENDLY, arg2, arg1, 3, 10)
	arg0._allPool[var2.HP_BAR_FOE] = var2.generateTempPool(var2.HP_BAR_FOE, arg2, arg1, 8, 10)
end

function var2.InitialPoolRoot(arg0, arg1)
	arg0._allPool[var2.HP_BAR_FRIENDLY]:ResetParent(arg1)
	arg0._allPool[var2.HP_BAR_FOE]:ResetParent(arg1)
end

function var2.Clear(arg0)
	for iter0, iter1 in pairs(arg0._allPool) do
		iter1:Dispose()
	end

	arg0._ob2Pool = {}
	arg0._allPool = {}
end

function var2.GetHPBar(arg0, arg1)
	local var0 = arg0._allPool[arg1]
	local var1 = var0:GetObject()

	arg0._ob2Pool[var1] = var0

	local var2 = var1.transform

	var2:Find("blood"):GetComponent(typeof(Image)).fillAmount = 1

	local var3 = var2:Find("type")

	if var3 then
		SetActive(var3, false)
	end

	local var4 = var2:Find("torpedoIcons")

	if var4 then
		SetActive(var4, false)
	end

	local var5 = var2:Find("biasBar")

	if var5 then
		SetActive(var5, false)
	end

	return var1
end

function var2.DestroyObj(arg0, arg1)
	if arg1 == nil then
		return
	end

	local var0 = arg0._ob2Pool[arg1]

	if var0 then
		var0:Recycle(arg1)
	else
		Object.Destroy(arg1)
	end
end

local var3 = Vector3(0, 10000, 0)

function var2.HideBullet(arg0)
	arg0.transform.position = var3
end

function var2.generateTempPool(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg2.transform:Find(arg0).gameObject

	var0.transform.position = var3

	var0:SetActive(true)

	local var1 = pg.Pool.New(arg1, var0, arg3, arg4, true, true)

	var1:SetRecycleFuncs(var2.HideBullet)
	var1:InitSize()

	return var1
end
