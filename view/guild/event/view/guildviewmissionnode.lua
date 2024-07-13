local var0_0 = class("GuildViewMissionNode")
local var1_0 = 200
local var2_0 = 150
local var3_0 = 100

var0_0.LINE_LEFT = 1
var0_0.LINE_RIGHT = 2
var0_0.TOP_LINK = 3
var0_0.BOTTOM_LINK = 4
var0_0.CENTER_LINK = 5
var0_0.TOP_HRZ_LINK = 6
var0_0.BOTTOM_HRZ_LINK = 7

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1.go
	arg0_1._tf = tf(arg0_1._go)
	arg0_1.slot = arg1_1.slot
	arg0_1.data = arg1_1.data
	arg0_1.parent = arg1_1.parent
	arg0_1.childs = {}
	arg0_1.offset = 0
	arg0_1.lineContainer = arg0_1._tf:Find("lines")
	arg0_1.lines = {}
	arg0_1.subLockBg = arg0_1._tf:Find("sub_lock")
	arg0_1.subUnlockBg = arg0_1._tf:Find("sub_unlock")
	arg0_1.unlockBg = arg0_1._tf:Find("unlock")
	arg0_1.lockBg = arg0_1._tf:Find("lock")
	arg0_1.nameTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.selected = arg0_1._tf:Find("selected")
	arg0_1.tip = arg0_1._tf:Find("tip")
end

function var0_0.Init(arg0_2)
	arg0_2:UpdateStyle()
	arg0_2:CalcOffset()
	arg0_2:SetPosition()
end

function var0_0.IsFinish(arg0_3)
	return arg0_3.data:IsFinish()
end

function var0_0.IsUnLock(arg0_4)
	if not arg0_4.parent then
		return true
	else
		return arg0_4:ParentIFinish() and arg0_4:IsActive()
	end
end

function var0_0.ParentIFinish(arg0_5)
	if not arg0_5.parent then
		return false
	end

	return arg0_5.parent:IsFinish()
end

function var0_0.ParentIsFinishByServer(arg0_6)
	if not arg0_6.parent then
		return false
	end

	return arg0_6.parent.data:IsFinishedByServer()
end

function var0_0.IsActive(arg0_7)
	return arg0_7.data:IsActive()
end

function var0_0.GetParentId(arg0_8)
	if not arg0_8.parent then
		return 0
	end

	return arg0_8.parent.data.id
end

function var0_0.UpdateData(arg0_9, arg1_9)
	arg0_9.data = arg1_9

	arg0_9:UpdateStyle()
	arg0_9:UpdateLineStyle()

	for iter0_9, iter1_9 in ipairs(arg0_9.childs) do
		iter1_9:UpdateStyle()
		iter1_9:UpdateLineStyle()
	end
end

function var0_0.UpdateStyle(arg0_10)
	local var0_10 = arg0_10:IsFinish()
	local var1_10 = not arg0_10:IsUnLock()
	local var2_10 = arg0_10:IsMain()

	setActive(arg0_10.subLockBg, not var0_10 and not var2_10 and var1_10)
	setActive(arg0_10.subUnlockBg, not var0_10 and not var2_10 and not var1_10)
	setActive(arg0_10.unlockBg, not var0_10 and var2_10 and not var1_10)
	setActive(arg0_10.lockBg, not var0_10 and var2_10 and var1_10)

	arg0_10.nameTxt.text = var1_10 and "" or arg0_10.data:GetName()

	arg0_10:UpdateTip()
end

function var0_0.UpdateTip(arg0_11)
	local var0_11 = arg0_11:IsUnLock() and arg0_11.data:CanFormation() and not arg0_11:IsFinish()

	setActive(arg0_11.tip, var0_11)
end

local var4_0 = {
	"blue",
	"gray",
	"yellow"
}

function var0_0.UpdateLineStyle(arg0_12)
	local var0_12

	local function var1_12(arg0_13, arg1_13)
		if arg0_13.gameObject.name == "line" then
			arg0_13:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/guildmissionui_atlas", arg1_13 .. "_line")
		elseif arg0_13.gameObject.name == "head" then
			arg0_13:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/guildmissionui_atlas", arg1_13)
		elseif arg0_13.gameObject.name == "adapter" then
			eachChild(arg0_13, function(arg0_14)
				var1_12(arg0_14, arg1_13)
			end)
		end
	end

	local var2_12 = arg0_12:IsFinish()

	for iter0_12, iter1_12 in ipairs(arg0_12.childs) do
		local var3_12 = arg0_12.lines[iter1_12]
		local var4_12 = iter1_12:IsMain()

		for iter2_12, iter3_12 in ipairs(var3_12) do
			local var5_12 = var2_12 and var4_0[2] or var4_12 and var4_0[3] or var4_0[1]

			var1_12(iter3_12.tf, var5_12)
		end
	end

	local var6_12 = arg0_12.lines[arg0_12] or {}
	local var7_12 = arg0_12:IsMain()
	local var8_12 = true

	if arg0_12.parent then
		var8_12 = arg0_12.parent:IsFinish()
	end

	for iter4_12, iter5_12 in ipairs(var6_12) do
		local var9_12

		if iter5_12.type == var0_0.LINE_LEFT then
			var9_12 = (var2_12 or var8_12) and var4_0[2] or var7_12 and var4_0[3] or var4_0[1]
		else
			var9_12 = var2_12 and var4_0[2] or var7_12 and var4_0[3] or var4_0[1]
		end

		var1_12(iter5_12.tf, var9_12)
	end
