local var0 = class("Fushun3SceneController")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._sceneTf = arg2
	arg0._followTf = arg3
	arg0._sceneBackTf = arg1
	arg0._backGrouds = {}

	for iter0 = 1, #Fushun3GameConst.backgroud_data do
		local var0 = Fushun3GameConst.backgroud_data[iter0]
		local var1 = findTF(arg0._sceneBackTf, var0.name)

		table.insert(arg0._backGrouds, {
			tf = var1,
			data = var0
		})
	end
end

function var0.start(arg0)
	arg0._sceneTf.anchoredPosition = Vector2(0, 0)

	for iter0 = 1, #arg0._backGrouds do
		arg0._backGrouds[iter0].tf.anchoredPosition = Vector2(0, 0)
	end
end

function var0.step(arg0)
	local var0 = arg0._sceneTf.anchoredPosition
	local var1 = arg0._followTf.anchoredPosition.x + var0.x
	local var2 = 0

	if var1 > 350 then
		var2 = (var1 - Fushun3GameConst.follow_bound_mid) * Fushun3GameConst.follow_spring * -1
	elseif var1 < 250 then
		var2 = math.abs(var1 - Fushun3GameConst.follow_bound_mid) * Fushun3GameConst.follow_spring
	end

	if var2 ~= 0 then
		if math.abs(var2) < 1 then
			var2 = 1 * math.sign(var2)
		end

		var0.x = var0.x + var2
		arg0._sceneTf.anchoredPosition = var0

		for iter0 = 1, #arg0._backGrouds do
			local var3 = arg0._backGrouds[iter0]
			local var4 = var3.tf.anchoredPosition

			var4.x = var0.x * var3.data.rate
			var4.y = var0.y * var3.data.rate
			var3.tf.anchoredPosition = var4
		end
	end
end

function var0.dispose(arg0)
	return
end

return var0
