local var0 = class("GuildViewMissionNode")
local var1 = 200
local var2 = 150
local var3 = 100

var0.LINE_LEFT = 1
var0.LINE_RIGHT = 2
var0.TOP_LINK = 3
var0.BOTTOM_LINK = 4
var0.CENTER_LINK = 5
var0.TOP_HRZ_LINK = 6
var0.BOTTOM_HRZ_LINK = 7

function var0.Ctor(arg0, arg1)
	arg0._go = arg1.go
	arg0._tf = tf(arg0._go)
	arg0.slot = arg1.slot
	arg0.data = arg1.data
	arg0.parent = arg1.parent
	arg0.childs = {}
	arg0.offset = 0
	arg0.lineContainer = arg0._tf:Find("lines")
	arg0.lines = {}
	arg0.subLockBg = arg0._tf:Find("sub_lock")
	arg0.subUnlockBg = arg0._tf:Find("sub_unlock")
	arg0.unlockBg = arg0._tf:Find("unlock")
	arg0.lockBg = arg0._tf:Find("lock")
	arg0.nameTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.selected = arg0._tf:Find("selected")
	arg0.tip = arg0._tf:Find("tip")
end

function var0.Init(arg0)
	arg0:UpdateStyle()
	arg0:CalcOffset()
	arg0:SetPosition()
end

function var0.IsFinish(arg0)
	return arg0.data:IsFinish()
end

function var0.IsUnLock(arg0)
	if not arg0.parent then
		return true
	else
		return arg0:ParentIFinish() and arg0:IsActive()
	end
end

function var0.ParentIFinish(arg0)
	if not arg0.parent then
		return false
	end

	return arg0.parent:IsFinish()
end

function var0.ParentIsFinishByServer(arg0)
	if not arg0.parent then
		return false
	end

	return arg0.parent.data:IsFinishedByServer()
end

function var0.IsActive(arg0)
	return arg0.data:IsActive()
end

function var0.GetParentId(arg0)
	if not arg0.parent then
		return 0
	end

	return arg0.parent.data.id
end

function var0.UpdateData(arg0, arg1)
	arg0.data = arg1

	arg0:UpdateStyle()
	arg0:UpdateLineStyle()

	for iter0, iter1 in ipairs(arg0.childs) do
		iter1:UpdateStyle()
		iter1:UpdateLineStyle()
	end
end

function var0.UpdateStyle(arg0)
	local var0 = arg0:IsFinish()
	local var1 = not arg0:IsUnLock()
	local var2 = arg0:IsMain()

	setActive(arg0.subLockBg, not var0 and not var2 and var1)
	setActive(arg0.subUnlockBg, not var0 and not var2 and not var1)
	setActive(arg0.unlockBg, not var0 and var2 and not var1)
	setActive(arg0.lockBg, not var0 and var2 and var1)

	arg0.nameTxt.text = var1 and "" or arg0.data:GetName()

	arg0:UpdateTip()
end

function var0.UpdateTip(arg0)
	local var0 = arg0:IsUnLock() and arg0.data:CanFormation() and not arg0:IsFinish()

	setActive(arg0.tip, var0)
end

local var4 = {
	"blue",
	"gray",
	"yellow"
}

function var0.UpdateLineStyle(arg0)
	local var0

	local function var1(arg0, arg1)
		if arg0.gameObject.name == "line" then
			arg0:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/guildmissionui_atlas", arg1 .. "_line")
		elseif arg0.gameObject.name == "head" then
			arg0:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/guildmissionui_atlas", arg1)
		elseif arg0.gameObject.name == "adapter" then
			eachChild(arg0, function(arg0)
				var1(arg0, arg1)
			end)
		end
	end

	local var2 = arg0:IsFinish()

	for iter0, iter1 in ipairs(arg0.childs) do
		local var3 = arg0.lines[iter1]
		local var4 = iter1:IsMain()

		for iter2, iter3 in ipairs(var3) do
			local var5 = var2 and var4[2] or var4 and var4[3] or var4[1]

			var1(iter3.tf, var5)
		end
	end

	local var6 = arg0.lines[arg0] or {}
	local var7 = arg0:IsMain()
	local var8 = true

	if arg0.parent then
		var8 = arg0.parent:IsFinish()
	end

	for iter4, iter5 in ipairs(var6) do
		local var9

		if iter5.type == var0.LINE_LEFT then
			var9 = (var2 or var8) and var4[2] or var7 and var4[3] or var4[1]
		else
			var9 = var2 and var4[2] or var7 and var4[3] or var4[1]
		end

		var1(iter5.tf, var9)
	end
