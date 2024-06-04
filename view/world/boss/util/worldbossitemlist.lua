local var0 = class("WorldBossItemList")
local var1 = 18
local var2 = -15
local var3 = 100

function var0.Ctor(arg0, arg1, arg2)
	arg0.tpl = arg2
	arg0.container = arg1
	arg0.angle = var1
	arg0.space = var2
	arg0.distance = var3
	arg0.tplHeight = arg0.tpl.rect.height
	arg0.trigger = arg0.container:GetComponent(typeof(EventTriggerListener))
	arg0.hrzOffset = (arg0.tplHeight + arg0.space) / math.tan((90 - arg0.angle) * math.rad(1))
	arg0.capacity = math.ceil(arg0.container.parent.parent.rect.height / (arg0.tplHeight + arg0.space))

	for iter0 = 1, arg0.capacity do
		cloneTplTo(arg0.tpl, arg0.container, iter0)
	end

	arg0.OnSwitch = nil
	arg0.OnRelease = nil

	setActive(arg0.tpl, false)

	arg0.tweens = {}

	arg0:AddListener()
end

function var0.Make(arg0, arg1, arg2, arg3)
	arg0.OnInit = arg1
	arg0.OnSwitch = arg2
	arg0.OnRelease = arg3
end

function var0.ClearTweens(arg0)
	for iter0, iter1 in ipairs(arg0.tweens) do
		if LeanTween.isTweening(iter1) then
			LeanTween.cancel(iter1)
		end
	end

	arg0.tweens = {}
end

function var0.Align(arg0, arg1, arg2)
	arg0:ClearTweens()

	arg0.childs = {}
	arg0.padding = 0
	arg0.animFlag = false
	arg0.totalCnt = arg1
	arg0.index = 0
	arg0.value = arg2 and arg2 or 0
	arg0.midIndex = math.ceil(arg0.capacity * 0.5)
	arg0.ranges = {
		math.huge,
		math.huge,
		arg0.capacity - arg0.midIndex + 1,
		arg0.midIndex - 1
	}

	if arg1 < arg0.capacity then
		local var0 = math.floor(arg1 * 0.5) + 1

		arg0.ranges[1] = arg1 - var0
		arg0.ranges[2] = var0
	end

	arg0:InitList()
end

function var0.InitList(arg0)
	for iter0 = 1, arg0.capacity do
		local var0 = arg0.container:GetChild(iter0 - 1)

		var0.localScale = Vector3.one

		var0.gameObject:SetActive(true)
		table.insert(arg0.childs, {
			index = -9999,
			tr = var0
		})
	end

	arg0.animTime = 0

	arg0:Switch()

	local var1 = arg0.value - 1
	local var2 = 1

	if arg0.totalCnt < arg0.capacity and arg0.value > arg0.ranges[2] then
		var1, var2 = arg0.totalCnt - arg0.value + 1, -1
	end

	for iter1 = 1, var1 do
		arg0:Switch(var2)
	end

	arg0:Release()

	arg0.animTime = 0.05
end

function var0.AddListener(arg0)
	local var0 = Vector2.zero
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = true

	local function var5(arg0)
		if arg0 > 0 then
			return arg0.index < arg0.ranges[2] - 1
		else
			return arg0.index > -arg0.ranges[1]
		end
	end

	arg0.trigger:AddBeginDragFunc(function(arg0, arg1)
		if arg0.animFlag then
			return
		end

		var1, var2 = 0, 0
		var0 = arg1.position
		var3 = var0.y
		var4 = true
	end)
	arg0.trigger:AddDragFunc(function(arg0, arg1)
		if arg0.animFlag then
			return
		end

		if var3 > arg1.position.y and var1 ~= 0 then
			var0, var1 = arg1.position, 0
		end

		if var3 < arg1.position.y and var2 ~= 0 then
			var0, var2 = arg1.position, 0
		end

		local var0 = arg1.position.y - var0.y

		if not var5(var0) then
			var4 = false

			return
		end

		local var1 = math.abs(var0 / arg0.distance)

		if var1 > var2 then
			var2 = var1

			arg0:Switch(var0)
		end

		if var1 < var1 then
			var1 = var1

			arg0:Switch(var0)
		end

		var3 = var0.y
	end)
	arg0.trigger:AddDragEndFunc(function(arg0, arg1)
		if not var4 then
			return
		end

		arg0:Release()
	end)
