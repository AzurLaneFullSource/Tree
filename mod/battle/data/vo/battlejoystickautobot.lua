ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleJoyStickAutoBot = class("BattleJoyStickAutoBot")

local var1_0 = var0_0.Battle.BattleJoyStickAutoBot

var1_0.__name = "BattleJoyStickAutoBot"
var1_0.COUNTER_MAIN = "CounterMainRandomStrategy"
var1_0.RANDOM = "RandomStrategy"
var1_0.AUTO_PILOT = "AutoPilotStrategy"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._dataProxy = arg1_1
	arg0_1._fleetVO = arg2_1

	arg0_1:init()
end

function var1_0.UpdateFleetArea(arg0_2)
	if arg0_2._strategy then
		arg0_2._strategy:SetBoardBound(arg0_2._fleetVO:GetFleetBound())
	end
end

function var1_0.FleetFormationUpdate(arg0_3)
	if arg0_3._strategy:GetStrategyType() == var1_0.AUTO_PILOT then
		arg0_3:SwitchStrategy(var1_0.AUTO_PILOT)
	end
end

function var1_0.SetActive(arg0_4, arg1_4)
	arg0_4._active = arg1_4

	if arg1_4 then
		local function var0_4()
			return arg0_4._strategy:Output()
		end

		arg0_4._fleetVO:SetMotionSource(var0_4)
	else
		arg0_4._fleetVO:SetMotionSource()
	end
end

function var1_0.SwitchStrategy(arg0_6, arg1_6)
	if arg0_6._strategy then
		arg0_6._strategy:Dispose()
	end

	arg1_6 = arg1_6 or var1_0.RANDOM
	arg0_6._strategy = var0_0.Battle[arg1_6].New(arg0_6._fleetVO)

	arg0_6:UpdateFleetArea()
	arg0_6._strategy:Input(arg0_6._dataProxy:GetFoeShipList(), arg0_6._dataProxy:GetFoeAircraftList())
end

function var1_0.init(arg0_7)
	arg0_7._active = false
	arg0_7._uiMgr = pg.UIMgr.GetInstance()

	arg0_7:SwitchStrategy()
end

function var1_0.Dispose(arg0_8)
	if arg0_8._strategy then
		arg0_8._strategy:Dispose()
	end

	arg0_8._dataProxy = nil
	arg0_8._uiMediator = nil
	arg0_8._uiMgr = nil
end