end

function var0_0.Selected(arg0_15, arg1_15)
	setActive(arg0_15.selected, arg1_15)
end

function var0_0.CalcOffset(arg0_16)
	if not arg0_16.parent then
		arg0_16.offset = 0

		return
	end

	if #arg0_16.parent.childs == 2 then
		local var0_16 = arg0_16:IsMain()
		local var1_16 = arg0_16:GetParentOffset()
		local var2_16 = 1
		local var3_16 = -1
		local var4_16 = math.abs(var1_16 + var2_16)
		local var5_16 = math.abs(var1_16 + var3_16)

		if var5_16 <= var4_16 then
			arg0_16.offset = var0_16 and var3_16 or var2_16
		elseif var4_16 < var5_16 then
			arg0_16.offset = var0_16 and var2_16 or var3_16
		end
	elseif #arg0_16.parent.childs == 1 then
		arg0_16.offset = 0 - arg0_16.parent:GetFirstNodeOffset()
	end
end

function var0_0.GetLocalPosition(arg0_17)
	if arg0_17.parent then
		local var0_17 = arg0_17:GetOffset()
		local var1_17 = (arg0_17.slot - 1) * (var1_0 + arg0_17._tf.sizeDelta.x)
		local var2_17 = arg0_17.parent:GetLocalPosition()
		local var3_17 = arg0_17:IsMain() and 0 or var3_0
		local var4_17 = var2_17.y + var0_17 * var2_0 + (var0_17 > 0 and var3_17 or -var3_17)

		return Vector3(var1_17, var4_17, 0)
	else
		return Vector3(0, 0, 0)
	end
end

function var0_0.SetPosition(arg0_18)
	local var0_18 = arg0_18:GetLocalPosition()

	arg0_18._tf.anchoredPosition = var0_18
end

function var0_0.AddChild(arg0_19, arg1_19)
	table.insert(arg0_19.childs, arg1_19)
end

function var0_0.GetChilds(arg0_20)
	return arg0_20.childs
end

function var0_0.HasParent(arg0_21)
	return arg0_21.parent ~= nil
end

function var0_0.HasChild(arg0_22)
	return #arg0_22.childs > 0
end

function var0_0.IsMain(arg0_23)
	return arg0_23.data:IsMain()
end

function var0_0.GetOffset(arg0_24)
	return arg0_24.offset
end

function var0_0.GetParentOffset(arg0_25)
	assert(arg0_25.parent)

	return arg0_25.parent:GetOffset()
end

function var0_0.GetFirstNodeOffset(arg0_26)
	local var0_26 = 0
	local var1_26 = arg0_26

	while var1_26.parent ~= nil do
		var0_26 = var0_26 + var1_26:GetOffset()
		var1_26 = var1_26.parent
	end

	return var0_26
end

