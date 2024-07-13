local var0_0 = class("Fushun3CharController")
local var1_0 = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._rectCollider = arg1_1
	arg0_1._charTf = arg2_1
	arg0_1._anim = findTF(arg0_1._charTf, "anim")
	arg0_1._pos = findTF(arg0_1._charTf, "pos")
	arg0_1._itemPos = findTF(arg0_1._charTf, "itemPos")
	arg0_1._dftEvent = GetOrAddComponent(arg0_1._anim, typeof(DftAniEvent))
	arg0_1._effectPos = findTF(arg0_1._charTf, "effectPos")
	arg0_1._effectFrPos = findTF(arg0_1._charTf, "effectFrPos")
	arg0_1._effectBkPos = findTF(arg0_1._charTf, "effectBkPos")
	arg0_1._powerSlider = arg4_1

	arg0_1._dftEvent:SetTriggerEvent(function()
		local var0_2
		local var1_2 = arg0_1._animator:GetCurrentAnimatorClipInfo(0)

		if var1_2 and var1_2.Length > 0 then
			var0_2 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.AnimatorClipInfo"), "clip", var1_2[0])
		end

		if var0_2 then
			arg0_1._event:emit(Fushun3GameEvent.add_anim_effect_call, {
				clipName = var0_2.name,
				targetTf = arg0_1._effectPos
			})
		end
	end)

	arg0_1._charItemCatchTf = findTF(arg0_1._effectPos, "charItem")
	arg0_1._charItemCatch = GetComponent(findTF(arg0_1._charItemCatchTf, "catch"), typeof(Animator))
	arg0_1._charShieldTf = findTF(arg0_1._effectPos, "shield")
	arg0_1._collisionInfo = arg3_1
	arg0_1._event = arg5_1
	arg0_1._animator = GetComponent(arg0_1._anim, typeof(Animator))
	arg0_1._powerScript = arg0_1._rectCollider:getScript(FuShunPowerSpeedScript)
	arg0_1._jumpScript = arg0_1._rectCollider:getScript(FuShunJumpScript)
	arg0_1._damageScript = arg0_1._rectCollider:getScript(FuShunDamageScript)
	arg0_1._attackScript = arg0_1._rectCollider:getScript(FuShunAttakeScript)
	arg0_1._monsterLayer = LayerMask.NameToLayer("Character")
	arg0_1._damageTf = findTF(arg0_1._charTf, "damage")
	arg0_1._damageCollider = GetComponent(arg0_1._damageTf, typeof(BoxCollider2D))
	arg0_1._attackCd = nil

	arg0_1._event:bind(Fushun3GameEvent.script_jump_event, function()
		if arg0_1._attackCd == 0 and arg0_1.damageCd == 0 and arg0_1._animator then
			arg0_1._animator:SetTrigger("jump")
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_JUMP)
		end
	end)
	arg0_1._event:bind(Fushun3GameEvent.script_attack_event, function()
		if arg0_1._attackCd == 0 and arg0_1.damageCd == 0 then
			arg0_1._animator:SetTrigger("attack")

			arg0_1._attackCd = Fushun3GameConst.attack_cd

			if arg0_1:getBuff(Fushun3GameConst.buff_weapon) then
				local var0_4 = math.random(1, 30) == 1 and "tamachan" or "rocket"

				arg0_1._event:emit(Fushun3GameEvent.create_item_call, {
					name = var0_4,
					pos = arg0_1._itemPos.position
				})
				arg0_1._charItemCatch:SetTrigger("attack")
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_ATTACK)

				arg0_1._attackTime = Fushun3GameConst.attack_time
			end
		end
	end)
	arg0_1._event:bind(Fushun3GameEvent.script_power_event, function(arg0_5, arg1_5, arg2_5)
		arg0_1._animator:SetTrigger("ex")
		arg0_1._charItemCatch:SetTrigger("ex")
	end)

	arg0_1.damageCd = 0
	arg0_1.buffList = {}

	if Application.isEditor then
		if not arg0_1.handle then
			arg0_1.handle = UpdateBeat:CreateListener(function()
				if Input.GetKeyDown(KeyCode.Y) then
					local var0_6 = 1

					if arg0_1:getBuffById(Fushun3GameConst.buff_data[var0_6].id) then
						arg0_1:removeBuff(Clone(Fushun3GameConst.buff_data[var0_6]))
					else
						arg0_1:addBuff(Clone(Fushun3GameConst.buff_data[var0_6]))
					end
				elseif Input.GetKeyDown(KeyCode.U) then
					local var1_6 = 2
					local var2_6 = Fushun3GameConst.buff_data[var1_6]

					if arg0_1:getBuffById(var2_6.id) then
						arg0_1:removeBuff(Clone(Fushun3GameConst.buff_data[var1_6]))
					else
						arg0_1:addBuff(Clone(Fushun3GameConst.buff_data[var1_6]))
					end
				elseif Input.GetKeyDown(KeyCode.I) then
					local var3_6 = 4

					if arg0_1:getBuffById(Fushun3GameConst.buff_data[var3_6].id) then
						arg0_1:removeBuff(Clone(Fushun3GameConst.buff_data[var3_6]))
					else
						arg0_1:addBuff(Clone(Fushun3GameConst.buff_data[var3_6]))
					end
				elseif Input.GetKeyDown(KeyCode.O) then
					local var4_6 = 5

					arg0_1:addBuff(Clone(Fushun3GameConst.buff_data[var4_6]))
				end
			end, arg0_1)
		end

		UpdateBeat:AddListener(arg0_1.handle, arg0_1)
	end
