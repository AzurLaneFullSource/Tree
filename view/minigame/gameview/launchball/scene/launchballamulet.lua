local var0_0 = class("LaunchBallAmulet")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = {
	var1_0,
	var3_0,
	var4_0,
	var7_0,
	var2_0,
	var5_0,
	var6_0
}
local var9_0 = "amulet s"
local var10_0 = "amulet l"
local var11_0 = "amulet ef"
local var12_0 = 3
local var13_0 = {
	{
		index = 1,
		anim_name = "EF_A",
		offset = Vector2(0, 20)
	},
	{
		index = 2,
		anim_name = "EF_B",
		offset = Vector2(0, 0)
	},
	{
		index = 3,
		anim_name = "EF_C",
		offset = Vector2(0, -20)
	}
}
local var14_0 = 50
local var15_0 = 70
local var16_0 = -80
local var17_0 = 1000
local var18_0 = 90
local var19_0 = -90
local var20_0 = 1000
local var21_0 = 0.05
local var22_0 = 0.5
local var23_0 = {
	[var1_0] = {
		name = "Yellow",
		animator = "Amulet_Yellow_"
	},
	[var3_0] = {
		name = "White",
		animator = "Amulet_White_"
	},
	[var4_0] = {
		name = "Red",
		animator = "Amulet_Red_"
	},
	[var7_0] = {
		name = "Purple",
		animator = "Amulet_Purple_"
	},
	[var2_0] = {
		name = "Green",
		animator = "Amulet_Green_"
	},
	[var5_0] = {
		name = "Blue",
		animator = "Amulet_Blue_"
	},
	[var6_0] = {
		name = "Black",
		animator = "Amulet_Black_"
	}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.amuletLAnimators = {}
	arg0_1.amuletSAnimators = {}
	arg0_1.amuletEFAnimators = {}

	for iter0_1, iter1_1 in ipairs(var23_0) do
		local var0_1 = iter0_1
		local var1_1 = iter1_1.name
		local var2_1 = iter1_1.animator
		local var3_1 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2_1 .. "L", typeof(RuntimeAnimatorController), false, false)
		local var4_1 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2_1 .. "S", typeof(RuntimeAnimatorController), false, false)
		local var5_1 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2_1 .. "EF", typeof(RuntimeAnimatorController), false, false)

		table.insert(arg0_1.amuletLAnimators, {
			animator = var3_1,
			type = var0_1,
			name = var1_1
		})
		table.insert(arg0_1.amuletSAnimators, {
			animator = var4_1,
			type = var0_1,
			name = var1_1
		})
		table.insert(arg0_1.amuletEFAnimators, {
			animator = var5_1,
			type = var0_1,
			name = var1_1
		})
	end

	arg0_1._content = arg1_1
	arg0_1._sContent = arg2_1
	arg0_1._lifeContent = arg3_1
	arg0_1._tpl = arg4_1
	arg0_1._eventCall = arg5_1
	arg0_1._amuletLTpl = findTF(arg0_1._tpl, "amuletL")
	arg0_1._amuletSTpl = findTF(arg0_1._tpl, "amuletS")
	arg0_1._amuletEfTpl = findTF(arg0_1._tpl, "amuletEF")
	arg0_1._butterflyTpl = findTF(arg0_1._tpl, "Butterfly")

	arg0_1:setAmuletL(nil)

	arg0_1.amuletS = nil
	arg0_1.amuletEFs = {}
	arg0_1.amuletLPool = {}
	arg0_1.amuletSPool = {}
	arg0_1.amuletEFPool = {}
	arg0_1._amuletFires = {}
	arg0_1.butterflys = {}
end

function var0_0.start(arg0_2)
	local var0_2 = LaunchBallGameVo.gameRoundData.amulet_life

	arg0_2.lifeBound = GetComponent(findTF(arg0_2._lifeContent, tostring(var0_2)), typeof(BoxCollider2D))
	arg0_2.min = arg0_2._lifeContent:InverseTransformPoint(arg0_2.lifeBound.bounds.min)
	arg0_2.max = arg0_2._lifeContent:InverseTransformPoint(arg0_2.lifeBound.bounds.max)
	arg0_2.amuletType = arg0_2:getRandomAmuletType()
	arg0_2.amuletNextType = arg0_2:getRandomAmuletType()

	arg0_2:setAmuletL(arg0_2:getAmulete(var10_0, arg0_2.amuletType))

	arg0_2.amuletS = arg0_2:getAmulete(var9_0, arg0_2.amuletNextType)
	arg0_2.amuletPos = Vector2(0, 0)
	arg0_2.angle = var19_0
	arg0_2.rad = var19_0 * math.deg2Rad
	arg0_2.amuletPos.x = math.cos(arg0_2.rad) * var15_0
	arg0_2.amuletPos.y = math.sin(arg0_2.rad) * var15_0
	arg0_2.isPlaying = false
