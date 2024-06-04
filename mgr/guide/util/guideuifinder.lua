local var0 = class("GuideUIFinder")

function var0.Ctor(arg0, arg1)
	arg0.queue = {}
end

function var0.Search(arg0, arg1)
	table.insert(arg0.queue, arg1)

	if #arg0.queue == 1 then
		arg0:Start()
	end
end

function var0.Start(arg0)
	if #arg0.queue <= 0 then
		return
	end

	local var0 = arg0.queue[1]

	arg0:Clear()

	local function var1()
		table.remove(arg0.queue, 1)
		arg0:Start()
	end

	if (var0.delay or 0) > 0 then
		arg0.delayTimer = Timer.New(function()
			arg0:AddSearchTimer(var0, var1)
		end, var0.delay)

		arg0.delayTimer:Start()
	else
		arg0:AddSearchTimer(var0, var1)
	end
end

local function var1(arg0, arg1)
	local var0 = {}

	for iter0 = 0, arg0.childCount - 1 do
		local var1 = arg0:GetChild(iter0)
		local var2 = var1:GetComponent(typeof(LayoutElement))

		if not IsNil(var1) and go(var1).activeInHierarchy and (not var2 or not var2.ignoreLayout) then
			table.insert(var0, var1)
		end
	end

	return arg1 and var0[arg1 + 1] or var0[#var0]
end

local function var2(arg0)
	local var0 = GameObject.Find(arg0.path)

	if var0 and arg0.childIndex and arg0.childIndex == "#" then
		return var1(var0.transform)
	elseif var0 and arg0.childIndex and arg0.childIndex == -999 then
		return var1(var0.transform, 0)
	elseif var0 and arg0.childIndex and arg0.childIndex >= 0 then
		return var1(var0.transform, arg0.childIndex)
	elseif var0 then
		return var0.transform
	end

	return nil
end

local function var3(arg0)
	local var0 = var2(arg0)

	if var0 ~= nil then
		for iter0, iter1 in ipairs(arg0.conditionData) do
			local var1 = var0:Find(iter1)

			if var1 then
				return var1
			end
		end
	end

	return nil
end

local function var4(arg0)
	local var0

	if arg0.conditionData then
		var0 = var3(arg0)
	else
		var0 = var2(arg0)
	end

	if var0 then
		return var0
	end

	return nil
end

function var0.AddSearchTimer(arg0, arg1, arg2)
	local var0 = 20

	arg0.timer = Timer.New(function()
		var0 = var0 - 1

		if var0 <= 0 then
			arg0:Clear()
			arg2()
			print("should exist ui node : " .. arg1.path)
			arg1.callback(nil)

			return
		end

		local var0 = var4(arg1)

		if var0 then
			arg0:Clear()
			arg2()
			arg1.callback(var0)
		end
	end, 0.5, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.SearchWithoutDelay(arg0, arg1)
	local var0 = var2(arg1)

	arg0:Clear()
	arg1.callback(var0)
end

function var0.Clear(arg0)
	if arg0.delayTimer then
		arg0.delayTimer:Stop()

		arg0.delayTimer = nil
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

return var0