end

function var0.Selected(arg0, arg1)
	setActive(arg0.selected, arg1)
end

function var0.CalcOffset(arg0)
	if not arg0.parent then
		arg0.offset = 0

		return
	end

	if #arg0.parent.childs == 2 then
		local var0 = arg0:IsMain()
		local var1 = arg0:GetParentOffset()
		local var2 = 1
		local var3 = -1
		local var4 = math.abs(var1 + var2)
		local var5 = math.abs(var1 + var3)

		if var5 <= var4 then
			arg0.offset = var0 and var3 or var2
		elseif var4 < var5 then
			arg0.offset = var0 and var2 or var3
		end
	elseif #arg0.parent.childs == 1 then
		arg0.offset = 0 - arg0.parent:GetFirstNodeOffset()
	end
end

function var0.GetLocalPosition(arg0)
	if arg0.parent then
		local var0 = arg0:GetOffset()
		local var1 = (arg0.slot - 1) * (var1 + arg0._tf.sizeDelta.x)
		local var2 = arg0.parent:GetLocalPosition()
		local var3 = arg0:IsMain() and 0 or var3
		local var4 = var2.y + var0 * var2 + (var0 > 0 and var3 or -var3)

		return Vector3(var1, var4, 0)
	else
		return Vector3(0, 0, 0)
	end
end

function var0.SetPosition(arg0)
	local var0 = arg0:GetLocalPosition()

	arg0._tf.anchoredPosition = var0
end

function var0.AddChild(arg0, arg1)
	table.insert(arg0.childs, arg1)
end

function var0.GetChilds(arg0)
	return arg0.childs
end

function var0.HasParent(arg0)
	return arg0.parent ~= nil
end

function var0.HasChild(arg0)
	return #arg0.childs > 0
end

function var0.IsMain(arg0)
	return arg0.data:IsMain()
end

function var0.GetOffset(arg0)
	return arg0.offset
end

function var0.GetParentOffset(arg0)
	assert(arg0.parent)

	return arg0.parent:GetOffset()
end

function var0.GetFirstNodeOffset(arg0)
	local var0 = 0
	local var1 = arg0

	while var1.parent ~= nil do
		var0 = var0 + var1:GetOffset()
		var1 = var1.parent
	end

	return var0
end

