local var0_0 = class("WorldBossItemList")
local var1_0 = 18
local var2_0 = -15
local var3_0 = 100

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.tpl = arg2_1
	arg0_1.container = arg1_1
	arg0_1.angle = var1_0
	arg0_1.space = var2_0
	arg0_1.distance = var3_0
	arg0_1.tplHeight = arg0_1.tpl.rect.height
	arg0_1.trigger = arg0_1.container:GetComponent(typeof(EventTriggerListener))
	arg0_1.hrzOffset = (arg0_1.tplHeight + arg0_1.space) / math.tan((90 - arg0_1.angle) * math.rad(1))
	arg0_1.capacity = math.ceil(arg0_1.container.parent.parent.rect.height / (arg0_1.tplHeight + arg0_1.space))

	for iter0_1 = 1, arg0_1.capacity do
		cloneTplTo(arg0_1.tpl, arg0_1.container, iter0_1)
	end

	arg0_1.OnSwitch = nil
	arg0_1.OnRelease = nil

	setActive(arg0_1.tpl, false)

	arg0_1.tweens = {}

	arg0_1:AddListener()
end

function var0_0.Make(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.OnInit = arg1_2
	arg0_2.OnSwitch = arg2_2
	arg0_2.OnRelease = arg3_2
end

function var0_0.ClearTweens(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.tweens) do
		if LeanTween.isTweening(iter1_3) then
			LeanTween.cancel(iter1_3)
		end
	end

	arg0_3.tweens = {}
end

function var0_0.Align(arg0_4, arg1_4, arg2_4)
	arg0_4:ClearTweens()

	arg0_4.childs = {}
	arg0_4.padding = 0
	arg0_4.animFlag = false
	arg0_4.totalCnt = arg1_4
	arg0_4.index = 0
	arg0_4.value = arg2_4 and arg2_4 or 0
	arg0_4.midIndex = math.ceil(arg0_4.capacity * 0.5)
	arg0_4.ranges = {
		math.huge,
		math.huge,
		arg0_4.capacity - arg0_4.midIndex + 1,
		arg0_4.midIndex - 1
	}

	if arg1_4 < arg0_4.capacity then
		local var0_4 = math.floor(arg1_4 * 0.5) + 1

		arg0_4.ranges[1] = arg1_4 - var0_4
		arg0_4.ranges[2] = var0_4
	end

	arg0_4:InitList()
end

function var0_0.InitList(arg0_5)
	for iter0_5 = 1, arg0_5.capacity do
		local var0_5 = arg0_5.container:GetChild(iter0_5 - 1)

		var0_5.localScale = Vector3.one

		var0_5.gameObject:SetActive(true)
		table.insert(arg0_5.childs, {
			index = -9999,
			tr = var0_5
		})
	end

	arg0_5.animTime = 0

	arg0_5:Switch()

	local var1_5 = arg0_5.value - 1
	local var2_5 = 1

	if arg0_5.totalCnt < arg0_5.capacity and arg0_5.value > arg0_5.ranges[2] then
		var1_5, var2_5 = arg0_5.totalCnt - arg0_5.value + 1, -1
	end

	for iter1_5 = 1, var1_5 do
		arg0_5:Switch(var2_5)
	end

	arg0_5:Release()

	arg0_5.animTime = 0.05
end

function var0_0.AddListener(arg0_6)
	local var0_6 = Vector2.zero
	local var1_6 = 0
	local var2_6 = 0
	local var3_6 = 0
	local var4_6 = true

	local function var5_6(arg0_7)
		if arg0_7 > 0 then
			return arg0_6.index < arg0_6.ranges[2] - 1
		else
			return arg0_6.index > -arg0_6.ranges[1]
		end
	end

	arg0_6.trigger:AddBeginDragFunc(function(arg0_8, arg1_8)
		if arg0_6.animFlag then
			return
		end

		var1_6, var2_6 = 0, 0
		var0_6 = arg1_8.position
		var3_6 = var0_6.y
		var4_6 = true
	end)
	arg0_6.trigger:AddDragFunc(function(arg0_9, arg1_9)
		if arg0_6.animFlag then
			return
		end

		if var3_6 > arg1_9.position.y and var1_6 ~= 0 then
			var0_6, var1_6 = arg1_9.position, 0
		end

		if var3_6 < arg1_9.position.y and var2_6 ~= 0 then
			var0_6, var2_6 = arg1_9.position, 0
		end

		local var0_9 = arg1_9.position.y - var0_6.y

		if not var5_6(var0_9) then
			var4_6 = false

			return
		end

		local var1_9 = math.abs(var0_9 / arg0_6.distance)

		if var1_9 > var2_6 then
			var2_6 = var1_9

			arg0_6:Switch(var0_9)
		end

		if var1_9 < var1_6 then
			var1_6 = var1_9

			arg0_6:Switch(var0_9)
		end

		var3_6 = var0_6.y
	end)
	arg0_6.trigger:AddDragEndFunc(function(arg0_10, arg1_10)
		if not var4_6 then
			return
		end

		arg0_6:Release()
	end)
end

function var0_0.RefreshChildPos(arg0_11, arg1_11)
	arg0_11.animFlag, arg0_11.padding = true, 0

	local var0_11 = arg0_11.midIndex

	for iter0_11 = 1, #arg0_11.childs do
		local var1_11 = arg0_11.childs[iter0_11].tr

		if not IsNil(var1_11) then
			local var2_11 = iter0_11 - 1

			if iter0_11 == var0_11 or iter0_11 == var0_11 + 1 then
				arg0_11.padding = arg0_11.padding + math.abs(arg0_11.space) * 2
			end

			if arg0_11.totalCnt == 0 then
				arg0_11.padding = 0
			end

			local var3_11 = arg0_11.padding / math.tan((90 - arg0_11.angle) * math.rad(1))
			local var4_11 = Vector3(-arg0_11.hrzOffset * var2_11 - var3_11, -1 * (arg0_11.tplHeight + arg0_11.space) * var2_11 - arg0_11.padding, 0)
			local var5_11 = var4_11

			if arg1_11 and var4_11.y < var1_11.localPosition.y then
				var5_11 = Vector3(arg0_11.hrzOffset, arg0_11.tplHeight + arg0_11.space, 0)
			elseif not arg1_11 and var4_11.y > var1_11.localPosition.y then
				var1_11.localPosition = Vector3(arg0_11.hrzOffset, arg0_11.tplHeight + arg0_11.space, 0)
			end

			if iter0_11 == var0_11 or arg0_11.animTime <= 0 then
				var1_11:SetAsLastSibling()

				var1_11.localPosition = var4_11
			end

			table.insert(arg0_11.tweens, var1_11.gameObject)
			LeanTween.moveLocal(var1_11.gameObject, var5_11, arg0_11.animTime):setOnComplete(System.Action(function()
				if not IsNil(var1_11) then
					var1_11.localPosition = var4_11
				end

				arg0_11.animFlag = false
			end))
		end
	end
end

function var0_0.Switch(arg0_13, arg1_13)
	if arg1_13 then
		local var0_13 = table.remove(arg0_13.childs, arg1_13 > 0 and 1 or #arg0_13.childs)

		table.insert(arg0_13.childs, arg1_13 > 0 and #arg0_13.childs + 1 or 1, var0_13)

		arg0_13.index = (arg1_13 > 0 and 1 or -1) + arg0_13.index
	end

	local var1_13 = 0
	local var2_13 = 0

	if arg0_13.totalCnt < arg0_13.capacity then
		var2_13 = math.min(arg0_13.ranges[4] - arg0_13.ranges[1] - arg0_13.index, arg0_13.ranges[4])
		var1_13 = math.min(arg0_13.ranges[3] - arg0_13.ranges[2] + arg0_13.index, arg0_13.ranges[3])
	end

	local var3_13 = arg0_13.index % arg0_13.totalCnt

	for iter0_13, iter1_13 in ipairs(arg0_13.childs) do
		local var4_13 = iter1_13.index
		local var5_13 = iter0_13 - arg0_13.midIndex

		if var2_13 > 0 and iter0_13 <= var2_13 or var1_13 > 0 and var1_13 > arg0_13.capacity - iter0_13 then
			iter1_13.index = -1
		else
			iter1_13.index = (var5_13 + var3_13) % arg0_13.totalCnt
		end

		if var4_13 ~= iter1_13.index and arg0_13.OnInit then
			arg0_13.OnInit(iter1_13.tr, iter1_13.index)
		end
	end

	arg0_13:RefreshChildPos((arg1_13 or 0) > 0)

	local var6_13 = arg0_13.childs[arg0_13.midIndex]

	if arg0_13.OnSwitch ~= nil then
		arg0_13.OnSwitch(var6_13.tr, var6_13.index)
	end
end

function var0_0.SliceTo(arg0_14, arg1_14)
	if arg0_14.animFlag then
		return
	end

	local var0_14 = -1

	for iter0_14, iter1_14 in ipairs(arg0_14.childs) do
		if iter1_14.tr == arg1_14 then
			var0_14 = iter0_14

			break
		end
	end

	if var0_14 == -1 then
		return
	end

	local var1_14 = var0_14 - arg0_14.midIndex
	local var2_14 = Mathf.Sign(var1_14)
	local var3_14 = {}

	for iter2_14 = 1, math.abs(var1_14) do
		table.insert(var3_14, function(arg0_15)
			arg0_14:Switch(var2_14)
			Timer.New(arg0_15, arg0_14.animTime * 2, 1):Start()
		end)
	end

	seriesAsync(var3_14, function()
		arg0_14:Release()
	end)
end

function var0_0.Release(arg0_17)
	local var0_17 = arg0_17.childs[arg0_17.midIndex]

	if arg0_17.OnRelease ~= nil then
		arg0_17.OnRelease(var0_17.tr, var0_17.index)
	end
end

function var0_0.Dispose(arg0_18)
	arg0_18:ClearTweens()

	arg0_18.OnSwitch = nil
	arg0_18.OnRelease = nil
	arg0_18.OnInit = nil
end

return var0_0
