local var0 = import(".StaticCellView")
local var1 = import(".EggCellView")
local var2 = class("StaticEggCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var0.Ctor(arg0, arg1)
	var1.Ctor(arg0)

	arg0.config = nil
	arg0.chapter = nil
	arg0.tweenId = nil
	arg0.buffer = FuncBuffer.New()
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityEnemy
end

function var2.Update(arg0)
	local var0 = arg0.info
	local var1 = arg0.config
	local var2 = var0.trait ~= ChapterConst.TraitLurk

	if ChapterConst.IsEnemyAttach(var0.attachment) and var0.flag == ChapterConst.CellFlagActive and arg0.chapter:existFleet(FleetType.Transport, var0.row, var0.column) then
		var2 = false
	end

	if not IsNil(arg0.go) then
		setActive(arg0.go, var2)
	end

	if not var2 then
		return
	end

	if IsNil(arg0.go) then
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0)
			arg0.name = "enemy_" .. var0.attachmentId
			arg0.go = arg0
			arg0.tf = tf(arg0)

			setParent(arg0, arg0.parent)
			var1.InitEggCellTransform(arg0)
			arg0:OverrideCanvas()
			arg0:ResetCanvasOrder()
			setAnchoredPosition(arg0.tf, Vector2.zero)
			var1.StartEggCellView(arg0, var1)
			arg0.buffer:SetNotifier(arg0)
			arg0.buffer:ExcuteAll()
			arg0:Update()
		end, "Main")

		return
	end

	var1.UpdateEggCell(arg0, arg0.chapter, arg0.info, arg0.config)

	if arg0.viewParent:isHuntingRangeVisible() and _.any(arg0.chapter.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Submarine and arg0:isValid() and arg0:inHuntingRange(var0.row, var0.column)
	end) then
		arg0:TweenBlink()
	else
		arg0:StopTween()
	end
end

function var2.TweenBlink(arg0)
	arg0:StopTween()

	local var0 = findTF(arg0.go, "icon")
	local var1 = var0:GetComponent("Image")

	arg0.tweenId = LeanTween.color(tf(var0), Color.New(1, 0.6, 0.6), 1):setFromColor(Color.white):setEase(LeanTweenType.easeInOutSine):setLoopPingPong():setOnComplete(System.Action(function()
		if IsNil(var1) then
			return
		end

		var1.color = Color.white
	end)).uniqueId
end

function var2.TweenShining(arg0, arg1)
	arg0:StopTween()

	local var0 = findTF(arg0.go, "icon")
	local var1 = var0:GetComponent("Image")
	local var2 = pg.ShaderMgr.GetInstance():GetShader("Spine/SkeletonGraphic (Additive)")
	local var3 = Material.New(var2)

	var1.material = var3
	arg0.tweenId = LeanTween.value(go(var0), 0, 1, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg1):setOnUpdate(System.Action_float(function(arg0)
		var3:SetColor("_Color", Color.Lerp(Color.black, Color.gray, arg0))
	end)):setOnComplete(System.Action(function()
		if IsNil(var1) then
			return
		end

		var1.material = nil
		var1.color = Color.white

		onNextTick(function()
			arg0:Update()
		end)
	end)).uniqueId
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
	arg0.buffer:Clear()

	arg0.chapter = nil

	var1.Clear(arg0)
	var0.Clear(arg0)
end

return var2
