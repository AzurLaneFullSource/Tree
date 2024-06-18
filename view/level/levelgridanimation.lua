local var0_0 = import(".LevelGrid")
local var1_0 = Vector2(-60, 84.8)
local var2_0 = Vector2(-50, 20)

function var0_0.PlaySubAnimation(arg0_1, arg1_1, arg2_1, arg3_1)
	if not arg1_1 then
		arg3_1()

		return
	end

	local var0_1 = arg1_1:GetSpineRole()

	if not var0_1 then
		arg3_1()

		return
	end

	local var1_1 = arg0_1.contextData.chapterVO

	var0_1:SetAction(arg2_1 and ChapterConst.ShipSwimAction or ChapterConst.ShipIdleAction)
	arg1_1:PlayShuiHua()

	local var2_1 = var1_1:GetQuickPlayFlag() and 0.1 or 0.3
	local var3_1 = arg2_1 and 1 or 0
	local var4_1 = arg2_1 and 0 or 1

	arg0_1:frozen()
	var0_1:TweenShining(var2_1, nil, var3_1, var4_1, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, function(arg0_2)
		if not IsNil(arg1_1.tfAmmo) then
			arg1_1.tfAmmo.anchoredPosition = Vector2.Lerp(var2_0, var1_0, arg0_2)
		end
	end, function()
		if arg0_1.exited then
			return
		end

		arg0_1:unfrozen()
		arg1_1:SetActiveModel(not arg2_1)

		if arg3_1 then
			arg3_1()
		end
	end)
end

