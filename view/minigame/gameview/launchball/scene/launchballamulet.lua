local var0 = class("LaunchBallAmulet")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 7
local var8 = {
	var1,
	var3,
	var4,
	var7,
	var2,
	var5,
	var6
}
local var9 = "amulet s"
local var10 = "amulet l"
local var11 = "amulet ef"
local var12 = 3
local var13 = {
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
local var14 = 50
local var15 = 70
local var16 = -80
local var17 = 1000
local var18 = 90
local var19 = -90
local var20 = 1000
local var21 = 0.05
local var22 = 0.5
local var23 = {
	[var1] = {
		name = "Yellow",
		animator = "Amulet_Yellow_"
	},
	[var3] = {
		name = "White",
		animator = "Amulet_White_"
	},
	[var4] = {
		name = "Red",
		animator = "Amulet_Red_"
	},
	[var7] = {
		name = "Purple",
		animator = "Amulet_Purple_"
	},
	[var2] = {
		name = "Green",
		animator = "Amulet_Green_"
	},
	[var5] = {
		name = "Blue",
		animator = "Amulet_Blue_"
	},
	[var6] = {
		name = "Black",
		animator = "Amulet_Black_"
	}
}

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.amuletLAnimators = {}
	arg0.amuletSAnimators = {}
	arg0.amuletEFAnimators = {}

	for iter0, iter1 in ipairs(var23) do
		local var0 = iter0
		local var1 = iter1.name
		local var2 = iter1.animator
		local var3 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2 .. "L", typeof(RuntimeAnimatorController), false, false)
		local var4 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2 .. "S", typeof(RuntimeAnimatorController), false, false)
		local var5 = ResourceMgr.Inst:getAssetSync(LaunchBallGameVo.ui_atlas, var2 .. "EF", typeof(RuntimeAnimatorController), false, false)

		table.insert(arg0.amuletLAnimators, {
			animator = var3,
			type = var0,
			name = var1
		})
		table.insert(arg0.amuletSAnimators, {
			animator = var4,
			type = var0,
			name = var1
		})
		table.insert(arg0.amuletEFAnimators, {
			animator = var5,
			type = var0,
			name = var1
		})
	end

	arg0._content = arg1
	arg0._sContent = arg2
	arg0._lifeContent = arg3
	arg0._tpl = arg4
	arg0._eventCall = arg5
	arg0._amuletLTpl = findTF(arg0._tpl, "amuletL")
	arg0._amuletSTpl = findTF(arg0._tpl, "amuletS")
	arg0._amuletEfTpl = findTF(arg0._tpl, "amuletEF")
	arg0._butterflyTpl = findTF(arg0._tpl, "Butterfly")

	arg0:setAmuletL(nil)

	arg0.amuletS = nil
	arg0.amuletEFs = {}
	arg0.amuletLPool = {}
	arg0.amuletSPool = {}
	arg0.amuletEFPool = {}
	arg0._amuletFires = {}
	arg0.butterflys = {}
end

function var0.start(arg0)
	local var0 = LaunchBallGameVo.gameRoundData.amulet_life

	arg0.lifeBound = GetComponent(findTF(arg0._lifeContent, tostring(var0)), typeof(BoxCollider2D))
	arg0.min = arg0._lifeContent:InverseTransformPoint(arg0.lifeBound.bounds.min)
	arg0.max = arg0._lifeContent:InverseTransformPoint(arg0.lifeBound.bounds.max)
	arg0.amuletType = arg0:getRandomAmuletType()
	arg0.amuletNextType = arg0:getRandomAmuletType()

	arg0:setAmuletL(arg0:getAmulete(var10, arg0.amuletType))

	arg0.amuletS = arg0:getAmulete(var9, arg0.amuletNextType)
	arg0.amuletPos = Vector2(0, 0)
	arg0.angle = var19
	arg0.rad = var19 * math.deg2Rad
	arg0.amuletPos.x = math.cos(arg0.rad) * var15
	arg0.amuletPos.y = math.sin(arg0.rad) * var15
	arg0.isPlaying = false
end

