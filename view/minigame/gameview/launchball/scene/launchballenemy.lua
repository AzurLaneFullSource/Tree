local var0_0 = class("LaunchBallEnemy")
local var1_0 = {}
local var2_0 = 0.35
local var3_0 = 70
local var4_0 = 100
local var5_0 = 80
local var6_0 = 80
local var7_0 = 50
local var8_0 = {
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
local var9_0 = -300
local var10_0 = -150
local var11_0 = 0.5
local var12_0 = 500
local var13_0 = -500
local var14_0 = 10
local var15_0 = {
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

local function var16_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._animator = GetComponent(findTF(arg0_2._tf, "ad/anim"), typeof(Animator))
			arg0_2.angleTf = findTF(arg0_2._tf, "ad/angle")
			arg0_2.leftBoundPoints = {}

			local var0_2 = GetComponent(findTF(arg0_2._tf, "ad/angle/left"), typeof("UnityEngine.PolygonCollider2D"))

			for iter0_2 = 0, var0_2.points.Length - 1 do
				table.insert(arg0_2.leftBoundPoints, var0_2.points[iter0_2])
			end

			arg0_2.rightBoundPoints = {}

			local var1_2 = GetComponent(findTF(arg0_2._tf, "ad/angle/right"), typeof("UnityEngine.PolygonCollider2D"))

			for iter1_2 = 0, var1_2.points.Length - 1 do
				table.insert(arg0_2.rightBoundPoints, var1_2.points[iter1_2])
			end

			arg0_2.localRotation = Vector3(0, 0, 0)
			arg0_2.circlePos = findTF(arg0_2._tf, "ad/angle/circle").anchoredPosition

			if not arg0_2.buffIcon then
				arg0_2.buffIcon = findTF(arg0_2._tf, "ad/iconEffect")
			end

			arg0_2._effectTf = findTF(arg0_2._tf, "ad/effect")
			arg0_2._playEffects = {}
		end,
		setData = function(arg0_3, arg1_3, arg2_3)
			arg0_3:clear()

			arg0_3.enemyIndex = arg1_3
			arg0_3._animator.runtimeAnimatorController = arg2_3.animator
			arg0_3.data = arg2_3
			arg0_3.hp = arg2_3.data.hp
			arg0_3.overSplitFlag = false

			for iter0_3 = 0, arg0_3.buffIcon.childCount - 1 do
				local var0_3 = arg0_3.buffIcon:GetChild(iter0_3)

				setActive(var0_3, false)
			end

			for iter1_3 = #arg0_3._playEffects, 1, -1 do
				setActive(arg0_3._playEffects[iter1_3].tf, false)
				table.remove(arg0_3._playEffects, iter1_3)
			end

			arg0_3:stopAnim(false)
		end,
		setBuff = function(arg0_4, arg1_4)
			arg0_4.buffType = arg1_4

			if arg0_4.buffType then
				local var0_4 = LaunchBallGameConst.enemy_buff_data[arg0_4.buffType].tpl

				for iter0_4 = 0, arg0_4.buffIcon.childCount - 1 do
					local var1_4 = arg0_4.buffIcon:GetChild(iter0_4)

					setActive(var1_4, var1_4.name == var0_4)
				end
			else
				for iter1_4 = 0, arg0_4.buffIcon.childCount - 1 do
					local var2_4 = arg0_4.buffIcon:GetChild(iter1_4)

					setActive(var2_4, false)
				end
			end
		end,
		getBuff = function(arg0_5)
			return arg0_5.buffType
		end,
		setPoints = function(arg0_6, arg1_6)
			arg0_6.points = arg1_6
		end,
		hit = function(arg0_7)
			if arg0_7.buffType and arg0_7.buffType == LaunchBallGameConst.enemy_buff_streng then
				arg0_7:setBuff(nil)

				return
			end

			arg0_7.hp = arg0_7.hp - 1

			if arg0_7.hp <= 0 then
				arg0_7:setTimeRemove()
			end
		end,
		getTf = function(arg0_8)
			return arg0_8._tf
		end,
		playAnimation = function(arg0_9, arg1_9)
			arg0_9._animator:Play(arg1_9)
		end,
		setActive = function(arg0_10, arg1_10)
			setActive(arg0_10._tf, arg1_10)
		end,
		getColor = function(arg0_11)
			return arg0_11.data.data.color
		end,
		getSplitFlag = function(arg0_12)
			return arg0_12.splitFlag
		end,
		setSplitFlag = function(arg0_13, arg1_13)
			arg0_13.splitFlag = arg1_13
		end,
		step = function(arg0_14)
			if arg0_14.timeToRemove and arg0_14.timeToRemove > 0 then
				arg0_14.timeToRemove = arg0_14.timeToRemove - LaunchBallGameVo.deltaTime

				if arg0_14.timeToRemove <= 0 then
					arg0_14.timeToRemove = nil
					arg0_14.removeFlag = true
				end
			end

			if #arg0_14._playEffects > 0 then
				for iter0_14 = #arg0_14._playEffects, 1, -1 do
					local var0_14 = arg0_14._playEffects[iter0_14]

					if var0_14.time then
						var0_14.time = var0_14.time - LaunchBallGameVo.deltaTime
					end

					if var0_14.time and var0_14.time <= 0 then
						setActive(var0_14.tf, false)
						table.remove(arg0_14._playEffects, iter0_14)
					end
				end
			end
		end,
		move = function(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
			if arg1_15 == 0 then
				return
			end

			var0_0.moveCount = var0_0.moveCount + 1
			arg0_15.distance = arg0_15.distance + arg1_15

			if arg0_15.distance < 0 then
				arg0_15.distance = 0
			end

			if arg2_15 and arg3_15 and arg4_15 then
				arg0_15._tf.anchoredPosition = arg2_15
				arg0_15.pointIndex = arg3_15
				arg0_15.localRotation = arg4_15
				arg0_15.angleTf.localEulerAngles = arg0_15.localRotation
			else
				local var0_15 = arg0_15:getPosByDistance(arg0_15.distance)
				local var1_15 = arg0_15._tf.anchoredPosition

				var1_15.x = var0_15.x
				var1_15.y = var0_15.y
				arg0_15._tf.anchoredPosition = var1_15
				arg0_15.pointIndex = var0_15.index
				arg0_15.localRotation.z = arg0_15.points[arg0_15.pointIndex].angle
				arg0_15.angleTf.localEulerAngles = arg0_15.localRotation
			end
		end,
		getPosition = function(arg0_16)
			return arg0_16._tf.anchoredPosition
		end,
		getPointIndex = function(arg0_17)
			return arg0_17.pointIndex
		end,
		getLocalRotation = function(arg0_18)
			return arg0_18.localRotation
		end,
		stopAnim = function(arg0_19, arg1_19)
			if arg1_19 then
				arg0_19._animator.speed = 0
			else
				arg0_19._animator.speed = 1
			end
		end,
		checkWorldInCircle = function(arg0_20, arg1_20)
			local var0_20 = arg0_20.angleTf:InverseTransformPoint(arg1_20)

			if math.abs(var0_20.x - arg0_20.circlePos.x) >= 150 or math.abs(var0_20.y - arg0_20.circlePos.y) >= var5_0 * 2 then
				return false
			end

			local var1_20 = 0

			if math.sqrt(math.pow(var0_20.x - arg0_20.circlePos.x, 2) + math.pow(var0_20.y - arg0_20.circlePos.y, 2)) < var5_0 then
				return true
			end

			return false
		end,
		checkWorldInRect = function(arg0_21, arg1_21)
			local var0_21 = arg0_21.angleTf:InverseTransformPoint(arg1_21)
			local var1_21 = 0
			local var2_21 = math.sqrt(math.pow(var0_21.x - arg0_21.circlePos.x, 2) + math.pow(var0_21.y - arg0_21.circlePos.y, 2))

			if var2_21 > var3_0 then
				return var1_21, nil
			end

			if LaunchBallGameVo.PointInRect(var0_21, arg0_21.leftBoundPoints[1], arg0_21.leftBoundPoints[2], arg0_21.leftBoundPoints[3], arg0_21.leftBoundPoints[4]) then
				var1_21 = -1
			elseif LaunchBallGameVo.PointInRect(var0_21, arg0_21.rightBoundPoints[1], arg0_21.rightBoundPoints[2], arg0_21.rightBoundPoints[3], arg0_21.rightBoundPoints[4]) then
				var1_21 = 1
			end

			return var1_21, var2_21
		end,
		getPosByDistance = function(arg0_22, arg1_22)
			local var0_22 = math.floor(arg1_22 * 2)

			if var0_0.EnemyDistanceData[arg0_22.enemyIndex][var0_22] then
				return var0_0.EnemyDistanceData[arg0_22.enemyIndex][var0_22]
			end

			local var1_22 = var0_22 / 2

			if not arg0_22.distancePosResult then
				arg0_22.distancePosResult = Vector2(0, 0)
			end

			local var2_22 = 1
			local var3_22 = 0

			for iter0_22 = 1, #arg0_22.points do
				local var4_22 = arg0_22.points[iter0_22]

				if var1_22 >= var4_22.distance then
					var2_22 = iter0_22

					if iter0_22 < #arg0_22.points then
						var3_22 = var1_22 - var4_22.distance
						arg0_22.distancePosResult.x = var4_22.pos.x
						arg0_22.distancePosResult.y = var4_22.pos.y
					else
						arg0_22.distancePosResult.x = var4_22.pos.x
						arg0_22.distancePosResult.y = var4_22.pos.y
						var3_22 = 0
					end
				else
					break
				end
			end

			if var3_22 ~= 0 then
				local var5_22 = arg0_22.points[var2_22].move

				arg0_22.distancePosResult.x = arg0_22.distancePosResult.x + var5_22.x * var3_22
				arg0_22.distancePosResult.y = arg0_22.distancePosResult.y + var5_22.y * var3_22
			end

			local var6_22 = {
				x = arg0_22.distancePosResult.x,
				y = arg0_22.distancePosResult.y,
				index = var2_22
			}

			var0_0.EnemyDistanceData[arg0_22.enemyIndex][var0_22] = var6_22

			return var6_22
		end,
		setTimeRemove = function(arg0_23)
			if arg0_23.hp > 0 then
				arg0_23.hp = 0
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_ENEMY_REMOVE)

			if arg0_23:getBuff(LaunchBallGameConst.enemy_buff_boom) then
				local var0_23 = arg0_23:getColor()
				local var1_23 = var15_0[var0_23].anim_name

				arg0_23:playEffectAnim("Bomb", var1_23, 0.2)
			end

			arg0_23:stopAnim(false)
			arg0_23:playAnimation("Remove")

			arg0_23.timeToRemove = var2_0
		end,
		playEffectAnim = function(arg0_24, arg1_24, arg2_24, arg3_24)
			local var0_24 = findTF(arg0_24._effectTf, arg1_24)

			setActive(var0_24, true)
			GetComponent(var0_24, typeof(Animator)):Play(arg2_24)
			table.insert(arg0_24._playEffects, {
				tf = var0_24,
				time = arg3_24
			})
		end,
		getTimeRemove = function(arg0_25)
			return arg0_25.timeToRemove
		end,
		setPosIndex = function(arg0_26, arg1_26)
			arg0_26._tf.anchoredPosition = arg0_26.points[arg1_26].pos
			arg0_26.pointIndex = arg1_26
			arg0_26.distance = arg0_26.points[arg1_26].distance
		end,
		setDistance = function(arg0_27, arg1_27)
			arg0_27.distance = arg1_27
			arg0_27._tf.anchoredPosition = arg0_27:getPosByDistance(arg0_27.distance)
		end,
		getDistance = function(arg0_28)
			return arg0_28.distance
		end,
		getRemoveFlag = function(arg0_29)
			return arg0_29.removeFlag
		end,
		setLastLayer = function(arg0_30, arg1_30)
			return arg0_30._tf:SetSiblingIndex(arg1_30)
		end,
		getFinish = function(arg0_31)
			return arg0_31.distance >= arg0_31.points[#arg0_31.points].distance
		end,
		clear = function(arg0_32)
			arg0_32.finalFlag = false
			arg0_32.removeFlag = false
			arg0_32.timeToRemove = nil
			arg0_32.buffType = nil
		end
	}

	var0_1:ctor()

	return var0_1
end

var0_0.EnemyDistanceData = {}

function var0_0.Ctor(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	arg0_33._enemyContent = arg1_33
	arg0_33._lineContent = arg2_33
	arg0_33._tpl = arg3_33
	arg0_33._eventCall = arg4_33
	arg0_33._enemyTpl = findTF(arg0_33._tpl, "Enemy")
	arg0_33.enemyDatas = {}

	for iter0_33, iter1_33 in pairs(LaunchBallGameConst.enemy_data) do
		local var0_33 = LoadAny(LaunchBallGameVo.ui_atlas, iter1_33.name, typeof(RuntimeAnimatorController))

		table.insert(arg0_33.enemyDatas, {
			animator = var0_33,
			data = iter1_33
		})
	end

	arg0_33.enemyRule = Clone(LaunchBallGameConst.enemy_create_rule)
	arg0_33.enemysList = {}
	arg0_33.enemyPool = {}
	arg0_33.colliderTestTf = findTF(arg0_33._enemyContent, "colliderTest")

	setActive(arg0_33.colliderTestTf, false)
end

function var0_0.start(arg0_34)
	arg0_34.moveSpeed = LaunchBallGameVo.gameRoundData.speed
	var0_0.EnemyDistanceData = {}
	arg0_34.gameRoundData = LaunchBallGameVo.gameRoundData
	arg0_34._enemyContent.sizeDelta = LaunchBallGameConst.enemy_round_bound[arg0_34.gameRoundData.round_bound]
	arg0_34.roundDatas = Clone(LaunchBallGameConst.round_enemy[arg0_34.gameRoundData.round_enemy])
	arg0_34.lineData = Clone(LaunchBallGameConst.map_data[arg0_34.gameRoundData.map])
	arg0_34.enemyBuffs = Clone(LaunchBallGameConst.enemy_round_buff[arg0_34.gameRoundData.enemy_buff])

	arg0_34:createRoundData()

	arg0_34.currentEnemyRule = arg0_34:getEnemyRule()

	if arg0_34.lineTf then
		setActive(arg0_34.lineTf, false)
	end

	arg0_34.lineTf = findTF(arg0_34._lineContent, arg0_34.lineData.line)

	setActive(arg0_34.lineTf, true)

	for iter0_34, iter1_34 in ipairs(arg0_34.enemysList) do
		for iter2_34 = #iter1_34, 1, -1 do
			arg0_34:returnEnemy(table.remove(iter1_34, iter2_34))
		end
	end

	arg0_34.pointsList = {}
	arg0_34.enemysList = {}

	local var0_34 = findTF(arg0_34.lineTf, "ad/points")

	if var0_34 then
		local var1_34 = arg0_34:createPoints(var0_34)

		table.insert(arg0_34.pointsList, var1_34)
		table.insert(arg0_34.enemysList, {})

		var0_0.EnemyDistanceData[1] = {}
	end

	local var2_34 = findTF(arg0_34.lineTf, "ad/points1")

	if var2_34 then
		local var3_34 = arg0_34:createPoints(var2_34)

		table.insert(arg0_34.pointsList, var3_34)
		table.insert(arg0_34.enemysList, {})

		var0_0.EnemyDistanceData[2] = {}
	end

	for iter3_34 = 1, #arg0_34.pointsList do
		arg0_34:createRandomEnemy(iter3_34, arg0_34.pointsList[iter3_34], arg0_34.enemysList[iter3_34], 1, 0, true)
	end

	arg0_34.backEnemyFlag = false
	arg0_34.backEnemyTime = nil
	arg0_34.seriesCount = 1
	arg0_34.lastPointDistance = nil
end

var0_0.moveCount = 0

function var0_0.step(arg0_35)
	var0_0.moveCount = 0

	arg0_35:checkEnemyRuleUpdate()
	arg0_35:checkEnemyDataUpdate()
	arg0_35:checkCreateEnemy()
	arg0_35:checkRemoveEnemy()
	arg0_35:moveEnmey()
	arg0_35:checkEnemyQuick()
	arg0_35:checkEnemyBack()
	arg0_35:updateEnemyRemoveFlag()
	arg0_35:checkEnemySplit()
	arg0_35:updateEnemyVo()
	arg0_35:checkEnemyFinal()
	arg0_35:updateEnemyData()
end

function var0_0.updateEnemyData(arg0_36)
	if not arg0_36.lastPointDistance then
		arg0_36.lastPointDistance = {}

		for iter0_36 = 1, #arg0_36.pointsList do
			local var0_36 = arg0_36.pointsList[iter0_36]

			table.insert(arg0_36.lastPointDistance, var0_36[#var0_36].distance)
		end
	end

	local var1_36 = {}
	local var2_36 = 0

	for iter1_36 = 1, #arg0_36.enemysList do
		local var3_36 = arg0_36.enemysList[iter1_36]

		if var3_36 and #var3_36 > 0 then
			local var4_36 = var3_36[#var3_36]:getDistance()

			table.insert(var1_36, math.floor(var4_36 / arg0_36.lastPointDistance[iter1_36] * 10))
		end
	end

	LaunchBallGameVo.enemyToEndRate = var1_36
end

function var0_0.checkEnemyDataUpdate(arg0_37)
	if arg0_37.currentEnemyRule == nil then
		arg0_37.currentEnemyRule = arg0_37:getEnemyRule()
	end
end

function var0_0.checkTargetScore(arg0_38)
	if LaunchBallGameVo.gameRoundData.target and LaunchBallGameVo.scoreNum >= LaunchBallGameVo.gameRoundData.target then
		return true
	end

	return false
end

function var0_0.checkCreateEnemy(arg0_39)
	if arg0_39:checkTargetScore() then
		return
	end

	local var0_39 = 1

	for iter0_39 = 1, #arg0_39.enemysList do
		local var1_39 = arg0_39.enemysList[iter0_39]
		local var2_39 = arg0_39.pointsList[iter0_39]

		if #var1_39 > 0 then
			if var1_39[1]:getDistance() > var6_0 then
				arg0_39:createRandomEnemy(iter0_39, var2_39, var1_39, 1, 0, true)

				break
			end
		else
			arg0_39:createRandomEnemy(iter0_39, var2_39, var1_39, 1, 0, true)

			break
		end
	end
end

function var0_0.checkRemoveEnemy(arg0_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.enemysList) do
		local var0_40 = false

		for iter2_40 = #iter1_40, 1, -1 do
			iter1_40[iter2_40]:step()

			if iter1_40[iter2_40]:getRemoveFlag() then
				local var1_40 = iter1_40[iter2_40]:getBuff()

				if var1_40 then
					arg0_40:appearEnemyBuff(var1_40, iter2_40, iter1_40[iter2_40], iter1_40)
				end

				arg0_40:returnEnemy(table.remove(iter1_40, iter2_40))

				local var2_40 = true
			end
		end
	end

	if arg0_40.timeRemoveAll and arg0_40.timeRemoveAll > 0 then
		arg0_40.timeRemoveAll = arg0_40.timeRemoveAll - LaunchBallGameVo.deltaTime

		if arg0_40.timeRemoveAll <= 0 then
			local var3_40 = 0

			for iter3_40, iter4_40 in ipairs(arg0_40.enemysList) do
				for iter5_40 = #iter4_40, 1, -1 do
					local var4_40 = iter4_40[iter5_40]

					if not var4_40:getRemoveFlag() then
						var4_40:setTimeRemove()

						var3_40 = var3_40 + 1

						local var5_40 = LaunchBallGameVo.GetScore(1, 1)

						arg0_40._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
							num = var5_40
						})
					end
				end
			end

			LaunchBallGameVo.UpdateGameResultData(LaunchBallGameVo.result_skill_count, var3_40)

			arg0_40.timeRemoveAll = nil
		end
	end
end

function var0_0.appearEnemyBuff(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = LaunchBallGameConst.enemy_buff_data[arg1_41]

	if arg1_41 == LaunchBallGameConst.enemy_buff_slow then
		arg0_41.slowTime = var0_41.time

		if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
			arg0_41.slowTime = arg0_41.slowTime * 1.5

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)

			if arg0_41.enemyStopTime and arg0_41.enemyStopTime > 0 then
				arg0_41.enemyStopTime = arg0_41.enemyStopTime + 3
			end
		end
	elseif arg1_41 == LaunchBallGameConst.enemy_buff_back then
		arg0_41.backEnemyTime = var0_41.time
		arg0_41.backSpeed = var10_0
		arg0_41.moveBackIndex = #arg4_41

		if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
			arg0_41.backEnemyTime = arg0_41.backEnemyTime * 1.3

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_use_pass_skill, 1)
		end
	elseif arg1_41 == LaunchBallGameConst.enemy_buff_boom then
		local var1_41 = arg3_41:getDistance()
		local var2_41 = var0_41.distance

		for iter0_41 = 1, #arg4_41 do
			if not arg4_41[iter0_41]:getRemoveFlag() and var2_41 >= math.abs(arg4_41[iter0_41]:getDistance() - var1_41) then
				arg4_41[iter0_41]:setTimeRemove()

				local var3_41 = LaunchBallGameVo.GetScore(1, 1)

				arg0_41._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
					num = var3_41
				})
			end
		end
	elseif arg1_41 == LaunchBallGameConst.enemy_buff_concentrate then
		arg0_41._eventCall(LaunchBallGameScene.CONCENTRATE_TRIGGER, var0_41)
	end
end

function var0_0.moveEnmey(arg0_42)
	local var0_42

	if arg0_42.enemyStopTime and arg0_42.enemyStopTime > 0 then
		arg0_42.enemyStopTime = arg0_42.enemyStopTime - LaunchBallGameVo.deltaTime

		if arg0_42.enemyStopTime <= 0 then
			arg0_42.enemyStopTime = nil

			arg0_42:stopEnemysAnim(false)
		end

		LaunchBallGameVo.enemyStopTime = arg0_42.enemyStopTime
	end

	if arg0_42.enemyStopTime and arg0_42.enemyStopTime > 0 then
		return
	end

	if arg0_42.backEnemyTime and arg0_42.backEnemyTime > 0 then
		arg0_42.backEnemyTime = arg0_42.backEnemyTime - LaunchBallGameVo.deltaTime

		if arg0_42.backEnemyTime <= 0 then
			arg0_42.backEnemyTime = nil
		end

		var0_42 = arg0_42.backSpeed * LaunchBallGameVo.deltaTime
	else
		var0_42 = arg0_42.moveSpeed * LaunchBallGameVo.deltaTime
	end

	if arg0_42.slowTime and arg0_42.slowTime > 0 then
		var0_42 = var0_42 / 3
		arg0_42.slowTime = arg0_42.slowTime - LaunchBallGameVo.deltaTime

		if arg0_42.slowTime < 0 then
			arg0_42.slowTime = nil
		end
	end

	local var1_42 = {}

	for iter0_42, iter1_42 in ipairs(arg0_42.enemysList) do
		local var2_42 = 0

		if var0_42 > 0 then
			for iter2_42 = 1, #iter1_42 do
				local var3_42 = false

				if iter2_42 < #iter1_42 and iter1_42[iter2_42]:getDistance() < var6_0 and iter1_42[iter2_42 + 1]:getDistance() < var6_0 then
					var3_42 = true
				end

				if iter2_42 > 1 and var2_42 == 0 then
					if iter1_42[iter2_42]:getDistance() - iter1_42[iter2_42 - 1]:getDistance() > var6_0 then
						var2_42 = iter2_42
						var3_42 = true
					elseif iter1_42[iter2_42]:getRemoveFlag() then
						var2_42 = iter2_42
						var3_42 = true
					end
				elseif var2_42 ~= 0 and var2_42 <= iter2_42 then
					var3_42 = true
				end

				if not var3_42 then
					iter1_42[iter2_42]:move(var0_42)
				end
			end
		end

		if var0_42 < 0 then
			for iter3_42 = #iter1_42, 1, -1 do
				local var4_42 = false

				if iter3_42 <= arg0_42.moveBackIndex and var2_42 == 0 then
					if iter3_42 > 1 and iter1_42[iter3_42]:getDistance() - iter1_42[iter3_42 - 1]:getDistance() > var6_0 + var14_0 then
						var2_42 = iter3_42 - 1
					end
				else
					var4_42 = var2_42 ~= 0 and iter3_42 <= var2_42 and true or true
				end

				if not var4_42 then
					iter1_42[iter3_42]:move(var0_42)
				end
			end
		end
	end
end

function var0_0.checkEnemyQuick(arg0_43)
	if arg0_43.backFlag then
		return
	end

	arg0_43.quickFlag = false

	for iter0_43, iter1_43 in ipairs(arg0_43.enemysList) do
		local var0_43 = 0

		for iter2_43 = 1, #iter1_43 do
			local var1_43 = iter1_43[iter2_43]

			if iter2_43 <= #iter1_43 - 1 then
				local var2_43 = iter1_43[iter2_43 + 1]

				if var2_43:getDistance() > var6_0 and var2_43:getDistance() - var1_43:getDistance() < var6_0 - var14_0 then
					var0_43 = iter2_43 + 1
					arg0_43.quickFlag = true

					break
				end
			end
		end

		if var0_43 ~= 0 then
			for iter3_43 = 1, #iter1_43 do
				if var0_43 <= iter3_43 then
					local var3_43 = iter1_43[iter3_43 - 1]

					if iter1_43[iter3_43]:getDistance() - var3_43:getDistance() < var6_0 - var14_0 then
						iter1_43[iter3_43]:move(var12_0 * LaunchBallGameVo.deltaTime)
					else
						break
					end
				end
			end
		end
	end
end

function var0_0.checkEnemyBack(arg0_44)
	arg0_44.backFlag = false

	if not arg0_44.quickFlag then
		for iter0_44, iter1_44 in ipairs(arg0_44.enemysList) do
			local var0_44 = 0

			for iter2_44 = 1, #iter1_44 do
				if iter2_44 > 1 and var0_44 == 0 and iter1_44[iter2_44]:getDistance() - iter1_44[iter2_44 - 1]:getDistance() > var6_0 + var14_0 and iter1_44[iter2_44]:getSplitFlag() and iter1_44[iter2_44]:getColor() == iter1_44[iter2_44 - 1]:getColor() then
					var0_44 = iter2_44

					if not arg0_44.backEnemyFlag then
						arg0_44.backEnemyFlag = true
					end
				end
			end

			if var0_44 ~= 0 then
				arg0_44.backFlag = true
				arg0_44.moveBackIndex = 0

				for iter3_44 = 1, #iter1_44 do
					if iter3_44 == var0_44 then
						arg0_44.moveBackIndex = iter3_44

						iter1_44[iter3_44]:move(var13_0 * LaunchBallGameVo.deltaTime)
					elseif var0_44 < iter3_44 then
						if iter1_44[iter3_44]:getDistance() - iter1_44[iter3_44 - 1]:getDistance() < var6_0 + var14_0 then
							iter1_44[iter3_44]:move(var13_0 * LaunchBallGameVo.deltaTime)

							arg0_44.moveBackIndex = iter3_44
						else
							break
						end
					end
				end
			end
		end
	end

	if arg0_44.backFlag and arg0_44.backEnemyFlag then
		arg0_44.backEnemyFlag = false
		arg0_44.backEnemyTime = var11_0
		arg0_44.backSpeed = var9_0
	end
end

function var0_0.updateEnemyRemoveFlag(arg0_45)
	arg0_45.enemyTimeRemoveFlag = false

	for iter0_45, iter1_45 in ipairs(arg0_45.enemysList) do
		local var0_45 = 0

		for iter2_45 = 1, #iter1_45 do
			if iter1_45[iter2_45]:getTimeRemove() then
				arg0_45.enemyTimeRemoveFlag = true
			end
		end
	end
end

function var0_0.checkEnemySplit(arg0_46)
	if not arg0_46.enemyTimeRemoveFlag and not arg0_46.backFlag and not arg0_46.quickFlag and not arg0_46.backEnemyFlag then
		for iter0_46, iter1_46 in ipairs(arg0_46.enemysList) do
			local var0_46 = 0

			for iter2_46 = 1, #iter1_46 do
				local var1_46 = iter1_46[iter2_46]

				if var1_46:getSplitFlag() then
					local var2_46 = iter2_46
					local var3_46, var4_46, var5_46 = arg0_46:checkSplit(var2_46, iter1_46)

					var1_46:setSplitFlag(false)

					if var3_46 >= 3 or var4_46 then
						arg0_46.seriesCount = arg0_46.seriesCount + 1

						if arg0_46.splitFireIndex and arg0_46.splitFireIndex + 1 >= arg0_46.fireIndex then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_series_count, 1)

							if not arg0_46.seriesCombat then
								arg0_46.seriesCombat = 1
							else
								arg0_46.seriesCombat = arg0_46.seriesCombat + 1
							end
						else
							arg0_46.seriesCombat = 0
						end

						if arg0_46.amuletOverFlag then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_over_count, 1)
						end

						arg0_46.splitFireIndex = arg0_46.fireIndex

						break
					end

					arg0_46.seriesCount = 1
					arg0_46.seriesCombat = 0

					break
				end
			end
		end
	end
