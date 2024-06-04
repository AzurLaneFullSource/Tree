local var0 = import(".DynamicCellView")
local var1 = import(".ChampionCellView")
local var2 = class("DynamicChampionCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var0.Ctor(arg0, arg1)
	var1.Ctor(arg0)
	var1.InitChampionCellTransform(arg0)
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityEnemy
end

function var2.SetActive(arg0, arg1)
	arg0:SetActiveModel(arg1)
end

function var2.SetActiveModel(arg0, arg1)
	arg0:SetSpineVisible(arg1)
	setActive(arg0.tfShadow, arg1)

	for iter0, iter1 in pairs(arg0._extraEffectList) do
		if not IsNil(iter1) then
			setActive(iter1, arg1)
		end
	end
end

function var2.PlayShuiHua()
	return
end

function var2.UpdateChampionCell(arg0, arg1, arg2, arg3)
	var1.UpdateChampionCell(arg0, arg1, arg2, arg3)
	arg0:RefreshLinePosition(arg1, arg2)
end

function var2.TweenShining(arg0, arg1)
	arg0:StopTween()

	local var0 = arg0:GetSpineRole()

	if not var0 then
		return
	end

	var0:TweenShining(0.5, arg1, 0, 1, Color.New(0, 0, 0, 0), Color.New(1, 1, 1, 1), true, true)
end

function var2.StopTween(arg0)
	if not arg0.tweenId then
		return
	end

	LeanTween.cancel(arg0.tweenId, true)

	arg0.tweenId = nil
end

function var2.Clear(arg0)
	arg0:StopTween()

	if arg0.go then
		LeanTween.cancel(arg0.go)
	end

	var1.Clear(arg0)
end

return var2