end

function var0_0.step(arg0_3)
	if not arg0_3.isPlaying then
		if LaunchBallGameVo.joyStickData and LaunchBallGameVo.joyStickData.angle then
			arg0_3.rad = LaunchBallGameVo.joyStickData.rad
			arg0_3.angle = LaunchBallGameVo.joyStickData.angle
			arg0_3.amuletPos.x = math.cos(arg0_3.rad) * var15_0
			arg0_3.amuletPos.y = math.sin(arg0_3.rad) * var15_0
		end

		if arg0_3.amuletL then
			arg0_3.amuletL.tf.anchoredPosition = arg0_3.amuletPos
			arg0_3.amuletL.rad = arg0_3.rad
		else
			arg0_3:setAmuletL(arg0_3:getAmulete(var10_0, arg0_3.amuletNextType))
			arg0_3:returnAmulete(arg0_3.amuletS, arg0_3.amuletSPool)

			arg0_3.amuletNextType = arg0_3:getRandomAmuletType()
			arg0_3.amuletS = nil
			arg0_3.amuletS = arg0_3:getAmulete(var9_0, arg0_3.amuletNextType)
		end

		if arg0_3.amuletS then
			arg0_3.amuletS.tf.anchoredPosition = Vector2(math.cos(arg0_3.rad) * var16_0, math.sin(arg0_3.rad) * var16_0)
		end
	end

	if arg0_3._amuletFires and #arg0_3._amuletFires > 0 then
		for iter0_3 = #arg0_3._amuletFires, 1, -1 do
			local var0_3 = arg0_3._amuletFires[iter0_3]
			local var1_3 = var0_3.tf.anchoredPosition

			var1_3.x = var1_3.x + var0_3.speed.x * LaunchBallGameVo.deltaTime
			var1_3.y = var1_3.y + var0_3.speed.y * LaunchBallGameVo.deltaTime
			var0_3.tf.anchoredPosition = var1_3

			if var0_3.effectTime and var0_3.effectTime > 0 then
				var0_3.effectTime = var0_3.effectTime - LaunchBallGameVo.deltaTime

				if var0_3.effectTime <= 0 then
					var0_3.effectTime = var21_0

					arg0_3:createEF(var0_3)
				end
			end

			if math.abs(var1_3.x) > var20_0 or math.abs(var1_3.y) > var20_0 then
				table.remove(arg0_3._amuletFires, iter0_3)
				arg0_3:returnAmulete(var0_3, arg0_3.amuletLPool)
			elseif var0_3.removeFlag then
				table.remove(arg0_3._amuletFires, iter0_3)
				arg0_3:returnAmulete(var0_3, arg0_3.amuletLPool)
			elseif arg0_3.lifeBound then
				if var1_3.x >= arg0_3.max.x or var1_3.x <= arg0_3.min.x then
					table.remove(arg0_3._amuletFires, iter0_3)
					arg0_3:returnAmulete(var0_3, arg0_3.amuletLPool)
				elseif var1_3.y >= arg0_3.max.y or var1_3.y <= arg0_3.min.y then
					table.remove(arg0_3._amuletFires, iter0_3)
					arg0_3:returnAmulete(var0_3, arg0_3.amuletLPool)
				end
			end
		end
	end

	if arg0_3.butterflys and #arg0_3.butterflys > 0 then
		for iter1_3 = #arg0_3.butterflys, 1, -1 do
			local var2_3 = arg0_3.butterflys[iter1_3]
			local var3_3 = var2_3.tf.anchoredPosition

			var3_3.x = var3_3.x + var2_3.speed.x * LaunchBallGameVo.deltaTime
			var3_3.y = var3_3.y + var2_3.speed.y * LaunchBallGameVo.deltaTime
			var2_3.tf.anchoredPosition = var3_3

			if math.abs(var3_3.x) > var20_0 or math.abs(var3_3.y) > var20_0 then
				var2_3.anim = nil

				Destroy(var2_3.tf)
				table.remove(arg0_3.butterflys, iter1_3)
			elseif var2_3.removeFlag then
				var2_3.anim = nil

				Destroy(var2_3.tf)
				table.remove(arg0_3.butterflys, iter1_3)
			elseif var3_3.x >= arg0_3.max.x or var3_3.x <= arg0_3.min.x then
				var2_3.anim = nil

				Destroy(var2_3.tf)
				table.remove(arg0_3.butterflys, iter1_3)
			elseif var3_3.y >= arg0_3.max.y or var3_3.y <= arg0_3.min.y then
				var2_3.anim = nil

				Destroy(var2_3.tf)
				table.remove(arg0_3.butterflys, iter1_3)
			elseif var2_3.removeTime and var2_3.removeTime > 0 then
				var2_3.removeTime = var2_3.removeTime - LaunchBallGameVo.deltaTime

				if var2_3.removeTime < 0 then
					var2_3.removeTime = nil
					var2_3.removeFlag = true
				end
			end
		end
	end

	if arg0_3.amuletEFs and #arg0_3.amuletEFs > 0 then
		for iter2_3 = #arg0_3.amuletEFs, 1, -1 do
			local var4_3 = arg0_3.amuletEFs[iter2_3]

			if var4_3.removeTime and var4_3.removeTime > 0 then
				var4_3.removeTime = var4_3.removeTime - LaunchBallGameVo.deltaTime

				if var4_3.removeTime <= 0 then
					table.remove(arg0_3.amuletEFs, iter2_3)
					arg0_3:returnAmulete(var4_3, arg0_3.amuletEFPool)
				end
			end
		end
	end