end

function var0_0.checkEnemyFinal(arg0_47)
	if arg0_47:checkTargetScore() then
		local var0_47 = 0

		for iter0_47, iter1_47 in ipairs(arg0_47.enemysList) do
			var0_47 = var0_47 + #iter1_47
		end

		if var0_47 == 0 then
			arg0_47._eventCall(LaunchBallGameScene.ENEMY_FINISH)

			return
		end
	end

	for iter2_47, iter3_47 in ipairs(arg0_47.enemysList) do
		if iter3_47 and #iter3_47 > 0 and iter3_47[#iter3_47]:getFinish() then
			arg0_47._eventCall(LaunchBallGameScene.ENEMY_FINISH)

			return
		end
	end
end

function var0_0.updateEnemyVo(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs(arg0_48.enemysList) do
		for iter2_48 = 1, #iter1_48 do
			local var1_48 = iter1_48[iter2_48]:getColor()

			if not table.contains(var0_48, var1_48) then
				table.insert(var0_48, var1_48)

				if #var0_48 >= LaunchBallGameConst.color_total then
					LaunchBallGameVo.enemyColors = var0_48

					return
				end
			end
		end
	end

	LaunchBallGameVo.enemyColors = var0_48
end

function var0_0.updateGameResultSplitCount(arg0_49, arg1_49, arg2_49)
	LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_split_count, 1)

	if arg2_49 > 1 then
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_series_count, 1)
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_mix_count, 1)
	end

	if arg1_49 > 3 then
		LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_many_count, 1)
	end
