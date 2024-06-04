local var0 = class("LaunchBallEnemy")
local var1 = {}
local var2 = 0.35
local var3 = 70
local var4 = 100
local var5 = 80
local var6 = 80
local var7 = 50
local var8 = {
	{
		0,
		60
	},
	{
		60,
		70
	},
	{
		120,
		80
	},
	{
		180,
		90
	},
	{
		240,
		100
	}
}
local var9 = -300
local var10 = -150
local var11 = 0.5
local var12 = 500
local var13 = -500
local var14 = 10
local var15 = {
	{
		anim_name = "01_Yellow"
	},
	{
		anim_name = "02_Green"
	},
	{
		anim_name = "03_White"
	},
	{
		anim_name = "04_Red"
	},
	{
		anim_name = "05_Blue"
	},
	{
		anim_name = "06_Black"
	},
	{
		anim_name = "07_Purple"
	}
}

local function var16(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._animator = GetComponent(findTF(arg0._tf, "ad/anim"), typeof(Animator))
			arg0.angleTf = findTF(arg0._tf, "ad/angle")
			arg0.leftBoundPoints = {}

			local var0 = GetComponent(findTF(arg0._tf, "ad/angle/left"), typeof("UnityEngine.PolygonCollider2D"))

			for iter0 = 0, var0.points.Length - 1 do
				table.insert(arg0.leftBoundPoints, var0.points[iter0])
			end

			arg0.rightBoundPoints = {}

			local var1 = GetComponent(findTF(arg0._tf, "ad/angle/right"), typeof("UnityEngine.PolygonCollider2D"))

			for iter1 = 0, var1.points.Length - 1 do
				table.insert(arg0.rightBoundPoints, var1.points[iter1])
			end

			arg0.localRotation = Vector3(0, 0, 0)
			arg0.circlePos = findTF(arg0._tf, "ad/angle/circle").anchoredPosition

			if not arg0.buffIcon then
				arg0.buffIcon = findTF(arg0._tf, "ad/iconEffect")
			end

			arg0._effectTf = findTF(arg0._tf, "ad/effect")
			arg0._playEffects = {}
		end,
		setData = function(arg0, arg1, arg2)
			arg0:clear()

			arg0.enemyIndex = arg1
			arg0._animator.runtimeAnimatorController = arg2.animator
			arg0.data = arg2
			arg0.hp = arg2.data.hp
			arg0.overSplitFlag = false

			for iter0 = 0, arg0.buffIcon.childCount - 1 do
				local var0 = arg0.buffIcon:GetChild(iter0)

				setActive(var0, false)
			end

			for iter1 = #arg0._playEffects, 1, -1 do
				setActive(arg0._playEffects[iter1].tf, false)
				table.remove(arg0._playEffects, iter1)
			end

			arg0:stopAnim(false)
		end,
		setBuff = function(arg0, arg1)
			arg0.buffType = arg1

			if arg0.buffType then
				local var0 = LaunchBallGameConst.enemy_buff_data[arg0.buffType].tpl

				for iter0 = 0, arg0.buffIcon.childCount - 1 do
					local var1 = arg0.buffIcon:GetChild(iter0)

					setActive(var1, var1.name == var0)
				end
			else
				for iter1 = 0, arg0.buffIcon.childCount - 1 do
					local var2 = arg0.buffIcon:GetChild(iter1)

					setActive(var2, false)
				end
			end
		end,
		getBuff = function(arg0)
			return arg0.buffType
		end,
		setPoints = function(arg0, arg1)
			arg0.points = arg1
		end,
		hit = function(arg0)
			if arg0.buffType and arg0.buffType == LaunchBallGameConst.enemy_buff_streng then
				arg0:setBuff(nil)

				return
			end

			arg0.hp = arg0.hp - 1

			if arg0.hp <= 0 then
				arg0:setTimeRemove()
			end
		end,
		getTf = function(arg0)
			return arg0._tf
		end,
		playAnimation = function(arg0, arg1)
			arg0._animator:Play(arg1)
		end,
		setActive = function(arg0, arg1)
			setActive(arg0._tf, arg1)
		end,
		getColor = function(arg0)
			return arg0.data.data.color
		end,
		getSplitFlag = function(arg0)
			return arg0.splitFlag
		end,
		setSplitFlag = function(arg0, arg1)
			arg0.splitFlag = arg1
		end,
		step = function(arg0)
			if arg0.timeToRemove and arg0.timeToRemove > 0 then
				arg0.timeToRemove = arg0.timeToRemove - LaunchBallGameVo.deltaTime

				if arg0.timeToRemove <= 0 then
					arg0.timeToRemove = nil
					arg0.removeFlag = true
				end
			end

			if #arg0._playEffects > 0 then
				for iter0 = #arg0._playEffects, 1, -1 do
					local var0 = arg0._playEffects[iter0]

					if var0.time then
						var0.time = var0.time - LaunchBallGameVo.deltaTime
					end

					if var0.time and var0.time <= 0 then
						setActive(var0.tf, false)
						table.remove(arg0._playEffects, iter0)
					end
				end
			end
		end,
		move = function(arg0, arg1, arg2, arg3, arg4)
			if arg1 == 0 then
				return
			end

			var0.moveCount = var0.moveCount + 1
			arg0.distance = arg0.distance + arg1

			if arg0.distance < 0 then
				arg0.distance = 0
			end

			if arg2 and arg3 and arg4 then
				arg0._tf.anchoredPosition = arg2
				arg0.pointIndex = arg3
				arg0.localRotation = arg4
				arg0.angleTf.localEulerAngles = arg0.localRotation
			else
				local var0 = arg0:getPosByDistance(arg0.distance)
				local var1 = arg0._tf.anchoredPosition

				var1.x = var0.x
				var1.y = var0.y
				arg0._tf.anchoredPosition = var1
				arg0.pointIndex = var0.index
				arg0.localRotation.z = arg0.points[arg0.pointIndex].angle
				arg0.angleTf.localEulerAngles = arg0.localRotation
			end
		end,
		getPosition = function(arg0)
			return arg0._tf.anchoredPosition
		end,
		getPointIndex = function(arg0)
			return arg0.pointIndex
		end,
		getLocalRotation = function(arg0)
			return arg0.localRotation
		end,
		stopAnim = function(arg0, arg1)
			if arg1 then
				arg0._animator.speed = 0
			else
				arg0._animator.speed = 1
			end
		end,
		checkWorldInCircle = function(arg0, arg1)
			local var0 = arg0.angleTf:InverseTransformPoint(arg1)

			if math.abs(var0.x - arg0.circlePos.x) >= 150 or math.abs(var0.y - arg0.circlePos.y) >= var5 * 2 then
				return false
			end

			local var1 = 0

			if math.sqrt(math.pow(var0.x - arg0.circlePos.x, 2) + math.pow(var0.y - arg0.circlePos.y, 2)) < var5 then
				return true
			end

			return false
		end,
		checkWorldInRect = function(arg0, arg1)
			local var0 = arg0.angleTf:InverseTransformPoint(arg1)
			local var1 = 0
			local var2 = math.sqrt(math.pow(var0.x - arg0.circlePos.x, 2) + math.pow(var0.y - arg0.circlePos.y, 2))

			if var2 > var3 then
				return var1, nil
			end

			if LaunchBallGameVo.PointInRect(var0, arg0.leftBoundPoints[1], arg0.leftBoundPoints[2], arg0.leftBoundPoints[3], arg0.leftBoundPoints[4]) then
				var1 = -1
			elseif LaunchBallGameVo.PointInRect(var0, arg0.rightBoundPoints[1], arg0.rightBoundPoints[2], arg0.rightBoundPoints[3], arg0.rightBoundPoints[4]) then
				var1 = 1
			end

			return var1, var2
		end,
		getPosByDistance = function(arg0, arg1)
			local var0 = math.floor(arg1 * 2)

			if var0.EnemyDistanceData[arg0.enemyIndex][var0] then
				return var0.EnemyDistanceData[arg0.enemyIndex][var0]
			end

			local var1 = var0 / 2

			if not arg0.distancePosResult then
				arg0.distancePosResult = Vector2(0, 0)
			end

			local var2 = 1
			local var3 = 0

			for iter0 = 1, #arg0.points do
				local var4 = arg0.points[iter0]

				if var1 >= var4.distance then
					var2 = iter0

					if iter0 < #arg0.points then
						var3 = var1 - var4.distance
						arg0.distancePosResult.x = var4.pos.x
						arg0.distancePosResult.y = var4.pos.y
					else
						arg0.distancePosResult.x = var4.pos.x
						arg0.distancePosResult.y = var4.pos.y
						var3 = 0
					end
				else
					break
				end
			end

			if var3 ~= 0 then
				local var5 = arg0.points[var2].move

				arg0.distancePosResult.x = arg0.distancePosResult.x + var5.x * var3
				arg0.distancePosResult.y = arg0.distancePosResult.y + var5.y * var3
			end

			local var6 = {
				x = arg0.distancePosResult.x,
				y = arg0.distancePosResult.y,
				index = var2
			}

			var0.EnemyDistanceData[arg0.enemyIndex][var0] = var6

			return var6
		end,
		setTimeRemove = function(arg0)
			if arg0.hp > 0 then
				arg0.hp = 0
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_ENEMY_REMOVE)

			if arg0:getBuff(LaunchBallGameConst.enemy_buff_boom) then
				local var0 = arg0:getColor()
				local var1 = var15[var0].anim_name

				arg0:playEffectAnim("Bomb", var1, 0.2)
			end

			arg0:stopAnim(false)
			arg0:playAnimation("Remove")

			arg0.timeToRemove = var2
		end,
		playEffectAnim = function(arg0, arg1, arg2, arg3)
			local var0 = findTF(arg0._effectTf, arg1)

			setActive(var0, true)
			GetComponent(var0, typeof(Animator)):Play(arg2)
			table.insert(arg0._playEffects, {
				tf = var0,
				time = arg3
			})
		end,
		getTimeRemove = function(arg0)
			return arg0.timeToRemove
		end,
		setPosIndex = function(arg0, arg1)
			arg0._tf.anchoredPosition = arg0.points[arg1].pos
			arg0.pointIndex = arg1
			arg0.distance = arg0.points[arg1].distance
		end,
		setDistance = function(arg0, arg1)
			arg0.distance = arg1
			arg0._tf.anchoredPosition = arg0:getPosByDistance(arg0.distance)
		end,
		getDistance = function(arg0)
			return arg0.distance
		end,
		getRemoveFlag = function(arg0)
			return arg0.removeFlag
		end,
		setLastLayer = function(arg0, arg1)
			return arg0._tf:SetSiblingIndex(arg1)
		end,
		getFinish = function(arg0)
			return arg0.distance >= arg0.points[#arg0.points].distance
		end,
		clear = function(arg0)
			arg0.finalFlag = false
			arg0.removeFlag = false
			arg0.timeToRemove = nil
			arg0.buffType = nil
		end
	}

	var0:ctor()

	return var0
