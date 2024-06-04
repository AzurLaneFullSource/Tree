local var0 = import(".DynamicCellView")
local var1 = import(".SpineCellView")
local var2 = class("FleetCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
	var1.Ctor(arg0)
	var1.InitCellTransform(arg0)

	arg0.tfArrow = arg0.tf:Find("arrow")
	arg0.tfAmmo = arg0.tf:Find("ammo")
	arg0.tfAmmoText = arg0.tfAmmo:Find("text")
	arg0.tfOp = arg0.tf:Find("op")
	arg0.tfIconRecorded = nil
	arg0.RecordedFlag = nil
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityFleet
end

function var2.showPoisonDamage(arg0, arg1)
	local var0 = "dexiv4_SLG_poison"
	local var1 = arg0.tfShip.localPosition

	arg0:GetLoader():GetPrefab("ui/" .. var0, var0, function(arg0)
		setParent(arg0.transform, arg0.tf, false)
		LeanTween.moveY(arg0.tfShip, var1.y - 10, 0.1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		local var0 = arg0:GetComponent(typeof(ParticleSystemEvent))

		if not IsNil(var0) then
			var0:AddEndEvent(function()
				arg0.tfShip.localPosition = var1

				arg0.loader:ClearRequest("PoisonDamage")
				LeanTween.cancel(arg0.tfShip.gameObject)

				if arg1 then
					arg1()
				end
			end)
		end
	end, "PoisonDamage")
end

function var2.SetActiveNoPassIcon(arg0, arg1)
	local var0 = "NoPassIcon"

	if not arg1 then
		if arg0.loader then
			arg0.loader:ClearRequest(var0)
		end
	else
		if arg0:GetLoader():GetRequestPackage(var0) then
			return
		end

		local var1 = "event_task_small"

		arg0:GetLoader():GetPrefabBYStopLoading("boxprefab/" .. var1, var1, function(arg0)
			setParent(arg0.transform, arg0.tf, false)

			local var0 = 150

			setLocalPosition(arg0, Vector3(0, var0, 0))
			LeanTween.moveY(rtf(arg0), var0 - 10, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		end, var0)
	end
end

function var2.UpdateIconRecordedFlag(arg0, arg1)
	arg0.RecordedFlag = arg1

	arg0:UpdateIconRecorded()
end

function var2.UpdateIconRecorded(arg0)
	if not (arg0.RecordedFlag and arg0.visible) then
		if not IsNil(arg0.tfIconRecorded) then
			setActive(arg0.tfIconRecorded, false)
		end
	else
		if IsNil(arg0.tfIconRecorded) then
			pg.PoolMgr.GetInstance():GetPrefab("effect/fleet_status_recorded", "", false, function(arg0)
				arg0.tfIconRecorded = tf(arg0)

				setParent(arg0, arg0.tf, false)
			end)
		end

		setActive(arg0.tfIconRecorded, true)
	end
end

function var2.TweenShining(arg0)
	local var0 = arg0:GetSpineRole()

	if not var0 then
		return
	end

	local var1 = Color.black
	local var2 = Color.gray

	var1.a = 0
	var2.a = 0

	var0:TweenShining(0.2, 2, 0, 1, var1, var2, true, true)
end

function var2.SetSpineVisible(arg0, arg1)
	arg0.visible = arg1

	var2.super.SetSpineVisible(arg0, arg1)
	setActive(arg0.tfShadow, arg1)
	arg0:UpdateIconRecorded()
end

function var2.StopTween(arg0)
	local var0 = arg0:GetSpineRole()

	if not var0 then
		return
	end

	var0:StopTweenShining()
end

function var2.unloadSpine(arg0)
	var2.super.UnloadSpine(arg0)
end

function var2.Clear(arg0)
	var1.ClearSpine(arg0)
	var2.super.Clear(arg0)
end

return var2
