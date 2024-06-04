local var0 = class("LaunchBallGameScene")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 1
local var6 = 2
local var7 = 3
local var8 = 4
local var9 = 5
local var10 = 6
local var11 = 7
local var12 = 90
local var13 = {
	[var5] = {
		tpl = "pointer01"
	},
	[var6] = {
		tpl = "pointer02"
	},
	[var7] = {
		tpl = "pointer03"
	},
	[var8] = {
		tpl = "pointer04"
	},
	[var9] = {
		tpl = "pointer05"
	},
	[var10] = {
		tpl = "pointer06"
	},
	[var11] = {
		tpl = "pointer07"
	}
}

var0.PLAYING_CHANGE = "playing change"
var0.FIRE_AMULET = "fire amulet"
var0.ENEMY_FINISH = "enemy finish"
var0.HIT_ENEMY = "hit enemy"
var0.RANDOM_FIRE = "random fire"
var0.CHANGE_AMULET = "change amulet"
var0.CONCENTRATE_TRIGGER = "concentrate trigger"
var0.SLEEP_TIME_TRIGGER = "sleep time trigger"
var0.SPILT_ENEMY_SCORE = "spilt enemy score"
var0.SPLIT_ALL_ENEMYS = "split all enemys"
var0.STOP_ENEMY_TIME = "stop enemy time"
var0.SPLIT_BUFF_ENEMY = "split buff enemy"
var0.SLASH_ENEMY = "slash enemy"
var0.PLAYER_EFFECT = "player effect"

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0.sceneMask = findTF(arg0._tf, "sceneMask")
	arg0.tplContent = findTF(arg0._tf, "sceneMask/sceneContainer/scene/tpl")
	arg0.contentBack = findTF(arg0._tf, "sceneMask/sceneContainer/scene_background/content")
	arg0.contentMid = findTF(arg0._tf, "sceneMask/sceneContainer/scene/content")
	arg0.contentTop = findTF(arg0._tf, "sceneMask/sceneContainer/scene_front/content")
	arg0.contentEF = findTF(arg0._tf, "sceneMask/sceneContainer/scene/effect_front")
	arg0.playerContent = findTF(arg0.contentTop, "player")
	arg0.amuletContent = findTF(arg0.contentTop, "amulet")
	arg0.amuletsContent = findTF(arg0.contentTop, "amulets")
	arg0.amuletLifeContent = findTF(arg0.contentTop, "amuletLifeContent")
	arg0.enemyContent = findTF(arg0.contentMid, "enemy")
	arg0.lineContent = findTF(arg0.contentMid, "line")
	arg0.joyStick = LaunchBallGameJoyStick.New(findTF(arg0.contentTop, "joyStick"))

	arg0.joyStick:setActiveCallback(function(arg0)
		arg0:joystickActive(arg0)
	end)

	local function var0(arg0, arg1)
		arg0.launchBallAmulet:eventCall(arg0, arg1)
		arg0.launchBallPlayer:eventCall(arg0, arg1)
		arg0.launchBallEnemy:eventCall(arg0, arg1)

		if arg0 == LaunchBallGameScene.ENEMY_FINISH then
			arg0._event:emit(LaunchBallGameView.GAME_OVER)
		elseif arg0 == LaunchBallGameScene.SPILT_ENEMY_SCORE then
			arg0._event:emit(LaunchBallGameView.ADD_SCORE, arg1)
		elseif arg0 == LaunchBallGameScene.SLASH_ENEMY then
			arg0.timeSlashDirect = arg1.direct
			arg0.timeSlash = arg1.time
		end
	end

	local var1 = Clone(LaunchBallGameConst.map_data[LaunchBallGameVo.gameRoundData.map].map)
	local var2 = findTF(arg0.contentBack, "bg")
	local var3 = findTF(arg0.contentTop, "bg")

	for iter0 = 0, var2.childCount - 1 do
		local var4 = var2:GetChild(iter0)

		setActive(var4, var4.name == var1)
	end

	for iter1 = 0, var3.childCount - 1 do
		local var5 = var3:GetChild(iter1)

		setActive(var5, var5.name == var1)
	end

	for iter2 = 0, arg0.lineContent.childCount - 1 do
		setActive(arg0.lineContent:GetChild(iter2), false)
	end

	arg0.launchBallAmulet = LaunchBallAmulet.New(arg0.amuletContent, arg0.amuletsContent, arg0.amuletLifeContent, arg0.tplContent, var0)
	arg0.launchBallPlayer = LaunchBallPlayerControl.New(arg0.contentTop, arg0.playerContent, arg0.tplContent, var0)
	arg0.launchBallEnemy = LaunchBallEnemy.New(arg0.enemyContent, arg0.lineContent, arg0.tplContent, var0)

	if not arg0.pointerContent then
		arg0.pointerContent = findTF(arg0.contentTop, "pointer")
	end

	if not arg0.pointerCollider then
		arg0.pointerCollider = findTF(arg0.contentTop, "collider")

		setActive(arg0.pointerCollider, false)
	end
end

local var14 = 50
local var15 = 500
local var16 = var15 / 50

function var0.start(arg0)
	arg0:prepareScene()
	arg0.launchBallAmulet:start()
	arg0.launchBallPlayer:start()
	arg0.launchBallEnemy:start()

	arg0.pointerRotation = Vector3(0, 0, 0)
	arg0.pointerPosition = Vector2(0, 0)

	for iter0 = 0, arg0.pointerContent.childCount - 1 do
		local var0 = arg0.pointerContent:GetChild(iter0)

		setActive(var0, false)
	end

	arg0.timeSlash = nil
