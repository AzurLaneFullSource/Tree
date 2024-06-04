local var0 = class("CastleGameScore")
local var1 = 180

function var0.Ctor(arg0, arg1, arg2)
	arg0._scoreTpl = arg1
	arg0._event = arg2
	arg0.scorePool = {}
	arg0.scores = {}
end

function var0.setContent(arg0, arg1)
	if not arg1 then
		print("地板的容器不能为nil")

		return
	end

	arg0._content = arg1
end

function var0.setFloor(arg0, arg1)
	arg0.floorIndexs = {}

	for iter0 = 1, #arg1 do
		if not arg1[iter0].fall then
			table.insert(arg0.floorIndexs, arg1[iter0].index)
		end
	end
end

function var0.start(arg0)
	arg0.prepareScores = {}

	for iter0 = #arg0.scores, 1, -1 do
		local var0 = table.remove(arg0.scores, iter0)

		arg0:returnScore(var0)
	end

	arg0.createTime = CastleGameVo.roundData.score_time
	arg0.scoreIndexs = {}
	arg0.floorIndexs = {}
end

function var0.step(arg0)
	for iter0 = #arg0.createTime, 1, -1 do
		if CastleGameVo.gameStepTime > arg0.createTime[iter0].time then
			local var0 = table.remove(arg0.createTime, iter0)
			local var1 = var0.num

			arg0.prepareScores = {}

			local var2 = var0.score

			for iter1, iter2 in pairs(var2) do
				for iter3 = 1, iter2 do
					table.insert(arg0.prepareScores, iter1)
				end
			end

			arg0:createScore(#arg0.prepareScores)
		end
	end

	for iter4 = #arg0.scores, 1, -1 do
		local var3 = arg0.scores[iter4]

		if var3.ready and var3.ready > 0 then
			var3.ready = var3.ready - CastleGameVo.deltaTime

			if var3.ready <= 0 then
				var3.ready = 0
			end
		end

		if var3.removeTime and var3.removeTime > 0 then
			var3.removeTime = var3.removeTime - CastleGameVo.deltaTime

			if var3.removeTime <= 0 then
				var3.ready = 0
				var3.removeTime = 0
			end
		end

		if not table.contains(arg0.floorIndexs, var3.index) then
			var3.ready = 0
			var3.removeTime = 0
		end

		if var3.removeTime and var3.removeTime == 0 then
			var3.ready = 0

			table.remove(arg0.scores, iter4)
			arg0:returnScore(var3)
		end
	end
end

function var0.createScore(arg0, arg1)
	for iter0 = 1, arg1 do
		if #arg0.prepareScores <= 0 then
			return
		end

		local var0 = arg0:getCreateAbleIndex()

		if not var0 then
			return
		end

		local var1

		if #arg0.scorePool > 0 then
			var1 = table.remove(arg0.scorePool, 1)
		else
			local var2 = tf(instantiate(arg0._scoreTpl))
			local var3 = findTF(var2, "zPos/anim")
			local var4 = GetComponent(var3, typeof(Animator))
			local var5 = GetComponent(findTF(var2, "zPos/collider"), typeof(BoxCollider2D))

			setParent(var2, arg0._content)

			local var6 = var2:InverseTransformPoint(var5.bounds.min)
			local var7 = var2:InverseTransformPoint(var5.bounds.max)

			var1 = {
				tf = var2,
				bound = var5,
				bmin = var6,
				bmax = var7,
				animTf = var3
			}
		end

		local var8 = table.remove(arg0.prepareScores, math.random(1, #arg0.prepareScores))
		local var9 = Clone(CastleGameVo.score_data[var8])

		var1.data = var9
		var1.id = var8

		local var10 = var9.tpl
		local var11 = var1.animTf.childCount

		for iter1 = 0, var11 - 1 do
			setActive(var1.animTf:GetChild(iter1), false)
		end

		setActive(findTF(var1.animTf, var10), true)

		local var12 = var0 % CastleGameVo.w_count
		local var13 = math.floor(var0 / CastleGameVo.w_count)
		local var14 = CastleGameVo.GetRotationPosByWH(var12, var13)

		var14.y = var14.y + var1
		var1.tf.anchoredPosition = var14
		var1.index = var0
		var1.ready = 0.5
		var1.removeTime = CastleGameVo.score_remove_time

		setActive(var1.tf, true)
		table.insert(arg0.scoreIndexs, var0)
		table.insert(arg0.scores, var1)

		if arg0.itemChangeCallback then
			arg0.itemChangeCallback(var1, true)
		end
	end
end

function var0.getCreateAbleIndex(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.floorIndexs do
		if not table.contains(arg0.scoreIndexs, arg0.floorIndexs[iter0]) then
			table.insert(var0, arg0.floorIndexs[iter0])
		end
	end

	if #var0 > 0 then
		return var0[math.random(1, #var0)]
	else
		return nil
	end
end

function var0.getScores(arg0)
	return arg0.scores
end

function var0.setItemChange(arg0, arg1)
	arg0.itemChangeCallback = arg1
end

function var0.hitScore(arg0, arg1)
	for iter0 = #arg0.scores, 1, -1 do
		if arg0.scores[iter0] == arg1 then
			local var0 = table.remove(arg0.scores, iter0)

			arg0:returnScore(var0)

			return
		end
	end
end

function var0.returnScore(arg0, arg1)
	local var0 = arg1.index

	for iter0 = #arg0.scoreIndexs, 1, -1 do
		if arg0.scoreIndexs[iter0] == var0 then
			table.remove(arg0.scoreIndexs, iter0)
		end
	end

	if arg0.itemChangeCallback then
		arg0.itemChangeCallback(arg1, false)
	end

	setActive(arg1.tf, false)
	table.insert(arg0.scorePool, arg1)
end

function var0.clear(arg0)
	return
end

return var0
