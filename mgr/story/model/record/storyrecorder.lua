local var0_0 = class("StoryRecorder")
local var1_0 = "#5ce6ff"
local var2_0 = "#70747F"
local var3_0 = "#BCBCBC"
local var4_0 = "#FFFFFF"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.recordList = {}
	arg0_1.displays = {}
end

function var0_0.Add(arg0_2, arg1_2)
	table.insert(arg0_2.recordList, arg1_2)
end

function var0_0.GetContentList(arg0_3)
	local var0_3 = arg0_3:Convert()

	for iter0_3, iter1_3 in ipairs(var0_3) do
		table.insert(arg0_3.displays, iter1_3)
	end

	return arg0_3.displays
end

function var0_0.Convert(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.recordList) do
		local var1_4 = iter1_4:GetMode()

		if var1_4 == Story.MODE_ASIDE then
			arg0_4:CollectAsideContent(var0_4, iter1_4)
		elseif var1_4 == Story.MODE_DIALOGUE or var1_4 == Story.MODE_BG then
			arg0_4:CollectDialogueContent(var0_4, iter1_4)
		end
	end

	arg0_4.recordList = {}

	return var0_4
end

local function var5_0(arg0_5)
	local var0_5 = {
		"<size=%d+>",
		"</size>",
		"<color=%w+>",
		"</color>"
	}
	local var1_5 = arg0_5

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var1_5 = string.gsub(var1_5, iter1_5, "")
	end

	return var1_5
end

function var0_0.CollectAsideContent(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg2_6:GetSequence()
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		table.insert(var1_6, var5_0(iter1_6[1]))
	end

	table.insert(arg1_6, {
		isPlayer = false,
		list = var1_6
	})
end

function var0_0.CollectDialogueContent(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7:GetPaintingIcon()
	local var1_7 = arg2_7:GetName()
	local var2_7 = ""

	if getProxy(PlayerProxy) then
		var2_7 = getProxy(PlayerProxy):getRawData().name
	end

	local var3_7 = var1_7 == var2_7

	local function var4_7()
		local var0_8 = arg2_7:GetNameColor()

		return var3_7 and var1_0 or var0_8 or var3_0
	end

	local var5_7 = arg2_7:GetContent()

	table.insert(arg1_7, {
		icon = var0_7,
		name = var1_7,
		nameColor = var4_7(),
		list = {
			setColorStr(var5_0(var5_7), var3_7 and var1_0 or var4_0)
		},
		isPlayer = var3_7
	})

	if arg2_7:ExistOption() then
		local var6_7 = arg2_7:GetSelectedBranchCode()
		local var7_7 = {}

		for iter0_7, iter1_7 in ipairs(arg2_7:GetOptions()) do
			local var8_7 = iter1_7[2] == var6_7
			local var9_7 = setColorStr("[ " .. var5_0(iter1_7[1]) .. " ]", var8_7 and var1_0 or var2_0)

			table.insert(var7_7, var9_7)
		end

		table.insert(arg1_7, {
			isPlayer = true,
			name = var2_7,
			nameColor = var1_0,
			list = var7_7
		})
	end
end

function var0_0.Clear(arg0_9)
	arg0_9.recordList = {}
	arg0_9.displays = {}
end

function var0_0.Dispose(arg0_10)
	arg0_10:Clear()
end

return var0_0
