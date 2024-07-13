ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleMainDamagedView = class("BattleMainDamagedView")

local var2_0 = class("BattleMainDamagedView")

var0_0.Battle.BattleMainDamagedView = var2_0
var2_0.__name = "BattleMainDamagedView"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:Init()
end

function var2_0.Init(arg0_2)
	arg0_2._tf = arg0_2._go.transform
	arg0_2._bleedView = findTF(arg0_2._tf, "mainUnitDamaged")
	arg0_2._bleedAnimation = arg0_2._bleedView:GetComponent(typeof(Animator))

	arg0_2._bleedView:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_3)
		setActive(arg0_2._bleedView, false)

		arg0_2._isPlaying = false
	end)
	setActive(arg0_2._bleedView, false)

	arg0_2._isPlaying = false
end

function var2_0.Play(arg0_4)
	if not arg0_4._isPlaying then
		setActive(arg0_4._bleedView, true)
	end

	arg0_4._isPlaying = true
end

function var2_0.Dispose(arg0_5)
	arg0_5._bleedView = nil
	arg0_5._bleedAnimation = nil
	arg0_5._tf = nil
	arg0_5._go = nil
end