end

function var0.step(arg0)
	arg0.joyStick:step()

	LaunchBallGameVo.joyStickData = arg0.joyStick:getValue()

	arg0.launchBallAmulet:step()
	arg0.launchBallPlayer:step()
	arg0.launchBallEnemy:step()

	local var0 = arg0.launchBallAmulet:getAngle()

	if var0 < 0 and arg0.lastContent ~= arg0.amuletContent then
		arg0.amuletContent:SetAsLastSibling()
		arg0.amuletsContent:SetAsFirstSibling()

		arg0.lastContent = arg0.amuletContent
	elseif var0 > 0 and arg0.lastContent ~= arg0.playerContent then
		arg0.amuletContent:SetAsFirstSibling()
		arg0.amuletsContent:SetAsLastSibling()

		arg0.lastContent = arg0.playerContent
	end

	if arg0.timeSlash and arg0.timeSlash > 0 then
		arg0.timeSlash = arg0.timeSlash - LaunchBallGameVo.deltaTime

		if arg0.timeSlash <= 0 then
			arg0.timeSlash = nil

			local var1 = GetComponent(findTF(arg0.contentTop, "effect/SlashBound/ad/" .. arg0.timeSlashDirect), typeof(BoxCollider2D))
			local var2 = var1.bounds.min
			local var3 = var1.bounds.max
			local var4 = arg0.launchBallEnemy:getEnemysInBounds(var2, var3)

			for iter0 = 1, #var4 do
				var4[iter0]:hit()

				local var5 = LaunchBallGameVo.GetScore(1, 1)

				arg0._event:emit(LaunchBallGameView.ADD_SCORE, {
					num = var5
				})
			end

			LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_skill_count, #var4)
		end
	end

	local var6 = arg0.launchBallAmulet:getFireAmulet()

	for iter1 = #var6, 1, -1 do
		local var7 = var6[iter1]
		local var8 = var6[iter1].tf.position

		if not var7.removeFlag and arg0.launchBallEnemy:checkAmulet(var6[iter1]) then
			var7.removeFlag = true
		end
	end

	local var9 = arg0.launchBallAmulet:getButterfly()

	for iter2 = #var9, 1, -1 do
		local var10 = var9[iter2]
		local var11 = var10.tf

		if not var10.removeFlag and not var10.removeTime then
			local var12 = var11.position
			local var13 = arg0.launchBallEnemy:checkPositionIn(var12)

			if var13 then
				var10.removeTime = 0.2
				var10.speed.x = 0
				var10.speed.y = 0

				var10.anim:Play("Hit")
				var13:setTimeRemove()

				local var14 = LaunchBallGameVo.GetScore(1, 1)

				arg0._event:emit(LaunchBallGameView.ADD_SCORE, {
					num = var14
				})
				LaunchBallGameVo.AddGameResultData(LaunchBallGameVo.result_pass_skill_count, 1)
			end
		end
	end

	if LaunchBallGameVo.joyStickData.active and LaunchBallGameVo.amulet then
		arg0.pointerTime = arg0.pointerTime + LaunchBallGameVo.deltaTime

		if not arg0.pointerColor then
			local var15 = LaunchBallGameVo.amulet.color
			local var16 = var13[LaunchBallGameVo.amulet.color].tpl

			for iter3 = 0, arg0.pointerContent.childCount - 1 do
				local var17 = arg0.pointerContent:GetChild(iter3)

				if var17.name == var16 then
					arg0.anglePointer = var17
				end

				setActive(var17, false)
			end
		end

		if arg0.pointerTime > 0.3 and LaunchBallGameVo.joyStickData.active then
			local var18 = LaunchBallGameVo.joyStickData.angle
			local var19 = LaunchBallGameVo.joyStickData.rad

			if var18 and var19 then
				arg0.pointerRotation.z = var18 + var12
				arg0.anglePointer.localEulerAngles = arg0.pointerRotation

				setActive(arg0.anglePointer, true)

				local var20 = 0

				for iter4 = 1, var16 do
					var20 = iter4 * var14
					arg0.pointerPosition.x = math.cos(var19) * var20
					arg0.pointerPosition.y = math.sin(var19) * var20

					local var21 = arg0.pointerContent:TransformPoint(arg0.pointerPosition)

					if arg0.launchBallEnemy:checkWorldInEnemy(var21) then
						break
					end
				end

				for iter5 = 1, 4 do
					arg0.pointerPosition.x = 0
					arg0.pointerPosition.y = (5 - iter5) / 4 * var20 * -1
					findTF(arg0.anglePointer, "ad/" .. iter5).anchoredPosition = arg0.pointerPosition
				end
			end
		end
	else
		arg0.pointerTime = 0
		arg0.pointerColor = nil

		if arg0.anglePointer then
			setActive(arg0.anglePointer, false)
		end
	end
end

function var0.clear(arg0)
	arg0.launchBallAmulet:clear()
	arg0.launchBallPlayer:clear()
	arg0.launchBallEnemy:clear()
end

function var0.stop(arg0)
	return
end

function var0.resume(arg0)
	return
end

function var0.dispose(arg0)
	return
end

function var0.prepareScene(arg0)
	arg0:showContainer(true)
end

function var0.showContainer(arg0, arg1)
	setActive(arg0.sceneMask, arg1)
end

function var0.useSkill(arg0)
	arg0.launchBallPlayer:useSkill()
end

function var0.press(arg0, arg1)
	arg0.launchBallEnemy:press(arg1)
end

function var0.joystickActive(arg0, arg1)
	arg0.launchBallPlayer:joystickActive(arg1)
end

return var0