function var0.step(arg0)
	if not arg0.isPlaying then
		if LaunchBallGameVo.joyStickData and LaunchBallGameVo.joyStickData.angle then
			arg0.rad = LaunchBallGameVo.joyStickData.rad
			arg0.angle = LaunchBallGameVo.joyStickData.angle
			arg0.amuletPos.x = math.cos(arg0.rad) * var15
			arg0.amuletPos.y = math.sin(arg0.rad) * var15
		end

		if arg0.amuletL then
			arg0.amuletL.tf.anchoredPosition = arg0.amuletPos
			arg0.amuletL.rad = arg0.rad
		else
			arg0:setAmuletL(arg0:getAmulete(var10, arg0.amuletNextType))
			arg0:returnAmulete(arg0.amuletS, arg0.amuletSPool)

			arg0.amuletNextType = arg0:getRandomAmuletType()
			arg0.amuletS = nil
			arg0.amuletS = arg0:getAmulete(var9, arg0.amuletNextType)
		end

		if arg0.amuletS then
			arg0.amuletS.tf.anchoredPosition = Vector2(math.cos(arg0.rad) * var16, math.sin(arg0.rad) * var16)
		end
	end

	if arg0._amuletFires and #arg0._amuletFires > 0 then
		for iter0 = #arg0._amuletFires, 1, -1 do
			local var0 = arg0._amuletFires[iter0]
			local var1 = var0.tf.anchoredPosition

			var1.x = var1.x + var0.speed.x * LaunchBallGameVo.deltaTime
			var1.y = var1.y + var0.speed.y * LaunchBallGameVo.deltaTime
			var0.tf.anchoredPosition = var1

			if var0.effectTime and var0.effectTime > 0 then
				var0.effectTime = var0.effectTime - LaunchBallGameVo.deltaTime

				if var0.effectTime <= 0 then
					var0.effectTime = var21

					arg0:createEF(var0)
				end
			end

			if math.abs(var1.x) > var20 or math.abs(var1.y) > var20 then
				table.remove(arg0._amuletFires, iter0)
				arg0:returnAmulete(var0, arg0.amuletLPool)
			elseif var0.removeFlag then
				table.remove(arg0._amuletFires, iter0)
				arg0:returnAmulete(var0, arg0.amuletLPool)
			elseif arg0.lifeBound then
				if var1.x >= arg0.max.x or var1.x <= arg0.min.x then
					table.remove(arg0._amuletFires, iter0)
					arg0:returnAmulete(var0, arg0.amuletLPool)
				elseif var1.y >= arg0.max.y or var1.y <= arg0.min.y then
					table.remove(arg0._amuletFires, iter0)
					arg0:returnAmulete(var0, arg0.amuletLPool)
				end
			end
		end
	end

	if arg0.butterflys and #arg0.butterflys > 0 then
		for iter1 = #arg0.butterflys, 1, -1 do
			local var2 = arg0.butterflys[iter1]
			local var3 = var2.tf.anchoredPosition

			var3.x = var3.x + var2.speed.x * LaunchBallGameVo.deltaTime
			var3.y = var3.y + var2.speed.y * LaunchBallGameVo.deltaTime
			var2.tf.anchoredPosition = var3

			if math.abs(var3.x) > var20 or math.abs(var3.y) > var20 then
				var2.anim = nil

				Destroy(var2.tf)
				table.remove(arg0.butterflys, iter1)
			elseif var2.removeFlag then
				var2.anim = nil

				Destroy(var2.tf)
				table.remove(arg0.butterflys, iter1)
			elseif var3.x >= arg0.max.x or var3.x <= arg0.min.x then
				var2.anim = nil

				Destroy(var2.tf)
				table.remove(arg0.butterflys, iter1)
			elseif var3.y >= arg0.max.y or var3.y <= arg0.min.y then
				var2.anim = nil

				Destroy(var2.tf)
				table.remove(arg0.butterflys, iter1)
			elseif var2.removeTime and var2.removeTime > 0 then
				var2.removeTime = var2.removeTime - LaunchBallGameVo.deltaTime

				if var2.removeTime < 0 then
					var2.removeTime = nil
					var2.removeFlag = true
				end
			end
		end
	end

	if arg0.amuletEFs and #arg0.amuletEFs > 0 then
		for iter2 = #arg0.amuletEFs, 1, -1 do
			local var4 = arg0.amuletEFs[iter2]

			if var4.removeTime and var4.removeTime > 0 then
				var4.removeTime = var4.removeTime - LaunchBallGameVo.deltaTime

				if var4.removeTime <= 0 then
					table.remove(arg0.amuletEFs, iter2)
					arg0:returnAmulete(var4, arg0.amuletEFPool)
				end
			end
		end
	end
end

function var0.getFireAmulet(arg0)
	return arg0._amuletFires
end

function var0.removeFireAmulet(arg0, arg1)
	if arg0._amuletFires and #arg0._amuletFires > 0 then
		for iter0 = #arg0._amuletFires, 1, -1 do
			local var0 = arg0._amuletFires[iter0]

			if var0 then
				table.remove(arg0._amuletFires, iter0)
				arg0:returnAmulete(var0, arg0.amuletLPool)
			end
		end
	end
end

var0.fireIndex = 0

