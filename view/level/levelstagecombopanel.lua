local var0_0 = class("LevelStageComboPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageComboPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.tf_combo = arg0_2:findTF("combo/text")
	arg0_2.text_combo = arg0_2.tf_combo:GetComponent(typeof(Text))
	arg0_2.tf_perfect = arg0_2:findTF("perfect/text")
	arg0_2.text_perfect = arg0_2.tf_perfect:GetComponent(typeof(Text))
	arg0_2.tf_good = arg0_2:findTF("good/text")
	arg0_2.text_good = arg0_2.tf_good:GetComponent(typeof(Text))
	arg0_2.tf_miss = arg0_2:findTF("miss/text")
	arg0_2.text_miss = arg0_2.tf_miss:GetComponent(typeof(Text))
	arg0_2.anims = {}
end

function var0_0.UpdateView(arg0_3, arg1_3)
	if not arg1_3 then
		return
	end

	setText(arg0_3.text_combo, arg1_3.combo or 0)

	local var0_3 = arg1_3.scoreHistory

	if var0_3 then
		arg0_3.text_perfect.text = var0_3[4] or 0
		arg0_3.text_good.text = (var0_3[2] or 0) + (var0_3[3] or 0)
		arg0_3.text_miss.text = (var0_3[0] or 0) + (var0_3[1] or 0)
	end
end

function var0_0.UpdateViewAnimated(arg0_4, arg1_4)
	if not arg1_4 then
		return
	end

	arg0_4:SetTextAnim(arg0_4.tf_combo, arg0_4.text_combo, arg1_4.combo or 0, 1)

	local var0_4 = arg1_4.scoreHistory

	if var0_4 then
		arg0_4:SetTextAnim(arg0_4.tf_perfect, arg0_4.text_perfect, var0_4[4] or 0, 2)
		arg0_4:SetTextAnim(arg0_4.tf_good, arg0_4.text_good, (var0_4[2] or 0) + (var0_4[3] or 0), 3)
		arg0_4:SetTextAnim(arg0_4.tf_miss, arg0_4.text_miss, (var0_4[0] or 0) + (var0_4[1] or 0), 4)
	end
end

function var0_0.SetTextAnim(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	if tonumber(arg2_5.text) == arg3_5 then
		return
	end

	local var0_5 = false
	local var1_5 = arg1_5.localPosition
	local var2_5 = var1_5 + Vector3(0, 30, 0)

	arg0_5.anims[arg4_5] = LeanTween.value(go(arg1_5), 0, 1, 0.3):setLoopPingPong(1):setOnUpdate(System.Action_float(function(arg0_6)
		arg1_5.localPosition = Vector3.Lerp(var1_5, var2_5, arg0_6)

		if arg0_6 >= 1 and not var0_5 then
			arg2_5.text = arg3_5
			var0_5 = true
		end
	end)).id
end

function var0_0.OnDestroy(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.anims) do
		LeanTween.cancel(iter1_7)
	end

	table.clear(arg0_7.anims)
end

return var0_0
