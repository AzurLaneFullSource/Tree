local var0_0 = class("Fushun3SceneController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneTf = arg2_1
	arg0_1._followTf = arg3_1
	arg0_1._sceneBackTf = arg1_1
	arg0_1._backGrouds = {}

	for iter0_1 = 1, #Fushun3GameConst.backgroud_data do
		local var0_1 = Fushun3GameConst.backgroud_data[iter0_1]
		local var1_1 = findTF(arg0_1._sceneBackTf, var0_1.name)

		table.insert(arg0_1._backGrouds, {
			tf = var1_1,
			data = var0_1
		})
	end
end

function var0_0.start(arg0_2)
	arg0_2._sceneTf.anchoredPosition = Vector2(0, 0)

	for iter0_2 = 1, #arg0_2._backGrouds do
		arg0_2._backGrouds[iter0_2].tf.anchoredPosition = Vector2(0, 0)
	end
end

function var0_0.step(arg0_3)
	local var0_3 = arg0_3._sceneTf.anchoredPosition
	local var1_3 = arg0_3._followTf.anchoredPosition.x + var0_3.x
	local var2_3 = 0

	if var1_3 > 350 then
		var2_3 = (var1_3 - Fushun3GameConst.follow_bound_mid) * Fushun3GameConst.follow_spring * -1
	elseif var1_3 < 250 then
		var2_3 = math.abs(var1_3 - Fushun3GameConst.follow_bound_mid) * Fushun3GameConst.follow_spring
	end

	if var2_3 ~= 0 then
		if math.abs(var2_3) < 1 then
			var2_3 = 1 * math.sign(var2_3)
		end

		var0_3.x = var0_3.x + var2_3
		arg0_3._sceneTf.anchoredPosition = var0_3

		for iter0_3 = 1, #arg0_3._backGrouds do
			local var3_3 = arg0_3._backGrouds[iter0_3]
			local var4_3 = var3_3.tf.anchoredPosition

			var4_3.x = var0_3.x * var3_3.data.rate
			var4_3.y = var0_3.y * var3_3.data.rate
			var3_3.tf.anchoredPosition = var4_3
		end
	end
end

function var0_0.dispose(arg0_4)
	return
end

return var0_0