end

var0.EnemyDistanceData = {}

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._enemyContent = arg1
	arg0._lineContent = arg2
	arg0._tpl = arg3
	arg0._eventCall = arg4
	arg0._enemyTpl = findTF(arg0._tpl, "Enemy")
	arg0.enemyDatas = {}

	for iter0, iter1 in pairs(LaunchBallGameConst.enemy_data) do
		local var0 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, iter1.name, typeof(RuntimeAnimatorController), false, false)

		table.insert(arg0.enemyDatas, {
			animator = var0,
			data = iter1
		})
	end

	arg0.enemyRule = Clone(LaunchBallGameConst.enemy_create_rule)
	arg0.enemysList = {}
	arg0.enemyPool = {}
	arg0.colliderTestTf = findTF(arg0._enemyContent, "colliderTest")

	setActive(arg0.colliderTestTf, false)
end

function var0.start(arg0)
	arg0.moveSpeed = LaunchBallGameVo.gameRoundData.speed
	var0.EnemyDistanceData = {}
	arg0.gameRoundData = LaunchBallGameVo.gameRoundData
	arg0._enemyContent.sizeDelta = LaunchBallGameConst.enemy_round_bound[arg0.gameRoundData.round_bound]
	arg0.roundDatas = Clone(LaunchBallGameConst.round_enemy[arg0.gameRoundData.round_enemy])
	arg0.lineData = Clone(LaunchBallGameConst.map_data[arg0.gameRoundData.map])
	arg0.enemyBuffs = Clone(LaunchBallGameConst.enemy_round_buff[arg0.gameRoundData.enemy_buff])

	arg0:createRoundData()

	arg0.currentEnemyRule = arg0:getEnemyRule()

	if arg0.lineTf then
		setActive(arg0.lineTf, false)
	end

	arg0.lineTf = findTF(arg0._lineContent, arg0.lineData.line)

	setActive(arg0.lineTf, true)

	for iter0, iter1 in ipairs(arg0.enemysList) do
		for iter2 = #iter1, 1, -1 do
			arg0:returnEnemy(table.remove(iter1, iter2))
		end
	end

	arg0.pointsList = {}
	arg0.enemysList = {}

	local var0 = findTF(arg0.lineTf, "ad/points")

	if var0 then
		local var1 = arg0:createPoints(var0)

		table.insert(arg0.pointsList, var1)
		table.insert(arg0.enemysList, {})

		var0.EnemyDistanceData[1] = {}
	end

	local var2 = findTF(arg0.lineTf, "ad/points1")

	if var2 then
		local var3 = arg0:createPoints(var2)

		table.insert(arg0.pointsList, var3)
		table.insert(arg0.enemysList, {})

		var0.EnemyDistanceData[2] = {}
	end

	for iter3 = 1, #arg0.pointsList do
		arg0:createRandomEnemy(iter3, arg0.pointsList[iter3], arg0.enemysList[iter3], 1, 0, true)
	end

	arg0.backEnemyFlag = false
	arg0.backEnemyTime = nil
	arg0.seriesCount = 1
	arg0.lastPointDistance = nil
