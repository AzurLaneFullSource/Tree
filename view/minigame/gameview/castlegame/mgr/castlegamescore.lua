local var0_0 = class("CastleGameScore")
local var1_0 = 180

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._scoreTpl = arg1_1
	arg0_1._event = arg2_1
	arg0_1.scorePool = {}
	arg0_1.scores = {}
end

function var0_0.setContent(arg0_2, arg1_2)
	if not arg1_2 then
		print("地板的容器不能为nil")

		return
	end

	arg0_2._content = arg1_2
end

function var0_0.setFloor(arg0_3, arg1_3)
	arg0_3.floorIndexs = {}

	for iter0_3 = 1, #arg1_3 do
		if not arg1_3[iter0_3].fall then
			table.insert(arg0_3.floorIndexs, arg1_3[iter0_3].index)
		end
	end
end

function var0_0.start(arg0_4)
	arg0_4.prepareScores = {}

	for iter0_4 = #arg0_4.scores, 1, -1 do
		local var0_4 = table.remove(arg0_4.scores, iter0_4)

		arg0_4:returnScore(var0_4)
	end

	arg0_4.createTime = CastleGameVo.roundData.score_time
	arg0_4.scoreIndexs = {}
	arg0_4.floorIndexs = {}
end

function var0_0.step(arg0_5)
	for iter0_5 = #arg0_5.createTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0_5.createTime[iter0_5].time then
			local var0_5 = table.remove(arg0_5.createTime, iter0_5)
			local var1_5 = var0_5.num

			arg0_5.prepareScores = {}

			local var2_5 = var0_5.score

			for iter1_5, iter2_5 in pairs(var2_5) do
				for iter3_5 = 1, iter2_5 do
					table.insert(arg0_5.prepareScores, iter1_5)
				end
			end

			arg0_5:createScore(#arg0_5.prepareScores)
		end
	end

	for iter4_5 = #arg0_5.scores, 1, -1 do
		local var3_5 = arg0_5.scores[iter4_5]

		if var3_5.ready and var3_5.ready > 0 then
			var3_5.ready = var3_5.ready - CastleGameVo.deltaTime

			if var3_5.ready <= 0 then
				var3_5.ready = 0
			end
		end

		if var3_5.removeTime and var3_5.removeTime > 0 then
			var3_5.removeTime = var3_5.removeTime - CastleGameVo.deltaTime

			if var3_5.removeTime <= 0 then
				var3_5.ready = 0
				var3_5.removeTime = 0
			end
		end

		if not table.contains(arg0_5.floorIndexs, var3_5.index) then
			var3_5.ready = 0
			var3_5.removeTime = 0
		end

		if var3_5.removeTime and var3_5.removeTime == 0 then
			var3_5.ready = 0

			table.remove(arg0_5.scores, iter4_5)
			arg0_5:returnScore(var3_5)
		end
	end
end

function var0_0.createScore(arg0_6, arg1_6)
	for iter0_6 = 1, arg1_6 do
		if #arg0_6.prepareScores <= 0 then
			return
		end

		local var0_6 = arg0_6:getCreateAbleIndex()

		if not var0_6 then
			return
		end

		local var1_6

		if #arg0_6.scorePool > 0 then
			var1_6 = table.remove(arg0_6.scorePool, 1)
		else
			local var2_6 = tf(instantiate(arg0_6._scoreTpl))
			local var3_6 = findTF(var2_6, "zPos/anim")
			local var4_6 = GetComponent(var3_6, typeof(Animator))
			local var5_6 = GetComponent(findTF(var2_6, "zPos/collider"), typeof(BoxCollider2D))

			setParent(var2_6, arg0_6._content)

			local var6_6 = var2_6:InverseTransformPoint(var5_6.bounds.min)
			local var7_6 = var2_6:InverseTransformPoint(var5_6.bounds.max)

			var1_6 = {
				tf = var2_6,
				bound = var5_6,
				bmin = var6_6,
				bmax = var7_6,
				animTf = var3_6
			}
		end

		local var8_6 = table.remove(arg0_6.prepareScores, math.random(1, #arg0_6.prepareScores))
		local var9_6 = Clone(CastleGameVo.score_data[var8_6])

		var1_6.data = var9_6
		var1_6.id = var8_6

		local var10_6 = var9_6.tpl
		local var11_6 = var1_6.animTf.childCount

		for iter1_6 = 0, var11_6 - 1 do
			setActive(var1_6.animTf:GetChild(iter1_6), false)
		end

		setActive(findTF(var1_6.animTf, var10_6), true)

		local var12_6 = var0_6 % CastleGameVo.w_count
		local var13_6 = math.floor(var0_6 / CastleGameVo.w_count)
		local var14_6 = CastleGameVo.GetRotationPosByWH(var12_6, var13_6)

		var14_6.y = var14_6.y + var1_0
		var1_6.tf.anchoredPosition = var14_6
		var1_6.index = var0_6
		var1_6.ready = 0.5
		var1_6.removeTime = CastleGameVo.score_remove_time

		setActive(var1_6.tf, true)
		table.insert(arg0_6.scoreIndexs, var0_6)
		table.insert(arg0_6.scores, var1_6)

		if arg0_6.itemChangeCallback then
			arg0_6.itemChangeCallback(var1_6, true)
		end
	end
end

function var0_0.getCreateAbleIndex(arg0_7)
	local var0_7 = {}

	for iter0_7 = 1, #arg0_7.floorIndexs do
		if not table.contains(arg0_7.scoreIndexs, arg0_7.floorIndexs[iter0_7]) then
			table.insert(var0_7, arg0_7.floorIndexs[iter0_7])
		end
	end

	if #var0_7 > 0 then
		return var0_7[math.random(1, #var0_7)]
	else
		return nil
	end
end

function var0_0.getScores(arg0_8)
	return arg0_8.scores
end

function var0_0.setItemChange(arg0_9, arg1_9)
	arg0_9.itemChangeCallback = arg1_9
end

function var0_0.hitScore(arg0_10, arg1_10)
	for iter0_10 = #arg0_10.scores, 1, -1 do
		if arg0_10.scores[iter0_10] == arg1_10 then
			local var0_10 = table.remove(arg0_10.scores, iter0_10)

			arg0_10:returnScore(var0_10)

			return
		end
	end
end

function var0_0.returnScore(arg0_11, arg1_11)
	local var0_11 = arg1_11.index

	for iter0_11 = #arg0_11.scoreIndexs, 1, -1 do
		if arg0_11.scoreIndexs[iter0_11] == var0_11 then
			table.remove(arg0_11.scoreIndexs, iter0_11)
		end
	end

	if arg0_11.itemChangeCallback then
		arg0_11.itemChangeCallback(arg1_11, false)
	end

	setActive(arg1_11.tf, false)
	table.insert(arg0_11.scorePool, arg1_11)
end

function var0_0.clear(arg0_12)
	return
end

return var0_0
