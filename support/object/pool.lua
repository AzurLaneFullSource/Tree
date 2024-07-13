pg = pg or {}

local var0_0 = pg
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = class("Pool")

var0_0.Pool = var2_0

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	assert(arg2_1, "template or transform should exist")

	arg0_1.template = arg2_1
	arg0_1.keepParent = arg5_1
	arg0_1.parentTF = arg1_1
	arg0_1.templateActive = arg2_1.activeSelf
	arg0_1.parentActive = arg1_1.gameObject.activeSelf
	arg0_1.keepActive = arg6_1
	arg0_1.min = arg3_1
	arg0_1.list = ys.LinkList.New()
	arg0_1.map = {}
	arg0_1.usedEnd = nil
	arg0_1.resizeTime = arg4_1
end

function var2_0.InitSize(arg0_2, arg1_2)
	arg1_2 = arg1_2 or arg0_2.min

	local var0_2 = {}

	for iter0_2 = 1, arg1_2 do
		var0_2[iter0_2] = arg0_2:GetObject()
	end

	for iter1_2 = 1, arg1_2 do
		arg0_2:Recycle(var0_2[iter1_2])
	end

	return arg0_2
end

function var2_0.SetInitFuncs(arg0_3, arg1_3)
	arg0_3.initFunc = arg1_3
end

function var2_0.SetRecycleFuncs(arg0_4, arg1_4)
	arg0_4.recycleFunc = arg1_4
end

function var2_0.IsEmpty(arg0_5)
	return arg0_5.usedEnd == arg0_5.list.Tail
end

function var2_0.GetRootTF(arg0_6)
	return arg0_6.parentTF
end

function var2_0.GetObject(arg0_7)
	local var0_7
	local var1_7 = arg0_7.usedEnd

	if not arg0_7:IsEmpty() then
		if var1_7 == nil then
			var1_7 = arg0_7.list.Head
		else
			var1_7 = arg0_7.usedEnd.Next
		end

		arg0_7.usedEnd = var1_7
		var0_7 = var1_7.Data
		arg0_7.map[var0_7] = var1_7

		LuaHelper.ResetTF(var0_7.transform)

		if not arg0_7.keepActive and arg0_7.parentActive then
			var0_7:SetActive(true)
		end
	else
		var0_7 = Object.Instantiate(arg0_7.template)

		if not arg0_7.templateActive then
			var0_7:SetActive(true)
		end

		if arg0_7.keepParent then
			var0_7.transform:SetParent(arg0_7.parentTF, false)
		end

		if arg0_7.initFunc then
			arg0_7.initFunc(var0_7)
		end

		local var2_7 = arg0_7.list:AddLast(var0_7)

		arg0_7.usedEnd = var2_7
		arg0_7.map[var0_7] = var2_7
	end

	return var0_7
end

function var2_0.ResetParent(arg0_8, arg1_8)
	arg0_8.parentTF = arg1_8

	for iter0_8 in arg0_8.list:Iterator() do
		iter0_8.Data.transform:SetParent(arg0_8.parentTF, false)
	end
end

function var2_0.Recycle(arg0_9, arg1_9)
	local var0_9 = arg0_9.map[arg1_9]

	if var0_9 == nil then
		var1_0.Destroy(arg1_9)

		return
	end

	arg0_9.map[arg1_9] = nil

	if not arg0_9.keepActive and arg0_9.parentActive then
		arg1_9:SetActive(false)
	end

	if not arg0_9.keepParent then
		LuaHelper.SetGOParentTF(arg1_9, arg0_9.parentTF, false)
	end

	if arg0_9.recycleFunc then
		arg0_9.recycleFunc(arg1_9)
	end

	if arg0_9.usedEnd == var0_9 then
		arg0_9.usedEnd = var0_9.Before
	end

	arg0_9.list:Remove(var0_9)
	arg0_9.list:AddNodeLast(var0_9)

	var0_9.liveTime = var0_0.TimeMgr.GetInstance():GetCombatTime() + arg0_9.resizeTime
end

function var2_0.AllRecycle(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.map) do
		arg0_10:Recycle(iter0_10)
	end
end

function var2_0.Resize(arg0_11)
	if arg0_11.list.Count <= arg0_11.min then
		return
	end

	local var0_11

	if arg0_11.usedEnd then
		var0_11 = arg0_11.usedEnd.Next
	else
		var0_11 = arg0_11.list.Head
	end

	local var1_11 = var0_0.TimeMgr.GetInstance():GetCombatTime()
	local var2_11 = 0

	while var0_11 do
		if var1_11 < var0_11.liveTime then
			break
		end

		var1_0.Destroy(var0_11.Data)

		var0_11 = var0_11.Next, arg0_11.list:Remove(var0_11)
		var2_11 = var2_11 + 1

		if var2_11 >= 6 or arg0_11.list.Count <= arg0_11.min then
			break
		end
	end
end

function var2_0.Dispose(arg0_12)
	for iter0_12 in arg0_12.list:Iterator() do
		var1_0.Destroy(iter0_12.Data)
	end

	arg0_12.list = nil
	arg0_12.map = nil
	arg0_12.last = nil
	arg0_12.template = nil
	arg0_12.parentTF = nil
end
