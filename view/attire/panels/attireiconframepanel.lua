local var0 = class("AttireIconFramePanel", import(".AttireFramePanel"))
local var1 = setmetatable

local function var2(arg0)
	local var0 = {}
	local var1 = AttireFramePanel.Card(arg0)

	local function var2(arg0)
		return
	end

	local function var3(arg0, arg1, arg2)
		return
	end

	function var0.Update(arg0, arg1, arg2, arg3)
		var1:Update(arg1, arg2, arg3)
		arg0:ReturnIconFrame(AttireConst.TYPE_ICON_FRAME)

		if arg0:isEmpty() then
			return
		end

		arg0:LoadPrefab(arg1, function(arg0)
			var3(arg0, arg0, arg1)
		end)
	end

	function var0.Dispose(arg0)
		arg0:ReturnIconFrame(AttireConst.TYPE_ICON_FRAME)
	end

	var2(var0)

	return var1(var0, {
		__index = var1
	})
end

function var0.getUIName(arg0)
	return "AttireIconFrameUI"
end

function var0.GetData(arg0)
	return arg0.rawAttireVOs.iconFrames
end

function var0.OnInitItem(arg0, arg1)
	local var0 = var2(arg1)

	arg0.cards[arg1] = var0

	onButton(arg0, var0._go, function()
		if not var0:isEmpty() then
			if arg0.card then
				arg0.card:UpdateSelected(false)
			end

			arg0.contextData.iconFrameId = var0.attireFrame.id

			arg0:UpdateDesc(var0)
			var0:UpdateSelected(true)

			arg0.card = var0
		end
	end, SFX_PANEL)
end

function var0.GetColumn(arg0)
	return 2
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	var0.super.OnUpdateItem(arg0, arg1, arg2)

	local var0 = arg0.contextData.iconFrameId or arg0.displayVOs[1].id
	local var1 = arg0.cards[arg2]

	if var1.attireFrame.id == var0 then
		triggerButton(var1._go)
		var1:UpdateSelected(true)
	end
end

return var0
