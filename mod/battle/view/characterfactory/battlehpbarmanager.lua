ys = ys or {}

local var0_0 = ys
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = singletonClass("BattleHPBarManager")

var0_0.Battle.BattleHPBarManager = var2_0
var2_0.__name = "BattleHPBarManager"
var2_0.ROOT_NAME = "HPBarContainer"
var2_0.HP_BAR_FRIENDLY = "heroBlood"
var2_0.HP_BAR_FOE = "enemyBlood"
var2_0.ORIGIN_BAR_WIDTH = {
	heroBlood = 70,
	enemyBlood = 154
}
var2_0.ORIGIN_PROGRESS_WIDTH = {
	heroBlood = 66,
	enemyBlood = 153
}

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.Init(arg0_2, arg1_2, arg2_2)
	arg0_2._allPool = {}
	arg0_2._ob2Pool = {}
	arg0_2._allPool[var2_0.HP_BAR_FRIENDLY] = var2_0.generateTempPool(var2_0.HP_BAR_FRIENDLY, arg2_2, arg1_2, 3, 10)
	arg0_2._allPool[var2_0.HP_BAR_FOE] = var2_0.generateTempPool(var2_0.HP_BAR_FOE, arg2_2, arg1_2, 8, 10)
end

function var2_0.InitialPoolRoot(arg0_3, arg1_3)
	arg0_3._allPool[var2_0.HP_BAR_FRIENDLY]:ResetParent(arg1_3)
	arg0_3._allPool[var2_0.HP_BAR_FOE]:ResetParent(arg1_3)
end

function var2_0.Clear(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4._allPool) do
		iter1_4:Dispose()
	end

	arg0_4._ob2Pool = {}
	arg0_4._allPool = {}
end

function var2_0.GetHPBar(arg0_5, arg1_5)
	local var0_5 = arg0_5._allPool[arg1_5]
	local var1_5 = var0_5:GetObject()

	arg0_5._ob2Pool[var1_5] = var0_5

	local var2_5 = var1_5.transform

	var2_5:Find("blood"):GetComponent(typeof(Image)).fillAmount = 1

	local var3_5 = var2_5:Find("type")

	if var3_5 then
		SetActive(var3_5, false)
	end

	local var4_5 = var2_5:Find("torpedoIcons")

	if var4_5 then
		SetActive(var4_5, false)
	end

	local var5_5 = var2_5:Find("biasBar")

	if var5_5 then
		SetActive(var5_5, false)
	end

	return var1_5
end

function var2_0.DestroyObj(arg0_6, arg1_6)
	if arg1_6 == nil then
		return
	end

	local var0_6 = arg0_6._ob2Pool[arg1_6]

	if var0_6 then
		var0_6:Recycle(arg1_6)
	else
		Object.Destroy(arg1_6)
	end
end

local var3_0 = Vector3(0, 10000, 0)

function var2_0.HideBullet(arg0_7)
	arg0_7.transform.position = var3_0
end

function var2_0.generateTempPool(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = arg2_8.transform:Find(arg0_8).gameObject

	var0_8.transform.position = var3_0

	var0_8:SetActive(true)

	local var1_8 = pg.Pool.New(arg1_8, var0_8, arg3_8, arg4_8, true, true)

	var1_8:SetRecycleFuncs(var2_0.HideBullet)
	var1_8:InitSize()

	return var1_8
end
