local var0_0 = import(".DynamicCellView")
local var1_0 = import(".ChampionCellView")
local var2_0 = class("DynamicChampionCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)
	var1_0.InitChampionCellTransform(arg0_1)
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityEnemy
end

function var2_0.SetActive(arg0_3, arg1_3)
	arg0_3:SetActiveModel(arg1_3)
end

function var2_0.SetActiveModel(arg0_4, arg1_4)
	arg0_4:SetSpineVisible(arg1_4)
	setActive(arg0_4.tfShadow, arg1_4)

	for iter0_4, iter1_4 in pairs(arg0_4._extraEffectList) do
		if not IsNil(iter1_4) then
			setActive(iter1_4, arg1_4)
		end
	end
end

function var2_0.PlayShuiHua()
	return
end

function var2_0.UpdateChampionCell(arg0_6, arg1_6, arg2_6, arg3_6)
	var1_0.UpdateChampionCell(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6:RefreshLinePosition(arg1_6, arg2_6)
end

function var2_0.TweenShining(arg0_7, arg1_7)
	arg0_7:StopTween()

	local var0_7 = arg0_7:GetSpineRole()

	if not var0_7 then
		return
	end

	var0_7:TweenShining(0.5, arg1_7, 0, 1, Color.New(0, 0, 0, 0), Color.New(1, 1, 1, 1), true, true)
end

function var2_0.StopTween(arg0_8)
	if not arg0_8.tweenId then
		return
	end

	LeanTween.cancel(arg0_8.tweenId, true)

	arg0_8.tweenId = nil
end

function var2_0.Clear(arg0_9)
	arg0_9:StopTween()

	if arg0_9.go then
		LeanTween.cancel(arg0_9.go)
	end

	var1_0.Clear(arg0_9)
end

return var2_0