end

function var0_0.getFireAmulet(arg0_4)
	return arg0_4._amuletFires
end

function var0_0.removeFireAmulet(arg0_5, arg1_5)
	if arg0_5._amuletFires and #arg0_5._amuletFires > 0 then
		for iter0_5 = #arg0_5._amuletFires, 1, -1 do
			local var0_5 = arg0_5._amuletFires[iter0_5]

			if var0_5 then
				table.remove(arg0_5._amuletFires, iter0_5)
				arg0_5:returnAmulete(var0_5, arg0_5.amuletLPool)
			end
		end
	end
end

var0_0.fireIndex = 0

function var0_0.getAmulete(arg0_6, arg1_6, arg2_6)
	local var0_6
	local var1_6
	local var2_6
	local var3_6
	local var4_6 = arg0_6._content

	if arg1_6 == var10_0 then
		var1_6 = arg0_6.amuletLPool
		var2_6 = arg0_6._amuletLTpl
		var3_6 = Vector2(0, var15_0)
	elseif arg1_6 == var9_0 then
		var1_6 = arg0_6.amuletSPool
		var2_6 = arg0_6._amuletSTpl
		var3_6 = Vector2(0, var16_0)
		var4_6 = arg0_6._sContent
	elseif arg1_6 == var11_0 then
		var1_6 = arg0_6.amuletEFPool
		var2_6 = arg0_6._amuletEfTpl
		var3_6 = Vector2(0, 0)
	end

	if not var1_6 then
		return
	end

	for iter0_6 = 1, #var1_6 do
		var0_6 = var0_6 or table.remove(var1_6, iter0_6)
	end

	if not var0_6 then
		local var5_6 = tf(instantiate(var2_6))
		local var6_6 = findTF(var5_6, "ad/anim")
		local var7_6 = GetComponent(findTF(var5_6, "ad/anim"), typeof(Animator))

		setParent(var5_6, var4_6)

		var0_6 = {
			tf = var5_6,
			type = arg1_6,
			anim = var7_6,
			animTf = var6_6
		}
	end

	var0_6.angle = nil
	var0_6.fire = nil

	setActive(var0_6.tf, true)

	var0_6.tf.anchoredPosition = var3_6
	var0_6.anim.runtimeAnimatorController = arg0_6:getAnimator(arg1_6, arg2_6)
	var0_6.tf.name = arg1_6 .. "_" .. var23_0[arg2_6].name
	var0_6.color = arg2_6
	findTF(var0_6.tf, "ad").localRotation = Quaternion.Euler(0, 0, 0)
	var0_6.removeFlag = false

	if arg1_6 == var10_0 then
		var0_6.effectTime = var21_0
		var0_6.effectIndex = 1
		var0_6[LaunchBallGameConst.amulet_buff_back] = false
		var0_6.concentrate = false
		var0_6.fireIndex = var0_0.fireIndex
		var0_6.overFlag = false
		var0_6.overCount = 0
		var0_0.fireIndex = var0_0.fireIndex + 1
	elseif arg1_6 == var9_0 then
		-- block empty
	elseif arg1_6 == var11_0 then
		var0_6.removeTime = var22_0
	end

	return var0_6
