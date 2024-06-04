local var0 = class("WSMapItem", import("...BaseEntity"))

var0.Fields = {
	cell = "table",
	transform = "userdata",
	rtArtifacts = "userdata",
	theme = "table"
}

function var0.GetResName()
	return "world_cell_item"
end

function var0.GetName(arg0, arg1)
	return "item_" .. arg0 .. "_" .. arg1
end

function var0.Setup(arg0, arg1, arg2)
	arg0.cell = arg1
	arg0.theme = arg2

	arg0:Init()
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.cell
	local var1 = arg0.transform

	var1.name = var0.GetName(var0.row, var0.column)
	var1.anchoredPosition = arg0.theme:GetLinePosition(var0.row, var0.column)
	var1.sizeDelta = arg0.theme.cellSize
	arg0.rtArtifacts = var1:Find("artifacts")
	arg0.rtArtifacts.localEulerAngles = Vector3(-arg0.theme.angle, 0, 0)
end

return var0
