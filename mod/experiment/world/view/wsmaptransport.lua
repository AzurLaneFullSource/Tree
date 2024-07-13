local var0_0 = class("WSMapTransport", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onStartTrip = "OnStartTrip",
	onArrived = "OnArrived"
}

function var0_0.GetResName()
	return "world_cell_transport"
end

function var0_0.GetName(arg0_2, arg1_2, arg2_2)
	return "transport_" .. arg0_2 .. "_" .. arg1_2 .. "_" .. arg2_2
end

function var0_0.Setup(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.row = arg1_3
	arg0_3.column = arg2_3
	arg0_3.dir = arg3_3
	arg0_3.map = arg4_3

	arg0_3.wsMapPath:AddListener(WSMapPath.EventStartTrip, arg0_3.onStartTrip)
	arg0_3.wsMapPath:AddListener(WSMapPath.EventArrived, arg0_3.onArrived)
	arg0_3:Init()
end

function var0_0.Dispose(arg0_4)
	arg0_4.wsMapPath:RemoveListener(WSMapPath.EventStartTrip, arg0_4.onStartTrip)
	arg0_4.wsMapPath:RemoveListener(WSMapPath.EventArrived, arg0_4.onArrived)
	arg0_4:DisposeUpdateTimer()
	arg0_4:UpdateAlpha(1)
	arg0_4:Clear()
end

function var0_0.Init(arg0_5)
	local var0_5 = arg0_5.transform

	arg0_5.rtClick = var0_5:Find("click")
	arg0_5.rtBottom = var0_5:Find("bottom")
	arg0_5.rtDanger = var0_5:Find("danger")
	arg0_5.rtForbid = var0_5:Find("forbid")

	local var1_5 = arg0_5.row
	local var2_5 = arg0_5.column
	local var3_5 = arg0_5.dir

	var0_5.name = var0_0.GetName(var1_5, var2_5, var3_5)

	local var4_5 = 0

	if var3_5 == WorldConst.DirDown then
		var1_5 = var1_5 + 1
		var4_5 = -90
	elseif var3_5 == WorldConst.DirLeft then
		var2_5 = var2_5 - 1
		var4_5 = 180
	elseif var3_5 == WorldConst.DirUp then
		var1_5 = var1_5 - 1
		var4_5 = 90
	elseif var3_5 == WorldConst.DirRight then
		var2_5 = var2_5 + 1
		var4_5 = 0
	end

	var0_5.localEulerAngles = Vector3(0, 0, var4_5)
	var0_5.anchoredPosition = arg0_5.map.theme:GetLinePosition(var1_5, var2_5)

	local var5_5 = arg0_5.map.theme.cellSize

	var0_5.localScale = Vector3(var5_5.x / var0_5.sizeDelta.x, var5_5.y / var0_5.sizeDelta.y, 1)

	if arg0_5.wsMapPath:IsMoving() then
		arg0_5:OnStartTrip()
	end
end

function var0_0.UpdateAlpha(arg0_6, arg1_6)
	setImageAlpha(arg0_6.rtBottom, arg1_6)
	setImageAlpha(arg0_6.rtDanger, arg1_6)
	setImageAlpha(arg0_6.rtForbid, arg1_6)
end

function var0_0.OnStartTrip(arg0_7)
	arg0_7:StartUpdateTimer()
end

function var0_0.OnArrived(arg0_8)
	arg0_8:DisposeUpdateTimer()
end

function var0_0.StartUpdateTimer(arg0_9)
	local var0_9 = arg0_9.wsMapPath.wsObject

	if var0_9.class == WSMapFleet then
		arg0_9:DisposeUpdateTimer()

		local var1_9 = arg0_9.map.theme
		local var2_9 = var1_9:GetLinePosition(arg0_9.row, arg0_9.column)
		local var3_9 = math.min(var1_9.cellSize.x + var1_9.cellSpace.x, var1_9.cellSize.y + var1_9.cellSpace.y)
		local var4_9 = var0_9.fleet
		local var5_9 = arg0_9.map:GetNormalFleets()
		local var6_9 = _.map(var5_9, function(arg0_10)
			local var0_10 = var1_9:GetLinePosition(arg0_10.row, arg0_10.column)

			return Vector3.Distance(var0_10, var2_9)
		end)

		arg0_9.updateTimer = Timer.New(function()
			var6_9[var4_9.index] = Vector3.Distance(var0_9.transform.anchoredPosition3D, var2_9)

			local var0_11 = math.max(1 - _.min(var6_9) / var3_9, 0)

			arg0_9:UpdateAlpha(var0_11)
		end, 0.033, -1)

		arg0_9.updateTimer:Start()
		arg0_9.updateTimer.func()
	end
end

function var0_0.DisposeUpdateTimer(arg0_12)
	if arg0_12.updateTimer then
		arg0_12.updateTimer:Stop()

		arg0_12.updateTimer = nil
	end
end

return var0_0
