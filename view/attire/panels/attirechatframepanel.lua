local var0 = class("AttireChatFramePanel", import(".AttireFramePanel"))
local var1 = setmetatable

local function var2(arg0)
	local var0 = {}
	local var1 = AttireFramePanel.Card(arg0)

	local function var2(arg0)
		return
	end

	local function var3(arg0, arg1, arg2)
		setAnchoredPosition(arg1, Vector2.zero)
		setText(arg1.transform:Find("Text"), "")
	end

	function var0.Update(arg0, arg1, arg2, arg3)
		var1:Update(arg1, arg2, arg3)
		arg0:ReturnIconFrame(AttireConst.TYPE_CHAT_FRAME)

		if arg0:isEmpty() then
			return
		end

		arg0:LoadPrefab(arg1, function(arg0)
			var3(arg0, arg0, arg1)
		end)
	end

	function var0.Dispose(arg0)
		arg0:ReturnIconFrame(AttireConst.TYPE_CHAT_FRAME)
	end

	var2(var0)

	return var1(var0, {
		__index = var1
	})
end

function var0.getUIName(arg0)
	return "AttireChatFrameUI"
end

function var0.GetData(arg0)
	return arg0.rawAttireVOs.chatFrames
end

function var0.OnInitItem(arg0, arg1)
	local var0 = var2(arg1)

	arg0.cards[arg1] = var0

	onButton(arg0, var0._go, function()
		if var0:isEmpty() then
			return
		end

		if arg0.card then
			arg0.card:UpdateSelected(false)
		end

		arg0.contextData.chatFrameIndex = var0.attireFrame.id

		arg0:UpdateDesc(var0)
		var0:UpdateSelected(true)

		arg0.card = var0
	end, SFX_PANEL)
end

function var0.GetColumn(arg0)
	return 3
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	var0.super.OnUpdateItem(arg0, arg1, arg2)

	local var0 = arg0.contextData.chatFrameIndex or arg0.displayVOs[1].id
	local var1 = arg0.cards[arg2]

	if var1.attireFrame.id == var0 then
		triggerButton(var1._go)
		var1:UpdateSelected(true)
	end
end

return var0
