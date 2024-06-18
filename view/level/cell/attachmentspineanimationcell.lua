local var0_0 = class("AttachmentSpineAnimationCell", import(".StaticCellView"))

var0_0.SDPosition = Vector2(0, -15)
var0_0.SDScale = Vector3(0.4, 0.4, 0.4)

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.name = nil
	arg0_1.model = nil
	arg0_1.anim = nil
	arg0_1.AnimIndex = nil
	arg0_1.group = {}
	arg0_1.timer = nil
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Set(arg0_3, arg1_3)
	if arg0_3.name == arg1_3 then
		return
	end

	arg0_3:ClearLoader()
	table.clear(arg0_3.group)

	arg0_3.name = arg1_3

	if IsNil(arg0_3.go) then
		arg0_3:PrepareBase("SD")
		arg0_3:OverrideCanvas()
		arg0_3:ResetCanvasOrder()
	end

	arg0_3:GetLoader():GetSpine(arg1_3, function(arg0_4)
		arg0_3.model = arg0_4
		arg0_3.anim = arg0_4:GetComponent("SpineAnimUI")

		setParent(arg0_4, arg0_3.go)

		arg0_4.transform.anchoredPosition = arg0_3.SDPosition
		arg0_4.transform.localScale = arg0_3.SDScale

		arg0_3:PlayAction(arg0_3.AnimIndex)
	end, "SD")
end

function var0_0.SetRoutine(arg0_5, arg1_5)
	table.clear(arg0_5.group)

	arg0_5.AnimIndex = nil

	for iter0_5, iter1_5 in ipairs(arg1_5 or {}) do
		arg0_5.group[iter0_5] = iter1_5
	end

	if #arg0_5.group < 1 then
		table.insert(arg0_5.group, {
			action = "default",
			duration = 9999
		})
	end

	arg0_5:PlayAction(math.min(#arg0_5.group, 1))
end

function var0_0.PlayAction(arg0_6, arg1_6)
	if not arg1_6 or arg1_6 <= 0 or arg1_6 > #arg0_6.group or arg0_6.AnimIndexPlaying == arg1_6 then
		return
	end

	arg0_6.AnimIndex = arg1_6

	if not arg0_6.loader or arg0_6.loader:GetLoadingRP("SD") or not arg0_6.anim then
		return
	end

	local var0_6 = arg0_6.group[arg1_6]

	arg0_6:ClearTimer()

	arg0_6.timer = Timer.New(function()
		arg1_6 = arg1_6 + 1

		if arg1_6 > #arg0_6.group then
			arg1_6 = math.min(#arg0_6.group, 1)
		end

		arg0_6:PlayAction(arg1_6)
	end, var0_6.duration)

	arg0_6.anim:SetAction(var0_6.action, 0)
	arg0_6.timer:Start()

	arg0_6.AnimIndexPlaying = arg1_6
end

function var0_0.ClearTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.Clear(arg0_9)
	arg0_9:ClearTimer()

	arg0_9.name = nil

	var0_0.super.Clear(arg0_9)
end

return var0_0
