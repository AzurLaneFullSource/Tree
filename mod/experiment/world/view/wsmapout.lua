local var0_0 = class("WSMapOut", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	transform = "userdata",
	emotion = "string",
	gid = "number",
	emotionTFs = "table",
	fleet = "table"
}
var0_0.Listeners = {
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onUpdateFleetEmotion = "OnUpdateFleetEmotion"
}

function var0_0.Build(arg0_1)
	return
end

function var0_0.Setup(arg0_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2.emotionTFs = {}
end

function var0_0.Dispose(arg0_3)
	arg0_3:RemoveFleetListener(arg0_3.fleet)
	arg0_3:RemoveMapListener()

	local var0_3 = PoolMgr.GetInstance()

	for iter0_3, iter1_3 in pairs(arg0_3.emotionTFs) do
		var0_3:ReturnUI(iter0_3, go(iter1_3))
	end

	pg.DelegateInfo.Dispose(arg0_3)
	arg0_3:Clear()
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
	end
end

function var0_0.AddFleetListener(arg0_7, arg1_7)
	if arg1_7 then
		arg1_7:AddListener(WorldMapFleet.EventUpdateLocation, arg0_7.onUpdateFleetEmotion)
	end
end

function var0_0.RemoveFleetListener(arg0_8, arg1_8)
	if arg1_8 then
		arg1_8:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0_8.onUpdateFleetEmotion)
	end
end

function var0_0.OnUpdateSelectedFleet(arg0_9)
	local var0_9 = arg0_9.map:GetFleet()

	if arg0_9.fleet ~= var0_9 then
		arg0_9:RemoveFleetListener(arg0_9.fleet)

		arg0_9.fleet = var0_9

		arg0_9:AddFleetListener(arg0_9.fleet)
	end

	arg0_9:OnUpdateFleetEmotion()
end

function var0_0.OnUpdateFleetEmotion(arg0_10)
	if not arg0_10.map.active then
		return
	end

	local var0_10 = arg0_10.map:GetCell(arg0_10.fleet.row, arg0_10.fleet.column):GetEmotion()
	local var1_10

	if arg0_10.emotion ~= var0_10 then
		local var2_10 = PoolMgr.GetInstance()
		local var3_10 = {}

		if arg0_10.emotion and arg0_10.emotionTFs[arg0_10.emotion] then
			setActive(arg0_10.emotionTFs[arg0_10.emotion], false)
		end

		arg0_10.emotion = var0_10

		if var0_10 then
			if arg0_10.emotionTFs[var0_10] then
				setActive(arg0_10.emotionTFs[arg0_10.emotion], true)
			else
				var2_10:GetUI(var0_10, true, function(arg0_11)
					if arg0_10.emotion == var0_10 then
						setParent(arg0_11, arg0_10.transform)
						setActive(arg0_11, true)

						arg0_10.emotionTFs[var0_10] = tf(arg0_11)
					else
						var2_10:ReturnUI(var0_10, arg0_11)
					end
				end)
			end
		end
	end
end

return var0_0
