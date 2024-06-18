local var0_0 = class("WSPortLeft", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onUpdateShip = "OnUpdateShip"
}

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	arg0_2:RemoveMapListener()
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	arg0_3.rtBG = arg0_3.transform:Find("bg")
	arg0_3.rtFleet = arg0_3.rtBG:Find("fleet")
	arg0_3.rtMain = arg0_3.rtFleet:Find("main")
	arg0_3.rtVanguard = arg0_3.rtFleet:Find("vanguard")
	arg0_3.rtShip = arg0_3.rtFleet:Find("shiptpl")

	setActive(arg0_3.rtShip, false)
end

function var0_0.UpdateMap(arg0_4, arg1_4)
	if arg0_4.map ~= arg1_4 or arg0_4.gid ~= arg1_4.gid then
		arg0_4:RemoveMapListener()

		arg0_4.map = arg1_4
		arg0_4.gid = arg1_4.gid

		arg0_4:AddMapListener()
		arg0_4:OnUpdateSelectedFleet()
	end
end

function var0_0.AddMapListener(arg0_5)
	if arg0_5.map then
		arg0_5.map:AddListener(WorldMap.EventUpdateFIndex, arg0_5.onUpdateSelectedFleet)
	end
end

function var0_0.RemoveMapListener(arg0_6)
	if arg0_6.map then
		arg0_6.map:RemoveListener(WorldMap.EventUpdateFIndex, arg0_6.onUpdateSelectedFleet)
		arg0_6:RemoveFleetListener(arg0_6.fleet)
	end
end

function var0_0.AddFleetListener(arg0_7, arg1_7)
	if arg1_7 then
		_.each(arg1_7:GetShips(true), function(arg0_8)
			arg0_8:AddListener(WorldMapShip.EventHpRantChange, arg0_7.onUpdateShip)
		end)
	end
end

function var0_0.RemoveFleetListener(arg0_9, arg1_9)
	if arg1_9 then
		_.each(arg1_9:GetShips(true), function(arg0_10)
			arg0_10:RemoveListener(WorldMapShip.EventHpRantChange, arg0_9.onUpdateShip)
		end)
	end
end

function var0_0.OnUpdateSelectedFleet(arg0_11)
	local var0_11 = arg0_11.map:GetFleet()

	if arg0_11.fleet ~= var0_11 then
		arg0_11:RemoveFleetListener(arg0_11.fleet)

		arg0_11.fleet = var0_11

		arg0_11:AddFleetListener(arg0_11.fleet)
		arg0_11:UpdateShipList(arg0_11.rtMain, arg0_11.fleet:GetTeamShipVOs(TeamType.Main, true))
		arg0_11:UpdateShipList(arg0_11.rtVanguard, arg0_11.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	end
end

function var0_0.OnUpdateShip(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.map:GetFleet(arg2_12.fleetId)

	assert(var0_12, "can not find fleet: " .. arg2_12.fleetId)

	local var1_12 = var0_12:GetFleetType()

	if var1_12 == FleetType.Normal then
		arg0_12:UpdateShipList(arg0_12.rtMain, arg0_12.fleet:GetTeamShipVOs(TeamType.Main, true))
		arg0_12:UpdateShipList(arg0_12.rtVanguard, arg0_12.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	elseif var1_12 == FleetType.Submarine then
		arg0_12:UpdateShipList(arg0_12.rtSubmarine, arg0_12.submarineFleet:GetTeamShipVOs(TeamType.Submarine, true))
	end
end

function var0_0.UpdateShipList(arg0_13, arg1_13, arg2_13)
	local var0_13 = UIItemList.New(arg1_13, arg0_13.rtShip)

	var0_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg2_13[arg1_14 + 1]
			local var1_14 = WorldConst.FetchWorldShip(var0_14.id)

			updateShip(arg2_14, var0_14)

			local var2_14 = findTF(arg2_14, "HP_POP")

			setActive(var2_14, true)
			setActive(findTF(var2_14, "heal"), false)
			setActive(findTF(var2_14, "normal"), false)

			local var3_14 = findTF(arg2_14, "blood")
			local var4_14 = findTF(arg2_14, "blood/fillarea/green")
			local var5_14 = findTF(arg2_14, "blood/fillarea/red")
			local var6_14 = not var1_14:IsHpSafe()

			setActive(var4_14, not var6_14)
			setActive(var5_14, var6_14)

			var3_14:GetComponent(typeof(Slider)).fillRect = var6_14 and var5_14 or var4_14

			setSlider(var3_14, 0, 10000, var1_14.hpRant)

			local var7_14 = arg2_14:Find("agony")

			setActive(var7_14, var6_14)

			local var8_14 = arg2_14:Find("broken")

			setActive(var8_14, var1_14:IsBroken())
		end
	end)
	var0_13:align(#arg2_13)
end

return var0_0
