local var0 = import(".LevelGrid")
local var1 = Vector2(-60, 84.8)
local var2 = Vector2(-50, 20)

function var0.PlaySubAnimation(arg0, arg1, arg2, arg3)
	if not arg1 then
		arg3()

		return
	end

	local var0 = arg1:GetSpineRole()

	if not var0 then
		arg3()

		return
	end

	local var1 = arg0.contextData.chapterVO

	var0:SetAction(arg2 and ChapterConst.ShipSwimAction or ChapterConst.ShipIdleAction)
	arg1:PlayShuiHua()

	local var2 = var1:GetQuickPlayFlag() and 0.1 or 0.3
	local var3 = arg2 and 1 or 0
	local var4 = arg2 and 0 or 1

	arg0:frozen()
	var0:TweenShining(var2, nil, var3, var4, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, function(arg0)
		if not IsNil(arg1.tfAmmo) then
			arg1.tfAmmo.anchoredPosition = Vector2.Lerp(var2, var1, arg0)
		end
	end, function()
		if arg0.exited then
			return
		end

		arg0:unfrozen()
		arg1:SetActiveModel(not arg2)

		if arg3 then
			arg3()
		end
	end)
end

function var0.TeleportCellByPortalWithCameraMove(arg0, arg1, arg2, arg3, arg4)
	local var0

	local function var1(arg0)
		var0 = arg0
	end

	local function var2(arg0)
		arg0:TeleportFleetByPortal(arg2, arg3, function()
			arg0:focusOnCell(arg1.line, var0)
		end, arg0)
	end

	parallelAsync({
		var1,
		var2
	}, arg4)
end

