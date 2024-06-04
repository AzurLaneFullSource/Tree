local var0 = class("AttachmentSpineAnimationCell", import(".StaticCellView"))

var0.SDPosition = Vector2(0, -15)
var0.SDScale = Vector3(0.4, 0.4, 0.4)

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.name = nil
	arg0.model = nil
	arg0.anim = nil
	arg0.AnimIndex = nil
	arg0.group = {}
	arg0.timer = nil
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Set(arg0, arg1)
	if arg0.name == arg1 then
		return
	end

	arg0:ClearLoader()
	table.clear(arg0.group)

	arg0.name = arg1

	if IsNil(arg0.go) then
		arg0:PrepareBase("SD")
		arg0:OverrideCanvas()
		arg0:ResetCanvasOrder()
	end

	arg0:GetLoader():GetSpine(arg1, function(arg0)
		arg0.model = arg0
		arg0.anim = arg0:GetComponent("SpineAnimUI")

		setParent(arg0, arg0.go)

		arg0.transform.anchoredPosition = arg0.SDPosition
		arg0.transform.localScale = arg0.SDScale

		arg0:PlayAction(arg0.AnimIndex)
	end, "SD")
end

function var0.SetRoutine(arg0, arg1)
	table.clear(arg0.group)

	arg0.AnimIndex = nil

	for iter0, iter1 in ipairs(arg1 or {}) do
		arg0.group[iter0] = iter1
	end

	if #arg0.group < 1 then
		table.insert(arg0.group, {
			action = "default",
			duration = 9999
		})
	end

	arg0:PlayAction(math.min(#arg0.group, 1))
end

function var0.PlayAction(arg0, arg1)
	if not arg1 or arg1 <= 0 or arg1 > #arg0.group or arg0.AnimIndexPlaying == arg1 then
		return
	end

	arg0.AnimIndex = arg1

	if not arg0.loader or arg0.loader:GetLoadingRP("SD") or not arg0.anim then
		return
	end

	local var0 = arg0.group[arg1]

	arg0:ClearTimer()

	arg0.timer = Timer.New(function()
		arg1 = arg1 + 1

		if arg1 > #arg0.group then
			arg1 = math.min(#arg0.group, 1)
		end

		arg0:PlayAction(arg1)
	end, var0.duration)

	arg0.anim:SetAction(var0.action, 0)
	arg0.timer:Start()

	arg0.AnimIndexPlaying = arg1
end

function var0.ClearTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Clear(arg0)
	arg0:ClearTimer()

	arg0.name = nil

	var0.super.Clear(arg0)
end

return var0
