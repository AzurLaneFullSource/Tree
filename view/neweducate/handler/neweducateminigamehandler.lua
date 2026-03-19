local var0_0 = class("NewEducateMinigameHandler")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.games = {}
	arg0_1.view = arg2_1
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	setActive(arg0_2._go, true)

	arg0_2.config = pg.child2_minigame[arg1_2]

	local var0_2 = arg0_2.config.view_name

	if not arg0_2.games[var0_2] then
		arg0_2.games[var0_2] = _G[var0_2].New(arg0_2._tf)

		arg0_2.games[var0_2]:RegisterView(arg0_2.view)
	end

	arg0_2.games[var0_2]:ExecuteAction("Show", arg1_2, function(arg0_3)
		local var0_3 = arg0_2:GetNextId(arg0_3)

		arg2_2(var0_3)
	end)
end

function var0_0.GetNextId(arg0_4, arg1_4)
	if type(arg1_4) ~= "number" then
		arg1_4 = 0
	end

	local var0_4 = arg0_4.config.result_data

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if arg1_4 >= iter1_4[1][1] and arg1_4 >= iter1_4[1][2] then
			return iter1_4[2][1]
		end
	end

	return var0_4[#var0_4][2][1]
end

function var0_0.Reset(arg0_5)
	setActive(arg0_5._go, false)
end

function var0_0.Destroy(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.games) do
		iter1_6:Destroy()
	end
end

return var0_0