end

function var0.RefreshChildPos(arg0, arg1)
	arg0.animFlag, arg0.padding = true, 0

	local var0 = arg0.midIndex

	for iter0 = 1, #arg0.childs do
		local var1 = arg0.childs[iter0].tr

		if not IsNil(var1) then
			local var2 = iter0 - 1

			if iter0 == var0 or iter0 == var0 + 1 then
				arg0.padding = arg0.padding + math.abs(arg0.space) * 2
			end

			if arg0.totalCnt == 0 then
				arg0.padding = 0
			end

			local var3 = arg0.padding / math.tan((90 - arg0.angle) * math.rad(1))
			local var4 = Vector3(-arg0.hrzOffset * var2 - var3, -1 * (arg0.tplHeight + arg0.space) * var2 - arg0.padding, 0)
			local var5 = var4

			if arg1 and var4.y < var1.localPosition.y then
				var5 = Vector3(arg0.hrzOffset, arg0.tplHeight + arg0.space, 0)
			elseif not arg1 and var4.y > var1.localPosition.y then
				var1.localPosition = Vector3(arg0.hrzOffset, arg0.tplHeight + arg0.space, 0)
			end

			if iter0 == var0 or arg0.animTime <= 0 then
				var1:SetAsLastSibling()

				var1.localPosition = var4
			end

			table.insert(arg0.tweens, var1.gameObject)
			LeanTween.moveLocal(var1.gameObject, var5, arg0.animTime):setOnComplete(System.Action(function()
				if not IsNil(var1) then
					var1.localPosition = var4
				end

				arg0.animFlag = false
			end))
		end
	end
end

function var0.Switch(arg0, arg1)
	if arg1 then
		local var0 = table.remove(arg0.childs, arg1 > 0 and 1 or #arg0.childs)

		table.insert(arg0.childs, arg1 > 0 and #arg0.childs + 1 or 1, var0)

		arg0.index = (arg1 > 0 and 1 or -1) + arg0.index
	end

	local var1 = 0
	local var2 = 0

	if arg0.totalCnt < arg0.capacity then
		var2 = math.min(arg0.ranges[4] - arg0.ranges[1] - arg0.index, arg0.ranges[4])
		var1 = math.min(arg0.ranges[3] - arg0.ranges[2] + arg0.index, arg0.ranges[3])
	end

	local var3 = arg0.index % arg0.totalCnt

	for iter0, iter1 in ipairs(arg0.childs) do
		local var4 = iter1.index
		local var5 = iter0 - arg0.midIndex

		if var2 > 0 and iter0 <= var2 or var1 > 0 and var1 > arg0.capacity - iter0 then
			iter1.index = -1
		else
			iter1.index = (var5 + var3) % arg0.totalCnt
		end

		if var4 ~= iter1.index and arg0.OnInit then
			arg0.OnInit(iter1.tr, iter1.index)
		end
	end

	arg0:RefreshChildPos((arg1 or 0) > 0)

	local var6 = arg0.childs[arg0.midIndex]

	if arg0.OnSwitch ~= nil then
		arg0.OnSwitch(var6.tr, var6.index)
	end
end

function var0.SliceTo(arg0, arg1)
	if arg0.animFlag then
		return
	end

	local var0 = -1

	for iter0, iter1 in ipairs(arg0.childs) do
		if iter1.tr == arg1 then
			var0 = iter0

			break
		end
	end

	if var0 == -1 then
		return
	end

	local var1 = var0 - arg0.midIndex
	local var2 = Mathf.Sign(var1)
	local var3 = {}

	for iter2 = 1, math.abs(var1) do
		table.insert(var3, function(arg0)
			arg0:Switch(var2)
			Timer.New(arg0, arg0.animTime * 2, 1):Start()
		end)
	end

	seriesAsync(var3, function()
		arg0:Release()
	end)
end

function var0.Release(arg0)
	local var0 = arg0.childs[arg0.midIndex]

	if arg0.OnRelease ~= nil then
		arg0.OnRelease(var0.tr, var0.index)
	end
end

function var0.Dispose(arg0)
	arg0:ClearTweens()

	arg0.OnSwitch = nil
	arg0.OnRelease = nil
	arg0.OnInit = nil
end

return var0