end

var0.moveCount = 0

function var0.step(arg0)
	var0.moveCount = 0

	arg0:checkEnemyRuleUpdate()
	arg0:checkEnemyDataUpdate()
	arg0:checkCreateEnemy()
	arg0:checkRemoveEnemy()
	arg0:moveEnmey()
	arg0:checkEnemyQuick()
	arg0:checkEnemyBack()
	arg0:updateEnemyRemoveFlag()
	arg0:checkEnemySplit()
	arg0:updateEnemyVo()
	arg0:checkEnemyFinal()
	arg0:updateEnemyData()
end

function var0.updateEnemyData(arg0)
	if not arg0.lastPointDistance then
		arg0.lastPointDistance = {}

		for iter0 = 1, #arg0.pointsList do
			local var0 = arg0.pointsList[iter0]

			table.insert(arg0.lastPointDistance, var0[#var0].distance)
		end
	end

	local var1 = {}
	local var2 = 0

	for iter1 = 1, #arg0.enemysList do
		local var3 = arg0.enemysList[iter1]

		if var3 and #var3 > 0 then
			local var4 = var3[#var3]:getDistance()

			table.insert(var1, math.floor(var4 / arg0.lastPointDistance[iter1] * 10))
		end
	end

	LaunchBallGameVo.enemyToEndRate = var1
end

function var0.checkEnemyDataUpdate(arg0)
	if arg0.currentEnemyRule == nil then
		arg0.currentEnemyRule = arg0:getEnemyRule()
	end
end

function var0.checkTargetScore(arg0)
	if LaunchBallGameVo.gameRoundData.target and LaunchBallGameVo.scoreNum >= LaunchBallGameVo.gameRoundData.target then
		return true
	end

	return false
end

function var0.checkCreateEnemy(arg0)
	if arg0:checkTargetScore() then
		return
	end

	local var0 = 1

	for iter0 = 1, #arg0.enemysList do
		local var1 = arg0.enemysList[iter0]
		local var2 = arg0.pointsList[iter0]

		if #var1 > 0 then
			if var1[1]:getDistance() > var6 then
				arg0:createRandomEnemy(iter0, var2, var1, 1, 0, true)

				break
			end
		else
			arg0:createRandomEnemy(iter0, var2, var1, 1, 0, true)

			break
		end
	end
end

function var0.checkRemoveEnemy(arg0)
	for iter0, iter1 in ipairs(arg0.enemysList) do
		local var0 = false

		for iter2 = #iter1, 1, -1 do
			iter1[iter2]:step()

			if iter1[iter2]:getRemoveFlag() then
				local var1 = iter1[iter2]:getBuff()

				if var1 then
					arg0:appearEnemyBuff(var1, iter2, iter1[iter2], iter1)
				end

				arg0:returnEnemy(table.remove(iter1, iter2))

				local var2 = true
			end
		end
	end

	if arg0.timeRemoveAll and arg0.timeRemoveAll > 0 then
		arg0.timeRemoveAll = arg0.timeRemoveAll - LaunchBallGameVo.deltaTime

		if arg0.timeRemoveAll <= 0 then
			local var3 = 0

			for iter3, iter4 in ipairs(arg0.enemysList) do
				for iter5 = #iter4, 1, -1 do
					local var4 = iter4[iter5]

					if not var4:getRemoveFlag() then
						var4:setTimeRemove()

						var3 = var3 + 1

						local var5 = LaunchBallGameVo.GetScore(1, 1)

						arg0._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
							num = var5
						})
					end
				end
			end

			LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.result_skill_count, var3)

			arg0.timeRemoveAll = nil
		end
	end