end

function var0_0.returnAmulete(arg0_7, arg1_7, arg2_7)
	setActive(arg1_7.tf, false)
	table.insert(arg2_7, arg1_7)
end

function var0_0.getColor(arg0_8)
	return arg0_8.amuletL.color
end

function var0_0.fireAmulet(arg0_9)
	if arg0_9.amuletL then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_FIRE)

		arg0_9.amuletPos.x = math.cos(arg0_9.rad) * var15_0
		arg0_9.amuletPos.y = math.sin(arg0_9.rad) * var15_0
		arg0_9.amuletL.tf.anchoredPosition = arg0_9.amuletPos
		arg0_9.amuletL.angle = arg0_9.angle
		arg0_9.amuletL.rad = arg0_9.rad
		arg0_9.amuletL.speed = Vector2(math.cos(arg0_9.amuletL.rad) * var17_0, math.sin(arg0_9.amuletL.rad) * var17_0)

		arg0_9.amuletL.anim:Play("L_Fire")

		findTF(arg0_9.amuletL.tf, "ad").localEulerAngles = Vector3(0, 0, arg0_9.angle + var18_0)

		if arg0_9.concentrateTime then
			arg0_9.amuletL.concentrate = true
			arg0_9.concentrateTime = arg0_9.concentrateTime - 1

			if arg0_9.concentrateTime <= 0 then
				arg0_9.concentrateTime = nil
			end
		end

		table.insert(arg0_9._amuletFires, arg0_9.amuletL)
		arg0_9:setAmuletL(nil)
	end
end

function var0_0.randomFireAmulet(arg0_10, arg1_10)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_FIRE)

	local var0_10 = arg0_10:getAmulete(var10_0, arg0_10:getRandomAmuletType())

	for iter0_10, iter1_10 in pairs(arg1_10) do
		var0_10[iter0_10] = iter1_10
	end

	local var1_10 = math.random(1, 360)
	local var2_10 = math.deg2Rad * var1_10

	var0_10.tf.anchoredPosition = Vector2(0, 0)
	var0_10.rad = arg0_10.rad
	var0_10.speed = Vector2(math.cos(var2_10) * var17_0, math.sin(var2_10) * var17_0)

	var0_10.anim:Play("L_Fire")

	findTF(var0_10.tf, "ad").localEulerAngles = Vector3(0, 0, var1_10 + var18_0)

	table.insert(arg0_10._amuletFires, var0_10)
end

function var0_0.setAmuletL(arg0_11, arg1_11)
	arg0_11.amuletL = arg1_11
	LaunchBallGameVo.amulet = arg0_11.amuletL
end

function var0_0.createEF(arg0_12, arg1_12)
	local var0_12 = arg0_12:getAmulete(var11_0, arg1_12.color)

	arg1_12.effectIndex = arg1_12.effectIndex + 1

	local var1_12 = arg1_12.effectIndex % var12_0 + 1
	local var2_12 = var13_0[var1_12].anim_name
	local var3_12 = arg1_12.tf.anchoredPosition

	var0_12.tf.anchoredPosition = var3_12

	local var4_12 = math.cos(arg1_12.rad)
	local var5_12 = math.sin(arg1_12.rad)
	local var6_12 = var13_0[var1_12].offset.x
	local var7_12 = var13_0[var1_12].offset.y
	local var8_12 = var4_12 * var6_12 - var5_12 * var7_12
	local var9_12 = var4_12 * var7_12 + var5_12 * var6_12

	findTF(var0_12.tf, "ad").anchoredPosition = Vector2(var8_12, var9_12)

	var0_12.anim:Play(var2_12)
	table.insert(arg0_12.amuletEFs, var0_12)
end