end

function var0_0.start(arg0_7)
	arg0_7._animator:SetBool("la", false)
	arg0_7._animator:SetBool("s", false)
	arg0_7._animator:SetBool("below", arg0_7._collisionInfo.below)

	arg0_7._attackCd = Fushun3GameConst.attack_cd
	arg0_7._charTf.anchoredPosition = Fushun3GameConst.char_init_pos
	arg0_7.buffList = {}
	arg0_7._attackTime = 0
	arg0_7.power = 0
	arg0_7._powerTime = 0
	arg0_7.powerFlag = false
	arg0_7.shieldNum = 0

	arg0_7:updateBuffShow(Fushun3GameConst.buff_shield)

	arg0_7.heart = Fushun3GameConst.heart_num

	setActive(arg0_7._charItemCatchTf, false)
end

function var0_0.step(arg0_8)
	if arg0_8._charTf.anchoredPosition.y >= 1200 or arg0_8._charTf.anchoredPosition.y <= -200 then
		if arg0_8._powerTime > 0 then
			arg0_8._charTf.anchoredPosition = Vector2(arg0_8._charTf.anchoredPosition.x + 100, 1000)
		else
			arg0_8._event:emit(Fushun3GameEvent.game_over_call)
		end

		return
	end

	arg0_8._powerSlider.value = arg0_8.power / Fushun3GameConst.power_max_num

	arg0_8._animator:SetBool("below", arg0_8._collisionInfo.below)

	local var0_8 = arg0_8._collisionInfo:getVelocity()

	arg0_8._animator:SetFloat("moveAmountX", var0_8.x)
	arg0_8._animator:SetFloat("moveAmountY", var0_8.y)

	if arg0_8._attackCd > 0 then
		arg0_8._attackCd = arg0_8._attackCd - Time.deltaTime
		arg0_8._attackCd = arg0_8._attackCd < 0 and 0 or arg0_8._attackCd
	end

	if arg0_8._powerTime > 0 then
		arg0_8._powerTime = arg0_8._powerTime - Time.deltaTime

		if arg0_8._powerTime < 0 then
			arg0_8._powerTime = 0
		end
	end

	for iter0_8 = #arg0_8.buffList, 1, -1 do
		local var1_8 = arg0_8.buffList[iter0_8]

		if var1_8.time then
			var1_8.time = var1_8.time - Time.deltaTime

			if var1_8.time <= 0 then
				arg0_8:removeBuff(var1_8)
			end
		end
	end

	local var2_8 = {}

	for iter1_8, iter2_8 in pairs(arg0_8._collisionInfo.horizontalLeftTfs) do
		table.insert(var2_8, iter2_8)
	end

	for iter3_8, iter4_8 in pairs(arg0_8._collisionInfo.horizontalRightTfs) do
		table.insert(var2_8, iter4_8)
	end

	local var3_8 = {}

	for iter5_8, iter6_8 in pairs(arg0_8._collisionInfo.verticalBottomTfs) do
		table.insert(var3_8, iter6_8)
	end

	if #var2_8 > 0 then
		if arg0_8:getBuff(Fushun3GameConst.buff_power_speed) then
			for iter7_8 = 1, #var2_8 do
				if go(var2_8[iter7_8]).layer == arg0_8._monsterLayer then
					arg0_8._event:emit(Fushun3GameEvent.power_damage_monster_call, {
						tf = var2_8[iter7_8]
					})
				end
			end
		else
			for iter8_8 = 1, #var2_8 do
				if arg0_8._powerTime == 0 and go(var2_8[iter8_8]).layer == arg0_8._monsterLayer and arg0_8.damageCd == 0 then
					arg0_8._event:emit(Fushun3GameEvent.check_player_damage, {
						tf = var2_8[iter8_8],
						callback = function(arg0_9)
							if not arg0_9 then
								arg0_8:damageChar()
							end
						end
					})
				elseif findTF(var2_8[iter8_8], "high_roof") then
					setActive(findTF(var2_8[iter8_8], "high_roof"), false)
					arg0_8._collisionInfo:changeVelocity(0, arg0_8._collisionInfo.config.minJumpVelocity, nil)

					if arg0_8._powerTime == 0 and arg0_8.damageCd == 0 then
						arg0_8:damageChar()
					end
				end
			end
		end
	elseif var3_8 and #var3_8 > 0 then
		for iter9_8 = 1, #var3_8 do
			if go(var3_8[iter9_8]).layer == arg0_8._monsterLayer then
				if arg0_8:getBuff(Fushun3GameConst.buff_speed) then
					arg0_8._event:emit(Fushun3GameEvent.kick_damage_monster_call, {
						tf = var3_8[iter9_8],
						callback = function(arg0_10)
							if arg0_10 then
								arg0_8._collisionInfo:changeVelocity(nil, arg0_8._collisionInfo.config.minJumpVelocity, nil)
							end
						end
					})
				else
					arg0_8._event:emit(Fushun3GameEvent.check_player_damage, {
						tf = var2_8[iter9_8],
						callback = function(arg0_11)
							if not arg0_11 then
								arg0_8:damageChar()
							end
						end
					})
				end
			end
		end
	end

	arg0_8:flushBuff()

	if arg0_8.damageCd > 0 then
		arg0_8.damageCd = arg0_8.damageCd - Time.deltaTime
		arg0_8.damageCd = arg0_8.damageCd <= 0 and 0 or arg0_8.damageCd
	end

	if arg0_8._attackTime > 0 then
		arg0_8._event:emit(Fushun3GameEvent.player_attack_call, {
			collider = arg0_8._damageCollider,
			callback = function(arg0_12)
				if arg0_12 then
					arg0_8._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = "EF_fr_Attack",
						targetTf = arg0_8._effectPos
					})
				end
			end
		})

		arg0_8._attackTime = arg0_8._attackTime - Time.deltaTime
		arg0_8._attackTime = arg0_8._attackTime <= 0 and 0 or arg0_8._attackTime
	end

	if arg0_8.power == Fushun3GameConst.power_max_num and not arg0_8.powerFlag and arg0_8._charTf.anchoredPosition.y >= 200 then
		arg0_8.powerFlag = true

		arg0_8._event:emit(Fushun3GameEvent.power_speed_call)

		if not arg0_8.powerBuff then
			for iter10_8 = 1, #Fushun3GameConst.buff_data do
				if Fushun3GameConst.buff_data[iter10_8].buff == Fushun3GameConst.buff_power_speed then
					arg0_8.powerBuff = Clone(Fushun3GameConst.buff_data[iter10_8])
				end
			end
		end

		arg0_8:addBuff(Clone(arg0_8.powerBuff))
	end

	if arg0_8.powerFlag then
		arg0_8.power = arg0_8.power - Fushun3GameConst.power_sub_time * Time.deltaTime

		if arg0_8.power <= 0 then
			arg0_8.power = 0
			arg0_8.powerFlag = false

			arg0_8:removeBuff(Clone(arg0_8.powerBuff))
		end
	elseif arg0_8.power >= Fushun3GameConst.power_max_num then
		arg0_8.power = Fushun3GameConst.power_max_num
	end
