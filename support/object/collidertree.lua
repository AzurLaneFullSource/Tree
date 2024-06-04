pg = pg or {}

local var0 = math.max
local var1 = math.min
local var2 = pg
local var3 = var2.CldNode
local var4 = table

var2.CldArea = class("CldArea")

function var2.CldArea.Ctor(arg0, arg1, arg2, arg3)
	arg0.min = arg1
	arg0.max = arg2
	arg0.center = (arg1 + arg2):Mul(0.5)
	arg0.father = arg3

	if arg3 then
		arg0.level = arg3.level + 1
	else
		arg0.level = 1
	end

	arg0.isLeaf = true
	arg0.childs = {}
	arg0.nodes = {}
end

function var2.CldArea.AddNode(arg0, arg1)
	var4.insert(arg0.nodes, arg1)

	arg1.area = arg0
end

function var2.CldArea.InArea(arg0, arg1, arg2)
	if arg1.x < arg0.min.x or arg1.y < arg0.min.y then
		return false
	end

	if arg2.x > arg0.max.x or arg2.y > arg0.max.y then
		return false
	end

	return true
end

function var2.CldArea.GetAreaIndex(arg0, arg1, arg2)
	local var0 = arg0.center
	local var1 = arg1.x >= var0.x and 0 or 2
	local var2 = arg2.x >= var0.x and 0 or 2

	if var1 ~= var2 then
		return 0
	end

	local var3 = var1 + (arg1.z >= var0.z and 1 or 2)

	return var3 == var2 + (arg2.z >= var0.z and 1 or 2) and var3 or 0
end

local var5 = class("ColliderTree")

var2.ColliderTree = var5
var5.MaxLayer = 3

local var6 = 6

function var5.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.name = arg1
	arg0.root = var2.CldArea.New(arg2, arg3, nil)
	arg0.MaxLayer = arg4
	arg0.cldStack = {}
end

function var5.Insert(arg0, arg1)
	local var0 = arg1.area

	if var0 then
		var4.removebyvalue(var0.nodes, arg1)
	end

	arg0:_insert(arg1, arg0:_findParent(arg1, arg0.root))
end

function var5._findParent(arg0, arg1, arg2)
	local var0 = arg1.min
	local var1 = arg1.max
	local var2

	while not arg2.isLeaf do
		local var3 = arg2:GetAreaIndex(var0, var1)

		if var3 < 1 then
			break
		end

		arg2 = arg2.childs[var3]
	end

	return arg2
end

function var5._insert(arg0, arg1, arg2)
	local var0

	if not arg2.isLeaf or #arg2.nodes < var6 or arg2.level >= arg0.MaxLayer then
		arg2:AddNode(arg1)

		return
	end

	arg2.isLeaf = false

	local var1 = arg2.center
	local var2 = arg2.max
	local var3 = arg2.min

	arg2.childs[1] = var2.CldArea.New(var1, var2, arg2)
	arg2.childs[2] = var2.CldArea.New(Vector3(var1.x, 0, var3.z), Vector3(var2.x, 0, var1.z), arg2)
	arg2.childs[3] = var2.CldArea.New(Vector3(var3.x, 0, var1.z), Vector3(var1.x, 0, var2.z), arg2)
	arg2.childs[4] = var2.CldArea.New(var3, var1, arg2)

	for iter0 = #arg2.nodes, 1, -1 do
		local var4 = arg2.nodes[iter0]
		local var5 = arg2:GetAreaIndex(var4.min, var4.max)

		if var5 > 0 then
			arg2.childs[var5]:AddNode(var4)
			var4.remove(arg2.nodes, iter0)
		end
	end

	local var6 = arg2:GetAreaIndex(arg1.min, arg1.max)

	if var6 > 0 then
		arg2.childs[var6]:AddNode(arg1)
	else
		arg2:AddNode(arg1)
	end
end

function var5.Update(arg0, arg1)
	local var0 = arg1.area

	if var0 == nil then
		return
	end

	local var1 = arg1.min
	local var2 = arg1.max

	while var0.father do
		if var0:InArea(var1, var2) then
			break
		end

		var0 = var0.father
	end

	local var3 = arg0:_findParent(arg1, var0)

	if var3 ~= arg1.area then
		var4.removebyvalue(arg1.area.nodes, arg1)
		arg0:_insert(arg1, var3)
	end
end

function var5.Remove(arg0, arg1)
	local var0 = arg1.area

	if not var0 then
		return
	end

	var4.removebyvalue(var0.nodes, arg1)

	arg1.area = nil
end

function var5.Intersect(arg0, arg1, arg2, arg3)
	return arg0.x <= arg3.x and arg1.x >= arg2.x and arg0.z <= arg3.z and arg1.z >= arg2.z
end

