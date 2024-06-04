local var0 = class("WSMapTransport", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	wsMapPath = "table",
	rtForbid = "userdata",
	transform = "userdata",
	dir = "number",
	column = "number",
	updateTimer = "table",
	row = "number",
	rtClick = "userdata",
	rtBottom = "userdata",
	rtDanger = "userdata"
}
var0.Listeners = {
	onStartTrip = "OnStartTrip",
	onArrived = "OnArrived"
}

function var0.GetResName()
	return "world_cell_transport"
end

function var0.GetName(arg0, arg1, arg2)
	return "transport_" .. arg0 .. "_" .. arg1 .. "_" .. arg2
end

function var0.Setup(arg0, arg1, arg2, arg3, arg4)
	arg0.row = arg1
	arg0.column = arg2
	arg0.dir = arg3
	arg0.map = arg4

	arg0.wsMapPath:AddListener(WSMapPath.EventStartTrip, arg0.onStartTrip)
	arg0.wsMapPath:AddListener(WSMapPath.EventArrived, arg0.onArrived)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.wsMapPath:RemoveListener(WSMapPath.EventStartTrip, arg0.onStartTrip)
	arg0.wsMapPath:RemoveListener(WSMapPath.EventArrived, arg0.onArrived)
	arg0:DisposeUpdateTimer()
	arg0:UpdateAlpha(1)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtClick = var0:Find("click")
	arg0.rtBottom = var0:Find("bottom")
	arg0.rtDanger = var0:Find("danger")
	arg0.rtForbid = var0:Find("forbid")

	local var1 = arg0.row
	local var2 = arg0.column
	local var3 = arg0.dir

	var0.name = var0.GetName(var1, var2, var3)

	local var4 = 0

	if var3 == WorldConst.DirDown then
		var1 = var1 + 1
		var4 = -90
	elseif var3 == WorldConst.DirLeft then
		var2 = var2 - 1
		var4 = 180
	elseif var3 == WorldConst.DirUp then
		var1 = var1 - 1
		var4 = 90
	elseif var3 == WorldConst.DirRight then
		var2 = var2 + 1
		var4 = 0
	end

	var0.localEulerAngles = Vector3(0, 0, var4)
	var0.anchoredPosition = arg0.map.theme:GetLinePosition(var1, var2)

	local var5 = arg0.map.theme.cellSize

	var0.localScale = Vector3(var5.x / var0.sizeDelta.x, var5.y / var0.sizeDelta.y, 1)

	if arg0.wsMapPath:IsMoving() then
		arg0:OnStartTrip()
	end
end

function var0.UpdateAlpha(arg0, arg1)
	setImageAlpha(arg0.rtBottom, arg1)
	setImageAlpha(arg0.rtDanger, arg1)
	setImageAlpha(arg0.rtForbid, arg1)
end

function var0.OnStartTrip(arg0)
	arg0:StartUpdateTimer()
end

function var0.OnArrived(arg0)
	arg0:DisposeUpdateTimer()
end

function var0.StartUpdateTimer(arg0)
	local var0 = arg0.wsMapPath.wsObject

	if var0.class == WSMapFleet then
		arg0:DisposeUpdateTimer()

		local var1 = arg0.map.theme
		local var2 = var1:GetLinePosition(arg0.row, arg0.column)
		local var3 = math.min(var1.cellSize.x + var1.cellSpace.x, var1.cellSize.y + var1.cellSpace.y)
		local var4 = var0.fleet
		local var5 = arg0.map:GetNormalFleets()
		local var6 = _.map(var5, function(arg0)
			local var0 = var1:GetLinePosition(arg0.row, arg0.column)

			return Vector3.Distance(var0, var2)
		end)

		arg0.updateTimer = Timer.New(function()
			var6[var4.index] = Vector3.Distance(var0.transform.anchoredPosition3D, var2)

			local var0 = math.max(1 - _.min(var6) / var3, 0)

			arg0:UpdateAlpha(var0)
		end, 0.033, -1)

		arg0.updateTimer:Start()
		arg0.updateTimer.func()
	end
end

function var0.DisposeUpdateTimer(arg0)
	if arg0.updateTimer then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end
end

return var0
