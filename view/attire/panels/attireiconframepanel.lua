local var0_0 = class("AttireIconFramePanel", import(".AttireFramePanel"))
local var1_0 = setmetatable

local function var2_0(arg0_1)
	local var0_1 = {}
	local var1_1 = AttireFramePanel.Card(arg0_1)

	local function var2_1(arg0_2)
		return
	end

	local function var3_1(arg0_3, arg1_3, arg2_3)
		return
	end

	function var0_1.Update(arg0_4, arg1_4, arg2_4, arg3_4)
		var1_1:Update(arg1_4, arg2_4, arg3_4)
		arg0_4:ReturnIconFrame(AttireConst.TYPE_ICON_FRAME)

		if arg0_4:isEmpty() then
			return
		end

		arg0_4:LoadPrefab(arg1_4, function(arg0_5)
			var3_1(arg0_4, arg0_5, arg1_4)
		end)
	end

	function var0_1.Dispose(arg0_6)
		arg0_6:ReturnIconFrame(AttireConst.TYPE_ICON_FRAME)
	end

	var2_1(var0_1)

	return var1_0(var0_1, {
		__index = var1_1
	})
end

function var0_0.getUIName(arg0_7)
	return "AttireIconFrameUI"
end

function var0_0.GetData(arg0_8)
	return arg0_8.rawAttireVOs.iconFrames
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = var2_0(arg1_9)

	arg0_9.cards[arg1_9] = var0_9

	onButton(arg0_9, var0_9._go, function()
		if not var0_9:isEmpty() then
			if arg0_9.card then
				arg0_9.card:UpdateSelected(false)
			end

			arg0_9.contextData.iconFrameId = var0_9.attireFrame.id

			arg0_9:UpdateDesc(var0_9)
			var0_9:UpdateSelected(true)

			arg0_9.card = var0_9
		end
	end, SFX_PANEL)
end

function var0_0.GetColumn(arg0_11)
	return 2
end

function var0_0.OnUpdateItem(arg0_12, arg1_12, arg2_12)
	var0_0.super.OnUpdateItem(arg0_12, arg1_12, arg2_12)

	local var0_12 = arg0_12.contextData.iconFrameId or arg0_12.displayVOs[1].id
	local var1_12 = arg0_12.cards[arg2_12]

	if var1_12.attireFrame.id == var0_12 then
		triggerButton(var1_12._go)
		var1_12:UpdateSelected(true)
	end
end

return var0_0