function var0_0.getRandomAmuletType(arg0_13)
	if not LaunchBallGameVo.enemyColors or #LaunchBallGameVo.enemyColors == 0 then
		return var8_0[math.random(1, #var8_0)]
	else
		return LaunchBallGameVo.enemyColors[math.random(1, #LaunchBallGameVo.enemyColors)]
	end
end

function var0_0.getAnimator(arg0_14, arg1_14, arg2_14)
	local var0_14

	if arg1_14 == var10_0 then
		var0_14 = arg0_14.amuletLAnimators
	elseif arg1_14 == var9_0 then
		var0_14 = arg0_14.amuletSAnimators
	elseif arg1_14 == var11_0 then
		var0_14 = arg0_14.amuletEFAnimators
	end

	for iter0_14 = 1, #var0_14 do
		if var0_14[iter0_14].type == arg2_14 then
			return var0_14[iter0_14].animator
		end
	end
end

function var0_0.getAmuletPos(arg0_15, arg1_15, arg2_15)
	local var0_15 = math.cos(arg2_15)
	local var1_15 = math.sin(arg2_15)
	local var2_15 = var0_15 * arg1_15
	local var3_15 = var1_15 * arg1_15

	return Vector2(var2_15, var3_15)
end

function var0_0.getAngle(arg0_16)
	return arg0_16.angle
end

function var0_0.eventCall(arg0_17, arg1_17, arg2_17)
	if arg1_17 == LaunchBallGameScene.PLAYING_CHANGE then
		arg0_17.isPlaying = arg2_17
	elseif arg1_17 == LaunchBallGameScene.FIRE_AMULET then
		arg0_17:fireAmulet()
	elseif arg1_17 == LaunchBallGameScene.RANDOM_FIRE then
		local var0_17 = arg2_17.num
		local var1_17 = arg2_17.data

		for iter0_17 = 1, var0_17 do
			arg0_17:randomFireAmulet(var1_17)
		end
	elseif arg1_17 == LaunchBallGameScene.CHANGE_AMULET then
		if arg0_17.changeTime and LaunchBallGameVo.gameStepTime - arg0_17.changeTime < 1 then
			return
		end

		if arg0_17.amuletL then
			arg0_17.changeTime = LaunchBallGameVo.gameStepTime

			arg0_17:returnAmulete(arg0_17.amuletL, arg0_17.amuletLPool)
			arg0_17:setAmuletL(nil)
		end
	elseif arg1_17 == LaunchBallGameScene.CONCENTRATE_TRIGGER then
		arg0_17.concentrateTime = arg2_17.time
	elseif arg1_17 == LaunchBallGameScene.SLEEP_TIME_TRIGGER then
		print("创建一个小蝴蝶")

		local var2_17 = arg0_17:createButterfly()
	end
end

function var0_0.getButterfly(arg0_18)
	return arg0_18.butterflys
end

function var0_0.createButterfly(arg0_19)
	local var0_19 = tf(instantiate(arg0_19._butterflyTpl))
	local var1_19 = GetComponent(findTF(var0_19, "ad/anim"), typeof(Animator))

	var0_19.anchoredPosition = Vector2(math.random(1, 20), math.random(1, 20))

	local var2_19 = math.random(1, 360)
	local var3_19 = math.deg2Rad * var2_19
	local var4_19 = Vector2(math.cos(var3_19) * var14_0, math.sin(var3_19) * var14_0)
	local var5_19 = 3
	local var6_19 = var4_19.x > 0 and -1 * var5_19 or 1 * var5_19

	findTF(var0_19, "ad/anim").localScale = Vector3(var6_19, var5_19, var5_19)

	table.insert(arg0_19.butterflys, {
		tf = var0_19,
		anim = var1_19,
		speed = var4_19
	})
	setParent(var0_19, arg0_19._content)
	setActive(var0_19, true)
end

function var0_0.clear(arg0_20)
	arg0_20:clearAmulet()
end

function var0_0.clearAmulet(arg0_21)
	if arg0_21.amuletL then
		arg0_21:returnAmulete(arg0_21.amuletL, arg0_21.amuletLPool)
		arg0_21:setAmuletL(nil)
	end

	if arg0_21.amuletS then
		arg0_21:returnAmulete(arg0_21.amuletS, arg0_21.amuletSPool)

		arg0_21.amuletS = nil
	end

	if #arg0_21.amuletEFs > 0 then
		for iter0_21 = #arg0_21.amuletEFs, 1, -1 do
			local var0_21 = table.remove(arg0_21.amuletEFs, iter0_21)

			arg0_21:returnAmulete(var0_21, arg0_21.amuletEFPool)
		end
	end

	if arg0_21.butterflys and #arg0_21.butterflys > 0 then
		for iter1_21 = #arg0_21.butterflys, 1, -1 do
			local var1_21 = arg0_21.butterflys[iter1_21].tf

			Destroy(arg0_21.butterflys[iter1_21].tf)
		end

		arg0_21.butterflys = {}
	end
end

return var0_0
