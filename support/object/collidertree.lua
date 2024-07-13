pg = pg or {}

local var0_0 = math.max
local var1_0 = math.min
local var2_0 = pg
local var3_0 = var2_0.CldNode
local var4_0 = table

var2_0.CldArea = class("CldArea")

function var2_0.CldArea.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.min = arg1_1
	arg0_1.max = arg2_1
	arg0_1.center = (arg1_1 + arg2_1):Mul(0.5)
	arg0_1.father = arg3_1

	if arg3_1 then
		arg0_1.level = arg3_1.level + 1
	else
		arg0_1.level = 1
	end

	arg0_1.isLeaf = true
	arg0_1.childs = {}
	arg0_1.nodes = {}
end

function var2_0.CldArea.AddNode(arg0_2, arg1_2)
	var4_0.insert(arg0_2.nodes, arg1_2)

	arg1_2.area = arg0_2
end

function var2_0.CldArea.InArea(arg0_3, arg1_3, arg2_3)
	if arg1_3.x < arg0_3.min.x or arg1_3.y < arg0_3.min.y then
		return false
	end

	if arg2_3.x > arg0_3.max.x or arg2_3.y > arg0_3.max.y then
		return false
	end

	return true
end

function var2_0.CldArea.GetAreaIndex(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.center
	local var1_4 = arg1_4.x >= var0_4.x and 0 or 2
	local var2_4 = arg2_4.x >= var0_4.x and 0 or 2

	if var1_4 ~= var2_4 then
		return 0
	end

	local var3_4 = var1_4 + (arg1_4.z >= var0_4.z and 1 or 2)

	return var3_4 == var2_4 + (arg2_4.z >= var0_4.z and 1 or 2) and var3_4 or 0
end

local var5_0 = class("ColliderTree")

var2_0.ColliderTree = var5_0
var5_0.MaxLayer = 3

local var6_0 = 6

function var5_0.Ctor(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg0_5.name = arg1_5
	arg0_5.root = var2_0.CldArea.New(arg2_5, arg3_5, nil)
	arg0_5.MaxLayer = arg4_5
	arg0_5.cldStack = {}
end

function var5_0.Insert(arg0_6, arg1_6)
	local var0_6 = arg1_6.area

	if var0_6 then
		var4_0.removebyvalue(var0_6.nodes, arg1_6)
	end

	arg0_6:_insert(arg1_6, arg0_6:_findParent(arg1_6, arg0_6.root))
end

function var5_0._findParent(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7.min
	local var1_7 = arg1_7.max
	local var2_7

	while not arg2_7.isLeaf do
		local var3_7 = arg2_7:GetAreaIndex(var0_7, var1_7)

		if var3_7 < 1 then
			break
		end

		arg2_7 = arg2_7.childs[var3_7]
	end

	return arg2_7
end

function var5_0._insert(arg0_8, arg1_8, arg2_8)
	local var0_8

	if not arg2_8.isLeaf or #arg2_8.nodes < var6_0 or arg2_8.level >= arg0_8.MaxLayer then
		arg2_8:AddNode(arg1_8)

		return
	end

	arg2_8.isLeaf = false

	local var1_8 = arg2_8.center
	local var2_8 = arg2_8.max
	local var3_8 = arg2_8.min

	arg2_8.childs[1] = var2_0.CldArea.New(var1_8, var2_8, arg2_8)
	arg2_8.childs[2] = var2_0.CldArea.New(Vector3(var1_8.x, 0, var3_8.z), Vector3(var2_8.x, 0, var1_8.z), arg2_8)
	arg2_8.childs[3] = var2_0.CldArea.New(Vector3(var3_8.x, 0, var1_8.z), Vector3(var1_8.x, 0, var2_8.z), arg2_8)
	arg2_8.childs[4] = var2_0.CldArea.New(var3_8, var1_8, arg2_8)

	for iter0_8 = #arg2_8.nodes, 1, -1 do
		local var4_8 = arg2_8.nodes[iter0_8]
		local var5_8 = arg2_8:GetAreaIndex(var4_8.min, var4_8.max)

		if var5_8 > 0 then
			arg2_8.childs[var5_8]:AddNode(var4_8)
			var4_0.remove(arg2_8.nodes, iter0_8)
		end
	end

	local var6_8 = arg2_8:GetAreaIndex(arg1_8.min, arg1_8.max)

	if var6_8 > 0 then
		arg2_8.childs[var6_8]:AddNode(arg1_8)
	else
		arg2_8:AddNode(arg1_8)
	end
end

function var5_0.Update(arg0_9, arg1_9)
	local var0_9 = arg1_9.area

	if var0_9 == nil then
		return
	end

	local var1_9 = arg1_9.min
	local var2_9 = arg1_9.max

	while var0_9.father do
		if var0_9:InArea(var1_9, var2_9) then
			break
		end

		var0_9 = var0_9.father
	end

	local var3_9 = arg0_9:_findParent(arg1_9, var0_9)

	if var3_9 ~= arg1_9.area then
		var4_0.removebyvalue(arg1_9.area.nodes, arg1_9)
		arg0_9:_insert(arg1_9, var3_9)
	end
end

function var5_0.Remove(arg0_10, arg1_10)
	local var0_10 = arg1_10.area

	if not var0_10 then
		return
	end

	var4_0.removebyvalue(var0_10.nodes, arg1_10)

	arg1_10.area = nil
end

function var5_0.Intersect(arg0_11, arg1_11, arg2_11, arg3_11)
	return arg0_11.x <= arg3_11.x and arg1_11.x >= arg2_11.x and arg0_11.z <= arg3_11.z and arg1_11.z >= arg2_11.z
end

function var5_0.CylinderCheck(arg0_12, arg1_12)
	if not arg0_12.cylinder and not arg1_12.cylinder then
		return true
	end

	if arg0_12.cylinder and arg1_12.cylinder then
		local var0_12 = arg0_12.center.x - arg1_12.center.x
		local var1_12 = arg0_12.center.z - arg1_12.center.z
		local var2_12 = arg0_12.range + arg1_12.range

		return var0_12 * var0_12 + var1_12 * var1_12 <= var2_12 * var2_12
	end

	local var3_12 = arg0_12.cylinder and arg0_12 or arg1_12
	local var4_12 = var3_12.range
	local var5_12 = var3_12.center.x
	local var6_12 = var3_12.center.z
	local var7_12 = arg0_12.cylinder and arg1_12 or arg0_12

	if var5_12 >= var7_12.min.x and var5_12 <= var7_12.max.x then
		return var6_12 >= var7_12.min.z - var4_12 and var6_12 <= var7_12.max.z + var4_12
	elseif var6_12 >= var7_12.min.z and var6_12 <= var7_12.max.z then
		return var5_12 >= var7_12.min.x - var4_12 and var5_12 <= var7_12.max.x + var4_12
	else
		local var8_12
		local var9_12

		if var5_12 < var7_12.min.x then
			var8_12 = var7_12.min.x - var5_12
		else
			var8_12 = var7_12.max.x - var5_12
		end

		if var6_12 < var7_12.min.z then
			var9_12 = var7_12.min.z - var6_12
		else
			var9_12 = var7_12.max.z - var6_12
		end

		return var8_12 * var8_12 + var9_12 * var9_12 < var4_12 * var4_12
	end
end

function var5_0.getTime(arg0_13, arg1_13, arg2_13)
	local var0_13 = 0

	if arg2_13.x ~= 0 then
		var0_13 = var0_0(0, (var0_0(arg0_13.min.x, arg1_13.min.x) - var1_0(arg0_13.max.x, arg1_13.max.x)) / arg2_13.x)
	end

	if arg2_13.z ~= 0 then
		var0_13 = var0_0(var0_13, (var0_0(arg0_13.min.z, arg1_13.min.z) - var1_0(arg0_13.max.z, arg1_13.max.z)) / arg2_13.z)
	end

	return var0_13
end

function var5_0.GetCldList(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg1_14.min
	local var1_14 = arg1_14.max
	local var2_14
	local var3_14 = arg0_14.root
	local var4_14 = {}

	while not var3_14.isLeaf do
		local var5_14 = var3_14:GetAreaIndex(var0_14, var1_14)

		if var5_14 < 1 then
			break
		end

		for iter0_14, iter1_14 in ipairs(var3_14.nodes) do
			if var5_0.Intersect(iter1_14.min, iter1_14.max, var0_14, var1_14) and var5_0.CylinderCheck(arg1_14, iter1_14) then
				var4_0.insert(var4_14, iter1_14)
			end
		end

		var3_14 = var3_14.childs[var5_14]
	end

	local var6_14 = arg0_14.cldStack

	var4_0.insert(var6_14, var3_14)

	while #var6_14 > 0 do
		local var7_14 = var4_0.remove(var6_14)

		for iter2_14, iter3_14 in ipairs(var7_14.nodes) do
			if var5_0.Intersect(iter3_14.min, iter3_14.max, var0_14, var1_14) and var5_0.CylinderCheck(arg1_14, iter3_14) then
				var4_0.insert(var4_14, iter3_14)
			end
		end

		for iter4_14, iter5_14 in pairs(var7_14.childs) do
			if iter5_14 ~= null and var5_0.Intersect(iter5_14.min, iter5_14.max, var0_14, var1_14) then
				var4_0.insert(var6_14, iter5_14)
			end
		end
	end

	return var4_14
end

function var5_0.GetCldListGradient(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = Vector3(math.cos(arg1_15), 0, math.sin(arg1_15))
	local var1_15 = Vector3.Cross(var0_15, Vector3.up)
	local var2_15 = {
		1,
		2,
		3,
		4,
		[1] = arg4_15 + var1_15 * (arg2_15 * -0.5),
		[2] = arg4_15 + var1_15 * (arg2_15 * 0.5)
	}
	local var3_15 = var0_15 * arg3_15

	var2_15[3] = var2_15[2] + var3_15
	var2_15[4] = var2_15[1] + var3_15

	local var4_15 = var2_0.CldNode.New()
	local var5_15 = Vector3(var1_0(var2_15[1].x, var2_15[2].x, var2_15[3].x, var2_15[4].x), 0, var1_0(var2_15[1].z, var2_15[2].z, var2_15[3].z, var2_15[4].z))
	local var6_15 = Vector3(var0_0(var2_15[1].x, var2_15[2].x, var2_15[3].x, var2_15[4].x), 0, var0_0(var2_15[1].z, var2_15[2].z, var2_15[3].z, var2_15[4].z))

	var4_15:UpdateStaticBox(var5_15, var6_15)

	local var7_15 = arg0_15:GetCldList(var4_15, nil)
	local var8_15 = var0_15.x * var0_15.z

	if var8_15 == 0 then
		return var7_15
	end

	local var9_15
	local var10_15
	local var11_15
	local var12_15

	for iter0_15 = #var7_15, 1, -1 do
		local var13_15 = var7_15[iter0_15]

		if var8_15 > 0 then
			var9_15 = var13_15.min
			var10_15 = var13_15.max
			var11_15 = Vector3(var9_15.x, 0, var10_15.z)
			var12_15 = Vector3(var10_15.x, 0, var9_15.z)
		else
			var11_15 = var13_15.min
			var12_15 = var13_15.max
			var9_15 = Vector3(var11_15.x, 0, var12_15.z)
			var10_15 = Vector3(var12_15.x, 0, var11_15.z)
		end

		repeat
			local var14_15 = Vector3.Dot(var0_15, var9_15 - var2_15[1])
			local var15_15 = Vector3.Dot(var0_15, var10_15 - var2_15[1])

			if var14_15 < 0 and var15_15 < 0 or arg3_15 < var14_15 and arg3_15 < var15_15 then
				var4_0.remove(var7_15, iter0_15)

				break
			end

			local var16_15 = Vector3.Dot(var1_15, var11_15 - var2_15[1])
			local var17_15 = Vector3.Dot(var1_15, var12_15 - var2_15[1])

			if var16_15 < 0 and var17_15 < 0 or arg2_15 < var16_15 and arg2_15 < var17_15 then
				var4_0.remove(var7_15, iter0_15)
			end

			break
		until true
	end

	return var7_15
end