end

function var0.appearEnemyBuff(arg0, arg1, arg2, arg3, arg4)
	local var0 = LaunchBallGameConst.enemy_buff_data[arg1]

	if arg1 == LaunchBallGameConst.enemy_buff_slow then
		arg0.slowTime = var0.time

		if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
			arg0.slowTime = arg0.slowTime * 1.5

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)

			if arg0.enemyStopTime and arg0.enemyStopTime > 0 then
				arg0.enemyStopTime = arg0.enemyStopTime + 3
			end
		end
	elseif arg1 == LaunchBallGameConst.enemy_buff_back then
		arg0.backEnemyTime = var0.time
		arg0.backSpeed = var10
		arg0.moveBackIndex = #arg4

		if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
			arg0.backEnemyTime = arg0.backEnemyTime * 1.3

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)
		end
	elseif arg1 == LaunchBallGameConst.enemy_buff_boom then
		local var1 = arg3:getDistance()
		local var2 = var0.distance

		for iter0 = 1, #arg4 do
			if not arg4[iter0]:getRemoveFlag() and var2 >= math.abs(arg4[iter0]:getDistance() - var1) then
				arg4[iter0]:setTimeRemove()

				local var3 = LaunchBallGameVo.GetScore(1, 1)

				arg0._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
					num = var3
				})
			end
		end
	elseif arg1 == LaunchBallGameConst.enemy_buff_concentrate then
		arg0._eventCall(LaunchBallGameScene.CONCENTRATE_TRIGGER, var0)
	end
end

function var0.moveEnmey(arg0)
	local var0

	if arg0.enemyStopTime and arg0.enemyStopTime > 0 then
		arg0.enemyStopTime = arg0.enemyStopTime - LaunchBallGameVo.deltaTime

		if arg0.enemyStopTime <= 0 then
			arg0.enemyStopTime = nil

			arg0:stopEnemysAnim(false)
		end

		LaunchBallGameVo.enemyStopTime = arg0.enemyStopTime
	end

	if arg0.enemyStopTime and arg0.enemyStopTime > 0 then
		return
	end

	if arg0.backEnemyTime and arg0.backEnemyTime > 0 then
		arg0.backEnemyTime = arg0.backEnemyTime - LaunchBallGameVo.deltaTime

		if arg0.backEnemyTime <= 0 then
			arg0.backEnemyTime = nil
		end

		var0 = arg0.backSpeed * LaunchBallGameVo.deltaTime
	else
		var0 = arg0.moveSpeed * LaunchBallGameVo.deltaTime
	end

	if arg0.slowTime and arg0.slowTime > 0 then
		var0 = var0 / 3
		arg0.slowTime = arg0.slowTime - LaunchBallGameVo.deltaTime

		if arg0.slowTime < 0 then
			arg0.slowTime = nil
		end
	end

	local var1 = {}

	for iter0, iter1 in ipairs(arg0.enemysList) do
		local var2 = 0

		if var0 > 0 then
			for iter2 = 1, #iter1 do
				local var3 = false

				if iter2 < #iter1 and iter1[iter2]:getDistance() < var6 and iter1[iter2 + 1]:getDistance() < var6 then
					var3 = true
				end

				if iter2 > 1 and var2 == 0 then
					if iter1[iter2]:getDistance() - iter1[iter2 - 1]:getDistance() > var6 then
						var2 = iter2
						var3 = true
					elseif iter1[iter2]:getRemoveFlag() then
						var2 = iter2
						var3 = true
					end
				elseif var2 ~= 0 and var2 <= iter2 then
					var3 = true
				end

				if not var3 then
					iter1[iter2]:move(var0)
				end
			end
		end

		if var0 < 0 then
			for iter3 = #iter1, 1, -1 do
				local var4 = false

				if iter3 <= arg0.moveBackIndex and var2 == 0 then
					if iter3 > 1 and iter1[iter3]:getDistance() - iter1[iter3 - 1]:getDistance() > var6 + var14 then
						var2 = iter3 - 1
					end
				else
					var4 = var2 ~= 0 and iter3 <= var2 and true or true
				end

				if not var4 then
					iter1[iter3]:move(var0)
				end
			end
		end
	end
