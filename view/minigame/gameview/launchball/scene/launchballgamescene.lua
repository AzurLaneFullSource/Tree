local var0_0 = class("LaunchBallGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 1
local var6_0 = 2
local var7_0 = 3
local var8_0 = 4
local var9_0 = 5
local var10_0 = 6
local var11_0 = 7
local var12_0 = 90
local var13_0 = {
	[var5_0] = {
		tpl = "pointer01"
	},
	[var6_0] = {
		tpl = "pointer02"
	},
	[var7_0] = {
		tpl = "pointer03"
	},
	[var8_0] = {
		tpl = "pointer04"
	},
	[var9_0] = {
		tpl = "pointer05"
	},
	[var10_0] = {
		tpl = "pointer06"
	},
	[var11_0] = {
		tpl = "pointer07"
	}
}

var0_0.PLAYING_CHANGE = "playing change"
var0_0.FIRE_AMULET = "fire amulet"
var0_0.ENEMY_FINISH = "enemy finish"
var0_0.HIT_ENEMY = "hit enemy"
var0_0.RANDOM_FIRE = "random fire"
var0_0.CHANGE_AMULET = "change amulet"
var0_0.CONCENTRATE_TRIGGER = "concentrate trigger"
var0_0.SLEEP_TIME_TRIGGER = "sleep time trigger"
var0_0.SPILT_ENEMY_SCORE = "spilt enemy score"
var0_0.SPLIT_ALL_ENEMYS = "split all enemys"
var0_0.STOP_ENEMY_TIME = "stop enemy time"
var0_0.SPLIT_BUFF_ENEMY = "split buff enemy"
var0_0.SLASH_ENEMY = "slash enemy"
var0_0.PLAYER_EFFECT = "player effect"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.tplContent = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/tpl")
	arg0_1.contentBack = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene_background/content")
	arg0_1.contentMid = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/content")
	arg0_1.contentTop = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene_front/content")
	arg0_1.contentEF = findTF(arg0_1._tf, "sceneMask/sceneContainer/scene/effect_front")
	arg0_1.playerContent = findTF(arg0_1.contentTop, "player")
	arg0_1.amuletContent = findTF(arg0_1.contentTop, "amulet")
	arg0_1.amuletsContent = findTF(arg0_1.contentTop, "amulets")
	arg0_1.amuletLifeContent = findTF(arg0_1.contentTop, "amuletLifeContent")
	arg0_1.enemyContent = findTF(arg0_1.contentMid, "enemy")
	arg0_1.lineContent = findTF(arg0_1.contentMid, "line")
	arg0_1.joyStick = LaunchBallGameJoyStick.New(findTF(arg0_1.contentTop, "joyStick"))

	arg0_1.joyStick:setActiveCallback(function(arg0_2)
		arg0_1:joystickActive(arg0_2)
	end)

	local function var0_1(arg0_3, arg1_3)
		arg0_1.launchBallAmulet:eventCall(arg0_3, arg1_3)
		arg0_1.launchBallPlayer:eventCall(arg0_3, arg1_3)
		arg0_1.launchBallEnemy:eventCall(arg0_3, arg1_3)

		if arg0_3 == LaunchBallGameScene.ENEMY_FINISH then
			arg0_1._event:emit(LaunchBallGameView.GAME_OVER)
		elseif arg0_3 == LaunchBallGameScene.SPILT_ENEMY_SCORE then
			arg0_1._event:emit(LaunchBallGameView.ADD_SCORE, arg1_3)
		elseif arg0_3 == LaunchBallGameScene.SLASH_ENEMY then
			arg0_1.timeSlashDirect = arg1_3.direct
			arg0_1.timeSlash = arg1_3.time
		end
	end

	local var1_1 = Clone(LaunchBallGameConst.map_data[LaunchBallGameVo.gameRoundData.map].map)
	local var2_1 = findTF(arg0_1.contentBack, "bg")
	local var3_1 = findTF(arg0_1.contentTop, "bg")

	for iter0_1 = 0, var2_1.childCount - 1 do
		local var4_1 = var2_1:GetChild(iter0_1)

		setActive(var4_1, var4_1.name == var1_1)
	end

	for iter1_1 = 0, var3_1.childCount - 1 do
		local var5_1 = var3_1:GetChild(iter1_1)

		setActive(var5_1, var5_1.name == var1_1)
	end

	for iter2_1 = 0, arg0_1.lineContent.childCount - 1 do
		setActive(arg0_1.lineContent:GetChild(iter2_1), false)
	end

	arg0_1.launchBallAmulet = LaunchBallAmulet.New(arg0_1.amuletContent, arg0_1.amuletsContent, arg0_1.amuletLifeContent, arg0_1.tplContent, var0_1)
	arg0_1.launchBallPlayer = LaunchBallPlayerControl.New(arg0_1.contentTop, arg0_1.playerContent, arg0_1.tplContent, var0_1)
	arg0_1.launchBallEnemy = LaunchBallEnemy.New(arg0_1.enemyContent, arg0_1.lineContent, arg0_1.tplContent, var0_1)

	if not arg0_1.pointerContent then
		arg0_1.pointerContent = findTF(arg0_1.contentTop, "pointer")
	end

	if not arg0_1.pointerCollider then
		arg0_1.pointerCollider = findTF(arg0_1.contentTop, "collider")

		setActive(arg0_1.pointerCollider, false)
	end
end

local var14_0 = 50
local var15_0 = 500
local var16_0 = var15_0 / 50

function var0_0.start(arg0_4)
	arg0_4:prepareScene()
	arg0_4.launchBallAmulet:start()
	arg0_4.launchBallPlayer:start()
	arg0_4.launchBallEnemy:start()

	arg0_4.pointerRotation = Vector3(0, 0, 0)
	arg0_4.pointerPosition = Vector2(0, 0)

	for iter0_4 = 0, arg0_4.pointerContent.childCount - 1 do
		local var0_4 = arg0_4.pointerContent:GetChild(iter0_4)

		setActive(var0_4, false)
	end

	arg0_4.timeSlash = nil
end

function var0_0.step(arg0_5)
	arg0_5.joyStick:step()

	LaunchBallGameVo.joyStickData = arg0_5.joyStick:getValue()

	arg0_5.launchBallAmulet:step()
	arg0_5.launchBallPlayer:step()
	arg0_5.launchBallEnemy:step()

	local var0_5 = arg0_5.launchBallAmulet:getAngle()

	if var0_5 < 0 and arg0_5.lastContent ~= arg0_5.amuletContent then
		arg0_5.amuletContent:SetAsLastSibling()
		arg0_5.amuletsContent:SetAsFirstSibling()

		arg0_5.lastContent = arg0_5.amuletContent
	elseif var0_5 > 0 and arg0_5.lastContent ~= arg0_5.playerContent then
		arg0_5.amuletContent:SetAsFirstSibling()
		arg0_5.amuletsContent:SetAsLastSibling()

		arg0_5.lastContent = arg0_5.playerContent
	end

	if arg0_5.timeSlash and arg0_5.timeSlash > 0 then
		arg0_5.timeSlash = arg0_5.timeSlash - LaunchBallGameVo.deltaTime

		if arg0_5.timeSlash <= 0 then
			arg0_5.timeSlash = nil

			local var1_5 = GetComponent(findTF(arg0_5.contentTop, "effect/SlashBound/ad/" .. arg0_5.timeSlashDirect), typeof(BoxCollider2D))
			local var2_5 = var1_5.bounds.min
			local var3_5 = var1_5.bounds.max
			local var4_5 = arg0_5.launchBallEnemy:getEnemysInBounds(var2_5, var3_5)

			for iter0_5 = 1, #var4_5 do
				var4_5[iter0_5]:hit()

				local var5_5 = LaunchBallGameVo.GetScore(1, 1)

				arg0_5._event:emit(LaunchBallGameView.ADD_SCORE, {
					num = var5_5
				})
			end

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, #var4_5)
		end
	end

	local var6_5 = arg0_5.launchBallAmulet:getFireAmulet()

	for iter1_5 = #var6_5, 1, -1 do
		local var7_5 = var6_5[iter1_5]
		local var8_5 = var6_5[iter1_5].tf.position

		if not var7_5.removeFlag and arg0_5.launchBallEnemy:checkAmulet(var6_5[iter1_5]) then
			var7_5.removeFlag = true
		end
	end

	local var9_5 = arg0_5.launchBallAmulet:getButterfly()

	for iter2_5 = #var9_5, 1, -1 do
		local var10_5 = var9_5[iter2_5]
		local var11_5 = var10_5.tf

		if not var10_5.removeFlag and not var10_5.removeTime then
			local var12_5 = var11_5.position
			local var13_5 = arg0_5.launchBallEnemy:checkPositionIn(var12_5)

			if var13_5 then
				var10_5.removeTime = 0.2
				var10_5.speed.x = 0
				var10_5.speed.y = 0

				var10_5.anim:Play("Hit")
				var13_5:setTimeRemove()

				local var14_5 = LaunchBallGameVo.GetScore(1, 1)

				arg0_5._event:emit(LaunchBallGameView.ADD_SCORE, {
					num = var14_5
				})
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_pass_skill_count, 1)
			end
		end
	end

	if LaunchBallGameVo.joyStickData.active and LaunchBallGameVo.amulet then
		arg0_5.pointerTime = arg0_5.pointerTime + LaunchBallGameVo.deltaTime

		if not arg0_5.pointerColor then
			local var15_5 = LaunchBallGameVo.amulet.color
			local var16_5 = var13_0[LaunchBallGameVo.amulet.color].tpl

			for iter3_5 = 0, arg0_5.pointerContent.childCount - 1 do
				local var17_5 = arg0_5.pointerContent:GetChild(iter3_5)

				if var17_5.name == var16_5 then
					arg0_5.anglePointer = var17_5
				end

				setActive(var17_5, false)
			end
		end

		if arg0_5.pointerTime > 0.3 and LaunchBallGameVo.joyStickData.active then
			local var18_5 = LaunchBallGameVo.joyStickData.angle
			local var19_5 = LaunchBallGameVo.joyStickData.rad

			if var18_5 and var19_5 then
				arg0_5.pointerRotation.z = var18_5 + var12_0
				arg0_5.anglePointer.localEulerAngles = arg0_5.pointerRotation

				setActive(arg0_5.anglePointer, true)

				local var20_5 = 0

				for iter4_5 = 1, var16_0 do
					var20_5 = iter4_5 * var14_0
					arg0_5.pointerPosition.x = math.cos(var19_5) * var20_5
					arg0_5.pointerPosition.y = math.sin(var19_5) * var20_5

					local var21_5 = arg0_5.pointerContent:TransformPoint(arg0_5.pointerPosition)

					if arg0_5.launchBallEnemy:checkWorldInEnemy(var21_5) then
						break
					end
				end

				for iter5_5 = 1, 4 do
					arg0_5.pointerPosition.x = 0
					arg0_5.pointerPosition.y = (5 - iter5_5) / 4 * var20_5 * -1
					findTF(arg0_5.anglePointer, "ad/" .. iter5_5).anchoredPosition = arg0_5.pointerPosition
				end
			end
		end
	else
		arg0_5.pointerTime = 0
		arg0_5.pointerColor = nil

		if arg0_5.anglePointer then
			setActive(arg0_5.anglePointer, false)
		end
	end
end

function var0_0.clear(arg0_6)
	arg0_6.launchBallAmulet:clear()
	arg0_6.launchBallPlayer:clear()
	arg0_6.launchBallEnemy:clear()
end

function var0_0.stop(arg0_7)
	return
end

function var0_0.resume(arg0_8)
	return
end

function var0_0.dispose(arg0_9)
	return
end

function var0_0.prepareScene(arg0_10)
	arg0_10:showContainer(true)
end

function var0_0.showContainer(arg0_11, arg1_11)
	setActive(arg0_11.sceneMask, arg1_11)
end

function var0_0.useSkill(arg0_12)
	arg0_12.launchBallPlayer:useSkill()
end

function var0_0.press(arg0_13, arg1_13)
	arg0_13.launchBallEnemy:press(arg1_13)
end

function var0_0.joystickActive(arg0_14, arg1_14)
	arg0_14.launchBallPlayer:joystickActive(arg1_14)
end

return var0_0
