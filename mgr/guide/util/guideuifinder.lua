local var0_0 = class("GuideUIFinder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.queue = {}
end

function var0_0.Search(arg0_2, arg1_2)
	table.insert(arg0_2.queue, arg1_2)

	if #arg0_2.queue == 1 then
		arg0_2:Start()
	end
end

function var0_0.Start(arg0_3)
	if #arg0_3.queue <= 0 then
		return
	end

	local var0_3 = arg0_3.queue[1]

	arg0_3:Clear()

	local function var1_3()
		table.remove(arg0_3.queue, 1)
		arg0_3:Start()
	end

	if (var0_3.delay or 0) > 0 then
		arg0_3.delayTimer = Timer.New(function()
			arg0_3:AddSearchTimer(var0_3, var1_3)
		end, var0_3.delay)

		arg0_3.delayTimer:Start()
	else
		arg0_3:AddSearchTimer(var0_3, var1_3)
	end
end

local function var1_0(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6 = 0, arg0_6.childCount - 1 do
		local var1_6 = arg0_6:GetChild(iter0_6)
		local var2_6 = var1_6:GetComponent(typeof(LayoutElement))

		if not IsNil(var1_6) and go(var1_6).activeInHierarchy and (not var2_6 or not var2_6.ignoreLayout) then
			table.insert(var0_6, var1_6)
		end
	end

	return arg1_6 and var0_6[arg1_6 + 1] or var0_6[#var0_6]
end

local function var2_0(arg0_7)
	local var0_7 = GameObject.Find(arg0_7.path)

	if var0_7 and arg0_7.childIndex and arg0_7.childIndex == "#" then
		return var1_0(var0_7.transform)
	elseif var0_7 and arg0_7.childIndex and arg0_7.childIndex == -999 then
		return var1_0(var0_7.transform, 0)
	elseif var0_7 and arg0_7.childIndex and arg0_7.childIndex >= 0 then
		return var1_0(var0_7.transform, arg0_7.childIndex)
	elseif var0_7 then
		return var0_7.transform
	end

	return nil
end

local function var3_0(arg0_8)
	local var0_8 = var2_0(arg0_8)

	if var0_8 ~= nil then
		for iter0_8, iter1_8 in ipairs(arg0_8.conditionData) do
			local var1_8 = var0_8:Find(iter1_8)

			if var1_8 then
				return var1_8
			end
		end
	end

	return nil
end

local function var4_0(arg0_9)
	local var0_9

	if arg0_9.conditionData then
		var0_9 = var3_0(arg0_9)
	else
		var0_9 = var2_0(arg0_9)
	end

	if var0_9 then
		return var0_9
	end

	return nil
end

function var0_0.AddSearchTimer(arg0_10, arg1_10, arg2_10)
	local var0_10 = 20

	arg0_10.timer = Timer.New(function()
		var0_10 = var0_10 - 1

		if var0_10 <= 0 then
			arg0_10:Clear()
			arg2_10()
			print("should exist ui node : " .. arg1_10.path)
			arg1_10.callback(nil)

			return
		end

		local var0_11 = var4_0(arg1_10)

		if var0_11 then
			arg0_10:Clear()
			arg2_10()
			arg1_10.callback(var0_11)
		end
	end, 0.5, -1)

	arg0_10.timer:Start()
	arg0_10.timer.func()
end

function var0_0.SearchWithoutDelay(arg0_12, arg1_12)
	local var0_12 = var2_0(arg1_12)

	arg0_12:Clear()
	arg1_12.callback(var0_12)
end

function var0_0.Clear(arg0_13)
	if arg0_13.delayTimer then
		arg0_13.delayTimer:Stop()

		arg0_13.delayTimer = nil
	end

	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end
end

return var0_0