end

function var0_0.checkSplit(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg2_50[arg1_50]:getColor()
	local var1_50 = 1
	local var2_50 = {
		arg2_50[arg1_50]
	}
	local var3_50 = false
	local var4_50 = 0
	local var5_50 = 0

	if arg1_50 > 1 then
		for iter0_50 = arg1_50 - 1, 1, -1 do
			if arg2_50[iter0_50]:getColor() == var0_50 then
				table.insert(var2_50, arg2_50[iter0_50])

				var1_50 = var1_50 + 1
				var5_50 = var5_50 + 1
			else
				break
			end
		end
	end

	local var6_50

	if arg1_50 < #arg2_50 then
		for iter1_50 = arg1_50 + 1, #arg2_50 do
			if arg2_50[iter1_50]:getColor() == var0_50 then
				table.insert(var2_50, arg2_50[iter1_50])

				var1_50 = var1_50 + 1
				var4_50 = var4_50 + 1
			else
				var6_50 = arg2_50[iter1_50]

				break
			end
		end
	end

	if var1_50 >= 3 then
		var3_50 = true
	end

	if var1_50 >= 3 and not var3_50 then
		print("")
	end

	if var3_50 and var6_50 then
		var6_50:setSplitFlag(true)
	end

	if var3_50 then
		for iter2_50 = 1, #var2_50 do
			var2_50[iter2_50]:hit()
		end

		if arg0_50._eventCall then
			local var7_50 = LaunchBallGameVo.GetScore(var1_50, arg0_50.seriesCount, arg0_50.amuletOverFlag)

			arg0_50._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
				split = true,
				num = var7_50,
				count = var1_50
			})

			if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) and arg0_50.enemyStopTime and arg0_50.enemyStopTime > 0 then
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, var1_50)
			end
		end

		arg0_50:updateGameResultSplitCount(var1_50, arg0_50.seriesCount)

		if not var6_50 then
			arg0_50.seriesCount = 0
		end
	end

	return var1_50, var3_50