function var5.CylinderCheck(arg0, arg1)
	if not arg0.cylinder and not arg1.cylinder then
		return true
	end

	if arg0.cylinder and arg1.cylinder then
		local var0 = arg0.center.x - arg1.center.x
		local var1 = arg0.center.z - arg1.center.z
		local var2 = arg0.range + arg1.range

		return var0 * var0 + var1 * var1 <= var2 * var2
	end

	local var3 = arg0.cylinder and arg0 or arg1
	local var4 = var3.range
	local var5 = var3.center.x
	local var6 = var3.center.z
	local var7 = arg0.cylinder and arg1 or arg0

	if var5 >= var7.min.x and var5 <= var7.max.x then
		return var6 >= var7.min.z - var4 and var6 <= var7.max.z + var4
	elseif var6 >= var7.min.z and var6 <= var7.max.z then
		return var5 >= var7.min.x - var4 and var5 <= var7.max.x + var4
	else
		local var8
		local var9

		if var5 < var7.min.x then
			var8 = var7.min.x - var5
		else
			var8 = var7.max.x - var5
		end

		if var6 < var7.min.z then
			var9 = var7.min.z - var6
		else
			var9 = var7.max.z - var6
		end

		return var8 * var8 + var9 * var9 < var4 * var4
	end
end

function var5.getTime(arg0, arg1, arg2)
	local var0 = 0

	if arg2.x ~= 0 then
		var0 = var0(0, (var0(arg0.min.x, arg1.min.x) - var1(arg0.max.x, arg1.max.x)) / arg2.x)
	end

	if arg2.z ~= 0 then
		var0 = var0(var0, (var0(arg0.min.z, arg1.min.z) - var1(arg0.max.z, arg1.max.z)) / arg2.z)
	end

	return var0
end

function var5.GetCldList(arg0, arg1, arg2)
	local var0 = arg1.min
	local var1 = arg1.max
	local var2
	local var3 = arg0.root
	local var4 = {}

	while not var3.isLeaf do
		local var5 = var3:GetAreaIndex(var0, var1)

		if var5 < 1 then
			break
		end

		for iter0, iter1 in ipairs(var3.nodes) do
			if var5.Intersect(iter1.min, iter1.max, var0, var1) and var5.CylinderCheck(arg1, iter1) then
				var4.insert(var4, iter1)
			end
		end

		var3 = var3.childs[var5]
	end

	local var6 = arg0.cldStack

	var4.insert(var6, var3)

	while #var6 > 0 do
		local var7 = var4.remove(var6)

		for iter2, iter3 in ipairs(var7.nodes) do
			if var5.Intersect(iter3.min, iter3.max, var0, var1) and var5.CylinderCheck(arg1, iter3) then
				var4.insert(var4, iter3)
			end
		end

		for iter4, iter5 in pairs(var7.childs) do
			if iter5 ~= null and var5.Intersect(iter5.min, iter5.max, var0, var1) then
				var4.insert(var6, iter5)
			end
		end
	end

	return var4
end

function var5.GetCldListGradient(arg0, arg1, arg2, arg3, arg4)
	local var0 = Vector3(math.cos(arg1), 0, math.sin(arg1))
	local var1 = Vector3.Cross(var0, Vector3.up)
	local var2 = {
		1,
		2,
		3,
		4,
		[1] = arg4 + var1 * (arg2 * -0.5),
		[2] = arg4 + var1 * (arg2 * 0.5)
	}
	local var3 = var0 * arg3

	var2[3] = var2[2] + var3
	var2[4] = var2[1] + var3

	local var4 = var2.CldNode.New()
	local var5 = Vector3(var1(var2[1].x, var2[2].x, var2[3].x, var2[4].x), 0, var1(var2[1].z, var2[2].z, var2[3].z, var2[4].z))
	local var6 = Vector3(var0(var2[1].x, var2[2].x, var2[3].x, var2[4].x), 0, var0(var2[1].z, var2[2].z, var2[3].z, var2[4].z))

	var4:UpdateStaticBox(var5, var6)

	local var7 = arg0:GetCldList(var4, nil)
	local var8 = var0.x * var0.z

	if var8 == 0 then
		return var7
	end

	local var9
	local var10
	local var11
	local var12

	for iter0 = #var7, 1, -1 do
		local var13 = var7[iter0]

		if var8 > 0 then
			var9 = var13.min
			var10 = var13.max
			var11 = Vector3(var9.x, 0, var10.z)
			var12 = Vector3(var10.x, 0, var9.z)
		else
			var11 = var13.min
			var12 = var13.max
			var9 = Vector3(var11.x, 0, var12.z)
			var10 = Vector3(var12.x, 0, var11.z)
		end

		repeat
			local var14 = Vector3.Dot(var0, var9 - var2[1])
			local var15 = Vector3.Dot(var0, var10 - var2[1])

			if var14 < 0 and var15 < 0 or arg3 < var14 and arg3 < var15 then
				var4.remove(var7, iter0)

				break
			end

			local var16 = Vector3.Dot(var1, var11 - var2[1])
			local var17 = Vector3.Dot(var1, var12 - var2[1])

			if var16 < 0 and var17 < 0 or arg2 < var16 and arg2 < var17 then
				var4.remove(var7, iter0)
			end

			break
		until true
	end

	return var7
end