function var0_0.TeleportCellByPortalWithCameraMove(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local var0_4

	local function var1_4(arg0_5)
		var0_4 = arg0_5
	end

	local function var2_4(arg0_6)
		arg0_4:TeleportFleetByPortal(arg2_4, arg3_4, function()
			arg0_4:focusOnCell(arg1_4.line, var0_4)
		end, arg0_6)
	end

	parallelAsync({
		var1_4,
		var2_4
	}, arg4_4)
end

function var0_0.TeleportFleetByPortal(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	local var0_8 = arg0_8.contextData.chapterVO
	local var1_8 = arg2_8[1]
	local var2_8 = arg2_8[2]

	if not var1_8 or not var2_8 then
		arg4_8()

		return
	end

	local var3_8 = arg1_8:GetSpineRole()

	if not var3_8 then
		arg4_8()

		return
	end

	arg0_8:frozen()

	local var4_8 = var0_8:GetQuickPlayFlag() and 0.1 or 0.3

	var3_8:TweenShining(var4_8, nil, 1, 0, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, nil, function()
		if arg0_8.exited then
			return
		end

		if arg3_8 then
			arg3_8()
		end

		arg0_8:updateFleet(table.indexof(arg0_8.cellFleets, arg1_8))
		var3_8:TweenShining(var4_8, nil, 0, 1, Color.New(1, 1, 1, 0), Color.New(1, 1, 1, 1), false, false, nil, function()
			if arg0_8.exited then
				return
			end

			arg0_8:unfrozen()
			existCall(arg4_8)
		end)
	end)
end

function var0_0.adjustCameraFocus(arg0_11, arg1_11)
	local var0_11 = arg0_11.contextData.chapterVO
	local var1_11 = var0_11.fleets[var0_11.findex].id
	local var2_11 = arg0_11.cellFleets[var1_11]

	if var2_11 then
		arg0_11:cameraFocus(var2_11.tf.position, arg1_11)
	else
		existCall(arg1_11)
	end
end

function var0_0.focusOnCell(arg0_12, arg1_12, arg2_12)
	local var0_12 = ChapterCell.Line2Name(arg1_12.row, arg1_12.column)
	local var1_12 = arg0_12.cellRoot:Find(var0_12)

	arg0_12:cameraFocus(var1_12.position, arg2_12)
end

function var0_0.cameraFocus(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.contextData.chapterVO.theme
	local var1_13 = arg0_13._tf:Find(ChapterConst.PlaneName)

	assert(var1_13, "plane not exist.")
	LeanTween.cancel(arg0_13._tf.gameObject, true)

	local var2_13 = arg0_13._tf.parent:InverseTransformVector(arg1_13 - var1_13.position)

	var2_13.x = var2_13.x + var1_13.localPosition.x
	var2_13.y = var2_13.y + var1_13.localPosition.y - var1_13.localPosition.z * math.tan(math.pi / 180 * var0_13.angle)
	var2_13.x = math.clamp(-var2_13.x, arg0_13.leftBound, arg0_13.rightBound)
	var2_13.y = math.clamp(-var2_13.y, arg0_13.bottomBound, arg0_13.topBound)
	var2_13.z = 0
	arg0_13.dragTrigger.enabled = false

	LeanTween.moveLocal(arg0_13._tf.gameObject, var2_13, 0.4):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg0_13.exited then
			return
		end

		arg0_13.dragTrigger.enabled = true

		existCall(arg2_13)
	end))
end

function var0_0.PlayChampionSubmarineAnimation(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15.contextData.chapterVO:getChampionIndex(arg1_15.row, arg1_15.column)

	if not var0_15 or var0_15 <= 0 then
		if arg3_15 then
			arg3_15()
		end

		return
	end

	local var1_15 = arg0_15.cellChampions[var0_15]

	if not var1_15 then
		if arg3_15 then
			arg3_15()
		end

		return
	end

	arg0_15:PlaySubAnimation(var1_15, arg2_15, arg3_15)
end

function var0_0.shakeCell(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.contextData.chapterVO
	local var1_16
	local var2_16 = var0_16:getChampion(arg1_16.row, arg1_16.column)
	local var3_16 = var0_16:getChapterCell(arg1_16.row, arg1_16.column)

	if var2_16 and var2_16.flag == ChapterConst.CellFlagActive then
		local var4_16 = var0_16:getChampionIndex(arg1_16.row, arg1_16.column)

		var1_16 = arg0_16.cellChampions[var4_16].tf
	elseif ChapterConst.IsEnemyAttach(var3_16.attachment) then
		local var5_16 = ChapterCell.Line2Name(arg1_16.row, arg1_16.column)

		var1_16 = arg0_16.attachmentCells[var5_16].tf
	else
		existCall(arg2_16)

		return
	end

	local var6_16 = var1_16.localPosition.x
	local var7_16 = var1_16.localPosition

	var7_16.x = var6_16 + 10
	var1_16.localPosition = var7_16

	LeanTween.moveX(var1_16, var6_16 - 10, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(3):setOnComplete(System.Action(function()
		local var0_17 = var1_16.localPosition

		var0_17.x = var6_16
		var1_16.localPosition = var0_17

		if arg2_16 then
			arg2_16()
		end
	end))
	arg0_16:PlayAttachmentEffect(arg1_16.row, arg1_16.column, "huoqiubaozha", Vector2.zero)

	return var1_16
end

function var0_0.PlayShellFx(arg0_18, arg1_18, arg2_18)
	local var0_18 = ChapterCell.Line2Name(arg1_18.row, arg1_18.column)
	local var1_18 = arg0_18.cellRoot:Find(var0_18):Find(ChapterConst.ChildAttachment)
	local var2_18 = arg1_18.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityUpperEffect
	local var3_18

	seriesAsync({
		function(arg0_19)
			arg0_18.loader:GetPrefab("effect/ATdun_full_SLG", "ATdun_full_SLG", function(arg0_20)
				setParent(arg0_20, var1_18)
				pg.ViewUtils.SetSortingOrder(arg0_20, var2_18)

				var3_18 = arg0_20

				arg0_19()
			end)
		end,
		function(arg0_21)
			Timer.New(arg0_21, 1, nil, true):Start()
		end,
		function(arg0_22)
			if arg0_18.exited then
				return
			end

			arg0_18.loader:ReturnPrefab(var3_18)
			existCall(arg2_18)
		end
	})
end

function var0_0.PlayMissileExplodAnim(arg0_23, arg1_23, arg2_23)
	local var0_23 = ChapterCell.Line2Name(arg1_23.row, arg1_23.column)
	local var1_23 = arg0_23.cellRoot:Find(var0_23):Find(ChapterConst.ChildAttachment)
	local var2_23 = arg1_23.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityAttachment
	local var3_23
	local var4_23
	local var5_23

	parallelAsync({
		function(arg0_24)
			arg0_23.loader:GetPrefab("effect/dexiv4_SLG_missile", "dexiv4_SLG_missile", function(arg0_25)
				setParent(arg0_25, var1_23)
				setActive(arg0_25, false)
				pg.ViewUtils.SetSortingOrder(arg0_25, var2_23)

				var3_23 = arg0_25

				arg0_24()
			end)
		end,
		function(arg0_26)
			arg0_23.loader:GetPrefab("effect/ShellHitBlue", "ShellHitBlue", function(arg0_27)
				setParent(arg0_27, var1_23)
				setActive(arg0_27, false)
				pg.ViewUtils.SetSortingOrder(arg0_27, var2_23)

				var4_23 = arg0_27

				arg0_26()
			end)
		end
	}, function()
		seriesAsync({
			function(arg0_29)
				local var0_29 = Vector3(150, 600)

				setLocalPosition(var3_23, var0_29)

				tf(var3_23).localRotation = Quaternion.FromToRotation(Vector3.right, -var0_29)

				setActive(var3_23, true)

				var5_23 = LeanTween.moveLocal(go(var3_23), Vector3.zero, 0.7):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_29)).id
				arg0_23.tweens[var5_23] = true
			end,
			function(arg0_30)
				arg0_23.tweens[var5_23] = nil

				arg0_23.loader:ReturnPrefab(var3_23)

				var3_23 = nil

				setActive(var4_23, true)
				setLocalScale(var4_23, Vector3.one)

				local var0_30 = go(var4_23):GetComponent(typeof(ParticleSystemEvent))

				var0_30:SetEndEvent(function(arg0_31)
					var0_30:SetEndEvent(nil)
					arg0_23.loader:ReturnPrefab(var4_23)

					var4_23 = nil
				end)
				arg0_30()
			end,
			arg2_23
		})
	end)
end

function var0_0.PlaySonarDetectAnim(arg0_32, arg1_32, arg2_32)
	existCall(arg2_32)
end

function var0_0.PlayAttachmentEffect(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33)
	local var0_33 = ChapterCell.Line2Name(arg1_33, arg2_33)
	local var1_33 = arg0_33.cellRoot:Find(var0_33)

	if not var1_33 then
		existCall(arg5_33)

		return
	end

	local var2_33 = var1_33:Find(ChapterConst.ChildAttachment)

	arg0_33:PlayParticleSystem(arg3_33, var2_33, arg4_33, arg5_33)
end

function var0_0.PlayParticleSystem(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	arg0_34.loader:GetPrefab("effect/" .. arg1_34, arg1_34, function(arg0_35)
		setParent(arg0_35, arg2_34)

		if arg3_34 then
			tf(arg0_35).localPosition = arg3_34
		end

		arg0_35:GetComponent(typeof(ParticleSystem)):Play()

		local var0_35 = arg0_35:GetComponent(typeof(ParticleSystemEvent))

		if not IsNil(var0_35) then
			var0_35:SetEndEvent(function(arg0_36)
				arg0_34.loader:ReturnPrefab(arg0_35)
				existCall(arg4_34)
			end)
		end
	end)
end
