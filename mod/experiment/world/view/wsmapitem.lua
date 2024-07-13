local var0_0 = class("WSMapItem", import("...BaseEntity"))

var0_0.Fields = {
	cell = "table",
	transform = "userdata",
	rtArtifacts = "userdata",
	theme = "table"
}

function var0_0.GetResName()
	return "world_cell_item"
end

function var0_0.GetName(arg0_2, arg1_2)
	return "item_" .. arg0_2 .. "_" .. arg1_2
end

function var0_0.Setup(arg0_3, arg1_3, arg2_3)
	arg0_3.cell = arg1_3
	arg0_3.theme = arg2_3

	arg0_3:Init()
end

function var0_0.Dispose(arg0_4)
	arg0_4:Clear()
end

function var0_0.Init(arg0_5)
	local var0_5 = arg0_5.cell
	local var1_5 = arg0_5.transform

	var1_5.name = var0_0.GetName(var0_5.row, var0_5.column)
	var1_5.anchoredPosition = arg0_5.theme:GetLinePosition(var0_5.row, var0_5.column)
	var1_5.sizeDelta = arg0_5.theme.cellSize
	arg0_5.rtArtifacts = var1_5:Find("artifacts")
	arg0_5.rtArtifacts.localEulerAngles = Vector3(-arg0_5.theme.angle, 0, 0)
end

return var0_0