end

function var0.checkEnemyQuick(arg0)
	if arg0.backFlag then
		return
	end

	arg0.quickFlag = false

	for iter0, iter1 in ipairs(arg0.enemysList) do
		local var0 = 0

		for iter2 = 1, #iter1 do
			local var1 = iter1[iter2]

			if iter2 <= #iter1 - 1 then
				local var2 = iter1[iter2 + 1]

				if var2:getDistance() > var6 and var2:getDistance() - var1:getDistance() < var6 - var14 then
					var0 = iter2 + 1
					arg0.quickFlag = true

					break
				end
			end
		end

		if var0 ~= 0 then
			for iter3 = 1, #iter1 do
				if var0 <= iter3 then
					local var3 = iter1[iter3 - 1]

					if iter1[iter3]:getDistance() - var3:getDistance() < var6 - var14 then
						iter1[iter3]:move(var12 * LaunchBallGameVo.deltaTime)
					else
						break
					end
				end
			end
		end
	end
end

function var0.checkEnemyBack(arg0)
	arg0.backFlag = false

	if not arg0.quickFlag then
		for iter0, iter1 in ipairs(arg0.enemysList) do
			local var0 = 0

			for iter2 = 1, #iter1 do
				if iter2 > 1 and var0 == 0 and iter1[iter2]:getDistance() - iter1[iter2 - 1]:getDistance() > var6 + var14 and iter1[iter2]:getSplitFlag() and iter1[iter2]:getColor() == iter1[iter2 - 1]:getColor() then
					var0 = iter2

					if not arg0.backEnemyFlag then
						arg0.backEnemyFlag = true
					end
				end
			end

			if var0 ~= 0 then
				arg0.backFlag = true
				arg0.moveBackIndex = 0

				for iter3 = 1, #iter1 do
					if iter3 == var0 then
						arg0.moveBackIndex = iter3

						iter1[iter3]:move(var13 * LaunchBallGameVo.deltaTime)
					elseif var0 < iter3 then
						if iter1[iter3]:getDistance() - iter1[iter3 - 1]:getDistance() < var6 + var14 then
							iter1[iter3]:move(var13 * LaunchBallGameVo.deltaTime)

							arg0.moveBackIndex = iter3
						else
							break
						end
					end
				end
			end
		end
	end

	if arg0.backFlag and arg0.backEnemyFlag then
		arg0.backEnemyFlag = false
		arg0.backEnemyTime = var11
		arg0.backSpeed = var9
	end
end

function var0.updateEnemyRemoveFlag(arg0)
	arg0.enemyTimeRemoveFlag = false

	for iter0, iter1 in ipairs(arg0.enemysList) do
		local var0 = 0

		for iter2 = 1, #iter1 do
			if iter1[iter2]:getTimeRemove() then
				arg0.enemyTimeRemoveFlag = true
			end
		end
	end
end

function var0.checkEnemySplit(arg0)
	if not arg0.enemyTimeRemoveFlag and not arg0.backFlag and not arg0.quickFlag and not arg0.backEnemyFlag then
		for iter0, iter1 in ipairs(arg0.enemysList) do
			local var0 = 0

			for iter2 = 1, #iter1 do
				local var1 = iter1[iter2]

				if var1:getSplitFlag() then
					local var2 = iter2
					local var3, var4, var5 = arg0:checkSplit(var2, iter1)

					var1:setSplitFlag(false)

					if var3 >= 3 or var4 then
						arg0.seriesCount = arg0.seriesCount + 1

						if arg0.splitFireIndex and arg0.splitFireIndex + 1 >= arg0.fireIndex then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_series_count, 1)

							if not arg0.seriesCombat then
								arg0.seriesCombat = 1
							else
								arg0.seriesCombat = arg0.seriesCombat + 1
							end
						else
							arg0.seriesCombat = 0
						end

						if arg0.amuletOverFlag then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_over_count, 1)
						end

						arg0.splitFireIndex = arg0.fireIndex

						break
					end

					arg0.seriesCount = 1
					arg0.seriesCombat = 0

					break
				end
			end
		end
	end
end

function var0.checkEnemyFinal(arg0)
	if arg0:checkTargetScore() then
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.enemysList) do
			var0 = var0 + #iter1
		end

		if var0 == 0 then
			arg0._eventCall(LaunchBallGameScene.ENEMY_FINISH)

			return
		end
	end

	for iter2, iter3 in ipairs(arg0.enemysList) do
		if iter3 and #iter3 > 0 and iter3[#iter3]:getFinish() then
			arg0._eventCall(LaunchBallGameScene.ENEMY_FINISH)

			return
		end
	end
