local var0 = class("Fushun3CharController")
local var1 = 3

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._rectCollider = arg1
	arg0._charTf = arg2
	arg0._anim = findTF(arg0._charTf, "anim")
	arg0._pos = findTF(arg0._charTf, "pos")
	arg0._itemPos = findTF(arg0._charTf, "itemPos")
	arg0._dftEvent = GetOrAddComponent(arg0._anim, typeof(DftAniEvent))
	arg0._effectPos = findTF(arg0._charTf, "effectPos")
	arg0._effectFrPos = findTF(arg0._charTf, "effectFrPos")
	arg0._effectBkPos = findTF(arg0._charTf, "effectBkPos")
	arg0._powerSlider = arg4

	arg0._dftEvent:SetTriggerEvent(function()
		local var0
		local var1 = arg0._animator:GetCurrentAnimatorClipInfo(0)

		if var1 and var1.Length > 0 then
			var0 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.AnimatorClipInfo"), "clip", var1[0])
		end

		if var0 then
			arg0._event:emit(Fushun3GameEvent.add_anim_effect_call, {
				clipName = var0.name,
				targetTf = arg0._effectPos
			})
		end
	end)

	arg0._charItemCatchTf = findTF(arg0._effectPos, "charItem")
	arg0._charItemCatch = GetComponent(findTF(arg0._charItemCatchTf, "catch"), typeof(Animator))
	arg0._charShieldTf = findTF(arg0._effectPos, "shield")
	arg0._collisionInfo = arg3
	arg0._event = arg5
	arg0._animator = GetComponent(arg0._anim, typeof(Animator))
	arg0._powerScript = arg0._rectCollider:getScript(FuShunPowerSpeedScript)
	arg0._jumpScript = arg0._rectCollider:getScript(FuShunJumpScript)
	arg0._damageScript = arg0._rectCollider:getScript(FuShunDamageScript)
	arg0._attackScript = arg0._rectCollider:getScript(FuShunAttakeScript)
	arg0._monsterLayer = LayerMask.NameToLayer("Character")
	arg0._damageTf = findTF(arg0._charTf, "damage")
	arg0._damageCollider = GetComponent(arg0._damageTf, typeof(BoxCollider2D))
	arg0._attackCd = nil

	arg0._event:bind(Fushun3GameEvent.script_jump_event, function()
		if arg0._attackCd == 0 and arg0.damageCd == 0 and arg0._animator then
			arg0._animator:SetTrigger("jump")
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_JUMP)
		end
	end)
	arg0._event:bind(Fushun3GameEvent.script_attack_event, function()
		if arg0._attackCd == 0 and arg0.damageCd == 0 then
			arg0._animator:SetTrigger("attack")

			arg0._attackCd = Fushun3GameConst.attack_cd

			if arg0:getBuff(Fushun3GameConst.buff_weapon) then
				local var0 = math.random(1, 30) == 1 and "tamachan" or "rocket"

				arg0._event:emit(Fushun3GameEvent.create_item_call, {
					name = var0,
					pos = arg0._itemPos.position
				})
				arg0._charItemCatch:SetTrigger("attack")
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_ATTACK)

				arg0._attackTime = Fushun3GameConst.attack_time
			end
		end
	end)
	arg0._event:bind(Fushun3GameEvent.script_power_event, function(arg0, arg1, arg2)
		arg0._animator:SetTrigger("ex")
		arg0._charItemCatch:SetTrigger("ex")
	end)

	arg0.damageCd = 0
	arg0.buffList = {}

	if Application.isEditor then
		if not arg0.handle then
			arg0.handle = UpdateBeat:CreateListener(function()
				if Input.GetKeyDown(KeyCode.Y) then
					local var0 = 1

					if arg0:getBuffById(Fushun3GameConst.buff_data[var0].id) then
						arg0:removeBuff(Clone(Fushun3GameConst.buff_data[var0]))
					else
						arg0:addBuff(Clone(Fushun3GameConst.buff_data[var0]))
					end
				elseif Input.GetKeyDown(KeyCode.U) then
					local var1 = 2
					local var2 = Fushun3GameConst.buff_data[var1]

					if arg0:getBuffById(var2.id) then
						arg0:removeBuff(Clone(Fushun3GameConst.buff_data[var1]))
					else
						arg0:addBuff(Clone(Fushun3GameConst.buff_data[var1]))
					end
				elseif Input.GetKeyDown(KeyCode.I) then
					local var3 = 4

					if arg0:getBuffById(Fushun3GameConst.buff_data[var3].id) then
						arg0:removeBuff(Clone(Fushun3GameConst.buff_data[var3]))
					else
						arg0:addBuff(Clone(Fushun3GameConst.buff_data[var3]))
					end
				elseif Input.GetKeyDown(KeyCode.O) then
					local var4 = 5

					arg0:addBuff(Clone(Fushun3GameConst.buff_data[var4]))
				end
			end, arg0)
		end

		UpdateBeat:AddListener(arg0.handle, arg0)
	end
