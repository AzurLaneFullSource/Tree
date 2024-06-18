local var0_0 = import(".DynamicCellView")
local var1_0 = import(".SpineCellView")
local var2_0 = class("SubCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)
	var1_0.InitCellTransform(arg0_1)

	arg0_1.tfAmmo = arg0_1.tf:Find("ammo")
	arg0_1.tfAmmoText = arg0_1.tfAmmo:Find("text")
	arg0_1.showFlag = true
	arg0_1.shuihuaLoader = AutoLoader.New()

	arg0_1:LoadEffectShuihua()
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityFleet
end

function var2_0.OverrideCanvas(arg0_3)
	var2_0.super.OverrideCanvas(arg0_3)

	arg0_3.markCanvas = GetOrAddComponent(arg0_3.tf:Find("mark"), typeof(Canvas))
	arg0_3.markCanvas.overrideSorting = true
end

function var2_0.ResetCanvasOrder(arg0_4)
	var2_0.super.ResetCanvasOrder(arg0_4)

	if not arg0_4.markCanvas then
		return
	end

	local var0_4 = arg0_4.line.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark

	pg.ViewUtils.SetSortingOrder(arg0_4.markCanvas, var0_4)
end

function var2_0.LoadEffectShuihua(arg0_5)
	local var0_5 = "qianting_01"

	arg0_5.shuihuaLoader:GetPrefab("Effect/" .. var0_5, var0_5, function(arg0_6)
		arg0_5.effect_shuihua = arg0_6

		tf(arg0_6):SetParent(arg0_5.tf)

		tf(arg0_6).localPosition = Vector3.zero

		setActive(arg0_6, false)
	end, "Shuihua")
end

function var2_0.PlayShuiHua(arg0_7)
	if not arg0_7.effect_shuihua then
		return
	end

	setActive(arg0_7.effect_shuihua, false)
	setActive(arg0_7.effect_shuihua, true)
end

function var2_0.SetActive(arg0_8, arg1_8)
	arg0_8:SetActiveModel(arg1_8)
end

function var2_0.SetActiveModel(arg0_9, arg1_9)
	setActive(arg0_9.tfShadow, arg1_9)
	arg0_9:SetSpineVisible(arg1_9)
end

function var2_0.Clear(arg0_10)
	arg0_10.showFlag = nil

	arg0_10.shuihuaLoader:Clear()
	var1_0.ClearSpine(arg0_10)
	var0_0.Clear(arg0_10)
end

return var2_0
