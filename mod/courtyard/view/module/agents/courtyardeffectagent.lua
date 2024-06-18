local var0_0 = class("CourtYardEffectAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.effects = {}
	arg0_1.counts = {}
end

function var0_0.EnableEffect(arg0_2, arg1_2)
	if not arg1_2 then
		return
	end

	if arg0_2.effects[arg1_2] then
		arg0_2.counts[arg1_2] = (arg0_2.counts[arg1_2] or 0) + 1

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1_2, arg1_2, true, function(arg0_3)
		pg.UIMgr.GetInstance():LoadingOff()

		if not arg0_2.effects or arg0_2.effects[arg1_2] then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_2, arg1_2, arg0_3)

			return
		end

		arg0_3.name = arg1_2

		setParent(arg0_3, arg0_2.effectContainer)
		setActive(arg0_3, true)

		arg0_2.effects[arg1_2] = arg0_3
		arg0_2.counts[arg1_2] = (arg0_2.counts[arg1_2] or 0) + 1
	end)
end

function var0_0.DisableEffect(arg0_4, arg1_4)
	if not arg0_4.effects[arg1_4] then
		return
	end

	arg0_4.counts[arg1_4] = (arg0_4.counts[arg1_4] or 0) - 1

	if arg0_4.counts[arg1_4] <= 0 then
		local var0_4 = findTF(arg0_4.effectContainer, arg1_4)

		if var0_4 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1_4, arg1_4, var0_4.gameObject)

			arg0_4.effects[arg1_4] = nil
		end
	end
end

function var0_0.Dispose(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.effects) do
		PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0_5, iter0_5, iter1_5)
	end

	arg0_5.effects = nil
	arg0_5.counts = nil
end

return var0_0