end

function var0.updateEnemyVo(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.enemysList) do
		for iter2 = 1, #iter1 do
			local var1 = iter1[iter2]:getColor()

			if not table.contains(var0, var1) then
				table.insert(var0, var1)

				if #var0 >= LaunchBallGameConst.color_total then
					LaunchBallGameVo.enemyColors = var0

					return
				end
			end
		end
	end

	LaunchBallGameVo.enemyColors = var0
end

function var0.updateGameResultSplitCount(arg0, arg1, arg2)
	LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_split_count, 1)

	if arg2 > 1 then
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_series_count, 1)
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_mix_count, 1)
	end

	if arg1 > 3 then
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_many_count, 1)
	end
end

function var0.checkSplit(arg0, arg1, arg2)
	local var0 = arg2[arg1]:getColor()
	local var1 = 1
	local var2 = {
		arg2[arg1]
	}
	local var3 = false
	local var4 = 0
	local var5 = 0

	if arg1 > 1 then
		for iter0 = arg1 - 1, 1, -1 do
			if arg2[iter0]:getColor() == var0 then
				table.insert(var2, arg2[iter0])

				var1 = var1 + 1
				var5 = var5 + 1
			else
				break
			end
		end
	end

	local var6

	if arg1 < #arg2 then
		for iter1 = arg1 + 1, #arg2 do
			if arg2[iter1]:getColor() == var0 then
				table.insert(var2, arg2[iter1])

				var1 = var1 + 1
				var4 = var4 + 1
			else
				var6 = arg2[iter1]

				break
			end
		end
	end

	if var1 >= 3 then
		var3 = true
	end

	if var1 >= 3 and not var3 then
		print("")
	end

	if var3 and var6 then
		var6:setSplitFlag(true)
	end

	if var3 then
		for iter2 = 1, #var2 do
			var2[iter2]:hit()
		end

		if arg0._eventCall then
			local var7 = LaunchBallGameVo.GetScore(var1, arg0.seriesCount, arg0.amuletOverFlag)

			arg0._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
				split = true,
				num = var7,
				count = var1
			})

			if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) and arg0.enemyStopTime and arg0.enemyStopTime > 0 then
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, var1)
			end
		end

		arg0:updateGameResultSplitCount(var1, arg0.seriesCount)

		if not var6 then
			arg0.seriesCount = 0
		end
	end

	return var1, var3
end

function var0.createPoints(arg0, arg1)
	local var0 = {}
	local var1 = 0
	local var2 = GetComponent(arg1, "EdgeCollider2D")

	for iter0 = 0, var2.points.Length - 1 do
		local var3 = var2.points[iter0]
		local var4 = Vector2(0, 0)
		local var5 = Vector2(0, 0)
		local var6 = 0
		local var7 = 0

		if iter0 >= 1 then
			local var8 = var2.points[iter0 - 1]
			local var9 = var2.points[iter0]

			var1 = var1 + math.sqrt(math.pow(var9.x - var8.x, 2) + math.pow(var9.y - var8.y, 2))
		end

		if iter0 < var2.points.Length - 1 then
			local var10 = var2.points[iter0]
			local var11 = var2.points[iter0 + 1]
			local var12 = math.atan(math.abs(var11.y - var10.y) / math.abs(var11.x - var10.x))

			var7 = math.atan2(var11.y - var10.y, var11.x - var10.x) * math.rad2Deg

			local var13 = var11.x > var10.x and 1 or -1
			local var14 = var11.y > var10.y and 1 or -1

			var5.x = var13
			var5.y = var14
			var4.x = math.cos(var12) * var13
			var4.y = math.sin(var12) * var14
		elseif iter0 == var2.points.Length - 1 then
			local var15 = var2.points[iter0 - 1]
			local var16 = var2.points[iter0]
			local var17 = math.atan(math.abs(var16.y - var15.y) / math.abs(var16.x - var15.x))

			var7 = math.atan2(var16.y - var15.y, var16.x - var15.x) * math.rad2Deg

			local var18 = var16.x > var15.x and 1 or -1
			local var19 = var16.y > var15.y and 1 or -1

			var5.x = var18
			var5.y = var19
			var4.x = math.cos(var17) * var18
			var4.y = math.sin(var17) * var19
		end

		table.insert(var0, {
			pos = var3,
			distance = var1,
			move = var4,
			direct = var5,
			angle = var7
		})
	end

	return var0
end