end

function var0_0.createPoints(arg0_51, arg1_51)
	local var0_51 = {}
	local var1_51 = 0
	local var2_51 = GetComponent(arg1_51, "EdgeCollider2D")

	for iter0_51 = 0, var2_51.points.Length - 1 do
		local var3_51 = var2_51.points[iter0_51]
		local var4_51 = Vector2(0, 0)
		local var5_51 = Vector2(0, 0)
		local var6_51 = 0
		local var7_51 = 0

		if iter0_51 >= 1 then
			local var8_51 = var2_51.points[iter0_51 - 1]
			local var9_51 = var2_51.points[iter0_51]

			var1_51 = var1_51 + math.sqrt(math.pow(var9_51.x - var8_51.x, 2) + math.pow(var9_51.y - var8_51.y, 2))
		end

		if iter0_51 < var2_51.points.Length - 1 then
			local var10_51 = var2_51.points[iter0_51]
			local var11_51 = var2_51.points[iter0_51 + 1]
			local var12_51 = math.atan(math.abs(var11_51.y - var10_51.y) / math.abs(var11_51.x - var10_51.x))

			var7_51 = math.atan2(var11_51.y - var10_51.y, var11_51.x - var10_51.x) * math.rad2Deg

			local var13_51 = var11_51.x > var10_51.x and 1 or -1
			local var14_51 = var11_51.y > var10_51.y and 1 or -1

			var5_51.x = var13_51
			var5_51.y = var14_51
			var4_51.x = math.cos(var12_51) * var13_51
			var4_51.y = math.sin(var12_51) * var14_51
		elseif iter0_51 == var2_51.points.Length - 1 then
			local var15_51 = var2_51.points[iter0_51 - 1]
			local var16_51 = var2_51.points[iter0_51]
			local var17_51 = math.atan(math.abs(var16_51.y - var15_51.y) / math.abs(var16_51.x - var15_51.x))

			var7_51 = math.atan2(var16_51.y - var15_51.y, var16_51.x - var15_51.x) * math.rad2Deg

			local var18_51 = var16_51.x > var15_51.x and 1 or -1
			local var19_51 = var16_51.y > var15_51.y and 1 or -1

			var5_51.x = var18_51
			var5_51.y = var19_51
			var4_51.x = math.cos(var17_51) * var18_51
			var4_51.y = math.sin(var17_51) * var19_51
		end

		table.insert(var0_51, {
			pos = var3_51,
			distance = var1_51,
			move = var4_51,
			direct = var5_51,
			angle = var7_51
		})
	end

	return var0_51
