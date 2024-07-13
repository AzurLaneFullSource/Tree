local var0_0 = import(".StaticCellView")
local var1_0 = import(".EggCellView")
local var2_0 = class("StaticEggCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)

	arg0_1.config = nil
	arg0_1.chapter = nil
	arg0_1.tweenId = nil
	arg0_1.buffer = FuncBuffer.New()
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityEnemy
end

function var2_0.Update(arg0_3)
	local var0_3 = arg0_3.info
	local var1_3 = arg0_3.config
	local var2_3 = var0_3.trait ~= ChapterConst.TraitLurk

	if ChapterConst.IsEnemyAttach(var0_3.attachment) and var0_3.flag == ChapterConst.CellFlagActive and arg0_3.chapter:existFleet(FleetType.Transport, var0_3.row, var0_3.column) then
		var2_3 = false
	end

	if not IsNil(arg0_3.go) then
		setActive(arg0_3.go, var2_3)
	end

	if not var2_3 then
		return
	end

	if IsNil(arg0_3.go) then
		arg0_3:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0_4)
			arg0_4.name = "enemy_" .. var0_3.attachmentId
			arg0_3.go = arg0_4
			arg0_3.tf = tf(arg0_4)

			setParent(arg0_4, arg0_3.parent)
			var1_0.InitEggCellTransform(arg0_3)
			arg0_3:OverrideCanvas()
			arg0_3:ResetCanvasOrder()
			setAnchoredPosition(arg0_3.tf, Vector2.zero)
			var1_0.StartEggCellView(arg0_3, var1_3)
			arg0_3.buffer:SetNotifier(arg0_3)
			arg0_3.buffer:ExcuteAll()
			arg0_3:Update()
		end, "Main")

		return
	end

	var1_0.UpdateEggCell(arg0_3, arg0_3.chapter, arg0_3.info, arg0_3.config)

	if arg0_3.viewParent:isHuntingRangeVisible() and _.any(arg0_3.chapter.fleets, function(arg0_5)
		return arg0_5:getFleetType() == FleetType.Submarine and arg0_5:isValid() and arg0_5:inHuntingRange(var0_3.row, var0_3.column)
	end) then
		arg0_3:TweenBlink()
	else
		arg0_3:StopTween()
	end
end

function var2_0.TweenBlink(arg0_6)
	arg0_6:StopTween()

	local var0_6 = findTF(arg0_6.go, "icon")
	local var1_6 = var0_6:GetComponent("Image")

	arg0_6.tweenId = LeanTween.color(tf(var0_6), Color.New(1, 0.6, 0.6), 1):setFromColor(Color.white):setEase(LeanTweenType.easeInOutSine):setLoopPingPong():setOnComplete(System.Action(function()
		if IsNil(var1_6) then
			return
		end

		var1_6.color = Color.white
	end)).uniqueId
end

function var2_0.TweenShining(arg0_8, arg1_8)
	arg0_8:StopTween()

	local var0_8 = findTF(arg0_8.go, "icon")
	local var1_8 = var0_8:GetComponent("Image")
	local var2_8 = pg.ShaderMgr.GetInstance():GetShader("Spine/SkeletonGraphic (Additive)")
	local var3_8 = Material.New(var2_8)

	var1_8.material = var3_8
	arg0_8.tweenId = LeanTween.value(go(var0_8), 0, 1, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg1_8):setOnUpdate(System.Action_float(function(arg0_9)
		var3_8:SetColor("_Color", Color.Lerp(Color.black, Color.gray, arg0_9))
	end)):setOnComplete(System.Action(function()
		if IsNil(var1_8) then
			return
		end

		var1_8.material = nil
		var1_8.color = Color.white

		onNextTick(function()
			arg0_8:Update()
		end)
	end)).uniqueId
end

function var2_0.StopTween(arg0_12)
	if not arg0_12.tweenId then
		return
	end

	LeanTween.cancel(arg0_12.tweenId, true)

	arg0_12.tweenId = nil
end

function var2_0.Clear(arg0_13)
	arg0_13:StopTween()
	arg0_13.buffer:Clear()

	arg0_13.chapter = nil

	var1_0.Clear(arg0_13)
	var0_0.Clear(arg0_13)
end

return var2_0
