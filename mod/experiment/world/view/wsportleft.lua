local var0 = class("WSPortLeft", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	rtVanguard = "userdata",
	rtFleet = "userdata",
	gid = "number",
	rtShip = "userdata",
	transform = "userdata",
	rtBG = "userdata",
	rtMain = "userdata",
	fleet = "table"
}
var0.Listeners = {
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onUpdateShip = "OnUpdateShip"
}

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	arg0.rtBG = arg0.transform:Find("bg")
	arg0.rtFleet = arg0.rtBG:Find("fleet")
	arg0.rtMain = arg0.rtFleet:Find("main")
	arg0.rtVanguard = arg0.rtFleet:Find("vanguard")
	arg0.rtShip = arg0.rtFleet:Find("shiptpl")

	setActive(arg0.rtShip, false)
end

function var0.UpdateMap(arg0, arg1)
	if arg0.map ~= arg1 or arg0.gid ~= arg1.gid then
		arg0:RemoveMapListener()

		arg0.map = arg1
		arg0.gid = arg1.gid

		arg0:AddMapListener()
		arg0:OnUpdateSelectedFleet()
	end
end

function var0.AddMapListener(arg0)
	if arg0.map then
		arg0.map:AddListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
	end
end

function var0.RemoveMapListener(arg0)
	if arg0.map then
		arg0.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0.onUpdateSelectedFleet)
		arg0:RemoveFleetListener(arg0.fleet)
	end
end

function var0.AddFleetListener(arg0, arg1)
	if arg1 then
		_.each(arg1:GetShips(true), function(arg0)
			arg0:AddListener(WorldMapShip.EventHpRantChange, arg0.onUpdateShip)
		end)
	end
end

function var0.RemoveFleetListener(arg0, arg1)
	if arg1 then
		_.each(arg1:GetShips(true), function(arg0)
			arg0:RemoveListener(WorldMapShip.EventHpRantChange, arg0.onUpdateShip)
		end)
	end
end

function var0.OnUpdateSelectedFleet(arg0)
	local var0 = arg0.map:GetFleet()

	if arg0.fleet ~= var0 then
		arg0:RemoveFleetListener(arg0.fleet)

		arg0.fleet = var0

		arg0:AddFleetListener(arg0.fleet)
		arg0:UpdateShipList(arg0.rtMain, arg0.fleet:GetTeamShipVOs(TeamType.Main, true))
		arg0:UpdateShipList(arg0.rtVanguard, arg0.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	end
end

function var0.OnUpdateShip(arg0, arg1, arg2)
	local var0 = arg0.map:GetFleet(arg2.fleetId)

	assert(var0, "can not find fleet: " .. arg2.fleetId)

	local var1 = var0:GetFleetType()

	if var1 == FleetType.Normal then
		arg0:UpdateShipList(arg0.rtMain, arg0.fleet:GetTeamShipVOs(TeamType.Main, true))
		arg0:UpdateShipList(arg0.rtVanguard, arg0.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	elseif var1 == FleetType.Submarine then
		arg0:UpdateShipList(arg0.rtSubmarine, arg0.submarineFleet:GetTeamShipVOs(TeamType.Submarine, true))
	end
end

function var0.UpdateShipList(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1, arg0.rtShip)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2[arg1 + 1]
			local var1 = WorldConst.FetchWorldShip(var0.id)

			updateShip(arg2, var0)

			local var2 = findTF(arg2, "HP_POP")

			setActive(var2, true)
			setActive(findTF(var2, "heal"), false)
			setActive(findTF(var2, "normal"), false)

			local var3 = findTF(arg2, "blood")
			local var4 = findTF(arg2, "blood/fillarea/green")
			local var5 = findTF(arg2, "blood/fillarea/red")
			local var6 = not var1:IsHpSafe()

			setActive(var4, not var6)
			setActive(var5, var6)

			var3:GetComponent(typeof(Slider)).fillRect = var6 and var5 or var4

			setSlider(var3, 0, 10000, var1.hpRant)

			local var7 = arg2:Find("agony")

			setActive(var7, var6)

			local var8 = arg2:Find("broken")

			setActive(var8, var1:IsBroken())
		end
	end)
	var0:align(#arg2)
end

return var0
