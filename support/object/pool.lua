pg = pg or {}

local var0 = pg
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = class("Pool")

var0.Pool = var2

function var2.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	assert(arg2, "template or transform should exist")

	arg0.template = arg2
	arg0.keepParent = arg5
	arg0.parentTF = arg1
	arg0.templateActive = arg2.activeSelf
	arg0.parentActive = arg1.gameObject.activeSelf
	arg0.keepActive = arg6
	arg0.min = arg3
	arg0.list = ys.LinkList.New()
	arg0.map = {}
	arg0.usedEnd = nil
	arg0.resizeTime = arg4
end

function var2.InitSize(arg0, arg1)
	arg1 = arg1 or arg0.min

	local var0 = {}

	for iter0 = 1, arg1 do
		var0[iter0] = arg0:GetObject()
	end

	for iter1 = 1, arg1 do
		arg0:Recycle(var0[iter1])
	end

	return arg0
end

function var2.SetInitFuncs(arg0, arg1)
	arg0.initFunc = arg1
end

function var2.SetRecycleFuncs(arg0, arg1)
	arg0.recycleFunc = arg1
end

function var2.IsEmpty(arg0)
	return arg0.usedEnd == arg0.list.Tail
end

function var2.GetRootTF(arg0)
	return arg0.parentTF
end

function var2.GetObject(arg0)
	local var0
	local var1 = arg0.usedEnd

	if not arg0:IsEmpty() then
		if var1 == nil then
			var1 = arg0.list.Head
		else
			var1 = arg0.usedEnd.Next
		end

		arg0.usedEnd = var1
		var0 = var1.Data
		arg0.map[var0] = var1

		LuaHelper.ResetTF(var0.transform)

		if not arg0.keepActive and arg0.parentActive then
			var0:SetActive(true)
		end
	else
		var0 = Object.Instantiate(arg0.template)

		if not arg0.templateActive then
			var0:SetActive(true)
		end

		if arg0.keepParent then
			var0.transform:SetParent(arg0.parentTF, false)
		end

		if arg0.initFunc then
			arg0.initFunc(var0)
		end

		local var2 = arg0.list:AddLast(var0)

		arg0.usedEnd = var2
		arg0.map[var0] = var2
	end

	return var0
end

function var2.ResetParent(arg0, arg1)
	arg0.parentTF = arg1

	for iter0 in arg0.list:Iterator() do
		iter0.Data.transform:SetParent(arg0.parentTF, false)
	end
end

function var2.Recycle(arg0, arg1)
	local var0 = arg0.map[arg1]

	if var0 == nil then
		var1.Destroy(arg1)

		return
	end

	arg0.map[arg1] = nil

	if not arg0.keepActive and arg0.parentActive then
		arg1:SetActive(false)
	end

	if not arg0.keepParent then
		LuaHelper.SetGOParentTF(arg1, arg0.parentTF, false)
	end

	if arg0.recycleFunc then
		arg0.recycleFunc(arg1)
	end

	if arg0.usedEnd == var0 then
		arg0.usedEnd = var0.Before
	end

	arg0.list:Remove(var0)
	arg0.list:AddNodeLast(var0)

	var0.liveTime = var0.TimeMgr.GetInstance():GetCombatTime() + arg0.resizeTime
end

function var2.AllRecycle(arg0)
	for iter0, iter1 in pairs(arg0.map) do
		arg0:Recycle(iter0)
	end
end

function var2.Resize(arg0)
	if arg0.list.Count <= arg0.min then
		return
	end

	local var0

	if arg0.usedEnd then
		var0 = arg0.usedEnd.Next
	else
		var0 = arg0.list.Head
	end

	local var1 = var0.TimeMgr.GetInstance():GetCombatTime()
	local var2 = 0

	while var0 do
		if var1 < var0.liveTime then
			break
		end

		var1.Destroy(var0.Data)

		var0 = var0.Next, arg0.list:Remove(var0)
		var2 = var2 + 1

		if var2 >= 6 or arg0.list.Count <= arg0.min then
			break
		end
	end
end

function var2.Dispose(arg0)
	for iter0 in arg0.list:Iterator() do
		var1.Destroy(iter0.Data)
	end

	arg0.list = nil
	arg0.map = nil
	arg0.last = nil
	arg0.template = nil
	arg0.parentTF = nil
end
