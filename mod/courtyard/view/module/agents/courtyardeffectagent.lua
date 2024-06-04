local var0 = class("CourtYardEffectAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.effects = {}
	arg0.counts = {}
end

function var0.EnableEffect(arg0, arg1)
	if not arg1 then
		return
	end

	if arg0.effects[arg1] then
		arg0.counts[arg1] = (arg0.counts[arg1] or 0) + 1

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetPrefab("ui/" .. arg1, arg1, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if not arg0.effects or arg0.effects[arg1] then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1, arg1, arg0)

			return
		end

		arg0.name = arg1

		setParent(arg0, arg0.effectContainer)
		setActive(arg0, true)

		arg0.effects[arg1] = arg0
		arg0.counts[arg1] = (arg0.counts[arg1] or 0) + 1
	end)
end

function var0.DisableEffect(arg0, arg1)
	if not arg0.effects[arg1] then
		return
	end

	arg0.counts[arg1] = (arg0.counts[arg1] or 0) - 1

	if arg0.counts[arg1] <= 0 then
		local var0 = findTF(arg0.effectContainer, arg1)

		if var0 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. arg1, arg1, var0.gameObject)

			arg0.effects[arg1] = nil
		end
	end
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.effects) do
		PoolMgr.GetInstance():ReturnPrefab("ui/" .. iter0, iter0, iter1)
	end

	arg0.effects = nil
	arg0.counts = nil
end

return var0
