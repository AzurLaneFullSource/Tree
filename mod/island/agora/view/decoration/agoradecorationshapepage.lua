local var0_0 = class("AgoraDecorationShapePage")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.tr = arg1_1
	arg0_1.parentTr = arg1_1.parent
	arg0_1.shapes = {
		[IslandConst.AGORA_TILE_SHAPE_ALL] = arg0_1.tr:Find("bg/list/1"),
		[IslandConst.AGORA_TILE_SHAPE_FAN] = arg0_1.tr:Find("bg/list/2"),
		[IslandConst.AGORA_TILE_SHAPE_TRIANGLE] = arg0_1.tr:Find("bg/list/3"),
		[IslandConst.AGORA_TILE_SHAPE_ARC] = arg0_1.tr:Find("bg/list/4")
	}

	arg0_1:InitShapes()

	arg0_1.bgTr = arg1_1:Find("bg")
	arg0_1.localPosition = arg0_1.bgTr.localPosition
end

function var0_0.InitShapes(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2.shapes) do
		onButton(arg0_2, iter1_2, function()
			if arg0_2.callback then
				arg0_2.callback(iter0_2)
			end
		end, SFX_PANEL)
	end
end

function var0_0.Show(arg0_4, arg1_4, arg2_4)
	arg0_4.callback = arg2_4

	local var0_4 = arg1_4._go.transform:GetSiblingIndex() + 1

	setParent(arg0_4.tr, arg1_4._go.transform.parent)
	arg0_4.tr:SetSiblingIndex(var0_4)
	setActive(arg0_4.tr, true)
	arg0_4:AdjustPosition(arg1_4._go.transform.parent)
end

function var0_0.AdjustPosition(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetComponent(typeof(HorizontalLayoutGroup)).spacing

	arg0_5.bgTr.localPosition = arg0_5.localPosition - Vector3(var0_5, 0, 0)
end

function var0_0.Hide(arg0_6)
	arg0_6.callback = nil

	setParent(arg0_6.tr, arg0_6.parentTr)
	setActive(arg0_6.tr, false)
end

function var0_0.Destroy(arg0_7)
	pg.DelegateInfo.Dispose(arg0_7)
end

return var0_0
