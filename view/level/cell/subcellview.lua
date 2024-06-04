local var0 = import(".DynamicCellView")
local var1 = import(".SpineCellView")
local var2 = class("SubCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var0.Ctor(arg0, arg1)
	var1.Ctor(arg0)
	var1.InitCellTransform(arg0)

	arg0.tfAmmo = arg0.tf:Find("ammo")
	arg0.tfAmmoText = arg0.tfAmmo:Find("text")
	arg0.showFlag = true
	arg0.shuihuaLoader = AutoLoader.New()

	arg0:LoadEffectShuihua()
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityFleet
end

function var2.OverrideCanvas(arg0)
	var2.super.OverrideCanvas(arg0)

	arg0.markCanvas = GetOrAddComponent(arg0.tf:Find("mark"), typeof(Canvas))
	arg0.markCanvas.overrideSorting = true
end

function var2.ResetCanvasOrder(arg0)
	var2.super.ResetCanvasOrder(arg0)

	if not arg0.markCanvas then
		return
	end

	local var0 = arg0.line.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark

	pg.ViewUtils.SetSortingOrder(arg0.markCanvas, var0)
end

function var2.LoadEffectShuihua(arg0)
	local var0 = "qianting_01"

	arg0.shuihuaLoader:GetPrefab("Effect/" .. var0, var0, function(arg0)
		arg0.effect_shuihua = arg0

		tf(arg0):SetParent(arg0.tf)

		tf(arg0).localPosition = Vector3.zero

		setActive(arg0, false)
	end, "Shuihua")
end

function var2.PlayShuiHua(arg0)
	if not arg0.effect_shuihua then
		return
	end

	setActive(arg0.effect_shuihua, false)
	setActive(arg0.effect_shuihua, true)
end

function var2.SetActive(arg0, arg1)
	arg0:SetActiveModel(arg1)
end

function var2.SetActiveModel(arg0, arg1)
	setActive(arg0.tfShadow, arg1)
	arg0:SetSpineVisible(arg1)
end

function var2.Clear(arg0)
	arg0.showFlag = nil

	arg0.shuihuaLoader:Clear()
	var1.ClearSpine(arg0)
	var0.Clear(arg0)
end

return var2
