local var0_0 = class("DreamlandSpinePlayer")

function var0_0.Ctor(arg0_1)
	arg0_1.holdSpinePlayRecorder = {}
	arg0_1.effects = {}
	arg0_1.timers = {}
	arg0_1.isPlayEffect = {}
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.root = arg1_2
	arg0_2.spineAnimUIList = arg3_2

	local var0_2 = arg3_2[arg2_2.name]

	if arg4_2.type == DreamlandData.EXPLORE_TYPE_HOLD then
		local var1_2 = arg0_2.holdSpinePlayRecorder[arg2_2.name]

		arg0_2:PlayInterActionAnimHold(arg4_2.sub_type, var0_2, var1_2, arg2_2)

		arg0_2.holdSpinePlayRecorder[arg2_2.name] = not defaultValue(var1_2, false)
	else
		arg0_2:PlayInterActionAnimOnce(arg4_2.sub_type, var0_2, arg2_2)
	end
end

function var0_0.PlayInterActionAnimHold(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg1_3[1]

	if arg3_3 then
		local var1_3 = DreamlandUtil.GetSpineNormalAction(var0_3)

		arg2_3:SetAction(var1_3, 0)

		if var0_3 == DreamlandData.EXPLORE_SUBTYPE_EFFECT then
			arg0_3:RemoveEffect(arg1_3[2])
		end

		if var0_3 == DreamlandData.EXPLORE_SUBTYPE_UNION then
			local var2_3 = arg0_3.spineAnimUIList[arg1_3[2]]

			if var2_3 then
				var2_3:SetAction(var1_3, 0)
			end
		end
	elseif var0_3 == DreamlandData.EXPLORE_SUBTYPE_3SEC then
		arg0_3:PlayAction(arg2_3, "action", "normal2")
	elseif var0_3 == DreamlandData.EXPLORE_SUBTYPE_EFFECT then
		arg0_3:PlayerEffect(-1, arg1_3[2])
	else
		local var3_3 = DreamlandUtil.GetSpineInterAction(var0_3)

		arg2_3:SetAction(var3_3, 0)

		if var0_3 == DreamlandData.EXPLORE_SUBTYPE_UNION then
			local var4_3 = arg0_3.spineAnimUIList[arg1_3[2]]

			if var4_3 then
				var4_3:SetAction(var3_3, 0)
			end
		end
	end
end

function var0_0.PlayInterActionAnimOnce(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg1_4[1]

	if var0_4 == DreamlandData.EXPLORE_SUBTYPE_EFFECT then
		arg0_4:PlayerEffect(arg1_4[3], arg1_4[2])
	else
		local var1_4 = DreamlandUtil.GetSpineInterAction(var0_4)
		local var2_4 = DreamlandUtil.GetSpineNormalAction(var0_4)

		arg0_4:PlayAction(arg2_4, var1_4, var2_4)

		if var0_4 == DreamlandData.EXPLORE_SUBTYPE_UNION then
			local var3_4 = arg0_4.spineAnimUIList[arg1_4[2]]

			if var3_4 then
				arg0_4:PlayAction(var3_4, var1_4, var2_4)
			end
		end
	end
end

function var0_0.PlayerEffect(arg0_5, arg1_5, arg2_5)
	if arg0_5.isPlayEffect[arg2_5] then
		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	arg0_5:RemoveEffect(arg2_5)
	PoolMgr.GetInstance():GetUI(arg2_5, true, function(arg0_6)
		arg0_5.effects[arg2_5] = arg0_6

		setParent(arg0_6, arg0_5.root)
		setActive(arg0_6, true)
		pg.UIMgr.GetInstance():LoadingOff()
	end)

	if arg1_5 > 0 then
		arg0_5:AddTimer(arg2_5, arg1_5)
	end
end

function var0_0.AddTimer(arg0_7, arg1_7, arg2_7)
	arg0_7.isPlayEffect[arg1_7] = true
	arg0_7.timers[arg1_7] = Timer.New(function()
		arg0_7:RemoveEffect(arg1_7)

		arg0_7.isPlayEffect[arg1_7] = false
	end, arg2_7, 1)

	arg0_7.timers[arg1_7]:Start()
end

function var0_0.RemoveTimer(arg0_9, arg1_9)
	if arg0_9.timers[arg1_9] then
		arg0_9.timers[arg1_9]:Stop()

		arg0_9.timers[arg1_9] = nil
	end
end

function var0_0.RemoveEffect(arg0_10, arg1_10)
	arg0_10:RemoveTimer()

	if arg0_10.effects[arg1_10] then
		local var0_10 = arg0_10.effects[arg1_10]

		setActive(var0_10, false)
		PoolMgr.GetInstance():ReturnUI(arg1_10, var0_10)

		arg0_10.effects[arg1_10] = nil
	end
end

function var0_0.PlayAction(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local function var0_11(arg0_12)
		if arg0_12 == "finish" then
			arg1_11:SetActionCallBack(nil)
			arg1_11:SetAction(arg3_11, 0)

			if arg4_11 then
				arg4_11()
			end
		end
	end

	arg1_11:SetActionCallBack(nil)
	arg1_11:SetActionCallBack(var0_11)
	arg1_11:SetAction(arg2_11, 0)
end

function var0_0.ClearEffects(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.effects) do
		arg0_13:RemoveEffect(iter0_13)
	end
end

function var0_0.Clear(arg0_14)
	arg0_14.holdSpinePlayRecorder = {}

	for iter0_14, iter1_14 in pairs(arg0_14.timers) do
		iter1_14:Stop()
	end

	arg0_14.timers = {}

	for iter2_14, iter3_14 in pairs(arg0_14.effects) do
		PoolMgr.GetInstance():ReturnUI(iter2_14, iter3_14)
	end

	arg0_14.effects = {}
	arg0_14.isPlayEffect = {}
end

function var0_0.Dispose(arg0_15)
	arg0_15:Clear()
end

return var0_0
