local var0 = class("LevelStageComboPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "LevelStageComboPanel"
end

function var0.OnInit(arg0)
	arg0.tf_combo = arg0:findTF("combo/text")
	arg0.text_combo = arg0.tf_combo:GetComponent(typeof(Text))
	arg0.tf_perfect = arg0:findTF("perfect/text")
	arg0.text_perfect = arg0.tf_perfect:GetComponent(typeof(Text))
	arg0.tf_good = arg0:findTF("good/text")
	arg0.text_good = arg0.tf_good:GetComponent(typeof(Text))
	arg0.tf_miss = arg0:findTF("miss/text")
	arg0.text_miss = arg0.tf_miss:GetComponent(typeof(Text))
	arg0.anims = {}
end

function var0.UpdateView(arg0, arg1)
	if not arg1 then
		return
	end

	setText(arg0.text_combo, arg1.combo or 0)

	local var0 = arg1.scoreHistory

	if var0 then
		arg0.text_perfect.text = var0[4] or 0
		arg0.text_good.text = (var0[2] or 0) + (var0[3] or 0)
		arg0.text_miss.text = (var0[0] or 0) + (var0[1] or 0)
	end
end

function var0.UpdateViewAnimated(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:SetTextAnim(arg0.tf_combo, arg0.text_combo, arg1.combo or 0, 1)

	local var0 = arg1.scoreHistory

	if var0 then
		arg0:SetTextAnim(arg0.tf_perfect, arg0.text_perfect, var0[4] or 0, 2)
		arg0:SetTextAnim(arg0.tf_good, arg0.text_good, (var0[2] or 0) + (var0[3] or 0), 3)
		arg0:SetTextAnim(arg0.tf_miss, arg0.text_miss, (var0[0] or 0) + (var0[1] or 0), 4)
	end
end

function var0.SetTextAnim(arg0, arg1, arg2, arg3, arg4)
	if tonumber(arg2.text) == arg3 then
		return
	end

	local var0 = false
	local var1 = arg1.localPosition
	local var2 = var1 + Vector3(0, 30, 0)

	arg0.anims[arg4] = LeanTween.value(go(arg1), 0, 1, 0.3):setLoopPingPong(1):setOnUpdate(System.Action_float(function(arg0)
		arg1.localPosition = Vector3.Lerp(var1, var2, arg0)

		if arg0 >= 1 and not var0 then
			arg2.text = arg3
			var0 = true
		end
	end)).id
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.anims) do
		LeanTween.cancel(iter1)
	end

	table.clear(arg0.anims)
end

return var0