end

function var0_0.createEnemy(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52, arg5_52)
	local var0_52 = arg0_52:getOrCreateEnemy()

	var0_52:setData(arg1_52, arg2_52)
	var0_52:setPoints(arg3_52)
	var0_52:setActive(true)
	var0_52:setSplitFlag(false)

	if arg5_52 then
		var0_52:setDistance(arg5_52)
	else
		var0_52:setDistance(0)
	end

	table.insert(arg4_52, var0_52)
	arg0_52:sortEnemys(arg4_52)

	return var0_52
end

function var0_0.createRandomEnemy(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53, arg5_53, arg6_53)
	local var0_53 = arg0_53:getEnemyDataByRule()

	if not var0_53 then
		return
	end

	local var1_53 = arg0_53:getOrCreateEnemy()
	local var2_53 = arg0_53:getEnemyBuff()

	var1_53:setData(arg1_53, var0_53)
	var1_53:setBuff(var2_53)
	var1_53:setPoints(arg2_53)
	var1_53:setActive(true)

	if arg4_53 and arg4_53 ~= 0 then
		var1_53:setPosIndex(arg4_53)
	elseif arg5_53 then
		var1_53:setDistance(arg5_53)
	end

	table.insert(arg3_53, var1_53)
	arg0_53:sortEnemys(arg3_53)

	return var1_53