function var0.getAmulete(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3
	local var4 = arg0._content

	if arg1 == var10 then
		var1 = arg0.amuletLPool
		var2 = arg0._amuletLTpl
		var3 = Vector2(0, var15)
	elseif arg1 == var9 then
		var1 = arg0.amuletSPool
		var2 = arg0._amuletSTpl
		var3 = Vector2(0, var16)
		var4 = arg0._sContent
	elseif arg1 == var11 then
		var1 = arg0.amuletEFPool
		var2 = arg0._amuletEfTpl
		var3 = Vector2(0, 0)
	end

	if not var1 then
		return
	end

	for iter0 = 1, #var1 do
		var0 = var0 or table.remove(var1, iter0)
	end

	if not var0 then
		local var5 = tf(instantiate(var2))
		local var6 = findTF(var5, "ad/anim")
		local var7 = GetComponent(findTF(var5, "ad/anim"), typeof(Animator))

		setParent(var5, var4)

		var0 = {
			tf = var5,
			type = arg1,
			anim = var7,
			animTf = var6
		}
	end

	var0.angle = nil
	var0.fire = nil

	setActive(var0.tf, true)

	var0.tf.anchoredPosition = var3
	var0.anim.runtimeAnimatorController = arg0:getAnimator(arg1, arg2)
	var0.tf.name = arg1 .. "_" .. var23[arg2].name
	var0.color = arg2
	findTF(var0.tf, "ad").localRotation = Quaternion.Euler(0, 0, 0)
	var0.removeFlag = false

	if arg1 == var10 then
		var0.effectTime = var21
		var0.effectIndex = 1
		var0[LaunchBallGameConst.amulet_buff_back] = false
		var0.concentrate = false
		var0.fireIndex = var0.fireIndex
		var0.overFlag = false
		var0.overCount = 0
		var0.fireIndex = var0.fireIndex + 1
	elseif arg1 == var9 then
		-- block empty
	elseif arg1 == var11 then
		var0.removeTime = var22
	end

	return var0
end

function var0.returnAmulete(arg0, arg1, arg2)
	setActive(arg1.tf, false)
	table.insert(arg2, arg1)
end

function var0.getColor(arg0)
	return arg0.amuletL.color
end

function var0.fireAmulet(arg0)
	if arg0.amuletL then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_FIRE)

		arg0.amuletPos.x = math.cos(arg0.rad) * var15
		arg0.amuletPos.y = math.sin(arg0.rad) * var15
		arg0.amuletL.tf.anchoredPosition = arg0.amuletPos
		arg0.amuletL.angle = arg0.angle
		arg0.amuletL.rad = arg0.rad
		arg0.amuletL.speed = Vector2(math.cos(arg0.amuletL.rad) * var17, math.sin(arg0.amuletL.rad) * var17)

		arg0.amuletL.anim:Play("L_Fire")

		findTF(arg0.amuletL.tf, "ad").localEulerAngles = Vector3(0, 0, arg0.angle + var18)

		if arg0.concentrateTime then
			arg0.amuletL.concentrate = true
			arg0.concentrateTime = arg0.concentrateTime - 1

			if arg0.concentrateTime <= 0 then
				arg0.concentrateTime = nil
			end
		end

		table.insert(arg0._amuletFires, arg0.amuletL)
		arg0:setAmuletL(nil)
	end
end