function var0.AddLine(arg0, arg1, arg2, arg3)
	arg1 = tf(arg1)

	SetParent(arg1, arg0.lineContainer)

	if arg2 == var0.LINE_LEFT then
		if arg0:IsMain() then
			arg1.anchorMax = Vector2(0, 0.5)
			arg1.anchorMin = Vector2(0, 0.5)
			arg1.pivot = Vector2(1, 0.5)
			arg1.anchoredPosition = Vector2(0, 0)
		else
			arg1.pivot = Vector2(1, 0.5)

			if arg0:GetOffset() > 0 then
				arg1.anchorMax = Vector2(0.5, 0)
				arg1.anchorMin = Vector2(0.5, 0)
				arg1.eulerAngles = Vector3(0, 0, 90)
				arg1.anchoredPosition = Vector2(0, 0)
			else
				arg1.anchorMax = Vector2(0.5, 1)
				arg1.anchorMin = Vector2(0.5, 1)
				arg1.eulerAngles = Vector3(0, 0, -90)
				arg1.anchoredPosition = Vector2(0, 0)
			end
		end
	elseif arg2 == var0.LINE_RIGHT then
		arg1.anchorMax = Vector2(1, 0.5)
		arg1.anchorMin = Vector2(1, 0.5)
		arg1.pivot = Vector2(0, 0.5)
		arg1.anchoredPosition = Vector2(0, 0)
	elseif arg2 == var0.TOP_LINK then
		arg1.anchorMax = Vector2(1, 0.5)
		arg1.anchorMin = Vector2(1, 0.5)
		arg1.pivot = Vector2(1, 0.5)

		local var0 = arg0.lines[arg0][1].tf.sizeDelta.x

		arg1.anchoredPosition = Vector2(var0, 0)
		arg1.eulerAngles = Vector3(0, 0, -90)

		local var1 = arg3:GetLocalPosition().y - arg0:GetLocalPosition().y

		if arg3:IsMain() then
			arg1.sizeDelta = Vector2(var1, arg1.sizeDelta.y)
		else
			arg1.sizeDelta = Vector2(var1 - var0 - arg0._tf.sizeDelta.y / 2, arg1.sizeDelta.y)
		end
	elseif arg2 == var0.BOTTOM_LINK then
		arg1.anchorMax = Vector2(1, 0.5)
		arg1.anchorMin = Vector2(1, 0.5)
		arg1.pivot = Vector2(1, 0.5)

		local var2 = arg0.lines[arg0][1].tf.sizeDelta.x

		arg1.anchoredPosition = Vector2(var2, 0)
		arg1.eulerAngles = Vector3(0, 0, 90)

		local var3 = arg3:GetLocalPosition().y - arg0:GetLocalPosition().y

		if arg3:IsMain() then
			arg1.sizeDelta = Vector2(-var3, arg1.sizeDelta.y)
		else
			arg1.sizeDelta = Vector2(-var3 - var2 - arg0._tf.sizeDelta.y / 2, arg1.sizeDelta.y)
		end
	elseif arg2 == var0.TOP_HRZ_LINK then
		local var4 = arg0.lines[arg3][1].tf
		local var5 = arg0.lines[arg0][1].tf.sizeDelta.x
		local var6 = var4.sizeDelta.x + var4.anchoredPosition.y

		arg1.anchoredPosition = Vector2(var4.anchoredPosition.x, var6)

		local var7 = arg3:GetLocalPosition()
		local var8 = arg0:GetLocalPosition()
		local var9

		if arg3:IsMain() then
			var9 = var7.x - var8.x - 2 * var5 - arg0._tf.sizeDelta.x
		else
			nextNodeLposX = var7.x + arg0._tf.sizeDelta.x / 2
			var9 = nextNodeLposX - var8.x - arg0._tf.sizeDelta.x - var5
		end

		arg1.sizeDelta = Vector2(var9, arg1.sizeDelta.y)
	elseif arg2 == var0.BOTTOM_HRZ_LINK then
		local var10 = arg0.lines[arg3][1].tf
		local var11 = arg0.lines[arg0][1].tf.sizeDelta.x
		local var12 = var10.anchoredPosition.y - var10.sizeDelta.x

		arg1.anchoredPosition = Vector2(var10.anchoredPosition.x, var12)

		local var13 = arg3:GetLocalPosition()
		local var14 = arg0:GetLocalPosition()
		local var15

		if arg3:IsMain() then
			var15 = var13.x - var14.x - 2 * var11 - arg0._tf.sizeDelta.x
		else
			nextNodeLposX = var13.x + arg0._tf.sizeDelta.x / 2
			var15 = nextNodeLposX - var14.x - arg0._tf.sizeDelta.x - var11
		end

		arg1.sizeDelta = Vector2(var15, arg1.sizeDelta.y)
	elseif arg2 == var0.CENTER_LINK then
		local var16 = arg3:GetLocalPosition()
		local var17 = arg0:GetLocalPosition()
		local var18 = arg0.lines[arg0][1].tf.sizeDelta.x
		local var19 = var16.x - var17.x - arg0._tf.sizeDelta.x - 2 * var18

		arg1.anchorMax = Vector2(1, 0.5)
		arg1.anchorMin = Vector2(1, 0.5)
		arg1.anchoredPosition = Vector2(var18, 0)
		arg1.sizeDelta = Vector2(var19, arg1.sizeDelta.y)
	end

	if not arg0.lines[arg3] then
		arg0.lines[arg3] = {}
	end

	table.insert(arg0.lines[arg3], {
		tf = arg1,
		type = arg2
	})
end

return var0