function var0.TeleportFleetByPortal(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg2[1]
	local var2 = arg2[2]

	if not var1 or not var2 then
		arg4()

		return
	end

	local var3 = arg1:GetSpineRole()

	if not var3 then
		arg4()

		return
	end

	arg0:frozen()

	local var4 = var0:GetQuickPlayFlag() and 0.1 or 0.3

	var3:TweenShining(var4, nil, 1, 0, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, nil, function()
		if arg0.exited then
			return
		end

		if arg3 then
			arg3()
		end

		arg0:updateFleet(table.indexof(arg0.cellFleets, arg1))
		var3:TweenShining(var4, nil, 0, 1, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, nil, function()
			if arg0.exited then
				return
			end

			arg0:unfrozen()
			existCall(arg4)
		end)
	end)
end

function var0.adjustCameraFocus(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleets[var0.findex].id
	local var2 = arg0.cellFleets[var1]

	if var2 then
		arg0:cameraFocus(var2.tf.position, arg1)
	else
		existCall(arg1)
	end
end

function var0.focusOnCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var1 = arg0.cellRoot:Find(var0)

	arg0:cameraFocus(var1.position, arg2)
end

function var0.cameraFocus(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO.theme
	local var1 = arg0._tf:Find(ChapterConst.PlaneName)

	assert(var1, "plane not exist.")
	LeanTween.cancel(arg0._tf.gameObject, true)

	local var2 = arg0._tf.parent:InverseTransformVector(arg1 - var1.position)

	var2.x = var2.x + var1.localPosition.x
	var2.y = var2.y + var1.localPosition.y - var1.localPosition.z * math.tan(math.pi / 180 * var0.angle)
	var2.x = math.clamp(-var2.x, arg0.leftBound, arg0.rightBound)
	var2.y = math.clamp(-var2.y, arg0.bottomBound, arg0.topBound)
	var2.z = 0
	arg0.dragTrigger.enabled = false

	LeanTween.moveLocal(arg0._tf.gameObject, var2, 0.4):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg0.exited then
			return
		end

		arg0.dragTrigger.enabled = true

		existCall(arg2)
	end))
end

function var0.PlayChampionSubmarineAnimation(arg0, arg1, arg2, arg3)
	local var0 = arg0.contextData.chapterVO:getChampionIndex(arg1.row, arg1.column)

	if not var0 or var0 <= 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var1 = arg0.cellChampions[var0]

	if not var1 then
		if arg3 then
			arg3()
		end

		return
	end

	arg0:PlaySubAnimation(var1, arg2, arg3)
end

function var0.shakeCell(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1
	local var2 = var0:getChampion(arg1.row, arg1.column)
	local var3 = var0:getChapterCell(arg1.row, arg1.column)

	if var2 and var2.flag == ChapterConst.CellFlagActive then
		local var4 = var0:getChampionIndex(arg1.row, arg1.column)

		var1 = arg0.cellChampions[var4].tf
	elseif ChapterConst.IsEnemyAttach(var3.attachment) then
		local var5 = ChapterCell.Line2Name(arg1.row, arg1.column)

		var1 = arg0.attachmentCells[var5].tf
	else
		existCall(arg2)

		return
	end

	local var6 = var1.localPosition.x
	local var7 = var1.localPosition

	var7.x = var6 + 10
	var1.localPosition = var7

	LeanTween.moveX(var1, var6 - 10, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(3):setOnComplete(System.Action(function()
		local var0 = var1.localPosition

		var0.x = var6
		var1.localPosition = var0

		if arg2 then
			arg2()
		end
	end))
	arg0:PlayAttachmentEffect(arg1.row, arg1.column, "huoqiubaozha", Vector2.zero)

	return var1
end

function var0.PlayShellFx(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var1 = arg0.cellRoot:Find(var0):Find(ChapterConst.ChildAttachment)
	local var2 = arg1.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityUpperEffect
	local var3

	seriesAsync({
		function(arg0)
			arg0.loader:GetPrefab("effect/ATdun_full_SLG", "ATdun_full_SLG", function(arg0)
				setParent(arg0, var1)
				pg.ViewUtils.SetSortingOrder(arg0, var2)

				var3 = arg0

				arg0()
			end)
		end,
		function(arg0)
			Timer.New(arg0, 1, nil, true):Start()
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			arg0.loader:ReturnPrefab(var3)
			existCall(arg2)
		end
	})
end

function var0.PlayMissileExplodAnim(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var1 = arg0.cellRoot:Find(var0):Find(ChapterConst.ChildAttachment)
	local var2 = arg1.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityAttachment
	local var3
	local var4
	local var5

	parallelAsync({
		function(arg0)
			arg0.loader:GetPrefab("effect/dexiv4_SLG_missile", "dexiv4_SLG_missile", function(arg0)
				setParent(arg0, var1)
				setActive(arg0, false)
				pg.ViewUtils.SetSortingOrder(arg0, var2)

				var3 = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0.loader:GetPrefab("effect/ShellHitBlue", "ShellHitBlue", function(arg0)
				setParent(arg0, var1)
				setActive(arg0, false)
				pg.ViewUtils.SetSortingOrder(arg0, var2)

				var4 = arg0

				arg0()
			end)
		end
	}, function()
		seriesAsync({
			function(arg0)
				local var0 = Vector3(150, 600)

				setLocalPosition(var3, var0)

				tf(var3).localRotation = Quaternion.FromToRotation(Vector3.right, -var0)

				setActive(var3, true)

				var5 = LeanTween.moveLocal(go(var3), Vector3.zero, 0.7):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0)).id
				arg0.tweens[var5] = true
			end,
			function(arg0)
				arg0.tweens[var5] = nil

				arg0.loader:ReturnPrefab(var3)

				var3 = nil

				setActive(var4, true)
				setLocalScale(var4, Vector3.one)

				local var0 = go(var4):GetComponent(typeof(ParticleSystemEvent))

				var0:SetEndEvent(function(arg0)
					var0:SetEndEvent(nil)
					arg0.loader:ReturnPrefab(var4)

					var4 = nil
				end)
				arg0()
			end,
			arg2
		})
	end)
end

function var0.PlaySonarDetectAnim(arg0, arg1, arg2)
	existCall(arg2)
end

function var0.PlayAttachmentEffect(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = ChapterCell.Line2Name(arg1, arg2)
	local var1 = arg0.cellRoot:Find(var0)

	if not var1 then
		existCall(arg5)

		return
	end

	local var2 = var1:Find(ChapterConst.ChildAttachment)

	arg0:PlayParticleSystem(arg3, var2, arg4, arg5)
end

function var0.PlayParticleSystem(arg0, arg1, arg2, arg3, arg4)
	arg0.loader:GetPrefab("effect/" .. arg1, arg1, function(arg0)
		setParent(arg0, arg2)

		if arg3 then
			tf(arg0).localPosition = arg3
		end

		arg0:GetComponent(typeof(ParticleSystem)):Play()

		local var0 = arg0:GetComponent(typeof(ParticleSystemEvent))

		if not IsNil(var0) then
			var0:SetEndEvent(function(arg0)
				arg0.loader:ReturnPrefab(arg0)
				existCall(arg4)
			end)
		end
	end)
end