end

function var0_0.jump(arg0_13)
	if arg0_13._jumpScript:checkScirptApply() then
		arg0_13._jumpScript:active(true)
	end
end

function var0_0.attack(arg0_14)
	if arg0_14._attackScript:checkScirptApply() then
		arg0_14._attackScript:active(true)
	end
end

function var0_0.damageChar(arg0_15)
	if arg0_15._damageScript:checkScirptApply() then
		arg0_15._damageScript:active(true)

		if arg0_15.damageCd == 0 then
			if arg0_15.shieldNum > 0 then
				arg0_15.shieldNum = arg0_15.shieldNum - 1

				arg0_15._animator:SetTrigger("damage")
				arg0_15:updateBuffShow(Fushun3GameConst.buff_shield)
				arg0_15._event:emit(Fushun3GameEvent.add_effect_call, {
					effectName = "EF_Barrier_Break",
					targetTf = arg0_15._effectPos
				})
			else
				arg0_15.heart = arg0_15.heart - 1

				if arg0_15.heart <= 0 then
					arg0_15.heart = 0
				end

				if arg0_15.heart == 0 then
					arg0_15._animator:SetTrigger("down")
				elseif #arg0_15.buffList > 0 then
					arg0_15:removeBuff(arg0_15.buffList[math.random(1, #arg0_15.buffList)], true)
					arg0_15._animator:SetTrigger("respawn")
				else
					arg0_15._animator:SetTrigger("damage")
				end
			end

			arg0_15.damageCd = Fushun3GameConst.damage_cd

			if arg0_15._attackTime > 0 then
				arg0_15._attackTime = 0
			end

			arg0_15._event:emit(Fushun3GameEvent.char_damaged_call)
		end
	end
end

function var0_0.addPower(arg0_16, arg1_16)
	if not arg0_16.powerFlag then
		arg0_16.power = arg0_16.power + arg1_16
	end
end

function var0_0.getBuff(arg0_17, arg1_17)
	for iter0_17 = 1, #arg0_17.buffList do
		if arg0_17.buffList[iter0_17].buff == arg1_17 then
			return arg0_17.buffList[iter0_17]
		end
	end

	return nil
end

function var0_0.getBuffById(arg0_18, arg1_18)
	for iter0_18 = 1, #arg0_18.buffList do
		if arg0_18.buffList[iter0_18].id == arg1_18 then
			return arg0_18.buffList[iter0_18]
		end
	end

	return nil
end

function var0_0.setBuff(arg0_19, arg1_19)
	local var0_19 = arg1_19.buff_id
	local var1_19

	for iter0_19 = 1, #Fushun3GameConst.buff_data do
		if Fushun3GameConst.buff_data[iter0_19].id == var0_19 then
			var1_19 = Fushun3GameConst.buff_data[iter0_19]
		end
	end

	if var1_19 then
		arg0_19:addBuff(Clone(var1_19))
	end
end

function var0_0.addBuff(arg0_20, arg1_20)
	for iter0_20 = 1, #arg0_20.buffList do
		if arg0_20.buffList[iter0_20].id == arg1_20.id then
			if arg1_20.buff == Fushun3GameConst.buff_shield then
				if arg0_20.shieldNum == var1_0 then
					return
				end
			else
				return
			end
		end
	end

	local var0_20 = arg0_20:getItemTriggerFlag()

	if arg1_20.buff == Fushun3GameConst.buff_speed then
		arg0_20._animator:SetBool("s", true)

		arg0_20._collisionInfo.config.moveSpeed = Fushun3GameConst.move_speed_shoose

		if not var0_20 then
			arg0_20._animator:SetTrigger("item")
		end
	elseif arg1_20.buff == Fushun3GameConst.buff_power_speed then
		if arg0_20._powerScript:checkScirptApply() then
			arg0_20._powerScript:active(true)
			arg0_20._animator:SetTrigger("ex_on")
			arg0_20._charItemCatch:SetTrigger("ex_on")
		end
	elseif arg1_20.buff == Fushun3GameConst.buff_weapon then
		arg0_20._animator:SetBool("la", true)

		if not var0_20 then
			arg0_20._animator:SetTrigger("item")
		end
	elseif arg1_20.buff == Fushun3GameConst.buff_catch then
		setActive(arg0_20._charItemCatchTf, true)
		arg0_20._charItemCatch:SetTrigger("ride")
	elseif arg1_20.buff == Fushun3GameConst.buff_shield then
		arg0_20.shieldNum = arg0_20.shieldNum + 1

		if arg0_20.shieldNum > var1_0 then
			arg0_20.shieldNum = var1_0
		end

		arg0_20:updateBuffShow(Fushun3GameConst.buff_shield)
		arg0_20._event:emit(Fushun3GameEvent.add_effect_call, {
			effectName = "EF_Barrier_Get",
			targetTf = arg0_20._effectPos
		})
	end

	table.insert(arg0_20.buffList, arg1_20)
end

function var0_0.updateBuffShow(arg0_21, arg1_21)
	if arg1_21 == Fushun3GameConst.buff_shield then
		for iter0_21 = 1, var1_0 do
			local var0_21 = iter0_21
			local var1_21 = findTF(arg0_21._charShieldTf, tostring(var0_21))

			setActive(var1_21, var0_21 <= arg0_21.shieldNum)
			setActive(findTF(arg0_21._effectFrPos, "Barrier/" .. tostring(var0_21)), arg0_21.shieldNum == var0_21)
			setActive(findTF(arg0_21._effectBkPos, "Barrier/" .. tostring(var0_21)), arg0_21.shieldNum == var0_21)
		end

		setActive(arg0_21._charShieldTf, false)
		setActive(arg0_21._charShieldTf, true)
	end
end

function var0_0.removeBuff(arg0_22, arg1_22, arg2_22)
	for iter0_22 = 1, #arg0_22.buffList do
		local var0_22 = arg0_22.buffList[iter0_22]

		if var0_22.buff == arg1_22.buff then
			local var1_22 = arg0_22:getItemTriggerFlag()

			if var0_22.buff == Fushun3GameConst.buff_speed then
				arg0_22._animator:SetBool("s", false)

				arg0_22._collisionInfo.config.moveSpeed = Fushun3GameConst.move_speed

				if not var1_22 and not arg2_22 then
					arg0_22._animator:SetTrigger("item")
				end
			elseif var0_22.buff == Fushun3GameConst.buff_power_speed then
				arg0_22._powerScript:active(false)
				arg0_22._animator:SetTrigger("ex_off")
				arg0_22._charItemCatch:SetTrigger("ex_off")

				arg0_22._powerTime = Fushun3GameConst.power_time
			elseif var0_22.buff == Fushun3GameConst.buff_weapon then
				arg0_22._animator:SetBool("la", false)

				if not var1_22 and not arg2_22 then
					arg0_22._animator:SetTrigger("item")
				end
			elseif var0_22.buff == Fushun3GameConst.buff_catch then
				setActive(arg0_22._charItemCatchTf, false)
			end

			table.remove(arg0_22.buffList, iter0_22)

			return
		end
	end
end

function var0_0.flushBuff(arg0_23)
	for iter0_23 = 1, #arg0_23.buffList do
		local var0_23 = arg0_23.buffList[iter0_23]

		if var0_23.buff == Fushun3GameConst.buff_speed then
			-- block empty
		elseif var0_23.buff == Fushun3GameConst.buff_power_speed then
			-- block empty
		elseif var0_23.buff == Fushun3GameConst.buff_weapon then
			-- block empty
		elseif var0_23.buff == Fushun3GameConst.buff_catch then
			local var1_23 = arg0_23._charTf.anchoredPosition

			var1_23.y = var1_23.y + arg0_23._itemPos.anchoredPosition.y

			arg0_23._event:emit(Fushun3GameEvent.item_follow_call, {
				anchoredPos = var1_23
			})
		end
	end
end

function var0_0.getHeart(arg0_24)
	return arg0_24.heart
end

function var0_0.getItemTriggerFlag(arg0_25)
	for iter0_25 = 1, #arg0_25.buffList do
		if arg0_25.buffList[iter0_25].lock_item then
			return true
		end
	end

	return false
end

function var0_0.dispose(arg0_26)
	if Application.isEditor then
		UpdateBeat:RemoveListener(arg0_26.handle)

		arg0_26.handle = nil
	end
end

return var0_0