end

function var0.start(arg0)
	arg0._animator:SetBool("la", false)
	arg0._animator:SetBool("s", false)
	arg0._animator:SetBool("below", arg0._collisionInfo.below)

	arg0._attackCd = Fushun3GameConst.attack_cd
	arg0._charTf.anchoredPosition = Fushun3GameConst.char_init_pos
	arg0.buffList = {}
	arg0._attackTime = 0
	arg0.power = 0
	arg0._powerTime = 0
	arg0.powerFlag = false
	arg0.shieldNum = 0

	arg0:updateBuffShow(Fushun3GameConst.buff_shield)

	arg0.heart = Fushun3GameConst.heart_num

	setActive(arg0._charItemCatchTf, false)
end

function var0.step(arg0)
	if arg0._charTf.anchoredPosition.y >= 1200 or arg0._charTf.anchoredPosition.y <= -200 then
		if arg0._powerTime > 0 then
			arg0._charTf.anchoredPosition = Vector2(arg0._charTf.anchoredPosition.x + 100, 1000)
		else
			arg0._event:emit(Fushun3GameEvent.game_over_call)
		end

		return
	end

	arg0._powerSlider.value = arg0.power / Fushun3GameConst.power_max_num

	arg0._animator:SetBool("below", arg0._collisionInfo.below)

	local var0 = arg0._collisionInfo:getVelocity()

	arg0._animator:SetFloat("moveAmountX", var0.x)
	arg0._animator:SetFloat("moveAmountY", var0.y)

	if arg0._attackCd > 0 then
		arg0._attackCd = arg0._attackCd - Time.deltaTime
		arg0._attackCd = arg0._attackCd < 0 and 0 or arg0._attackCd
	end

	if arg0._powerTime > 0 then
		arg0._powerTime = arg0._powerTime - Time.deltaTime

		if arg0._powerTime < 0 then
			arg0._powerTime = 0
		end
	end

	for iter0 = #arg0.buffList, 1, -1 do
		local var1 = arg0.buffList[iter0]

		if var1.time then
			var1.time = var1.time - Time.deltaTime

			if var1.time <= 0 then
				arg0:removeBuff(var1)
			end
		end
	end

	local var2 = {}

	for iter1, iter2 in pairs(arg0._collisionInfo.horizontalLeftTfs) do
		table.insert(var2, iter2)
	end

	for iter3, iter4 in pairs(arg0._collisionInfo.horizontalRightTfs) do
		table.insert(var2, iter4)
	end

	local var3 = {}

	for iter5, iter6 in pairs(arg0._collisionInfo.verticalBottomTfs) do
		table.insert(var3, iter6)
	end

	if #var2 > 0 then
		if arg0:getBuff(Fushun3GameConst.buff_power_speed) then
			for iter7 = 1, #var2 do
				if go(var2[iter7]).layer == arg0._monsterLayer then
					arg0._event:emit(Fushun3GameEvent.power_damage_monster_call, {
						tf = var2[iter7]
					})
				end
			end
		else
			for iter8 = 1, #var2 do
				if arg0._powerTime == 0 and go(var2[iter8]).layer == arg0._monsterLayer and arg0.damageCd == 0 then
					arg0._event:emit(Fushun3GameEvent.check_player_damage, {
						tf = var2[iter8],
						callback = function(arg0)
							if not arg0 then
								arg0:damageChar()
							end
						end
					})
				elseif findTF(var2[iter8], "high_roof") then
					setActive(findTF(var2[iter8], "high_roof"), false)
					arg0._collisionInfo:changeVelocity(0, arg0._collisionInfo.config.minJumpVelocity, nil)

					if arg0._powerTime == 0 and arg0.damageCd == 0 then
						arg0:damageChar()
					end
				end
			end
		end
	elseif var3 and #var3 > 0 then
		for iter9 = 1, #var3 do
			if go(var3[iter9]).layer == arg0._monsterLayer then
				if arg0:getBuff(Fushun3GameConst.buff_speed) then
					arg0._event:emit(Fushun3GameEvent.kick_damage_monster_call, {
						tf = var3[iter9],
						callback = function(arg0)
							if arg0 then
								arg0._collisionInfo:changeVelocity(nil, arg0._collisionInfo.config.minJumpVelocity, nil)
							end
						end
					})
				else
					arg0._event:emit(Fushun3GameEvent.check_player_damage, {
						tf = var2[iter9],
						callback = function(arg0)
							if not arg0 then
								arg0:damageChar()
							end
						end
					})
				end
			end
		end
	end

	arg0:flushBuff()

	if arg0.damageCd > 0 then
		arg0.damageCd = arg0.damageCd - Time.deltaTime
		arg0.damageCd = arg0.damageCd <= 0 and 0 or arg0.damageCd
	end

	if arg0._attackTime > 0 then
		arg0._event:emit(Fushun3GameEvent.player_attack_call, {
			collider = arg0._damageCollider,
			callback = function(arg0)
				if arg0 then
					arg0._event:emit(Fushun3GameEvent.add_effect_call, {
						effectName = "EF_fr_Attack",
						targetTf = arg0._effectPos
					})
				end
			end
		})

		arg0._attackTime = arg0._attackTime - Time.deltaTime
		arg0._attackTime = arg0._attackTime <= 0 and 0 or arg0._attackTime
	end

	if arg0.power == Fushun3GameConst.power_max_num and not arg0.powerFlag and arg0._charTf.anchoredPosition.y >= 200 then
		arg0.powerFlag = true

		arg0._event:emit(Fushun3GameEvent.power_speed_call)

		if not arg0.powerBuff then
			for iter10 = 1, #Fushun3GameConst.buff_data do
				if Fushun3GameConst.buff_data[iter10].buff == Fushun3GameConst.buff_power_speed then
					arg0.powerBuff = Clone(Fushun3GameConst.buff_data[iter10])
				end
			end
		end

		arg0:addBuff(Clone(arg0.powerBuff))
	end

	if arg0.powerFlag then
		arg0.power = arg0.power - Fushun3GameConst.power_sub_time * Time.deltaTime

		if arg0.power <= 0 then
			arg0.power = 0
			arg0.powerFlag = false

			arg0:removeBuff(Clone(arg0.powerBuff))
		end
	elseif arg0.power >= Fushun3GameConst.power_max_num then
		arg0.power = Fushun3GameConst.power_max_num
	end
