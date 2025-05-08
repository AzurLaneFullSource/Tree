local var0_0 = class("IslandSlotHudView", import(".IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandSlotHudUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.parent = arg0_2._tf:Find("look")
	arg0_2.hudDic = {}
	arg0_2.isShow = {}
end

function var0_0.Update(arg0_3)
	arg0_3:UpdatePosition()
end

function var0_0.UpdatePosition(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.hudDic) do
		if not arg0_4.isShow[iter0_4] then
			setActive(iter1_4.transform, false)
		else
			local var0_4 = pg.island_world_objects[iter0_4].param.position
			local var1_4 = Vector3(var0_4[1], var0_4[2], var0_4[3]) + Vector3(0, 2.3, 0)

			if not IslandCalcUtil.IsInViewport(var1_4) then
				setActive(iter1_4.transform, false)
			else
				setActive(iter1_4.transform, true)

				local var2_4 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_4.parent, var1_4)

				iter1_4.transform.localPosition = var2_4
			end
		end
	end
end

function var0_0.HandleHud(arg0_5, arg1_5)
	local var0_5 = arg1_5.displayTpye
	local var1_5 = false

	if var0_5 and var0_5 == "collect" then
		var1_5 = true
	end

	if var1_5 then
		arg0_5:ShowHud(arg1_5.nearItem.pos)
	else
		arg0_5:HideHud()
	end
end

function var0_0.ShowHud(arg0_6, arg1_6)
	if arg1_6 == nil then
		return
	end

	arg0_6.isShow[arg1_6] = true
	arg0_6.lastNearId = arg1_6

	if arg0_6.hudDic[arg1_6] then
		setActive(arg0_6.hudDic[arg1_6].transform, true)

		return
	end

	ResourceMgr.Inst:getAssetAsync("ui/IslandCollectHud", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		if arg0_6.hudDic[arg1_6] then
			return
		end

		local var0_7 = Object.Instantiate(arg0_7)

		setParent(var0_7, arg0_6.parent)

		arg0_6.hudDic[arg1_6] = var0_7
		var0_7.name = arg1_6

		arg0_6:UpdatePosition()
	end), true, true)
end

function var0_0.HideHud(arg0_8)
	if arg0_8.lastNearId then
		arg0_8.isShow[arg0_8.lastNearId] = false

		setActive(arg0_8.hudDic[arg0_8.lastNearId].transform, false)
	end
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