end

function var0_0.getEnemyBuff(arg0_54)
	local var0_54 = {}

	for iter0_54 = 1, #arg0_54.enemyBuffs.buffs do
		local var1_54 = arg0_54.enemyBuffs.buffs[iter0_54]
		local var2_54 = true

		if var1_54.type == LaunchBallGameConst.enemy_buff_back then
			if arg0_54:getEnemyByBuff(LaunchBallGameConst.enemy_buff_slow) then
				var2_54 = false
			end
		elseif var1_54.type == LaunchBallGameConst.enemy_buff_slow and arg0_54:getEnemyByBuff(LaunchBallGameConst.enemy_buff_back) then
			var2_54 = false
		end

		if var2_54 then
			local var3_54 = var1_54.rate
			local var4_54 = var3_54[1]

			if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) then
				if var1_54.type == LaunchBallGameConst.enemy_buff_slow then
					var4_54 = var4_54 + 2
				elseif var1_54.type == LaunchBallGameConst.enemy_buff_back then
					var4_54 = var4_54 + 2
				end
			end

			if var4_54 >= math.random(1, var3_54[2]) then
				table.insert(var0_54, var1_54.type)
			end
		end
	end

	if #var0_54 > 0 then
		return var0_54[math.random(1, #var0_54)]
	end

	return nil
end

function var0_0.getEnemyByBuff(arg0_55, arg1_55)
	for iter0_55 = 1, #arg0_55.enemysList do
		local var0_55 = arg0_55.pointsList[iter0_55]
		local var1_55 = arg0_55.enemysList[iter0_55]

		for iter1_55 = #var1_55, 1, -1 do
			local var2_55 = var1_55[iter1_55]

			if var2_55:getBuff() == arg1_55 then
				return var2_55
			end
		end
	end

	return nil
end

function var0_0.getOrCreateEnemy(arg0_56)
	local var0_56

	if #arg0_56.enemyPool > 0 then
		var0_56 = table.remove(arg0_56.enemyPool, 1)
	else
		local var1_56 = tf(instantiate(arg0_56._enemyTpl))

		setParent(var1_56, arg0_56._enemyContent)

		var0_56 = var16_0(var1_56)
	end

	return var0_56
end

function var0_0.sortEnemys(arg0_57, arg1_57)
	table.sort(arg1_57, function(arg0_58, arg1_58)
		return arg0_58:getDistance() < arg1_58:getDistance()
	end)

	for iter0_57 = 1, #arg1_57 do
		arg1_57[iter0_57]:setLastLayer(iter0_57 - 1)
	end
end

function var0_0.returnEnemy(arg0_59, arg1_59)
	arg1_59:setActive(false)
	table.insert(arg0_59.enemyPool, arg1_59)
end

function var0_0.getEnemyDataByRule(arg0_60)
	if not arg0_60.currentEnemyRule then
		arg0_60.currentEnemyRule = arg0_60:getEnemyRule()
	end

	if #var1_0 > 0 then
		return arg0_60:getEnemyById(table.remove(var1_0, 1))
	end

	if arg0_60.currentEnemyRule then
		local var0_60

		if arg0_60.currentEnemyRule.single then
			var0_60 = arg0_60.currentEnemyRule.singleId
		else
			var0_60 = arg0_60.currentEnemyRule.enemys[math.random(1, #arg0_60.currentEnemyRule.enemys)]
		end

		arg0_60.currentEnemyRule.count = arg0_60.currentEnemyRule.count - 1

		if arg0_60.currentEnemyRule.count <= 0 then
			arg0_60.currentEnemyRule = nil
		end

		return arg0_60:getEnemyById(var0_60)
	end

	return nil
end

function var0_0.getEnemyById(arg0_61, arg1_61)
	for iter0_61 = 1, #arg0_61.enemyDatas do
		if arg0_61.enemyDatas[iter0_61].data.id == arg1_61 then
			return arg0_61.enemyDatas[iter0_61]
		end
	end

	print("找不到id = " .. arg1_61 .. "的怪物")

	return nil
end

function var0_0.checkEnemyRuleUpdate(arg0_62)
	local var0_62 = false

	for iter0_62 = 1, #arg0_62.rounds do
		if LaunchBallGameVo.gameStepTime >= arg0_62.rounds[iter0_62].time[2] then
			var0_62 = true
		end
	end

	if var0_62 then
		arg0_62:createRoundData()
	end
end

function var0_0.getEnemysInBounds(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg0_63._enemyContent:InverseTransformPoint(arg1_63)
	local var1_63 = arg0_63._enemyContent:InverseTransformPoint(arg2_63)

	arg0_63.colliderTestTf.anchoredPosition = var1_63

	local var2_63 = {}

	for iter0_63 = 1, #arg0_63.enemysList do
		local var3_63 = arg0_63.pointsList[iter0_63]
		local var4_63 = arg0_63.enemysList[iter0_63]

		for iter1_63 = #var4_63, 1, -1 do
			local var5_63 = var4_63[iter1_63]:getTf().anchoredPosition

			if var5_63.x > var0_63.x and var5_63.x < var1_63.x and var5_63.y > var0_63.y and var5_63.y < var1_63.y then
				table.insert(var2_63, var4_63[iter1_63])
			end
		end
	end

	return var2_63
end

function var0_0.getEnemyRule(arg0_64)
	local var0_64
	local var1_64 = math.random(0, arg0_64.maxWeight)
	local var2_64

	for iter0_64 = 1, #arg0_64.rounds do
		if not var2_64 and var1_64 <= arg0_64.rounds[iter0_64].maxWeight then
			var2_64 = arg0_64.rounds[iter0_64].createId
		end
	end

	if var2_64 then
		if not arg0_64.enemyRule[var2_64] then
			print("create id not exit " .. var2_64)
		end

		local var3_64 = arg0_64.enemyRule[var2_64]
		local var4_64 = var3_64.id
		local var5_64 = var3_64.enemy_create.count
		local var6_64 = var3_64.enemy_create.enemys
		local var7_64 = var3_64.enemy_create.single
		local var8_64

		if var7_64 then
			var8_64 = var6_64[math.random(1, #var6_64)]
		end

		var0_64 = {
			id = var4_64,
			count = var5_64,
			enemys = var6_64,
			single = var7_64,
			singleId = var8_64
		}
	end

	return var0_64
end

function var0_0.createRoundData(arg0_65)
	local var0_65 = 0

	arg0_65.rounds = {}

	local var1_65 = LaunchBallGameVo.gameStepTime

	for iter0_65 = 1, #arg0_65.roundDatas do
		local var2_65 = arg0_65.roundDatas[iter0_65]
		local var3_65 = var2_65.weight
		local var4_65 = var2_65.time
		local var5_65 = var2_65.create_id

		if var1_65 >= var4_65[1] and var1_65 <= var4_65[2] then
			var0_65 = var0_65 + var3_65

			table.insert(arg0_65.rounds, {
				time = var4_65,
				weight = var3_65,
				maxWeight = var0_65,
				createId = var5_65
			})
		end
	end

	arg0_65.maxWeight = var0_65
end

function var0_0.checkAmulet(arg0_66, arg1_66)
	local var0_66 = arg1_66.tf.position

	arg0_66.fireIndex = arg1_66.fireIndex

	local var1_66 = arg1_66.color

	for iter0_66 = 1, #arg0_66.enemysList do
		local var2_66 = arg0_66.pointsList[iter0_66]
		local var3_66 = arg0_66.enemysList[iter0_66]

		for iter1_66 = #var3_66, 1, -1 do
			local var4_66 = var3_66[iter1_66]
			local var5_66, var6_66 = var3_66[iter1_66]:checkWorldInRect(var0_66)

			if var6_66 and var6_66 < var4_0 then
				arg1_66.overCount = arg1_66.overCount + 1
			end

			if var5_66 ~= 0 then
				arg0_66.amuletOverFlag = false

				if arg1_66.concentrate then
					if not var3_66[iter1_66]:getTimeRemove() then
						var3_66[iter1_66]:setTimeRemove()

						if arg0_66._eventCall then
							local var7_66 = LaunchBallGameVo.GetScore(1, 1)

							arg0_66._eventCall(LaunchBallGameScene.SPILT_ENEMY_SCORE, {
								num = var7_66
							})
						end

						if LaunchBallGameVo.GetBuff(LaunchBallPlayerControl.buff_time_max) and arg0_66.enemyStopTime and arg0_66.enemyStopTime > 0 then
							LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, 1)
						end
					end

					return false
				else
					local var8_66 = var4_66:getDistance()

					if var5_66 == 1 then
						var8_66 = var8_66 + var7_0
					else
						var8_66 = var8_66 - var7_0
					end

					if arg1_66.overCount >= 2 then
						arg0_66.amuletOverFlag = true
					end

					local var9_66 = arg0_66:getEnemyByColor(arg1_66.color, true)
					local var10_66 = arg0_66:createEnemy(iter0_66, var9_66, arg0_66.pointsList[iter0_66], arg0_66.enemysList[iter0_66], var8_66)

					var10_66:setSplitFlag(true)
					var10_66:playAnimation("Spawn")

					local var11_66 = arg0_66:getBackBuff()
					local var12_66 = arg1_66[LaunchBallGameConst.amulet_buff_back]

					if var11_66 or var12_66 then
						arg0_66:setBackTime(LaunchBallPlayerControl.buff_amulet_back_time, #var3_66, var9_0)
					end

					return true
				end
			end
		end
	end

	return false
end

function var0_0.checkPositionIn(arg0_67, arg1_67)
	for iter0_67 = 1, #arg0_67.enemysList do
		local var0_67 = arg0_67.pointsList[iter0_67]
		local var1_67 = arg0_67.enemysList[iter0_67]

		for iter1_67 = #var1_67, 1, -1 do
			local var2_67 = var1_67[iter1_67]

			if var1_67[iter1_67]:checkWorldInRect(arg1_67) ~= 0 then
				return var2_67
			end
		end
	end

	return false
end

function var0_0.checkWorldInEnemy(arg0_68, arg1_68)
	for iter0_68 = 1, #arg0_68.enemysList do
		local var0_68 = arg0_68.pointsList[iter0_68]
		local var1_68 = arg0_68.enemysList[iter0_68]

		for iter1_68 = #var1_68, 1, -1 do
			local var2_68 = var1_68[iter1_68]

			if var1_68[iter1_68]:checkWorldInCircle(arg1_68) then
				return true
			end
		end
	end

	return false
end

function var0_0.getBackBuff(arg0_69)
	local var0_69 = LaunchBallGameVo.buffs

	for iter0_69 = 1, #var0_69 do
		if var0_69[iter0_69].data.type == LaunchBallPlayerControl.buff_amulet_back then
			return true
		end
	end

	return false
end

function var0_0.getEnemyByColor(arg0_70, arg1_70, arg2_70)
	for iter0_70 = 1, #arg0_70.enemyDatas do
		if arg0_70.enemyDatas[iter0_70].data.color == arg1_70 and arg0_70.enemyDatas[iter0_70].data.player == arg2_70 then
			return arg0_70.enemyDatas[iter0_70]
		end
	end
end

function var0_0.setBackTime(arg0_71, arg1_71, arg2_71, arg3_71)
	arg0_71.backEnemyTime = arg1_71
	arg0_71.moveBackIndex = arg2_71
	arg0_71.backSpeed = arg3_71 or var9_0
end

function var0_0.eventCall(arg0_72, arg1_72, arg2_72)
	if arg1_72 == LaunchBallGameScene.PLAYING_CHANGE then
		-- block empty
	elseif arg1_72 == LaunchBallGameScene.FIRE_AMULET then
		-- block empty
	elseif arg1_72 == LaunchBallGameScene.SPLIT_ALL_ENEMYS then
		arg0_72.timeRemoveAll = arg2_72.time, arg2_72.effect
	elseif arg1_72 == LaunchBallGameScene.STOP_ENEMY_TIME then
		arg0_72.enemyStopTime = arg2_72.time

		arg0_72:stopEnemysAnim(true)
	elseif arg1_72 == LaunchBallGameScene.SLASH_ENEMY then
		local var0_72 = arg2_72.bound
	end
end

function var0_0.stopEnemysAnim(arg0_73, arg1_73)
	for iter0_73 = 1, #arg0_73.enemysList do
		local var0_73 = arg0_73.pointsList[iter0_73]
		local var1_73 = arg0_73.enemysList[iter0_73]

		for iter1_73 = #var1_73, 1, -1 do
			var1_73[iter1_73]:stopAnim(arg1_73)
		end
	end
end

function var0_0.press(arg0_74, arg1_74)
	if arg1_74 == KeyCode.J then
		-- block empty
	end
end

function var0_0.clear(arg0_75)
	return
end

return var0_0
