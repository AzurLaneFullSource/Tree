ys = ys or {}

local var0 = ys

var0.Battle.BattleJoyStickAutoBot = class("BattleJoyStickAutoBot")

local var1 = var0.Battle.BattleJoyStickAutoBot

var1.__name = "BattleJoyStickAutoBot"
var1.COUNTER_MAIN = "CounterMainRandomStrategy"
var1.RANDOM = "RandomStrategy"
var1.AUTO_PILOT = "AutoPilotStrategy"

function var1.Ctor(arg0, arg1, arg2)
	arg0._dataProxy = arg1
	arg0._fleetVO = arg2

	arg0:init()
end

function var1.UpdateFleetArea(arg0)
	if arg0._strategy then
		arg0._strategy:SetBoardBound(arg0._fleetVO:GetFleetBound())
	end
end

function var1.FleetFormationUpdate(arg0)
	if arg0._strategy:GetStrategyType() == var1.AUTO_PILOT then
		arg0:SwitchStrategy(var1.AUTO_PILOT)
	end
end

function var1.SetActive(arg0, arg1)
	arg0._active = arg1

	if arg1 then
		local function var0()
			return arg0._strategy:Output()
		end

		arg0._fleetVO:SetMotionSource(var0)
	else
		arg0._fleetVO:SetMotionSource()
	end
end

function var1.SwitchStrategy(arg0, arg1)
	if arg0._strategy then
		arg0._strategy:Dispose()
	end

	arg1 = arg1 or var1.RANDOM
	arg0._strategy = var0.Battle[arg1].New(arg0._fleetVO)

	arg0:UpdateFleetArea()
	arg0._strategy:Input(arg0._dataProxy:GetFoeShipList(), arg0._dataProxy:GetFoeAircraftList())
end

function var1.init(arg0)
	arg0._active = false
	arg0._uiMgr = pg.UIMgr.GetInstance()

	arg0:SwitchStrategy()
end

function var1.Dispose(arg0)
	if arg0._strategy then
		arg0._strategy:Dispose()
	end

	arg0._dataProxy = nil
	arg0._uiMediator = nil
	arg0._uiMgr = nil
end