function var0.randomFireAmulet(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(LaunchBallGameVo.SFX_FIRE)

	local var0 = arg0:getAmulete(var10, arg0:getRandomAmuletType())

	for iter0, iter1 in pairs(arg1) do
		var0[iter0] = iter1
	end

	local var1 = math.random(1, 360)
	local var2 = math.deg2Rad * var1

	var0.tf.anchoredPosition = Vector2(0, 0)
	var0.rad = arg0.rad
	var0.speed = Vector2(math.cos(var2) * var17, math.sin(var2) * var17)

	var0.anim:Play("L_Fire")

	findTF(var0.tf, "ad").localEulerAngles = Vector3(0, 0, var1 + var18)

	table.insert(arg0._amuletFires, var0)
end

function var0.setAmuletL(arg0, arg1)
	arg0.amuletL = arg1
	LaunchBallGameVo.amulet = arg0.amuletL
end

function var0.createEF(arg0, arg1)
	local var0 = arg0:getAmulete(var11, arg1.color)

	arg1.effectIndex = arg1.effectIndex + 1

	local var1 = arg1.effectIndex % var12 + 1
	local var2 = var13[var1].anim_name
	local var3 = arg1.tf.anchoredPosition

	var0.tf.anchoredPosition = var3

	local var4 = math.cos(arg1.rad)
	local var5 = math.sin(arg1.rad)
	local var6 = var13[var1].offset.x
	local var7 = var13[var1].offset.y
	local var8 = var4 * var6 - var5 * var7
	local var9 = var4 * var7 + var5 * var6

	findTF(var0.tf, "ad").anchoredPosition = Vector2(var8, var9)

	var0.anim:Play(var2)
	table.insert(arg0.amuletEFs, var0)
end

function var0.getRandomAmuletType(arg0)
	if not LaunchBallGameVo.enemyColors or #LaunchBallGameVo.enemyColors == 0 then
		return var8[math.random(1, #var8)]
	else
		return LaunchBallGameVo.enemyColors[math.random(1, #LaunchBallGameVo.enemyColors)]
	end
end

function var0.getAnimator(arg0, arg1, arg2)
	local var0

	if arg1 == var10 then
		var0 = arg0.amuletLAnimators
	elseif arg1 == var9 then
		var0 = arg0.amuletSAnimators
	elseif arg1 == var11 then
		var0 = arg0.amuletEFAnimators
	end

	for iter0 = 1, #var0 do
		if var0[iter0].type == arg2 then
			return var0[iter0].animator
		end
	end
end

function var0.getAmuletPos(arg0, arg1, arg2)
	local var0 = math.cos(arg2)
	local var1 = math.sin(arg2)
	local var2 = var0 * arg1
	local var3 = var1 * arg1

	return Vector2(var2, var3)
end

function var0.getAngle(arg0)
	return arg0.angle
end

function var0.eventCall(arg0, arg1, arg2)
	if arg1 == LaunchBallGameScene.PLAYING_CHANGE then
		arg0.isPlaying = arg2
	elseif arg1 == LaunchBallGameScene.FIRE_AMULET then
		arg0:fireAmulet()
	elseif arg1 == LaunchBallGameScene.RANDOM_FIRE then
		local var0 = arg2.num
		local var1 = arg2.data

		for iter0 = 1, var0 do
			arg0:randomFireAmulet(var1)
		end
	elseif arg1 == LaunchBallGameScene.CHANGE_AMULET then
		if arg0.changeTime and LaunchBallGameVo.gameStepTime - arg0.changeTime < 1 then
			return
		end

		if arg0.amuletL then
			arg0.changeTime = LaunchBallGameVo.gameStepTime

			arg0:returnAmulete(arg0.amuletL, arg0.amuletLPool)
			arg0:setAmuletL(nil)
		end
	elseif arg1 == LaunchBallGameScene.CONCENTRATE_TRIGGER then
		arg0.concentrateTime = arg2.time
	elseif arg1 == LaunchBallGameScene.SLEEP_TIME_TRIGGER then
		print("创建一个小蝴蝶")

		local var2 = arg0:createButterfly()
	end
end

function var0.getButterfly(arg0)
	return arg0.butterflys
end

function var0.createButterfly(arg0)
	local var0 = tf(instantiate(arg0._butterflyTpl))
	local var1 = GetComponent(findTF(var0, "ad/anim"), typeof(Animator))

	var0.anchoredPosition = Vector2(math.random(1, 20), math.random(1, 20))

	local var2 = math.random(1, 360)
	local var3 = math.deg2Rad * var2
	local var4 = Vector2(math.cos(var3) * var14, math.sin(var3) * var14)
	local var5 = 3
	local var6 = var4.x > 0 and -1 * var5 or 1 * var5

	findTF(var0, "ad/anim").localScale = Vector3(var6, var5, var5)

	table.insert(arg0.butterflys, {
		tf = var0,
		anim = var1,
		speed = var4
	})
	setParent(var0, arg0._content)
	setActive(var0, true)
end

function var0.clear(arg0)
	arg0:clearAmulet()
end

function var0.clearAmulet(arg0)
	if arg0.amuletL then
		arg0:returnAmulete(arg0.amuletL, arg0.amuletLPool)
		arg0:setAmuletL(nil)
	end

	if arg0.amuletS then
		arg0:returnAmulete(arg0.amuletS, arg0.amuletSPool)

		arg0.amuletS = nil
	end

	if #arg0.amuletEFs > 0 then
		for iter0 = #arg0.amuletEFs, 1, -1 do
			local var0 = table.remove(arg0.amuletEFs, iter0)

			arg0:returnAmulete(var0, arg0.amuletEFPool)
		end
	end

	if arg0.butterflys and #arg0.butterflys > 0 then
		for iter1 = #arg0.butterflys, 1, -1 do
			local var1 = arg0.butterflys[iter1].tf

			Destroy(arg0.butterflys[iter1].tf)
		end

		arg0.butterflys = {}
	end
end

return var0
