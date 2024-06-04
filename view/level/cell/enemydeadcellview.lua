local var0 = class("EnemyDeadCellView", import("view.level.cell.StaticCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.config = nil
	arg0.chapter = nil
	arg0._live2death = nil
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityLittle
end

function var0.Update(arg0)
	local var0 = arg0.info
	local var1 = arg0.config

	if IsNil(arg0.go) then
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0)
			arg0.name = "enemy_" .. var0.attachmentId
			arg0.go = arg0
			arg0.tf = tf(arg0)

			setParent(arg0, arg0.parent)
			arg0:OverrideCanvas()
			arg0:ResetCanvasOrder()
			setAnchoredPosition(arg0.tf, Vector2.zero)

			if var1.icon_type == 1 then
				setAnchoredPosition(arg0.tf, Vector2(0, 10))
				arg0:GetLoader():LoadSprite("enemies/" .. var1.icon .. "_d_blue", "", tf(arg0):Find("icon"))
			end

			setActive(findTF(arg0.tf, "effect_not_open"), false)
			setActive(findTF(arg0.tf, "effect_open"), false)
			setActive(findTF(arg0.tf, "huoqiubaozha"), false)
			arg0:Update()
		end, "Main")

		return
	end

	setActive(findTF(arg0.tf, "huoqiubaozha"), arg0._live2death)
end

function var0.Clear(arg0)
	arg0._live2death = nil
	arg0.chapter = nil

	var0.super.Clear(arg0)
end

return var0