end

function var0.jump(arg0)
	if arg0._jumpScript:checkScirptApply() then
		arg0._jumpScript:active(true)
	end
end

function var0.attack(arg0)
	if arg0._attackScript:checkScirptApply() then
		arg0._attackScript:active(true)
	end
end

function var0.damageChar(arg0)
	if arg0._damageScript:checkScirptApply() then
		arg0._damageScript:active(true)

		if arg0.damageCd == 0 then
			if arg0.shieldNum > 0 then
				arg0.shieldNum = arg0.shieldNum - 1

				arg0._animator:SetTrigger("damage")
				arg0:updateBuffShow(Fushun3GameConst.buff_shield)
				arg0._event:emit(Fushun3GameEvent.add_effect_call, {
					effectName = "EF_Barrier_Break",
					targetTf = arg0._effectPos
				})
			else
				arg0.heart = arg0.heart - 1

				if arg0.heart <= 0 then
					arg0.heart = 0
				end

				if arg0.heart == 0 then
					arg0._animator:SetTrigger("down")
				elseif #arg0.buffList > 0 then
					arg0:removeBuff(arg0.buffList[math.random(1, #arg0.buffList)], true)
					arg0._animator:SetTrigger("respawn")
				else
					arg0._animator:SetTrigger("damage")
				end
			end

			arg0.damageCd = Fushun3GameConst.damage_cd

			if arg0._attackTime > 0 then
				arg0._attackTime = 0
			end

			arg0._event:emit(Fushun3GameEvent.char_damaged_call)
		end
	end
end

function var0.addPower(arg0, arg1)
	if not arg0.powerFlag then
		arg0.power = arg0.power + arg1
	end
end

function var0.getBuff(arg0, arg1)
	for iter0 = 1, #arg0.buffList do
		if arg0.buffList[iter0].buff == arg1 then
			return arg0.buffList[iter0]
		end
	end

	return nil
end

function var0.getBuffById(arg0, arg1)
	for iter0 = 1, #arg0.buffList do
		if arg0.buffList[iter0].id == arg1 then
			return arg0.buffList[iter0]
		end
	end

	return nil
end

function var0.setBuff(arg0, arg1)
	local var0 = arg1.buff_id
	local var1

	for iter0 = 1, #Fushun3GameConst.buff_data do
		if Fushun3GameConst.buff_data[iter0].id == var0 then
			var1 = Fushun3GameConst.buff_data[iter0]
		end
	end

	if var1 then
		arg0:addBuff(Clone(var1))
	end
end

function var0.addBuff(arg0, arg1)
	for iter0 = 1, #arg0.buffList do
		if arg0.buffList[iter0].id == arg1.id then
			if arg1.buff == Fushun3GameConst.buff_shield then
				if arg0.shieldNum == var1 then
					return
				end
			else
				return
			end
		end
	end

	local var0 = arg0:getItemTriggerFlag()

	if arg1.buff == Fushun3GameConst.buff_speed then
		arg0._animator:SetBool("s", true)

		arg0._collisionInfo.config.moveSpeed = Fushun3GameConst.move_speed_shoose

		if not var0 then
			arg0._animator:SetTrigger("item")
		end
	elseif arg1.buff == Fushun3GameConst.buff_power_speed then
		if arg0._powerScript:checkScirptApply() then
			arg0._powerScript:active(true)
			arg0._animator:SetTrigger("ex_on")
			arg0._charItemCatch:SetTrigger("ex_on")
		end
	elseif arg1.buff == Fushun3GameConst.buff_weapon then
		arg0._animator:SetBool("la", true)

		if not var0 then
			arg0._animator:SetTrigger("item")
		end
	elseif arg1.buff == Fushun3GameConst.buff_catch then
		setActive(arg0._charItemCatchTf, true)
		arg0._charItemCatch:SetTrigger("ride")
	elseif arg1.buff == Fushun3GameConst.buff_shield then
		arg0.shieldNum = arg0.shieldNum + 1

		if arg0.shieldNum > var1 then
			arg0.shieldNum = var1
		end

		arg0:updateBuffShow(Fushun3GameConst.buff_shield)
		arg0._event:emit(Fushun3GameEvent.add_effect_call, {
			effectName = "EF_Barrier_Get",
			targetTf = arg0._effectPos
		})
	end

	table.insert(arg0.buffList, arg1)
end

function var0.updateBuffShow(arg0, arg1)
	if arg1 == Fushun3GameConst.buff_shield then
		for iter0 = 1, var1 do
			local var0 = iter0
			local var1 = findTF(arg0._charShieldTf, tostring(var0))

			setActive(var1, var0 <= arg0.shieldNum)
			setActive(findTF(arg0._effectFrPos, "Barrier/" .. tostring(var0)), arg0.shieldNum == var0)
			setActive(findTF(arg0._effectBkPos, "Barrier/" .. tostring(var0)), arg0.shieldNum == var0)
		end

		setActive(arg0._charShieldTf, false)
		setActive(arg0._charShieldTf, true)
	end
end

function var0.removeBuff(arg0, arg1, arg2)
	for iter0 = 1, #arg0.buffList do
		local var0 = arg0.buffList[iter0]

		if var0.buff == arg1.buff then
			local var1 = arg0:getItemTriggerFlag()

			if var0.buff == Fushun3GameConst.buff_speed then
				arg0._animator:SetBool("s", false)

				arg0._collisionInfo.config.moveSpeed = Fushun3GameConst.move_speed

				if not var1 and not arg2 then
					arg0._animator:SetTrigger("item")
				end
			elseif var0.buff == Fushun3GameConst.buff_power_speed then
				arg0._powerScript:active(false)
				arg0._animator:SetTrigger("ex_off")
				arg0._charItemCatch:SetTrigger("ex_off")

				arg0._powerTime = Fushun3GameConst.power_time
			elseif var0.buff == Fushun3GameConst.buff_weapon then
				arg0._animator:SetBool("la", false)

				if not var1 and not arg2 then
					arg0._animator:SetTrigger("item")
				end
			elseif var0.buff == Fushun3GameConst.buff_catch then
				setActive(arg0._charItemCatchTf, false)
			end

			table.remove(arg0.buffList, iter0)

			return
		end
	end
end

function var0.flushBuff(arg0)
	for iter0 = 1, #arg0.buffList do
		local var0 = arg0.buffList[iter0]

		if var0.buff == Fushun3GameConst.buff_speed then
			-- block empty
		elseif var0.buff == Fushun3GameConst.buff_power_speed then
			-- block empty
		elseif var0.buff == Fushun3GameConst.buff_weapon then
			-- block empty
		elseif var0.buff == Fushun3GameConst.buff_catch then
			local var1 = arg0._charTf.anchoredPosition

			var1.y = var1.y + arg0._itemPos.anchoredPosition.y

			arg0._event:emit(Fushun3GameEvent.item_follow_call, {
				anchoredPos = var1
			})
		end
	end
end

function var0.getHeart(arg0)
	return arg0.heart
end

function var0.getItemTriggerFlag(arg0)
	for iter0 = 1, #arg0.buffList do
		if arg0.buffList[iter0].lock_item then
			return true
		end
	end

	return false
end

function var0.dispose(arg0)
	if Application.isEditor then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end
end

return var0
