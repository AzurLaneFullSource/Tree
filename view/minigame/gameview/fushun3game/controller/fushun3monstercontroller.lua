local var0_0 = class("Fushun3MonsterController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._tpl = arg1_1
	arg0_1._parent = arg2_1
	arg0_1._event = arg4_1
	arg0_1._sceneTf = arg3_1
	arg0_1.monsterDatas = {}

	for iter0_1 = 1, #Fushun3GameConst.monster_data do
		table.insert(arg0_1.monsterDatas, Clone(Fushun3GameConst.monster_data[iter0_1]))
	end

	arg0_1.monsters = {}
	arg0_1.monsterPool = {}
end

function var0_0.setDiff(arg0_2, arg1_2)
	return
end

function var0_0.start(arg0_3)
	arg0_3:clearMonster()
end

function var0_0.step(arg0_4)
	for iter0_4 = 1, #arg0_4.monsters do
		if not arg0_4.monsters[iter0_4].damage then
			arg0_4.monsters[iter0_4].rect:step()
		end
	end

	arg0_4:removeOutMonster()
end

function var0_0.removeOutMonster(arg0_5)
	for iter0_5 = #arg0_5.monsters, 1, -1 do
		if arg0_5.monsters[iter0_5].tf.anchoredPosition.x <= math.abs(arg0_5._sceneTf.anchoredPosition.x) - 1920 then
			arg0_5:returnMonsterToPool(table.remove(arg0_5.monsters, iter0_5))
		end
	end
end

function var0_0.createMonster(arg0_6, arg1_6)
	local var0_6 = arg0_6.monsterDatas[math.random(1, #arg0_6.monsterDatas)]
	local var1_6 = arg0_6:getOrCreateMonster(var0_6.id)

	if var1_6 then
		var1_6.damage = false

		setActive(var1_6.tf, true)

		var1_6.tf.position = arg1_6
	end
end

function var0_0.getOrCreateMonster(arg0_7, arg1_7)
	local var0_7

	for iter0_7 = 1, #arg0_7.monsterPool do
		if arg0_7.monsterPool[iter0_7].data.id == arg1_7 then
			var0_7 = table.remove(arg0_7.monsterPool, iter0_7)

			table.insert(arg0_7.monsters, var0_7)

			return var0_7
		end
	end

	local var1_7

	for iter1_7 = 1, #arg0_7.monsterDatas do
		if arg0_7.monsterDatas[iter1_7].id == arg1_7 then
			var1_7 = arg0_7.monsterDatas[iter1_7]
		end
	end

	if var1_7 then
		local var2_7 = var1_7.name
		local var3_7 = tf(instantiate(findTF(arg0_7._tpl, var2_7)))

		var3_7.localScale = Fushun3GameConst.game_scale_v3

		local var4_7 = RectCollider.New(var3_7, {}, arg0_7._event)

		var4_7:addScript(FuShunMonsterScript.New())

		var4_7:getCollisionInfo().config.moveSpeed = math.random(Fushun3GameConst.monster_speed[1], Fushun3GameConst.monster_speed[2])

		local var5_7 = GetComponent(findTF(var3_7, "anim"), typeof(Animator))

		setParent(var3_7, arg0_7._parent)

		local var6_7 = GetComponent(findTF(var3_7, "collider"), typeof(BoxCollider2D))

		var0_7 = {
			tf = var3_7,
			data = var1_7,
			rect = var4_7,
			animator = var5_7,
			collider = var6_7
		}

		GetComponent(findTF(var3_7, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			arg0_7:removeMonster(var0_7)
		end)
		table.insert(arg0_7.monsters, var0_7)
	end

	return var0_7
end

function var0_0.checkPlayerDamage(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #arg0_9.monsters do
		local var0_9 = arg0_9.monsters[iter0_9]

		if var0_9.tf == arg1_9 and var0_9.damage then
			arg2_9(true)

			return
		end
	end

	arg2_9(false)
end

function var0_0.checkMonsterDamage(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg1_10.bounds

	for iter0_10 = 1, #arg0_10.monsters do
		local var1_10 = arg0_10.monsters[iter0_10]
		local var2_10 = var1_10.collider.bounds

		if not var1_10.damage and Fushun3GameConst.CheckBoxCollider(var0_10.min, var2_10.min, var0_10.size, var2_10.size) then
			arg0_10:damageMonster(var1_10.tf, arg3_10)

			if arg2_10 then
				arg2_10(true)
			end

			return
		end
	end

	if arg2_10 then
		arg2_10(false)
	end
end

function var0_0.damageMonster(arg0_11, arg1_11, arg2_11, arg3_11)
	for iter0_11 = #arg0_11.monsters, 1, -1 do
		if arg0_11.monsters[iter0_11].tf == arg1_11 then
			local var0_11 = arg0_11.monsters[iter0_11]

			if not var0_11.damage then
				var0_11.damage = true

				if arg2_11 == Fushun3GameEvent.power_damage_monster_call then
					var0_11.animator:SetTrigger("dmg_ex")
				elseif arg2_11 == Fushun3GameEvent.shot_damage_monster_call then
					var0_11.animator:SetTrigger("dmg_la")
				elseif arg2_11 == Fushun3GameEvent.kick_damage_monster_call then
					var0_11.animator:SetTrigger("dmg_jump")
				elseif arg2_11 == Fushun3GameEvent.attack_damdage_monster_call then
					var0_11.animator:SetTrigger("dmg_attack")
				end

				arg0_11._event:emit(Fushun3GameEvent.add_monster_score_call)

				if arg3_11 then
					arg3_11(true)
				end
			end

			return
		end
	end

	if arg3_11 then
		arg3_11(false)
	end
end

function var0_0.removeMonster(arg0_12, arg1_12)
	for iter0_12 = 1, #arg0_12.monsters do
		if arg0_12.monsters[iter0_12] == arg1_12 then
			arg0_12:returnMonsterToPool(table.remove(arg0_12.monsters, iter0_12))

			return
		end
	end
end

function var0_0.returnMonsterToPool(arg0_13, arg1_13)
	setActive(arg1_13.tf, false)
	table.insert(arg0_13.monsterPool, arg1_13)
end

function var0_0.clearMonster(arg0_14)
	for iter0_14 = #arg0_14.monsters, 1, -1 do
		arg0_14:returnMonsterToPool(table.remove(arg0_14.monsters, iter0_14))
	end
end

return var0_0
