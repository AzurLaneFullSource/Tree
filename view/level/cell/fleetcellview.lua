local var0_0 = import(".DynamicCellView")
local var1_0 = import(".SpineCellView")
local var2_0 = class("FleetCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)
	var1_0.InitCellTransform(arg0_1)

	arg0_1.tfArrow = arg0_1.tf:Find("arrow")
	arg0_1.tfAmmo = arg0_1.tf:Find("ammo")
	arg0_1.tfAmmoText = arg0_1.tfAmmo:Find("text")
	arg0_1.tfOp = arg0_1.tf:Find("op")
	arg0_1.tfIconRecorded = nil
	arg0_1.RecordedFlag = nil
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityFleet
end

function var2_0.showPoisonDamage(arg0_3, arg1_3)
	local var0_3 = "dexiv4_SLG_poison"
	local var1_3 = arg0_3.tfShip.localPosition

	arg0_3:GetLoader():GetPrefab("ui/" .. var0_3, var0_3, function(arg0_4)
		setParent(arg0_4.transform, arg0_3.tf, false)
		LeanTween.moveY(arg0_3.tfShip, var1_3.y - 10, 0.1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		local var0_4 = arg0_4:GetComponent(typeof(ParticleSystemEvent))

		if not IsNil(var0_4) then
			var0_4:AddEndEvent(function()
				arg0_3.tfShip.localPosition = var1_3

				arg0_3.loader:ClearRequest("PoisonDamage")
				LeanTween.cancel(arg0_3.tfShip.gameObject)

				if arg1_3 then
					arg1_3()
				end
			end)
		end
	end, "PoisonDamage")
end

function var2_0.SetActiveNoPassIcon(arg0_6, arg1_6)
	local var0_6 = "NoPassIcon"

	if not arg1_6 then
		if arg0_6.loader then
			arg0_6.loader:ClearRequest(var0_6)
		end
	else
		if arg0_6:GetLoader():GetRequestPackage(var0_6) then
			return
		end

		local var1_6 = "event_task_small"

		arg0_6:GetLoader():GetPrefabBYStopLoading("boxprefab/" .. var1_6, var1_6, function(arg0_7)
			setParent(arg0_7.transform, arg0_6.tf, false)

			local var0_7 = 150

			setLocalPosition(arg0_7, Vector3(0, var0_7, 0))
			LeanTween.moveY(rtf(arg0_7), var0_7 - 10, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		end, var0_6)
	end
end

function var2_0.UpdateIconRecordedFlag(arg0_8, arg1_8)
	arg0_8.RecordedFlag = arg1_8

	arg0_8:UpdateIconRecorded()
end

function var2_0.UpdateIconRecorded(arg0_9)
	if not (arg0_9.RecordedFlag and arg0_9.visible) then
		if not IsNil(arg0_9.tfIconRecorded) then
			setActive(arg0_9.tfIconRecorded, false)
		end
	else
		if IsNil(arg0_9.tfIconRecorded) then
			pg.PoolMgr.GetInstance():GetPrefab("effect/fleet_status_recorded", "", false, function(arg0_10)
				arg0_9.tfIconRecorded = tf(arg0_10)

				setParent(arg0_10, arg0_9.tf, false)
			end)
		end

		setActive(arg0_9.tfIconRecorded, true)
	end
end

function var2_0.TweenShining(arg0_11)
	local var0_11 = arg0_11:GetSpineRole()

	if not var0_11 then
		return
	end

	local var1_11 = Color.black
	local var2_11 = Color.gray

	var1_11.a = 0
	var2_11.a = 0

	var0_11:TweenShining(0.2, 2, 0, 1, var1_11, var2_11, true, true)
end

function var2_0.SetSpineVisible(arg0_12, arg1_12)
	arg0_12.visible = arg1_12

	var2_0.super.SetSpineVisible(arg0_12, arg1_12)
	setActive(arg0_12.tfShadow, arg1_12)
	arg0_12:UpdateIconRecorded()
end

function var2_0.StopTween(arg0_13)
	local var0_13 = arg0_13:GetSpineRole()

	if not var0_13 then
		return
	end

	var0_13:StopTweenShining()
end

function var2_0.unloadSpine(arg0_14)
	var2_0.super.UnloadSpine(arg0_14)
end

function var2_0.Clear(arg0_15)
	var1_0.ClearSpine(arg0_15)
	var2_0.super.Clear(arg0_15)
end

return var2_0
