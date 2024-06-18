local var0_0 = class("EnemyDeadCellView", import("view.level.cell.StaticCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.config = nil
	arg0_1.chapter = nil
	arg0_1._live2death = nil
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityLittle
end

function var0_0.Update(arg0_3)
	local var0_3 = arg0_3.info
	local var1_3 = arg0_3.config

	if IsNil(arg0_3.go) then
		arg0_3:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0_4)
			arg0_4.name = "enemy_" .. var0_3.attachmentId
			arg0_3.go = arg0_4
			arg0_3.tf = tf(arg0_4)

			setParent(arg0_4, arg0_3.parent)
			arg0_3:OverrideCanvas()
			arg0_3:ResetCanvasOrder()
			setAnchoredPosition(arg0_3.tf, Vector2.zero)

			if var1_3.icon_type == 1 then
				setAnchoredPosition(arg0_3.tf, Vector2(0, 10))
				arg0_3:GetLoader():LoadSprite("enemies/" .. var1_3.icon .. "_d_blue", "", tf(arg0_4):Find("icon"))
			end

			setActive(findTF(arg0_3.tf, "effect_not_open"), false)
			setActive(findTF(arg0_3.tf, "effect_open"), false)
			setActive(findTF(arg0_3.tf, "huoqiubaozha"), false)
			arg0_3:Update()
		end, "Main")

		return
	end

	setActive(findTF(arg0_3.tf, "huoqiubaozha"), arg0_3._live2death)
end

function var0_0.Clear(arg0_5)
	arg0_5._live2death = nil
	arg0_5.chapter = nil

	var0_0.super.Clear(arg0_5)
end

return var0_0