function var0_0.AddLine(arg0_27, arg1_27, arg2_27, arg3_27)
	arg1_27 = tf(arg1_27)

	SetParent(arg1_27, arg0_27.lineContainer)

	if arg2_27 == var0_0.LINE_LEFT then
		if arg0_27:IsMain() then
			arg1_27.anchorMax = Vector2(0, 0.5)
			arg1_27.anchorMin = Vector2(0, 0.5)
			arg1_27.pivot = Vector2(1, 0.5)
			arg1_27.anchoredPosition = Vector2(0, 0)
		else
			arg1_27.pivot = Vector2(1, 0.5)

			if arg0_27:GetOffset() > 0 then
				arg1_27.anchorMax = Vector2(0.5, 0)
				arg1_27.anchorMin = Vector2(0.5, 0)
				arg1_27.eulerAngles = Vector3(0, 0, 90)
				arg1_27.anchoredPosition = Vector2(0, 0)
			else
				arg1_27.anchorMax = Vector2(0.5, 1)
				arg1_27.anchorMin = Vector2(0.5, 1)
				arg1_27.eulerAngles = Vector3(0, 0, -90)
				arg1_27.anchoredPosition = Vector2(0, 0)
			end
		end
	elseif arg2_27 == var0_0.LINE_RIGHT then
		arg1_27.anchorMax = Vector2(1, 0.5)
		arg1_27.anchorMin = Vector2(1, 0.5)
		arg1_27.pivot = Vector2(0, 0.5)
		arg1_27.anchoredPosition = Vector2(0, 0)
	elseif arg2_27 == var0_0.TOP_LINK then
		arg1_27.anchorMax = Vector2(1, 0.5)
		arg1_27.anchorMin = Vector2(1, 0.5)
		arg1_27.pivot = Vector2(1, 0.5)

		local var0_27 = arg0_27.lines[arg0_27][1].tf.sizeDelta.x

		arg1_27.anchoredPosition = Vector2(var0_27, 0)
		arg1_27.eulerAngles = Vector3(0, 0, -90)

		local var1_27 = arg3_27:GetLocalPosition().y - arg0_27:GetLocalPosition().y

		if arg3_27:IsMain() then
			arg1_27.sizeDelta = Vector2(var1_27, arg1_27.sizeDelta.y)
		else
			arg1_27.sizeDelta = Vector2(var1_27 - var0_27 - arg0_27._tf.sizeDelta.y / 2, arg1_27.sizeDelta.y)
		end
	elseif arg2_27 == var0_0.BOTTOM_LINK then
		arg1_27.anchorMax = Vector2(1, 0.5)
		arg1_27.anchorMin = Vector2(1, 0.5)
		arg1_27.pivot = Vector2(1, 0.5)

		local var2_27 = arg0_27.lines[arg0_27][1].tf.sizeDelta.x

		arg1_27.anchoredPosition = Vector2(var2_27, 0)
		arg1_27.eulerAngles = Vector3(0, 0, 90)

		local var3_27 = arg3_27:GetLocalPosition().y - arg0_27:GetLocalPosition().y

		if arg3_27:IsMain() then
			arg1_27.sizeDelta = Vector2(-var3_27, arg1_27.sizeDelta.y)
		else
			arg1_27.sizeDelta = Vector2(-var3_27 - var2_27 - arg0_27._tf.sizeDelta.y / 2, arg1_27.sizeDelta.y)
		end
	elseif arg2_27 == var0_0.TOP_HRZ_LINK then
		local var4_27 = arg0_27.lines[arg3_27][1].tf
		local var5_27 = arg0_27.lines[arg0_27][1].tf.sizeDelta.x
		local var6_27 = var4_27.sizeDelta.x + var4_27.anchoredPosition.y

		arg1_27.anchoredPosition = Vector2(var4_27.anchoredPosition.x, var6_27)

		local var7_27 = arg3_27:GetLocalPosition()
		local var8_27 = arg0_27:GetLocalPosition()
		local var9_27

		if arg3_27:IsMain() then
			var9_27 = var7_27.x - var8_27.x - 2 * var5_27 - arg0_27._tf.sizeDelta.x
		else
			nextNodeLposX = var7_27.x + arg0_27._tf.sizeDelta.x / 2
			var9_27 = nextNodeLposX - var8_27.x - arg0_27._tf.sizeDelta.x - var5_27
		end

		arg1_27.sizeDelta = Vector2(var9_27, arg1_27.sizeDelta.y)
	elseif arg2_27 == var0_0.BOTTOM_HRZ_LINK then
		local var10_27 = arg0_27.lines[arg3_27][1].tf
		local var11_27 = arg0_27.lines[arg0_27][1].tf.sizeDelta.x
		local var12_27 = var10_27.anchoredPosition.y - var10_27.sizeDelta.x

		arg1_27.anchoredPosition = Vector2(var10_27.anchoredPosition.x, var12_27)

		local var13_27 = arg3_27:GetLocalPosition()
		local var14_27 = arg0_27:GetLocalPosition()
		local var15_27

		if arg3_27:IsMain() then
			var15_27 = var13_27.x - var14_27.x - 2 * var11_27 - arg0_27._tf.sizeDelta.x
		else
			nextNodeLposX = var13_27.x + arg0_27._tf.sizeDelta.x / 2
			var15_27 = nextNodeLposX - var14_27.x - arg0_27._tf.sizeDelta.x - var11_27
		end

		arg1_27.sizeDelta = Vector2(var15_27, arg1_27.sizeDelta.y)
	elseif arg2_27 == var0_0.CENTER_LINK then
		local var16_27 = arg3_27:GetLocalPosition()
		local var17_27 = arg0_27:GetLocalPosition()
		local var18_27 = arg0_27.lines[arg0_27][1].tf.sizeDelta.x
		local var19_27 = var16_27.x - var17_27.x - arg0_27._tf.sizeDelta.x - 2 * var18_27

		arg1_27.anchorMax = Vector2(1, 0.5)
		arg1_27.anchorMin = Vector2(1, 0.5)
		arg1_27.anchoredPosition = Vector2(var18_27, 0)
		arg1_27.sizeDelta = Vector2(var19_27, arg1_27.sizeDelta.y)
	end

	if not arg0_27.lines[arg3_27] then
		arg0_27.lines[arg3_27] = {}
	end

	table.insert(arg0_27.lines[arg3_27], {
		tf = arg1_27,
		type = arg2_27
	})
end

return var0_0
