local var0 = class("WSMapOut", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	transform = "userdata",
	emotion = "string",
	gid = "number",
	emotionTFs = "table",
	fleet = "table"
}
var0.Listeners = {
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onUpdateFleetEmotion = "OnUpdateFleetEmotion"
}

function var0.Build(arg0)
	return
end

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)

	arg0.emotionTFs = {}
end

function var0.Dispose(arg0)
	arg0:RemoveFleetListener(arg0.fleet)
	arg0:RemoveMapListener()

	local var0 = PoolMgr.GetInstance()

	for iter0, iter1 in pairs(arg0.emotionTFs) do
		var0:ReturnUI(iter0, go(iter1))
	end

	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
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
	end
end

function var0.AddFleetListener(arg0, arg1)
	if arg1 then
		arg1:AddListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdateFleetEmotion)
	end
end

function var0.RemoveFleetListener(arg0, arg1)
	if arg1 then
		arg1:RemoveListener(WorldMapFleet.EventUpdateLocation, arg0.onUpdateFleetEmotion)
	end
end

function var0.OnUpdateSelectedFleet(arg0)
	local var0 = arg0.map:GetFleet()

	if arg0.fleet ~= var0 then
		arg0:RemoveFleetListener(arg0.fleet)

		arg0.fleet = var0

		arg0:AddFleetListener(arg0.fleet)
	end

	arg0:OnUpdateFleetEmotion()
end

function var0.OnUpdateFleetEmotion(arg0)
	if not arg0.map.active then
		return
	end

	local var0 = arg0.map:GetCell(arg0.fleet.row, arg0.fleet.column):GetEmotion()
	local var1

	if arg0.emotion ~= var0 then
		local var2 = PoolMgr.GetInstance()
		local var3 = {}

		if arg0.emotion and arg0.emotionTFs[arg0.emotion] then
			setActive(arg0.emotionTFs[arg0.emotion], false)
		end

		arg0.emotion = var0

		if var0 then
			if arg0.emotionTFs[var0] then
				setActive(arg0.emotionTFs[arg0.emotion], true)
			else
				var2:GetUI(var0, true, function(arg0)
					if arg0.emotion == var0 then
						setParent(arg0, arg0.transform)
						setActive(arg0, true)

						arg0.emotionTFs[var0] = tf(arg0)
					else
						var2:ReturnUI(var0, arg0)
					end
				end)
			end
		end
	end
end

return var0