function var0.createEnemy(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0:getOrCreateEnemy()

	var0:setData(arg1, arg2)
	var0:setPoints(arg3)
	var0:setActive(true)
	var0:setSplitFlag(false)

	if arg5 then
		var0:setDistance(arg5)
	else
		var0:setDistance(0)
	end

	table.insert(arg4, var0)
	arg0:sortEnemys(arg4)

	return var0
end

function var0.createRandomEnemy(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg0:getEnemyDataByRule()

	if not var0 then
		return
	end

	local var1 = arg0:getOrCreateEnemy()
	local var2 = arg0:getEnemyBuff()

	var1:setData(arg1, var0)
	var1:setBuff(var2)
	var1:setPoints(arg2)
	var1:setActive(true)

	if arg4 and arg4 ~= 0 then
		var1:setPosIndex(arg4)
	elseif arg5 then
		var1:setDistance(arg5)
	end

	table.insert(arg3, var1)
	arg0:sortEnemys(arg3)

	return var1
end

function var0.getEnemyBuff(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.enemyBuffs.buffs do
		local var1 = arg0.enemyBuffs.buffs[iter0]
		local var2 = true

		if var1.type == LaunchBallGameConst.enemy_buff_back then
			if arg0:getEnemyByBuff(LaunchBallGameConst.enemy_buff_slow) then
				var2 = false
			end
		elseif var1.type == LaunchBallGameConst.enemy_buff_slow and arg0:getEnemyByBuff(LaunchBallGameConst.enemy_buff_back) then
			var2 = false
		end

		if var2 then
			local var3 = var1.rate
			local var4 = var3[1]

			if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
				if var1.type == LaunchBallGameConst.enemy_buff_slow then
					var4 = var4 + 2
				elseif var1.type == LaunchBallGameConst.enemy_buff_back then
					var4 = var4 + 2
				end
			end

			if var4 >= math.random(1, var3[2]) then
				table.insert(var0, var1.type)
			end
		end
	end

	if #var0 > 0 then
		return var0[math.random(1, #var0)]
	end

	return nil
end

function var0.getEnemyByBuff(arg0, arg1)
	for iter0 = 1, #arg0.enemysList do
		local var0 = arg0.pointsList[iter0]
		local var1 = arg0.enemysList[iter0]

		for iter1 = #var1, 1, -1 do
			local var2 = var1[iter1]

			if var2:getBuff() == arg1 then
				return var2
			end
		end
	end

	return nil
end

function var0.getOrCreateEnemy(arg0)
	local var0

	if #arg0.enemyPool > 0 then
		var0 = table.remove(arg0.enemyPool, 1)
	else
		local var1 = tf(instantiate(arg0._enemyTpl))

		setParent(var1, arg0._enemyContent)

		var0 = var16(var1)
	end

	return var0
end

function var0.sortEnemys(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		return arg0:getDistance() < arg1:getDistance()
	end)

	for iter0 = 1, #arg1 do
		arg1[iter0]:setLastLayer(iter0 - 1)
	end
end

function var0.returnEnemy(arg0, arg1)
	arg1:setActive(false)
	table.insert(arg0.enemyPool, arg1)
end

function var0.getEnemyDataByRule(arg0)
	if not arg0.currentEnemyRule then
		arg0.currentEnemyRule = arg0:getEnemyRule()
	end

	if #var1 > 0 then
		return arg0:getEnemyById(table.remove(var1, 1))
	end

	if arg0.currentEnemyRule then
		local var0

		if arg0.currentEnemyRule.single then
			var0 = arg0.currentEnemyRule.singleId
		else
			var0 = arg0.currentEnemyRule.enemys[math.random(1, #arg0.currentEnemyRule.enemys)]
		end

		arg0.currentEnemyRule.count = arg0.currentEnemyRule.count - 1

		if arg0.currentEnemyRule.count <= 0 then
			arg0.currentEnemyRule = nil
		end

		return arg0:getEnemyById(var0)
	end

	return nil
end

function var0.getEnemyById(arg0, arg1)
	for iter0 = 1, #arg0.enemyDatas do
		if arg0.enemyDatas[iter0].data.id == arg1 then
			return arg0.enemyDatas[iter0]
		end
	end

	print("找不到id = " .. arg1 .. "的怪物")

	return nil
end

function var0.checkEnemyRuleUpdate(arg0)
	local var0 = false

	for iter0 = 1, #arg0.rounds do
		if LaunchBallGameVo.gameStepTime >= arg0.rounds[iter0].time[2] then
			var0 = true
		end
	end

	if var0 then
		arg0:createRoundData()
	end
end

function var0.getEnemysInBounds(arg0, arg1, arg2)
	local var0 = arg0._enemyContent:InverseTransformPoint(arg1)
	local var1 = arg0._enemyContent:InverseTransformPoint(arg2)

	arg0.colliderTestTf.anchoredPosition = var1

	local var2 = {}

	for iter0 = 1, #arg0.enemysList do
		local var3 = arg0.pointsList[iter0]
		local var4 = arg0.enemysList[iter0]

		for iter1 = #var4, 1, -1 do
			local var5 = var4[iter1]:getTf().anchoredPosition

			if var5.x > var0.x and var5.x < var1.x and var5.y > var0.y and var5.y < var1.y then
				table.insert(var2, var4[iter1])
			end
		end
	end

	return var2
end

function var0.getEnemyRule(arg0)
	local var0
	local var1 = math.random(0, arg0.maxWeight)
	local var2

	for iter0 = 1, #arg0.rounds do
		if not var2 and var1 <= arg0.rounds[iter0].maxWeight then
			var2 = arg0.rounds[iter0].createId
		end
	end

	if var2 then
		if not arg0.enemyRule[var2] then
			print("create id not exit " .. var2)
		end

		local var3 = arg0.enemyRule[var2]
		local var4 = var3.id
		local var5 = var3.enemy_create.count
		local var6 = var3.enemy_create.enemys
		local var7 = var3.enemy_create.single
		local var8

		if var7 then
			var8 = var6[math.random(1, #var6)]
		end

		var0 = {
			id = var4,
			count = var5,
			enemys = var6,
			single = var7,
			singleId = var8
		}
	end

	return var0
end

function var0.createRoundData(arg0)
	local var0 = 0

	arg0.rounds = {}

	local var1 = LaunchBallGameVo.gameStepTime

	for iter0 = 1, #arg0.roundDatas do
		local var2 = arg0.roundDatas[iter0]
		local var3 = var2.weight
		local var4 = var2.time
		local var5 = var2.create_id

		if var1 >= var4[1] and var1 <= var4[2] then
			var0 = var0 + var3

			table.insert(arg0.rounds, {
				time = var4,
				weight = var3,
				maxWeight = var0,
				createId = var5
			})
		end
	end

	arg0.maxWeight = var0
end

function var0.checkAmulet(arg0, arg1)
	local var0 = arg1.tf.position

	arg0.fireIndex = arg1.fireIndex

	local var1 = arg1.color

	for iter0 = 1, #arg0.enemysList do
		local var2 = arg0.pointsList[iter0]
		local var3 = arg0.enemysList[iter0]

		for iter1 = #var3, 1, -1 do
			local var4 = var3[iter1]
			local var5, var6 = var3[iter1]:checkWorldInRect(var0)

			if var6 and var6 < var4 then
				arg1.overCount = arg1.overCount + 1
			end

			if var5 ~= 0 then
				arg0.amuletOverFlag = false

				if arg1.concentrate then
					if not var3[iter1]:getTimeRemove() then
						var3[iter1]:setTimeRemove()

						if arg0._eventCall then
							local var7 = LaunchBallGameVo.GetScore(1, 1)

							arg0._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
								num = var7
							})
						end

						if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) and arg0.enemyStopTime and arg0.enemyStopTime > 0 then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, 1)
						end
					end

					return false
				else
					local var8 = var4:getDistance()

					if var5 == 1 then
						var8 = var8 + var7
					else
						var8 = var8 - var7
					end

					if arg1.overCount >= 2 then
						arg0.amuletOverFlag = true
					end

					local var9 = arg0:getEnemyByColor(arg1.color, true)
					local var10 = arg0:createEnemy(iter0, var9, arg0.pointsList[iter0], arg0.enemysList[iter0], var8)

					var10:setSplitFlag(true)
					var10:playAnimation("Spawn")

					local var11 = arg0:getBackBuff()
					local var12 = arg1[LaunchBallGameConst.amulet_buff_back]

					if var11 or var12 then
						arg0:setBackTime(LaunchBallPlayerControl.buff_amulet_back_time, #var3, var9)
					end

					return true
				end
			end
		end
	end

	return false
end

function var0.checkPositionIn(arg0, arg1)
	for iter0 = 1, #arg0.enemysList do
		local var0 = arg0.pointsList[iter0]
		local var1 = arg0.enemysList[iter0]

		for iter1 = #var1, 1, -1 do
			local var2 = var1[iter1]

			if var1[iter1]:checkWorldInRect(arg1) ~= 0 then
				return var2
			end
		end
	end

	return false
end

function var0.checkWorldInEnemy(arg0, arg1)
	for iter0 = 1, #arg0.enemysList do
		local var0 = arg0.pointsList[iter0]
		local var1 = arg0.enemysList[iter0]

		for iter1 = #var1, 1, -1 do
			local var2 = var1[iter1]

			if var1[iter1]:checkWorldInCircle(arg1) then
				return true
			end
		end
	end

	return false
end

function var0.getBackBuff(arg0)
	local var0 = LaunchBallGameVo.buffs

	for iter0 = 1, #var0 do
		if var0[iter0].data.type == LaunchBallPlayerControl.buff_amulet_back then
			return true
		end
	end

	return false
end

function var0.getEnemyByColor(arg0, arg1, arg2)
	for iter0 = 1, #arg0.enemyDatas do
		if arg0.enemyDatas[iter0].data.color == arg1 and arg0.enemyDatas[iter0].data.player == arg2 then
			return arg0.enemyDatas[iter0]
		end
	end
end

function var0.setBackTime(arg0, arg1, arg2, arg3)
	arg0.backEnemyTime = arg1
	arg0.moveBackIndex = arg2
	arg0.backSpeed = arg3 or var9
end

function var0.eventCall(arg0, arg1, arg2)
	if arg1 == LaunchBallGameScene.PLAYING_CHANGE then
		-- block empty
	elseif arg1 == LaunchBallGameScene.FIRE_AMULET then
		-- block empty
	elseif arg1 == LaunchBallGameScene.SPLIT_ALL_ENEMYS then
		arg0.timeRemoveAll = arg2.time, arg2.effect
	elseif arg1 == LaunchBallGameScene.STOP_ENEMY_TIME then
		arg0.enemyStopTime = arg2.time

		arg0:stopEnemysAnim(true)
	elseif arg1 == LaunchBallGameScene.SLASH_ENEMY then
		local var0 = arg2.bound
	end
end

function var0.stopEnemysAnim(arg0, arg1)
	for iter0 = 1, #arg0.enemysList do
		local var0 = arg0.pointsList[iter0]
		local var1 = arg0.enemysList[iter0]

		for iter1 = #var1, 1, -1 do
			var1[iter1]:stopAnim(arg1)
		end
	end
end

function var0.press(arg0, arg1)
	if arg1 == KeyCode.J then
		-- block empty
	end
end

function var0.clear(arg0)
	return
end

return var0
