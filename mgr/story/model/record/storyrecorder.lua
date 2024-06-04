local var0 = class("StoryRecorder")
local var1 = "#5ce6ff"
local var2 = "#70747F"
local var3 = "#BCBCBC"
local var4 = "#FFFFFF"

function var0.Ctor(arg0, arg1)
	arg0.recordList = {}
	arg0.displays = {}
end

function var0.Add(arg0, arg1)
	table.insert(arg0.recordList, arg1)
end

function var0.GetContentList(arg0)
	local var0 = arg0:Convert()

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.displays, iter1)
	end

	return arg0.displays
end

function var0.Convert(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.recordList) do
		local var1 = iter1:GetMode()

		if var1 == Story.MODE_ASIDE then
			arg0:CollectAsideContent(var0, iter1)
		elseif var1 == Story.MODE_DIALOGUE or var1 == Story.MODE_BG then
			arg0:CollectDialogueContent(var0, iter1)
		end
	end

	arg0.recordList = {}

	return var0
end

local function var5(arg0)
	local var0 = {
		"<size=%d+>",
		"</size>",
		"<color=%w+>",
		"</color>"
	}
	local var1 = arg0

	for iter0, iter1 in ipairs(var0) do
		var1 = string.gsub(var1, iter1, "")
	end

	return var1
end

function var0.CollectAsideContent(arg0, arg1, arg2)
	local var0 = arg2:GetSequence()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, var5(iter1[1]))
	end

	table.insert(arg1, {
		isPlayer = false,
		list = var1
	})
end

function var0.CollectDialogueContent(arg0, arg1, arg2)
	local var0 = arg2:GetPaintingIcon()
	local var1 = arg2:GetName()
	local var2 = ""

	if getProxy(PlayerProxy) then
		var2 = getProxy(PlayerProxy):getRawData().name
	end

	local var3 = var1 == var2

	local function var4()
		local var0 = arg2:GetNameColor()

		return var3 and var1 or var0 or var3
	end

	local var5 = arg2:GetContent()

	table.insert(arg1, {
		icon = var0,
		name = var1,
		nameColor = var4(),
		list = {
			setColorStr(var5(var5), var3 and var1 or var4)
		},
		isPlayer = var3
	})

	if arg2:ExistOption() then
		local var6 = arg2:GetSelectedBranchCode()
		local var7 = {}

		for iter0, iter1 in ipairs(arg2:GetOptions()) do
			local var8 = iter1[2] == var6
			local var9 = setColorStr("[ " .. var5(iter1[1]) .. " ]", var8 and var1 or var2)

			table.insert(var7, var9)
		end

		table.insert(arg1, {
			isPlayer = true,
			name = var2,
			nameColor = var1,
			list = var7
		})
	end
end

function var0.Clear(arg0)
	arg0.recordList = {}
	arg0.displays = {}
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
